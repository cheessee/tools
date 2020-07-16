#!/bin/bash

#
# Copyright Indra Sistemas, S.A.
# 2013-2018 SPAIN
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#      http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ------------------------------------------------------------------------

source config.properties
#export DOCKER_HOST=localhost:2375/

configdbBackupAndRestore()
{
	docker exec ${CONFIGDB} mysqldump --max_allowed_packet=512M -u ${SQLUSER} --password=${SQLPASS} onesaitplatform_config > "/home/axposa/onesaitplatform_scripts/backups/data/onesaitplatform_config.sql"
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Transferring configdb data.."
	docker cp /home/axposa/onesaitplatform_scripts/backups/data/onesaitplatform_config.sql ${ENDING_CONFIGDB}:/tmp/
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Done!"
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Restoring..."
	docker exec ${ENDING_CONFIGDB} bash -c 'mysql -u root --password=changeIt! onesaitplatform_config < /home/axposa/onesaitplatform_scripts/backups/data/onesaitplatform_config.sql'
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Done!"
}

configdbBackup()
{
    	docker exec ${CONFIGDB} mysqldump --max_allowed_packet=512M -u ${SQLUSER} --password=${SQLPASS} onesaitplatform_config > "/home/axposa/onesaitplatform_scripts/backups/data/onesaitplatform_config.sql"
}

realtimedbBackupAndRestore()
{
	docker exec ${REALTIMEDB} mongodump -u platformadmin -p 0pen-platf0rm-2018! --authenticationDatabase admin --db onesaitplatform_rtdb --out /tmp
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Transferring realtimedb data.."
	docker cp ${REALTIMEDB}:/tmp/onesaitplatform_rtdb /home/axposa/onesaitplatform_scripts/backups/data/
	docker cp /home/axposa/onesaitplatform_scripts/backups/data/onesaitplatform_rtdb ${ENDING_REALTIMEDB}:/tmp/
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Done!"
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Restoring..."
	docker exec ${ENDING_REALTIMEDB} mongorestore -u platformadmin -p 0pen-platf0rm-2018! --authenticationDatabase admin --db onesaitplatform_rtdb --drop /tmp/onesaitplatform_rtdb
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Done!"

}

realtimedbBackup()
{
    	docker exec ${REALTIMEDB} mongodump -u platformadmin -p 0pen-platf0rm-2018! --authenticationDatabase admin --db onesaitplatform_rtdb --out /tmp
    	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Transferring realtimedb data.."
 	docker cp ${REALTIMEDB}:/tmp/onesaitplatform_rtdb /home/axposa/onesaitplatform_scripts/backups/data/
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Done!"

}

volumeCopy()
{
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Copying persistent volumes..."
	cp -R /datadrive/onesaitplatform-rc17/flowengine ${DATADISK}
	cp -R /datadrive/onesaitplatform-rc17/nginx ${DATADISK}
	cp -R /datadrive/onesaitplatform-rc17/streamsets ${DATADISK}
	cp -R /datadrive/onesaitplatform-rc17/webprojects ${DATADISK}
	cp -R /datadrive/onesaitplatform-rc17/zeppelin ${DATADISK}
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Copied!!!"
}

zipBackup()
{
	cd ${DATADISK}/..
	zip -r `date +OneSaitPlatformBackup-"%d-%m-%Y"`.zip ${BACKUPDIR}
}

removeOlddata()
{
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Removing old data..."
	find ${DATADISK}/.. -name "*.zip" -cmin +120 -type f -print -delete
	echo "`date +"%d-%m-%Y"T"%H:%M:%S"`.000+0000 Removed!!!"
}


volumeCopy
realtimedbBackup
configdbBackup
zipBackup
removeOlddata
