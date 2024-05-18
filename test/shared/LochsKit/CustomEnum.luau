--[[ CustomEnum Class ]]--
local CustomEnum = {}
CustomEnum.__type = "CustomEnum"
CustomEnum.__index = function(_, key)
    error(`{key} is not a valid member of CustomEnum`, 2)
end

function CustomEnum.new(enumMap)
    if typeof(enumMap) ~= "table" then error("enumMap must be a table!", 2) end

    for key, value in enumMap do
        if typeof(key) ~= "string" then error("all enumMap keys must be strings!", 2) end
        if typeof(value) ~= "number" then error("all enumMap values must be numbers!", 2) end
    end

    -- construct an instance of CustomEnum
    setmetatable(enumMap, CustomEnum)

    return enumMap
end

return CustomEnum
