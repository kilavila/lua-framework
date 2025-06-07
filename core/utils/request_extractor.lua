---@class RequestExtractorModule
---@field new fun(self: RequestExtractorModule): RequestExtractorModule
local RequestExtractor = {}
RequestExtractor.__index = RequestExtractor

---@type fun(): RequestExtractorModule
---@param self RequestExtractorModule
function RequestExtractor:new()
  local instance = setmetatable({}, RequestExtractor)
  return instance
end

---@type fun(): table
---@param self RequestExtractorModule
---@param client table
function RequestExtractor:headers(client)
  local headers = {}

  while true do
    local line, _ = client:receive()
    if not line or line == "" then
      break
    end

    local key, value = line:match("^(.-):%s*(.*)$")
    if key and value then
      headers[key:lower()] = value
    end
  end

  return headers
end

---@type fun(): table
---@param self RequestExtractorModule
---@param client table
---@param content_length number
function RequestExtractor:body(client, content_length)
  local body = ""
  ---@diagnostic disable-next-line: undefined-field
  body = client:receive(content_length)
  return body
end

return RequestExtractor
