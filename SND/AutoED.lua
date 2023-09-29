--[[
/waitaddon DON'T_FORGET_TO_PRESS_LUA
/waitaddon DON'T_FORGET_TO_PRESS_LUA
/waitaddon DON'T_FORGET_TO_PRESS_LUA
    Automagic grand company expert delivery and purchase script for SomethingNeedDoing
    Written by plottingCreeper, with help from Thee
    
    Requires:
        SomethingNeedDoing
        Pandora v69
    Advanced requirements:
        SomethingNeedDoing (Expanded Edition)
        Island Sanctuary Automation
--]]

-- CONFIGURE THESE BEFORE USE
GrandCompany = "auto" -- "Storm", "Flame", "Serpent", "auto" (auto requires SND expanded)
WhatToBuy = "Ventures" -- "Ventures", "Paper", "Sap", "Coke", "MC3", "MC4"
NumberToBuy = "max" -- Can be a number or "max"
UseSealBuff = "yes"  -- Whether to use Priority Seal Allowance
VenturesUntil = 10000
AfterVentures = "Paper" --"Paper", "Sap", "Coke", "MC3", "MC4"
TurninArmoury = "yes" -- Might be dodgy if this doesn't align with your game setting.
CharacterSpecificSettings = true
UseVisland = "fuck no, I haven't finished this part yet"
FinalPurchase = false
CompletionMessage = true
Verbose = true
Debug = true

-- Advanced configuration. Will probably break things and/or get you banned.
ExpertDeliveryThrottle = "0" -- Probably fine at 0, since I have to wait anyway.
PurchaseThrottle = "2"
TargetThrottle = "1"

--    Super experimental character specific settings.
Characters = {
    COPYME = { WhatToBuy = "Ventures", NumberToBuy = "max", UseSealBuff = "yes", VenturesUntil = 65000, AfterVentures = "Sap", TurninArmoury = yes },
    p = { VenturesUntil = 65000, AfterVentures = "MC4" },
    q = { UseSealBuff = "no" },
    Name = { VenturesUntil = 65000 },
}

function CharacterSpecific()
    CurrentChar = GetCharacterName()
    if Verbose then yield("/echo Current character: "..CurrentChar) end
    for CharTest, _ in pairs(Characters) do
        if string.find(string.gsub(CurrentChar,"%W",""), string.gsub(CharTest,"%W","")) then
            CharName = CharTest
            CharSpecific = Characters[CharTest]
            UsingCharSpecific = true
            yield("/echo Found "..CharName)
        end
    end
    if UsingCharSpecific then
        if CharSpecific.WhatToBuy then WhatToBuy = CharSpecific.WhatToBuy end
        if CharSpecific.NumberToBuy then NumberToBuy = CharSpecific.NumberToBuy end
        if CharSpecific.UseSealBuff then UseSealBuff = CharSpecific.UseSealBuff end
        if CharSpecific.VenturesUntil then VenturesUntil = CharSpecific.VenturesUntil end
        if CharSpecific.AfterVentures then AfterVentures = CharSpecific.AfterVentures end
        if CharSpecific.TurninArmoury then TurninArmoury = CharSpecific.TurninArmoury end
        if Debug then 
            if CharSpecific.WhatToBuy then yield("/echo "..CharName.." specific setting: WhatToBuy = "..WhatToBuy) end
            if CharSpecific.NumberToBuy then yield("/echo "..CharName.." specific setting: NumberToBuy = "..NumberToBuy) end
            if CharSpecific.UseSealBuff then yield("/echo "..CharName.." specific setting: UseSealBuff = "..UseSealBuff) end
            if CharSpecific.VenturesUntil then yield("/echo "..CharName.." specific setting: VenturesUntil = "..VenturesUntil) end
            if CharSpecific.AfterVentures then yield("/echo "..CharName.." specific setting: AfterVentures = "..AfterVentures) end
            if CharSpecific.TurninArmoury then yield("/echo "..CharName.." specific setting: TurninArmoury = "..TurninArmoury) end
            yield("/wait 3") 
        end
    else 
        if Verbose then yield("/echo Using general settings") end
    end
end

function OpenPurchase()
    if Verbose then yield("/echo Running OpenPurchase") end
    yield("/target "..GC.." Quartermaster <wait.0.1>")
    yield("/pint <wait.0.1>")
    yield("/pint <wait.0.1>")
    yield("/waitaddon GrandCompanyExchange <wait."..PurchaseThrottle..">")
    step = "Purchase"
