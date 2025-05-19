local app_service_test = require("src.test.app_service_test")
local Test = require("core.tests.test")

local test = Test:new()

app_service_test(test)
test:summary()
