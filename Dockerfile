FROM ehdevops/action-deploy:0.0.1
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
