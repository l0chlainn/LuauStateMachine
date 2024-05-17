--[[ State Class ]]--
local State = {}
State.__type = "State"
State.__index = State

function State.new(name, onEnter, onExit)
    if typeof(name) ~= "string" then error("name must be a string!", 2) end
    if typeof(onEnter) ~= "function" then error("onEnter must be a function!", 2) end
    if typeof(onExit) ~= "function" then error("onExit must be a function!", 2) end

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
