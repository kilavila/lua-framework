---| Module for extracting data from the request.
---@class RequestExtractorModule
---@field new fun(self: RequestExtractorModule): RequestExtractorModule ---| Creates new instance of RequestExtractorModule.
---@field headers fun(self: RequestExtractorModule, client: table): RequestExtractorModule ---| Extracts the headers from the request.
---@field body fun(self: RequestExtractorModule, client: table, content_length: number): RequestExtractorModule ---| Extracts the body from the request.
local RequestExtractor = {}
RequestExtractor.__index = RequestExtractor

function RequestExtractor:new()
  local instance = setmetatable({}, RequestExtractor)
  return instance
end

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

function RequestExtractor:body(client, content_length)
  local body = ""
  ---@diagnostic disable-next-line: undefined-field
  body = client:receive(content_length)
  return body
end

return RequestExtractor
