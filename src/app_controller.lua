local Logger = require("core.utils.logging")
local AppService = require("src.app_service")

--- AppController class defined in 'src.types.types'
---@class AppController
local AppController = {}

---@type fun(): HttpResponse
---@param request HttpRequest
function AppController.status(request)
  -- This function serves as an example of a controller in the application.
  -- Controllers are responsible for processing incoming requests,
  -- executing the necessary business logic, and sending responses
  -- back to the client.
  --
  -- To test this endpoint, start the server and use one of the following
  -- commands in your terminal:
  --
  -- 1. Using curl:
  --    curl http://localhost:3000/app/status
  --
  -- 2. Using HTTPie:
  --    http GET http://localhost:3000/app/status
  --
  -- Both commands will send a GET request to the /app/status endpoint
  -- and return the current status of the application.

  -- Creating a new instance of the logger
  ---@type LoggerModule
  local logger = Logger:new()

  for k, v in pairs(request) do
    -- The request table contains important information about the incoming
    -- HTTP request. It is structured as follows:
    --
    -- {
    --   body = {}          -- Contains the parsed body of the request (e.g., JSON data).
    --   headers = {}       -- A table of HTTP headers sent with the request.
    --   method = "string"  -- The HTTP method used for the request (e.g., GET, POST).
    --   origin = "string"  -- The origin of the request, typically the client's address.
    --   parameters = {}    -- A table of query parameters included in the request URL.
    --   route = "string"   -- The route or endpoint being accessed.
    -- }
    --
    -- This information can be useful for logging, debugging, and
    -- processing the request appropriately.
    local str = string.format("[AppController.status] %s: %s", k, v)
    logger:info(str)
  end

  -- Call the AppService status function
  ---@type HttpResponse
  local response = AppService.status()
  return response
end

function AppController.test(request)
  -- Example using a guard.
  -- See `src.router` and `src.guards.api_key_guard`

  ---@type LoggerModule
  local logger = Logger:new()

  for k, v in pairs(request) do
    local str = string.format("[AppController.status] %s: %s", k, v)
    logger:info(str)
  end

  ---@type HttpResponse
  local response = {
    status = 200,
    data = {
      { message = "Congrats!" },
    },
  }
  return response
end

return AppController
