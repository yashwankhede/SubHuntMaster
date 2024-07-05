#!/bin/bash

# Check for required tools
for tool in host dig curl jq; do
    if ! command -v $tool &> /dev/null; then
        echo "$tool is required but not installed. Please install it and try again."
        exit 1
    fi
done

# Check if domain is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1
OUTPUT_FILE="subdomains_${DOMAIN}.txt"

# Function to perform DNS enumeration
dns_enum() {
    echo "Performing DNS enumeration..."
    for type in A AAAA CNAME MX NS; do
        dig +nocmd $DOMAIN $type +noall +answer | awk '{print $1}' | sed 's/\.$//' >> $OUTPUT_FILE
    done
}

# Function to perform web scraping
web_scrape() {
    echo "Performing web scraping..."
    curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> $OUTPUT_FILE
    curl -s "https://www.google.com/search?q=site:$DOMAIN" | grep -oP '(?<=\/\/)[^\/]*?\.'$DOMAIN | sort -u >> $OUTPUT_FILE
}

# Function to use certificate transparency logs
cert_transparency() {
    echo "Checking certificate transparency logs..."
    curl -s "https://certspotter.com/api/v1/issuances?domain=$DOMAIN&include_subdomains=true&expand=dns_names" | jq -r '.[].dns_names[]' | sort -u >> $OUTPUT_FILE
}

# Function to resolve and verify subdomains
resolve_subdomains() {
    echo "Resolving and verifying discovered subdomains..."
    local temp_file="temp_subdomains.txt"
    sort -u $OUTPUT_FILE > $temp_file
    > $OUTPUT_FILE
    while IFS= read -r subdomain; do
        if host "$subdomain" &>/dev/null; then
            echo "$subdomain" >> $OUTPUT_FILE
            ip=$(dig +short "$subdomain" | grep -E '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' | head -n 1)
            if [ -n "$ip" ]; then
                echo "  $subdomain - $ip"
            else
                echo "  $subdomain"
            fi
        fi
    done < $temp_file
    rm $temp_file
}

# Main execution
echo "Starting subdomain enumeration for $DOMAIN"
echo "----------------------------------------"

dns_enum
web_scrape
cert_transparency
resolve_subdomains

total=$(wc -l < $OUTPUT_FILE)
echo "----------------------------------------"
echo "Enumeration complete. Found $total unique subdomains."
echo "Results saved in $OUTPUT_FILE"
