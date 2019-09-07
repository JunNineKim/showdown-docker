#!/bin/sh
echo " _                                            _ ";
echo "| |__   __ _ _ __  _   _  __ _ ______ ___   _(_)";
echo "| '_ \ / _\` | '_ \| | | |/ _\` |_  / _\` \ \ / / |";
echo "| |_) | (_| | | | | |_| | (_| |/ / (_| |\ V /| |";
echo "|_.__/ \__,_|_| |_|\__, |\__,_/___\__,_| \_/ |_|";
echo "                   |___/                        ";

# Initial settings
ls /home/banya
if [ $? -ne 0 ];then

  ## Create user:group
  echo "zavi:x:$PGID:" >> /etc/group
  echo "zavi:x:$PGID:" >> /etc/group-
  echo "banya:x:$PUID:$PGID:banya:/home/banya:/bin/ash" >> /etc/passwd
  echo "banya:x:$PUID:$PGID:banya:/home/banya:/bin/ash" >> /etc/passwd-
  echo "banya:!::0:::::" >> /etc/shadow
  echo "banya:!::0:::::" >> /etc/shadow-

  mkdir -p /home/banya
  chown banya:zavi -R /home/banya
  chmod 755 -R /home/banya 

  ## Set for php-fpm
  PHP_FPM_USER="nginx"
  PHP_FPM_GROUP="nginx"
  PHP_FPM_LISTEN_MODE="0660"
  PHP_MEMORY_LIMIT="512M"
  PHP_MAX_UPLOAD="50M"
  PHP_MAX_FILE_UPLOAD="200"
  PHP_MAX_POST="100M"
  PHP_DISPLAY_ERRORS="On"
  PHP_DISPLAY_STARTUP_ERRORS="On"
  PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
  PHP_CGI_FIX_PATHINFO=0

  sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf
  sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf
  sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.d/www.conf
  sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf
  sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf
  sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.d/www.conf #uncommenting line 

  sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini
  sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini
  sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini
  sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini
  sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini
  sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini
  sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini
  sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini

fi

# Set transmission directories and settings.json
mkdir -p /transmission/downloads/complete /transmission/downloads/incomplete /transmission/watch /transmission/config
if [[ ! -f /transmission/config/settings.json ]]; then
  if [[ -f /transmission/settings.json ]]; then
    cp /transmission/settings.json /transmission/config/settings.json
  else
    cp /settings.json /transmission/config/settings.json
  fi
fi

# Set permission
chmod -R 777 /showdown /showdown-manager
chmod -R $PERMISSION /transmission /output
chown -R root:users /showdown /showdown-manager
chown -R $PUID:$PGID /transmission /output

# Run services
su - banya -c "transmission-daemon -g /transmission/config"
php-fpm7
nginx

cd /showdown
java -jar Server.jar
