--[[
  Automatic ocean fishing script. Options for AutoRetainer and returning to inn room between trips.
  Required plugins:
    Autohook (Auto Casts): https://raw.githubusercontent.com/InitialDet/MyDalamudPlugins/main/pluginmaster.json
    Pandora: https://love.puni.sh/ment.json
    Visland: https://puni.sh/api/repository/veyn
  Optional plugins:
    AutoRetainer (Multi Mode): https://love.puni.sh/ment.json
    Teleporter: main repository
    Simple Tweaks (/bait command): main repository
]]

is_ar_while_waiting = false --AutoRetainer multimode enabled in between fishing trips.
wait_location = false
fishing_character = "auto" --"auto" requires starting the script while on your fishing character.
is_wait_to_move = true --Wait for the barrier to drop before moving to the side of the boat.
is_adjust_z = true --true might cause stuttery movement, false might cause infinite movement. Good luck.
is_discard = false --Not done yet
is_desynth = false --Not done yet
bait_and_switch = true

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
  "/echo Bags full!",
  "/leaveduty",
  "/pcraft stop",
}
is_debug = true

------------------------------------------------------------------------

baits = {
  [1] = {id = 237, name = "Galadion Bay", normal_bait = "Plump Worm", daytime = "Ragworm", sunset = "Plump Worm", nighttime = "Krill"},
  [2] = {id = 239, name = "Southern Merlthor", normal_bait = "Krill", daytime = "Krill", sunset = "Ragworm", nighttime = "Plump Worm"},
  [3] = {id = 243, name = "Northern Merlthor", normal_bait = "Ragworm", daytime = "Plump Worm", sunset = "Ragworm", nighttime = "Krill"},
  [4] = {id = 241, name = "Rhotano Sea", normal_bait = "Plump Worm", daytime = "Plump Worm", sunset = "Ragworm", nighttime = "Krill"},
  [5] = {id = 246, name = "The Ciedalaes", normal_bait = "Ragworm", daytime = "Krill", sunset = "Plump Worm", nighttime = "Krill"},
  [6] = {id = 248, name = "Bloodbrine Sea", normal_bait = "Krill", daytime = "Ragworm", sunset = "Plump Worm", nighttime = "Krill"},
  [7] = {id = 250, name = "Rothlyt Sound", normal_bait = "Plump Worm", daytime = "Krill", sunset = "Krill", nighttime = "Krill"},
  [8] = {id = 286, name = "Sirensong Sea", normal_bait = "Plump Worm", daytime = "Krill", sunset = "Krill", nighttime = "Krill"},
  [9] = {id = 288, name = "Kugane Coast", normal_bait = "Ragworm", daytime = "Krill", sunset = "Ragworm", nighttime = "Plump Worm"},
  [10] = {id = 290, name = "Ruby Sea", normal_bait = "Krill", daytime = "Ragworm", sunset = "Plump Worm", nighttime = "Krill"},
  [11] = {id = 292, name = "Lower One River", normal_bait = "Krill", daytime = "Ragworm", sunset = "Krill", nighttime = "Krill"},
}

routes = { --Lua indexes from 1, so make sure to add 1 to the zone returned by SND.
  [1] = {[1] = 2, [2] = 1, [3] = 3},
  [2] = {[1] = 2, [2] = 1, [3] = 3},
  [3] = {[1] = 2, [2] = 1, [3] = 3},
  [4] = {[1] = 1, [2] = 2, [3] = 4},
  [5] = {[1] = 1, [2] = 2, [3] = 4},
  [6] = {[1] = 1, [2] = 2, [3] = 4},
  [7] = {[1] = 5, [2] = 3, [3] = 6},
  [8] = {[1] = 5, [2] = 3, [3] = 6},
  [9] = {[1] = 5, [2] = 3, [3] = 6},
  [10] = {[1] = 5, [2] = 4, [3] = 7},
  [11] = {[1] = 5, [2] = 4, [3] = 7},
  [12] = {[1] = 5, [2] = 4, [3] = 7},
  [13] = {[1] = 8, [2] = 9, [3] = 11},
  [14] = {[1] = 8, [2] = 9, [3] = 11},
  [15] = {[1] = 8, [2] = 9, [3] = 11},
  [16] = {[1] = 8, [2] = 9, [3] = 10},
  [17] = {[1] = 8, [2] = 9, [3] = 10},
  [18] = {[1] = 8, [2] = 9, [3] = 10},
}

