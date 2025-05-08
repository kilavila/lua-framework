M = {}

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

local datetime = function()
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

local format = function(type, color, message)
  local msg =
    string.format("[ %s%s%s ] - %s - %s%s%s", color, type, colors.reset, datetime(), color, message, colors.reset)
  return msg
end

---@type fun(): nil
---@param message string
function M:success(message)
  local msg = format("OK", colors.green, message)
  print(msg)
end

---@type fun(): nil
---@param message string
function M:info(message)
  local msg = format("INFO", colors.blue, message)
  print(msg)
end

---@type fun(): nil
---@param message string
function M:warn(message)
  local msg = format("WARN", colors.yellow, message)
  print(msg)
end

---@type fun(): nil
---@param message string
function M:error(message)
  local msg = format("ERROR", colors.red, message)
  print(msg)
end

return M
