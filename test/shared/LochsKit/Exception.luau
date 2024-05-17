--[[ Exception Class ]]--
local Exception = {}
Exception.__type = "Exception"
Exception.__index = Exception
Exception.__tostring = function(exception)
    return `Error: {exception.code}, Reason: {exception.reason}`
end

function Exception.new(code, reason)
    if typeof(code) ~= "number" then error("code must be a number!", 2) end
    if typeof(reason) ~= "string" then error("reason must be a string!", 2) end

    -- construct an instance of Exception
    local self = setmetatable({}, Exception)

    self.code = code
    self.reason = reason

    return self
end

return Exception
