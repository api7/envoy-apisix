local core = require("apisix.core")
local ctx = {}

function envoy_on_request(request_handle)
  ctx.test = "a"
  core.ctx.set_vars_meta(ctx, request_handle)

  local metadata = handle:metadata()

  local ok, redirect = pcall(require, "apisix.plugins.redirect")
  local phase_func = redirect.rewrite
  local conf = {ret_code = 302, uri = "/redirected/path"}
  phase_func(conf, ctx, request_handle)
end

function envoy_on_response(response_handle)
  if ctx and ctx.var then
    for key, value in pairs(ctx.var) do
      response_handle:logWarn("ctx key:" .. key .. " value: " .. value)
    end                 
  end  
end