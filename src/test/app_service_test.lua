local AppService = require("src.app_service")

local function app_service_test(test)
  test
    :expect("AppService.echo", AppService.echo("this is a test"))
    :to_be("Echo: this is a test")
    :to_be_type("string")
    :log()
end

return app_service_test
