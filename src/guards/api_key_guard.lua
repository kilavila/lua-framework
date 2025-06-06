local Logger = require("core.utils.logging")
local env = require("src._environment")

-- This is an example of a guard decorator for API key validation.
-- The decorator checks for the presence of the 'x-API-key' header
-- in the incoming request. If the header is present, it verifies
-- whether the provided API key matches the expected key.
--
-- ┌─────────────────────┐       ┌─────────────────────┐       ┌─────────────────────┐
-- │                     │       │                     │       │                     │
-- │       Router        │ ─────▶│        Guard        │ ─────▶│      Controller     │
-- │                     │       │                     │       │                     │
-- └─────────────────────┘       └─────────────────────┘       └─────────────────────┘
--
--
-- If the API key is valid, the request is allowed to proceed;
-- otherwise, an appropriate error response is returned.
local api_key_guard = function(func)
  return function(request)
    local logger = Logger:new()

    -- Check if environment api_key exist
    if not env.api_key then
      logger:error("[Guard] Could not find env.api_key {api_key_guard}")

      ---@type HttpResponse
      local response = {
        status = 500,
        errors = {
          { message = "Environment Configuration Error." },
          { message = "Please ensure that all required environment variables are set, including 'api_key'." },
        },
      }

      return response
    end

    -- If no API key
    if not request.headers["x-api-key"] then
      ---@type HttpResponse
      local response = {
        status = 401,
        errors = {
          { message = "No API key was provided." },
        },
      }

      return response
    end

    -- If wrong API key
    if request.headers["x-api-key"] ~= env.api_key then
      ---@type HttpResponse
      local response = {
        status = 401,
        errors = {
          { message = "The provided API key is incorrect." },
        },
      }

      return response
    end

    -- If correct API key, continue handling the request
    local result = func(request)

    -- Return the result of the request back to the
    -- router and the HTTP utility
    return result
  end
end

return api_key_guard
