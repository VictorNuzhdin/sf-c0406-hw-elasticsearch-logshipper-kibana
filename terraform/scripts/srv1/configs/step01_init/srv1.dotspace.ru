server {
    listen 80 default_server;

    root /var/www/srv1.dotspace.ru/html;
    index index.html;

    # server_name srv1.dotspace.ru www.srv1.dotspace.ru;
    server_name srv1.dotspace.ru;

    location / {
        try_files $uri $uri/ =404;
    }

}
