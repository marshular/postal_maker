currentPostals = {}

function RegisterPostal(x, y, code)
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
    elseif not args[1] and args[2] and args[3] then
        RegisterPostal(coords.x, args[2], args[3])
    elseif args[1] and not args[2] and args[3] then
        RegisterPostal(args[1], coords.y, args[3])
    elseif not args[1] and not args[2] and args[3] then
        RegisterPostal(coords.x, coords.y, args[3])  
    elseif not args[1] and not args[2] and not args[3] then
        print('ERROR: Missing "CODE" value')
    elseif args[1] and args[2] and not args[3] then
        print('ERROR: Missing "CODE" value')
    elseif not args[1] and args[2] and not args[3] then
        print('ERROR: Missing "CODE" value')
    elseif args[1] and not args[2] and not args[3] then
        print('ERROR: Missing "CODE" value')
    end
end)

RegisterCommand('loadpostals', function()
    LoadPostals()
    print("Loading postals...")
end)