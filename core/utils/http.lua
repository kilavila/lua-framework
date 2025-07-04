local json = require("cjson")

---| Module for handling Http responses
---@class HttpModule
---@field new fun(self: HttpModule): HttpModule ---| Creates new instance of HttpModule
---@field respond fun(self: HttpModule, client: table, response: HttpResponse, origin_header: string): nil ---| Send Http response
local Http = {}
Http.__index = Http

function Http:new()
  local instance = setmetatable({}, Http)
  return instance
end

---| Table of all available Http response status codes.
---@type table
local responses = {
  -- Successful responses (200 – 299)
  ["200"] = "200 OK",
  ["201"] = "201 Created",
  ["202"] = "202 Accepted",
  ["203"] = "203 Non-Authoritative Information",
  ["204"] = "204 No Content",
  ["205"] = "205 Reset Content",
  ["206"] = "206 Partial Content",
  ["207"] = "207 Multi-Status",
  ["208"] = "208 Already Reported",
  ["226"] = "226 IM Used",
  -- Client error responses (400 – 499)
  ["400"] = "400 Bad Request",
  ["401"] = "401 Unauthorized",
  ["402"] = "402 Payment Required",
  ["403"] = "403 Forbidden",
  ["404"] = "404 Not Found",
  ["405"] = "405 Method Not Allowed",
  ["406"] = "406 Not Acceptable",
  ["407"] = "407 Proxy Authentication Required",
  ["408"] = "408 Request Timeout",
  ["409"] = "409 Conflict",
  ["410"] = "410 Gone",
  ["411"] = "411 Length Required",
  ["412"] = "412 Precondition Failed",
  ["413"] = "413 Content Too Large",
  ["414"] = "414 URI Too Long",
  ["415"] = "415 Unsupported Media Type",
  ["416"] = "416 Range Not Satisfiable",
  ["417"] = "417 Expectation Failed",
  ["418"] = "418 I'm a teapot",
  ["421"] = "421 Misdirected Request",
  ["422"] = "422 Unprocessable Content",
  ["423"] = "423 Locked",
  ["424"] = "424 Failed Dependency",
  ["425"] = "425 Too Early Experimental",
  ["426"] = "426 Upgrade Required",
  ["428"] = "428 Precondition Required",
  ["429"] = "429 Too Many Requests",
  ["431"] = "431 Request Header Fields Too Large",
  ["451"] = "451 Unavailable For Legal Reasons",
  -- Server error responses (500 – 599)
  ["500"] = "500 Internal Server Error",
  ["501"] = "501 Not Implemented",
  ["502"] = "502 Bad Gateway",
  ["503"] = "503 Service Unavailable",
  ["504"] = "504 Gateway Timeout",
  ["505"] = "505 HTTP Version Not Supported",
  ["506"] = "506 Variant Also Negotiates",
  ["507"] = "507 Insufficient Storage",
  ["508"] = "508 Loop Detected",
  ["509"] = "510 Not Extended",
  ["510"] = "511 Network Authentication Required",
}

function Http:respond(client, response, origin_header)
  local status = responses[tostring(response.status)]
  local response_json = json.encode({
    data = response.data,
    errors = response.errors,
    meta = response.meta,
  })

  local res = "HTTP/1.1 "
    .. status
    .. "\r\n"
    .. "Access-Control-Allow-Origin: "
    .. origin_header
    .. "\r\n"
    .. "Content-Type: application/json\r\n"
    .. "Content-Length: "
    .. #response_json
    .. "\r\n"
    .. "Connection: close\r\n\r\n"
    .. response_json

  client:send(res)
end

return Http
