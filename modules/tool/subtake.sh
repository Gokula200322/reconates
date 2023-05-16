#!/bin/bash
# subdomain takeover checker

url=$1

echo "SUBDOMAINS TAKEOVER CHECK" >> /Users/gokul.s/Documents/tool/output/$url-output.txt
printf "\n\n" >> /Users/gokul.s/Documents/tool/output/$url-output.txt

subzy -concurrency 90 -timeout 20 -hide_fails -targets output/$url-subs | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | tee -a /Users/gokul.s/Documents/tool/output/$url-output.txt

printf "\n\n\n" >> /Users/gokul.s/Documents/tool/output/$url-output.txt
printf "##########################################################################################\n" >> /Users/gokul.s/Documents/tool/output/$url-output.txt
printf "##########################################################################################" >> /Users/gokul.s/Documents/tool/output/$url-output.txt
printf "\n\n\n" >> /Users/gokul.s/Documents/tool/output/$url-output.txt
