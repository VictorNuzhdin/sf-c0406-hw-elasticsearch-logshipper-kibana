server {
    listen 80 default_server;

    root /var/www/srv2.dotspace.ru/html;
    index index.html;

    # server_name srv2.dotspace.ru www.srv2.dotspace.ru;
    server_name srv2.dotspace.ru;

    location / {
        try_files $uri $uri/ =404;
    }

}
