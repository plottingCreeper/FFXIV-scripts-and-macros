math.randomseed(os.time())
random=string.sub(math.random(),3,-1)
first = string.sub(random,1,4)
second = string.sub(random,6,9)
third = string.sub(random,11,14)
throttle = " <wait.0.1>"
yield("/echo "..random)
yield("/echo "..first)
yield("/echo "..second)
yield("/echo "..third)

yield("/waitaddon LotteryWeeklyInput"..throttle)
yield("/pcall LotteryWeeklyInput true "..first..throttle)
if IsAddonVisible(SelectYesno) then yield("/pcall SelectYesno true 2"..throttle) end
yield("/waitaddon LotteryWeeklyInput"..throttle)
yield("/pcall LotteryWeeklyInput true "..second..throttle)
if IsAddonVisible(SelectYesno) then yield("/pcall SelectYesno true 2"..throttle) end
yield("/waitaddon LotteryWeeklyInput"..throttle)
yield("/pcall LotteryWeeklyInput true "..third..throttle)
if IsAddonVisible(SelectYesno) then yield("/pcall SelectYesno true 2"..throttle) end
