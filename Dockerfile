# ETAPA 1: Build de la aplicación Node - Se encarga de transformar el código fuente (React/Next/Vue) en archivos estáticos.
# Se utiliza una imagen de Node.js versión 18 sobre Alpine Linux para mantener un entorno de construcción liviano.
FROM node:18-alpine AS build

# Se establece /app como el directorio de trabajo donde se procesará el proyecto.
WORKDIR /app

# Se transfieren los archivos de manifiesto (package.json y package-lock.json) para preparar la instalación de dependencias.
COPY package*.json ./

# Se ejecuta la instalación de todos los paquetes y librerías necesarios para el proyecto.
RUN npm install

# Se transfiere la totalidad del código fuente del frontend al entorno de construcción.
COPY . .

# Se ejecuta el script de construcción que genera la versión optimizada para producción en la carpeta /dist.
RUN npm run build

# ETAPA 2: Servidor Web liviano para producción - Se prepara el entorno final que servirá la web al usuario.
# Se utiliza Nginx (versión Alpine)
FROM nginx:alpine

# Se define el directorio estándar donde Nginx busca los archivos para servir a través de la web.
WORKDIR /usr/share/nginx/html

# Se eliminan los archivos por defecto que trae la imagen de Nginx para asegurar una instalación limpia.
RUN rm -rf ./*

# Se recuperan únicamente los archivos estáticos generados (HTML, JS, CSS) desde la etapa de construcción a la carpeta de Nginx.
COPY --from=build /app/dist . 

# Se documenta que este contenedor (el Frontend) opera sobre el puerto 80, que es el estándar para tráfico HTTP.
EXPOSE 80

# Se define el comando de inicio que mantiene a Nginx ejecutándose en primer plano para servir las peticiones de los usuarios.
CMD ["nginx", "-g", "daemon off;"]