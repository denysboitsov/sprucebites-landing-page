#! /bin/sh

sudo apt update && sudo apt upgrade
sudo apt -y install apache2
sudo apt -y install mariadb-server mariadb-client
sudo mysql --user=root <<_EOF_
  UPDATE mysql.user SET Password=PASSWORD('password') WHERE User='root';
  DELETE FROM mysql.user WHERE User='';
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
  DROP DATABASE IF EXISTS test;
  DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
  FLUSH PRIVILEGES;
_EOF_
sudo apt -y install php php-mysql