# Audit Dropbox Sign API usage
On [May 1, 2024 Dropbox Sign team disclosed unauthorized access to their systems](https://sign.dropbox.com/blog/a-recent-security-incident-involving-dropbox-sign), recommending rotation of API keys and OAuth tokens.

The Dropbox Sign [API Requests dashboard](https://app.hellosign.com/apidashboard/apiRequests) currently lacks capability to download an audit log, and requires clicking through the UI to investigate individual API request records.

These simple bash scripts will download API request IDs and details of those requests.

The `review_ip_usage.sh` script will then iterate through the IPs, looking at whois data, and outputting a histogram of the IPs.

## Usage
Make the files executable
```bash
chmod +X fetch_api_usage.sh review_ip_usage.sh
```

### Fetch API usage
Get your cookie (sans `Cookie:`) from your browser session, and your Dropbox/Hellosign account ID. This script depends on `curl` and `jq`

`HELLOSIGN_ACCOUNT_ID= HELLOSIGN_COOKIE= ./fetch_api_usage.sh`
This will write API request IDs to `ids.txt` and the IP addresses to `ips.txt`

### Review IP usage
This depends on `whois`.

`./review_ip_usage.sh`

## Thanks
Additional thanks to @tpelissier23 and @bob-ats

## License
The source code for the site is licensed under the MIT license, which you can find in the LICENSE.txt file.