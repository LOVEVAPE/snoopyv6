-- init.lua: simple loader that ensures a chat-folder fallback
local rs = game:GetService("ReplicatedStorage")
if not rs:FindFirstChild("DefaultChatSystemChatEvents") then
    local f = Instance.new("Folder")
    f.Name = "DefaultChatSystemChatEvents"
    f.Parent = rs
end

local url = 'https://raw.githubusercontent.com/LOVEVAPE/snoopyv6/main/vape/CustomModules/6872274481.lua'
local ok, chunk = pcall(function()
    return loadstring(game:HttpGet(url), 'init_loader')
end)
if not ok or type(chunk) ~= 'function' then
    warn('init.lua: failed to load module from', url)
    return function() end
end

return chunk(...)
