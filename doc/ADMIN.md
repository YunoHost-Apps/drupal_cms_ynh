The app install dir is `__INSTALL_DIR__`

If you need to install a Drupal module, the command line should be something like:
```
sudo -E -u __APP__ php__PHP_VERSION__ __INSTALL_DIR__/composer.phar require 'drupal/admin_toolbar:^3.6' -d __INSTALL_DIR__ --no-cache
```

If you need to update Drupal, the command line should be something like:
```
sudo -E -u __APP__ php__PHP_VERSION__ __INSTALL_DIR__/composer.phar update --with-all-dependencies -d __INSTALL_DIR__ --no-cache
sudo -u __APP__ env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin COREPACK_ENABLE_DOWNLOAD_PROMPT=0 NPM_CONFIG_UPDATE_NOTIFIER=false env PATH=__INSTALL_DIR__/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin DRUSH_PHP=/usr/bin/__PHP_VERSION__ drush @__APP__ updatedb
sudo -u __APP__ env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin COREPACK_ENABLE_DOWNLOAD_PROMPT=0 NPM_CONFIG_UPDATE_NOTIFIER=false env PATH=__INSTALL_DIR__/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin DRUSH_PHP=/usr/bin/__PHP_VERSION__ drush @__APP__ cache:rebuild
```
