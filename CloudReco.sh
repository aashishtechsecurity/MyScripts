#!/bin/bash

# Create a directory
echo "Creating directory: cloudrecon"
mkdir /home/jaisriram/cloudrecon

# Change to the directory
echo "Changing to directory: cloudrecon"
cd /home/jaisriram/cloudrecon

# Function to download and process SNI IP ranges
download_and_process() {
    echo "Downloading SNI IP range from: $1"
    curl -O "$1"
    echo "Copying to: $2"
    cp ipv4_merged_sni.txt "$2"
    echo "Removing temporary file: ipv4_merged_sni.txt"
    rm -rf ipv4_merged_sni.txt
}

# Download and process DigitalOcean SNI IP range
download_and_process "https://kaeferjaeger.gay/sni-ip-ranges/digitalocean/ipv4_merged_sni.txt" "digitalocean.txt"

# Download and process Google SNI IP range
download_and_process "https://kaeferjaeger.gay/sni-ip-ranges/google/ipv4_merged_sni.txt" "google.txt"

# Download and process Microsoft SNI IP range
download_and_process "https://kaeferjaeger.gay/sni-ip-ranges/microsoft/ipv4_merged_sni.txt" "microsoft.txt"

# Download and process Oracle SNI IP range
download_and_process "https://kaeferjaeger.gay/sni-ip-ranges/oracle/ipv4_merged_sni.txt" "oracle.txt"

# Download and process Amazon SNI IP range
download_and_process "https://kaeferjaeger.gay/sni-ip-ranges/amazon/ipv4_merged_sni.txt" "amazon.txt"
