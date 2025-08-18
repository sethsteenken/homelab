# Restoring Volume Backups

[Volume Backups docker image](https://hub.docker.com/r/offen/docker-volume-backup)

Copy *tar.gz package to the server via [PSCP](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

Extract contents:

```bash
tar -C /tmp -xvf  backup.tar.gz
```

Run temp container with mounted volume and copy files from extracted backup. Do this for all named volumes. In this example *data* is the named volume.

```bash
docker run -d --name temp_restore_container -v data:/backup_restore alpine

docker cp /tmp/backup/data/. temp_restore_container:/backup_restore 

docker stop temp_restore_container
docker rm temp_restore_container
```
