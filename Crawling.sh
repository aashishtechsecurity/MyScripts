#!/bin/bash

echo "

░█████╗░██████╗░░█████╗░░██╗░░░░░░░██╗██╗░░░░░██╗███╗░░██╗░██████╗░
██╔══██╗██╔══██╗██╔══██╗░██║░░██╗░░██║██║░░░░░██║████╗░██║██╔════╝░
██║░░╚═╝██████╔╝███████║░╚██╗████╗██╔╝██║░░░░░██║██╔██╗██║██║░░██╗░
██║░░██╗██╔══██╗██╔══██║░░████╔═████║░██║░░░░░██║██║╚████║██║░░╚██╗
╚█████╔╝██║░░██║██║░░██║░░╚██╔╝░╚██╔╝░███████╗██║██║░╚███║╚██████╔╝
░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚══════╝╚═╝╚═╝░░╚══╝░╚═════╝░
        Author   : Aashish💕💕  
                                              
        Github   : https://github.com/aashish36

"

echo "Tool Started at:" $(date +"%d-%m-%Y %I:%M %p")

# Check if a domain is provided as a command-line argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Extract the domain from the command-line argument
domain="$1"

# Create a directory to store the results
output_dir="crawling_info"
mkdir -p $output_dir

echo "[*] Processing domain: $domain"

# Run Waybackurls
echo "    Running Waybackurls..."
echo "$domain" | /home/jaisriram/go/bin/waybackurls $domain > $output_dir/waybackurls_$domain.txt

# Run Gau
echo "    Running Gau..."
echo "$domain" | /home/jaisriram/go/bin/gau  > $output_dir/gau_$domain.txt

# Run Hakrawler
echo "    Running Hakrawler..."
echo "https://$domain" | hakrawler -d 10 > $output_dir/hakrawler_$domain.txt

# Run Katana
echo "    Running Katana..."
katana -u $domain -o $output_dir/katana_$domain.txt

# Run WayMore
echo "    Running WayMore..."
python3 /home/jaisriram/tools/waymore/waymore.py -i $domain -mode U -oU $output_dir/waymore_$domain.txt

echo "[+] Domain $domain completed."

cd $output_dir

# Combine and sort all unique URLs
echo "    Combine and sort all unique URLs..."
cat * | sort -u | tee ./unique-crawling.txt

echo "[+] Saved the Unique URLs"

echo "[+] Web information gathering completed. Results saved in $output_dir."

echo "Tool Ended at:" $(date +"%d-%m-%Y %I:%M %p")
