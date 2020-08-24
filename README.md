# SSPanel 自动签到

## 使用方法

脚本依赖：
- `jq` 安装命令: Ubuntu: `apt-get install jq`、CentOS: `yum install jq`、MacOS: `brew install jq`

克隆或下载仓库 `ssp-autocheckin.sh` 脚本，编辑替换 `url`、`username` 和 `passwd` 变量值。

然后执行，签到成功后，即可添加定时任务。

```bash
bash /path/to/ssp-autocheckin.bash
[2020-08-24 14:05:18] "登录成功"
[2020-08-24 14:05:19] "获得了 59 MB流量"
```

如下：

```bash
24 10 * * * bash /path/to/ssp-autocheckin.bash >> /path/to/ssp-autocheckin.log
```

