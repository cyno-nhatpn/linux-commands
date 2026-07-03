### Commands meant to be run as Root, need to be adjusted if run by a non-privileged user.

### Dump MariaDB one by one and archive into tar.gz in current directory, then remove leftover SQL files
```bash
for db in $(mysql -e "SHOW DATABASES;" | tail -n +2 | grep -vE "information_schema|performance_schema|mysql|sys"); do mysqldump "$db" > "${db}.sql"; done && sleep 2 && tar -czf "$(hostname)-wp-dbs.tar.gz" *.sql && rm *.sql
```

### Create table and load each into new databases
```bash
for f in *.sql; do mysql -e "CREATE DATABASE IF NOT EXISTS \`${f%.sql}\`;"; done && for f in *.sql; do mysql "${f%.sql}" < "$f"; done
```

### Generate Password
```bash
openssl rand -base64 24 | tr -d '/'
```

### Create user (if not exists) and set password

Replace `dbname` and `GENERATED_PASSWORD` before running:

```sql
CREATE USER IF NOT EXISTS 'dbname'@'localhost' IDENTIFIED BY 'GENERATED_PASSWORD';
```

If the user might already exist with a different password, update it too:

```sql
ALTER USER 'dbname'@'localhost' IDENTIFIED BY 'GENERATED_PASSWORD';
```

### Grant permissions on the DB

```sql
GRANT ALL PRIVILEGES ON dbname.* TO 'dbname'@'localhost';
```

```sql
FLUSH PRIVILEGES;
```

### Symlink nginx
```bash
ln -s /etc/nginx/sites-available/site_name /etc/nginx/sites-enabled/site_name
```

### wp command check domain ( Execute from wp root dir)
```bash
sudo -u www-data wp option get siteurl
```
```bash
sudo -u www-data wp option get home
````

### wp search-replace as www-data

```bash
sudo -u www-data wp search-replace 'https://old-domain.com' 'https://new-domain.com' --all-tables --path=/var/www/dbname
```

If you also need it to skip guessing and use `--precise` (safer for serialized data edge cases):

```bash
sudo -u www-data wp search-replace 'https://old-domain.com' 'https://new-domain.com' --all-tables --precise --path=/var/www/dbname
```
