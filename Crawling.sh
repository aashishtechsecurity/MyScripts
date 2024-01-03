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

cat $output_dir/waymore_$domain.txt $output_dir/katana_$domain.txt $output_dir/hakrawler_$domain.txt $output_dir/gau_$domain.txt $output_dir/waybackurls_$domain.txt | sort -u | tee unique-crawling.txt

# echo "[+] Removing the output directory $output_dir ..."
# rm -rf $output_dir

echo "[+] Saved the Unique URLs"

echo "[+] Web information gathering completed. Results saved in $output_dir."

# echo "[+] Doing httpx on unique-crawling.txt ...."
# cat unique-crawling.txt | httpx -mc 200,404,401,403 -cl > unique-crawling-alive.txt

# echo "[+] Extracting only website from it..."
# cat unique-crawling-alive.txt |  cut -d " " -f 1 > unique-crawling-alive-websites.txt

# # Extract file extensions and create an array
# file_extensions=("zip" "rar" "tar" "tgz" "sql" "db" "sqlite" "pgsql.txt" "mysql.txt" "gz" "config" "log" "bak" "backup" "bkp" "crt" "dat" "eml" "java" "lst" "key" "passwd" "pl" "pwd" "mysql-connect" "jar" "cfg" "dir" "orig" "bz2" "old" "vbs" "img" "inf" "sh" "py" "vbproj" "mysql-pconnect" "war" "go" "psql" "sql.gz" "vb" "webinfo" "jnlp" "cgi" "temp" "ini" "webproj" "xsql" "raw" "inc" "lck" "nz" "rc" "html.gz" "gz" "env" "yml" "php" "asp" "aspx" "jsp" "txt" "conf" "config" "bak" "backup" "swp" "old" "db" "sqlasp" "aspx~" "asp~" "py" "py~" "rb" "rb~" "php" "php~" "bak" "bkp" "cache" "cgi" "conf" "csv" "html" "inc" "jar" "js" "json" "jsp" "jsp~" "lock" "log" "rar" "old" "sql" "sql.gz" "sql.zip" "sql.tar.gz" "sql~" "swp" "swp~" "tar" "tar.bz2" "tar.gz" "txt" "wadl" "zip")

# # Create a directory to store output files
# output_directory="sensitive_files"
# mkdir -p "$output_directory"

# # Loop through the array and run the grep command for each file extension
# for ext in "${file_extensions[@]}"; do
#     # Create a subdirectory for each file extension
#     ext_directory="${output_directory}/${ext}"
#     mkdir -p "$ext_directory"
    
#     # Run grep command with -F and store the output in the corresponding subdirectory
#     grep -F ".$ext" unique-crawling-alive-websites.txt > "${ext_directory}/${ext}.txt"
# done

# echo "[*] Tool Ended at:" $(date +"%d-%m-%Y %I:%M %p")
