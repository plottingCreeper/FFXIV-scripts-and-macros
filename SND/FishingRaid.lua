--[[

  Automatic ocean fishing script. Options for AutoRetainer and returning to inn room between trips.

    Script runs using:
      SomethingNeedDoing (Expanded Edition): https://puni.sh/api/repository/croizat
    Required plugins:
      Autohook: https://raw.githubusercontent.com/InitialDet/MyDalamudPlugins/main/pluginmaster.json
      Pandora: https://love.puni.sh/ment.json
      Visland: https://puni.sh/api/repository/veyn
    Optional plugins:
      AutoRetainer: https://love.puni.sh/ment.json
      Teleporter: main repository
      Simple Tweaks: main repository
      Discard Helper: https://plugins.carvel.li/
      YesAlready: https://love.puni.sh/ment.json
]]

is_ar_while_waiting = false  --AutoRetainer multimode enabled in between fishing trips.
wait_location = false  --Can be false, "inn", or "fc"
fishing_character = "auto"  --"auto" requires starting the script while on your fishing character.
is_wait_to_move = false  --Wait for the barrier to drop before moving to the side of the boat.
is_adjust_z = true  --true might cause stuttery movement, false might cause infinite movement. Good luck.
is_discard = false  --Requires Discard Helper
is_desynth = true  --Runs faster with YesAlready, but this isn't required.'
bait_and_switch = true  --Uses /bait command from SimpleTweaks
force_autohook_presets = true
movement_method = "visland route" --"visland route", "visland random"
buy_baits = false  --Minimum number of baits you want. Will buy 99 at a time.

is_spend_scrips = false
scrip_category = 1
scrip_subcategory = 6
scrip_item_to_buy = "RegionalFolkloreTrader'sTokenC"

start_fishing = {
  "/wait 0.1",
  "/ac cast",
  "/ahon",
}

bags_full = {
  "/echo Bags full!",
  "/leaveduty",
  "/pcraft stop",
}
is_debug = true

------------------------------------------------------------------------

function AutoHookPresets()
  if force_autohook_presets then
    if autohook_preset_loaded then
      DeletedSelectedAutoHookPreset()
      autohook_preset_loaded = false
    end
    if OceanFishingIsSpectralActive() then
      UseAutoHookAnonymousPreset("AH3_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")
      autohook_preset_loaded = "spectral"
    else
      UseAutoHookAnonymousPreset("AH3_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")
      autohook_preset_loaded = "normal"
    end
  end
end

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

Ragworm = 29714
Krill = 29715
PlumpWorm = 29716

function WaitReady(delay, is_not_ready, status)
  if is_not_ready then loading_tick = -1
    else loading_tick = 0 end
  if not delay then delay = 3 end
  wait = 0.1
  if type(status)=="number" then wait = wait + (status / 10000) end
  while loading_tick<delay do
    if IsAddonVisible("NowLoading") then loading_tick = 0
    elseif IsPlayerOccupied() then loading_tick = 0
--     elseif GetCharacterCondition(1, false) then loading_tick = 0
--     elseif GetCharacterCondition(27) then loading_tick = 0
--     elseif GetCharacterCondition(32) then loading_tick = 0
--     elseif GetCharacterCondition(35) then loading_tick = 0
--     elseif GetCharacterCondition(45) then loading_tick = 0
    elseif loading_tick == -1 then yield("/wait "..wait)
    else loading_tick = loading_tick + 0.1 end
    yield("/wait "..wait)
    if IsAddonVisible("IKDResult") then
      yield("/wait 10")
      yield("/pcall IKDResult true 0")
    end
  end
end

function RunDiscard(y)
  if is_discard then
    if is_desynth and y==1 then
      yield("/echo You have desynth and discard turned on.")
      yield("/echo Waiting to discard until after desynth!")
    elseif y==1 then
      discarded_on_1 = true
      yield("/discardall")
    elseif discarded_on_1 then
      yield("/discardall")
    else
      yield("/discardall")
      yield("/echo Waiting 10 seconds to give Discard Helper time to run.")
      yield("/wait 10")
    end
  end
end

