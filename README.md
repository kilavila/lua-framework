# Lua-Framework (REST API)

Lua-Framework is a lightweight REST API framework built with Lua, inspired by
the structure of NestJS. It utilizes LuaSocket for networking and provides a
simple yet powerful routing system to define endpoints and controllers.

## Features

- Routing System: Define your API endpoints in a centralized router file.
- Controllers: Organize your endpoint logic in separate controller files for better maintainability.
- Easy Configuration: Simple setup and configuration for your application.
- Logging: Built-in logging utility for tracking requests and responses.

## Project Structure

```
/lua-framework
│
├── core
│   ├── factory.lua        # Application factory for configuration and initialization
│   └── utils
│       └── logging.lua    # Logging utility
│
└── src
    ├── app_controller.lua  # Controller for handling app-related endpoints
    ├── main.lua            # Entry point of the application
    └── router.lua          # Router for defining API endpoints
```

## Getting Started

### Prerequisites

- Lua (version 5.1 or higher)
- LuaSocket library

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd lua-framework
```

2. Install LuaSocket if you haven't already. You can use LuaRocks:

```bash
luarocks install luasocket
```

### Running the Application

To start the server, run the following command:

```bash
lua main.lua

[ OK ] - 08/05/2025, 20:52:29 - [Core] Starting Lua Server...
[ OK ] - 08/05/2025, 20:52:29 - [Core] Listening on port: 3000

[ OK ] - 08/05/2025, 20:52:29 - [Router] app_controller {/app}:
[ OK ] - 08/05/2025, 20:52:29 - [Router] Mapped {/status, GET}
```

The server will start listening on port 3000.

### Defining Endpoints

Endpoints are defined in the `router.lua` file. Each endpoint is associated with a controller and a specific HTTP method. For example:

```lua
local app_controller = require("src.app_controller")

M = {
  ["/app"] = {
    name = "app_controller",
    entities = {
      ["/status"] = {
        method = "GET",
        fun = app_controller.status,
      },
    },
  },
}

return M
```

### Creating Controllers

Controllers are defined in separate files (e.g., `app_controller.lua`). Each controller can have multiple functions corresponding to different endpoints. For example:

```lua
M.status = function(request)
  -- Handle the request and return a response
  local response = {
    status = 200,
    data = {
      message = "Server online!",
    },
  }
  return response
end
```

### Testing Endpoints

You can test the defined endpoints using `curl`. For example, to check the status of the server, run:

```bash
curl http://localhost:3000/app/status
```

### Contributing

Contributions are welcome! If you have suggestions or improvements, feel free to open an issue or submit a pull request.
