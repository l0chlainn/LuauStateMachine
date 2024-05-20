local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared

local LochsKit = require(Shared.LochsKit)
local CustomEnum = LochsKit.CustomEnum
local Exception = LochsKit.Exception

local Exceptions = CustomEnum.new({
    InvalidEvent = 0,
    InvalidTransition = 1,
})

--[[ Machine Class ]]--
local Machine = {}
Machine.__type = "Machine"
Machine.__index = Machine

Machine.Exceptions = Exceptions

function Machine.new(initial, states, events)
    if typeof(initial) ~= "string" then error("initial must be a string!", 2) end
    if typeof(states) ~= "table" then error("states must be a table!", 2) end
    if typeof(events) ~= "table" then error("events must be a table!", 2) end

    local statesMap = {}
    for _, state in states do
        if typeof(state) ~= "table" or state.__type ~= "State" then
            error("state in states must be a State!", 2)
        end
        statesMap[state.name] = state
    end

    local eventsMap = {}
    for _, event in events do
        if typeof(event) ~= "table" or event.__type ~= "Event" then
            error("event in events must be a Event!", 2)
        end
        eventsMap[event.name] = event
    end

    local initialState = statesMap[initial]
    if not initialState then
        error("initial must be a valid state name!", 2)
    end

    -- construct an instance of Machine
    local self = {
        currentState = initial,
        _statesMap = statesMap,
        _eventsMap = eventsMap,
    }
    setmetatable(self, Machine)

    -- enter first state so Machine can transition
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
        return false, Exception.new(Exceptions.InvalidEvent, "provided name did not map to a valid event!")
    elseif not event:canTransitionFromState(self.currentState) then
        return false, Exception.new(Exceptions.InvalidTransition, "can not transition from current state!")
    end

    local currentState = self._statesMap[self.currentState]
    local nextState = self._statesMap[event.toState]

    currentState:exit()
    nextState:enter()

    self.currentState = nextState.name

    return true
end

return Machine
