local currentPostals = {}

local function registerPostal(code, x, y)
    table.insert(currentPostals, {x = x, y = y, code = code})
    print("Postal: " .. code .. " added to table, once finished do /loadpostals.")
end

RegisterCommand('registerpostal', function(source, args, rawCommand)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local code = tonumber(args[1])
    if code then
        registerPostal(code, coords.x, coords.y)
    else
        print('ERROR: Missing "CODE" value')
    end
end)

RegisterCommand('loadpostals', function()
    TriggerServerEvent(GetCurrentResourceName() .. ":server:loadPostals", currentPostals)
    print("Loading postals...")
end)

TriggerEvent('chat:addSuggestion', '/registerpostal', 'Register a postal.', {
    { name = "code", help = "The postal code you would like to put." }
})

TriggerEvent('chat:addSuggestion', '/loadpostals', 'Load currently registered postals.')