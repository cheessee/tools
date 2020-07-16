#!/bin/bash

openssl req \
         -nodes \
         -x509 \
         -newkey rsa:2048 \
         -days 365 \
         -subj /C=ES/ST=Madrid/L=Minsait/O=Indra \
         -keyout /datadrive/onesaitplatform/nginx/certs/caplatform.key \
         -out /datadrive/onesaitplatform/nginx/certs/caplatform.crt

openssl genrsa \
         -out /datadrive/onesaitplatform/nginx/certs/server.key 2048

openssl req \
         -new \
         -config /datadrive/onesaitplatform/nginx/openssl.cnf \
         -key /datadrive/onesaitplatform/nginx/certs/server.key \
         -out /datadrive/onesaitplatform/nginx/certs/server.csr

openssl x509 \
         -CA /datadrive/onesaitplatform/nginx/certs/caplatform.crt \
         -CAkey /datadrive/onesaitplatform/nginx/certs/caplatform.key \
         -req \
         -in /datadrive/onesaitplatform/nginx/certs/server.csr \
         -days 365 \
         -CAcreateserial \
         -extensions v3_req \
         -extfile /datadrive/onesaitplatform/nginx/openssl.cnf \
         -out /datadrive/onesaitplatform/nginx/certs/platform.crt