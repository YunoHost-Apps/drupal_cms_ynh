#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

_ynh_exec_with_drush_php() {
    ynh_hide_warnings ynh_exec_as_app \
        env PATH="$install_dir/vendor/bin:$PATH" \
        DRUSH_PHP="/usr/bin/php$php_version" \
        "$@"
}

# Give nginx (www-data) read access to the tree it serves static files from.
#
# php-fpm runs as $app and can always read install_dir, so a missing grant here
# does not stop pages from rendering: PHP keeps working while every CSS, JS and
# image URL 404s, because nginx's try_files cannot stat the file and falls
# through to index.php. The whole chain has to be traversable, not just the
# webroot symlink directory.
_ynh_grant_webserver_access() {
    # install_dir itself is $app:$app 0750 by default, which blocks www-data at
    # the very first hop.
    chgrp www-data "$install_dir"
    chmod g+x "$install_dir"

    chgrp -R www-data "$install_dir/web"
    chmod -R g+rX "$install_dir/web"

    # Files Drupal writes at runtime (uploads, image derivatives) are created by
    # php-fpm as $app. setgid on the directories makes them inherit the www-data
    # group so nginx can serve them without re-running this helper.
    if [ -d "$install_dir/web/sites/default/files" ]; then
        chmod -R g+rwX "$install_dir/web/sites/default/files"
        find "$install_dir/web/sites/default/files" -type d -exec chmod g+s {} +
    fi

    # The database credentials do not need to be readable by nginx.
    if [ -e "$install_dir/web/sites/default/settings.php" ]; then
        chgrp "$app" "$install_dir/web/sites/default/settings.php"
        chmod 640 "$install_dir/web/sites/default/settings.php"
    fi
}

# Build the symlink tree that conf/nginx.conf points "root" at.
#
# nginx cannot reliably resolve try_files against "alias", so instead of
# aliasing __PATH__ onto web/ we mirror the sub-path on disk and use "root".
# Sets the "webroot" app setting, consumed as __WEBROOT__ by the template.
_ynh_setup_webroot() {
    local app_path="${1:-$path}"

    if [ "$app_path" = "/" ]; then
        # Installed at the domain root: no symlink needed.
        webroot="$install_dir/web"
        ynh_app_setting_set --key=webroot --value="$webroot"
        _ynh_grant_webserver_access
        return
    fi

    ynh_safe_rm "$install_dir/webroot"
    install -d -m 750 -o "$app" -g www-data "$install_dir/webroot$(dirname "$app_path")"
    ln -sfn "$install_dir/web" "$install_dir/webroot$app_path"
    chown -h "$app:www-data" "$install_dir/webroot$app_path"

    # Assign the shell variable as well, not just the setting: ynh_config_add
    # substitutes __WEBROOT__ from the running shell's variables, and a setting
    # written mid-script is not exported back into it.
    webroot="$install_dir/webroot"
    ynh_app_setting_set --key=webroot --value="$webroot"

    _ynh_grant_webserver_access
}

# Point settings.php's trusted_host_patterns at $1 (defaults to $domain).
#
# The pattern is a regex, so the dots are escaped: matching or replacing the
# bare domain string in this file does not work. Rewrite the whole line, and
# append it if a settings.php from an older version does not have one.
_ynh_set_trusted_host() {
    local host="${1:-$domain}"
    local settings="$install_dir/web/sites/default/settings.php"
    local escaped="${host//./\\.}"
    local line="\$settings['trusted_host_patterns'] = ['^${escaped}\$'];"

    chmod u+w "$settings"

    if grep -q "^\$settings\['trusted_host_patterns'\]" "$settings"; then
        sed -i "s|^\$settings\['trusted_host_patterns'\].*|${line}|" "$settings"
    else
        echo "$line" >> "$settings"
    fi

    chmod 0640 "$settings"
    ynh_delete_file_checksum "$settings"
    ynh_store_file_checksum "$settings"
}
