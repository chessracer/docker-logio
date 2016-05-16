export LOGIO_PASSWORD=${LOGIO_PASSWORD:-"changeme"}
#export LARAVEL_HOME=${LARAVEL_HOME:-"/opt/laravel-coci"}

# use the laravel-enabled harvester definition, if LARAVEL_HOME is set
if [[ -z "${LARAVEL_HOME:-""}" ]]; then
    echo "LARAVEL_HOME not set"
else
    echo "LARAVEL_HOME was set, harvesting laravel log"
    custom_app="laravel"
fi

if [[ -z "${custom_app:-""}" ]]; then
    echo "Neither custom_app nor LARAVEL_HOME were set, only harvesting syslog"
    sed -e "s/node_name/$(hostname)/g" volumes/harvester.conf.template > volumes/harvester.conf
else
    echo "custom_app was set, harvesting $custom_app log"
    sed -e "s/node_name/$(hostname)/g" volumes/harvester.conf.template.$custom_app > volumes/harvester.conf
fi


sed -e "s/password/${LOGIO_PASSWORD}/g" volumes/web_server.conf.template > volumes/web_server.conf

docker-compose up -d

