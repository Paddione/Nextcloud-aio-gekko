bashCopy# Set nginx-proxy-manager as a trusted proxy
docker exec -u www-data nextcloud-aio-nextcloud /usr/local/bin/php occ config:system:set trusted_proxies 0 --value="nginx-proxy-manager"

# Tell Nextcloud to always use HTTPS for external connections
docker exec -u www-data nextcloud-aio-nextcloud /usr/local/bin/php occ config:system:set overwriteprotocol --value="https"

# Set the correct hostname that Nextcloud should use
docker exec -u www-data nextcloud-aio-nextcloud /usr/local/bin/php occ config:system:set overwritehost --value="nextcloud.mentolder.de"

# Tell Nextcloud to trust connections coming from your Docker network
docker exec -u www-data nextcloud-aio-nextcloud /usr/local/bin/php occ config:system:set overwritecondaddr --value="^172\.18\."

# Next, let's configure the Collabora (Rich Documents) integration. This ensures that document editing works correctly through your secure connection:
# bashCopy# Configure the Collabora service endpoint
docker exec -u www-data nextcloud-aio-nextcloud /usr/local/bin/php occ config:app:set richdocuments wopi_url --value="https://nextcloud.mentolder.de"
# Now, let's repair any file system inconsistencies and theming issues:
# bashCopy# Run Nextcloud's repair routine
docker exec -u www-data nextcloud-aio-nextcloud /usr/local/bin/php occ maintenance:repair
# Finally, we'll clear Nextcloud's cache to ensure all our changes take effect. We'll do this carefully by first enabling maintenance mode, then clearing the cache, and finally disabling maintenance mode:
# bashCopy# Enable maintenance mode
docker exec -u www-data nextcloud-aio-nextcloud /usr/local/bin/php occ maintenance:mode --on

# Clear the cache
docker exec -u www-data nextcloud-aio-nextcloud /usr/local/bin/php occ cache:clean

# Disable maintenance mode
docker exec -u www-data nextcloud-aio-nextcloud /usr/local/bin/php occ maintenance:mode --off