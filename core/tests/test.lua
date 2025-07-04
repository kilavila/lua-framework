local Logger = require("core.utils.logging")

---| Values for the current test.
---@class CurrentTest
---@field time { start: number|nil, stop: number|nil } ---| Start and stop time for current test.
---@field title string|nil ---| Title of current test.
---@field result any ---| The result of the provided function.
---@field passed boolean|nil ---| If the test passed or failed.
---@field tests table|nil ---| Table of all the tests for the given function.

---| Module for unit testing.
---@class TestModule
---@field current CurrentTest
---@field failed number ---| Number of failed tests.
---@field passed number ---| Number of passed tests.
---@field total number ---| Total number of tests.
---@field time number ---| Total time spent running tests.
---@field logger LoggerModule
---@field new fun(self: TestModule): TestModule ---| Creates new instance of TestModule.
---@field check_tables fun(self: TestModule, result: table, expected: table): boolean ---| Checking if tables are identical.
---@field expect fun(self: TestModule, title: string, func: any): TestModule ---| Creates new test.
---@field to_be fun(self: TestModule, result: any): TestModule ---| Expect result of function to match provided result.
---@field to_be_type fun(self: TestModule, expected_type: string): TestModule ---| Expect result of function to match provided type.
---@field log fun(self: TestModule): nil ---| Logging test result to console.
---@field summary fun(self: TestModule): nil ---| Logging summary of all test.
local Test = {
  current = {
    time = {
      start = nil,
      stop = nil,
    },
    title = nil,
    result = nil,
    passed = nil,
    tests = nil,
  },
  failed = 0,
  passed = 0,
  total = 0,
  time = 0,
}
Test.__index = Test

function Test:new()
  local instance = setmetatable({}, Test)
  instance.logger = Logger:new()
  return instance
end

---| Table of all available colors for logging.
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
  gray = "\27[30m",
}

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

function Test:expect(title, func)
  self.current.time = {}
  self.current.time.start = os.clock()
  self.current.title = title
  self.current.result = func
  self.current.passed = true
  self.current.tests = {}
  return self
end

function Test:to_be(result)
  if not result then
    self.logger:error("Function 'to_be()' expects a parameter")
  end

  if not self.current.result then
    self.logger:error("Could not find a return value from function, remember to call ':expect()'")
  end

  local pass = true
  local message = "Correct return value"

  if type(result) == "table" then
    local is_identical = self:check_tables(self.current.result, result)
    if not is_identical then
      pass = false
      message = "Wrong return value"
      self.current.passed = false
    end
  else
    if self.current.result ~= result then
      pass = false
      message = "Wrong return value"
      self.current.passed = false
    end
  end

  table.insert(self.current.tests, {
    pass = pass,
    message = message,
    expected = result,
    response = self.current.result,
  })

  return self
end

function Test:to_be_type(expected_type)
  if not expected_type then
    self.logger:error("Function 'to_be_type()' expects a parameter")
  end

  if not self.current.result then
    self.logger:error("Could not find a return value from function, remember to call ':expect()'")
  end

  local pass = true
  local message = "Correct return type"

  if type(self.current.result) ~= expected_type then
    pass = false
    message = "Wrong return type"
    self.current.passed = false
  end

  table.insert(self.current.tests, {
    pass = pass,
    message = message,
    expected = expected_type,
    response = type(self.current.result),
  })

  return self
end

function Test:log()
  local overall_status = colors.green .. "PASS" .. colors.reset

  if self.current.passed then
    self.passed = self.passed + 1
  else
    self.failed = self.failed + 1
    overall_status = colors.red .. "FAIL" .. colors.reset
  end

  self.total = self.total + 1
  self.current.time.stop = os.clock()
  self.time = self.time + ((self.current.time.stop - self.current.time.start) * 1000)

  local test_title = string.format(
    "[ %s ] %s - %s%.3fms%s",
    overall_status,
    self.current.title,
    colors.yellow,
    (self.current.time.stop - self.current.time.start) * 1000,
    colors.reset
  )
  print("")
  print(test_title)

  for _, check in pairs(self.current.tests) do
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

-- TODO: implement more functionality
--
-- exact:
-- not_to_be
-- not_to_be_type
--
-- equal but not exact:?
-- to_equal
-- not_to_equal
--
-- nil:
-- to_be_nil
-- not_to_be_nil
--
-- boolean:
-- to_be_true
-- to_be_false
--
-- numbers:
-- to_be_greater_than
-- to_be_greater_than_or_equal
-- to_be_less_than
-- to_be_less_than_or_equal
--
-- strings:
-- to_match
-- not_to_match
--
-- tables:
-- to_contain
-- not_to_contain