function MoveNear(near_x, near_z, near_y, radius, timeout, fast)
  if not radius then radius = 3 end
  if not timeout then timeout = 60 end
  if not type(fast)=="number" then fast = radius*2 end
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
    if near_z == false then
      move_z = math.floor(GetPlayerRawYPos()*1000)/1000
      yield("/visland moveto "..move_x.." "..move_z.." "..move_y)
    end
    if fast then
      if GetDistanceToPoint(near_x, move_z, near_y)<fast then
        break
      end
      move_tick = move_tick + 0.01
      yield("/wait 0.01")
    else
      move_tick = move_tick + 0.1
      yield("/wait 0.1")
    end
  end
  if move_tick < timeout or not fast then yield("/visland stop") end
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

::Start::
if IsInZone(900) then
  goto OnBoat
elseif (os.date("!*t").hour%2==1 and os.date("!*t").min>=45) or (os.date("!*t").hour%2==0 and os.date("!*t").min<15) then
  if IsInZone(129) and GetDistanceToPoint(-410,4,76)<6.9 then
    if GetCharacterCondition(91) then
      goto Enter
    elseif os.date("!*t").hour%2==0 and os.date("!*t").min<15 then
      goto Queue
    elseif os.date("!*t").hour%2==1 and os.date("!*t").min>=45 then
      goto WaitForBoat
    end
  else
    goto ReturnFromWait
  end
elseif IsInZone(129) and GetDistanceToPoint(-410,4,76)<6.9 then
  goto DoneFishing
elseif fishing_character~="auto" and fishing_character~=GetCharacterName(true) then
  goto ARWait
else
  goto StartAR
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
    yield("/wait 1.003")
  end
end

::ReturnFromWait::
::TeleportToLimsa::
if not ( IsInZone(177) or IsInZone(128) or IsInZone(129) ) then
  yield("/tp Limsa")
  WaitReady(3, true)
end
if IsInZone(129) and GetDistanceToPoint(-84,19,0)<20 then
  while GetDistanceToPoint(-84,19,0)<20 do
    if IsAddonVisible("TelepotTown") then
      yield("/pcall TelepotTown true 11 3u")
    elseif GetTargetName()~="aetheryte" then
      yield("/target aetheryte")
    elseif IsAddonVisible("SelectString") then
      yield("/pcall SelectString true 0")
    elseif GetDistanceToTarget()<8 then
      yield("/pinteract")
    else
      yield("/lockon on")
      yield("/automove on")
    end
    yield("/wait 0.501")
  end
  WaitReady(3, true)
end
::ExitInn::
if IsInZone(177) then
  while IsInZone(177) do
    if GetTargetName()~="Heavy Oaken Door" then
      yield("/target Heavy Oaken Door")
    elseif IsAddonVisible("SelectYesno") then
      yield("/pcall SelectYesno true 0")
    else
      yield("/lockon on")
      yield("/automove on")
      yield("/pinteract")
    end
    yield("/wait 0.502")
  end
  WaitReady(3, true)
end
::MoveToAftcastle::
if IsInZone(128) and GetDistanceToPoint(13,40,13)<20 then
  if movement_method=="visland route" then
    yield("/visland exectemponce H4sIAAAAAAAACuWTyWrDMBCGXyXM2QiNFkvyrXQBH9KNQrrQg2hUIqilYistxeTdqzgKCfQNGp3mnxlGvz40I1zbzkEDbQizFGfWpZXrg0tQwcL+fEYf0gDNywi3cfDJxwDNCI/QcEKlqaVUFTxlZYhEJYWo4BkarIlWRqDaZBmDay+goRXc26Vf52GMZDGPX65zIU2VNiTX27e08Gl1U7qPc8Vj9jSs4ve+ks3kae/2Y3CH9skhVnDZxbS/uE2uK+HZ1FHE3doNqcTbwQvr02HiVl3F/jyGZXk43SUffOfmuY9uqj9YKBFSG6WYPuYiJywMCUdTc3Z6WJAILSUKNlERlCCnivMJi6L5K2ltTo+KIJIaLcoOZSp0e/SOCiesVvoEVwg50UxLdqCyA4IEFar6vwN53fwCXs5zv5QFAAA=")
    yield("/wait 3")
    while IsVislandRouteRunning() or IsMoving() do
      yield("/wait 1.035")
    end
  elseif movement_method=="visland random" then
    MoveNear(6, 40, 19, 0.5, 5, 7)  --a
    MoveNear(-4, 40, 20, 2, 5, 6)  --b
    MoveNear(1, 40, 77, 2, 9, 6)  --c
    MoveNear(18.6, 40, 71, 2, 5, 5)  --d
  end
