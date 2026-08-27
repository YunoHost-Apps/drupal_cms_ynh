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

# Build the symlink tree that conf/nginx.conf points "root" at.
#
# nginx cannot reliably resolve try_files against "alias", so instead of
# aliasing __PATH__ onto web/ we mirror the sub-path on disk and use "root".
# Sets the "webroot" app setting, consumed as __WEBROOT__ by the template.
_ynh_setup_webroot() {
    local app_path="${1:-$path}"

    if [ "$app_path" = "/" ]; then
        # Installed at the domain root: no symlink needed.
        ynh_app_setting_set --key=webroot --value="$install_dir/web"
        return
    fi

    ynh_safe_rm "$install_dir/webroot"
    install -d -m 750 -o "$app" -g www-data "$install_dir/webroot$(dirname "$app_path")"
    ln -sfn "$install_dir/web" "$install_dir/webroot$app_path"
    chown -h "$app:www-data" "$install_dir/webroot$app_path"

    ynh_app_setting_set --key=webroot --value="$install_dir/webroot"
}
