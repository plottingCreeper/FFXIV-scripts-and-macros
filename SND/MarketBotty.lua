--[[
    MarketBotty! Fuck it, I'm going there. Don't @ me. 
]]

NumberOfRetainers = 9

------------------------------
function OpenRetainer(r)
    yield("/waitaddon RetainerList")
    yield("/click select_retainer"..r.." <wait.1>")
    if IsAddonVisible("SelectString")==false then yield("/click talk <wait.1>") end 
    if IsAddonVisible("SelectString")==false then yield("/click talk <wait.1>") end 
    yield("/waitaddon SelectString") 
    yield("/click select_string3") 
end

function CloseRetainer()
    yield("/pcall RetainerSellList true -2")
    yield("/pcall RetainerSellList true -1")
    yield("/waitaddon SelectString")
    yield("/pcall SelectString true -1 <wait.1>")
    yield("/click talk")
end

-------------------------------
for retainer = 1, NumberOfRetainers do 
    OpenRetainer(retainer)

    for list = 0, 19 do
        yield("/waitaddon RetainerSellList")
        yield("/pcall RetainerSellList true 0 "..list.." 1 <wait.0.1>")
        if IsAddonVisible("ContextMenu") then yield("/pcall ContextMenu true 0 0 <wait.1>") else break end
        dfhkldunjfbkzdnf
    end

    CloseRetainer()
end