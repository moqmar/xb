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
      BACKUP_EVERY_MINUTES: 180  # make an incremental backup every 3 hours minutes
      FULL_BACKUP_INTERVAL: 8  # every 8th backup should be a full backup (= every 24 hours)
      KEEP_FULL_BACKUPS: 3  # keep 3 full backups, delete everything older than that (= 2-3 days)
      MYSQL_ROOT_PASSWORD: helloworld123  # required!
      ERROR_COMMAND:  # called upon error - percona logs are in /var/log/xtrabackup.log
      SUCCESS_COMMAND:  # called upon success - percona logs are in /var/log/xtrabackup.log

volumes:
  database-root:
  database-config:
  database-socket:
```

## Restore:
```bash
docker-compose stop # stop everything so we're not breaking anything
docker-compose run --rm backup restore # interactively list all available backups & restore one of them
docker-compose up -d # start everything again
```

With `docker-compose run --rm backup restore <subdirectory>`, you can non-interactively restore a specific backup.
