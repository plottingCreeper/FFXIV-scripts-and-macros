chars = {
    'Character Name@Server',
    'Character Name@Server',
    'Character Name@Server',
    'Character Name@Server',
    'Character Name@Server',
    'Character Name@Server',
    'Character Name@Server',
    'Character Name@Server',
    } FirstRun = 1
    
    -- Main loop
    for _, char in ipairs(chars) do
        if FirstRun==0 then
            yield("/echo "..char)
            yield("/ays relog " .. char)
            yield("/waitaddon NowLoading <maxwait.15>")
            yield("/waitaddon NamePlate <maxwait.600><wait.5>")
        end
        FirstRun = 0
        yield("/ays het")
        yield("/wait 0.3")
        if IsAddonVisible("_TargetInfoMainTarget") then
            yield("/waitaddon Nowloading <maxwait.15>")
            yield("/waitaddon NamePlate <maxwait.15><wait.5>")
            yield("/target Summoning Bell <wait.0.1>")
        else
            yield("/target Summoning Bell <wait.0.1>")
        end
        yield("/lockon on")
        yield("/automove on")
        b = 0
        while(b == 0)do
            if IsAddonVisible("RetainerList") then b = 1 else yield("/send NUMPAD0 <wait.1>") end
        end 
    
    -- Normie section
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
                if IsAddonVisible("ContextMenu") then yield("/pcall ContextMenu true 0 0 <wait.2>") else break end
                if IsAddonVisible("ItemHistory") then yield("/pcall ItemHistory true -1 <wait.0.1>") end
                yield("/send NUMPAD0")
                yield("/send NUMPAD0")
                yield("/wait 0.3")
                if IsAddonVisible("ItemSearchResult") then 
                    yield("/wait 2")
                    yield("/send NUMPAD0")
                    yield("/send NUMPAD0")
                end
            end
        
            yield("/pcall RetainerSellList true -2")
            yield("/pcall RetainerSellList true -1")
            yield("/waitaddon SelectString")    -- If it gets stuck here, back out to the retainer list and click resume in SND
            yield("/pcall SelectString true -1 <wait.1>")
            yield("/click talk")
        end
    -- End of normie section
    
    -- Close retainer menu
        yield("/wait 1")
        yield("/pcall RetainerList false -2")
        yield("/pcall RetainerList true -1 <wait.1>")
        yield("/pcall RetainerList false -2")
        yield("/pcall RetainerList true -1 <wait.1>")
    end
    -- Last one out turn off the lights
    yield ("/ays multi")
