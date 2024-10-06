#! /bin/sh

sudo apt -qq update && sudo apt -qq upgrade
sudo apt -qq -y install apache2
sudo apt -qq -y install mariadb-server mariadb-client
sudo mysql --user=root <<_EOF_
  DELETE FROM mysql.user WHERE User='';
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
  DROP DATABASE IF EXISTS test;
  DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
  FLUSH PRIVILEGES;
_EOF_
sudo apt -qq -y install php php-mysql
sudo mysql --user=root <<_EOF_
    CREATE DATABASE wordpress_db;
    CREATE USER 'wp_user'@'localhost' IDENTIFIED BY '$1';
    GRANT ALL ON wordpress_db.* TO 'wp_user'@'localhost' IDENTIFIED BY '$1';
    FLUSH PRIVILEGES;
_EOF_
cd /tmp && wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
sudo cp -R wordpress /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress/
sudo chmod -R 755 /var/www/html/wordpress/
sudo mkdir /var/www/html/wordpress/wp-content/uploads
sudo chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads/
sudo mv -R /var/www/html/wordpress/* /var/www/html/

echo "DB name: wordpress_db"
echo "DB user: wp_user"