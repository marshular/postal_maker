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

local function isEmpty(table)
    for _, _ in pairs(table) do
        return false
    end
    return true
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
                TriggerEvent('chat:addMessage', {args = {"ERROR", "Code does not exist"}})
            else
                table.remove(currentPostals, vaild)
                TriggerEvent('chat:addMessage', {args = {"SUCCESS", "Deleted postal: " .. code}})
            end
        else
            TriggerEvent('chat:addMessage', {args = {"ERROR", "Missing 'CODE' value"}})
        end
    elseif type == "add" then
        if code then
            table.insert(currentPostals, {x = coords.x, y = coords.y, code = code})
            TriggerEvent('chat:addMessage', {args = {"SUCCESS", "Added postal: " .. code}})
        else
            TriggerEvent('chat:addMessage', {args = {"ERROR", "Missing 'CODE' value"}})
        end
    elseif type == "load" then
        if not isEmpty(currentPostals) then
            TriggerServerEvent(GetCurrentResourceName() .. ":server:loadPostals", currentPostals)
            TriggerEvent('chat:addMessage', {args = {"SUCCESS", "Loaded postals"}})
        else
            TriggerEvent('chat:addMessage', {args = {"ERROR", "Postals table is empty"}})
        end
    elseif type == "clear" then
        if not isEmpty(currentPostals) then
            TriggerEvent('chat:addMessage', {args = {"SUCCESS", "Cleared postals"}})
            for k, v in pairs(currentPostals) do 
                currentPostals[k] = nil 
            end
        else
            TriggerEvent('chat:addMessage', {args = {"ERROR", "Postals table is already empty"}})
        end
    elseif type == "list" then
        if not isEmpty(currentPostals) then
            printTable(currentPostals, 1)
            TriggerEvent('chat:addMessage', {args = {"SUCCESS", "Printed list of postals in console"}})
        else
            TriggerEvent('chat:addMessage', {args = {"ERROR", "Postals table is empty"}})
        end
    end
end)

TriggerEvent('chat:addSuggestion', '/pmake', 'Postal maker.', {
    { name = "type", help = "Add/Remove/Load/Clear/List" },
    { name = "code", help = "The postal code you would like to delete. (only required if type is add/remove)" }
})