function WaitReady(delay, is_not_ready)
  if is_not_ready then loading_tick = -1
    else loading_tick = 0 end
  if not delay then delay = 3 end
  while loading_tick<delay do
    if IsAddonVisible("NowLoading") then loading_tick = 0
    elseif GetCharacterCondition(1, false) then loading_tick = 0
    elseif GetCharacterCondition(27) then loading_tick = 0
    elseif GetCharacterCondition(32) then loading_tick = 0
    elseif GetCharacterCondition(35) then loading_tick = 0
    elseif GetCharacterCondition(45) then loading_tick = 0
    elseif loading_tick == -1 then yield("/wait 0.01")
    else loading_tick = loading_tick + 0.1 end
    yield("/wait 0.1")
  end
end

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
  elseif wait_location then
    goto WaitLocation
  else
    goto StartAR
  end
elseif IsInZone(177) and wait_location=="inn" then
  goto StartAR
elseif fishing_character ~= "auto" then
  goto ARWait
elseif (os.date("!*t").hour%2==1 and os.date("!*t").min>=45) or (os.date("!*t").hour%2==0 and os.date("!*t").min<15) then
  goto ReturnFromWait
else
  yield("/echo Zone: "..GetZoneID())
  if IsInZone(129) then yield("/echo Distance from Dryskthota: "..GetDistanceToPoint(-410,4,76)) end
  yield("/echo That's not gonna work, chief.")
  yield("/pcraft stop")
end

::ARWait::
if is_ar_while_waiting then
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

::ReturnFromWait::
if not ( IsInZone(177) or IsInZone(128) or IsInZone(129) ) then
  yield("/tp Limsa")
  yield("/wait 10")
  WaitReady()
end
if IsInZone(129) and GetDistanceToPoint(-84,19,0)<20 then
  while GetDistanceToPoint(-84,19,0)<20 do
    if IsAddonVisible("TelepotTown") then
      yield("/pcall TelepotTown true 11 3u")
    elseif GetTargetName()~="aetheryte" or IsAddonVisible("_TargetInfoMainTarget")==false then
      yield("/target aetheryte")
    elseif IsAddonVisible("SelectString") then
      yield("/pcall SelectString true 0")
    elseif GetDistanceToTarget()<8 then
      yield("/pinteract")
    else
      yield("/lockon on")
      yield("/automove on")
    end
    yield("/wait 0.5")
  end
  yield("/wait 3")
  while GetCharacterCondition(32) or GetCharacterCondition(45) do
      yield("/wait 1")
  end
  yield("/wait 3")
end
::ExitInn::
if wait_location=="inn" and IsInZone(177) then
  while IsInZone(177) do
    if GetTargetName()~="Heavy Oaken Door" or IsAddonVisible("_TargetInfoMainTarget")==false then
      yield("/target Heavy Oaken Door")
    elseif IsAddonVisible("SelectYesno") then
      yield("/pcall SelectYesno true 0")
    else
      yield("/lockon on")
      yield("/automove on")
      yield("/pinteract")
    end
    yield("/wait 0.5")
  end
  while GetCharacterCondition(32) or GetCharacterCondition(45) do
    yield("/wait 1")
  end
  yield("/wait 3")
end
::MoveToAftcastle::
if IsInZone(128) and GetDistanceToPoint(13,40,13)<20 then
  yield("/visland exectemponce H4sIAAAAAAAACuWTyWrDMBCGXyXM2QiNFkvyrXQBH9KNQrrQg2hUIqilYistxeTdqzgKCfQNGp3mnxlGvz40I1zbzkEDbQizFGfWpZXrg0tQwcL+fEYf0gDNywi3cfDJxwDNCI/QcEKlqaVUFTxlZYhEJYWo4BkarIlWRqDaZBmDay+goRXc26Vf52GMZDGPX65zIU2VNiTX27e08Gl1U7qPc8Vj9jSs4ve+ks3kae/2Y3CH9skhVnDZxbS/uE2uK+HZ1FHE3doNqcTbwQvr02HiVl3F/jyGZXk43SUffOfmuY9uqj9YKBFSG6WYPuYiJywMCUdTc3Z6WJAILSUKNlERlCCnivMJi6L5K2ltTo+KIJIaLcoOZSp0e/SOCiesVvoEVwg50UxLdqCyA4IEFar6vwN53fwCXs5zv5QFAAA=")
  yield("/wait 3")
  while IsVislandRouteRunning() or IsMoving() do
    yield("/wait 1")
  end
