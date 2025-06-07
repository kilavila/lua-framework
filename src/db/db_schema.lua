local DatabaseService = require("core.db.db_service")

local db_service = DatabaseService:new()

local users_model = db_service:new_model([[
  CREATE TABLE IF NOT EXISTS Users (
    id TEXT PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    salt TEXT NOT NULL
  );
]])

if not users_model then
  print("Could not create model: Users")
end
