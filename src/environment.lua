--[[
    Environment Configuration

    This file contains sensitive information such as API keys and secrets
    required for the application to function properly. The `environment`
    table holds key-value pairs for configuration settings.

    Note: When you compile the application using `luac`, the source code
    will be converted to bytecode, which helps protect sensitive information
    from being easily readable. However, ensure that this file is not
    included in public repositories to maintain security.
--]]

---@type table
local environment = {
  jwt_secret = "owZVhBaU9pSktWMVFpTENKaGJHY2lPaUpJVXpJMU5pSjkuZXlKemRXSWlPaUl4TW",
  api_key = "b295688a2bdee36aac7548afd28c73d9e32899af",
}

return environment
