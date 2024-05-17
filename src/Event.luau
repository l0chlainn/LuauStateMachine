--[[ Event Class ]]--
local Event = {}
Event.__type = "Event"
Event.__index = Event

function Event.new(name, toState, fromStates)
    if typeof(name) ~= "string" then error("name must be a string!", 2) end
    if typeof(toState) ~= "string" then error("toState must be a string!", 2) end
    if typeof(fromStates) ~= "table" then error("fromStates must be a string!", 2) end

    -- construct an instance of Transiton
    local self = setmetatable({}, Event)

    self.name = name

    self.toState = toState
    self.fromStates = fromStates

    return self
end

function Event:canTransitionFromState(name)
    if typeof(name) ~= "string" then error("name must be a string!", 2) end

    for _, state in self.fromStates do
        if state == name then
            return true
        end
    end
    return false
end

return Event
