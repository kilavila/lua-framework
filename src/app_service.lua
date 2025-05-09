local AppService = {}

---@type fun(): HttpResponse
function AppService.status()
  -- This is an example function.
  -- This service will handle data(f.ex. storage and retrieval)
  -- and it will be used by the AppController.
  -- In this case we just return a message.

  ---@type HttpResponse
  local response = {
    status = 200,
    data = {
      message = "Server online!",
    },
  }

  return response
end

return AppService
