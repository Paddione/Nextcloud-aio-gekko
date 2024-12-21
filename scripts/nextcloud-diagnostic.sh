#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to check test results
check_result() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $1${NC}"
    else
        echo -e "${RED}✗ $1${NC}"
        echo -e "${RED}  $2${NC}"
    fi
}

echo -e "${YELLOW}=== Detailed Network Diagnostics ===${NC}"

# Test direct IP connectivity
echo -e "\nTesting direct IP connectivity..."
docker exec nginx-proxy-manager ping -c 1 172.18.0.2
check_result "Ping to Nextcloud container IP (172.18.0.2)" "Check if container networking is blocked by firewall rules"

# Test DNS resolution
echo -e "\nTesting DNS resolution..."
docker exec nginx-proxy-manager getent hosts nextcloud-aio-mastercontainer
check_result "DNS resolution of Nextcloud container name" "Verify Docker's built-in DNS is functioning"

# Test HTTP connectivity
echo -e "\nTesting HTTP connectivity to Nextcloud..."
docker exec nginx-proxy-manager curl -I http://172.18.0.2:11000 2>/dev/null
check_result "HTTP connection to Nextcloud" "Verify Nextcloud is listening on port 11000"

# Test proxy configuration
echo -e "\nTesting Nginx configuration..."
docker exec nginx-proxy-manager curl -I http://localhost:80 2>/dev/null
check_result "Nginx Proxy Manager is listening on port 80" "Check Nginx configuration"

# Display Nginx Proxy Manager logs
echo -e "\n${YELLOW}=== Recent Nginx Proxy Manager Logs ===${NC}"
docker logs --tail 10 nginx-proxy-manager

# Display current proxy configurations
echo -e "\n${YELLOW}=== Nginx Proxy Manager Configurations ===${NC}"
docker exec nginx-proxy-manager find /data/nginx/proxy_host -type f -name "*.conf" -exec cat {} \;

echo -e "\n${YELLOW}=== Network Route Table ===${NC}"
docker exec nginx-proxy-manager ip route

echo -e "\n${YELLOW}=== Connection Tracking ===${NC}"
docker exec nginx-proxy-manager conntrack -L 2>/dev/null || echo "conntrack not installed"