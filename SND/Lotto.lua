--[[
  Jumbo Cactpot claim and purchase script.
  Barely working.
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
  yield("/visland moveto 120 13 -10")
  yield("/wait 1.5")
  yield("/target Jumbo Cactpot Broker")
  yield("/wait 0.1")
  yield("/pinteract")
  yield("/visland stop")
  Talk()
  Select(1)
  yield("/wait 2")
end

if IsAddonVisible("LotteryWeeklyInput") then
  ::BuyTicket::
  if IsAddonVisible("LotteryWeeklyInput") then
    math.randomseed(os.time())
    random=string.sub(math.random(),3,-1)
    four_digit = string.sub(random,6,9)
    yield("/echo "..random)
    yield("/echo "..four_digit)
    yield("/waitaddon LotteryWeeklyInput")
    yield("/wait 0.1")
    yield("/pcall LotteryWeeklyInput true "..four_digit)
    Yesno()
    Yesno()
    goto BuyTicket
  end
  Talk()
  Talk()
  Talk()
end

