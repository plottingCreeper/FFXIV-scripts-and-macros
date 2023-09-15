for retainers = 1, 9 do
    yield("/waitaddon RetainerList")
    yield("/click select_retainer"..retainers.." <wait.1>")
    if IsAddonVisible("SelectString")==false then yield("/click talk <wait.1>") end
    if IsAddonVisible("SelectString")==false then yield("/click talk <wait.1>") end
    yield("/waitaddon SelectString")
    yield("/click select_string3")

    for list = 0, 19 do
        yield("/waitaddon RetainerSellList")
        yield("/pcall RetainerSellList true 0 "..list.." 1 <wait.0.1>")
        if IsAddonVisible("ContextMenu") then yield("/pcall ContextMenu true 0 0 <wait.1>") else break end
        a = 0
        while(a == 0)do
            if IsAddonVisible("RetainerSell")==false then a = 1 else yield("/wait 1") end
        end
    end

    yield("/pcall RetainerSellList true -2")
    yield("/pcall RetainerSellList true -1")
    yield("/waitaddon SelectString")
    yield("/pcall SelectString true -1 <wait.1>")
    yield("/click talk")
end
