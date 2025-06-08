local sqlite3 = require("lsqlite3")
local Logger = require("core.utils.logging")

-- TODO: Add more functionality
-- get many
-- get first
-- insert one
-- insert many
-- get linked rows by f.ex id
-- TEST: Test all functions and create example in src -> app service

---@class DbServiceModule
---@field database_url string
---@field current { row: string|nil, values: string|nil }
---@field db any
---@field logger LoggerModule
---@field new fun(self: DbServiceModule): DbServiceModule
---@field new_model fun(self: DbServiceModule, sql_string: string): boolean
---@field select_row fun(self: DbServiceModule, row: string): DbServiceModule|nil
---@field where_values fun(self: DbServiceModule, values: string): table
local DatabaseService = {
  database_url = "./dev.db",
  current = {
    row = nil,
    values = nil,
  },
}
DatabaseService.__index = DatabaseService

---@type fun(): DbServiceModule
---@param self DbServiceModule
function DatabaseService:new()
  local instance = setmetatable({}, DatabaseService)
  ---@diagnostic disable-next-line: unused-local
  instance.db = sqlite3.open(DatabaseService.database_url)
  ---@diagnostic disable-next-line: unused-local
  instance.logger = Logger:new()
  return instance
end

---@type fun(): boolean
---@param self DbServiceModule
---@param sql_string string
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

---@type fun(): DbServiceModule|nil
---@param self DbServiceModule
---@param row string
function DatabaseService:select_from(row)
  if not row then
    self.logger:error("[DatabaseService] :select_from(row) expected a row name")
    return nil
  end

  DatabaseService.current.row = row
  return self
end

---@type fun(): table
---@param self DbServiceModule
---@param values string
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
