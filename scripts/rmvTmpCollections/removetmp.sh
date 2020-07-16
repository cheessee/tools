#!/bin/bash

#source /datadrive/onesaitplatform/scripts/config.properties

SCRIPT_PATH=/datadrive/onesaitplatform/scripts/script.js
LOG_PATH=/mnt/resource/script_logs/

DOCKERPATH=$(docker ps | grep realtimedb | awk '{print $1}')

echo "###########################" >> ${LOG_PATH}mongocleanup.log
echo "### `date +"%d-%m-%Y"T"%H:%M:%S"` ###" >> ${LOG_PATH}mongocleanup.log
echo "###########################" >> ${LOG_PATH}mongocleanup.log

#Copia el archivo .js al /tmp del contenedor
docker cp ${SCRIPT_PATH} ${DOCKERPATH}:/tmp/ >> ${LOG_PATH}mongocleanup.log

#Ejecuta el script con comandos Mongo
docker exec -u root ${DOCKERPATH} mongo /tmp/script.js >> ${LOG_PATH}mongocleanup.log

exit 0

