local core = require("apisix.core")
local ctx = {}

function envoy_on_request(request_handle)
  core.ctx.set_vars_meta(ctx, request_handle)

  local metadata = request_handle:metadata()

--   for key, value in pairs(metadata) do
--     request_handle:logWarn("meta key:" .. key .. " value: " .. value)
--   end

  local plugins = metadata:get("plugins")
  local plugin_name = ""
  if #plugins >0 then
      for key, plugin_conf in pairs(plugins) do
        plugin_name = plugin_conf.name
        request_handle:logWarn("plugin name:" .. plugin_conf.name .. " key: " .. key)
      end
  end


  local ok, redirect = pcall(require, "apisix.plugins.redirect")
  local phase_func = redirect.rewrite
  local conf = {ret_code = 302, uri = "/redirected/path-" .. plugin_name}
  phase_func(conf, ctx, request_handle)
end

function envoy_on_response(response_handle)
  if ctx and ctx.var then
    for key, value in pairs(ctx.var) do
      response_handle:logWarn("ctx key:" .. key .. " value: " .. value)
    end
  end
end