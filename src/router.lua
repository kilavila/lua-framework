local AppController = require("src.app_controller")

-- A controller's purpose is to handle specific requests for the application.
-- The routing mechanism determines which controller will handle each request.
-- Often, a controller has multiple routes, and each route can perform a different action.

-- Routes is an array containing controllers:
-- {
--  ["/app"] = {},
--  ["/user"] = {},
--  ...
-- }
--
-- And similarly, entities is an array containing endpoints.

---@type Routes
local Routes = {
  -- Strict!
  -- Must be unique
  -- Must start with: /
  -- Must have a name, can't just be /
  -- ["/"] -- Not working
  -- ["/app/example"] -- Not working
  ["/app"] = {
    -- Name is used by the core and logger
    name = "app_controller",
    entities = {
      -- Not so strict..
      -- Must be unique(within the controller)
      -- Must start with: /
      -- Must have a name, can't just be /
      -- Can have multiple / and names
      -- ["/"] -- Not working
      -- ["/status/example"] -- OK
      ["/status"] = {
        -- method and fun both used by the router
        method = "GET",
        fun = AppController.status,
      },
    },
  },
}

return Routes
