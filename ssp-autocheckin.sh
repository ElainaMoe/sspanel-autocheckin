#!/bin/bash

# Your host
url="https://****.best"
# User email
username="EMAIL"
# User password
passwd="PASSWORD"
# Cookie file save path
cookie_path="./.ss-autocheckin.cook"

login=$(curl "${url}/auth/login" -d "email=${username}&passwd=${passwd}&code=" -c ${cookie_path} -L -k -s)

date=$(date '+%Y-%m-%d %H:%M:%S')
login_status=$(echo ${login} | jq '.msg')

echo "[${date}] ${login_status}"

checkin=$(curl -k -s -d "" -b ${cookie_path} "${url}/user/checkin")

rm -rf ${cookie_path}

date=$(date '+%Y-%m-%d %H:%M:%S')
checkin_status=$(echo ${checkin} | jq '.msg')

echo "[${date}] ${checkin_status}"
