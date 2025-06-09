local app_service_test = require("src.test.app_service_test")
local Test = require("core.tests.test")

--[[
    Running this file will run all the tests.
    To run individual tests, import 'Test' in
    the specific file and add 'test:summary()' at
    the end of the file.
--]]

---@type TestModule
local test = Test:new()

app_service_test(test)
test:summary()
