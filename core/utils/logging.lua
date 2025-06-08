---| Module for logging output to the console.
---@class LoggerModule
---@field new fun(self: LoggerModule): LoggerModule ---| Creates new instance of LoggerModule.
---@field success fun(self: LoggerModule, message: string): nil ---| Print success message to console.
---@field info fun(self: LoggerModule, message: string): nil ---| Print info message to console.
---@field warn fun(self: LoggerModule, message: string): nil ---| Print warn message to console.
---@field error fun(self: LoggerModule, message: string): nil ---| Print error message to console.
local Logger = {}
Logger.__index = Logger

function Logger:new()
  local instance = setmetatable({}, Logger)
  return instance
end

---| Table of available colors for logging.
---@type table
local colors = {
  reset = "\27[0m",
  red = "\27[31m",
  green = "\27[32m",
  yellow = "\27[33m",
  blue = "\27[34m",
  magenta = "\27[35m",
  cyan = "\27[36m",
  white = "\27[37m",
}

---| Returns current date and time in a nice format.
---| Format: day/month/year, hour:min:sec
---@type fun(): string
local function datetime()
  local current_time = os.date("*t")

  ---datetime as "day/month/year, hour:minutes:seconds"
  local formatted_datetime = string.format(
    "%02d/%02d/%04d, %02d:%02d:%02d",
    current_time.day,
    current_time.month,
    current_time.year,
    current_time.hour,
    current_time.min,
    current_time.sec
  )

  return formatted_datetime
end

---| Returns a nicely formatted string for logging.
---@type fun(): string
---@param type string
---@param color string
---@param message string
local function format(type, color, message)
  local msg =
    string.format("[ %s%s%s ] - %s - %s%s%s", color, type, colors.reset, datetime(), color, message, colors.reset)
  return msg
end

function Logger:success(message)
  local msg = format("OK", colors.green, message)
  print(msg)
end

function Logger:info(message)
  local msg = format("INFO", colors.blue, message)
  print(msg)
end

function Logger:warn(message)
  local msg = format("WARN", colors.yellow, message)
  print(msg)
end

function Logger:error(message)
  local msg = format("ERROR", colors.red, message)
  print(msg)
end

return Logger
