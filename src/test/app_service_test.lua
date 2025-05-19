local AppService = require("src.app_service")

local function app_service_test(test)
  test:expect("AppService.status()", {
    func = AppService.status(),
    result = {
      status = 200,
      data = {
        { message = "Server online!" },
      },
    },
    type = "table",
  })

  test:expect("AppService.echo()", {
    func = AppService.echo("this is a test"),
    result = "this is a test",
    type = "string",
  })
end

return app_service_test
