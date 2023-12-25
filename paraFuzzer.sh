#!/bin/bash

# Check if the filename argument is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Check if the specified file exists
if [ ! -f "$1" ]; then
  echo "Error: File $1 not found."
  exit 1
fi



# Run paramspider with the specified file
paramspider -l "$1"

# Change directory to results
cd results

# Concatenate and sort unique entries, then save to fuzzer.txt
cat results/* | sort -u | tee fuzzer.txt

# Remove the results directory
rm -rf results

# Run gospider with the specified file
cat "$1" | xargs -I % gospider -s https://% -t 5 -c 10 --sitemap -o ./out/%.txt 

