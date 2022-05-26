FROM ekho/nginx-lua
COPY etc/nginx/conf.d/ /etc/nginx/conf.d
COPY docker-entrypoint.sh /
RUN mkdir /libraries && \
    mkdir -p /etc/nginx/html && \
    ln -s /libraries /etc/nginx/html/libraries && \
    chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 8001