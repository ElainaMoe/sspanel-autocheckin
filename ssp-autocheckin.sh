#!/bin/bash

PATH="/usr/local/bin:/usr/bin:/bin"

ENV_PATH="$(dirname $0)/.env"

if [ ! -f ${ENV_PATH} ]; then
    echo "配置不存在，请复制 env.example 到 .env 并修改配置" && exit 1
fi

source ${ENV_PATH}

# Check jq command exist
if [ $(command -v jq) == "" ] 
then
    echo "依赖缺失: jq，查看 https://github.com/isecret/sspanel-autocheckin/blob/master/README.md 安装" && exit 1
fi

COOKIE_PATH="./.ss-autocheckin.cook"

login=$(curl "${DOMAIN}/auth/login" -d "email=${USERNAME}&passwd=${PASSWD}&code=" -c ${COOKIE_PATH} -L -k -s)

date=$(date '+%Y-%m-%d %H:%M:%S')
login_status=$(echo ${login} | jq '.msg')

echo "[${date}] ${login_status}"

checkin=$(curl -k -s -d "" -b ${COOKIE_PATH} "${DOMAIN}/user/checkin")

rm -rf ${COOKIE_PATH}

date=$(date '+%Y-%m-%d %H:%M:%S')
checkin_status=$(echo ${checkin} | jq '.msg')

if [ "${checkin_status}" == "" ]
then
    checkin_status='"签到失败"'
fi

echo "[${date}] ${checkin_status}"
