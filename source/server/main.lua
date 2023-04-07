RegisterNetEvent(GetCurrentResourceName() .. ':server:loadPostals', function(table)
    local file = LoadResourceFile(GetCurrentResourceName(), "./postals.json")
    SaveResourceFile(GetCurrentResourceName(), "./postals.json", json.encode(table, {indent = true}), -1)
end)