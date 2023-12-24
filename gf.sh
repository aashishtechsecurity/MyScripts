#!/bin/bash

# Define the list of patterns
patterns=("xss" "ssti" "ssrf" "sqli" "redirect" "rce" "lfi" "jsvar" "interestingsubs" "interestingparams" "interestingEXT" "idor" "debug_logic" "imag-traversal")

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Extract the input file from the command-line argument
input_file="$1"

# Check if the file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File not found."
    exit 1
fi

# Create the 'gf-pattern' folder if it doesn't exist
output_folder="gf-pattern"
mkdir -p "$output_folder"

# Loop through each pattern and execute the command
for pattern in "${patterns[@]}"
do
    gf "$pattern" "$input_file" > "$output_folder/${pattern}.txt"
done

echo "Pattern matching commands have been executed successfully. Output files are saved in 'gf-pattern' folder."
