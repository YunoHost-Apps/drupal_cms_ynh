The app install dir is `__INSTALL_DIR__`.

## Admin account

The site is installed during `yunohost app install`, with the starter site
template (`drupal_cms_starter`) applied. The admin account is the YunoHost user
picked at install time; its generated password is stored as an app setting:

```bash
sudo yunohost app setting __APP__ admin_password
```

Change it with `drush user:password`, or get a one-time login link with:

```bash
sudo -u __APP__ env PATH=__INSTALL_DIR__/vendor/bin:$PATH DRUSH_PHP=/usr/bin/php__PHP_VERSION__ drush @__APP__ user:login
```

Drupal CMS is installed here with the web root at `__INSTALL_DIR__/web`, Composer
dependencies at `__INSTALL_DIR__/vendor`, and the site template recipes at
`__INSTALL_DIR__/recipes`.

## Running drush

```bash
sudo -u __APP__ env PATH=__INSTALL_DIR__/vendor/bin:$PATH DRUSH_PHP=/usr/bin/php__PHP_VERSION__ drush @__APP__ status
```

## Applying another recipe

The starter site template is applied at install time. The other recipes shipped
by Drupal CMS are already on disk and can be applied afterwards, for example:

```bash
sudo -u __APP__ env PATH=__INSTALL_DIR__/vendor/bin:$PATH DRUSH_PHP=/usr/bin/php__PHP_VERSION__ drush @__APP__ recipe __INSTALL_DIR__/recipes/drupal_cms_seo_tools
```

## Installing an extra module

```bash
sudo -E -u __APP__ php__PHP_VERSION__ __INSTALL_DIR__/composer.phar require 'drupal/admin_toolbar:^3.6' -d __INSTALL_DIR__ --no-cache
```

## Updating

Prefer `yunohost app upgrade __APP__`, which runs the same steps in the right
order. Drupal CMS ships the Automatic Updates module, but in-place updates from
the web UI are not recommended here: they would put the codebase out of sync with
what the YunoHost package expects.
