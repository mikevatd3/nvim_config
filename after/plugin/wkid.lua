local source = {}


source.new = function ()
   local self = setmetatable({ cache = {} }, { __index = source })

   return self
end


local function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*a")
    f:close()
    print("This didn't fail")
    return content
end


local variablesFile = readAll(
    "/home/michael/reference/variables.json"
)

local parsed = vim.fn.json_decode(variablesFile)

local items = {}
for label, details in pairs(parsed.variables) do
   table.insert(items, {
       label = label,
       documentation = {
           kind = "markdown",
           value = details.label
       },
   })
end

source.complete = function (self, _, callback)
    callback { items = items, isIncomplete = false }
end


source.get_trigger_characters = function ()
    return { "S", "B", "C" }
end


require("cmp").register_source("test", source.new())