end
::AethernetToArcanist::
if IsInZone(128) and GetDistanceToPoint(14,40,71)<9 then
  while IsInZone(128) do
    if IsAddonVisible("TelepotTown") then
      yield("/pcall TelepotTown true 11 3u")
    elseif GetTargetName()~="Aethernet shard" then
      yield("/target Aethernet shard")
    elseif GetDistanceToTarget()<4 then
      yield("/pinteract")
    else
      yield("/lockon on")
      yield("/automove on")
    end
    yield("/wait 0.503")
  end
  WaitReady(3, true)
end
::MoveToOcean::
if IsInZone(129) and GetDistanceToPoint(-335,12,53)<9 then
  if movement_method=="visland route" then
    yield("/visland exectemponce H4sIAAAAAAAACuWSy2rDMBBFfyXM2hV62hrtQh+QRfqikD7oQiRKLailEistJeTfq9gOLaX9gWRWM6PL5eowG7i0jQMDY5dqtwoujVIcxbmzYbT0be3DCxQws59v0YfUgnnawHVsffIxgNnAPZgTITSpkKkCHsAwRrTkCmUBj2CkJsgklts8xeAmZ1nAsYBbu/Dr7MYILWAa313jQgKTh0lIbmXnaeZTfbXT/9oNcXOoto4f+5ecJrst7WvrvuVdRFbAeROT21sl1wztuFMMw83atWnod8Yz69O34266iKvTGBbDz2m/vPONm2Yd3RZ/cCkVkciF7MBoQnOpsudSEcpKofV/YPhBg9GYwaCqOjCKYC6hezBIGBOU/QRDjwULcqIUH6DQjkc+ISZLjkeIQ9KKaFpiD0R0V4LYn0klSaVRqUPH8rz9ApGJUVChBQAA")
    yield("/wait 3")
    while IsVislandRouteRunning() or IsMoving() do
      yield("/wait 1.036")
    end
  elseif movement_method=="visland random" then
    MoveNear(-343.9, 12, 51.54, 1, 5, 3)  --1
    MoveNear(-356.5, 8, 52, 1, 5, 4)  --2
    MoveNear(-374.36, 8, 44, 2, 5, 7)  --3
    MoveNear(-395, 6, 48, 2.5, 5, 7.5)  --4
    MoveNear(-393, 5, 71, 3, 5, 7)  --5
    MoveNear(-408, 4, 73.5, 2.2, 5)  --ocean
    yield("/visland stop")
  end
end

::BuyBait::
if type(buy_baits)=="number" then
  if GetItemCount(29714)<buy_baits then
    yield("/echo Need to buy Ragworm!")
    is_purchase_ragworm = true
  end
  if GetItemCount(29715)<buy_baits then
    yield("/echo Need to buy Krill!")
    is_purchase_krill = true
  end
  if GetItemCount(29716)<buy_baits then
    yield("/echo Need to buy Plump Worm!")
    is_purchase_plump = true
  end
  if is_purchase_ragworm or is_purchase_krill or is_purchase_plump then
    if IsInZone(129) and GetDistanceToPoint(-397,3,80)>5 then MoveNear(-398, 3, 78, 2, 5) end
    while not IsAddonVisible("Shop") do
      if GetTargetName()~="Merchant & Mender" then
        yield("/target Merchant & Mender")
      elseif GetCharacterCondition(32, false) then
        yield("/pinteract")
      elseif IsAddonVisible("SelectString") then
        yield("/pcall SelectString true 0")
        yield("/wait 0.591")
      end
    end
    if is_purchase_ragworm then
      yield("/pcall Shop true 0 0 99")
      is_purchase_ragworm = false
      yield("/wait 0.5")
      if IsAddonVisible("SelectYesno") then yield("/pcall SelectYesno true 0") end
      yield("/wait 0.5")
    end
    if is_purchase_krill then
      yield("/pcall Shop true 0 1 99")
      is_purchase_krill = false
      yield("/wait 0.5")
      if IsAddonVisible("SelectYesno") then yield("/pcall SelectYesno true 0") end
      yield("/wait 0.5")
    end
    if is_purchase_plump then
      yield("/pcall Shop true 0 2 99")
      is_purchase_plump = false
      yield("/wait 0.5")
      if IsAddonVisible("SelectYesno") then yield("/pcall SelectYesno true 0") end
      yield("/wait 0.5")
    end
  goto BuyBait
  end
  yield("/pcall Shop true -1")
  if GetDistanceToPoint(-398,3,78)>5 then
    MoveNear(-404, 4, 73, 1, 2)
    MoveNear(-408, 4, 73.5, 2.2, 5)
  end
