The app install dir is `__INSTALL_DIR__`.

## First run: the setup wizard

This package installs the Drupal CMS codebase and seeds `settings.php` with the
database credentials, but it does **not** install the site. Open
`https://__DOMAIN____PATH__` in a browser to run the Drupal CMS setup wizard,
which asks for a site name, a site template (Starter, Byte, Haven) and the admin
account. See <https://project.pages.drupalcode.org/drupal_cms/get-started/setup/>.

Until the wizard has been completed the site is not usable and the hourly cron
job will do nothing.

Once the wizard has finished, lock the settings directory back down:

```bash
sudo chmod 0550 __INSTALL_DIR__/web/sites/default
sudo chmod 0440 __INSTALL_DIR__/web/sites/default/settings.php
```

Drupal CMS is installed here with the web root at `__INSTALL_DIR__/web`, Composer
dependencies at `__INSTALL_DIR__/vendor`, and the site template recipes at
`__INSTALL_DIR__/recipes`.

## Running drush

```bash
sudo -u __APP__ env PATH=__INSTALL_DIR__/vendor/bin:$PATH DRUSH_PHP=/usr/bin/php__PHP_VERSION__ drush @__APP__ status
```

## Applying another recipe

The site template is chosen in the setup wizard. The other recipes shipped by
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