end
::AethernetToArcanist::
if IsInZone(128) and GetDistanceToPoint(14,40,71)<9 then
  while IsInZone(128) do
    if IsAddonVisible("TelepotTown") then
      yield("/pcall TelepotTown true 11 3u")
    elseif GetTargetName()~="Aethernet shard" or IsAddonVisible("_TargetInfoMainTarget")==false then
      yield("/target Aethernet shard")
    elseif GetDistanceToTarget()<4 then
      yield("/pinteract")
    else
      yield("/lockon on")
      yield("/automove on")
    end
    yield("/wait 0.5")
  end
  yield("/wait 3")
  while GetCharacterCondition(32) or GetCharacterCondition(45) do
      yield("/wait 1")
  end
  yield("/wait 3")
end
::MoveToOcean::
if IsInZone(129) and GetDistanceToPoint(-335,12,53)<9 then
  yield("/visland exectemponce H4sIAAAAAAAACuWSy2rDMBBFfyXM2hV62hrtQh+QRfqikD7oQiRKLailEistJeTfq9gOLaX9gWRWM6PL5eowG7i0jQMDY5dqtwoujVIcxbmzYbT0be3DCxQws59v0YfUgnnawHVsffIxgNnAPZgTITSpkKkCHsAwRrTkCmUBj2CkJsgklts8xeAmZ1nAsYBbu/Dr7MYILWAa313jQgKTh0lIbmXnaeZTfbXT/9oNcXOoto4f+5ecJrst7WvrvuVdRFbAeROT21sl1wztuFMMw83atWnod8Yz69O34266iKvTGBbDz2m/vPONm2Yd3RZ/cCkVkciF7MBoQnOpsudSEcpKofV/YPhBg9GYwaCqOjCKYC6hezBIGBOU/QRDjwULcqIUH6DQjkc+ISZLjkeIQ9KKaFpiD0R0V4LYn0klSaVRqUPH8rz9ApGJUVChBQAA")
  yield("/wait 3")
  while IsVislandRouteRunning() or IsMoving() do
    yield("/wait 1")
  end
end

::WaitForBoat::
while not ( os.date("!*t").hour%2==0 and os.date("!*t").min<15 ) do
  yield("/wait 1.010")
end

::BotPause::
notabot = math.random(3,10)
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
movement = true
if tostring(math.random(2))=="1" then move_x = 7.5
else move_x = -7.5 end
move_y = math.random(-11000,5000)/1000
move_z = 6.750

::OnBoat::
results_tick = 0
debug_tick = 0
while IsInZone(900) do
  current_route = routes[GetCurrentOceanFishingRoute()]
  current_zone = current_route[GetCurrentOceanFishingZone()+1]
  normal_bait = baits[current_zone].normal_bait
  if GetCurrentOceanFishingTimeOfDay()==1 then spectral_bait = baits[current_zone].daytime end
  if GetCurrentOceanFishingTimeOfDay()==2 then spectral_bait = baits[current_zone].sunset end
  if GetCurrentOceanFishingTimeOfDay()==3 then spectral_bait = baits[current_zone].nighttime end
  if OceanFishingIsSpectralActive() then correct_bait = spectral_bait else correct_bait = normal_bait end
  if IsAddonVisible("NowLoading") or GetCharacterCondition(35) then
    WaitReady()
