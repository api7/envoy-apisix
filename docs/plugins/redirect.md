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

URI redirect.

## Attributes

| Name          | Type    | Requirement | Valid | Description |
| ------------- | ------- | ----------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| http_to_https | boolean | optional     |       | When it is set to `true` and the request is HTTP, will be automatically redirected to HTTPS with 301 response code, and the URI will keep the same as client request.|
| uri           | string  | optional    |       | New URL which redirect to. |
| ret_code      | string  | optional    | [200, ...]     | Response code    |

One of `http_to_https` and `uri` need to be specified.

## How To Enable

Here's a mini example, enable the `redirect` plugin on the specified route:

```yaml
    - match:
        prefix: "/bar"
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
            - name: redirect
            conf:
                ret_code: 301
                uri: "/redirected/path"
```


## Test Plugin

Testing based on the above examples :

```shell
$ curl http://127.0.0.1:8000/bar -i
HTTP/1.1 301 Moved Permanently
location: /redirected/path
server: envoy
content-length: 4
date: Mon, 21 Dec 2020 00:16:08 GMT

```

We can check the response code and the response header `Location`.

It shows that the `redirect` plugin is in effect.

 Here is an example of redirect HTTP to HTTPS:
```yaml
    - match:
        prefix: "/bar"
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
            - name: redirect
            conf:
                ret_code: 301
                http_to_https: true
```

## Disable Plugin

When you want to disable the `redirect` plugin, it is very simple,
 you can delete the corresponding yaml configuration in the route metadata.
