#!/bin/sh

SCRIPTS_PATH=/home/ubuntu/scripts
CONFIGS_PATH=/home/ubuntu/scripts/configs/step04_rsyslogClient
LOG_PATH=$SCRIPTS_PATH/configure_07-logging-rsyslog-client.log
WEBSITE_DOMAIN_NAME=srv1.dotspace.ru



##--STEP#07 :: Configuring Syslog Client for sendings logs to remote RSyslog server..
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


echo '## Step07.1 - Adding custom RSyslog Client configuration..' >> $LOG_PATH
sudo cp $CONFIGS_PATH/10-custom-c0406.conf /etc/rsyslog.d/
##..fix permissions
sudo chown root:root /etc/rsyslog.d/10-custom-c0406.conf
sudo chmod 664 /etc/rsyslog.d/10-custom-c0406.conf
##..checkout
sudo ls -1X /etc/rsyslog.d/ >> $LOG_PATH
echo "" >> $LOG_PATH
sudo cat /etc/rsyslog.d/10-custom-c0406.conf >> $LOG_PATH
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.2 - Replacing current nginx hosts configuration with NEW logging settings..' >> $LOG_PATH
sudo rm -f /etc/nginx/sites-available/$WEBSITE_DOMAIN_NAME
sudo cp $CONFIGS_PATH/$WEBSITE_DOMAIN_NAME /etc/nginx/sites-available/
##..fix permissions
sudo chown root:root /etc/nginx/sites-available/$WEBSITE_DOMAIN_NAME
sudo chmod 664 /etc/nginx/sites-available/$WEBSITE_DOMAIN_NAME
##..checkout
sudo cat /etc/nginx/sites-available/srv1.dotspace.ru | grep _log >> $LOG_PATH
echo "" >> $LOG_PATH
sudo nginx -t >> $LOG_PATH
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.3 - Adding test shell script && cron job..' >> $LOG_PATH
sudo mkdir $SCRIPTS_PATH/apps
sudo cp $CONFIGS_PATH/get_hostinfo.sh $SCRIPTS_PATH/apps
sudo chmod 755 $SCRIPTS_PATH/apps/get_hostinfo.sh
##..create cronjob (run script every 5 minutes or every 1 hour)
##  saving current crontab to file - adding new record - applying new crontab
sudo crontab -l > $SCRIPTS_PATH/apps/crontab_root.backup
sudo crontab -l > $SCRIPTS_PATH/apps/cron_tmp
#echo "*/5 * * * *    $SCRIPTS_PATH/apps/get_hostinfo.sh" >> $SCRIPTS_PATH/apps/cron_tmp
echo "0 */1 * * *    $SCRIPTS_PATH/apps/get_hostinfo.sh" >> $SCRIPTS_PATH/apps/cron_tmp
sudo crontab $SCRIPTS_PATH/apps/cron_tmp
sudo service cron reload
##..checkout
sudo systemctl status cron >> $LOG_PATH
echo "" >> $LOG_PATH
sudo crontab -l >> $LOG_PATH
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.4 - Restarting RSyslog service..' >> $LOG_PATH
sudo systemctl restart rsyslog
##..checkout
sudo systemctl status rsyslog >> $LOG_PATH
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.4 - Restarting Nginx service..' >> $LOG_PATH
sudo systemctl restart nginx
##..checkout
sudo systemctl status nginx >> $LOG_PATH
echo "" >> $LOG_PATH


echo ""
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
