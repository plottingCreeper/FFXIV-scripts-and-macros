--[[
    Automagic grand company expert delivery and purchase script for SomethingNeedDoing
    Written by plottingCreeper, with help from Thee
    
    Requires:
        SomethingNeedDoing
        Pandora testing
        Probably some other stuff too; good luck!

    First section is the variables. Basically the settings for the script.
    If the script doesn't work for you, double check your variables. 
--]]

GC = "" -- "Storm", "Flame", "Serpent"
WhatToBuy = "Ventures" --"Ventures", "Paper", "Coke", "MC3", "MC4"
NumberToBuy = 390
CompletionSound = "1" -- Should be safe to leave this blank for no sound. Not tested. 
Verbose = 1 -- If something doesn't work, set this to 1 and try again before bothering me about it.
SealBuff = 0

--[[
    This second section is tunables. Hopefully you won't ever have to touch these.
    Very high chance of breaking things here. Don't mess with these unless you understand the script.
--]]

ExpertDeliveryThrottle = 0.2 -- Seconds to wait after handing in each item. This WILL break the script if set too low.
PurchaseThrottle = 2 -- Seconds to wait after buying. Mostly to not be super suspicious to anyone who may be watching.

--[[
    Functions and logic section; where the real work gets done. 
    You shouldn't ever need to mess anything below this point.
--]]

function OpenPurchase()
    if Verbose==1 then yield("/echo Running OpenPurchase") end
    yield("/target "..GC.." Quartermaster <wait.0.1>")
    if IsAddonVisible("_TargetInfoMainTarget") then
        yield("/send NUMPAD0")
        yield("/waitaddon GrandCompanyExchange <wait."..PurchaseThrottle..">")
        step = "Purchase"
    else
        yield("/echo Target not found. Are you at the GC desk?")
        step = "finish"
    end
end

function Purchase()
    if Verbose==1 then yield("/echo Running Purchase "..NumberToBuy.." "..WhatToBuy) end
    if WhatToBuy=="Ventures" then
        yield("/pcall GrandCompanyExchange true 1 0")
        yield("/pcall GrandCompanyExchange true 2 1")
        yield("/pcall GrandCompanyExchange false 0 0 "..NumberToBuy.." 0 True False 0 0 0")
    else
        if WhatToBuy=="Paper" then
            yield("/pcall GrandCompanyExchange true 1 2")
            yield("/pcall GrandCompanyExchange true 2 1")
            yield("/pcall GrandCompanyExchange false 0 17 "..NumberToBuy.." 0 True False 0 0 0")
        else
            if WhatToBuy=="Coke" then
                yield("/pcall GrandCompanyExchange true 1 2")
                yield("/pcall GrandCompanyExchange true 2 4")
                yield("/pcall GrandCompanyExchange false 0 31 "..NumberToBuy.." 0 True False 0 0 0")
            else
                if WhatToBuy=="MC3" then
                    yield("/pcall GrandCompanyExchange true 1 2")
                    yield("/pcall GrandCompanyExchange true 2 1")
                    yield("/pcall GrandCompanyExchange false 0 38 "..NumberToBuy.." 0 True False 0 0 0")
                else
                    if WhatToBuy=="MC4" then
                        yield("/pcall GrandCompanyExchange true 1 2")
                        yield("/pcall GrandCompanyExchange true 2 1")
                        yield("/pcall GrandCompanyExchange false 0 39 "..NumberToBuy.." 0 True False 0 0 0")
                    end
                end
            end
        end
    end
    yield("/wait 0.3")
    if IsAddonVisible("SelectYesno") then yield("/pcall SelectYesno true 0") end
    yield("/wait 1")
    QuitPurchase()
    step = "OpenDeliver"
end

function QuitPurchase()
    if Verbose==1 then yield("/echo Running QuitPurchase") end
    yield("/pcall GrandCompanyExchange true -1")
    yield("/wait 1")
end

function OpenDeliver()
    if SealBuff==1 then SealBuff() end
    if Verbose==1 then yield("/echo Running OpenDeliver") end
    yield("/target "..GC.." Personnel Officer <wait.1>")
    if IsAddonVisible("_TargetInfoMainTarget") then
        yield("/send NUMPAD0")
        yield("/waitaddon SelectString")
        yield("/click select_string1")
        yield("/wait 1")
        step = "Deliver"
    else
        yield("/echo Target not found. Are you at the GC desk?")
        step = "finish"
    end
