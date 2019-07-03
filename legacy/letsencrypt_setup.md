# THIS IS OBSOLETE

# SSL setup with Let's encrypt for Ubuntu, Nginx  

This guide demonstrates how to set up ssl and auto renew with Let's encrypt on a server running Ubuntu 16.04 or 14.04 LTS, DHIS2 and Nginx.  

## Install letsencrypt:  

#### Ubuntu 16.04:  

```bash
$ sudo apt-get install letsencrypt
```  
#### Ubuntu 14.04:  

```bash
$ cd /opt
$ sudo wget https://dl.eff.org/certbot-auto
$ sudo chmod a+x certbot-auto
$ sudo ./certbot-auto
``` 

## Obtain certificate using Nginx  

#### Ubuntu 16.04:  

```bash
$ sudo letsencrypt certonly --webroot -w /usr/share/nginx/html -d example.com -d www.example.com -d <subdomain>.dhis2.org
```

#### Ubuntu 14.04:  

```bash
$ sudo ./certbot-auto certonly --webroot -w /usr/share/nginx/html -d example.dhis2.org
```
Parameter "-w" is the webroot directory. Nginx standard directory: `/usr/share/nginx/html`, or check if the root directory is set in your Nginx config.  
Parameter "-d" is the domain name you want a certificate for. You can add multiple domains as seen in the example above.
If you get an error check the [troubleshooting section](#troubleshooting).


## Configure Nginx  

Start by running the following command, it can take a few minutes but it will increase the security:  

```bash
$ sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
```  

The certificate will be located under `/etc/letsencrypt/live/<domain>/`.  
The Nginx configuration should be the same for both 14.04 and 16.04: 

```
# apply these settings to all backends
proxy_cache_path  /var/cache/nginx  keys_zone=dhis:250m  inactive=1d;
proxy_redirect    off;
proxy_set_header  Host               $host;
proxy_set_header  X-Real-IP          $remote_addr;
proxy_set_header  X-Forwarded-For    $proxy_add_x_forwarded_for;
proxy_set_header  X-Forwarded-Proto  https;
#proxy_cache       dhis;

server {
  listen     80;
  rewrite    ^ https://$host$request_uri? permanent;
  location ~ /.well-known {
    allow all;
  }
}

# HTTPS server
server {
  listen               443;
  client_max_body_size 10M;

  # ssl settings
  ssl                        on;
  ssl_certificate            /etc/letsencrypt/live/<domain>/fullchain.pem;
  ssl_certificate_key        /etc/letsencrypt/live/<domain>/privkey.pem;
  ssl_session_timeout        30m;
  ssl_protocols              TLSv1 TLSv1.1 TLSv1.2;
  ssl_session_cache          shared:SSL:10m;
  ssl_prefer_server_ciphers  on;
  
  # This is quite strict.  If you have much older windoze browsers
  # to support you might need the line below instead.
  ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';

  # ssl_ciphers "ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";

  # Enable HSTS
  add_header Strict-Transport-Security max-age=63072000;

  # Do not allow this site to be displayed in iframes
  add_header X-Frame-Options DENY;

  # Do not permit Content-Type sniffing.
  add_header X-Content-Type-Options nosniff;

  # You need to generate the dh parameters before using this setting
  # Command:  openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
  ssl_dhparam /etc/ssl/certs/dhparam.pem;

  # nominate a backend as the default
  rewrite ^/$ /dhis/;

  # Proxy pass to servlet containers
  location /dhis/ { proxy_pass  http://localhost:8080/dhis/; }
}
```  

Notice the `location ~ /.well-known{ allow all; }`, this is needed for auto renewing the certificates.

## Auto renew certificate  

A Let's Encrypt certificate is valid for 90 days, so it is recommended that you make a cron job for auto renewing the certificate.  
Before setting up auto renew you should check that everything is working correctly, run:  

#### Ubuntu 16.04:  

```bash
$ sudo letsencrypt renew --dry-run --agree-tos
```    
#### Ubuntu 14.04:  

```bash
$ sudo ./certbot-auto renew --dry-run --agree-tos
``` 

### Set up auto renew  

If this looks good you can add renewing as a cron job:  

```bash
$ sudo crontab -e
```
Append the following for Ubuntu 16.04:  

```
30 2 * * 1 /usr/bin/letsencrypt renew >> /var/log/le-renew.log
35 2 * * 1 /bin/systemctl reload nginx
```  
and for Ubuntu 14.04 use this instead:  

```
30 2 * * 1 /opt/certbot-auto renew >> /var/log/le-renew.log
35 2 * * 1 /etc/init.d/nginx reload
```  

The setting can be adjusted as you want, but by using the settings above renewal will be initiated every Monday at 2:30am and Nginx will reload at 2:35am. It wont actually do anything until there are 30 days left of the certificate.


## Troubleshooting  

If you get an error while requesting a certificate, try to run it without https settings in the Nginx config:  

```
# apply these settings to all backends
proxy_cache_path  /var/cache/nginx  keys_zone=dhis:250m  inactive=1d;
proxy_redirect    off;
proxy_set_header  Host               $host;
proxy_set_header  X-Real-IP          $remote_addr;
proxy_set_header  X-Forwarded-For    $proxy_add_x_forwarded_for;

server {
  listen     80;
  location ~ /.well-known {
    allow all;
  }
}
```  

Try to get the certificate again by running:  

```bash
$ sudo letsencrypt certonly --webroot -w /usr/share/nginx/html -d <domain>.dhis2.org
```  

If it looks good, continue by [configuring Nginx](#configure-nginx).

##### Useful links
[How To Secure Nginx with Let's Encrypt on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-14-04)  
[How To Secure Nginx with Let's Encrypt on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04)  
[Let's Encrypt](https://letsencrypt.org/)
