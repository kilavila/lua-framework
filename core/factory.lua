local socket = require("socket")
local FactoryRouter = require("core.factory_router")
local Logger = require("core.utils.logging")
local Routes = require("src.router")

---| Print ascii art on application start
---@type fun(): nil
local function print_ascii_art()
  local ascii = "\r\n"
    .. "\r\n"
    .. "                      ---  --   --  --        -------      \r\n"
    .. "                  ---                   --  -----------    \r\n"
    .. "               --                           ------------   \r\n"
    .. "            --          -------------       ------------   \r\n"
    .. "                    --------------------    -----------    \r\n"
    .. "         --      --------------------------   -------      \r\n"
    .. "               ---------------------     ----              \r\n"
    .. "       -      --------------------         ---      --     \r\n"
    .. "             --------------------           ---            \r\n"
    .. "     --     ---------------------           ----           \r\n"
    .. "     -     ----------------------          ------     -    \r\n"
    .. "           ------------------------      --------          \r\n"
    .. "    --     ------  -------------------------------    --   \r\n"
    .. "           ------ --------------------- ----------         \r\n"
    .. "    --     ------ --------  ----  --  ---  -------    --   \r\n"
    .. "           ------ --------  ----  -------- ------          \r\n"
    .. "     --    ------ --------- ----  --   --- ------     -    \r\n"
    .. "            ----- --------  ----  -- ----- -----     --    \r\n"
    .. "      -      ----        --    ------    -  ---            \r\n"
    .. "       -      --------------------------------      --     \r\n"
    .. "                --------- Framework ---------              \r\n"
    .. "         -        ------ by kilavila ------       -        \r\n"
    .. "           --       --------------------        -          \r\n"
    .. "                        ------------           -           \r\n"
    .. "              ---                          ---             \r\n"
    .. "                  --                    --                 \r\n"
    .. "                      --- ---  --  ---                     \r\n"
    .. "\r\n"
    .. "\r\n"

  print("\27[34m" .. ascii .. "\27[0m")
end

---| The core module of the application.
---| Handles configuration and listens for requests.
---@class FactoryModule
---@field configuration FactoryConfiguration
---@field logger LoggerModule
---@field factory_router FactoryRouterModule
---@field new fun(self: FactoryModule): FactoryModule ---| Creates new instance of FactoryModule
---@field config fun(self: FactoryModule, config?: FactoryConfiguration): nil ---| Overrides default configuration
---@field listen fun(self: FactoryModule): nil ---| Tells the application to listen on specified port
local Factory = {
  ---| Config table for the application.
  ---| Default config:
  ---|
  ---|  {
  ---|    enable_cors = false,
  ---|    allowed_origins = nil,
  ---|    port = 5000,
  ---|    ascii_art = true,
  ---|  }
  ---@class FactoryConfiguration
  ---@field enable_cors? boolean
  ---@field allowed_origins? table|nil
  ---@field port? number
  ---@field ascii_art? boolean
  configuration = {
    enable_cors = false,
    allowed_origins = nil,
    port = 5000,
    ascii_art = true,
  },
}
Factory.__index = Factory

function Factory:new()
  local instance = setmetatable({}, Factory)
  instance.logger = Logger:new()
  instance.factory_router = FactoryRouter:new()
  return instance
end

function Factory:config(config)
  if config then
    for key, value in pairs(config) do
      self.configuration[key] = value
    end
  end
end

function Factory:listen()
  local server = socket.bind("*", self.configuration.port)

  if self.configuration.ascii_art then
    print_ascii_art()
  end

  self.logger:success("[Core] Starting Lua Server...")
  self.logger:success("[Core] Listening on port: " .. self.configuration.port .. "\r\n")

  for _route, _controller in pairs(Routes) do
    local log_controller = string.format("[Router] %s {%s}:", _controller.name, _route)
    self.logger:success(log_controller)

    for _endpoint, _entity in pairs(_controller.entities) do
      local log_entity = string.format("[Router] Mapped {%s, %s}", _endpoint, _entity.method)
      self.logger:success(log_entity)
    end
  end

  while true do
    local client = server:accept()
    if client then
      client:settimeout(10)

      local request = client:receive("*l")
      if request then
        self.factory_router:handle_request(client, request, Routes, self.configuration)
      end

      client:close()
    end

    socket.sleep(0.01)
  end
end

return Factory
