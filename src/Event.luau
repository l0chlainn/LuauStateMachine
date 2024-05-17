local Event = {}
Event.__index = Event

function Event.new(name, toState, fromStates)
    assert(typeof(name) == "string", "name must be a string!")
    assert(typeof(toState) == "string", "toState must be a string!")
    assert(typeof(fromStates) == "table", "fromStates must be a table!")

    -- construct an instance of Transiton
    local self = setmetatable({}, Event)

    self.name = name

    self.toState = toState
    self.fromStates = fromStates

    return self
end

function Event:canTransitionFromState(name)
    assert(typeof(name) == "string", "name must be a string!")

    for _, state in self.fromStates do
        if state == name then
            return true
        end
    end
    return false
end

return Event
