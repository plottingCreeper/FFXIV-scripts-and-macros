--[[
/wait 1
/target Storm Quartermaster
/send NUMPAD0
/waitaddon GrandCompanyExchange <wait.1>
buy ventures
/wait 5
/pcall GrandCompanyExchange true -1
/target Storm Personnel Officer
/wait 1
/send NUMPAD0
/waitaddon SelectString
/click select_string1
--]]
venturesToBuy = 390

state = 0
if IsAddonVisible("GrandCompanyExchange") then
    state = 1
    yield("/echo BUYING "..venturesToBuy.." VENTURES")
    yield("/pcall GrandCompanyExchange true 1 0")
    yield("/pcall GrandCompanyExchange true 2 1")
    yield("/pcall GrandCompanyExchange false 0 0 "..venturesToBuy.." 0 True False 0 0 0")
else if IsAddonVisible("GrandCompanySupplyList") then
    state = 2
    yield("/echo EXPERT DELIVERY")
    
    yield("/pcall GrandCompanySupplyList true -1")
    yield("/pcall SelectString true -1 <wait.1>")
    end
end
    yield("")
