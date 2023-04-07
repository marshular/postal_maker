local currentPostals = {}

local function registerPostal(code, x, y)
    table.insert(currentPostals, {x = x, y = y, code = code})
    print("Postal: " .. code .. " added to table")
end

local function printTable(table, indent)
    if not indent then indent = 0 end
    for k, v in pairs(table) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            printTable(v, indent+1)
        else
            print(formatting .. v)
        end
    end
end

local function getIndex(table, value)
    local index = nil
    for i, v in ipairs (table) do 
        if (v.code == value) then
            index = i 
        end
    end
    return index
end

RegisterCommand('registerpostal', function(source, args)
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
    print("Loaded postals")
end)

RegisterCommand('clearpostals', function()
    print("Cleared registered postals")
    for k, v in pairs(currentPostals) do 
        currentPostals[k] = nil 
    end
end)

RegisterCommand('listpostals', function()
    printTable(currentPostals, 1)
end)

RegisterCommand('deletepostal', function(source, args)
    local code = tonumber(args[1])
    local vaild = getIndex(currentPostals, code)
    if code then
        if vaild == nil then 
            print("ERROR: Code does not exist")
        else
            table.remove(currentPostals, vaild)
            print("Deleted postal: " .. code)
        end
    else
        print('ERROR: Missing "CODE" value')
    end
end)

TriggerEvent('chat:addSuggestion', '/loadpostals', 'Load currently registered postals.')

TriggerEvent('chat:addSuggestion', '/clearpostals', 'Clear the currently registered postals.')

TriggerEvent('chat:addSuggestion', '/listpostals', 'List out the currently registered postals.')

TriggerEvent('chat:addSuggestion', '/registerpostal', 'Register a postal.', {
    { name = "code", help = "The postal code you would like to put." }
})

TriggerEvent('chat:addSuggestion', '/deletepostal', 'Delete a postal.', {
    { name = "code", help = "The postal code you would like to delete." }
})