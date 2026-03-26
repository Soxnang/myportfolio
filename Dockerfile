FROM nginx:alpine

COPY src/index.html /usr/share/nginx/html/index.html
COPY assets/css/style.css /usr/share/nginx/html/assets/css/style.css

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
