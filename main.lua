currentPostals = {}

function RegisterPostal(code, x, y)
    table.insert(currentPostals, {x = x, y = y, code = code})
    print("Postal: " .. code .. " added to table, once finished do /loadpostals.")
end

function LoadPostals()
    local file = LoadResourceFile(GetCurrentResourceName(), "./postals.json")
    SaveResourceFile(GetCurrentResourceName(), "./postals.json", json.encode(currentPostals, {indent = true}), -1)
    print("Postals loaded!")
end

RegisterCommand('registerpostal', function(args)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if args[1] and args[2] and args [3] then
        RegisterPostal(args[1], args[2], args[3])
    elseif args[1] and not args[2] and args[3] then
        RegisterPostal(args[1], coords.x, args[3])
    elseif args[1] and args[2] and not args[3] then
        RegisterPostal(args[1], args[2], coords.y)
    elseif args[1] and not args[2] and not args[3] then
        RegisterPostal(args[1], coords.x, coords.y)  
    elseif not args[1] and not args[2] and not args[3] then
        print('ERROR: Missing "CODE" value')
    elseif not args[1] and args[2] and args[3] then
        print('ERROR: Missing "CODE" value')
    elseif not args[1] and not args[2] and args[3] then
        print('ERROR: Missing "CODE" value')
    elseif not args[1] and args[2] and not args[3] then
        print('ERROR: Missing "CODE" value')
    end
end)

RegisterCommand('loadpostals', function()
    LoadPostals()
    print("Loading postals...")
end)

TriggerEvent('chat:addSuggestion', '/registerpostal', 'Register a postal.', {
    { name = "code", help = "The postal code you would like to put." },
    { name = "x", help = "The X coordinate of the postal (if not entered will grab your current X coordinate)." },
    { name = "y", help = "The Y coordinate of the postal (if not entered will grab your current y coordinate)." }
})

TriggerEvent('chat:addSuggestion', '/loadpostals', 'Load currently registered postals.')