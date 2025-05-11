local Routes = require("src.router")

local function create_routes_table()
  local html = ""

  for route, controller in pairs(Routes) do
    for endpoint, entity in pairs(controller.entities) do
      local routes_html = [[
<div class="endpoint">
  <h2 class="method">]] .. entity.method .. " " .. route .. endpoint .. [[</h2>
  <div class="parameters">
    <strong>Parameters:</strong>
    <ul>
      <li><code>name</code> (required, string): The name of the user.</li>
      <li><code>email</code> (required, string): The email of the user.</li>
    </ul>
  </div>
  <div class="response">
    <strong>Response:</strong>
    <pre>{
  "id": 3,
  "name": "New User",
  "email": "newuser@example.com"
}</pre>
  </div>
</div>
      ]]
      html = html .. routes_html
    end
  end

  return html
end

return create_routes_table
