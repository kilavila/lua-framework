local Routes = require("src.router")

local function title(method, route, endpoint)
  if not method or not route or not endpoint then
    return ""
  end

  local html = [[<h2 class="method">]] .. method .. " " .. route .. endpoint .. [[</h2>]]
  return html
end

local function description(desc)
  if not desc then
    return ""
  end

  local html = [[<p>]] .. desc .. [[</p>]]
  return html
end

local function parameters(params)
  if not params then
    return ""
  end

  local html = [[
    <div class="parameters">
      <strong>Parameters:</strong>
      <ul>
  ]]

  for _, param in pairs(params) do
    html = html
      .. "<li><code>"
      .. param.name
      .. "</code> (required: "
      .. param.required
      .. ", type: "
      .. param.type
      .. "): "
      .. param.description
      .. "</li>"
  end

  html = html .. [[
      </ul>
    </div>
  ]]

  return html
end

local function example_request(req)
  if not req then
    return ""
  end

  local html = [[
    <div class="response">
      <strong>Request:</strong>
      <pre>]]

  for _, line in ipairs(req) do
    html = html .. line .. "\n"
  end

  html = html .. [[</pre>
    </div>
  ]]

  return html
end

local function example_response(res)
  if not res then
    return ""
  end

  local html = [[
    <div class="response">
      <strong>Response:</strong>
      <pre>]]

  for _, line in ipairs(res) do
    html = html .. line .. "\n"
  end

  html = html .. [[</pre>
    </div>
  ]]

  return html
end

local function create_routes_table()
  local html = ""

  for route, controller in pairs(Routes) do
    for endpoint, entity in pairs(controller.entities) do
      local routes_html = [[
        <div class="endpoint ]] .. string.lower(entity.method) .. [[">]]

      routes_html = routes_html
        .. title(entity.method, route, endpoint)
        .. description(entity.docs.description)
        .. parameters(entity.docs.parameters)
        .. example_request(entity.docs.request)
        .. example_response(entity.docs.response)

      routes_html = routes_html .. [[</div>]]

      html = html .. routes_html
    end
  end

  return html
end

return create_routes_table
