---| Module for Cross-Origin Resource Sharing
---| Mechanism that allows a server to indicate any origins (domain, scheme, or port)
---| other than its own from which a browser should permit loading resources.
---|
---| Read more: [https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CORS)
---@class CorsModule
---@field allow_all_origins boolean
---@field allowed_origins table
---@field new fun(self: CorsModule): CorsModule ---| Creates new instance of CorsModule
---@field enable fun(self: CorsModule, allowed_origins?: string[]): nil ---| Sets the table of allowed origins if table is provided, or sets allow all if no table.
---@field get_origin_header fun(self: CorsModule, origin: string): string|nil ---| Checks if a request origin is allowed.
---@field preflight fun(self: CorsModule, client: table, method: string,  origin: string): nil ---| Preflight check
local Cors = {
  allow_all_origins = false,
  allowed_origins = {},
}
Cors.__index = Cors

function Cors:new()
  local instance = setmetatable({}, Cors)
  return instance
end

function Cors:enable(allowed_origins)
  if allowed_origins then
    self.allowed_origins = allowed_origins
  else
    self.allow_all_origins = true
  end
end

function Cors:get_origin_header(origin)
  -- TODO: Fix same-origin
  if self.allow_all_origins then
    -- Allow all
    return "*"
  elseif self.allowed_origins[origin] then
    -- If in allowed_origins
    return origin
  else
    -- Deny access
    return nil
  end
end

function Cors:preflight(client, method, origin)
  if method == "OPTIONS" then
    local origin_header = self:get_origin_header(origin)

    if origin_header then
      local res = "HTTP/1.1 204 No Content\r\n"
        .. "Access-Control-Allow-Origin: "
        .. origin_header
        .. "\r\n"
        .. "Access-Control-Allow-Methods: GET, POST, OPTIONS\r\n"
        .. "Access-Control-Allow-Headers: Content-Type\r\n\r\n"

      client:send(res)
    else
      local res = "HTTP/1.1 403 Forbidden\r\n"
        .. "Content-Type: text/plain\r\n"
        .. "\r\n"
        .. "CORS policy: Access denied.\n"

      client:send(res)
    end
  end
end

return Cors
