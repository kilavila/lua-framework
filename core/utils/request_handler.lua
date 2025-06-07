local RequestExtractor = require("core.utils.request_extractor")
local Cors = require("core.utils.cors")

---@class RequestHandlerModule
---@field cors CorsModule
---@field request_extractor RequestExtractorModule
---@field new fun(self: RequestHandlerModule): RequestHandlerModule
---@field parse fun(self: RequestHandlerModule, client: table, request: table, configuration: table): nil
local RequestHandler = {}
RequestHandler.__index = RequestHandler

---@type fun(): RequestHandlerModule
---@param self RequestHandlerModule
function RequestHandler:new()
  local instance = setmetatable({}, RequestHandler)
  instance.cors = Cors:new()
  instance.request_extractor = RequestExtractor:new()
  return instance
end

---@type fun(): table|nil
---@param self RequestHandlerModule
---@param client table
---@param request table
---@param configuration table
function RequestHandler:parse(client, request, configuration)
  local method, url = request:match("^(%S+) (%S+)")
  local headers = self.request_extractor:headers(client)

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

  ---@class RequestData
  ---@field body table|nil
  ---@field headers table
  ---@field method string
  ---@field origin string
  ---@field params table|nil
  ---@field route string
  local req_data = {
    body = body,
    headers = headers,
    method = method,
    origin = origin,
    params = parameters,
    route = route,
  }

  ---@class HttpRequest
  ---@field controller string
  ---@field endpoint string
  ---@field method string
  ---@field origin_header string|nil
  ---@field req RequestData
  local req = {
    controller = controller,
    endpoint = endpoint,
    method = method,
    origin_header = origin_header,
    req = req_data,
  }
  return req
end

return RequestHandler
