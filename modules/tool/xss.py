import os
import requests
import argparse

# Parse the target URL
parser = argparse.ArgumentParser(description='Detect XSS vulnerabilities')
parser.add_argument('target_url', help='The target URL')
args = parser.parse_args()

# Define the URLs file
urls_file = 'urls.txt'

# Use waybackurls/gau to get all the URLs that belong to the target
os.system(f'gau {args.target_url} > {urls_file}')
os.system(f'waybackurls {args.target_url} >> {urls_file}')

# Use gf to filter out XSS vulnerable parameters/inputs from the URLs obtained in the previous step
os.system(f'gf xss {urls_file} > xss_urls.txt')

# Pass these URLs with XSS vulnerable inputs to dalfox to identify possible XSS attacks
with open('xss_urls.txt', 'r') as f:
    for line in f:
        url = line.strip()
        command = f'dalfox url "{url}"'
        output = os.popen(command).read()

        # Display the results in an easy-to-read format
        if 'Vulnerability found' in output:
            print(f'[XSS VULNERABILITY FOUND] {url}')
            print(output)
        else:
            print(f'[NO XSS VULNERABILITY FOUND] {url}')
