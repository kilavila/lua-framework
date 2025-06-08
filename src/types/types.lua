---@meta

-- This is a demo file for writing types.
-- You can create your own types here or
-- you can write the types directly in
-- your code(as I have done throughout this project).
--
-- https://luals.github.io/wiki/annotations

---| This is a comment for the AppController class.
---| Proper typing can be very useful!
---@class AppController
---@field status fun(request: HttpRequest): HttpResponse
---@field test fun(request: HttpRequest): HttpResponse

---@alias UnitTest fun(test: TestModule): nil
