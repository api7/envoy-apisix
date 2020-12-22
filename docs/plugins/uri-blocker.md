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

The plugin helps we intercept user requests, we only need to indicate the `referer-restriction`.

## Attributes

| Name          | Type          | Requirement | Default | Valid      | Description                                                                 |
| ------------- | ------------- | ----------- | ------- | ---------- | --------------------------------------------------------------------------- |
| block_rules   | array[string] | required    |         |            | Regular filter rule array. Each of these items is a regular rule. If the current request URI hits any one of them, set the response code to rejected_code to exit the current user request. Example: `["root.exe", "root.m+"]`. |
| rejected_code | integer       | optional    | 403     | [200, ...] | The HTTP status code returned when the request URI hit any of `block_rules` |

## How To Enable

Here's a mini example, enable the `uri-blocker` plugin on the specified route:

```yaml
    - match:
        prefix: "/foo"
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
            - name: uri-blocker
            conf:
                rejected_code: 403
                block_rules: 
                - root.exe
                - root.m+
```

## Test Plugin

```shell
$ curl "127.0.0.1:8000/foo?name=root.exe" -i
HTTP/1.1 403 Forbidden
server: envoy
content-length: 0
date: Mon, 21 Dec 2020 00:45:26 GMT


...
```

## Disable Plugin

When you want to disable the `uri-blocker` plugin, it is very simple,
 you can delete the corresponding yaml configuration in the route metadata.
