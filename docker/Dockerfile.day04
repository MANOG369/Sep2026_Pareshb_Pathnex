FROM ubuntu:22.04

RUN apt update && apt install apache2 -y

RUN echo "Hello Pathnex" > /var/www/html/index.html

CMD ["apachectl", "-D", "FOREGROUND"]
