local factory = require("core.factory")

local bootstrap = function()
  local app = factory:config({ port = 3000 })
  app:listen()
end

bootstrap()
