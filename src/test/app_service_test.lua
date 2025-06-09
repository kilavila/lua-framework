local AppService = require("src.app_service")
local AppController = require("src.app_controller")

--[[
    This is an example of a unit test.
    As shown below you should chain functions together.
    A unit test must always start with the ':expect()' function.
    Chain the funtions you want ending with the ':log()' function.
    In the 'src.test.test' file we end with the ':summary()' function.
    You can run this example with the following command:
       lua src/test/tests.lua
--]]

--- The type alias 'UnitTest' is defined in 'src.types.types'
---@type UnitTest
local function app_service_test(test)
  test
    :expect("AppService.status", AppService.status())
    :to_be({
      status = 200,
      data = {
        { message = "Server online!" },
      },
    })
    :to_be_type("table")
    :log()

  test
    :expect("AppService.echo", AppService.test())
    :to_be({
      status = 200,
      data = {
        { message = "Congrats!" },
      },
    })
    :to_be_type("table")
    :log()
end

return app_service_test
