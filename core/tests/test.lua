local Test = {
  failed = 0,
  passed = 0,
  total = 0,
  time = 0,
}
Test.__index = Test

function Test:new()
  local instance = setmetatable({}, Test)
  return instance
end

local colors = {
  reset = "\27[0m",
  red = "\27[31m",
  green = "\27[32m",
  yellow = "\27[33m",
  blue = "\27[34m",
  magenta = "\27[35m",
  cyan = "\27[36m",
  white = "\27[37m",
  gray = "\27[30m",
}

local function log_tests(comment, test)
  local overall_status = colors.green .. "PASS" .. colors.reset

  if not test.passed then
    overall_status = colors.red .. "FAIL" .. colors.reset
  end

  local test_title = string.format(
    "[ %s ] %s - %s%.3fms%s",
    overall_status,
    comment,
    colors.yellow,
    (test.time.stop - test.time.start) * 1000,
    colors.reset
  )
  print("")
  print(test_title)

  for _, check in pairs(test.checks) do
    local msg = ""
    local color = colors.green
    local indent = "         "

    if not check.pass then
      color = colors.red
    end
    msg = string.format(indent .. "%s𜱺%s %s", color, colors.reset, check.message)

    print(msg)
  end
end

function Test:check_tables(result, expected)
  local tables_are_identical = true

  for key, value in pairs(result) do
    if type(value) == "table" then
      local inner_table_is_identical = self:check_tables(value, expected[key])
      if not inner_table_is_identical then
        tables_are_identical = false
      end
    else
      if value ~= expected[key] then
        tables_are_identical = false
      end
    end
  end

  return tables_are_identical
end

function Test:expect(comment, data)
  local new_test = {
    checks = {},
    passed = true,
    time = {},
  }
  new_test.time.start = os.clock()

  local result = data.func

  if data.type then
    if type(result) == data.type then
      table.insert(new_test.checks, {
        pass = true,
        message = "Correct return type",
      })
    else
      table.insert(new_test.checks, {
        pass = false,
        message = "Wrong return type: " .. type(result) .. ". Expected return type: " .. data.type,
      })
      new_test.passed = false
    end
  end

  if type(result) == "table" then
    local is_identical = self:check_tables(result, data.result)
    if is_identical then
      table.insert(new_test.checks, {
        pass = true,
        message = "Correct return value",
      })
    else
      table.insert(new_test.checks, {
        pass = false,
        message = "Wrong return value",
      })
      new_test.passed = false
    end
  else
    if result == data.result then
      table.insert(new_test.checks, {
        pass = true,
        message = "Correct return value",
      })
    else
      table.insert(new_test.checks, {
        pass = false,
        message = "Wrong return value",
      })
      new_test.passed = false
    end
  end

  if new_test.passed then
    self.passed = self.passed + 1
  else
    self.failed = self.failed + 1
  end

  self.total = self.total + 1
  new_test.time.stop = os.clock()
  log_tests(comment, new_test)

  self.time = self.time + ((new_test.time.stop - new_test.time.start) * 1000)
end

function Test:summary()
  local summary = string.format("[ %sSUMMARY%s ]", colors.blue, colors.reset)
  local passed = string.format("%s𜱺 %s passed%s", colors.green, self.passed, colors.reset)
  local failed = string.format("%s𜱺 %s failed%s", colors.red, self.failed, colors.reset)
  local total = string.format(
    "Ran %s%s test(s)%s in %s%.3fms%s",
    colors.blue,
    self.total,
    colors.reset,
    colors.yellow,
    self.time,
    colors.reset
  )
  local divider = string.format("%s-----------%s", colors.gray, colors.reset)

  print("")
  print(divider)
  print("")
  print(summary)
  print(passed)
  print(failed)
  print("")
  print(total)
end

return Test
