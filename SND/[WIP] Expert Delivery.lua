--[[
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
GC = Flame -- Storm, Flame, Serpent
WhatToBuy = Ventures --Ventures, --TODO add more options
NumberToBuy = 390
ExpertDeliveryThrottle = 1 -- Seconds to wait after handing in each item. Will break the script if this is too short. 
MenuThrottle = 2 -- Seconds to wait after buying. Mostly to not be super suspicious to anyone who may be watching
CompletionSound = <se.1> -- Should be safe to leave this blank for no sound. Not tested. 

function OpenPurchase()
    yield("/target "..GC.." Quartermaster <wait.0.1>")
    yield("/send NUMPAD0")
    yield("/waitaddon GrandCompanyExchange <wait."..MenuThrottle">")
end


function Purchase()
    yield("/echo Purchase "..NumberToBuy.." "..WhatToBuy)
    if WhatToBuy==Ventures then
        yield("/pcall GrandCompanyExchange true 1 0")
        yield("/pcall GrandCompanyExchange true 2 1")
        yield("/pcall GrandCompanyExchange false 0 0 "..NumberToBuy.." 0 True False 0 0 0")
    else if WhatToBuy==Paper then
        yield("/pcall GrandCompanyExchange true ") --TODO
        yield("/pcall GrandCompanyExchange true ") --TODO
        yield("/pcall GrandCompanyExchange false 0 0 "..NumberToBuy.." 0 True False 0 0 0") --TODO
    else if WhatToBuy==Coke then
        yield("/pcall GrandCompanyExchange true ") --TODO
        yield("/pcall GrandCompanyExchange true ") --TODO
        yield("/pcall GrandCompanyExchange false 0 0 "..NumberToBuy.." 0 True False 0 0 0") --TODO
    else
        yield("/echo Variable WhatToBuy is set as:")
        yield("/echo "..WhatToBuy)
        yield("WhatToBuy invalid - terminating script.")
        run = 0
        break
    end
end


function QuitPurchase()
    yield("/echo QuitPurchase")
    yield("/pcall GrandCompanyExchange true -1")
end



function OpenDeliver()
yield("/target "..GC.." Personnel Officer")
yield("/wait 1")
yield("/send NUMPAD0")
yield("/waitaddon SelectString")
yield("/click select_string1")
yield("/wait 1")
end

function Deliver()
    yield("/echo Deliver")
    ed = 1
    while (ed == 1) then 
        yield("/pcall GrandCompanySupplyList true 1 0 0") --TODO: Detect item list is empty
        if IsAddonVisible("GrandcompanySupplyList")==false then
            yield("/waitaddon GrandCompanySupplyList <wait."..ExpertDeliveryThrottle..">")
        else
            run = 0
            break
        end
        if IsAddonVisible("SelectYesNo") then
            ed = 0
        end
    end    
end


function QuitDeliver()
    yield("/echo QuitDeliver")
    yield("/pcall GrandCompanySupplyList true -1")
    yield("/waitaddon SelectString")
    yield("/pcall SelectString true -1 <wait.1>")
end



run = 1
while (run==1) then
if IsAddonVisible("GrandCompanyExchange") then end
if IsAddonVisible("GrandCompanySupplyList") then end
end
yield("")
yield("/echo COMPLETED "..CompletionSound)
