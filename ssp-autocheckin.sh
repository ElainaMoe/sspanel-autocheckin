#!/bin/bash

PATH="/usr/local/bin:/usr/bin:/bin"

ENV_PATH="$(dirname $0)/.env"

if [ -f ${ENV_PATH} ]; then
    source ${ENV_PATH}
fi

if [ "${DOMAIN}" == "" ] || [ "${USERNAME}" == "" ] || [ "${PASSWD}" == "" ]; then
    echo "环境常量未配置，请正确配置 DOMAIN、USERNAME 和 PASSWD 值" && exit 1
fi

if [ $(command -v jq) == "" ]; then
    echo "依赖缺失: jq，查看 https://github.com/isecret/sspanel-autocheckin/blob/master/README.md 安装" && exit 1
fi

COOKIE_PATH="./.ss-autocheckin.cook"

login=$(curl "${DOMAIN}/auth/login" -d "email=${USERNAME}&passwd=${PASSWD}&code=" -c ${COOKIE_PATH} -L -k -s)

date=$(date '+%Y-%m-%d %H:%M:%S')
login_status=$(echo ${login} | jq '.msg')

if [ "${login_status}" == "" ]; then
    login_status='"登录失败"'
fi

login_text="[${date}] ${login_status}"

echo ${login_text}

checkin=$(curl -k -s -d "" -b ${COOKIE_PATH} "${DOMAIN}/user/checkin")

rm -rf ${COOKIE_PATH}

date=$(date '+%Y-%m-%d %H:%M:%S')
checkin_status=$(echo ${checkin} | jq '.msg')

if [ "${checkin_status}" == "" ]; then
    checkin_status='"签到失败"'
fi

checkin_text="[${date}] ${checkin_status}"

echo ${checkin_text}

date=$(date '+%Y-%m-%d %H:%M:%S')
if [ "${PUSH_KEY}" == "" ]; then
    push_status='"未配置推送 PUSH_KEY"'
else
    text="SSPanel Auto Checkin 签到结果"
    desp="站点: ${DOMAIN}"+$'\n\n'+"用户名: ${USERNAME}"+$'\n\n'+"${login_text}"+$'\n\n'+"${checkin_text}"+$'\n\n'
    push=$(curl -k -s -d "text=${text}&desp=${desp}" "https://sc.ftqq.com/${PUSH_KEY}.send")
    push_code=$(echo ${push} | jq '.errno')

    if [ ${push_code} == 0 ]; then
        push_status='"签到结果推送成功"'
    else
        push_status='"签到结果推送失败"'
    fi
fi

push_text="[${date}] ${push_status}"

echo ${push_text}
