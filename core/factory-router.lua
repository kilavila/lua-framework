local RequestExtractor = require("core.utils.request_extractor")
local Cors = require("core.utils.cors")
local Http = require("core.utils.http")
local Logger = require("core.utils.logging")

local FactoryRouter = {}
FactoryRouter.__index = FactoryRouter

function FactoryRouter:new()
  local instance = setmetatable({}, FactoryRouter)
  instance.request_extractor = RequestExtractor:new()
  instance.cors = Cors:new()
  instance.http = Http:new()
  instance.logger = Logger:new()
  return instance
end

---@type fun(): nil
---@param client table
---@param request table
---@param routes table
---@param configuration table
function FactoryRouter:handle_request(client, request, routes, configuration)
  print("")
  self.logger:info("[Request] " .. request)

  local headers = self.request_extractor:headers(client)

  local method, url = request:match("^(%S+) (%S+)")

  -- TODO: Fix same-origin
  -- TODO: Test origins on the server
  -- local server_origin = headers["host"]
  local origin = client:getpeername()

  if configuration.allowed_origins then
    self.cors:enable(configuration.allowed_origins)
  elseif configuration.enable_cors then
    self.cors:enable()
  end

  if method == "OPTIONS" then
    self.cors:preflight(client, method, origin)
    return
  end

  local origin_header = self.cors:get_origin_header(origin)
  if not origin_header then
    local res = "HTTP/1.1 403 Forbidden\r\n"
      .. "Content-Type: text/plain\r\n"
      .. "\r\n"
      .. "CORS policy: Access denied.\n"

    client:send(res)
    return
  end

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

  local body = nil
  if headers["content-length"] then
    body = self.request_extractor:body(client, headers["content-length"])
  end

  ---@type HttpRequest
  local req = {
    body = body,
    headers = headers,
    method = method,
    origin = origin,
    params = parameters,
    route = route,
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
            self.http:respond(client, response, origin_header)
          else
            response = {
              status = 500,
              errors = {
                { message = "The server has encountered a situation it does not know how to handle." },
              },
            }

            self.http:respond(client, response, origin_header)
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

    self.http:respond(client, response, origin_header)
  end
end

return FactoryRouter
