# sf-c0406-hw-elasticsearch-logshipper-kibana
For Skill Factory study project (C04, HW2)

<br>


### Quick Info

```bash
#Общее описание
Terraform IaC конфигурация для развертывания в облаке Yandex Cloud
тестового стенда на основе стека EFK (Elasticsearch + Fluent + Kibana).

Данный стек является альтернативой общепринятому стеку ELK (Elasticsearch + Logstash + Kibana)
в котором используется логшиппер "Fluent" вместо "Logstash"

#Основные ссылки с описанием используемых технологий
Terraform by HashiCorp
https://www.terraform.io/

Yandex Cloud by Yandex
https://cloud.yandex.com/en-ru/

RSyslog :: log processing system
https://www.rsyslog.com/doc/v8-stable/

Fluentd :: log processor and log forwarder
https://en.wikipedia.org/wiki/Fluentd
https://www.fluentd.org/

Elasticsearch :: search engine with distributed, full-text search, http web interface and schema-free JSON documents features
https://en.wikipedia.org/wiki/Elasticsearch
https://www.elastic.co/

Logstash :: tool for managing events and logs (collection, processing, storage and searching)
https://wikitech.wikimedia.org/wiki/Logstash
https://www.elastic.co/logstash

Kibana :: provides visualization capabilities on top of the content indexed on an Elasticsearch cluster
https://en.wikipedia.org/wiki/Kibana
https://www.elastic.co/kibana


```
<br>

### Quick UserGuide

