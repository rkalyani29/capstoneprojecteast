FROM nginx

RUN rm /usr/share/nginx/html/index.html

# Copy source code(index.html) to nginx html directory
COPY index.html /usr/share/nginx/html

