local sqlite3 = require("lsqlite3")
local Logger = require("core.utils.logging")

-- TODO: Add more functionality
-- get many
-- get first
-- insert one
-- insert many
-- get linked rows by f.ex id
-- TEST: Test all functions and create example in src -> app service

---| Module for working with SQLite: Object–relational mapping(ORM).
---@class DbServiceModule
---@field database_url string ---| Path to '.db' file.
---@field current { row: string|nil, values: string|nil }
---@field db any
---@field logger LoggerModule
---@field new fun(self: DbServiceModule): DbServiceModule ---| Creates new instance of DbServiceModule
---@field new_model fun(self: DbServiceModule, sql_string: string): boolean ---| Create new database model.
---@field select_from fun(self: DbServiceModule, row: string): DbServiceModule|nil ---| Select which database row to get data from(run this before ':where_values()').
---@field where_values fun(self: DbServiceModule, values: string): table ---| Select which values to get from the row(run this after ':select_from()').
local DatabaseService = {
  database_url = "./dev.db",
  current = {
    row = nil,
    values = nil,
  },
}
DatabaseService.__index = DatabaseService

function DatabaseService:new()
  local instance = setmetatable({}, DatabaseService)
  ---@diagnostic disable-next-line: unused-local
  instance.db = sqlite3.open(DatabaseService.database_url)
  ---@diagnostic disable-next-line: unused-local
  instance.logger = Logger:new()
  return instance
end

function DatabaseService:new_model(sql_string)
  self.db:exec("BEGIN TRANSACTION;")

  local stmt = self.db:exec(sql_string)

  if stmt == sqlite3.OK then
    self.db:exec("COMMIT;")
    return true
  else
    self.db:exec("ROLLBACK;")
    return false
  end
end

function DatabaseService:select_from(row)
  if not row then
    self.logger:error("[DatabaseService] :select_from(row) expected a row name")
    return nil
  end

  DatabaseService.current.row = row
  return self
end

function DatabaseService:where_values(values)
  local stmt = self.db:prepare("SELECT * FROM " .. DatabaseService.current.row .. " WHERE ?")
  stmt:bind_values(values)

  local rows = {}

  while stmt:step() == sqlite3.ROW do
    local new_row = stmt:get_values()
    table.insert(rows, new_row)
  end

  local column_names = stmt:get_unames()
  local result = {}

  for _, row in ipairs(rows) do
    local row_table = {}

    for i, column in ipairs(row) do
      -- TEST: merge column names and column values
      -- row_table[column_names[i]] = column
      table.insert(row_table, column_names[i], column)
    end

    table.insert(result, row_table)
  end

  stmt:finalize()
  return result
end

return DatabaseService
