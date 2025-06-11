---| Http exception filter module
---@class HttpExceptionModule
---@field new fun(self: HttpExceptionModule): HttpExceptionModule ---| Creates new instance of HttpExceptionModule
---@field BadRequest BadRequestException
---@field Unauthorized UnauthorizedException
---@field NotFound NotFoundException
---@field Forbidden ForbiddenException
---@field NotAcceptable NotAcceptableException
---@field RequestTimeout RequestTimeoutException
---@field Conflict ConflictException
---@field Gone GoneException
---@field HttpVersionNotSupported HttpVersionNotSupportedException
---@field ContentTooLarge ContentTooLargeException
---@field UnsupportedMediaType UnsupportedMediaTypeException
---@field UnprocessableContent UnprocessableContentException
---@field InternalServerError InternalServerErrorException
---@field NotImplemented NotImplementedException
---@field Teapot TeapotException
---@field MethodNotAllowed MethodNotAllowedException
---@field BadGateway BadGatewayException
---@field ServiceUnavailable ServiceUnavailableException
---@field GatewayTimeout GatewayTimeoutException
---@field PreconditionFailed PreconditionFailedException
local Exception = {}
Exception.__index = Exception

function Exception:new()
  local instance = setmetatable({}, Exception)
  return instance
end

function Exception:BadRequest(messages)
  ---@type HttpResponse
  local response = {
    status = 400,
    errors = {
      { message = "Bad Request" },
      { message = "The request could not be understood by the server." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:Unauthorized(messages)
  ---@type HttpResponse
  local response = {
    status = 401,
    errors = {
      { message = "Unauthorized" },
      { message = "Authentication is required to access this resource." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:NotFound(messages)
  ---@type HttpResponse
  local response = {
    status = 404,
    errors = {
      { message = "Not Found" },
      { message = "The requested resource could not be found." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:Forbidden(messages)
  ---@type HttpResponse
  local response = {
    status = 403,
    errors = {
      { message = "Forbidden" },
      { message = "You do not have permission to access this resource." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:NotAccepable(messages)
  ---@type HttpResponse
  local response = {
    status = 406,
    errors = {
      { message = "Not Acceptable" },
      { message = "The requested resource is not available in a format acceptable to the client." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:RequestTimeout(messages)
  ---@type HttpResponse
  local response = {
    status = 408,
    errors = {
      { message = "Request Timeout" },
      { message = "The server timed out waiting for the request." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:Conflict(messages)
  ---@type HttpResponse
  local response = {
    status = 409,
    errors = {
      { message = "Conflict" },
      { message = "The request could not be completed due to a conflict with the current state of the resource." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:Gone(messages)
  ---@type HttpResponse
  local response = {
    status = 410,
    errors = {
      { message = "Gone" },
      { message = "The requested resource is no longer available and has been permanently removed." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:HTTPVersionNotSupported(messages)
  ---@type HttpResponse
  local response = {
    status = 505,
    errors = {
      { message = "HTTP Version Not Supported" },
      { message = "The server does not support the HTTP protocol version that was used in the request." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:ContentTooLarge(messages)
  ---@type HttpResponse
  local response = {
    status = 413,
    errors = {
      { message = "Content Too Large" },
      { message = "The request entity is larger than the server is willing or able to process." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:UnsupportedMediaType(messages)
  ---@type HttpResponse
  local response = {
    status = 415,
    errors = {
      { message = "Unsupported Media Type" },
      { message = "The media type of the request data is not supported by the server." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:UnprocessableContent(messages)
  ---@type HttpResponse
  local response = {
    status = 422,
    errors = {
      { message = "Unprocessable Content" },
      { message = "The request was well-formed but could not be processed due to semantic errors." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:InternalServerError(messages)
  ---@type HttpResponse
  local response = {
    status = 500,
    errors = {
      { message = "Internal Server Error" },
      { message = "The server encountered an unexpected condition that prevented it from fulfilling the request." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:NotImplemented(messages)
  ---@type HttpResponse
  local response = {
    status = 501,
    errors = {
      { message = "Not Implemented" },
      { message = "The server does not support the functionality required to fulfill the request." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:Teapot(messages)
  ---@type HttpResponse
  local response = {
    status = 418,
    errors = {
      { message = "I'm a Teapot" },
      { message = "The server refuses to brew coffee because it is a teapot." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:MethodNotAllowed(messages)
  ---@type HttpResponse
  local response = {
    status = 405,
    errors = {
      { message = "Method Not Allowed" },
      { message = "The request method is not supported for the requested resource." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:BadGateway(messages)
  ---@type HttpResponse
  local response = {
    status = 502,
    errors = {
      { message = "Bad Gateway" },
      { message = "The server received an invalid response from the upstream server." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:ServiceUnavailable(messages)
  ---@type HttpResponse
  local response = {
    status = 503,
    errors = {
      { message = "Service Unavailable" },
      { message = "The server is currently unable to handle the request due to temporary overloading or maintenance." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:GatewayTimeout(messages)
  ---@type HttpResponse
  local response = {
    status = 504,
    errors = {
      { message = "GatewayTimeout" },
      { message = "The server did not receive a timely response from the upstream server." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

function Exception:PreconditionFailed(messages)
  ---@type HttpResponse
  local response = {
    status = 412,
    errors = {
      { message = "Precondition Failed" },
      { message = "One or more conditions given in the request header fields evaluated to false." },
    },
  }

  if messages then
    for _, msg in pairs(messages) do
      table.insert(response.errors, msg)
    end
  end

  return response
end

return Exception
