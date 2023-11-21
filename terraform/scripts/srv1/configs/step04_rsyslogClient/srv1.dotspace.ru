server {

    root /var/www/srv1.dotspace.ru/html;
    index index.html;

    # server_name srv1.dotspace.ru www.srv1.dotspace.ru;
    server_name srv1.dotspace.ru;

    location / {
        try_files $uri $uri/ =404;
    }

    ## HTTPS/SSL Configuration with "Lets Encrypt" and "certbot"
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/srv1.dotspace.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/srv1.dotspace.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    ## Logging Configuration :: save to local files
    access_log    /var/log/nginx/srv1_dotspace_ru.access.log;
    error_log     /var/log/nginx/srv1_dotspace_ru.error.log;

    ## Logging Configuration :: send to remote server
    access_log  syslog:server=srv2.dotspace.ru:5143,facility=local7,severity=info,tag=nginx_srv1;
    error_log   syslog:server=srv2.dotspace.ru:5143,facility=local7,tag=nginx_srv1;
}

server {
    if ($host = srv1.dotspace.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80 default_server;
    server_name srv1.dotspace.ru;
    return 404; # managed by Certbot
}
