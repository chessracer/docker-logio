# docker-logio

Forward all your logs to [Log-Io](http://logio.org/)
and see it to http://localhost:28778

## Usage as a Container

### copy volumes/web_server.conf.template to volumes/web_server.conf, adjusting password as desired

```
sed -e "s/password/new_password/g" volumes/web_server.conf.template > volumes/web_server.conf
```

### copy volumes/harvester.conf.template to volumes/harvester.conf, adjusting node_name as desired

```
sed -e "s/node_name/$(hostname)/g" volumes/harvester.conf.template > volumes/harvester.conf
```


### Docker Compose

```
cat >docker-compose.yml <<EOF
logs:
  image: gerchardon/docker-logio
  links:
   - logio:logio
  volumes:
   - /var/run/docker.sock:/var/run/docker.sock
  command: -h logio -n docker
  privileged: true
logio:
  image: temal/logio-server
  ports:
   - 28777:28777
   - 28778:28778
  volumes:
   - ./volumes:/home/logio/.log.io
EOF
docker-compose up
```

### Manually

```
docker run -d --name logio -p 28777:28777 -p 28778:28778 temal/logio-server
docker run -d --privileged --link logio:logio -v /var/run/docker.sock:/var/run/docker.sock gerchardon/docker-logio -n `uname -n` -h logio
docker run -d -p 8000:8000 python:3.5-slim python -m http.server
```

See LogIo http://localhost:28778 and generate app log with http://localhost:8000

## Usage as CLI

1. ```npm install -g log.io --user "ubuntu"```
2. ```npm install docker-logio -g```
3. ```docker-logio -n docker```

## How it works

This module wraps four [Docker APIs](https://docs.docker.com/reference/api/docker_remote_api_v1.17/):

* `POST /containers/{id}/attach`, to fetch the logs
* `GET /containers/json`, to detect the containers that are running when
  this module starts
* `GET /events`, to detect new containers that will start after the
  module has started

## Roadmap

* Handle stream close
* Handle better container start/stop (fix LogIo server event)

## Inspire by

https://github.com/nearform/docker-logentries


## License

MIT
