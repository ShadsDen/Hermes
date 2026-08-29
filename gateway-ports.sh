#!/usr/bin/env bash
set -euo pipefail

for unit in $(systemctl --user list-unit-files 'hermes-gateway-*.service' --no-legend | awk '{print $1}'); do
    profile="${unit#hermes-gateway-}"
    profile="${profile%.service}"

    port=$(systemctl --user show "$unit" -p Environment --value |
        tr ' ' '\n' |
        sed -n 's/^API_SERVER_PORT=//p')

    printf '%-30s API_PORT=%s\n' "$profile" "${port:-8642}"
done
