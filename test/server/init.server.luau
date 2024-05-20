local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")

local StateMachine = require(Shared.StateMachine)
local Machine = StateMachine.Machine
local State = StateMachine.State
local Event = StateMachine.Event

local function enter(name)
    print(`entering {name}...`)
end

local function exit(name)
    print(`exiting {name}...`)
end

local states = {
    State.new("idling", function() enter("idling") end, function() exit("idling") end),
    State.new("walking", function() enter("walking") end, function() exit("walking") end),
    State.new("running", function() enter("running") end, function() exit("running") end),
    State.new("jumping", function() enter("jumping") end, function() exit("jumping") end),
    State.new("landing", function() enter("landing") end, function() exit("landing") end),
}
local events = {
    Event.new("idle", "idling", {"walking", "running", "landing",}),
    Event.new("walk", "walking", {"idling", "running",}),
    Event.new("run", "running", {"idling", "walking",}),
    Event.new("jump", "jumping", {"idling", "walking", "running",}),
    Event.new("land", "landing", {"jumping",}),
}
local machine = Machine.new("idling", states, events)

local function testCurrentState()
    print("testing currentState...")

    local currentState = machine.currentState
    print(`current state is: {currentState}`)
    return currentState == "idling"
end

local function testCanTriggerEvent()
    print("testing canTriggerEvent...")

    -- test allowed transitions
    for _, name in {"walk", "run", "jump",} do
        if not machine:canTriggerEvent(name) then
            return false
        end
    end

    -- test not allowed transitions
    for _, name in {"land", "idle",} do
        if machine:canTriggerEvent(name) then
            return false
        end
    end

    return true
end

local function testTriggerEvent()
    print("testing triggerEvent...")

    -- test event success, order is important!
    for _, name in {"jump", "land", "idle",} do
        local success, response = machine:triggerEvent(name)
        if not success then
            return false
        end
        print(response)
    end

    -- test event failures, one is a fake event!
    for _, name in {"land", "swim",} do
        local success, response = machine:triggerEvent(name)
        if success then
            return false
        end
        print(response)
    end

    return true
end

print("testing StateMachine...")
local resultCurrentState = testCurrentState()
local resultCanTriggerEvent = testCanTriggerEvent()
local resultTriggerEvent = testTriggerEvent()

print("test results:")
print(`currentState: {resultCurrentState}`)
print(`canTriggerEvent: {resultCanTriggerEvent}`)
print(`triggerEvent: {resultTriggerEvent}`)
