#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1
OUTPUT_DIR="./output"

# Create output directory if not exists
mkdir -p $OUTPUT_DIR

WAYBACK_URL="https://web.archive.org/cdx/search/cdx?url=${DOMAIN}&collapse=domain&fl=timestamp,original,mimetype,statuscode,digest"
CCRAWL_INDEX_URL="https://index.commoncrawl.org/collinfo.json"
ALIENVAULT_URL="https://otx.alienvault.com/api/v1/indicators/domain/${DOMAIN}/url_list?limit=500"
URLSCAN_URL="https://urlscan.io/api/v1/search/?q=domain:${DOMAIN}&size=10000"
VIRUSTOTAL_URL="https://www.virustotal.com/vtapi/v2/domain/report?apikey={APIKEY}&domain=${DOMAIN}"

# User Agents to use when making requests, chosen at random
USER_AGENT=(
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15"
    "Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36 Edg/99.0.1150.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101 Firefox/67.0"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0"
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36"
    "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
    "Mozilla/5.0 (X11; CrOS x86_64 8172.45.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.64 Safari/537.36"
    "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)"
    "Mozilla/5.0 (iPad; CPU OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53"
    "Mozilla/5.0 (iPhone; CPU iPhone OS 8_4_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12H321 Safari/600.1.4"
)


# Function to make requests to URLs and save output
make_request() {
    URL=$1
    FILENAME="${OUTPUT_DIR}/$(basename $URL | tr -d '?&=')_output.txt"
    USER_AGENT_RANDOM=${USER_AGENT[$RANDOM % ${#USER_AGENT[@]}]}
    
    curl -A "$USER_AGENT_RANDOM" "$URL" -o "$FILENAME"
    echo "[$(date)] Requested $URL with User-Agent: $USER_AGENT_RANDOM"
}

# Function to process URLs and replace word after '=' with 'FUZZ'
process_urls() {
    INPUT_FILE="${OUTPUT_DIR}/sorted_output.txt"
    OUTPUT_FILE="${OUTPUT_DIR}/processed_output.txt"
    
    while IFS= read -r url; do
        # Check if '=' is present in the URL
        if [[ $url == *"="* ]]; then
            # Replace the word after '=' with 'FUZZ'
            modified_url=$(echo "$url" | sed 's/=\([^&]*\)/=FUZZ/')
            echo "$modified_url" >> "$OUTPUT_FILE"
        else
            echo "$url" >> "$OUTPUT_FILE"
        fi
    done < "$INPUT_FILE"
}

# Make requests to URLs with random headers
make_request "$WAYBACK_URL"
make_request "$CCRAWL_INDEX_URL"
make_request "$ALIENVAULT_URL"
make_request "$URLSCAN_URL"
make_request "$VIRUSTOTAL_URL"

# Concatenate and sort the output files
cat ${OUTPUT_DIR}/* | sort > "${OUTPUT_DIR}/sorted_output.txt"

# Process URLs and replace word after '=' with 'FUZZ'
process_urls

# Delete the individual URL files
rm -f ${OUTPUT_DIR}/*.txt

echo "Processed output saved to ${OUTPUT_DIR}/processed_output.txt"
