# Lua-Framework (REST API)

> [!WARNING]  
> This project is currently under development. Features and functionality are
> being actively worked on, and the API may change as improvements are made.
> Please check back for updates, and feel free to contribute or provide feedback!

Hey there! 😊 Let me tell you about Lua-Framework — it's this super cool,
lightweight REST API toolkit built with Lua that’s inspired by the awesome
NestJS style! 🚀 It uses LuaSocket to handle all the networking magic and gives
you an easy-to-use yet super powerful way to set up your endpoints and
controllers. Perfect for making your API projects smooth and fun! 🎉

## Features

- Routing System: Define your API endpoints in a centralized router file.
- Controllers: Organize your endpoint logic in separate controller files for better maintainability.
- Easy Configuration: Simple setup and configuration for your application.
- Logging: Built-in logging utility for tracking requests and responses.

## Project Structure

```
/lua-framework
│
├── core/
│   ├── factory.lua         # Application factory for configuration and initialization
│   ├── factory-router.lua  # Application router for handling requests and responses
│   ├── types/              # LuaCATS (Lua Comment And Type System) annotations
│   │   └── ...
│   └── utils/
│       ├── cors.lua               # Cors utility
│       ├── http.lua               # Http response utility
│       ├── logging.lua            # Logging utility
│       └── ...
│
└── src/
    ├── app_controller.lua  # Controller for handling app-related endpoints
    ├── app_service.lua     # Service for handling data storage and retrieval
    ├── main.lua            # Entry point of the application
    └── router.lua          # Router for defining API endpoints
```

## Getting Started

### Prerequisites

- Lua (version 5.1 or higher)
- LuaRocks

### Installation

1. Clone the repository:

```bash
git clone https://github.com/kilavila/lua-framework.git
cd lua-framework
```

2. Install `luasocket` and `lua-cjson`:

```bash
luarocks install luasocket lua-cjson
```

### Running the Application

To start the server, run the following command:

```bash
lua src/main.lua
```

```bash
[ OK ] - 08/05/2025, 20:52:29 - [Core] Starting Lua Server...
[ OK ] - 08/05/2025, 20:52:29 - [Core] Listening on port: 3000

[ OK ] - 08/05/2025, 20:52:29 - [Router] app_controller {/app}:
[ OK ] - 08/05/2025, 20:52:29 - [Router] Mapped {/status, GET}
```

The server will start listening on port 3000.

> [!TIP]
> Everything you need is in the `src` directory.
> Read the comments in the files to get started.

### Defining Endpoints

Endpoints are defined in the `router.lua` file. Each endpoint is associated with a controller and a specific HTTP method. For example:

```lua
local AppController = require("src.app_controller")

local Routes = {
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

return Routes
```

### Creating Controllers

Controllers are defined in separate files (e.g., `app_controller.lua`). Each controller can have multiple functions corresponding to different endpoints. For example:

```lua
local AppService = require("src.app_service")

local AppController = {}

function AppController.status(request)
  -- Call the AppService status function
  -- Send request body, params etc

  local response = AppService.status()
  return response
end

return AppController
```

### Creating Services

Services are also defined in separate files (e.g., `app_service.lua`). A service should handle data storage and retrieval. For example:

```lua
local AppService = {}

function AppService.status()
  -- Handle request body, params etc
  -- Retrieve or store data in database

  local response = {
    status = 200,
    data = {
      message = "Server online!",
    },
  }
  return response
end

return AppService
```

### Testing Endpoints

You can test the defined endpoints using `curl`. For example, to check the status of the server, run:

```bash
curl http://localhost:3000/app/status
```

```bash
{"data":{"message":"Server online!"}}
```

Or test with HTTPie:

```bash
http GET :3000/app/status
```

```bash
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: close
Content-Length: 37
Content-Type: application/json

{
    "data": {
        "message": "Server online!"
    }
}
```

```bash
[ OK ] - 08/05/2025, 21:50:22 - [Core] Starting Lua Server...
[ OK ] - 08/05/2025, 21:50:22 - [Core] Listening on port: 3000

[ OK ] - 08/05/2025, 21:50:22 - [Router] app_controller {/app}:
[ OK ] - 08/05/2025, 21:50:22 - [Router] Mapped {/status, GET}

[ INFO ] - 08/05/2025, 21:50:35 - [Request] GET /app/status HTTP/1.1
[ INFO ] - 08/05/2025, 21:50:35 - [app_controller] params: table: 0x5c670bce7fa0
[ INFO ] - 08/05/2025, 21:50:35 - [app_controller] headers: table: 0x5c670bcec880
[ INFO ] - 08/05/2025, 21:50:35 - [app_controller] method: GET
[ INFO ] - 08/05/2025, 21:50:35 - [app_controller] route: /app/status
```

### Contributing

Contributions are welcome! If you have suggestions or improvements, feel free to open an issue or submit a pull request.