end

ItemsTable = { 
    Ventures = { Cost = 200, Page = 0, Tab = 1, Position = 0 },
    Paper = { Cost = 600, Page = 2, Tab = 1, Position = 17 },
    Sap = { Cost = 200, Page = 2, Tab = 4, Position = 30 },
    Coke = { Cost = 200, Page = 2, Tab = 4, Position = 31 },
    MC3 = { Cost = 20000, Page = 2, Tab = 1, Position = 38 },
    MC4 = { Cost = 20000, Page = 2, Tab = 1, Position = 39 },
}

function Purchase()
    if Verbose then yield("/echo Running purchase") end
    CheckSeals()
    if WhatToBuy=="Ventures" then 
        if CheckVentures() >= VenturesUntil then
            WhatToBuy = AfterVentures
        end
    end
    Item = ItemsTable[WhatToBuy]
    if NumberToBuy=="max" then
        Amount = CurrentSeals // Item.Cost
    else
        Amount = tonumber(NumberToBuy)
    end
    if WhatToBuy=="Ventures" then 
        SecondAmount = 0
        if (CurrentVentures+Amount)>65000 then 
            Amount=(65000-CurrentVentures) 
        end
    else
        if Amount > 99 then 
            SecondAmount = Amount - 99
            Amount = 99
        else 
            SecondAmount = 0
        end
    end
    if Verbose then yield("/echo "..NumberToBuy.." "..WhatToBuy) end
    yield("/pcall GrandCompanyExchange true 1 " .. Item.Page)
    yield("/pcall GrandCompanyExchange true 2 " .. Item.Tab)
    yield("/pcall GrandCompanyExchange false 0 " .. Item.Position .. " " .. Amount .." 0 True False 0 0 0")
    if SecondAmount > 0 then 
        yield("/wait 1")
        yield("/pcall GrandCompanyExchange false 0 " .. Item.Position .. " " .. SecondAmount .." 0 True False 0 0 0")
    end
    yield("/wait 0.3")
    if IsAddonVisible("SelectYesno") then yield("/pcall SelectYesno true 0") end
    yield("/wait "..PurchaseThrottle)
    QuitPurchase()
    step = "OpenDeliver"
end

function QuitPurchase()
    if Verbose then yield("/echo Running QuitPurchase") end
    yield("/pcall GrandCompanyExchange true -1")
end

function OpenDeliver()
    if Verbose then yield("/echo Running OpenDeliver") end
    yield("/wait "..TargetThrottle)
    if UseSealBuff=="yes" then SealBuff() end
    yield("/target "..GC.." Personnel Officer <wait.1>")
    yield("/pint <wait.0.1>")
    yield("/pint <wait.0.1>")
    yield("/waitaddon SelectString")
    yield("/click select_string1")
    yield("/waitaddon GrandCompanySupplyList <wait.1>")
    step = "Deliver"
end

function Deliver()
    if Verbose then yield("/echo Running Deliver") end
    ed = 1
    if UseSealBuff=="yes" then SealBuff() end
    while (ed == 1) do
        if TurninArmoury=="yes" then 
            yield("/pcall GrandCompanySupplyList true 5 1 0")
            if Debug then yield("/echo Armoury=yes") end
        else
            yield("/pcall GrandCompanySupplyList true 5 2 0")
            if Debug then yield("/echo Armoury=yes") end
        end
        yield("/wait 0.1")
        if GetNodeText("GrandCompanySupplyList", 5, 2, 4)=="" then
            yield("/echo No more items!")
            ed = 0
            step = "finish"
            break
        end
        CheckSeals()
        if Debug then
            yield("/echo Current : "..CurrentSeals)
            yield("/echo Next Item : "..NextSealValue)
            yield("/echo Current+Next : "..(CurrentSeals + NextSealValue))
            yield("/echo Seals Max : "..MaxSeals)
        end
        if ((CurrentSeals + NextSealValue) > MaxSeals) then
            yield("/echo Current+Next:"..(CurrentSeals + NextSealValue))
            ed = 0
            step = "OpenPurchase"
            break
        end
        yield("/pcall GrandCompanySupplyList true 1 0 0")
        yield("/wait 0.1")
        if IsAddonVisible("GrandCompanySupplyReward") then yield("/pcall GrandCompanySupplyReward true 0") end
        if IsAddonVisible("Request") then
            yield("/echo Request window bug: probably no more items!")
            yield("/pcall Request true 1")
            ed = 0
            step = "finish"
        end
        if IsAddonVisible("SelectYesno") then
            yield("/pcall SelectYesno true 0")
        end
        yield("/waitaddon GrandCompanySupplyList <wait."..ExpertDeliveryThrottle..">")
    end
    QuitDeliver()