end

::WaitForBoat::
while not ( os.date("!*t").hour%2==0 and os.date("!*t").min<15 ) do
  yield("/wait 1.005")
end

::BotPause::
notabot = math.random(3,10)
yield("/echo Randomly waiting "..notabot.." seconds. Soooooooo human.")
yield("/wait "..notabot)

::Queue::
if IsInZone(129) and GetDistanceToPoint(-410,4,76)<6.9 then
  while GetCharacterCondition(91, false) do
    if GetTargetName()~="Dryskthota" then
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
    yield("/wait 0.511")
  end
else
  yield("/echo Zone: "..GetZoneID())
  if IsInZone(129) then yield("/echo Distance from Dryskthota: "..GetDistanceToPoint(-410,4,76)) end
  yield("/echo That's not gonna work, chief.")
  yield("/pcraft stop")
end

::Enter::
while IsInZone(129) do
  if IsAddonVisible("ContentsFinderConfirm") then yield("/pcall ContentsFinderConfirm true 8") end
  yield("/wait 1.007")
end
WaitReady(3, true)

::PrepareRandom::
movement = true
move_y = math.random(-11000,5000)/1000
move_z = 6.750
if math.ceil(move_y)%2==1 then
  move_x = 7.5
else
  move_x = -7.5
end
if is_debug then
  yield("/echo move_x: "..move_x)
  yield("/echo move_y: "..move_y)
end

