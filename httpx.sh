#!/bin/bash

echo"

╭╮╱╭╮╱╭╮╱╱╱╭━━━┳╮
┃┃╭╯╰┳╯╰╮╱╱┃╭━╮┃┃
┃╰┻╮╭┻╮╭╋━━┫┃╱┃┃┃╭┳╮╭┳━━╮
┃╭╮┃┃╱┃┃┃╭╮┃╰━╯┃┃┣┫╰╯┃┃━┫
┃┃┃┃╰╮┃╰┫╰╯┃╭━╮┃╰┫┣╮╭┫┃━┫
╰╯╰┻━╯╰━┫╭━┻╯╱╰┻━┻╯╰╯╰━━╯
╱╱╱╱╱╱╱╱┃┃
╱╱╱╱╱╱╱╱╰╯

        Author   : Aashish💕💕  
                                              
        Github   : https://github.com/aashishsec

"
echo "Tool Started at:" $(date +"%d-%m-%Y %I:%M %p")

# Check if the input file argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Set the path to httpx binary
HTTPX_PATH="/home/jaisriram/.pdtm/go/bin/httpx"

# Specify the input file containing the list of URLs
file="$1"

# Run httpx with specified options and save the output to httpx.txt
echo "Running $HTTPX_PATH -l $file -follow-redirects -random-agent -status-code -title -web-server -tech-detect -ct -location -o httpx.txt"
$HTTPX_PATH -l "$file" -follow-redirects -random-agent -status-code -title -web-server -tech-detect -ct -location -o httpx.txt

# Extract all unique websites from httpx.txt and save them to httpx-website.txt
echo "Extracting unique websites from httpx.txt and saving to httpx-website.txt"
cat httpx.txt | cut -d " " -f 1 | tee httpx-website.txt

# Extract all alive (HTTP status code 200) websites from httpx.txt and save them to httpx-website-alive.txt
echo "Extracting alive websites (HTTP status code 200) from httpx.txt and saving to httpx-website-alive.txt"
cat httpx.txt | grep 200 | cut -d " " -f 1 | tee httpx-website-alive.txt

echo "Tool Ended at:" $(date +"%d-%m-%Y %I:%M %p")

