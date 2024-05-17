print("testing...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local StateMachine = require(Shared.StateMachine)
local Machine = StateMachine.Machine
local State = StateMachine.State
local Event = StateMachine.Event

local states = {
    State.new("idle", function() print("entering idle...") end, function() print("exiting idle...") end),
    State.new("walking", function() print("entering walk...") end, function() print("exiting walk...") end),
    State.new("running", function() print("entering run...") end, function() print("exiting run...") end),
    State.new("jumping", function() print("entering jump...") end, function() print("exiting jump...") end),
    State.new("landing", function() print("entering land...") end, function() print("exiting land...") end),
}
local events = {
    Event.new("stand", "idle", {"walking", "running", "landing"}),
    Event.new("walk", "walking", {"idle", "running",}),
    Event.new("run", "running", {"idle", "walking",}),
    Event.new("jump", "jumping", {"idle", "walking", "running",}),
    Event.new("land", "landing", {"jumping"}),
}

local machine = Machine.new(states, events, "idle")

-- we should expect to return false, since while in the idle initial state you can't land.
print("Can player land?: " .. tostring(machine:canTriggerEvent("land")))

-- we should expect to return true, since while in the idle initial state you can jump.
print("Can player jump?: " .. tostring(machine:canTriggerEvent("jump")))

machine:triggerEvent("jump")
print("New state is: " .. machine.currentState)

-- we should expect to return true, since while in the jump state you can land.
print("Can player land?: " .. tostring(machine:canTriggerEvent("land")))
