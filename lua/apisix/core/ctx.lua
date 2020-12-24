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


local function get_client_ip(handler)
    local streamInfo = handler:streamInfo()
    if not streamInfo then
        return nil
    end

    local ip = streamInfo:downstreamLocalAddress()
    if ip then
        return ip
    end

    ip = streamInfo:downstreamDirectRemoteAddress()
    if ip then
        return ip
    end
end

--- Note: envoy doesn't support context for lua currently. using a global var as ctx temporarily.
--- TODO: need a better implement and more vars
local var = {}
function _M.set_vars_meta(ctx, handler)
    table.clear(var)
    local headers = handler:headers()
    for key, value in pairs(headers) do
        if key == ":authority" then
            var.host = value
        elseif key == ":path" then
            var.request_uri = value
        elseif key == ":method" then
            var.method = value
        elseif key == ":scheme" or key == "x-forwarded-proto" then
            var.scheme = value
        else
            var[key] = value
        end
    end

    var.remote_addr = get_client_ip(handler)

    ctx.var = var
end


return _M
