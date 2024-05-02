#!/bin/bash

account_id=${HELLOSIGN_ACCOUNT_ID}
cookie="Cookie: ${HELLOSIGN_COOKIE}"
pages_to_fetch=${1:-${PAGES_TO_FETCH:-10}}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 [number of pages to fetch]"
    echo "Environment variables: HELLOSIGN_ACCOUNT_ID, HELLOSIGN_COOKIE"
    exit 0
fi

if ! command -v curl &>/dev/null || ! command -v jq &>/dev/null; then
    echo "This script requires 'curl' and 'jq'. Please install them and run this script again."
    exit 1
fi

for ((i=1; i<pages_to_fetch+1; i++))
do
    curl 'https://app.hellosign.com/apidashboard/apiRequestsList?testMode=false&account='"$account_id"'&page_size=100&page_num='"$i"'' \
        -H 'Accept: application/json' \
        -H 'Accept-Language: en-US,en;q=0.9' \
        -H 'Connection: keep-alive' \
        -H "$cookie" | jq '.items[].id' | tr -d '"' >> ids.txt
done

while IFS= read id; do
    curl 'https://app.hellosign.com/apidashboard/apiRequestDetail?id='"$id"'&account_id='"$account_id"'' \
    -H 'Accept: application/json' \
    -H 'Accept-Language: en-US,en;q=0.9' \
    -H 'Connection: keep-alive' \
    -H "$cookie" | jq '.ip' | tr -d '"' >> ips.txt
done < ids.txt