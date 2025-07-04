local Exception = require("core.utils.exceptions")
local Logger = require("core.utils.logging")
local env = require("src.environment")

--[[
    This is an example of a guard decorator for API key validation.
    The decorator checks for the presence of the 'x-API-key' header
    in the incoming request. If the header is present, it verifies
    whether the provided API key matches the expected key.

    ┌─────────────────────┐       ┌─────────────────────┐       ┌─────────────────────┐
    │                     │       │                     │       │                     │
    │       Router        │ ─────▶│        Guard        │ ─────▶│      Controller     │
    │                     │       │                     │       │                     │
    └─────────────────────┘       └─────────────────────┘       └─────────────────────┘

    If the API key is valid, the request is allowed to proceed;
    otherwise, an appropriate error response is returned.
--]]

---@type Guard
local function api_key_guard(func)
  return function(request)
    -- Create new instance of 'Exception' and 'Logger'

    ---@type HttpExceptionModule
    local exception = Exception:new()

    ---@type LoggerModule
    local logger = Logger:new()

    -- The API Key from the request
    ---@type string|nil
    local key = request.headers["x-api-key"]

    -- Check if environment api_key exist
    if not env.api_key then
      logger:error("[Guard] Could not find env.api_key {api_key_guard}")

      return exception:InternalServerError({
        "Environment Configuration Error.",
        "Please ensure that all required environment variables are set, including 'api_key'.",
      })
    end

    -- If no API key
    if not key then
      return exception:Unauthorized({ "No API Key provided." })
    end

    -- If wrong API key
    if key ~= env.api_key then
      return exception:Unauthorized({ "Invalid API Key." })
    end

    -- If correct API key, continue handling the request
    ---@type HttpResponse
    local result = func(request)

    -- Return the result of the request back to the router and the HttpModule
    return result
  end
end

return api_key_guard
