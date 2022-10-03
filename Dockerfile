FROM ehdevops/action-deploy:1.0.0
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]
