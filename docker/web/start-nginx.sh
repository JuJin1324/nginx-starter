docker build --tag starter/nginx:1.0-local .; \
docker run -d \
-p 80:80 \
--name web-nginx-starter \
starter/nginx:1.0-local
