--[[
UNFINISHED WORK IN PROGRESS
NOT EVEN READY FOR TESTING

TODO LIST (not exhaustive)
    paper
    coke
    main loop logic
    literally any testing at all
    menu throttle
    variable validation
--]]

--[[
First section is the variables. Basically the settings for the script.
If the script doesn't work, double check your variables. 
--]]

GC = Flame -- Storm, Flame, Serpent
WhatToBuy = Ventures --Ventures, --TODO add more options
NumberToBuy = 390
ExpertDeliveryThrottle = 1 -- Seconds to wait after handing in each item. Will break the script if this is too short. 
MenuThrottle = 2 -- Seconds to wait after buying. Mostly to not be super suspicious to anyone who may be watching
CompletionMessage = COMPLETED <se.1> -- Should be safe to leave this blank for no sound. Not tested. 
Verbose = 1
CompletionCommand = 

--[[
You really shouldn't change anything below here, unless you know what you're doing.
--]]


function OpenPurchase()
    if Verbose==1 then yield("/echo OpenPurchase") end
    yield("/target "..GC.." Quartermaster <wait.0.1>")
    yield("/send NUMPAD0")
    yield("/waitaddon GrandCompanyExchange <wait."..MenuThrottle">")
end


function Purchase()
    if Verbose==1 then yield("/echo Purchase "..NumberToBuy.." "..WhatToBuy) end
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
                step = quit
                break
            end
        end
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
    yield("/send NUMPAD0")
    yield("/waitaddon SelectString")
    yield("/click select_string1")
    yield("/wait 1")
end

function Deliver()
    if Verbose==1 then yield("/echo Deliver") end
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
    if Verbose==1 then yield("/echo QuitDeliver") end
    yield("/pcall GrandCompanySupplyList true -1")
    yield("/waitaddon SelectString")
    yield("/pcall SelectString true -1 <wait.1>")
end


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
            else if ( MenuThrottle>0)==false then
                    yield("/echo MenuThrottle = "..MenuThrottle")
                    yield("/echo ERROR: Variable MenuThrottle is too short or is not a number")
                    break
                end
            end
        end
    end
end

if Verbose==1 then yield("/echo Startup...") end
step = startup
if IsAddonVisible("GrandCompanyExchange") then
    step = Purchase
else if IsAddonVisible("GrandCompanySupplyList") then
    step = Deliver
end

if Verbose==1 then yield("/echo Entering main loop.") end
while (step~=quit) then
    
end
yield("")
yield("/echo "..CompletionMessage)
yield(CompletionCommand)
