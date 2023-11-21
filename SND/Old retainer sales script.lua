for retainers = 1, 9 do -- First value is retainer number to start at. Second value is retainer number to stop at.
    yield("/waitaddon RetainerList") -- You must have the retainer list open before it will start.
    yield("/click select_retainer"..retainers.." <wait.1>")
    -- What do you mean you don't have YesAlready and/or TextAdvance? Ok, fine, we'll work around that.
    if IsAddonVisible("SelectString")==false then yield("/click talk <wait.1>") end    -- You should install YesAlready
    if IsAddonVisible("SelectString")==false then yield("/click talk <wait.1>") end    -- You should install TextAdvance
    yield("/waitaddon SelectString") -- If it stops here, you probably don't have Pandora >= 1.4.0.6
    yield("/click select_string3")    -- 3 to sell items from player inventory, 4 to sell from retainer inventory

    for list = 0, 19 do
        yield("/waitaddon RetainerSellList")
        yield("/pcall RetainerSellList true 0 "..list.." 1 <wait.0.1>")
        if IsAddonVisible("ContextMenu") then yield("/pcall ContextMenu true 0 0 <wait.1>") else break end
        a = 0
        while(a == 0)do    -- Wait for user to click a price to undercut! Expected but not necessary to use MarketBuddy.
            if IsAddonVisible("RetainerSell") then yield("/wait 1") else  a = 1 end
        end      -- No, it's not stuck! You're expecting a bot, but what you have is not.
    end

    yield("/pcall RetainerSellList true -2")
    yield("/pcall RetainerSellList true -1")
    yield("/waitaddon SelectString")    -- If it gets stuck here, back out to the retainer list and click resume in SND
    yield("/pcall SelectString true -1 <wait.1>")
    yield("/click talk")
end
