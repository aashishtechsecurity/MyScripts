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

echo "[*] Tool Started at:" $(date +"%d-%m-%Y %I:%M %p")

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <domain> <listfile>"
    exit 1
fi

# Extract the domain and listfile from the command-line arguments
domain="$1"
listfile="$2"


# Create a directory to store the results
output_dir="crawling"

mkdir -p $output_dir

echo "[*] Processing Domain: $domain"
echo "[*] Processing List File: $listfile"


# Run Waybackurls
echo "[*] Running Waybackurls..."
cat $listfile | /home/jaisriram/go/bin/waybackurls $domain > $output_dir/waybackurls_$domain.txt

# Run Gau
echo "[*] Running Gau..."
cat $listfile  | /home/jaisriram/go/bin/gau  > $output_dir/gau_$domain.txt

# Run Hakrawler
echo "[*] Running Hakrawler..."
echo "https://$domain" | hakrawler -d 10 > $output_dir/hakrawler_$domain.txt

# Run Katana
echo "[*] Running Katana..."
katana -list $listfile -o $output_dir/katana_$domain.txt

# Run WayMore
echo "[*] Running WayMore..."
python3 /home/jaisriram/tools/waymore/waymore.py -i $domain -mode U -oU $output_dir/waymore_$domain.txt

echo "[+] Crawling of Domain $domain and SubDomins $listfile completed."

# Combine and sort all unique URLs
echo "[*] Combine and sort all unique URLs..."

cat $output_dir/waymore_$domain.txt $output_dir/katana_$domain.txt $output_dir/hakrawler_$domain.txt $output_dir/gau_$domain.txt $output_dir/waybackurls_$domain.txt | sort -u | tee ./unique-crawling.txt

echo "[+] Removing the output directory $output_dir ..."
rm -rf $output_dir

echo "[+] Saved the Unique URLs"

echo "[+] Web information gathering completed. Results saved in $output_dir."

echo "[*] Tool Ended at:" $(date +"%d-%m-%Y %I:%M %p")
