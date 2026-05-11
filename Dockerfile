# ETAPA 1: Build de la aplicación Node
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# ETAPA 2: Servidor Web liviano para producción
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Limpiamos y copiamos los archivos construidos
RUN rm -rf ./*
COPY --from=build /app/dist . 

# El Frontend suele exponer el puerto 80 por defecto en Nginx
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]