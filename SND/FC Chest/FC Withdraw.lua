tabs = {'1', '2', '3', '4', '5'}
for _, tab in ipairs(tabs) do
    yield("/pcall FreeCompanyChest true 0 " .. tab -1)
    yield("/wait 1")
    for slot = 1, 50 do
        yield("/pcall FreeCompanyChest true 4 " .. slot -1)
        yield("/pcall ContextMenu true 0 0 0 0 0")
        yield("/wait 1")
    end
end
