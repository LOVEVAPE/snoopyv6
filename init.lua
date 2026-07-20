-- Forwarding root loader to /vape/init.lua to avoid duplication
local url = 'https://raw.githubusercontent.com/LOVEVAPE/snoopyv6/main/vape/init.lua'
local ok, chunk = pcall(function()
    return loadstring(game:HttpGet(url), 'vape_init_forward')
end)
if ok and type(chunk) == 'function' then
    return chunk(...)
end
warn('init.lua: failed to load vape/init.lua from', url)
return function() end
