local AppService = {}

---@type fun(): HttpResponse
function AppService.status()
  -- This function serves as an example of a service method within the AppService.
  -- It is responsible for handling data operations, such as storage and retrieval,
  -- and is intended to be used by the AppController.
  --
  -- In this specific implementation, the function simply returns a response
  -- indicating that the server is online.

  ---@type HttpResponse
  local response = {
    status = 200,
    data = {
      { message = "Server online!" },
    },
  }

  return response
end

return AppService
