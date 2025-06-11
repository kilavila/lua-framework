---@meta

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

---| Incoming request data that has been parsed.
---@class RequestData
---@field body table|nil ---| The request body.
---@field headers table ---| The request headers.
---@field method string ---| Http method used for the incoming request.
---@field origin string ---| Where did the request originate from.
---@field params table|nil ---| URL parameters from the request.
---@field route string ---| The URL route used for the request.

---| Incoming request that has been parsed.
---@class HttpRequest
---@field controller string ---| Which controller that will handle the incoming request.
---@field endpoint string ---| Which endpoint(entity) the controller will use.
---@field method string ---| Http method used for the incoming request.
---@field origin_header string|nil ---| Where did the request originate from.
---@field req RequestData

---| Array of tables containing error messages.
---@class ErrorResponse
---@field message string ---| Error message.

---| Lua table to return as response.
---| Will be parsed to JSON data by HttpModule.
---@class HttpResponse
---@field status HttpStatusCode
---@field errors? ErrorResponse[]
---@field data? table<any> ---| Lua table with data to return as Http response.
---@field meta? table<any> ---| Lua table with meta data to return with the response.

---| Endpoint(entity) documentation accessible at '<url>/docs'.
---@class Docs
---@field description? string ---| Description of the endpoint(entity).
---@field request? string[] ---| Example request.
---@field response? string[] ---| Example response.

---| Entities(services) will handle data storage and retrieval.
---@class Entity
---@field method string ---| Which Http method to use.
---@field fun EntityFunction|Guard ---| What function to run. Either controller function or guard function with controller function as parameter.
---@field docs? Docs

---| Controllers are responsible for handling incoming requests and sending responses back to the client.
---@class Controller
---@field name string ---| The name of the controller. Mainly used for logging and documentation.
---@field entities table<{ [string]: Entity }>
