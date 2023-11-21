#!/bin/sh

SCRIPTS_PATH=/home/ubuntu/scripts
CONFIGS_PATH=/home/ubuntu/scripts/configs/step04_rsyslogServer
LOG_PATH=$SCRIPTS_PATH/configure_07-logging-rsyslog-server.log
WEBSITE_DOMAIN_NAME=srv1.dotspace.ru
HOST1_NAME=srv1



##--STEP#07 :: Configuring RSyslog Server for receive logs from remote Syslog Client..
##
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs started.." >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.0 - Collecting RSyslog info..' >> $LOG_PATH
which rsyslogd >> $LOG_PATH
rsyslogd -version | head -n 1 >> $LOG_PATH
rsyslogd -version | grep Config >> $LOG_PATH
#
##..example_output
## /usr/sbin/rsyslogd
## rsyslogd  8.2112.0 (aka 2021.12) compiled with..
## Config file: /etc/rsyslog.conf
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.1 - Adding custom RSyslog Server configurations..' >> $LOG_PATH
sudo cp $CONFIGS_PATH/10-custom-c0406-audit.conf /etc/rsyslog.d/
sudo cp $CONFIGS_PATH/11-custom-c0406-cron.conf /etc/rsyslog.d/
sudo cp $CONFIGS_PATH/12-custom-c0406-nginx.conf /etc/rsyslog.d/
##..fix permissions
sudo chown root:root /etc/rsyslog.d/10-custom-c0406-audit.conf
sudo chown root:root /etc/rsyslog.d/11-custom-c0406-cron.conf
sudo chown root:root /etc/rsyslog.d/12-custom-c0406-nginx.conf
sudo chmod 664 /etc/rsyslog.d/10-custom-c0406-audit.conf
sudo chmod 664 /etc/rsyslog.d/11-custom-c0406-cron.conf
sudo chmod 664 /etc/rsyslog.d/12-custom-c0406-nginx.conf
##..checkout
sudo ls -1X /etc/rsyslog.d/ >> $LOG_PATH
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.2 - Restarting RSyslog service..' >> $LOG_PATH
sudo systemctl restart rsyslog
##..checkout
sudo systemctl status rsyslog >> $LOG_PATH
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.3 - Adding firewall (ufw) rules..' >> $LOG_PATH
sudo ufw allow proto tcp from any to any port 5141 comment 'Allow Incoming RSyslog 5141/TCP'
sudo ufw allow proto udp from any to any port 5142 comment 'Allow Incoming RSyslog 5142/UDP'
sudo ufw allow proto udp from any to any port 5143 comment 'Allow Incoming RSyslog 5143/UDP'
##..checkout
sudo ufw status numbered >> $LOG_PATH
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.4 - Checking Logs locally received from remote RSyslog Client..' >> $LOG_PATH
echo "--log_folders" >> $LOG_PATH
sudo ls /var/log/remote/ >> $LOG_PATH
sudo ls /var/log/remote/$HOST1_NAME/ >> $LOG_PATH
echo "" >> $LOG_PATH
echo "--audit.log" >> $LOG_PATH
sudo tail -n 5 /var/log/remote/$HOST1_NAME/$(date +'%Y%m%d')/audit.log >> $LOG_PATH
echo "" >> $LOG_PATH
echo "--cron.log" >> $LOG_PATH
sudo tail -n 5 /var/log/remote/$HOST1_NAME/$(date +'%Y%m%d')/cron.log >> $LOG_PATH
echo "" >> $LOG_PATH
echo "--nginx.log" >> $LOG_PATH
sudo tail -n 5 /var/log/remote/$HOST1_NAME/$(date +'%Y%m%d')/nginx.log >> $LOG_PATH
##..example_path
##  /var/log/remote/srv1/20231120/nginx.log
echo "" >> $LOG_PATH


echo ""
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
