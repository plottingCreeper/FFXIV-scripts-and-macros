--[[
/pcall GrandCompanySupplyList true -1
/waitaddon SelectString
/click select_string4
/wait 1
/target Storm Quartermaster
/send NUMPAD0
/waitaddon GrandCompanyExchange <wait.1>
/pcall GrandCompanyExchange true 1 0
/pcall GrandCompanyExchange true 2 1
/pcall GrandCompanyExchange false 0 0 390 0 True False 0 0 0
/wait 5
/pcall GrandCompanyExchange true -1
/target Storm Personnel Officer
/wait 1
/send NUMPAD0
/waitaddon SelectString
/click select_string1
/wait 1
/ays deliver

/pcall GrandCompanySupplyList true 1 0 0
/waitaddon GrandCompanySupplyList <wait.1>
--]]
venturesToBuy = 390
GC = Flame -- Storm, Flame, Serpent

run = 1
while (run==1) then
    if IsAddonVisible("GrandCompanyExchange") then
        yield("/echo BUYING "..venturesToBuy.." VENTURES")
        yield("/pcall GrandCompanyExchange true 1 0")
        yield("/pcall GrandCompanyExchange true 2 1")
        yield("/pcall GrandCompanyExchange false 0 0 "..venturesToBuy.." 0 True False 0 0 0")
    
        yield("/echo QUIT")
        yield("/pcall GrandCompanyExchange true -1")
    
    else if IsAddonVisible("GrandCompanySupplyList") then
        yield("/echo EXPERT DELIVERY")
        ed = 1
        while (ed == 1) then 
            yield("/pcall GrandCompanySupplyList true 1 0 0") --TODO: Detect item list is empty
            yield("/waitaddon GrandCompanySupplyList <wait.0.5>")
            if IsAddonVisible(" ") then ed = 0 end --TODO: Find full seals popup window (YesNo?). 
        end    
        yield("/echo QUIT")
        yield("/pcall GrandCompanySupplyList true -1")
        yield("/waitaddon SelectString")
        yield("/pcall SelectString true -1 <wait.1>")
    end
end



yield("")
