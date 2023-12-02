chest_tabs_to_empty = { 2, 3, 4 }

for _, tab in ipairs(chest_tabs_to_empty) do
  yield("/pcall FreeCompanyChest true 0 " .. tab -1)
  yield("/wait 1")
  for slot = 1, 50 do
    if GetNodeText("FreeCompanyChest", 5)=="0/50" then break end
    yield("/pcall FreeCompanyChest true 4 " .. slot -1)
    for tick = 1, 10 do
      if IsAddonVisible("ContextMenu") then
        yield("/pcall ContextMenu true 0 0 0 0 0")
        yield("/wait 1.1")
        break
      else
        yield("/wait 0.01")
      end
    end
  end
end
