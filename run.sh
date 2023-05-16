#!/bin/bash
d=$(zenity --entry --text "Enter the domain : ")

url=$(zenity --entry --text "Enter the url : ")
zenity --info --text "target, $url!"

echo " ##################################################################"
echo "                                                                   "
echo "                           directory fuzzing                       "
echo "                                                                   "
echo " ##################################################################"
gobuster dir -u $url -w /Users/gokul.s/Downloads/common.txt | tee output/$d-dir

echo "                    "
echo " ##################################################################"
echo "                                                                   "
echo "                        HTTP Parameter Discovery                   "
echo "                                                                   "
echo " ##################################################################"
arjun -u $url --stable | tee output/$d-param 
echo "                    "
echo "                    "
echo " ##################################################################"
echo "                                                                   "
echo "                         secret finder                             "
echo "                                                                   "
echo " ##################################################################"
waybackurls $url -no-subs | grep "\\.js" | uniq | sort | tee output/$d-js
echo "                    "
echo " ##################################################################"
echo "                                                                   "
echo "                             WebDav Testing                        "
echo "                                                                   "
echo " ##################################################################"
python modules/dav $url output/$d-out
echo "                    "
echo "                  "
echo " ##################################################################"
echo "                                                                   "
echo "                        clickjacking $url                          "
echo "                                                                   "
echo " ##################################################################"
echo "                 "
python3 /Users/gokul.s/Documents/tool/modules/tool/clickjacking.py $url 
echo "                  "
echo " ##################################################################"
echo "                                                                   "
echo "                        subdomain finder                           "
echo "                                                                   "
echo " ##################################################################"
echo "                  "
subfinder -d $d | tee output/$d-sub
echo "                  "
echo "                  "
echo " ##################################################################"
echo "                                                                   "
echo "                        subdomain takeover                         "
echo "                                                                   "
echo " ##################################################################"
echo "                                                                   "
httpx -l output/$d-sub -status-code | tee output/$d-sub
cat output/$d-sub | subzy -hide -only-resolved 
echo "                                                                   "
echo " ##################################################################"
echo "                                                                   "
echo "                           port scanning                           "
echo "                                                                   "
echo " ##################################################################"
nmap $d -p- -vv -A --script=vuln | tee output/$d-nmap

zenity --info \
       --title "Info Message" \
       --width 500 \
       --height 100 \
       --text "completed successfully - result saved in output/$d."
