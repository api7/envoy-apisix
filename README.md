# About

A Lua framework that support [Apache APISIX](https://github.com/apache/apisix) plugins run directly in [Envoy](https://github.com/envoyproxy/envoy) Lua filter without modify Envoy.

# Run

1. clone the code
```shell
git clone https://github.com/api7/envoy-apisix.git
```

2. build and run
```shell
$ cd envoy-apisix/compose
$ docker-compose pull
$ docker-compose up --build -d
 ```

# Test

```shell
$ curl 127.0.0.1:8000/foo/root.exe -i

HTTP/1.1 403 Forbidden
server: envoy
content-length: 0
date: Wed, 18 Nov 2020 00:08:54 GMT
```
