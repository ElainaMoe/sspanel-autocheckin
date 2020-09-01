#!/bin/bash

PATH="/usr/local/bin:/usr/bin:/bin"

ENV_PATH="$(dirname $0)/.env"

if [ -f ${ENV_PATH} ]; then
    source ${ENV_PATH}
fi

if [ "${WORK_DOMAIN}" == "" ] || [ "${WORK_USERNAME}" == "" ] || [ "${WORK_PASSWD}" == "" ]; then
    echo "环境常量未配置，请正确配置 DOMAIN、USERNAME 和 PASSWD 值" && exit 1
fi

if [ $(command -v jq) == "" ]; then
    echo "依赖缺失: jq，查看 https://github.com/isecret/sspanel-autocheckin/blob/master/README.md 安装" && exit 1
fi

COOKIE_PATH="./.ss-autocheckin.cook"

login=$(curl "${WORK_DOMAIN}/auth/login" -d "email=${WORK_USERNAME}&passwd=${WORK_PASSWD}&code=" -c ${COOKIE_PATH} -L -k -s)

date=$(date '+%Y-%m-%d %H:%M:%S')
login_status=$(echo ${login} | jq '.msg')

if [ "${login_status}" == "" ]; then
    login_status='"登录失败"'
fi

echo "[${date}] ${login_status}"

checkin=$(curl -k -s -d "" -b ${COOKIE_PATH} "${WORK_DOMAIN}/user/checkin")

rm -rf ${COOKIE_PATH}

date=$(date '+%Y-%m-%d %H:%M:%S')
checkin_status=$(echo ${checkin} | jq '.msg')

if [ "${checkin_status}" == "" ]; then
    checkin_status='"签到失败"'
fi

echo "[${date}] ${checkin_status}"
