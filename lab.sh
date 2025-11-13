#!/bin/bash

# SOC Lab Startup Script
# This script helps you start, stop, and manage your SOC lab

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║         SOC Lab with Splunk - Manager             ║"
    echo "║       Production Environment Simulation           ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}[!] Docker is not installed. Please install Docker Desktop.${NC}"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        echo -e "${RED}[!] Docker is not running. Please start Docker Desktop.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[✓] Docker is running${NC}"
}

start_lab() {
    echo -e "${YELLOW}[*] Starting SOC Lab...${NC}"
    docker-compose up -d
    
    echo ""
    echo -e "${YELLOW}[*] Waiting for Splunk to initialize (this may take 2-3 minutes)...${NC}"
    echo -e "${YELLOW}[*] You can monitor progress with: docker logs -f splunk-enterprise${NC}"
    
    sleep 5
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Lab is Starting!                     ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}📊 Splunk Web UI:${NC} http://localhost:8000"
    echo -e "${GREEN}👤 Username:${NC} admin"
    echo -e "${GREEN}🔑 Password:${NC} ChangeMe123!"
    echo ""
    echo -e "${GREEN}🌐 Web Server:${NC} http://localhost:8080"
    echo ""
    echo -e "${YELLOW}💡 Tip: Wait for Splunk to fully start before logging in${NC}"
    echo -e "${YELLOW}Check status with: docker logs -f splunk-enterprise${NC}"
    echo ""
}

stop_lab() {
    echo -e "${YELLOW}[*] Stopping SOC Lab...${NC}"
    docker-compose down
    echo -e "${GREEN}[✓] Lab stopped${NC}"
}

restart_lab() {
    echo -e "${YELLOW}[*] Restarting SOC Lab...${NC}"
    docker-compose restart
    echo -e "${GREEN}[✓] Lab restarted${NC}"
}

status_lab() {
    echo -e "${YELLOW}[*] Lab Status:${NC}"
    echo ""
    docker-compose ps
    echo ""
    echo -e "${YELLOW}[*] Resource Usage:${NC}"
    docker stats --no-stream
}

logs_lab() {
    echo -e "${YELLOW}[*] Showing logs (Ctrl+C to exit):${NC}"
    docker-compose logs -f
}

run_attacks() {
    echo -e "${YELLOW}[*] Running attack simulations...${NC}"
    echo ""
    echo -e "${GREEN}[1/2] Running web attacks...${NC}"
    docker exec -it kali-attacker bash -c "cd /root/scripts && ./web-attacks.sh"
    echo ""
    echo -e "${GREEN}[2/2] Running network scans...${NC}"
    docker exec -it kali-attacker bash -c "cd /root/scripts && ./network-scan.sh"
    echo ""
    echo -e "${GREEN}[✓] Attack simulations complete!${NC}"
    echo -e "${YELLOW}💡 Check Splunk for generated events${NC}"
}

open_splunk() {
    echo -e "${GREEN}[*] Opening Splunk in browser...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open http://localhost:8000
    else
        xdg-open http://localhost:8000 2>/dev/null || echo "Please open http://localhost:8000 in your browser"
    fi
}

shell_kali() {
    echo -e "${GREEN}[*] Opening Kali Linux shell...${NC}"
    docker exec -it kali-attacker bash
}

cleanup_lab() {
    echo -e "${RED}[!] This will remove all containers and volumes (data will be lost)${NC}"
    read -p "Are you sure? (yes/no): " -r
    if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        echo -e "${YELLOW}[*] Cleaning up...${NC}"
        docker-compose down -v
        echo -e "${GREEN}[✓] Cleanup complete${NC}"
    else
        echo -e "${YELLOW}[*] Cancelled${NC}"
    fi
}

show_help() {
    echo "Usage: ./lab.sh [command]"
    echo ""
    echo "Commands:"
    echo "  start       Start the SOC lab"
    echo "  stop        Stop the SOC lab"
    echo "  restart     Restart all containers"
    echo "  status      Show container status"
    echo "  logs        Show container logs"
    echo "  attacks     Run attack simulations"
    echo "  open        Open Splunk in browser"
    echo "  kali        Open Kali Linux shell"
    echo "  cleanup     Remove all containers and data"
    echo "  help        Show this help message"
    echo ""
}

# Main script
print_banner
check_docker

case "$1" in
    start)
        start_lab
        ;;
    stop)
        stop_lab
        ;;
    restart)
        restart_lab
        ;;
    status)
        status_lab
        ;;
    logs)
        logs_lab
        ;;
    attacks)
        run_attacks
        ;;
    open)
        open_splunk
        ;;
    kali)
        shell_kali
        ;;
    cleanup)
        cleanup_lab
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        show_help
        ;;
esac
