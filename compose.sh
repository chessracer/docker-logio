export LOGIO_PASSWORD=${LOGIO_PASSWORD:-"changeme"}
#export LARAVEL_HOME=${LARAVEL_HOME:-"/opt/laravel-coci"}

# use the laravel-enabled harvester definition, if LARAVEL_HOME is set
if [[ -z "${LARAVEL_HOME:-""}" ]]; then
    echo "LARAVEL_HOME not set, not harvesting laravel log"
    sed -e "s/node_name/$(hostname)/g" volumes/harvester.conf.template > volumes/harvester.conf
else
    echo "LARAVEL_HOME was set, harvesting laravel log"
    sed -e "s/node_name/$(hostname)/g" volumes/harvester.conf.template.laravel > volumes/harvester.conf
fi

sed -e "s/password/${LOGIO_PASSWORD}/g" volumes/web_server.conf.template > volumes/web_server.conf

docker-compose up -d

