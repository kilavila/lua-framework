local render_routes_table = require("core.docs.render_routes_table")

local Docs = {}
Docs.__index = Docs

function Docs:new()
  local instance = setmetatable({}, Docs)
  return instance
end

function Docs:render_template(filename, data)
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

  local endpoints = render_routes_table()
  content = content:gsub("{{ endpoints }}", endpoints)

  return content
end

function Docs:serve_html(client)
  local data = {
    title = "Docs | Lua-Framework",
    heading = "API Documentation",
    description = "Lightweight REST API framework built with Lua, inspired by the structure of NestJS. Utilising LuaSocket for networking.",
  }

  -- Render the template
  local content = self:render_template("core/docs/template.html", data)

  -- Send HTTP response
  client:send("HTTP/1.1 200 OK\r\n")
  client:send("Content-Type: text/html\r\n")
  client:send("Content-Length: " .. #content .. "\r\n")
  client:send("\r\n")
  client:send(content)
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

function Docs:route_handler(client, method, controller, endpoint)
  -- TODO: Create new Docs module for serving HTML, CSS, JS and static files
  --
  -- TODO: Create new routes table for docs and static files

  if method == "GET" and controller == "/docs" then
    self:serve_html(client)
    return true
  elseif method == "GET" and controller == "/static" and endpoint == "/styles.css" then
    -- TODO: Check endpoint for which static file to return
    self:serve_static_file("core/docs/styles.css", client)
    return true
  end
end

return Docs
