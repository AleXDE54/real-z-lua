local HttpService = game:GetService("HttpService")

local url = "https://raw.githubusercontent.com/AleXDE54/real-z-lua/refs/heads/main/lua/realz.lua"
local success, response = pcall(function()
    return HttpService:GetAsync(url)
end)

if success then
    local func, err = loadstring(response)
    if func then
        func()
    else
        warn("Ошибка парсинга скрипта: "..err)
    end
else
    warn("Не удалось загрузить скрипт: "..tostring(response))
end

