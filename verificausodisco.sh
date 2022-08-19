#!/bin/bash
#
#script verificadisco.sh
# Version : 1.0
#Para verificar disco de un servidor y ejecutar una accion y notificación a telegram
#Autor : Ing. Jorge Navarrete
#mail : jorge_n@web.de
#Fecha : 2019-02-19
#script verificadisco.sh

#===========================================================================
PATH=/bin:/usr/bin:/usr/sbin/
#===========================================================================

TOKEN="569774679:AAEl8uSwPNDzHwM_MCCR1-iXi4C6zLGeoqU"
IDJN="152054272"
IDdiego="966225514"
# para no verificar ciertos volumenes o particiones
df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 " " $2 " " $3 " " $4}' | while read output;
do
  echo $output
  usoparticion=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  tamaniodisco=$(echo $output | awk '{ print $3}' | cut -d'%' -f1  )
  usodisco=$(echo $output | awk '{ print $4}' | cut -d'%' -f1  )
  disponibledisco=$(echo $output | awk '{ print $5}' | cut -d'%' -f1  )
  particion=$(echo $output | awk '{ print $2 }' )
  if [ $usoparticion -ge 75 ]; then
    MENSAJE=`echo "Aletar de espacio en disco \"$particion ($usoparticion%)  Tamanio: $tamaniodisco  Usado: $usodisco  Disponible: $disponibledisco \" en $(hostname) a la fecha $(date)"` #|
   #  mail -s "Alert: Almost out of disk space $usep%" you@somewhere.com

        URL="https://api.telegram.org/bot$TOKEN/sendMessage"
        curl -s -X POST $URL -d chat_id=$IDJN -d text="$MENSAJE"  > /dev/null
#        curl -s -X POST $URL -d chat_id=$IDdiego -d text="$MENSAJE"  > /dev/null
  fi
done