```bash
##--Terrafrom

#00.1 :: Select "terraform" directory
$ cd terraform

#00.2 :: Retrieve new auth token from Cloud (configured "yc" tool is required)
$ export TF_VAR_yc_token=$(yc iam create-token) && echo $TF_VAR_yc_token

#00.3 :: Check configuration, Build/Rebuild execution plan and Create/Recreate Cloud resources
$ terraform validate
$ terraform plan
$ terraform apply -auto-approve
..or
$ terraform validate && terraform plan && terraform apply -auto-approve
..or
$ terraform destroy -auto-approve && terraform validate && terraform plan && terraform apply -auto-approve

#00.4 :: Check site home pages of created cloud hosts with your preferred web browser
https://srv1.dotspace.ru    ## Welcome to [srv1.dotspace.ru] (Monitored: RSyslog)
https://srv2.dotspace.ru    ## Welcome to [srv2.dotspace.ru] (Monitor: Elasticsearch + Fluent + Kibana | EFK)

#00.5 :: Destroy cloud resources if they are not needed
$ terraform destroy -auto-approve


##--RSyslog

#01.1 :: Check [srv1] example shell-script for cron job
$ /home/ubuntu/scripts/apps/get_hostinfo.sh
$ cat /home/ubuntu/scripts/apps/get_hostinfo.log

        {"ram_mb_totl":1963,"ram_mb_used":1282,"ram_mb_usep":65.3082,"ram_mb_free":680,"dsk_mb_totl":7975,"dsk_mb_used":4482,"dsk_mb_usep":60,"dsk_mb_free":3099}

#01.2 :: Check [srv1] cron job that runs the example shell-script every 1 hour
$ sudo crontab -l

        PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
        0 */1 * * *    /home/ubuntu/scripts/apps/get_hostinfo.sh 2>&1

#01.3 :: Check [srv1] RSyslog Client config
#      ./terraform/scripts/srv2/configs/step04_rsyslogServer
$ ls -1X /etc/rsyslog.d/

        10-custom-c0406.conf
        ..

#01.4 :: Check [srv2] RSyslog Server config
#      ./terraform/scripts/srv2/configs/step04_rsyslogServer
$ sudo ls -1X /etc/rsyslog.d/

        10-custom-c0406-audit.conf
        11-custom-c0406-cron.conf
        12-custom-c0406-nginx.conf
        ..

#01.5 :: Check [srv1] received logs on [srv2]
$ sudo ls /var/log/remote/srv1/             ## 20231118  20231119  20231120
$ sudo ls /var/log/remote/srv1/20231120/    ## audit.log  cron.log  nginx.log

$ sudo tail -f /var/log/remote/srv1/20231120/audit.log

        Nov 20 06:51:29 srv1 sshd[5258]: Accepted publickey for devops from 92.124.136.25 port 55593 ssh2: ED25519 SHA256:mOv9chV3P0oNUZMgxSioWrSCWu3mOsDVDhqH3ep13ww
        Nov 20 06:51:29 srv1 sshd[5258]: pam_unix(sshd:session): session opened for user devops(uid=1001) by (uid=0)
        Nov 20 06:51:29 srv1 systemd-logind[714]: New session 16 of user devops.
        Nov 20 06:51:29 srv1 systemd: pam_unix(systemd-user:session): session opened for user devops(uid=1001) by (uid=0)
        Nov 20 06:51:36 srv1 sshd[5258]: pam_unix(sshd:session): session closed for user devops
        Nov 20 06:51:36 srv1 systemd-logind[714]: Session 16 logged out. Waiting for processes to exit.
        Nov 20 06:51:36 srv1 systemd-logind[714]: Removed session 16.

$ sudo tail -f /var/log/remote/srv1/20231120/cron.log

        Nov 20 06:35:01 srv1 CRON[5013]: (root) CMD (/home/ubuntu/scripts/apps/get_hostinfo.sh)
        Nov 20 06:40:01 srv1 CRON[5126]: (root) CMD (/home/ubuntu/scripts/apps/get_hostinfo.sh)
        Nov 20 06:45:01 srv1 CRON[5168]: (root) CMD (/home/ubuntu/scripts/apps/get_hostinfo.sh)
        Nov 20 06:50:02 srv1 CRON[5234]: (root) CMD (/home/ubuntu/scripts/apps/get_hostinfo.sh)

$ sudo tail -f /var/log/remote/srv1/20231120/nginx.log

        Nov 20 06:27:22 srv1 nginx_srv1: 92.124.136.25 - - [20/Nov/2023:06:27:22 +0000] "GET / HTTP/1.1" 200 902 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"
        Nov 20 06:50:17 srv1 nginx_srv1: 92.124.136.25 - - [20/Nov/2023:06:50:17 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"
        Nov 20 06:54:44 srv1 nginx_srv1: 92.124.136.25 - - [20/Nov/2023:06:54:44 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"

$ sudo tail -f /root/get_hostinfo.log

        2023-11-20T06:20:01    {"ram_mb_totl":1963,"ram_mb_used":1282,"ram_mb_usep":65.3082,"ram_mb_free":680,"dsk_mb_totl":7975,"dsk_mb_used":4482,"dsk_mb_usep":60,"dsk_mb_free":3099}
        2023-11-20T06:25:01    {"ram_mb_totl":1963,"ram_mb_used":1272,"ram_mb_usep":64.7988,"ram_mb_free":690,"dsk_mb_totl":7975,"dsk_mb_used":4482,"dsk_mb_usep":60,"dsk_mb_free":3099}
        2023-11-20T06:30:01    {"ram_mb_totl":1963,"ram_mb_used":1278,"ram_mb_usep":65.1044,"ram_mb_free":685,"dsk_mb_totl":7975,"dsk_mb_used":4490,"dsk_mb_usep":60,"dsk_mb_free":3091}
        2023-11-20T06:35:01    {"ram_mb_totl":1963,"ram_mb_used":1278,"ram_mb_usep":65.1044,"ram_mb_free":685,"dsk_mb_totl":7975,"dsk_mb_used":4490,"dsk_mb_usep":60,"dsk_mb_free":3091}

```
<br>

### Changelog

```bash
2023.11.20 :: Настроено логирование на оснве RSyslog :: хост "srv1" передает логи (audit.log, cron.log, nginx.log) на хост "srv2"
2023.11.07 :: Разработана каркасная базовая Terraform конфигурация создающая два хоста "srv1", "srv2" на основе образа Ubuntu 22.04

```
<br>
