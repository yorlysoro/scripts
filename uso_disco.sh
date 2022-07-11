#!/bin/bash
# Verificar la cantidad de espacio
# Desarrollado para platzi by  Jhon Edison Castro Sánchez @edisoncast


CWD=$(pwd)
FECHA=$(date +"%F%T")
echo $fecha

df -h | grep S. > uso_disco_"$FECHA".txt
df -h | grep /dev/mapper/ubuntu--vg-root >> uso_disco_"$FECHA".txt

echo "Se ha generado un archivo con nombre uso_disco$FECHA.txt en la ubicacion $CWD" 