--     loading_tick = 0
--     while loading_tick<3 do
--       if IsAddonVisible("NowLoading") then loading_tick = 0
--       elseif GetCharacterCondition(35) then loading_tick = 0
--       elseif GetCharacterCondition(45) then loading_tick = 0
--       else
--         loading_tick = loading_tick + 0.1
--       end
--       yield("/wait 0.1")
--     end
  elseif IsAddonVisible("IKDResult") then
    while IsAddonVisible("IKDResult") do
      yield("/wait 10")
      yield("/pcall IKDResult true 0")
    end
    break
  elseif GetCurrentOceanFishingZoneTimeLeft()<0 then
    yield("/wait 1.08")
  elseif GetInventoryFreeSlotCount()<=2 then
    for _, command in pairs(bags_full) do
      if command=="/leaveduty" then LeaveDuty() end
      yield("/echo Running: "..command)
      yield(command)
    end
  elseif movement and ( GetCurrentOceanFishingZoneTimeLeft()<420 and is_wait_to_move ) then
    yield("/visland moveto "..move_x.." "..move_z.." "..move_y)
    yield("/wait 0.5")
    move_tick = 0
    while IsMoving() and move_tick <= 5 do
      move_tick = move_tick + 0.1
      if is_adjust_z then
        move_z = math.floor(GetPlayerRawYPos()*1000)/1000
        yield("/visland moveto "..move_x.." "..move_z.." "..move_y)
      end
      yield("/wait 0.1")
    end
    if move_x == 7.5 then yield("/visland moveto 9 "..move_z.." "..move_y)
    else yield("/visland moveto -9 "..move_z.." "..move_y) end
    yield("/wait 0.2")
    yield("/visland stop")
    movement = false
  elseif bait_and_switch and correct_bait~=current_bait then
    if correct_bait=="Ragworm" then bait_count = GetItemCount(29714)
      elseif correct_bait=="Krill" then bait_count = GetItemCount(29715)
      elseif correct_bait=="Plump Worm" then bait_count = GetItemCount(29716)
    end
    yield("/echo Switching bait to: "..correct_bait)
    if GetCharacterCondition(6) then
      while GetCharacterCondition(42, false) do yield("/wait 1") end
      yield("/ahoff")
      while GetCharacterCondition(43) do yield("/wait 1") end
    end
    if bait_count>1 then
      --yield("/wait 1")
      yield("/bait "..correct_bait)
    else
      yield("/echo Out of "..correct_bait)
      yield("/bait Versatile Lure")
    end
    current_bait = correct_bait
  elseif GetCurrentOceanFishingZoneTimeLeft()>30 and GetCharacterCondition(43, false) then
    yield("/wait 0.5")
    if GetCharacterCondition(43, false) then
      yield("/echo Starting fishing from: X: ".. math.floor(GetPlayerRawXPos()*1000)/1000 .." Y or Z, depending on which plugin you ask: ".. math.floor(GetPlayerRawZPos()*1000)/1000 )
      for _, command in pairs(start_fishing) do
        yield("/echo Running: "..command)
        yield(command)
      end
    end
  end
  if is_debug then
    debug_tick = debug_tick + 1
    if debug_tick>=0 then
      debug_tick = -10
      yield("/echo -------------------------------------")
      yield("/echo FishingRoute: "..tostring(GetCurrentOceanFishingRoute()))
      yield("/echo FishingZone:  "..tostring(GetCurrentOceanFishingZone()))
      yield("/echo FishingTime:  "..tostring(GetCurrentOceanFishingTimeOfDay()))
      yield("/echo Zone name: "..baits[current_zone].name)
      yield("/echo Normal bait: "..normal_bait)
      yield("/echo Spectral bait: "..spectral_bait)
      yield("/echo -------------------------------------")
    end
  end
  yield("/wait 1.039")
end

if IsAddonVisible("NowLoading") or GetCharacterCondition(35) then
  loading_tick = 0
  while loading_tick<3 do
    if IsAddonVisible("NowLoading") then loading_tick = 0
    elseif GetCharacterCondition(35) then loading_tick = 0
    elseif GetCharacterCondition(45) then loading_tick = 0
    else
      loading_tick = loading_tick + 0.1
    end
    yield("/wait 0.1")
  end
end
for _, command in pairs(back_in_limsa) do
  yield("/echo Running: "..command)
  yield(command)
end

