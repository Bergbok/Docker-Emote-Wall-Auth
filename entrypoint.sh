#!/bin/bash
set -eo pipefail

# addr.json
jq --arg host "$GLOBAL_HOST" \
   --arg home "$GLOBAL_HOME" \
   --arg twitch "$GLOBAL_TWITCH" \
   --arg youtube "$GLOBAL_YOUTUBE" \
   --arg kick "$GLOBAL_KICK" \
   --arg trovo "$GLOBAL_TROVO" \
   --arg return "$GLOBAL_RETURN" \
   '.global.host = $host |
	.global.home = $home |
	.global.twitch = $twitch |
	.global.youtube = $youtube |
	.global.kick = $kick |
	.global.trovo = $trovo |
	.global.return = $return' \
   /var/www/data/example_addr.json > /var/www/data/addr.json

# auth.json
jq --arg twitch_id "$TWITCH_CLIENT_ID" \
   --arg twitch_secret "$TWITCH_CLIENT_SECRET" \
   --arg kick_events_channel "$TWITCH_KICK_EVENTS_CHANNEL_ID" \
   --arg kick_events_id "$TWITCH_KICK_EVENTS_CLIENT_ID" \
   --arg kick_events_secret "$TWITCH_KICK_EVENTS_CLIENT_SECRET" \
   --arg kick_events_access "$TWITCH_KICK_EVENTS_ACCESS_TOKEN" \
   --arg kick_events_refresh "$TWITCH_KICK_EVENTS_REFRESH_TOKEN" \
   --arg kick_events_expires "$TWITCH_KICK_EVENTS_EXPIRES" \
   --arg kick_id "$KICK_CLIENT_ID" \
   --arg kick_secret "$KICK_CLIENT_SECRET" \
   --arg kick_challenge "$KICK_CHALLENGE" \
   --arg kick_verifier "$KICK_VERIFIER" \
   --arg trovo_id "$TROVO_CLIENT_ID" \
   --arg trovo_secret "$TROVO_CLIENT_SECRET" \
   --arg youtube_id "$YOUTUBE_CLIENT_ID" \
   --arg youtube_secret "$YOUTUBE_CLIENT_SECRET" \
   --arg se_id "$STREAMELEMENTS_CLIENT_ID" \
   --arg se_secret "$STREAMELEMENTS_CLIENT_SECRET" \
   '.twitch.client_id = $twitch_id |
	.twitch.client_secret = $twitch_secret |
	.twitch.kick_events.channel_id = $kick_events_channel |
	.twitch.kick_events.client_id = $kick_events_id |
	.twitch.kick_events.client_secret = $kick_events_secret |
	.twitch.kick_events.access_token = $kick_events_access |
	.twitch.kick_events.refresh_token = $kick_events_refresh |
	.twitch.kick_events.expires = $kick_events_expires |
	.kick.client_id = $kick_id |
	.kick.client_secret = $kick_secret |
	.kick.challenge = $kick_challenge |
	.kick.verifier = $kick_verifier |
	.trovo.client_id = $trovo_id |
	.trovo.client_secret = $trovo_secret |
	.youtube.client_id = $youtube_id |
	.youtube.client_secret = $youtube_secret |
	.streamelements.client_id = $se_id |
	.streamelements.client_secret = $se_secret' \
   /var/www/data/example_auth.json > /var/www/data/auth.json

cat > /etc/apache2/conf-available/emote-wall.conf <<'EOF'
ServerName ${GLOBAL_HOST}
DirectoryIndex login.php index.php index.html

<FilesMatch \.php$>
	SetHandler application/x-httpd-php
</FilesMatch>

<Directory /var/www/html>
	Options +FollowSymLinks -Indexes +MultiViews
	AllowOverride None
</Directory>
EOF

a2enmod rewrite >/dev/null || true
a2enconf emote-wall >/dev/null || true

if [[ -n "$KICK_CLIENT_ID" && "$KICK_CLIENT_ID" != "00000000000000000000000000" ]]; then
	service cron start
	echo "0 */1 * * * curl -fsSL https://api.kick.com/public/v1/public-key | jq -r '.data.public_key' > /var/www/data/k.pub 2>/dev/null || echo 'Failed to download Kick public key'" | crontab -
	curl -fsSL https://api.kick.com/public/v1/public-key | jq -r '.data.public_key' > /var/www/data/k.pub 2>/dev/null || echo 'Failed to download Kick public key'
fi

exec "$@"