::OnBoat::
results_tick = 0
debug_tick = 0
start_fishing_attempts = 0
while IsInZone(900) do
  current_route = routes[GetCurrentOceanFishingRoute()]
  current_zone = current_route[GetCurrentOceanFishingZone()+1]
  normal_bait = baits[current_zone].normal_bait
  if GetCurrentOceanFishingTimeOfDay()==1 then spectral_bait = baits[current_zone].daytime end
  if GetCurrentOceanFishingTimeOfDay()==2 then spectral_bait = baits[current_zone].sunset end
  if GetCurrentOceanFishingTimeOfDay()==3 then spectral_bait = baits[current_zone].nighttime end
  if OceanFishingIsSpectralActive() then
    correct_bait = spectral_bait
    if force_autohook_presets then
      if autohook_preset_loaded~="spectral" then
        AutoHookPresets()
      end
    end
  else
    correct_bait = normal_bait
    if force_autohook_presets then
      if autohook_preset_loaded~="normal" then
        AutoHookPresets()
      end
    end
  end
  if IsAddonVisible("IKDResult") then
    yield("/wait 10")
    yield("/pcall IKDResult true 0")
  elseif IsAddonVisible("NowLoading") or GetCharacterCondition(35) then
    WaitReady(2, false, 62)
  elseif GetCurrentOceanFishingZoneTimeLeft()<0 and is_wait_to_move then
    yield("/wait 1.011")
  elseif GetInventoryFreeSlotCount()<=2 then
    for _, command in pairs(bags_full) do
      if command=="/leaveduty" then LeaveDuty() end
      if is_debug then yield("/echo Running: "..command) end
      yield(command)
    end
  elseif movement and ( GetCurrentOceanFishingZoneTimeLeft()<420 or not is_wait_to_move ) then
    yield("/visland moveto "..move_x.." "..move_z.." "..move_y)
    yield("/wait 0.512")
    move_tick = 0
    while IsMoving() and move_tick <= 5 do
      if GetCurrentOceanFishingZoneTimeLeft()<420 and GetCurrentOceanFishingZoneTimeLeft()>0 then
        move_tick = move_tick + 0.1
      end
      if is_adjust_z then
        move_z = math.floor(GetPlayerRawYPos()*1000)/1000
        yield("/visland moveto "..move_x.." "..move_z.." "..move_y)
      end
      yield("/wait 0.119")
    end
    if move_x == 7.5 then yield("/visland moveto 9 "..move_z.." "..move_y)
    else yield("/visland moveto -9 "..move_z.." "..move_y) end
    yield("/wait 0.200")
    yield("/visland stop")
    movement = false
  elseif bait_and_switch and correct_bait~=current_bait then
    yield("/tweaks e baitcommand")
    if correct_bait=="Ragworm" then bait_count = GetItemCount(29714)
      elseif correct_bait=="Krill" then bait_count = GetItemCount(29715)
      elseif correct_bait=="Plump Worm" then bait_count = GetItemCount(29716)
    end
    yield("/echo Switching bait to: "..correct_bait)
    if GetCharacterCondition(43) then
      while GetCharacterCondition(42, false) do yield("/wait 1.012") end
      yield("/ahoff")
      while GetCharacterCondition(43) do yield("/wait 1.013") end
    end
    if bait_count>1 then
      yield("/bait "..correct_bait)
    else
      yield("/echo Out of "..correct_bait)
      yield("/bait Versatile Lure")
    end
    is_changed_bait = true
    --yield("/wait 0.4")
    if not (IsAddonVisible("_TextError") and GetNodeText("_TextError", 1)=="Unable to change bait at this time.") then
      current_bait = correct_bait
    end
  elseif GetCurrentOceanFishingZoneTimeLeft()>30 and GetCharacterCondition(43, false) then
    not_fishing_tick = 0
    while GetCharacterCondition(43, false) and not_fishing_tick<1.5 and not is_changed_bait do
      yield("/wait 0.108")
      not_fishing_tick = not_fishing_tick + 0.1
    end
    is_changed_bait = false
    if start_fishing_attempts>6 then
      LeaveDuty()
      yield("/pcraft stop")
    elseif start_fishing_attempts>1 then
      current_bait = ""
    elseif GetCharacterCondition(43, false) then
      start_fishing_attempts = start_fishing_attempts + 1
      if is_debug then yield("/echo Starting fishing from: X: ".. math.floor(GetPlayerRawXPos()*1000)/1000 .." Y or Z, depending on which plugin you ask: ".. math.floor(GetPlayerRawZPos()*1000)/1000 ) end
      for _, command in pairs(start_fishing) do
        if is_debug then yield("/echo Running: "..command) end
        yield(command)
      end
    end
  else
    start_fishing_attempts = 0
  end
  if is_debug and IsInZone(900) then
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
  yield("/wait 1.010")
end

::DoneFishing::
RunDiscard(1)
if autohook_preset_loaded then
  DeletedSelectedAutoHookPreset()
  autohook_preset_loaded = false
end
WaitReady(3, false, 72)

::SpendScrips::
if is_spend_scrips then
  yield("/visland moveto -407 71 4")
  while IsAddonVisible("InclusionShop")==false do
    if GetTargetName()~="Scrip Exchange" then
      yield("/target Scrip Exchange")
    elseif IsAddonVisible("SelectIconString")==false then
      yield("/pinteract")
      yield("/visland stop")
    else
      yield("/pcall SelectIconString true 0")
    end
    yield("/wait 0.521")
  end
  yield("/pcall InclusionShop true 12 "..scrip_category)
  yield("/wait 0.522")
  yield("/pcall InclusionShop true 13 "..scrip_subcategory)
  yield("/wait 1.021")
  scrips_raw = string.gsub(GetNodeText("InclusionShop", 21),"%D","")
  scrips_owned = tonumber(scrips_raw)
  for item=21, 36 do
    scrip_shop_item_name = string.sub(string.gsub(GetNodeText("InclusionShop", 5, item, 12),"%G",""),5,-3)
    if scrip_shop_item_name==string.gsub(scrip_item_to_buy,"%G","") then
      price_raw = string.gsub(GetNodeText("InclusionShop", 5, item, 5, 1),"%D","")
      scrip_shop_item_price = tonumber(price_raw)
      scrip_number_to_buy = scrips_owned//scrip_shop_item_price
      yield("/pcall InclusionShop true 14 "..item-21 .." "..scrip_number_to_buy)
      yield("/wait 1.022")
      if IsAddonVisible("ShopExchangeItemDialog") then
        yield("/pcall ShopExchangeItemDialog true 0")
        yield("/wait 1.023")
      end
      break
    end
  end
  yield("/pcall InclusionShop true -1")
