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

return {
    ctx      = require("apisix.core.ctx"),
    json     = require("apisix.core.json"),   -- need a better json lib
    lrucache = require("apisix.core.lrucache"),
    plugin   = require("apisix.core.plugin"),
    re       = require("apisix.core.re"),
    schema   = require("apisix.schema_def"),
    string   = require("apisix.core.string"),
    table    = require("apisix.core.table"),
    version  = require("apisix.core.version"),

    empty_tab= {},
}
