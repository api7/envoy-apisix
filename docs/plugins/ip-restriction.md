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

The `ip-restriction` can restrict access to a Service or a Route by either
whitelisting or blacklisting IP addresses. Single IPs, multiple IPs or ranges
in CIDR notation like 10.10.10.0/24 can be used.

## Attributes

| Name      | Type          | Requirement | Valid | Description                              |
| --------- | ------------- | ----------- | ----- | ---------------------------------------- |
| whitelist | array[string] | optional    |       | List of IPs or CIDR ranges to whitelist. |
| blacklist | array[string] | optional    |       | List of IPs or CIDR ranges to blacklist. |

One of `whitelist` or `blacklist` must be specified, and they can not work together.

## How To Enable

Creates a route or service object, and enable plugin `ip-restriction`.



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
            - name: ip-restriction
            conf:
                whitelist:
                - 127.0.0.1
                - 113.74.26.106/24
```


## Test Plugin

Requests from `127.0.0.1`:

```shell
$ curl http://127.0.0.1:9080/index.html -i
HTTP/1.1 200 OK
...
```

Requests from `127.0.0.2`:

```shell
$ curl http://127.0.0.1:9080/index.html -i --interface 127.0.0.2
HTTP/1.1 403 Forbidden
...
{"message":"Your IP address is not allowed"}
```


## Disable Plugin

When you want to disable the `ip-restriction` plugin, it is very simple,
 you can delete the corresponding yaml configuration in the route metadata.
