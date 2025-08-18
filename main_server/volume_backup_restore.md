# Restoring Main Server Volume Backups

[Setup directions here](/volume_backup_restore.md)

```bash
sudo bash
```

```bash
docker run -d --name temp_restore_container \
-v mqtt_broker_config:/backup_restore/mqtt_broker_config \
-v mqtt_broker_data:/backup_restore/mqtt_broker_data \
-v mqtt_broker_log:/backup_restore/mqtt_broker_log \
-v postgresql_data:/backup_restore/postgresql_data \
-v keg_monitor_app_data:/backup_restore/keg_monitor_app_data \
-v pgadmin_data:/backup_restore/pgadmin_data \
-v file_browser_data:/backup_restore/file_browser_data \
-v plex_server_config:/backup_restore/plex_server_config \
-v portainer_data:/backup_restore/portainer_data \
-v home_assistant_data:/backup_restore/home_assistant_data \
-v nginx_proxy_config:/backup_restore/nginx_proxy_config \
-v nginx_proxy_data:/backup_restore/nginx_proxy_data \
-v nginx_proxy_letsencrypt:/backup_restore/nginx_proxy_letsencrypt \
-v pi_hole_dnsmasq:/backup_restore/pi_hole_dnsmasq \
alpine

docker cp /tmp/backup/mqtt_broker_config/. temp_restore_container:/backup_restore/mqtt_broker_config
docker cp /tmp/backup/mqtt_broker_data/. temp_restore_container:/backup_restore/mqtt_broker_data
docker cp /tmp/backup/mqtt_broker_log/. temp_restore_container:/backup_restore/mqtt_broker_log
docker cp /tmp/backup/postgresql_data/. temp_restore_container:/backup_restore/postgresql_data
docker cp /tmp/backup/keg_monitor_app_data/. temp_restore_container:/backup_restore/keg_monitor_app_data
docker cp /tmp/backup/pgadmin/. temp_restore_container:/backup_restore/pgadmin_data
docker cp /tmp/backup/file_browser_data/. temp_restore_container:/backup_restore/file_browser_data
docker cp /tmp/backup/plex_server_config/. temp_restore_container:/backup_restore/plex_server_config
docker cp /tmp/backup/portainer_data/. temp_restore_container:/backup_restore/portainer_data
docker cp /tmp/backup/home_assistant_data/. temp_restore_container:/backup_restore/home_assistant_data
docker cp /tmp/backup/nginx_proxy_config/. temp_restore_container:/backup_restore/nginx_proxy_config
docker cp /tmp/backup/nginx_proxy_data/. temp_restore_container:/backup_restore/nginx_proxy_data
docker cp /tmp/backup/nginx_proxy_letsencrypt/. temp_restore_container:/backup_restore/nginx_proxy_letsencrypt
docker cp /tmp/backup/pi_hole_dnsmasq/. temp_restore_container:/backup_restore/pi_hole_dnsmasq

docker stop temp_restore_container
docker rm temp_restore_container
```
