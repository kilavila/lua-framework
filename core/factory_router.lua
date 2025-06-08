local RequestHandler = require("core.utils.request_handler")
local Http = require("core.utils.http")
local Logger = require("core.utils.logging")

local Docs = require("core.docs.render_template")

---@class FactoryRouterModule
---@field request_handler RequestHandlerModule
---@field http HttpModule
---@field logger LoggerModule
---@field docs DocsModule
---@field new fun(self: FactoryRouterModule): FactoryRouterModule
---@field handle_request fun(self: FactoryRouterModule, client: table, request: table, routes: table, configuration: table): nil
local FactoryRouter = {}
FactoryRouter.__index = FactoryRouter

---@type fun(): FactoryRouterModule
---@param self FactoryRouterModule
function FactoryRouter:new()
  local instance = setmetatable({}, FactoryRouter)
  instance.request_handler = RequestHandler:new()
  instance.http = Http:new()
  instance.logger = Logger:new()
  instance.docs = Docs:new()
  return instance
end

---@type fun(): nil
---@param self FactoryRouterModule
---@param client table
---@param request table
---@param routes table
---@param configuration table
function FactoryRouter:handle_request(client, request, routes, configuration)
  print("")
  self.logger:info("[Request] " .. request)

  local parsed_request = self.request_handler:parse(client, request, configuration)
  if not parsed_request then
    return
  end

  -- return HTML and static files for /docs endpoint
  local served_docs =
    self.docs:route_handler(client, parsed_request.method, parsed_request.controller, parsed_request.endpoint)
  if served_docs then
    return
  end

  ---@class ErrorResponse
  ---@field message string

  ---@class HttpResponse
  ---@field status number
  ---@field errors? ErrorResponse[]
  ---@field data? table<any>
  ---@field meta? table<any>

  ---@type HttpResponse
  local response = {
    status = 404,
    errors = {
      { message = "The server cannot find the requested resource." },
      { message = "Invalid endpoint: " .. parsed_request.req.route },
    },
  }

  local controller = routes[parsed_request.controller]
  if not controller then
    self.logger:error("[Router] Controller not found!")
    self.http:respond(client, response, parsed_request.origin_header)
    return
  end

  local entity = controller.entities[parsed_request.endpoint]
  if not entity then
    self.logger:error("[Router] Endpoint not found!")
    self.http:respond(client, response, parsed_request.origin_header)
    return
  end

  response = entity.fun(parsed_request.req)
  if response then
    self.http:respond(client, response, parsed_request.origin_header)
  else
    response = {
      status = 500,
      errors = {
        { message = "The server has encountered a situation it does not know how to handle." },
      },
    }

    self.http:respond(client, response, parsed_request.origin_header)
  end
end

return FactoryRouter
