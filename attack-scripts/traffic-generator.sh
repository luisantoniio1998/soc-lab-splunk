#!/bin/bash

# Traffic Generator for SOC Lab
# Generates realistic web traffic patterns

WEB_TARGET="http://webserver"

echo "===== Traffic Generator Starting ====="

# Function to generate random traffic
generate_normal_traffic() {
    local pages=("/" "/api" "/about" "/contact" "/products" "/services" "/blog" "/docs")
    local user_agents=(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36"
        "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)"
    )
    
    for i in {1..20}; do
        page=${pages[$RANDOM % ${#pages[@]}]}
        ua=${user_agents[$RANDOM % ${#user_agents[@]}]}
        
        curl -s -A "$ua" "$WEB_TARGET$page" > /dev/null
        
        # Random delay between requests (0.5 to 3 seconds)
        sleep $(awk -v min=0.5 -v max=3 'BEGIN{srand(); print min+rand()*(max-min)}')
    done
}

# Function to simulate business hours traffic
generate_business_hours() {
    echo "[+] Simulating business hours traffic pattern..."
    
    for i in {1..30}; do
        generate_normal_traffic &
    done
    
    wait
    echo "[✓] Business hours simulation complete"
}

# Function to simulate download activity
generate_download_activity() {
    echo "[+] Simulating file downloads..."
    
    local files=("report.pdf" "data.csv" "image.jpg" "document.docx")
    
    for file in "${files[@]}"; do
        curl -s "$WEB_TARGET/downloads/$file" > /dev/null
        sleep 1
    done
    
    echo "[✓] Download activity complete"
}

# Function to simulate API usage
generate_api_traffic() {
    echo "[+] Simulating API traffic..."
    
    local endpoints=("users" "orders" "products" "analytics" "reports")
    
    for endpoint in "${endpoints[@]}"; do
        # GET requests
        curl -s -X GET "$WEB_TARGET/api/$endpoint" > /dev/null
        
        # POST requests
        curl -s -X POST "$WEB_TARGET/api/$endpoint" \
            -H "Content-Type: application/json" \
            -d '{"key":"value"}' > /dev/null
        
        sleep 0.5
    done
    
    echo "[✓] API traffic complete"
}

# Function to simulate search queries
generate_search_traffic() {
    echo "[+] Simulating search queries..."
    
    local queries=("product" "service" "help" "support" "contact" "pricing" "documentation")
    
    for query in "${queries[@]}"; do
        curl -s "$WEB_TARGET/search?q=$query" > /dev/null
        sleep 1
    done
    
    echo "[✓] Search traffic complete"
}

# Main execution
echo ""
echo "Select traffic type:"
echo "1) Normal traffic (20 requests)"
echo "2) Business hours simulation (high volume)"
echo "3) Download activity"
echo "4) API traffic"
echo "5) Search queries"
echo "6) All of the above"
echo "7) Continuous (runs until stopped)"
echo ""
read -p "Enter choice [1-7]: " choice

case $choice in
    1)
        generate_normal_traffic
        ;;
    2)
        generate_business_hours
        ;;
    3)
        generate_download_activity
        ;;
    4)
        generate_api_traffic
        ;;
    5)
        generate_search_traffic
        ;;
    6)
        generate_normal_traffic
        generate_download_activity
        generate_api_traffic
        generate_search_traffic
        ;;
    7)
        echo "[*] Running continuous traffic generation (Ctrl+C to stop)..."
        while true; do
            generate_normal_traffic
            sleep 5
        done
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "===== Traffic Generation Complete ====="
