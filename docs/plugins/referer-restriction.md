<!--
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
-->

# Summary
- [**Name**](#name)
- [**Attributes**](#attributes)
- [**How To Enable**](#how-to-enable)
- [**Test Plugin**](#test-plugin)
- [**Disable Plugin**](#disable-plugin)


## Name

The `referer-restriction` can restrict access to a Route by whitelisting request header Referers.

## Attributes

| Name      | Type          | Requirement | Default | Valid | Description                              |
| --------- | ------------- | ----------- | ------- | ----- | ---------------------------------------- |
| whitelist | array[string] | required    |         |       | List of hostname to whitelist. The hostname can be started with `*` as a wildcard |
| bypass_missing  | boolean       | optional    | false   |       | Whether to bypass the check when the Referer header is missing or malformed |

## How To Enable

Here's a mini example, enable the `referer-restriction` plugin on the specified route:

```yaml
    - match:
        prefix: "/hello"
    route:
        cluster: web_service
    typed_per_filter_config:
        envoy.filters.http.lua:
        "@type": type.googleapis.com/envoy.extensions.filters.http.lua.v3.LuaPerRoute
        name: entry.lua
    metadata:
        filter_metadata:
        envoy.filters.http.lua:
            plugins: 
            - name: referer-restriction
            conf:
                bypass_missing: false
                whitelist:
                - "127.0.0.1"
```

## Test Plugin

Request with `Referer: http://xx.com/x`:

```shell
$ curl 127.0.0.1:8000/hello -i -H "Referer: http://127.0.0.1"
HTTP/1.1 200 OK
x-powered-by: Express
content-type: application/json; charset=utf-8
content-length: 566
etag: W/"236-exxhnQXbbhWjM6uv+UNfhdV7NWU"
date: Mon, 21 Dec 2020 00:25:47 GMT
x-envoy-upstream-service-time: 2
server: envoy

...
```

Request with `Referer: http://yy.com/x`:

```shell
$ curl 127.0.0.1:8000/hello -i -H "Referer: http://127.0.0.2"
HTTP/1.1 403 Forbidden
server: envoy
content-length: 46
date: Mon, 21 Dec 2020 00:24:56 GMT

{"message":"Your referer host is not allowed"}%
```

Request without `Referer`:

```shell
$ curl 127.0.0.1:8000/hello -i
HTTP/1.1 200 OK
x-powered-by: Express
content-type: application/json; charset=utf-8
content-length: 566
etag: W/"236-exxhnQXbbhWjM6uv+UNfhdV7NWU"
date: Mon, 21 Dec 2020 00:25:47 GMT
x-envoy-upstream-service-time: 2
server: envoy

...
```

## Disable Plugin

When you want to disable the `referer-restriction` plugin, it is very simple,
 you can delete the corresponding yaml configuration in the route metadata.
