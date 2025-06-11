---@meta

---| Routing table for the application.
---| Example:
---|
---|  local Routes = {
---|
---|    \["/path"] = {
---|      name = "ControllerName",
---|      entities = {
---|
---|        \["/path"] = {
---|          method = "GET",
---|          fun = Controller.function,
---|          docs = {
---|            description = "Enpoint description",
---|            request = {
---|              "Example request",
---|            },
---|            response = {
---|              "Example response",
---|            },
---|          },
---|        },
---|
---|      },
---|    },
---|
---|  }
---@alias Routes table<{ [string]: Controller }>

---@alias EntityFunction fun(request: RequestData): HttpResponse
---@alias GuardFunction fun(request: RequestData): HttpResponse
---@alias Guard fun(func: EntityFunction): GuardFunction

---| Http status code.
---| See: [MDN: HTTP status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status).
---@alias HttpStatusCode number

---| 400 Bad Request
---| The request could not be understood by the server.
---@alias BadRequestException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 401 Unauthorized
---| Authentication is required to access this resource.
---@alias UnauthorizedException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 404 Not found
---| The requested resource could not be found.
---@alias NotFoundException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 403 Forbidden
---| You do not have permission to access this resource.
---@alias ForbiddenException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 406 NotAcceptable
---| The requested resource is not available in a format acceptable to the client.
---@alias NotAcceptableException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 408 RequestTimeout
---| The server timed out waiting for the request.
---@alias RequestTimeoutException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 409 Conflict
---| The request could not be completed due to a conflict with the current state of the resource.
---@alias ConflictException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 410 Gone
---| The requested resource is no longer available and has been permanently removed.
---@alias GoneException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 505 HttpVersionNotSupported
---| The server does not support the HTTP protocol version that was used in the request.
---@alias HttpVersionNotSupportedException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 413 ContentTooLarge
---| The request entity is larger than the server is willing or able to process.
---@alias ContentTooLargeException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 415 UnsupportedMediaType
---| The media type of the request data is not supported by the server.
---@alias UnsupportedMediaTypeException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 422 UnprocessableContent
---| The request was well-formed but could not be processed due to semantic errors.
---@alias UnprocessableContentException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 500 InternalServerError
---| The server encountered an unexpected condition that prevented it from fulfilling the request.
---@alias InternalServerErrorException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 501 NotImplemented
---| The server does not support the functionality required to fulfill the request.
---@alias NotImplementedException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 418 Teapot
---| The server refuses to brew coffee because it is a teapot.
---@alias TeapotException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 405 MethodNotAllowed
---| The request method is not supported for the requested resource.
---@alias MethodNotAllowedException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 502 BadGateway
---| The server received an invalid response from the upstream server.
---@alias BadGatewayException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 503 ServiceUnavailable
---| The server is currently unable to handle the request due to temporary overloading or maintenance.
---@alias ServiceUnavailableException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 504 GatewayTimeout
---| The server did not receive a timely response from the upstream server.
---@alias GatewayTimeoutException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse

---| 412 PreconditionFailed
---| One or more conditions given in the request header fields evaluated to false.
---@alias PreconditionFailedException fun(self: HttpExceptionModule, messages?: string[]): HttpResponse
