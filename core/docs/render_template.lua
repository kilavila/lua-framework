local Docs = {}
Docs.__index = Docs

function Docs:new()
  local instance = setmetatable({}, Docs)
  return instance
end

local function render_template(filename, data)
  local file = io.open(filename, "r")
  if not file then
    print("HTML template file not found")
    return
  end

  local content = file:read("*all")
  file:close()

  -- Replace placeholders with actual data
  for key, value in pairs(data) do
    content = content:gsub("{{ " .. key .. " }}", value)
  end

  return content
end

function Docs:serve_static_file(filename, client)
  local file = io.open(filename, "r")
  if not file then
    client:send("HTTP/1.1 404 Not Found\r\n")
    client:send("\r\n")
    return
  end
  local content = file:read("*all")
  file:close()

  client:send("HTTP/1.1 200 OK\r\n")
  client:send("Content-Type: text/css\r\n") -- Set the correct content type for CSS
  client:send("Content-Length: " .. #content .. "\r\n")
  client:send("\r\n")
  client:send(content)
end

function Docs:serve_html(client)
  local data = {
    title = "My Lua Web Page",
    heading = "Welcome to My Lua Web Page",
    message = "This page is rendered using Lua!",
  }

  -- Render the template
  local content = render_template("core/docs/template.html", data)

  -- Send HTTP response
  client:send("HTTP/1.1 200 OK\r\n")
  client:send("Content-Type: text/html\r\n")
  client:send("Content-Length: " .. #content .. "\r\n")
  client:send("\r\n")
  client:send(content)
end

return Docs
