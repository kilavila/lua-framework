local AppController = require("src.app_controller")
local api_key_guard = require("src.guards.api_key_guard")

--[[
    The purpose of a controller is to manage specific requests within the application.
    It acts as an intermediary between the incoming requests and the service functions,
    processing the requests and returning appropriate responses.

    ┌─────────────────────┐                  ┌─────────────────────┐       ┌─────────────────────┐       ┌─────────────────────┐
    │                     │   HTTP Request   │                     │       │                     │       │                     │
    │     Client Side     │ ────────────────▶│       Router        │ ─────▶│     Controller      │ ─────▶│       Service       │
    │                     │                  │                     │       │                     │       │                     │
    └─────────────────────┘                  └─────────────────────┘       └─────────────────────┘       └─────────────────────┘

    The routing mechanism determines which controller is responsible for handling
    each incoming request based on the request's URL and HTTP method.

    Typically, a controller can have multiple routes, with each route corresponding
    to a different action or endpoint within the application.

    The `routes` table is structured as follows, where each key represents a URL path
    and the associated value is an array of controllers for that path:
    {
      ["/app"] = {},   -- Controllers for handling requests to the /app endpoint
      ["/user"] = {},  -- Controllers for handling requests to the /user endpoint
      ...
    }

    Similarly, the `entities` table contains definitions for various endpoints,
    allowing for organized management of the application's API structure.
--]]

---@type Entity
local app_test = {
  method = "GET", -- HTTP method for this endpoint.
  fun = api_key_guard(AppController.test), -- Function wrapped with the guard decorator.
  docs = {
    description = "Endpoint for testing API Key guard",
    request = {
      "http GET :3000/app/test 'x-API-key: my_secret_key'",
    },
    response = {
      "{",
      '  "data": [',
      '    { "message": "Congrats!" }',
      "  ]",
      "}",
    },
  },
}

---@type Entity
local app_status = {
  method = "GET", -- HTTP method for this endpoint.
  fun = AppController.status, -- Function to handle requests to this endpoint.
  docs = {
    description = "Check status of the API",
    request = {
      "http GET :3000/app/status",
    },
    response = {
      "{",
      '  "data": [',
      '    { "message": "Server online!" }',
      "  ]",
      "}",
    },
  },
}

---@type Controller
local app_controller = {
  -- The name of the controller associated with this route.
  -- This name is used by the core application and for logging purposes.
  name = "AppController",

  entities = {
    --[[
        The following rules apply to entities within a controller:
        1. Must be unique within the context of the controller.
        2. Must start with a forward slash ("/").
        3. Must have a descriptive name; an entity cannot simply be "/".
        4. Can contain multiple segments (e.g., "/status/example") and names.

        Examples of valid and invalid entities:
        ["/"] -- Not working: This entity lacks a name.
        ["/status/example"] -- OK: This entity is valid and properly defined.
    --]]

    -- Example of a request using a guard decorator for API key validation.
    ["/test"] = app_test,
    ["/status"] = app_status,
  },
}

---@type Routes
local Routes = {
  --[[
      Route Definitions

      Each route must adhere to the following strict rules:
      1. Must be unique across all controllers.
      2. Must start with a forward slash ("/").
      3. Must have a descriptive name; a route cannot simply be "/".

      Examples of invalid routes:
      ["/"] -- Not working: This route lacks a name.
      ["/app/example"] -- Not working: This route is not defined correctly.
  --]]

  ["/app"] = app_controller,
}

return Routes
