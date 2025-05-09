local Logger = require("core.utils.logging")
local AppService = require("src.app_service")

local AppController = {}

---@type fun(): HttpResponse
---@param request HttpRequest
function AppController.status(request)
  -- This is an example function.
  -- Controllers are responsible for handling incoming
  -- requests and sending responses back to the client.
  --
  -- You can test this endpoint by starting the server and running:
  --
  --    curl http://localhost:3000/app/status
  --
  --    or
  --
  --    http GET :3000/app/status
  --

  -- Creating a new instance of the logger
  local logger = Logger:new()

  for k, v in pairs(request) do
    local str = string.format("[app_controller] %s: %s", k, v)
    logger:info(str)
  end

  -- Call the AppService status function
  local response = AppService.status()
  return response
end

return AppController
