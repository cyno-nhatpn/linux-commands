# Commands meant to be run as Root, need to be adjusted if run by a non-privileged user.

# Dump MariaDB one by one and archive into tar.gz in current directory, then remove leftover SQL files
```bash
for db in $(mysql -e "SHOW DATABASES;" | tail -n +2 | grep -vE "information_schema|performance_schema|mysql|sys"); do mysqldump "$db" > "${db}.sql"; done && sleep 2 && tar -czf "$(hostname)-wp-dbs.tar.gz" *.sql && rm *.sql
```

# Create table and load each into new databases
```bash
for f in *.sql; do mysql -e "CREATE DATABASE IF NOT EXISTS \`${f%.sql}\`;"; done && for f in *.sql; do mysql "${f%.sql}" < "$f"; done
```
