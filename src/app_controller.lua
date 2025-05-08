local log = require("core.utils.logging")

M = {}

---@type fun(): HttpResponse
---@param request HttpRequest
M.status = function(request)
  -- This is an example function.
  -- Test this endpoint by starting the server and running:
  --
  --    curl http://localhost:3000/app/status
  --

  for k, v in pairs(request) do
    local str = string.format("[app_controller] %s: %s", k, v)
    log:info(str)
  end

  ---@type HttpResponse
  local response = {
    status = 200,
    data = {
      message = "Server online!",
    },
  }

  return response
end

return M
