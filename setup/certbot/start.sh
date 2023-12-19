#!/bin/sh

# Generate SSL certificate if it doesn't exist
FULLCHAIN=/etc/letsencrypt/live/${HOSTNAME}/fullchain.pem
PRIVKEY=/etc/letsencrypt/live/${HOSTNAME}/privkey.pem

if [ ! -f ${FULLCHAIN} ] || [ ! -f ${PRIVKEY} ]; then
    certbot certonly --webroot --webroot-path /var/www/certbot/ -d ${HOSTNAME} -d www.${HOSTNAME} --non-interactive --agree-tos -m ${CERT_EMAIL}
    # certbot certonly --webroot --webroot-path /var/www/certbot/ -d ${HOSTNAME} -d www.${HOSTNAME} -d mail.${HOSTNAME} --non-interactive --agree-tos -m ${CERT_EMAIL}
fi

# Every 12h, check if the certificate on the server will expire
# within the next 30 days, and renew it if so.
trap exit TERM

while true
do
  certbot renew --quiet
  sleep 12h & wait ${!}
done