local Machine = {}
Machine.__index = Machine

function Machine.new(states, events, initial)
    assert(typeof(states) == "table", "states must be a table!")
    assert(typeof(events) == "table", "events must be a table!")
    assert(typeof(initial) == "string", "initial must be a string!")

    -- construct an instance of Machine
    local self = setmetatable({}, Machine)

    self._states = {}
    for _, state in states do
        self._states[state.name] = state
    end

    self._events = {}
    for _, event in events do
        self._events[event.name] = event
    end

    self.currentState = initial
    local initialState = self._states[initial]
    initialState:enter()

    return self
end

function Machine:canTriggerEvent(name)
    assert(typeof(name) == "string", "name must be a string!")

    local event = self._events[name]
    if event and event:canTransitionFromState(self.currentState) then
        return true
    else
        return false
    end
end

function Machine:triggerEvent(name)
    assert(typeof(name) == "string", "name must be a string!")

    local event = self._events[name]
    if not event then
        return false
    elseif not event:canTransitionFromState(self.currentState) then
        return false
    end

    local currentState = self._states[self.currentState]
    local nextState = self._states[event.toState]

    currentState:exit()
    nextState:enter()

    self.currentState = nextState.name

    return true
end

return Machine
