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
local _M = {version = 0.2}

local json_encode = require("apisix.core.json").encode

function _M.run(ctx, plugins)
    local handle = ctx.handle
    if not ctx then
        handle:logWarn("no ctx" )
        return
    end

    plugins = plugins or ctx.plugins
    if not plugins or #plugins == 0 then
        handle:logWarn("no plugins" )
        return ctx
    end

    local phase = ctx.phase
    local phases = {
        request = {
            'access',
            'rewrite'
        },
        response = {
            'header_filter',
            'body_filter'
        }
    }

    for _, plugin in ipairs(plugins) do
        local ok, plugin_object = pcall(require, "apisix.plugins." .. plugin.name)
        if ok then
            local apisix_phases = phases[phase]
            for _, phase_name in ipairs(apisix_phases) do
                local phase_func = plugin_object[phase_name]
                if phase_func then
                    local conf = plugin.conf
                    local status, body = phase_func(conf, ctx)
                    if status then
                        handle:logWarn("resp")
                        if type(body) == "table" then
                            body = json_encode(body)
                        end
                        handle:respond(
                            {[":status"] = status,
                            -- ["Location"] = uri,
                            ["server"] = "apisix"},
                            body or "" )
                        return
                    end
                end
            end
        else
            handle:logWarn("fail to load plugin:" .. plugin.name)
        end
    end

    return ctx
end


return _M
