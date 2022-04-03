# iauro-assignment

Before run this command please make sure that you need to create require directories in your machine.
To execute the docker-compose file use this command, below command will execute using docker-compose.yaml file,
docker-compose up -d --build

For execution flow please check screenshots, I have associated all screenshots of execution logs and flow.
Also, I have added nginx_nodeapp.conf file of nginx configs.

For lets encrypt configs, please follow steps,
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

Output
Country Name (2 letter code) [AU]:IN
State or Province Name (full name) [Some-State]:MH
Locality Name (eg, city) []:Pune
Organization Name (eg, company) [Internet Widgits Pty Ltd]:test
Organizational Unit Name (eg, section) []:IT
Common Name (e.g. server FQDN or YOUR name) []:<host_ip>
Email Address []:NA

sudo openssl dhparam -out /etc/nginx/node_nginx.pem 4096

sudo nano /etc/nginx/site-enabled/self-signed.conf
ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

sudo nano /etc/nginx/site-enabled/ssl-params.conf

sudo nano /etc/nginx/sites-available/nginx_nodeapp.conf
Add below content in this file,
server
{
    listen 80;
    listen [::]:80;
    server_name 13.213.45.33;
    return 302 https://$server_name$request_uri;
}

server {

    listen 443 default_server ssl;
    server_name 13.213.45.33;
    client_max_body_size 100M;
    ssl_session_cache builtin:1000 shared:SSL:200m;
    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    #ssl_trusted_certificate /etc/nginx/ssl/scm_solargroup_com.ca-bundle;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
    ssl_protocols TLSv1.2;
    proxy_ssl_ciphers             HIGH:!aNULL:!MD5;
    ssl_ciphers "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA HIGH !RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS";
    ssl_prefer_server_ciphers on;
    access_log            /var/log/nginx/ssl.access.log;
    error_log            /var/log/nginx/ssl.error.log;
   
	location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header Connection "Keep-Alive";
        proxy_set_header Proxy-Connection "Keep-Alive";
        proxy_set_header    X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_read_timeout 1800;
        proxy_connect_timeout 1800;
        proxy_send_timeout 1800;
        send_timeout 1800;
    }
 
}

Allow firefall for nginx,
sudo ufw allow 'Nginx Full'
sudo ufw status
Output
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere
Nginx Full                 ALLOW       Anywhere
OpenSSH (v6)               ALLOW       Anywhere (v6)
Nginx Full (v6)            ALLOW       Anywhere (v6)

Enabling changes in nginx,
sudo nginx -t

Restart the nginx service,
sudo systemctl restart nginx

curl https://<host_ip>

Finally app is tested, for more information please check screenshots.

