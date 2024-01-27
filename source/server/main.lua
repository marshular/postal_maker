local currentPostals = {}

local function printTable(table, indent)
    if not indent then indent = 0 end
    for k, v in pairs(table) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            printTable(v, indent + 1)
        else
            print(formatting .. v)
        end
    end
end

local function isEmpty(table)
    for _, _ in pairs(table) do
        return false
    end
    return true
end

RegisterCommand('pmake', function(source, args)
    local type, postal = args[1], tonumber(args[2])
    local vaild = lib.table.contains(currentPostals, postal)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local empty = isEmpty(currentPostals)           
    if vaild == nil then return TriggerClientEvent('chat:addMessage', {args = {"ERROR", "Postal does not exist"}}) end
    if type == "remove" then
        if not postal or postal == nil then return TriggerClientEvent('chat:addMessage', {args = {"ERROR", "Missing 'Postal' value"}}) end

        table.remove(currentPostals, vaild)
        TriggerClientEvent('chat:addMessage', {args = {"SUCCESS", "Deleted postal: " .. postal}})
    elseif type == "add" then
        if not postal or postal == nil then return TriggerClientEvent('chat:addMessage', {args = {"ERROR", "Missing 'Postal' value"}}) end

        table.insert(currentPostals, {x = coords.x, y = coords.y, code = postal})
        TriggerClientEvent('chat:addMessage', {args = {"SUCCESS", "Added postal: " .. postal}})
    elseif type == "load" then
        if empty then return TriggerClientEvent('chat:addMessage', {args = {"ERROR", "Postals table is empty"}}) end

        SaveResourceFile(GetCurrentResourceName(), "./postals.json", json.encode(currentPostals, {indent = true}), -1)
        TriggerClientEvent('chat:addMessage', {args = {"SUCCESS", "Loaded postals"}})
    elseif type == "clear" then
        if empty then return TriggerClientEvent('chat:addMessage', {args = {"ERROR", "Postals table is empty"}}) end

        TriggerClientEvent('chat:addMessage', {args = {"SUCCESS", "Cleared postals"}})
        for k, v in pairs(currentPostals) do 
            currentPostals[k] = nil 
        end
    elseif type == "list" then
        if empty then return TriggerClientEvent('chat:addMessage', {args = {"ERROR", "Postals table is empty"}}) end

        printTable(currentPostals, 1)
        TriggerClientEvent('chat:addMessage', {args = {"SUCCESS", "Printed list of postals in console"}})
    end
end, false)