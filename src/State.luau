local State = {}
State.__index = State

function State.new(name, onEnter, onExit)
    assert(typeof(name) == "string", "name must be a string!")
    assert(typeof(onEnter) == "function", "onEnter must be a function!")
    assert(typeof(onExit) == "function", "onExit must be a function!")

    -- construct an instance of State
    local self = setmetatable({}, State)

    self.name = name

    self._onEnter = onEnter
    self._onExit = onExit

    return self
end

function State:enter()
    self._onEnter()
end

function State:exit()
    self._onExit()
end

return State
