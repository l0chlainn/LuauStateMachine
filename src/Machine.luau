local StateMachine = script.Parent
local State = require(StateMachine.State)
local Event = require(StateMachine.Event)

local Machine = {}
Machine.__index = Machine

function Machine.new(states, events, initial)
    if typeof(states) ~= "table" then error("states must be a table!", 2) end
    if typeof(events) ~= "table" then error("events must be a table!", 2) end
    if typeof(initial) ~= "string" then error("initial must be a string!", 2) end

    local statesMap = {}
    for _, state in states do
        if typeof(state) ~= "table" or state.__index ~= State then
            error("state in states must be a State!", 2)
        end
        statesMap[state.name] = state
    end

    local eventsMap = {}
    for _, event in states do
        if typeof(event) ~= "table" or event.__index ~= Event then
            error("event in events must be a Event!", 2)
        end
        eventsMap[event.name] = event
    end

    local initialState = statesMap[initial]
    if not initialState then
        error("initial must be a valid state name!")
    end

    -- construct an instance of Machine
    local self = setmetatable({}, Machine)

    self.currentState = initial

    self._statesMap = statesMap
    self._eventsMap = eventsMap

    initialState:enter()

    return self
end

function Machine:canTriggerEvent(name)
    if typeof(name) ~= "string" then error("name must be a string!", 2) end

    local event = self._eventsMap[name]
    if event and event:canTransitionFromState(self.currentState) then
        return true
    else
        return false
    end
end

function Machine:triggerEvent(name)
    if typeof(name) ~= "string" then error("name must be a string!", 2) end

    local event = self._eventsMap[name]
    if not event then
        return false
    elseif not event:canTransitionFromState(self.currentState) then
        return false
    end

    local currentState = self._statesMap[self.currentState]
    local nextState = self._statesMap[event.toState]

    currentState:exit()
    nextState:enter()

    self.currentState = nextState.name

    return true
end

return Machine
