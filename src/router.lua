local app_controller = require("src.app_controller")

---@type Router
M = {
  ["/app"] = {
    name = "app_controller",
    entities = {
      ["/status"] = {
        method = "GET",
        fun = app_controller.status,
      },
    },
  },
}

return M