end

function QuitDeliver()
    if Verbose then yield("/echo Running QuitDeliver") end
    yield("/pcall GrandCompanySupplyList true -1")
    yield("/waitaddon SelectString")
    yield("/pcall SelectString true -1 <wait.1>")
end

function SealBuff()
    if HasStatus("Priority Seal Allowance")==false then
        if IsAddonVisible("GrandCompanySupplyList") then 
            QuitDeliver() 
            ed = 0
        end
        yield("/wait 1")
        yield("/item Priority Seal Allowance")
        step = "OpenDeliver"
        yield("/wait 4")
    end
end

function CheckSeals(input)
    if IsAddonVisible("GrandCompanySupplyList") then
        NextSealValue = string.gsub(GetNodeText("GrandCompanySupplyList", 5, 2, 4),",","")
        NextSealValue = tonumber(NextSealValue)
        if HasStatus("Priority Seal Allowance") then 
            NextSealValue = math.floor(NextSealValue * 1.15) + 1
        else if HasStatus("Seal Sweetener") then 
                NextSealValue = math.floor(NextSealValue * 1.10) + 1
            end
        end
        RawSeals = string.gsub(GetNodeText("GrandCompanySupplyList", 23),",","")
        CurrentSeals = tonumber(string.sub(RawSeals,1,-7))
        MaxSeals = tonumber(string.sub(RawSeals,-5,-1))
    end
    if IsAddonVisible("GrandCompanyExchange") then
        CurrentSeals = string.gsub(GetNodeText("GrandCompanyExchange", 52),",","")
        CurrentSeals = tonumber(CurrentSeals)
    end
    output = CurrentSeals
    if input == "max" then
        output = MaxSeals
    end
    return output
end

function CheckVentures()
    yield("/pcall GrandCompanyExchange true 1 0")
    yield("/pcall GrandCompanyExchange true 2 1")
    yield("/wait 0.1")
    CurrentVentures = string.gsub(GetNodeText("GrandCompanyExchange", 2, 1, 3),",","")
    CurrentVentures = tonumber(CurrentVentures)
    return CurrentVentures
end

function GetCloser()
    if IsAddonVisible("_TargetInfoMainTarget") then
        yield("/lockon on")
        yield("/automove on")
    end
end

function LeaveInn()
    if IsInZone(177) or IsInZone(178) or IsInZone(179) then
        yield("/target HeavyOaken Door")
        yield("/lockon on")
        yield("/automove on <wait.2>") --TODO check coordinates instead of wait?
        yield("/pint")
        yield("/waitaddon Nowloading <maxwait.15>")
        yield("/waitaddon NamePlate <maxwait.15><wait.5>")
    end
end

function InnToGC()
    if IsInZone(128) then 
        yield("/visland moveto 12 40 12")
        yield("/visland moveto 1.6 40 19.35")
        yield("/visland moveto 2.4 40 73.2")
        yield("/visland moveto 28 40 73.8")
        yield("/visland moveto 94 40 75.2")
    end
    if IsInZone(130) then 
        yield("/visland moveto ")
    end
    if IsInZone(132) then 
    end
end

function GCToInn()
    if IsInZone(128) then 
        yield("/visland moveto 81.5 40 74.1")
        yield("/visland moveto 1 40 71.1")
        yield("/visland moveto 1.2 40 18.2")
        yield("/visland moveto 13.2 40 12.6")
    end
    if IsInZone(130) then 
    end
    if IsInZone(132) then 
    end
end

function EnterInn()
    if IsInZone(128) then 
        GC="Storm" 
    end
    if IsInZone(130) then 
        GC="Flame" 
        yield("/visland moveto ")
    end
    if IsInZone(132) then 
        GC="Serpent" 
    end
end

------------------------------------------------
yield("/waitaddon NamePlate <maxwait.600>")
yield("/echo AutoED is starting...")
step = "Startup"
if IsAddonVisible("GrandCompanyExchange") then
    step = "Purchase"
