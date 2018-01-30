This is the proxy server docker image for python web application which run at 5000 with self generated SSl
Command
==After starting docker container you have to start these service ==.
# /etc/init.d/apache2 start
# cd /var/www/flshapp
# python \__init__.py 
-------------------------
# apt-get install apache2 -y
# /etc/init.d/apache2 start
Install Mod proxy
# apt-get install libapache2-mod-proxy-html libxml2-dev -y
Making Proxy
# a2enmod
# a2enmod proxy
# a2enmod proxy_http
# a2enmod proxy_ajp
# a2enmod rewrite
# a2enmod deflate
# a2enmod headers
# a2enmod proxy_balancer
# a2enmod proxy_connect
# a2enmod proxy_htm
----------------------------
Disable 000-default.conf file
# a2dissite 000-default
Create New virtual host files
# vim /etc/apache2/sites-available/proxy-host.conf
== Add this line ==

<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
  ProxyPreserveHost On
 =# Servers to proxy the connection, or
  =# List of application servers Usage
  ProxyPass / http://localhost:5000/
  ProxyPassReverse / http://localhost:5000/
  ServerName localhost
</VirtualHost>
------------------------------
Enable Virtual host files and restart apache
# a2ensite proxy-host
# /etc/init.d/apache2 restart
------------------------------------------
Enable SSL for proxy and restart apache
# a2enmod ssl
# /etc/init.d/apache2 restart
-------------------------------
Generating self-signed certificate
-----------------------------
# mkdir self-cert; cd self-cert
# openssl genrsa -out proxy.key 2048
# openssl req -nodes -new -key proxy.key -out proxy.csr
=== Making valid Generated keys and Cert === 
# openssl x509 -req -days 365 -in proxy.csr -signkey proxy.key -out proxy.crt
# mkdir /etc/apache2/ssl
# cp proxy.crt proxy.key proxy.csr /etc/apache2/ssl/
Creating ssl conf file
# vim /etc/apache2/sites-available/proxy-ssl-host.conf
==add this line==
<VirtualHost *:443>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        SSLEngine On
        =# Set the path to SSL certificate
        =# Usage: SSLCertificateFile /path/to/cert.pem and proxy.key files ##
        SSLCertificateFile /etc/apache2/ssl/proxy.crt
        SSLCertificateKeyFile /etc/apache2/ssl/proxy.key
        ProxyPreserveHost On
        ProxyPass / http://localhost:5000/
        ProxyPassReverse / http://localhost:5000/
        ServerName localhost
</VirtualHost>
---------------
Enable new virtual host
# a2ensite proxy-ssl-host.conf
# /etc/init.d/apache2 restart

Port Forwarding 80 to 443

we are goping to redirecting port 80 to 443
