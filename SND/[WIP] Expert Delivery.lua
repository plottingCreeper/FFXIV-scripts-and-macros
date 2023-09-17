--[[
WORK IN PROGRESS
Untested, but ready to begin testing.

TODO LIST (not exhaustive)
    paper
    coke
    literally any testing at all
    refactor menu throttle
--]]

--[[
    Automagic grand company expert delivery and purchase script for SomethingNeedDoing
    Written by plottingCreeper
    
    Requires:
        SomethingNeedDoing
        Pandora testing
        Probably some other stuff too; good luck!

    First section is the variables. Basically the settings for the script.
    If the script doesn't work for you, double check your variables. 
--]]

GC = Flame -- Storm, Flame, Serpent
WhatToBuy = Ventures --Ventures, Paper, Coke
NumberToBuy = 390
CompletionMessage = COMPLETED <se.1> -- Should be safe to leave this blank for no sound. Not tested. 
CompletionCommand = -- Is this safe to leave blank? To be tested eventually.
Verbose = 1 -- If something doesn't work, set this to 1 and try again before bothering me about it.

--[[
    This second section is tunables. Hopefully you won't ever have to touch these.
    Very high chance of breaking things here. Don't mess with these unless you understand the script.
--]]

ExpertDeliveryThrottle = 1 -- Seconds to wait after handing in each item. This WILL break the script if set too low.
PurchaseThrottle = 2 -- Seconds to wait after buying. Mostly to not be super suspicious to anyone who may be watching.

--[[
    Functions and logic section; where the real work gets done. 
    You shouldn't ever need to mess anything below this point.
--]]

function OpenPurchase()
    if Verbose==1 then yield("/echo OpenPurchase") end
    yield("/target "..GC.." Quartermaster <wait.0.1>")
    yield("/pint")
    yield("/waitaddon GrandCompanyExchange <wait."..PurchaseThrottle">")
    step = Purchase
end

function Purchase() -- TODO paper and coke
    if Verbose==1 then yield("/echo Purchase "..NumberToBuy.." "..WhatToBuy) end
    if WhatToBuy==Ventures then
        yield("/pcall GrandCompanyExchange true 1 0")
        yield("/pcall GrandCompanyExchange true 2 1")
        yield("/pcall GrandCompanyExchange false 0 0 "..NumberToBuy.." 0 True False 0 0 0")
    end
    if WhatToBuy==Paper then
        yield("/pcall GrandCompanyExchange true ")
        yield("/pcall GrandCompanyExchange true ")
        yield("/pcall GrandCompanyExchange false 0 0 "..NumberToBuy.." 0 True False 0 0 0")
    end
    if WhatToBuy==Coke then
        yield("/pcall GrandCompanyExchange true ")
        yield("/pcall GrandCompanyExchange true ")
        yield("/pcall GrandCompanyExchange false 0 0 "..NumberToBuy.." 0 True False 0 0 0")
    end
end

function QuitPurchase()
    if Verbose==1 then yield("/echo QuitPurchase") end
    yield("/pcall GrandCompanyExchange true -1")
end

function OpenDeliver()
    if Verbose==1 then yield("/echo OpenDeliver") end
    yield("/target "..GC.." Personnel Officer")
    yield("/wait 1")
    yield("/pint")
    yield("/waitaddon SelectString")
    yield("/click select_string1")
    yield("/wait 1")
    step = Deliver
end

function Deliver()
    if Verbose==1 then yield("/echo Deliver") end
    ed = 1
    while (ed == 1) then do
        yield("/pcall GrandCompanySupplyList true 1 0 0")
        if IsAddonVisible("GrandcompanySupplyList") then
            ed = 0
            step = finish
        else
            yield("/waitaddon GrandCompanySupplyList <wait."..ExpertDeliveryThrottle..">")
        end
        if IsAddonVisible("SelectYesNo") then
            yield("/pcall SelectYesNo true -1")
            ed = 0
            step = QuitDeliver
        end
    end    
end

function QuitDeliver()
    if Verbose==1 then yield("/echo QuitDeliver") end
    yield("/pcall GrandCompanySupplyList true -1")
    yield("/waitaddon SelectString")
    yield("/pcall SelectString true -1 <wait.1>")
end

function Validation()
    if Verbose==1 then yield("/echo Validation") end
    if ( GC==Storm or GC==Flame or GC==Serpent )==false then 
        yield("/echo GC = "..GC")
        yield("/echo ERROR: Variable GC does not match expected options")
        break
        else if ( WhatToBuy==Ventures or WhatToBuy==Paper or WhatToBuy==Coke )==false then 
            yield("/echo WhatToBuy = "..WhatToBuy")
            yield("/echo ERROR: Variable WhatToBuy does not match expected options")
            break
        else if ( NumberToBuy>0 )==false then
                yield("/echo NumberToBuy = "..NumberToBuy")
                yield("/echo ERROR: Variable NumberToBuy is invalid")
                break
            else if ( ExpertDeliveryThrottle>=0)==false then
                    yield("/echo ExpertDeliveryThrottle = "..ExpertDeliveryThrottle")
                    yield("/echo ERROR: Variable ExpertDeliveryThrottle is not a number")
                    break
                else if ( PurchaseThrottle>0)==false then
                        yield("/echo PurchaseThrottle = "..PurchaseThrottle")
                        yield("/echo ERROR: Variable PurchaseThrottle is too short or is not a number")
                        break
                    end
                end
            end
        end
    end
end

function Startup()
    if Verbose==1 then yield("/echo Startup...") end
    step = Startup
    if IsAddonVisible("GrandCompanyExchange") then
        step = Purchase
    else if IsAddonVisible("GrandCompanySupplyList") then
        step = Deliver
    end
end

Validation()
Startup()

if Verbose==1 then yield("/echo Entering main loop.") end
step = run
while (step~=finish) then do
    if step==OpenDeliver then OpenDeliver() end 
    if step==Deliver then Deliver() end 
    if step==QuitDeliver then QuitDeliver() end 
    if step==OpenPurchase then OpenPurchase() end 
    if step==Purchase then Purchase() end 
    if step==QuitPurchase then QuitPurchase() end 
end

yield("/echo "..CompletionMessage)
yield(CompletionCommand)
