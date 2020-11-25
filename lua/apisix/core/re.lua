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

local string_match = string.match

function _M.parse_uri(_, uri, query_in_path)
    if query_in_path == nil then query_in_path = true end

    local m, err = string_match(uri, [[^(?:(http[s]?):)?//([^:/\?]+)(?::(\d+))?([^\?]*)\??(.*)]])

    if not m then
        if err then
            return nil, "failed to match the uri: " .. uri .. ", " .. err
        end

        return nil, "bad uri: " .. uri
    else
        -- If the URI is schemaless (i.e. //example.com) try to use our current
        -- request scheme.
        if not m[1] then
            return nil, "schemaless URIs require a request context: " .. uri
        end

        if m[3] then
            m[3] = tonumber(m[3])
        else
            if m[1] == "https" then
                m[3] = 443
            else
                m[3] = 80
            end
        end
        if not m[4] or "" == m[4] then m[4] = "/" end

        if query_in_path and m[5] and m[5] ~= "" then
            m[4] = m[4] .. "?" .. m[5]
            m[5] = nil
        end

        return m, nil
    end
end

return _M
