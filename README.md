DockerHostHeartbeat
===================

This daemon runs on a docker host and phones home to [docker proxy api](https://github.com/bradleyd/docker_api_proxy)

### Usage

It requires system environment variables during start

Port that Docker is listening on

```bash
DOCKER_PORT=14443
```

The interface Docker API is listening on
```bash
DOCKER_INTERFACE="eth0"
```
The address to Docker API Proxy
```bash
DOCKER_API_PROXY="127.0.0.1:4000"
```
```bash
cd docker_host_heartbeat
mix run --no-halt
```


### TODO

- [ ] Use the env variable
- [ ] Phone home every 15 seconds
- [ ] Tests


