M = {}

function M:headers(client)
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

function M:body(client, content_length)
  local body = ""
  body = client:receive(content_length)
  return body
end

return M
