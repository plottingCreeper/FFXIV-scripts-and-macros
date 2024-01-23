--[[
  Ocean fishing spam, using AutoHook, Pandora, and Visland
]]

ar_while_waiting = true --AutoRetainer multimode enabled in between fishing trips.
fishing_character = "auto" --"auto" requires starting the script while on your fishing character.
adjust_z = true --true might cause stuttery movement, false might cause infinite movement. Good luck.

start_fishing = {
  "/wait 0.1",
  "/ac cast",
  "/ahon",
}

back_in_limsa = {
  "/wait 5",
  "/discardall",
  "/wait 5",
}

bags_full = {
  LeaveDuty(),
  "/pcraft stop",
}

------------------------------------------------------------------------

::Start::
if IsInZone(900) then
  goto OnBoat
elseif IsInZone(129) and GetDistanceToPoint(-410,4,76)<6.9 then
  if GetCharacterCondition(91) then
    goto Enter
  elseif os.date("!*t").hour%2==0 and os.date("!*t").min<15 then
    goto Queue
  elseif os.date("!*t").hour%2==1 and os.date("!*t").min>=45 then
    goto WaitForBoat
  else
    goto StartAR
  end
elseif fishing_character ~= "auto" then
  goto ARWait
else
  yield("/echo That's not gonna work, chief.")
  yield("/pcraft stop")
end

::ARWait::
if ar_while_waiting then
  while not ( os.date("!*t").hour%2==1 and os.date("!*t").min>=55 ) do
    yield("/wait 1.001")
  end
  yield("/ays multi")
  while GetCharacterName(true)~=fishing_character do
    if IsAddonVisible("TitleConnect") or IsAddonVisible("NowLoading") or IsAddonVisible("CharaSelect") then
      yield("/wait 1.002")
    elseif GetCharacterCondition(50,false) then
      yield("/ays relog " .. fishing_character)
    elseif IsAddonVisible("RetainerList") then
      yield("/pcall RetainerList true -1")
    end
    yield("/wait 1.009")
  end
end

::WaitForBoat::
while not ( os.date("!*t").hour%2==0 and os.date("!*t").min<15 ) do
  yield("/wait 1.010")
end

::BotPause::
notabot = math.random(3,15)
yield("/echo Randomly waiting "..notabot.." seconds. Soooooooo human.")
yield("/wait "..notabot)

::Queue::
while GetCharacterCondition(91, false) do
  if GetTargetName()~="Dryskthota" or IsAddonVisible("_TargetInfoMainTarget")==false then
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
  yield("/wait 1.020")
end
while GetCharacterCondition(35, false) do yield("/wait 1.021") end

::PrepareRandom::
is_entering = true
if tostring(math.random(2))=="1" then move_x = 7.5
else move_x = -7.5 end
move_y = math.random(-11000,5000)/1000
move_z = 6.750

::OnBoat::
while IsInZone(900) do
  if IsAddonVisible("IKDFishingLog") then
    yield("/wait 0.101")
    timer_string = string.gsub(GetNodeText("IKDFishingLog", 18),"%D","")
    timer = tonumber(timer_string)
    if type(timer)=="number" then
      while timer < 030 or timer > 698 do
        yield("/wait 1.031")
        timer_string = string.gsub(GetNodeText("IKDFishingLog", 18),"%D","")
        while timer_string=="" do
          timer_string = string.gsub(GetNodeText("IKDFishingLog", 18),"%D","")
          yield("/wait 0.103")
        end
        timer = tonumber(timer_string)
        if IsAddonVisible("IKDFishingLog")==false then timer = 500 end
      end
    end
    if is_entering then
      is_move = true
      is_entering = false
    end
  end
  if IsAddonVisible("_TextError") then
    if GetNodeText("_TextError", 1)=="Unable to gather. Insufficient inventory space." then
      for _, command in pairs(bags_full) do
        yield("/echo Running: "..command)
        yield(command)
      end
    end
  elseif GetCharacterCondition(35) then
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
    if move_x == 7.5 then yield("/visland moveto 9 "..move_z.." "..move_y)
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
  yield("/wait 1.039")
end

for _, command in pairs(back_in_limsa) do
  yield("/echo Running: "..command)
  yield(command)
end

::StartAR::
if ar_while_waiting then
  if fishing_character=="auto" then fishing_character = GetCharacterName(true) end
  yield("/ays multi")
  while GetCharacterCondition(1) do
    yield("/wait 1")
  end
  goto ARWait
else
  goto WaitForBoat
end

GetNodeText("_BattleTalk", 4)

goto Start
