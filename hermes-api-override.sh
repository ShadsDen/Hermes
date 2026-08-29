#!/usr/bin/env bash
set -euo pipefail

echo "========================================"
echo " Hermes API Server Override"
echo "========================================"
echo

mapfile -t SERVICES < <(
    systemctl --user list-unit-files 'hermes-gateway-*.service' \
        --no-legend 2>/dev/null |
        awk '{print $1}' |
        sort
)

if [[ ${#SERVICES[@]} -eq 0 ]]; then
    echo "No Hermes gateway services found."
    exit 1
fi

echo "Installed Hermes gateways:"
echo

for i in "${!SERVICES[@]}"; do
    service="${SERVICES[$i]}"
    profile="${service#hermes-gateway-}"
    profile="${profile%.service}"

    printf "  %d) %s\n" "$((i + 1))" "$profile"
done

echo
read -rp "Select profile number: " selection

if ! [[ "$selection" =~ ^[0-9]+$ ]] ||
   (( selection < 1 || selection > ${#SERVICES[@]} )); then
    echo "Invalid selection."
    exit 1
fi

service="${SERVICES[$((selection - 1))]}"
profile="${service#hermes-gateway-}"
profile="${profile%.service}"

echo
echo "Selected profile: $profile"
echo

read -rp "API server port: " port

if ! [[ "$port" =~ ^[0-9]+$ ]] ||
   (( port < 1 || port > 65535 )); then
    echo "Invalid port."
    exit 1
fi

echo
echo "API server host:"
echo "  1) Local  (127.0.0.1)"
echo "  2) Open   (0.0.0.0)"
echo
read -rp "Select host [1]: " host_selection
host_selection="${host_selection:-1}"

case "$host_selection" in
    1)
        api_host="127.0.0.1"
        ;;
    2)
        api_host="0.0.0.0"
        ;;
    *)
        echo "Invalid host selection."
        exit 1
        ;;
esac

echo
echo "Selected host: $api_host"
echo

read -rsp "API server key: " api_key
echo

if [[ ${#api_key} -lt 16 ]]; then
    echo "ERROR: API_SERVER_KEY must be at least 16 characters."
    exit 1
fi

override_dir="$HOME/.config/systemd/user/${service}.d"
override_file="$override_dir/override.conf"

mkdir -p "$override_dir"

cat > "$override_file" <<EOF2
[Service]
Environment="API_SERVER_ENABLED=true"
Environment="API_SERVER_KEY=${api_key}"
Environment="API_SERVER_PORT=${port}"
Environment="API_SERVER_HOST=${api_host}"
EOF2

echo
echo "Override installed:"
echo "  $override_file"
echo

systemctl --user daemon-reload

echo "Restarting $service..."
systemctl --user restart "$service"

sleep 2

echo
echo "========================================"
echo " Verification"
echo "========================================"
echo

echo "Systemd environment:"
systemctl --user show "$service" -p Environment

echo
echo "Listening socket:"
ss -ltnp | grep -E ":${port}([[:space:]]|$)" || {
    echo "WARNING: Nothing is currently listening on port $port"
}

echo
echo "Service status:"
systemctl --user --no-pager --full status "$service" | head -20

echo
echo "Done."
