Buena pregunta — puedes recuperar espacio en Docker eliminando imágenes, contenedores detenidos y caché de compilación sin tocar las bases de datos si estas últimas están guardadas en volúmenes o en montajes persistentes. Aquí tienes un procedimiento seguro y los comandos clave, con advertencias:

1) Verifica el uso actual (qué ocupa espacio)
- Muestra resumen de uso:
```
docker system df
```
- Lista imágenes (útiles para identificar las que eliminarás):
```
docker images
```
- Lista contenedores (verifica cuáles están en ejecución):
```
docker ps -a
```
- Lista volúmenes (para confirmar que tus volúmenes de BD existen):
```
docker volume ls
```

2) Asegúrate de que tus datos importantes estén en volúmenes
- Si tu base de datos usa un volumen nombrado o un bind-mount, no se borrará con la limpieza de imágenes. Si no estás seguro, inspecciona el contenedor de la BD:
```
docker inspect <nombre_o_id_del_contenedor> --format '{{json .Mounts}}' | jq
```
(Alternativa: docker inspect <container> y busca "Mounts".)

Si tus datos NO están en un volumen (por ejemplo, se escribieron dentro del contenedor sin volumen), haz backup antes de eliminar nada.

3) Hacer backup de un volumen (opcional, recomendado)
```
# ejemplo: respaldo del volumen my_db_volume a un archivo en el host
docker run --rm -v my_db_volume:/data -v $(pwd):/backup alpine \
  sh -c "cd /data && tar czf /backup/my_db_volume_backup.tar.gz ."
```
(En PowerShell usa ${PWD} o especifica ruta completa en lugar de $(pwd).)

4) Eliminar sólo "dangling" (capas huérfanas) — seguro y rápido
```
# elimina imágenes colgantes (dangling) — capas sin etiqueta
docker image prune -f
```

5) Eliminar contenedores detenidos y caché de construcción (sin tocar volúmenes)
```
# elimina contenedores detenidos
docker container prune -f

# elimina cache de build (buildx / builder)
docker builder prune -f           # limpia cache inactiva
# o para eliminar todo (más agresivo)
docker builder prune -af
```

6) Eliminar imágenes no usadas (más agresivo)
- Esto borra todas las imágenes que no están asociadas a contenedores en ejecución. No toca volúmenes.
```
docker image prune -a -f
```
- Antes de usar -a, revisa `docker images` para no eliminar imágenes que quieras conservar (las podrás volver a descargar).

7) Resumen "toda la limpieza" (usa con precaución)
```
# elimina contenedores detenidos, networks no usados, imágenes dangling y build cache
docker system prune -f

# con -a también elimina imágenes no usadas
docker system prune -a -f
```
NO ejecutes `docker system prune --volumes` ni `docker volume prune` si no quieres borrar volúmenes con datos importantes.

8) Casos con docker-compose
- docker-compose down no elimina volúmenes a menos que pases -v:
```
docker-compose down        # deja volúmenes
docker-compose down -v     # ELIMINA volúmenes (no hacer si contienen BD)
docker-compose down --rmi local   # elimina imágenes creadas localmente, no volúmenes
```

Puntos críticos de seguridad
- Las operaciones de prune no tocan volúmenes a menos que uses explícitamente las opciones o ejecutes `docker volume prune` o `--volumes`.
- Si tu BD vive dentro del contenedor sin volumen, perderás datos al eliminar el contenedor; haz backup.
- Eliminar imágenes en uso por contenedores en ejecución no funcionará hasta detener esos contenedores.

Si quieres, dime:
- si usas docker-compose y el nombre del servicio de la BD,
- o ejecuta `docker ps -a` y `docker volume ls` y te ayudo a identificar qué es seguro eliminar.
