--
-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements.  See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
local schema    = require('apisix.core.schema')
local setmetatable = setmetatable
local error     = error

local _M = {version = 0.5}

local plugins_schema = {
    type = "object"
}

local id_schema = {
    anyOf = {
        {
            type = "string", minLength = 1, maxLength = 64,
            pattern = [[^[a-zA-Z0-9-_.]+$]]
        },
        {type = "integer", minimum = 1}
    }
}

local host_def_pat = "^\\*?[0-9a-zA-Z-.]+$"
local host_def = {
    type = "string",
    pattern = host_def_pat,
}
_M.host_def = host_def


local ipv4_def = "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}"
local ipv6_def = "([a-fA-F0-9]{0,4}:){0,8}(:[a-fA-F0-9]{0,4}){0,8}"
                 .. "([a-fA-F0-9]{0,4})?"
local ip_def = {
    {title = "IPv4", type = "string", pattern = "^" .. ipv4_def .. "$"},
    {title = "IPv4/CIDR", type = "string", pattern = "^" .. ipv4_def .. "/[0-9]{1,2}$"},
    {title = "IPv6", type = "string", pattern = "^" .. ipv6_def .. "$"},
    {title = "IPv6/CIDR", type = "string", pattern = "^" .. ipv6_def .. "/[0-9]{1,3}$"},
}
_M.ip_def = ip_def

_M.uri_def = {type = "string", pattern = [=[^[^\/]+:\/\/([\da-zA-Z.-]+|\[[\da-fA-F:]+\])(:\d+)?]=]}

_M.id_schema = id_schema

_M.plugin_disable_schema = {
    disable = {type = "boolean"}
}


setmetatable(_M, {
    __index = schema,
    __newindex = function() error("no modification allowed") end,
})


return _M
