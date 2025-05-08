local http = require("core.utils.http")
local log = require("core.utils.logging")
local extract = require("core.utils.request_extract")

M = {}

---@type fun(): nil
---@param client table
---@param request table
---@param routes table
function M:handle_request(client, request, routes)
  log:info("[Request] " .. request)

  local method, url = request:match("^(%S+) (%S+)")

  local route = string.match(url, "([^?]+)")
  local controller = string.match(route, "^(/%w+)")
  local endpoint = string.match(route, "^/%w+(.*)$")

  local params = string.match(url, "[^?]+?(.*)$")
  local parameters = {}

  if params then
    for param in string.gmatch(params, "([^&]+)") do
      local key, value = string.match(param, "^([^=]+)=(.*)$")
      parameters[key] = value
    end
  end

  local headers = extract:headers(client)
  local body = nil
  if headers["content-length"] then
    -- FIX: Very slow!
    -- TODO: Test various HTTP methods with and without request body
    body = extract:body(client, headers["content-length"])
  end

  ---@type HttpRequest
  local req = {
    method = method,
    route = route,
    headers = headers,
    body = body,
    params = parameters,
  }

  local path_found = false

  for _route, _controller in pairs(routes) do
    if _route == controller then
      for _endpoint, _entity in pairs(_controller.entities) do
        if _endpoint == endpoint and _entity.method == method then
          path_found = true

          ---@type HttpResponse
          local response = _entity.fun(req)

          if response then
            http:respond(client, response)
          else
            response = {
              status = 500,
              errors = {
                { message = "The server has encountered a situation it does not know how to handle." },
              },
            }

            http:respond(client, response)
          end --[[if response]]
        end --[[if _endpoint == endpoint and _entity.method == method]]
      end --[[for _endpoint, _entity in pairs(_controller.entities)]]
    end --[[if _route == controller]]
  end --[[for _route, _controller in pairs(routes)]]

  if not path_found then
    ---@type HttpResponse
    local response = {
      status = 404,
      errors = {
        { message = "The server cannot find the requested resource." },
        { message = "Invalid endpoint: " .. req.route },
      },
    }

    http:respond(client, response)
  end
end

return M
