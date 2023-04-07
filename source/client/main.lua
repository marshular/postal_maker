local currentPostals = {}

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

RegisterCommand('pmake', function(source, args)
    local type = args[1]
    local code = tonumber(args[2])
    local vaild = getIndex(currentPostals, code)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if type == "remove" then
        if code then
            if vaild == nil then 
                print("ERROR: Code does not exist")
                TriggerEvent('chat:addMessage', {args = {"ERROR", "Code does not exist"}})
            else
                table.remove(currentPostals, vaild)
                print("Deleted postal: " .. code)
                TriggerEvent('chat:addMessage', {args = {"SUCCESS", "Deleted postal: " .. code}})
            end
        else
            print('ERROR: Missing "CODE" value')
            TriggerEvent('chat:addMessage', {args = {"ERROR", "Missing 'CODE' value"}})
        end
    elseif type == "add" then
        if code then
            table.insert(currentPostals, {x = coords.x, y = coords.y, code = code})
            print("Added postal: " .. code)
            TriggerEvent('chat:addMessage', {args = {"SUCCESS", "Added postal: " .. code}})
        else
            print('ERROR: Missing "CODE" value')
            TriggerEvent('chat:addMessage', {args = {"ERROR", "Missing 'CODE' value"}})
        end
    elseif type == "load" then
        TriggerServerEvent(GetCurrentResourceName() .. ":server:loadPostals", currentPostals)
        print("Loaded postals")
        TriggerEvent('chat:addMessage', {args = {"SUCCESS", "Loaded postals"}})
    elseif type == "clear" then
        TriggerEvent('chat:addMessage', {args = {"SUCCESS", "Cleared postals"}})
        for k, v in pairs(currentPostals) do 
            currentPostals[k] = nil 
        end
    elseif type == "list" then
        printTable(currentPostals, 1)
        TriggerEvent('chat:addMessage', {args = {"SUCCESS", "Printed list of postals"}})
    end
end)

TriggerEvent('chat:addSuggestion', '/pmake', 'Postal maker.', {
    { name = "type", help = "Add/Remove/Load/Clear/List" },
    { name = "code", help = "The postal code you would like to delete. (only required if type is add/remove)" }
})