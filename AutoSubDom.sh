#!/bin/bash

echo "

░█████╗░██╗░░░██╗████████╗░█████╗░░██████╗██╗░░░██╗██████╗░██████╗░░█████╗░███╗░░░███╗
██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗██╔════╝██║░░░██║██╔══██╗██╔══██╗██╔══██╗████╗░████║
███████║██║░░░██║░░░██║░░░██║░░██║╚█████╗░██║░░░██║██████╦╝██║░░██║██║░░██║██╔████╔██║
██╔══██║██║░░░██║░░░██║░░░██║░░██║░╚═══██╗██║░░░██║██╔══██╗██║░░██║██║░░██║██║╚██╔╝██║
██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝██████╔╝╚██████╔╝██████╦╝██████╔╝╚█████╔╝██║░╚═╝░██║
╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░╚═════╝░░╚═════╝░╚═════╝░╚═════╝░░╚════╝░╚═╝░░░░░╚═╝
        Author   : Aashish💕💕  
                                              
        Github   : https://github.com/aashish36

"
echo "Tool Started at:" $(date +"%d-%m-%Y %I:%M %p")


# Check if necessary tools are installed
if ! command -v subfinder &> /dev/null; then
    echo "subfinder is not installed. Please install it first."
    exit 1
fi

if ! command -v amass &> /dev/null; then
    echo "amass is not installed. Please install it first."
    exit 1
fi

if ! command -v assetfinder &> /dev/null; then
    echo "assetfinder is not installed. Please install it first."
    exit 1
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Please install it first."
    exit 1
fi

# Check if a target domain is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <target_domain>"
    exit 1
fi

target_domain="$1"

# Create a timestamped directory
timestamp=$(date +"%Y%m%d_%H%M%S")
output_directory="subdomains_$timestamp"
mkdir "$output_directory"

# Output files
subfinder_output="$output_directory/subdomains.txt"
amass_output="$output_directory/amass_subdomains.txt"
assetfinder_output="$output_directory/assetfinder_subdomains.txt"
crt_output="$output_directory/crt_subdomains.txt"
final_output="unique_subdomains.txt"

echo "Run subfinder......."
subfinder -d $target_domain -o $subfinder_output

echo "Run amass......"
amass enum -d $target_domain -o $amass_output

echo "Run assetfinder....."
assetfinder --subs-only $target_domain > $assetfinder_output

echo "Run crt.sh enumeration......"
curl -s "https://crt.sh/?q=%.$target_domain" | grep -F ".$target_domain" | sort -u | cut -d'>' -f2 | cut -d'<' -f1 | sort -u > $crt_output

echo "Combine and sort all subdomains......"
cat $subfinder_output $amass_output $assetfinder_output $crt_output | sort -u > $final_output

# echo "Removing the $output_directory ......"
# rm -rf $output_directory

echo "Subdomain enumeration completed. Results saved to ./$final_output ."
echo "Tool Ended at:" $(date +"%d-%m-%Y %I:%M %p")