end

::WaitLocation::
if wait_location=="inn" then
  ::MoveToArcanist::
  if IsInZone(129) and GetDistanceToPoint(-408,4,75)<20 then
    if movement_method=="visland route" then
      yield("/visland exectemponce H4sIAAAAAAAACuWTTU8DIRCG/0oz55XAArvAzfiR9FCrxqR+xANpqUvigtmlGrPpf5elbOrBX2A5MfO+GYYnMwPc6NaAguXaaDfb2r6x7m0W/Eyb0JjOmQAFrPT3h7cu9KBeBrj1vQ3WO1ADPII6o5IgUcm6gCdQHOECnkFVHHFW8nIfI+/M/BJUFO71xu5ilXJ0LfynaY0LSZm7YDq9DisbmmV2/87lNmMzfeO/JiV2Eatt9XtvjvbUGingqvVhengeTJuv58mRg7ud6UO+j4VX2oZjxTG69t2Fd5v8Y3xIPtjWLKIP74s/eAiJaEVp5iHjKVmdqDARFSYZO0UsXCKCBa4SF4HweNiEhVeSi5OkQhGlbJyPSKVO0yJoohIVLFktThIL5YgQSg5LRMjIhZQTFlaVNf73O/S6/wFHKPaRngUAAA==")
      yield("/wait 3")
      while IsVislandRouteRunning() or IsMoving() do
        yield("/wait 1.031")
      end
    elseif movement_method=="visland random" then
      MoveNear(-388, 5, 61, 1, 5, 5.5)  --1
      MoveNear(-386.5, 6, 41.8, 1, 5, 8)  --2
      MoveNear(-362.4, 8, 48.5, 1, 5, 3)  --3
      MoveNear(-354, 8, 50, 0.5, 3, 3)  --4
      if move_x==7.5 then
        MoveNear(-352.5, 8, 53.5, 0.5, 3, 2)  --5l
        MoveNear(-344, 12, 52.4, 0.5, 3, 2)  --6l
      else
        MoveNear(-350, 8, 49, 0.5, 3, 2.5)  --5r
        MoveNear(-336, 12, 48.6, 0.5, 3, 3)  --6r
      end
      MoveNear(-333.5, 12, 55.5, 2, 5, 5)  --arcanist
    end
  end
  ::AethernetToAftcastle::
  if IsInZone(129) and GetDistanceToPoint(-335,12,53)<9 then
    while IsInZone(129) do
      if IsAddonVisible("TelepotTown") then
        yield("/pcall TelepotTown true 11 1u")
      elseif GetTargetName()~="Aethernet shard" then
        yield("/target Aethernet shard")
      elseif GetDistanceToTarget()<4 then
        yield("/pinteract")
      else
        yield("/lockon on")
        yield("/automove on")
      end
      yield("/wait 0.531")
    end
    WaitReady(3, true)
  end
  ::MoveToInn::
  if IsInZone(128) and GetDistanceToPoint(14,40,71)<9 then
    if movement_method=="visland route" then
      yield("/visland exectemponce H4sIAAAAAAAACuWT22rDMAyGX6XoOjNyYseHu7ID9KI7Mei6sYuwetSw2CNxN0bou09JU1rYnmDVlX5JyNKH3MF1VTuwMHVp7Zrg0iTFiQ8BMlhU3x/Rh9SCfe7gNrY++RjAdvAIliNTyCWKDJZgBTLsjdQTWCWYQNRiSyoGN7sAixncVyu/oV45IzGPn652IQ2ZWUiuqV7Twqf1zVh9HBtHpJHadfzaZ2gW6vZWvbfuUD4MyDO4rGPaPzxLrh7d6VAxiruNa9Po940XlU+Hjr26is15DKtxb9wFH3zt5lSH2+w3FcKgi7LM/6LCmVJSmdOjcoaMK11oLsqBS2GY6a0cuIiCFWgwl6cHhnYzXJpc77FIThcyUOGKqOTmFKnwgnGt6RsdH4uWOyw505Jj+e9/0cv2ByD0KqubBQAA")
      yield("/wait 3")
      while IsVislandRouteRunning() or IsMoving() do
        yield("/wait 1.032")
      end
    elseif movement_method=="visland random" then
      MoveNear(5.5, 40, 74, 1, 5, 6)  --a
      MoveNear(-3, 40, 72, 1, 5, 5)  --b
      MoveNear(0.5, 40, 11, 1, 9, 8)  --c
      MoveNear(13, 40, 12, 0, 5)  --d
    end
  end
  ::EnterInn::
  while IsInZone(128) do
    if GetDistanceToPoint(13,40,13)<4 then
      if GetTargetName()~="Mytesyn" then
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
    yield("/wait 0.532")
  end
  WaitReady(3, true)
