-- init.lua: simple loader that ensures a chat-folder fallback
local rs = game:GetService("ReplicatedStorage")
local chatEvents = rs:FindFirstChild("DefaultChatSystemChatEvents")
if not chatEvents then
    chatEvents = Instance.new("Folder")
    chatEvents.Name = "DefaultChatSystemChatEvents"
    chatEvents.Parent = rs
end

-- Ensure common chat signals exist so scripts that assume them won't error
local function ensureBindable(name)
    if not chatEvents:FindFirstChild(name) then
        local ev = Instance.new("BindableEvent")
        ev.Name = name
        ev.Parent = chatEvents
    end
end

local function ensureRemote(name)
    if not chatEvents:FindFirstChild(name) then
        local ev = Instance.new("RemoteEvent")
        ev.Name = name
        ev.Parent = chatEvents
    end
end

-- Common events used by many chat modules
ensureBindable("OnNewMessage")
ensureBindable("OnMessageDoneFiltering")
ensureRemote("SayMessageRequest")

local url = 'https://raw.githubusercontent.com/LOVEVAPE/snoopyv6/main/vape/CustomModules/6872274481.lua'
local ok, chunk = pcall(function()
    return loadstring(game:HttpGet(url), 'init_loader')
end)
if not ok or type(chunk) ~= 'function' then
    warn('init.lua: failed to load module from', url)
    return function() end
end

return chunk(...)
