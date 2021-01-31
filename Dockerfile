FROM ubuntu:focal
ENV TZ=Europe/Amsterdam
WORKDIR /var/www/
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get install rsyslog git net-tools lshw dos2unix apache2 \
    python3-pip g++ freetype2-demos libatlas-base-dev apache2-ssl-dev netcat python3 \
    python3-ldap libpq-dev python-dev libpython2-dev libxml2-dev libxslt1-dev libldap2-dev \
    libsasl2-dev libffi-dev python3-dev libssl-dev gcc rsync ansible \
    libpng-dev libqhull-dev libfreetype6-dev libagg-dev pkg-config nmap -y
RUN git clone https://github.com/Aidaho12/haproxy-wi.git /var/www/haproxy-wi
RUN chown -R www-data:www-data haproxy-wi/
RUN sed -i 's/^.*ErrorLog.*/    ErrorLog \/var\/log\/apache2\/haproxy-wi.error.log/' haproxy-wi/config_other/httpd/haproxy-wi.conf
RUN sed -i 's/^.*CustomLog.*/    CustomLog \/var\/log\/apache2\/haproxy-wi.access.log combined/' haproxy-wi/config_other/httpd/haproxy-wi.conf
RUN cp haproxy-wi/config_other/httpd/* /etc/apache2/sites-available/
RUN a2ensite haproxy-wi.conf
RUN a2enmod cgid
RUN a2enmod ssl
RUN pip3 install -r haproxy-wi/requirements.txt
RUN chmod +x haproxy-wi/app/*.py 
RUN cp haproxy-wi/config_other/logrotate/* /etc/logrotate.d/
RUN cp haproxy-wi/config_other/syslog/* /etc/rsyslog.d/
# RUN systemctl daemon-reload 
# RUN systemctl restart httpd
# RUN systemctl restart rsyslog
# RUN mkdir /var/www/haproxy-wi/app/certs
RUN mkdir /var/www/haproxy-wi/keys
RUN mkdir /var/www/haproxy-wi/configs/
RUN mkdir /var/www/haproxy-wi/configs/hap_config/
RUN mkdir /var/www/haproxy-wi/configs/kp_config/
RUN mkdir /var/www/haproxy-wi/configs/nginx_config/
RUN mkdir /var/www/haproxy-wi/log/
RUN chown -R www-data:www-data /var/www/haproxy-wi/
RUN cd /var/www/haproxy-wi/app && ./create_db.py
RUN chown -R www-data:www-data /var/www/haproxy-wi/
EXPOSE 443
VOLUME /var/www/haproxy-wi/
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
