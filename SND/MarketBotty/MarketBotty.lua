--[[
/echo Don't forget to click lua!
/pcraft stop
    WORK IN PROGRESS (that means it doesn't work yet)
    MarketBotty! Fuck it, I'm going there. Don't @ me. 
]]


yield("/echo You've loaded the first skeleton of MarketBotty.")
yield("/echo Development is continuing offline for now, because people are fucking stupid.")
yield("/echo MarketBotty 1.0 will be uploaded when it's done.")
yield("/pcraft stop")
yield("/pcraft stop")
yield("/pcraft stop")



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

function ItemList()
    ItemList = {}
    for i= 1, 20 do
        RawText = GetNodeText("RetainerSellList", 10, i, 11)
        TextLetters = string.gsub(RawText,"%W","")
        TextTrimmed = string.sub(TextLetters,3,-3)
        if TextTrimmed > "" then
            ItemList[i] = TextTrimmed
        end
    end 
    for i = 1,20 do
        if ItemList[i] then
            yield("/echo "..ItemList[i])
        end
    end 
end

function SearchPrices()
    SearchPrices = {}
    for i= 1, 20 do
        RawPrice = GetNodeText("ItemSearchResult", 5, i, 10)
        if RawPrice ~= 10 then
            TrimmedPrice = string.gsub(RawPrice,"%D","")
            SearchPrices[i] = TrimmedPrice
        end
    end 
    for i = 1,20 do
        if SearchPrices[i] then
            yield("/echo "..SearchPrices[i])
        end
    end 
end

function RetainerName()
    RetainerNames = {}
    for i= 1, 20 do
        ListName = GetNodeText("ItemSearchResult", 5, i, 5)
        if ListName ~= 5 then
            RetainerNames[i] = ListName
        end
    end 
    for i = 1,20 do
        if RetainerNames[i] then
            yield("/echo "..RetainerNames[i])
        end
    end 
end

function SetPrice(price)
    yield("/pcall ItemSearchResult true -1")
    yield("/pcall RetainerSell true 2 "..price)
    yield("/pcall RetainerSell true 0")
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
