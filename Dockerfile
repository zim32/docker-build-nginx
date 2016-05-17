FROM zim32/debian:v1

RUN apt-get update && apt-get install -y nginx

RUN \
	rm /etc/nginx/sites-enabled/default && \
	mkdir /home/zim32/www && \
	chown -R zim32:zim32 /home/zim32

COPY copy/ /

CMD ["/bin/bash", "/root/start_all.sh"]

EXPOSE 80
