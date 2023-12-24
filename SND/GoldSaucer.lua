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
  move_x = math.random((near_x-radius)*1000, (near_x+radius)*1000)/1000
  move_z = near_z
  move_y = math.random((near_y-radius)*1000, (near_y+radius)*1000)/1000
  yield("/visland moveto "..move_x.." "..move_z.." "..move_y)
  yield("/wait 0.5")
  move_tick = 0
  while IsMoving() and move_tick <= timeout do
    move_tick = move_tick + 0.1
    yield("/wait 0.1")
  end
  yield("/visland stop")
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
  MoveNear(121, 13, -11, 3, 2)
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

if IsAddonVisible("FashionCheck") then
  yield("/pcall FashionCheck true -1")
end

::Loop::
yield("/wait 1.00"..gs)
gs = gs + 1

if IsInZone(144) and gs < 99 then
  goto Start
else
  goto Loop
end