::WaitLocation::
if wait_location=="inn" then
  ::MoveToArcanist::
  if IsInZone(129) and GetDistanceToPoint(-408,4,75)<20 then
    yield("/visland exectemponce H4sIAAAAAAAACuWTTU8DIRCG/0oz55XAArvAzfiR9FCrxqR+xANpqUvigtmlGrPpf5elbOrBX2A5MfO+GYYnMwPc6NaAguXaaDfb2r6x7m0W/Eyb0JjOmQAFrPT3h7cu9KBeBrj1vQ3WO1ADPII6o5IgUcm6gCdQHOECnkFVHHFW8nIfI+/M/BJUFO71xu5ilXJ0LfynaY0LSZm7YDq9DisbmmV2/87lNmMzfeO/JiV2Eatt9XtvjvbUGingqvVhengeTJuv58mRg7ud6UO+j4VX2oZjxTG69t2Fd5v8Y3xIPtjWLKIP74s/eAiJaEVp5iHjKVmdqDARFSYZO0UsXCKCBa4SF4HweNiEhVeSi5OkQhGlbJyPSKVO0yJoohIVLFktThIL5YgQSg5LRMjIhZQTFlaVNf73O/S6/wFHKPaRngUAAA==")
    yield("/wait 3")
    while IsVislandRouteRunning() or IsMoving() do
      yield("/wait 1")
    end
  end
  ::AethernetToAftcastle::
  if IsInZone(129) and GetDistanceToPoint(-335,12,53)<9 then
    while IsInZone(129) do
      if IsAddonVisible("TelepotTown") then
        yield("/pcall TelepotTown true 11 1u")
      elseif GetTargetName()~="Aethernet shard" or IsAddonVisible("_TargetInfoMainTarget")==false then
        yield("/target Aethernet shard")
      elseif GetDistanceToTarget()<4 then
        yield("/pinteract")
      else
        yield("/lockon on")
        yield("/automove on")
      end
      yield("/wait 0.5")
    end
    yield("/wait 3")
    while GetCharacterCondition(32) or GetCharacterCondition(45) do
        yield("/wait 1")
    end
    yield("/wait 3")
  end
  ::MoveToInn::
  if IsInZone(128) and GetDistanceToPoint(14,40,71)<9 then
    yield("/visland exectemponce H4sIAAAAAAAACuWT22rDMAyGX6XoOjNyYseHu7ID9KI7Mei6sYuwetSw2CNxN0bou09JU1rYnmDVlX5JyNKH3MF1VTuwMHVp7Zrg0iTFiQ8BMlhU3x/Rh9SCfe7gNrY++RjAdvAIliNTyCWKDJZgBTLsjdQTWCWYQNRiSyoGN7sAixncVyu/oV45IzGPn652IQ2ZWUiuqV7Twqf1zVh9HBtHpJHadfzaZ2gW6vZWvbfuUD4MyDO4rGPaPzxLrh7d6VAxiruNa9Po940XlU+Hjr26is15DKtxb9wFH3zt5lSH2+w3FcKgi7LM/6LCmVJSmdOjcoaMK11oLsqBS2GY6a0cuIiCFWgwl6cHhnYzXJpc77FIThcyUOGKqOTmFKnwgnGt6RsdH4uWOyw505Jj+e9/0cv2ByD0KqubBQAA")
    yield("/wait 3")
    while IsVislandRouteRunning() or IsMoving() do
      yield("/wait 1")
    end
  end
  ::EnterInn::
  while IsInZone(128) do
    if GetDistanceToPoint(13,40,13)<4 then
      if GetTargetName()~="Mytesyn" or IsAddonVisible("_TargetInfoMainTarget")==false then
        yield("/target Mytesyn")
      elseif GetCharacterCondition(32, false) then
        yield("/pinteract")
      elseif IsAddonVisible("Talk") then
        yield("/click talk")
      elseif IsAddonVisible("SelectString") then
        yield("/pcall SelectString true 0")
      elseif IsAddonVisible("SelectYesno") then
        yield("/pcall SelectYesno true 0")
      end
    end
    yield("/wait 0.5")
  end
elseif wait_location=="fc" then
  yield("/tp estate hall")
  WaitReady()
end

::Desynth::
if is_desynth then
  yield("/echo Nope! Desynth isn't implemented yet.")
end

::StartAR::
if is_ar_while_waiting then
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

if is_debug then yield("/echo ".. "") end

goto Start
