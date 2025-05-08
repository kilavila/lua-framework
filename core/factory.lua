local socket = require("socket")

local factory_router = require("core.factory-router")
local log = require("core.utils.logging")

local routes = require("src.router")

M = {
  _config = {
    port = 3000,
  },
}

-- TODO: Create proper config and merging of config tables
function M:config(cfg)
  if cfg then
    M._config = cfg
  end

  return self
end

function M:listen()
  local server = socket.bind("*", self._config.port)

  log:success("[Core] Starting Lua Server...")
  log:success("[Core] Listening on port: " .. self._config.port)
  print("")

  for _route, _controller in pairs(routes) do
    local log_controller = string.format("[Router] %s {%s}:", _controller.name, _route)
    log:success(log_controller)

    for _endpoint, _entity in pairs(_controller.entities) do
      local log_entity = string.format("[Router] Mapped {%s, %s}", _endpoint, _entity.method)
      log:success(log_entity)
    end

    print("")
  end

  while true do
    local client = server:accept()
    if client then
      client:settimeout(10)

      local request = client:receive("*l")
      if request then
        -- TODO: Implement function decorator for timing functions?
        factory_router:handle_request(client, request, routes)
      end

      client:close()
    end

    socket.sleep(0.01)
  end
end

return M
