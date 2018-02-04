import strutils


proc CleanDatabaseName* (database: var string): void {.gcsafe.} =
  database = database.toLower
                     .replace("-", "_")
                     .replace(":", "")
                     .replace("+", "")