else
    if IsAddonVisible("GrandCompanySupplyList") then
        step = "Deliver"
    end
end

if CharacterSpecificSettings then CharacterSpecific() end

if UseVisland=="yes" then 
    LeaveInn() 
    InnToGC()
end

if GrandCompany=="auto" then 
    yield("/echo Autodetecting GC")
    if IsInZone(128) then GC="Storm" end
    if IsInZone(130) then GC="Flame" end
    if IsInZone(132) then GC="Serpent" end
    if ( GC=="Storm" or GC=="Flame" or GC=="Serpent" )==false then 
        yield("/echo GC = "..GC)
        yield("/echo ERROR: Auto is set but you are not in a GC zone!")
        step = "finish"
    end
else 
    GC = GrandCompany
end 

--[[
    This is growing out of control, but it's better than not having it. 
    The plan is to add multicharacter mode, and that'll mean it'll take forever to run.
    Better to check everything and fail immediately than to error halfway through an overnight run.
    I guess? Still seems like shit code though. 
]]
if Verbose then yield("/echo Running Validation...") end
if ( GC=="Storm" or GC=="Flame" or GC=="Serpent" )==false then 
    yield("/echo GC = "..GC)
    yield("/echo ERROR: Variable GC does not match expected options")
    step = "finish"
end
if ( WhatToBuy=="Ventures" or "Paper" or "Sap" or "Coke" or "MC3" or "MC4" )==false then 
    yield("/echo WhatToBuy = "..WhatToBuy)
    yield("/echo ERROR: Variable WhatToBuy does not match expected options")
    step = "finish"
end
if ( NumberToBuy>"0" or NumberToBuy=="max" )==false then
    yield("/echo NumberToBuy = "..NumberToBuy)
    yield("/echo ERROR: Variable NumberToBuy is invalid")
    step = "finish"
end
if ( UseSealBuff=="yes" or UseSealBuff=="no" )==false then
    yield("/echo ERROR: UseSealBuff should be yes or no")
    step = "finish"
end
if ( VenturesUntil>0 and VenturesUntil<=65000 )==false then
    yield("/echo NumberToBuy = "..NumberToBuy)
    yield("/echo ERROR: Variable NumberToBuy is invalid")
    step = "finish"
end
if ( AfterVentures=="Ventures" or "Paper" or "Sap" or "Coke" or "MC3" or "MC4" )==false then 
    yield("/echo AfterVentures = "..AfterVentures)
    yield("/echo ERROR: Variable AfterVentures does not match expected options")
    step = "finish"
end
if ( TurninArmoury=="yes" or "no" )==false then
    yield("/echo ERROR: TurninArmoury should be yes or no")
    step = "finish"
end
if ( ExpertDeliveryThrottle>="0" )==false then
    yield("/echo ExpertDeliveryThrottle = "..ExpertDeliveryThrottle)
    yield("/echo ERROR: Variable ExpertDeliveryThrottle not a valid number")
    step = "finish"
end
if ( PurchaseThrottle>="0" )==false then
    yield("/echo PurchaseThrottle = "..PurchaseThrottle)
    yield("/echo ERROR: Variable PurchaseThrottle is not a valid number")
    step = "finish"
end
if ( TargetThrottle>="0" )==false then
    yield("/echo TargetThrottle = "..TargetThrottle)
    yield("/echo ERROR: Variable TargetThrottle is not a valid number")
    step = "finish"
end

if Verbose then yield("/echo Entering main loop.") end

while (step~="finish") do
    if step=="OpenDeliver" then OpenDeliver() end 
    if step=="Deliver" then Deliver() end 
    if step=="QuitDeliver" then QuitDeliver() end 
    if step=="OpenPurchase" then OpenPurchase() end 
    if step=="Purchase" then Purchase() end 
    if step=="QuitPurchase" then QuitPurchase() end 
    if step=="Startup" then step = "OpenDeliver" end
    if Debug then yield("/echo DEBUG: step = "..step) end
    yield ("/wait 1")
end

if FinalPurchase then
    OpenPurchase()
    Purchase()
end

if UseVisland=="yes" then 
    GCToInn()
    EnterInn()
end

if CompletionMessage then
    yield("/echo --------------------")
    yield("/echo AutoED has finished!")
    yield("/echo --------------------")
end
yield("/pcraft stop")