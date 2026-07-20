-- vape/init.lua: loader placed inside the `vape` folder so
-- users can load '.../vape/init.lua' directly.
local rs = game:GetService("ReplicatedStorage")
local chatEvents = rs:FindFirstChild("DefaultChatSystemChatEvents")
if not chatEvents then
    chatEvents = Instance.new("Folder")
    chatEvents.Name = "DefaultChatSystemChatEvents"
    chatEvents.Parent = rs
end

local _converted = {}
local function ensureRemote(name)
    local existing = chatEvents:FindFirstChild(name)
    if existing then
        if existing.ClassName ~= "RemoteEvent" then
            existing:Destroy()
            local ev = Instance.new("RemoteEvent")
            ev.Name = name
            ev.Parent = chatEvents
        end
    else
        local ev = Instance.new("RemoteEvent")
        ev.Name = name
        ev.Parent = chatEvents
    end

    if not _converted[name] then
        _converted[name] = true
        chatEvents.ChildAdded:Connect(function(child)
            if child.Name == name and child.ClassName ~= "RemoteEvent" then
                pcall(function() child:Destroy() end)
                local ev = Instance.new("RemoteEvent")
                ev.Name = name
                ev.Parent = chatEvents
            end
        end)
    end
end

ensureRemote("OnNewMessage")
ensureRemote("OnMessageDoneFiltering")
ensureRemote("SayMessageRequest")

-- Aggressively replace any existing BindableEvent children for a short window
spawn(function()
    local t0 = tick()
    while tick() - t0 < 5 do -- 5 seconds
        for _, child in pairs(chatEvents:GetChildren()) do
            if (child.ClassName == "BindableEvent") then
                local name = child.Name
                pcall(function() child:Destroy() end)
                if not chatEvents:FindFirstChild(name) then
                    local ev = Instance.new("RemoteEvent")
                    ev.Name = name
                    ev.Parent = chatEvents
                end
            end
        end
        task.wait(0.05)
    end
end)

local url = 'https://raw.githubusercontent.com/LOVEVAPE/snoopyv6/main/vape/CustomModules/6872274481.lua'
local ok, chunk = pcall(function()
    return loadstring(game:HttpGet(url), 'vape_init_loader')
end)
if not ok or type(chunk) ~= 'function' then
    warn('vape/init.lua: failed to load module from', url)
    return function() end
end

return chunk(...)
