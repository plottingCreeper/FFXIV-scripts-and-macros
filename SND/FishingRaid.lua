--[[
  Ocean fishing spam, using AutoHook, Pandora, and Visland
  Some bits borrowed and/or stolen from Curio Salso's feeshing script
]]
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
  minutes = wait_time // 60
  seconds = wait_time % 60
  yield("/echo Waiting "..minutes.." minutes and "..seconds.." seconds for the next boat")
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
random_move = math.random(1,8)

::OnBoat::
while not IsInZone(129) do
  if GetCharacterCondition(35) then
    while GetCharacterCondition(35) do yield("/wait 1.03") end
    yield("/wait 3")
  elseif IsAddonVisible("NowLoading") then
    yield("/wait 1.04")
  elseif IsAddonVisible("IKDResult") then
    yield("/pcall IKDResult true 0")
    yield("/wait 1.08")
  elseif random_move then --These next lines written by Curio Salso, then modified to cram in here.
    if random_move == 1 then yield("/visland moveto 6.641 6.711 -0.335")
      elseif random_move == 2 then yield("/visland moveto 7.451 6.750 -4.043")
      elseif random_move == 3 then yield("/visland moveto 7.421 6.750 -5.462")
      elseif random_move == 4 then yield("/visland moveto 7.391 6.711 -7.936")
      elseif random_move == 5 then yield("/visland moveto -7.450 6.711 -8.982")
      elseif random_move == 6 then yield("/visland moveto -7.548 6.750 -6.590")
      elseif random_move == 7 then yield("/visland moveto -7.482 6.739 -2.633")
      elseif random_move == 8 then yield("/visland moveto -7.419 6.711 -0.113")
    end
    yield("/wait 1.06")
    while IsMoving() do yield("/wait 1.07") end
    random_move = nil
  elseif not ( GetCharacterCondition(6) or GetCharacterCondition(42) or GetCharacterCondition(43) ) then
    yield("/ac cast")
    yield("/ahon")
  elseif IsAddonVisible("IKDFishingLog") then
    timer = string.gsub(GetNodeText("IKDFishingLog", 18),"%D","")
    timer = tonumber(timer)
    while timer < 030 or timer > 698 do
      yield("/wait 1.05")
      timer = string.gsub(GetNodeText("IKDFishingLog", 18),"%D","")
      timer = tonumber(timer)
      if IsAddonVisible("IKDFishingLog")==false then timer = 500 end
    end
  end
  yield("/wait 1.09")
end

GetNodeText("_BattleTalk", 4)

goto Start
