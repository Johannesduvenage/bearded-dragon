import strutils


proc CleanDatabaseName* (database: var string): void =
  database = database.toLower
                     .replace("-", "_")
                     .replace(":", "")
                     .replace("+", "")
