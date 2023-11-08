server {

    root /var/www/srv2.dotspace.ru/html;
    index index.html;

    # server_name srv2.dotspace.ru www.srv2.dotspace.ru;
    server_name srv2.dotspace.ru;

    location / {
        try_files $uri $uri/ =404;
    }

    ## HTTPS/SSL Configuration with "Lets Encrypt" and "certbot"
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/srv2.dotspace.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/srv2.dotspace.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    ## Logging Configuration
    access_log    /var/log/nginx/srv2_dotspace_ru.access.log;
    error_log     /var/log/nginx/srv2_dotspace_ru.error.log;
}

server {
    if ($host = srv2.dotspace.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80 default_server;
    server_name srv2.dotspace.ru;
    return 404; # managed by Certbot
}
