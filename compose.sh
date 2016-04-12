export LOGIO_PASSWORD=${LOGIO_PASSWORD:-"changeme"}
export LARAVEL_HOME=${LARAVEL_HOME:-"/opt/laravel-coci"}

sed -e "s/password/${LOGIO_PASSWORD}/g" volumes/web_server.conf.template > volumes/web_server.conf
sed -e "s/node_name/$(hostname)/g" volumes/harvester.conf.template > volumes/harvester.conf

docker-compose up -d

