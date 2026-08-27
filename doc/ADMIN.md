The app install dir is `__INSTALL_DIR__`.

Drupal CMS is installed here with the web root at `__INSTALL_DIR__/web`, Composer
dependencies at `__INSTALL_DIR__/vendor`, and the site template recipes at
`__INSTALL_DIR__/recipes`.

## Running drush

```bash
sudo -u __APP__ env PATH=__INSTALL_DIR__/vendor/bin:$PATH DRUSH_PHP=/usr/bin/php__PHP_VERSION__ drush @__APP__ status
```

## Applying another site template or recipe

The starter template is applied at install time. The other recipes shipped by
Drupal CMS are already on disk and can be applied afterwards, for example:

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
