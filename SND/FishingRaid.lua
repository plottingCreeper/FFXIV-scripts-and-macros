--[[
  Ocean fishing spam, using AutoHook, Pandora, and Visland
  Some bits borrowed and/or stolen from Curio Salso's feeshing script
]]

start_fishing = {
  "/wait 0.1",
  "/ac cast",
  "/ahon",
}

back_in_limsa = {
  "/wait 5",
}

countdown_timer = false
adjust_z = true

::Start::
if IsInZone(900) then goto OnBoat end

::WaitForBoat::
elapsed = os.time()
while elapsed > 7200 do
  elapsed = elapsed - 7200
end
last_boat = os.time() - elapsed

wait_time = math.floor(7200-os.difftime(os.time(), last_boat))
while wait_time >= 1 do
  wait_time = math.floor(7200-os.difftime(os.time(), last_boat))
  if type(countdown_timer)=="number" then
    if wait_time % countdown_timer == 0 then
      minutes = wait_time // 60
      seconds = wait_time % 60
      yield("/echo Waiting "..minutes.." minutes and "..seconds.." seconds for the next boat")
    end
  end
  yield("/wait 1.0")
end

::BotPause::
notabot = math.random(3,15)
yield("/echo Randomly waiting "..notabot.." seconds. Soooooooo human.")
yield("/wait "..notabot)

::Queue::
while GetCharacterCondition(91, false) do
  if GetTargetName()=="" then
    yield("/target Dryskthota")
  elseif GetCharacterCondition(32, false) then
    yield("/pinteract")
  elseif IsAddonVisible("Talk") then
    yield("/click talk")
  elseif IsAddonVisible("SelectString") then
    yield("/pcall SelectString true 0")
  elseif IsAddonVisible("SelectYesno") then
    yield("/pcall SelectYesno true 0")
  end
  yield("/wait 0.5")
end

::Enter::
while IsInZone(129) do
  if IsAddonVisible("ContentsFinderConfirm") then yield("/pcall ContentsFinderConfirm true 8") end
  yield("/wait 1.01")
end
while GetCharacterCondition(35, false) do yield("/wait 1.02") end

::PrepareRandom::
is_entering = true
random_x = math.random(1,2)
if random_x == 1 then move_x = 7.5
else move_x = -7.5 end
move_y = math.random(-11000,5000)/1000
move_z = 6.750

::OnBoat::
while not IsInZone(129) do
  if IsAddonVisible("IKDFishingLog") then
    yield("/wait 0.11")
    timer_string = string.gsub(GetNodeText("IKDFishingLog", 18),"%D","")
    while timer_string=="" do
      timer_string = string.gsub(GetNodeText("IKDFishingLog", 18),"%D","")
      yield("/wait 0.111")
    end
    timer = tonumber(timer_string)
    while timer < 030 or timer > 698 do
      yield("/wait 1.05")
      timer_string = string.gsub(GetNodeText("IKDFishingLog", 18),"%D","")
      while timer_string=="" do
        timer_string = string.gsub(GetNodeText("IKDFishingLog", 18),"%D","")
        yield("/wait 0.112")
      end
      timer = tonumber(timer_string)
      if IsAddonVisible("IKDFishingLog")==false then timer = 500 end
    end
    if is_entering then
      is_move = true
      is_entering = false
    end
  end
  if GetCharacterCondition(35) then
    while GetCharacterCondition(35) do yield("/wait 1.03") end
    yield("/wait 3")
  elseif IsAddonVisible("NowLoading") then
    yield("/wait 1.04")
  elseif IsAddonVisible("IKDResult") then
    yield("/pcall IKDResult true 0")
    yield("/wait 1.08")
  elseif is_move then
    yield("/visland moveto "..move_x.." "..move_z.." "..move_y)
    yield("/wait 0.5")
    move_tick = 0
    while IsMoving() and move_tick <= 10 do
      move_tick = move_tick + 0.1
      if adjust_z then
        move_z = math.floor(GetPlayerRawYPos()*1000)/1000
        yield("/visland moveto "..move_x.." "..move_z.." "..move_y)
      end
      yield("/wait 0.1")
    end
    if random_x == 1 then yield("/visland moveto 9 "..move_z.." "..move_y)
    else yield("/visland moveto -9 "..move_z.." "..move_y) end
    yield("/wait 0.2")
    yield("/visland stop")
    is_move = false
  elseif not ( GetCharacterCondition(6) or GetCharacterCondition(42) or GetCharacterCondition(43) ) then
    for _, command in pairs(start_fishing) do
      yield("/echo Running: "..command)
      yield(command)
    end
  end
  yield("/wait 1.09")
end

for _, command in pairs(back_in_limsa) do
  yield("/echo Running: "..command)
  yield(command)
end

GetNodeText("_BattleTalk", 4)

goto Start
