# xb - worry-free MySQL backups for Docker

Automatically creates easily restorable Percona XtraBackup backups of your most important databases.

Currently only works with `mysql:5`, as Percona XtraBackup is currently incompatible with MySQL 8 and newer versions of MariaDB.

## Usage:
```yaml
version: "3"
services:
  database:
    image: mysql:5
    restart: always
    volumes: ["database-root:/var/lib/mysql", "database-socket:/var/run/mysqld", "database-config:/etc/mysql"]
    environment:
      MYSQL_ROOT_PASSWORD: helloworld123
  backup:
    image: momar/xb
    restart: always
    volumes: ["database-root:/var/lib/mysql", "database-socket:/var/run/mysqld", "database-config:/etc/mysql", "./database:/backup"]
    environment:
      BACKUP_EVERY_MINUTES: 30 # make an incremental backup every 30 minutes
      FULL_BACKUP_INTERVAL: 12 # every 12th backup should be a full backup (= every 6 hours)
      KEEP_FULL_BACKUPS: 6     # keep 6 full backups, delete everything older than that (= 36 hours)
      MYSQL_ROOT_PASSWORD: helloworld123 # required!
      ERROR_COMMAND: # called upon error - percona logs are in /var/log/xtrabackup.log
      SUCCESS_COMMAND: # called upon success - percona logs are in /var/log/xtrabackup.log

volumes:
  database-root:
  database-config:
  database-socket:
```

## Restore:
```bash
docker-compose stop # stop everything so we're not breaking anything
ls -1 database # list all available backups
docker-compose run --no-deps --rm backup restore 2019-06-02--22-49-00 # restore the backup
docker-compose up -d # start everything again
```
