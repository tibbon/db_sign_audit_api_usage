#!/bin/bash

usage() {
    echo "Usage: $0 [filename]"
    echo "filename: Text file containing IP addresses. Default: ips.txt"
    exit 1
}

# Default filename
filename="${1:-ips.txt}"

# Check if the file exists
if [[ ! -f "$filename" ]]; then
    echo "File not found: $filename"
    usage
fi

# Process file and WHOIS data
echo "Fetching WHOIS data and generating histogram..."
# Read each line in the file
sort "$filename" | uniq | while IFS= read -r ip; do
    # Perform the whois lookup
    result=$(whois "$ip")

    # Extract the organization name and description
    name=$(echo "$result" | grep -m 1 'OrgName\|owner:\|Registrant Organization' | cut -d ':' -f 2 | sed 's/^\s*//;s/\s*$//')
    description=$(echo "$result" | grep -m 1 'OrgTechDescr\|descr:' | cut -d ':' -f 2 | sed 's/^\s*//;s/\s*$//')

    # Print the IP, organization name, and description
    echo "$ip   $name   $description"
done

# # Count occurrences of each IP, sort them by frequency, and display a histogram
echo "Histogram of IP occurrences:"
sort "$filename" | uniq -c | sort -nr | awk '{ printf "%s - %d occurrences\n", $2, $1 }'