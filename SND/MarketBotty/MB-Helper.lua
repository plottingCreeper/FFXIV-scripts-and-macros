--[[
/echo Don't forget to click lua!
/pcraft stop 

  MarketBotty helper script
]]
MarketBotty_script_name = "MarketBotty"
if IsAddonVisible("RecommendList") then
  yield("/echo Ending MarketBuddy helper mode!")
  goto Close
end
::Open::
yield("/recommended")
yield("/waitaddon RecommendList")
if IsAddonVisible("InventoryExpansion") then
  yield("/pcall InventoryExpansion true -1")
  yield("/inventory")
elseif IsAddonVisible("InventoryLarge") then
  yield("/pcall InventoryLarge true -1")
  yield("/inventory")
elseif IsAddonVisible("Inventory") then
  yield("/pcall Inventory true -1")
  yield("/inventory")
end
::MarketBotty::
yield("/pcraft run "..MarketBotty_script_name)
goto EOF
::Close::
yield("/pcall RecommendList true -1")
yield("/pcraft stop")
yield("/pcraft stop")
yield("/pcraft stop")
goto EOF
::EOF::
