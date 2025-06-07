local Factory = require("core.factory")

-- The entry file of the application which uses the
-- core function Factory to create an application instance.

---@type fun(): nil
local function bootstrap()
  -- Creating a new instance of Factory, the core of the application
  ---@type FactoryModule
  local app = Factory:new()

  -- The app has some default configurations.
  -- There is f.ex. no need to change the port
  -- but if you want to use a custom configuration
  -- you can pass in a table like so:

  -- TODO:
  -- Fix types
  -- Encryption and hashing
  -- User defined types in src/
  -- Rate limiting?
  -- Websockets?
  -- Add caching?
  -- Serialization?
  -- Cron jobs?
  -- ORM similar to prisma?
  -- Add database config for SQL and NoSQL?
  -- Multiple databases?
  -- Header or URI versioning?
  -- Controller specific or endpoint or both and global default?

  ---@type FactoryConfiguration
  local config = {
    -- Define the allowed origins
    -- You don't have to use both allowed_origins and enable_cors.
    -- Setting either one is fine, but if you set both
    -- then allowed_origins will override enable_cors!
    --
    -- Example:
    --
    -- allowed_origins = {
    --   ["localhost"] = true,
    --   ["127.0.0.1"] = true,
    --   ["http://example.com"] = true,
    --   ["http://another-example.com"] = true,
    -- },

    -- Do not show ascii art on server start
    -- ascii_art = false,

    -- Sets allow origin to: *
    -- which will allow all origins
    enable_cors = true,
    port = 3000,
  }
  app:config(config)

  -- Start listening for requests
  app:listen()
end

bootstrap()
