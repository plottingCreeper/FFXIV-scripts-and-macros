--[[
  Jumbo Cactpot claim and purchase script.
  Maybe some extra bits too. Plan is to automate my whole weekly GS visit.
]]


function Talk()
  yield("/wait 0.1")
  while IsAddonVisible("Talk") do
    yield("/click Talk")
    yield("/wait 0.1")
  end
end

function Yesno()
  yield("/wait 0.2")
  if IsAddonVisible("SelectYesno") then
    yield("/pcall SelectYesno true 0")
    yield("/wait 0.1")
  end
end

function Select(i)
  yield("/wait 0.1")
  if IsAddonVisible("SelectString") then
    yield("/click select_string"..i)
    yield("/wait 0.1")
  end
end

function MoveNear(near_x, near_z, near_y, radius, timeout)
  if not radius then radius = 3 end
  if not timeout then timeout = 60 end
  move_x = math.random((near_x-radius)*1000, (near_x+radius)*1000)/1000
  if near_z then
    move_z = near_z
  else
    move_z = math.floor(GetPlayerRawYPos()*1000)/1000
  end
  move_y = math.random((near_y-radius)*1000, (near_y+radius)*1000)/1000
  yield("/visland moveto "..move_x.." "..move_z.." "..move_y)
  yield("/wait 0.5")
  move_tick = 0
  while IsMoving() and move_tick <= timeout do
    move_tick = move_tick + 0.1
    if near_z == false then
        move_z = math.floor(GetPlayerRawYPos()*1000)/1000
        yield("/visland moveto "..move_x.." "..move_z.." "..move_y)
    end
    yield("/wait 0.1")
  end
  yield("/visland stop")
  if is_debug then
    yield("/echo Aimed for: X:"..move_x.." Z:"..move_z.." Y:"..move_y)
    yield("/echo Landed at: X:"..math.floor(GetPlayerRawXPos()*1000)/1000 .." Z:"..math.floor(GetPlayerRawYPos()*1000)/1000 .." Y:"..math.floor(GetPlayerRawZPos()*1000)/1000)
    if move_tick < timeout then 
      reason = "arrived" 
    else 
      reason = "timeout" 
    end
    yield("/echo Reason: "..reason)
  end
  return "X:"..move_x.." Z:"..move_z.." Y:"..move_y
end

----------------------------------------------------------

::Start::
gs = 0

if IsAddonVisible("LotteryWeeklyRewardList") then
  ::NextClaim::
  Yesno()
  Talk()
  if IsAddonVisible("LotteryWeeklyRewardList") then
    yield("/pcall LotteryWeeklyRewardList true -1")
    yield("/wait 1")
    Talk()
    goto NextClaim
  end
  is_tickets_claimed = true
end

if is_tickets_claimed then
  is_tickets_claimed = false
  MoveNear(121, false, -11, 2, 1.5)
  yield("/target Jumbo Cactpot Broker")
  yield("/wait 0.1")
  yield("/pinteract")
  Talk()
  Select(1)
  yield("/wait 2")
end

if IsAddonVisible("LotteryWeeklyInput") then
  four_digit = 9876
  ::BuyTicket::
  if IsAddonVisible("LotteryWeeklyInput") then
    tick = 0
    math.randomseed(os.time()..four_digit)
    random=string.sub(math.random(),3,-1)
    four_digit = string.sub(random,6,9)
    yield("/echo "..random)
    yield("/echo "..four_digit)
    yield("/waitaddon LotteryWeeklyInput")
    yield("/wait 0.1")
    yield("/pcall LotteryWeeklyInput true "..four_digit)
    Yesno()
    Yesno()
    yield("/wait 0.3")
    goto BuyTicket
  elseif tick < 10 then
    Talk()
    yield("/wait 0.1")
    tick = tick + 1
    goto BuyTicket
  end
end

if IsAddonVisible("SelectString") then
  yield("/wait 0.1")
  for i=0, 5 do
    yield("/wait 0.01")
    string = GetSelectStringText(i)
    if string=="Present yourself for judging." or string=="Purchase a Jumbo Cactpot ticket." then
      Select(i+1)
      Yesno()
      break
    end
  end
end

if IsAddonVisible("Talk") then Talk() end

if IsAddonVisible("FashionCheck") then
  yield("/pcall FashionCheck true -1")
end

if HasStatus("Gold Saucer VIP Card")==false then
  if IsAddonVisible("GrandCompanySupplyList") then
    QuitDeliver()
    ed = 0
  end
  if GetItemCount(14947) > 0 then
    yield("/wait 1")
    yield("/item Gold Saucer VIP Card")
  end
end

::Loop::
yield("/wait 1.00"..gs)
gs = gs + 1

if IsInZone(144) and gs < 99 then
  goto Start
else
  goto Loop
end