elseif wait_location=="fc" then
  yield("/tp Estate Hall (Free Company)")
  WaitReady(3, true)
  yield("/autmove on")
  yield("/wait 1.033")
  yield("/automove off")
  yield("/ays het")
  WaitReady(3, true)
end

WaitReady()

::Desynth::
if is_desynth then
  is_doing_desynth = true
  failed_click_tick = 0
  open_desynth_attempts = 0
  while is_doing_desynth do
    if not IsAddonVisible("SalvageItemSelector") then
      yield("/generalaction desynthesis")
      open_desynth_attempts = open_desynth_attempts + 1
      if open_desynth_attempts>5 then
        is_doing_desynth = false
        is_desynth = false
        yield("/echo Tried too many times to open desynth, and it hasn't worked. Giving up and moving on.")
      end
    elseif IsAddonVisible("SalvageDialog") then
      yield("/pcall SalvageDialog true 0 false")
      is_clicked_desynth = false
    elseif IsAddonVisible("SalvageResult") then
      yield("/pcall SalvageResult true 1")
    elseif IsAddonVisible("SalvageAutoDialog") then
      is_clicked_desynth = false
      if string.sub(GetNodeText("SalvageAutoDialog", 27),1,1)=="0" then yield("/pcall SalvageAutoDialog true -1") end
    elseif is_clicked_desynth then
      failed_click_tick = failed_click_tick + 1
      if failed_click_tick>4 then
        is_doing_desynth = false
        yield("/pcall SalvageItemSelector true -1")
      end
    elseif GetCharacterCondition(39, false) then
      for list=2, 16 do
        item_name_raw = string.gsub(GetNodeText("SalvageItemSelector", 3, list, 8),"%W","")
        item_name = string.sub(item_name_raw, 3,-3)
        item_level_raw = string.sub(GetNodeText("SalvageItemSelector", 3, list, 2),1,3)
        item_level = string.gsub(item_level_raw,"%D","")
        item_type = GetNodeText("SalvageItemSelector", 3, list, 5)
        if item_level=="1" and item_type=="Culinarian" then
          if is_debug then
            yield("/echo item_name: "..item_name)
            yield("/echo item_level: "..item_level)
            yield("/echo item_type: "..item_type)
          end
          yield("/pcall SalvageItemSelector true 12 "..list-2)
          is_clicked_desynth = true
          break
        elseif list==16 then
          is_doing_desynth = false
          break
        end
      end
    end
    yield("/wait 0.540")
  end
  yield("/pcall SalvageItemSelector true -1")
end

RunDiscard(2)

::StartAR::
if is_ar_while_waiting then
  if fishing_character=="auto" then fishing_character = GetCharacterName(true) end
  yield("/ays multi")
  while GetCharacterCondition(1) do
    yield("/wait 1.040")
  end
  goto ARWait
else
  goto WaitForBoat
end

goto Start