end

function Deliver()
    if SealBuff==1 then SealBuff() end
    if Verbose==1 then yield("/echo Running Deliver") end
    ed = 1
    while (ed == 1) do
        yield("/pcall GrandCompanySupplyList true 1 0 0")
        yield("/wait 0.1")
        if IsAddonVisible("Request") then
            yield("/pcall Request true 1")
            ed = 0
            step = "finish"
        end
        if IsAddonVisible("GrandCompanySupplyList") then
            ed = 0
            step = "finish"
        else
            if IsAddonVisible("GrandCompanySupplyReward") then yield("/pcall GrandCompanySupplyReward true 0") end
            yield("/wait 0.5")
            if IsAddonVisible("SelectYesno") then
                yield("/pcall SelectYesno true 1")
                ed = 0
                step = "OpenPurchase"
            end
            yield("/waitaddon GrandCompanySupplyList <wait."..ExpertDeliveryThrottle..">")
        end
    end
    QuitDeliver()
end

function QuitDeliver()
    if Verbose==1 then yield("/echo Running QuitDeliver") end
    yield("/pcall GrandCompanySupplyList true -1")
    yield("/waitaddon SelectString")
    yield("/pcall SelectString true -1 <wait.1>")
end

function SealBuff()
    if HasStatus("Priority Seal Allowance")==false then
        if IsAddonVisible("GrandCompanySupplyList") then QuitDeliver() end
        yield("/item Priority Seal Allowance")
        step = "OpenDeliver"
        yield("/wait 2")
    end
end

function GetCloser()
    if IsAddonVisible("_TargetInfoMainTarget") then
        yield("/lockon on")
        yield("/automove on")
    end
end

function Validation()
    if Verbose==1 then yield("/echo Running Validation...") end
    if ( GC=="Storm" or GC=="Flame" or GC=="Serpent" )==false then 
        yield("/echo GC = "..GC)
        yield("/echo ERROR: Variable GC does not match expected options")
        step = "finish"
    else
        if ( WhatToBuy=="Ventures" or WhatToBuy=="Paper" or WhatToBuy=="Coke" or WhatToBuy=="MC3" or WhatToBuy=="MC4" )==false then 
            yield("/echo WhatToBuy = "..WhatToBuy)
            yield("/echo ERROR: Variable WhatToBuy does not match expected options")
            step = "finish"
        else
            if ( NumberToBuy>0 )==false then
                yield("/echo NumberToBuy = "..NumberToBuy)
                yield("/echo ERROR: Variable NumberToBuy is invalid")
                step = "finish"
            else
                if ( ExpertDeliveryThrottle>=0)==false then
                    yield("/echo ExpertDeliveryThrottle = "..ExpertDeliveryThrottle)
                    yield("/echo ERROR: Variable ExpertDeliveryThrottle is not a number")
                    step = "finish"
                else
                    if ( PurchaseThrottle>0)==false then
                        yield("/echo PurchaseThrottle = "..PurchaseThrottle)
                        yield("/echo ERROR: Variable PurchaseThrottle is too short or is not a number")
                        step = "finish"
                    end
                end
            end
        end
    end
end

function Startup()
    if Verbose==1 then yield("/echo Running Startup...") end
    step = "Startup"
    if IsAddonVisible("GrandCompanyExchange") then
        step = "Purchase"
    else
        if IsAddonVisible("GrandCompanySupplyList") then
            step = "Deliver"
        end
    end
end

Validation()
Startup()

if Verbose==1 then yield("/echo Entering main loop.") end

while (step~="finish") do
    if step=="OpenDeliver" then OpenDeliver() end 
    if step=="Deliver" then Deliver() end 
    if step=="QuitDeliver" then QuitDeliver() end 
    if step=="OpenPurchase" then OpenPurchase() end 
    if step=="Purchase" then Purchase() end 
    if step=="QuitPurchase" then QuitPurchase() end 
    if step=="Startup" then step = "OpenDeliver" end
    if Verbose==1 then yield("/echo DEGUG: step = "..step) end
    yield ("/wait 1")
end

yield("/echo COMPLETED <se."..CompletionSound..">")
