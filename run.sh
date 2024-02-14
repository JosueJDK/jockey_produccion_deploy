#!/bin/bash

# Nombres de los contenedores a eliminar
nombres_contenedores=("jockey_frontend" "backend_jockey" "auth_service_jockey")

# Función para detener y eliminar contenedores
function detener_y_eliminar_contenedor {
    if docker ps -a --format '{{.Names}}' | grep -q "$1"; then
        docker stop "$1" && docker rm "$1"
        echo "Contenedor ($1) detenido y eliminado correctamente."
    else
        echo "El Contenedor ($1) no existe."
    fi
}

# Función para eliminar imágenes
function eliminar_imagen {
    if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "$1"; then
        docker rmi "$1"
        echo "Imagen ($1) eliminada correctamente."
    else
        echo "La Imagen ($1) no existe."
    fi
}

echo "Deteniendo y eliminando contenedores específicos por nombre..."

# Iterar sobre los nombres de contenedores para detener y eliminar
for nombre_contenedor in "${nombres_contenedores[@]}"; do
    detener_y_eliminar_contenedor "$nombre_contenedor"
    eliminar_imagen "$nombre_contenedor" # Asumiendo que el nombre de la imagen es el mismo que el del contenedor
done


# Agrega más bloques if-else según sea necesario para cada contenedor que desees detener y eliminar

echo "Proceso de detención y eliminación completado."
echo " "
echo " "
echo "Proceso de recontrucion con docker build iniciado...."

sudo docker build -t backend_jockey ./backend/

sudo docker build -t auth_service_jockey ./auth_login_service/

echo " "
echo " "
echo "Proceso de ejecucion de contenedores con docker compose iniciado...."

sudo docker compose -f ./backend/docker-backend-compose.yml up -d

sudo docker compose -f ./frontend/docker-frontend-compose.yml up -d

sudo docker compose -f ./auth_login_service/docker-compose.yml up -d

echo "Servicios lenvantados correctamente"
