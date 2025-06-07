---@class CorsModule
---@field allow_all_origins boolean
---@field allowed_origins table
---@field new fun(self: CorsModule): CorsModule
---@field get_origin_header fun(self: CorsModule, origin: string): string|nil
---@field preflight fun(self: CorsModule, client: table, method: string,  origin: string): nil
local Cors = {
  allow_all_origins = false,
  allowed_origins = {},
}
Cors.__index = Cors

---@type fun(): CorsModule
---@param self CorsModule
function Cors:new()
  local instance = setmetatable({}, Cors)
  return instance
end

---@type fun(): nil
---@param allowed_origins? table<string>
function Cors:enable(allowed_origins)
  if allowed_origins then
    self.allowed_origins = allowed_origins
  else
    self.allow_all_origins = true
  end
end

---@type fun(): string|nil
---@param self CorsModule
---@param origin string
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

---@type fun(): nil
---@param self CorsModule
---@param client table
---@param method string
---@param origin string
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
