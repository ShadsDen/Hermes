# Hermes Multi gateway agents project
  AKA..  Hermes MGAP project

Project Based on Ubuntu LTS and Debian Headless VM servers

Project files and code goals
  This is my personal project and progress to create and optimise a dynamic and efficient use of GPU resources.
  For any GPU including the Nvidia Tesla V100 PCIe and SXM2 models.
  Modular design to prevent complete failure minimising risk in experimental environment.
  Tools and scripts for creation and workarounds to help duplication of project.
  Utilize secured WebUI tools to allow for access from any device.

1) Parent and VM dependencies and install scripts.
  Cuda Drivers and tools.
    apt version locking for Tesla V100
         CUDA 12.8 - Nvidia 570 [working]
         CUDA 13.0 - Nvidia 580 [working] (experimental)
         CUDA 13.3 - Nvidia 595 [working] (custom dev build: lost my notes so will take time before I remake instructions)
  
3) Dual Hermes VMs with primary/Parent VM to manage and create Child agents as required.
  Hermes-Webui (Parent WebUI)
  Dashboard (Multi agent API gateways)
  
5) PostgreSQL Local Server (dedicated VM)
    with PGadmin4 (WebUI).

6) Hindsight Local External (dedicated VM)
  Control Plane (WebUI).
  
7) LLM Hosts on Parent Server.
  a) Ollama
  b) Llama.cp
  c) VM Studio
  d) vLLM

9) Agent to agent API scripts.

10) Completed instruction and script to rebuild from scratch.
