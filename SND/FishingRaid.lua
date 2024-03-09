--[[

  Automatic ocean fishing script. Options for AutoRetainer and returning to inn room between trips.

    Script runs using:
      SomethingNeedDoing (Expanded Edition): https://puni.sh/api/repository/croizat
    Required plugins:
      Autohook: https://love.puni.sh/ment.json
      Pandora: https://love.puni.sh/ment.json
      Visland: https://puni.sh/api/repository/veyn
    Required for major features:
      Teleporter: main repository
      Simple Tweaks: main repository
    Optional plugins:
      AutoRetainer: https://love.puni.sh/ment.json
      Discard Helper: https://plugins.carvel.li/
      YesAlready: https://love.puni.sh/ment.json
]]

-- Before getting on the boat
do_repair = "npc"  --"npc", "self". Add a number to set threshhold; "npc 10" to only repair if under 10%
buy_baits = 100  --Minimum number of baits you want. Will buy 99 at a time.
boat_route = "indigo"  --"indigo", "ruby", "random"
is_equip_recommended_gear = true  --Run /equiprecommended

-- Just got on the boat
food_to_eat = false  --Name of the food you want to use, in quotes. DOES NOT CHECK ITEM COUNT YET
is_wait_to_move = true  --Wait for the barrier to drop before moving to the side of the boat.
is_adjust_z = true  --true might cause stuttery movement, false might cause infinite movement. Good luck.

-- Fishing
bait_and_switch = true  --Uses /bait command from SimpleTweaks
force_autohook_presets = true
is_recast_on_spectral = true  --Cancels cast when spectral current starts
is_leveling = "auto"  --false, "auto"

-- Getting off the boat
score_screen_delay = 3  --How long in seconds to wait once the final score is displayed.
is_discard = false  --Requires Discard Helper. Can set to "spam" to run during cutscenes.
is_desynth = true  --Will enable Extended Desynthesis Window in Simple Tweaks. Optionally runs faster with YesAlready.

-- Waiting for next boat
wait_location = false  --false, "inn", "fc", "private", "apartment", "shared", "Shared Estate (Plot [#], [#]nd ward)"
is_ar_while_waiting = false  --AutoRetainer multimode enabled in between fishing trips.

-- Other script settings
is_verbose = true  --General status messages
is_debug = false  --Spammy status messages
fishing_character = "auto"  --"First Last@Server", "auto"
movement_method = "visland" --"visland" (navmesh coming soon)
is_last_minute_entry = false  --Waits until 5 minutes before the boat leaves
is_single_run = false  --Only go on 1 fishing trip, then stop.

-- Spend white gatherer scrips (overhaul coming soon:tm:)
spend_scrips_when_above = false
scrip_category = 1
scrip_subcategory = 1
scrip_item_to_buy = "Hi-Cordial"

-- What to do when bags are full. (overhaul coming soon:tm:)
bags_full = {
  "/echo Bags full!",
  "/leaveduty",
  "/pcraft stop",
}

------------------------------------------------------------------------

function AutoHookPresets()
  if force_autohook_presets then
    if is_leveling then
      if GetLevel()>=60 then
        UseAutoHookAnonymousPreset("AH4_H4sIAAAAAAAACu1aTXPaMBD9K4zPZAZMME0OnUkJ+ZjSlAHaHJgcVCywBmG5spyEZvjv1SJLRMYGckon1Q1Wb98+adfarMmLd5EJ1kWpSLuzuXf+4vVi9IviC0q9c8EzXPdgsU9ivF0M9dKAE8aJWHnnzbp3m/aepzQLcbg1A2ytKL4xNo2AY/PBh0/XyTjiOI0YlYzNRsMi3M9YLaRxUEk3ypYlm7HUdIK2xapdGaV4KsB7u+gfjsh4SBDde4KnOfaKpFFvhdOdA2q3rQMK9LmiBR5FZCa+ILIRBoZUG0YCTReSS+7GJntNdZZTDZAgOJ6WZdp2DuxU+dqfkz+4i4TKs+XiF7Lbyl3GEaIELdIr9Mg4eFkGrb5Vt+1DPGWPWOKbcCb7pLasqMEaSudZcJQXOxzRmI2eUHIbi4wIwuJrRGJYupXeJ7II79BSHojnSc8SdJ+logI9kCJwObt34lWsK77N+jbaKJE1xxHtZpzjWBylsOBzpM7SSN4EapLE8yEi4UNNYwpbKA0oN2Ii5CFtsj5+xFR+q30OGpKwT1LxfQa7kFmfqPwAXkv3zzrNjlH/E/NUlizFtX7GMUS6Y3yJ6A1ji80jmtfzPUab72AHvatEep82O1D3GjMSnMXzElSj9QrVx3Mch4ivqoA/UnzJMlmOSoOqSGUpqDBVO0M0lSCLzQ9Am/LbUXa0Z7VahRpzkrxRV6ftt4znG5VZvnu05biRYMnFTGDeRdk8ki1oCfcb3MTmadGJHuLfGeE4lPeFyOC2Cz5tc+ay/7GyD3BQXbj2wQwUakPwdCubklkB1nuAp1dZjbIKj1fKt04Q0xTlHl0GsyvwkHsBVSr5EMcuUNOUXlsW9+XN+KZAW5Eik3h3BX/UK3hdL2/Np6Y1D9H8SfZi15NdT3Y9+eP/ReZ6suvJbiz6J3ty2/Tkr5zIt3puSnZTspuSXUd2U7Kbkt2LyvfoyIHpyAOaLZPavRuU3ctr9/L6v/jpwg3KblB2g/L7DsoP+nfm/F9SJsagOvXkYf0XukpR2xcjAAA=")
      else
        UseAutoHookAnonymousPreset("AH4_H4sIAAAAAAAACu1aTXPaMBD9K4zPZAZMME2ml5SQjylNGaDNgclBxQJrEJYry0lohv9eLbJEZGwgp3RS3WD19u2Tdq3Nmrx4F5lgXZSKtDube+cvXi9Gvyi+oNQ7FzzDdQ8W+yTG28VQLw04YZyIlXferHu3ae95SrMQh1szwNaK4htj0wg4Nh98+HSdjCOO04hRydhsNCzC/YzVQhoHlXSjbFmyGUtNJ2hbrNqVUYqnAry3i/7hiIyHBNG9J3iaY69IGvVWON05oHbbOqBAnyta4FFEZuILIhthYEi1YSTQdCG55G5sstdUZznVAAmC42lZpm3nwE6Vr/05+YO7SKg8Wy5+Ibut3GUcIUrQIr1Cj4yDl2XQ6lt12z7EU/aIJb4JZ7JPasuKGqyhdJ4FR3mxwxGN2egJJbexyIggLL5GJIalW+l9IovwDi3lgXie9CxB91kqKtADKQKXs3snXsW64tusb6ONEllzHNFuxjmOxVEKCz5H6iyN5E2gJkk8HyISPtQ0prCF0oByIyZCHtIm6+NHTOW32uegIQn7JBXfZ7ALmfWJyg/gtXT/rNPsGPU/MU9lyVJc62ccQ6Q7xpeI3jC22DyieT3fY7T5DnbQu0qk92mzA3WvMSPBWTwvQTVar1B9PMdxiPiqCvgjxZcsk+WoNKiKVJaCClO1M0RTCbLY/AC0Kb8dZUd7VqtVqDEnyRt1ddp+y3i+UZnlu0dbjhsJllzMBOZdlM0j2YKWcL/BTWyeFp3oIf6dEY5DeV+IDG674NM2Zy77Hyv7AAfVhWsfzEChNgRPt7IpmRVgvQd4epXVKKvweKV86wQxTVHu0WUwuwIPuRdQpZIPcewCNU3ptWVxX96Mbwq0FSkyiXdX8Ee9gtf18tZ8alrzEM2fZC92Pdn1ZNeTP/5fZK4nu57sxqJ/sie3TU/+yol8q+emZDcluynZdWQ3Jbsp2b2ofI+OHJiOPKDZMqndu0HZvbx2L6//i58u3KDsBmU3KL/voPygf2fO/yVlYgyqU08e1n8B1bpk/BcjAAA=")
      end
    elseif OceanFishingIsSpectralActive() then
      if GetMaxGp()>700 then
        UseAutoHookAnonymousPreset("AH4_H4sIAAAAAAAACu1aTXPaMBD9KxmdyQyYAA23lHxOacoAbQ5MDioWtgZhubKclDL892otS8bEhvTSSVrdYPV292l3pWWVbNBFKvkAJzIZLALU36CrCH9n5IIx1JciJQ0Ei0MaEVi8CyIuyGfO5yHqLzBL1LpW8A18JCgXVK5Rv9VAd8nVzzlLfeIXYoBttdnc0AZlH7zCvbV2E09DQZKQMyVqNZsl+4cd1PNqHiU2CNMVsDno3mA5Y2QuAV4sesddcOFTzCr2XMDPcuw1TcKrNUleUOp0SpS6Jq54SSYhXciPmGbEQJAYwUTi+VLZ6uyFt7Nr6jw3NcKSkmieZb+M7paj4RkFQX+RAZY6sSUVby+A7VxlGmJG8TK5xk9cgFZJYOi2G2X5mMz5E1H4FgThUN20S167WyiOn1LgUsVbVQjRlE+ecXwXyZRKyqMbTKOs/BXoVFXdPV6pgCC0rUQPeSJr0CPFiVRbR6eoZl3by9YLb5NY1ZzAbJAKQSL5KoZ7Oq/kWekJzaAmaRSMMfUfT+65WKlabiBQ0MqVzkyB11rP91pp3fLKiZZBxpAiMaSJ/LKAfauymW2yCADWbNY777V6dr/fiEhUkTNyMkwFAS/a3y3ny+xQ5yfggeDsO8iB/jpW2metHpwUg5lIwaOgAtVs76CGJCCRj8W6DnjJU1WRew5tmeb3bknR655bvRoSu5B6Bhr1NSFTQWNGdBB02rTkj1j1Oh7sR2vW8SqBDjDLcRPJ44uFJGKA0yBUrWkFdxzcxvbEmNSNyY+UCuKrK0SmcON1PxRZcPl86/kEONDbu6BBDCY0cziBWqb51IANWThhWmqZ1WjsMC+UwKctswO8LOYlwWPqe6hKysdsvAQaM5UnuyB3eTu9rbBp7VWs1+TPlo67Q9/PHbptVHfLM9stxzh4Vu3RtUnXJt3PnrdwZF2bdG3SjRpvo012bJv8JKh6QXOzpJsl3duAa5JulnSz5H/3HlfXJLu2SY5YuopPHtw4+Y6z7F5d/61T68ZJN066cfIvd8pH8zfL/B8iZlagm+fscfsbA95oG6khAAA=")
      elseif GetMaxGp()>400 then
        UseAutoHookAnonymousPreset("AH4_H4sIAAAAAAAACu1aS3PaMBD+K4zOZIZHgIZbSp5TmjJAmwOTg4qFrUFYriwnoQz/PVrLkjGxIb10klY3WH27+2m12mWVbNB5IvkAxzIeLHzU36DLEP9k5Jwx1JciIXUEi0MaEli89UMuyFfO5wHqLzCL1bpW8Ax8JCgXVK5Rv1lHt/Hl85wlHvFyMcC22mxmaIPSD63cvbV2HU0DQeKAMyVqNhoF+4cdVPNqHCU2CJIVsDno3mA5Y2QuAZ4vto674MKjmJXsOYefZtgrGgeXaxK/otTpFCh1TVzxkkwCupCfMU2JgSA2gonE86Wy1dkLb2fX1FlmaoQlJeE8Pf0iuluMRssoCPqbDLDUB1tQae0FsJ2pTAPMKF7GV/iRC9AqCAzddr0oH5M5fyQK34QgHMqbdsFrdwvJ8SwFLmS8VYUQTfnkCUe3oUyopDy8xjRM01+BTlTW3eGVCghC21L0kMeyAj1SnEi5dXSCKta1vXQ99zaJVM4JzAaJECSUb2K4p/NGnqWeUjawqpGllk02V5rKNjaD9KahP8bUe6jdcbHCrHZSG/Kn2vUoZ5PRK6KNxRxfR0May28L2LbKmtkmDQAomb22znrNnt3uDyJileOM1IaJIOBOM7jhfJne6ewC3BOcfgc5bGgdKe3TZg8uisFMpOChX4JqtHdQQ+KT0MNiXQX8HpMLnqic1Bx0HLVkj4VN3awWF6y1usBN61Uw24VU09KoqaDRHxLodVptq1lFoQA6QCLDTSSPzheSiAFO/EB1phWUOCjG9sKYoxuTXwkVxFMVRCZQ8Lqf8lNw5/nezxPgQG+vPoMYTGjmcAO1TPOpABuycMO01DKr0NhhniuBT5tmB3hZzGuCx9T3UKWUj9l4DTRmSktLTu7iZnpTYtPaK1mvOD+bOq6Gfpwauq2Xd8tT2y3H2H9S7dG1Sdcm3c+e93BlXZt0bdKNGu+jTXZsm/wiqHpAc7OkmyXd24Brkm6WdLPkf/ceV9Uku7ZJjliyimr3bpz8wKfsXl3/rVvrxkk3Trpx8i93ygfzN8vs/yFmVqCb5+xh+wJpSeU1qCEAAA==")
      else
        is_leveling = true
      end
      autohook_preset_loaded = "spectral"
    else
      if GetMaxGp()>700 then
        UseAutoHookAnonymousPreset("AH4_H4sIAAAAAAAACu1aTXPaMBD9KxmfkxlwwDTcKPmc0pQB2hyYHBQssAZjubKchDL892otS0bGQJjphUY3Rtr39Fa72rWUrJxOymkXJTzpTmdOe+XcROglxJ0wdNqcpfjcgckeiXAx6aupPiOUEb502vVz5yG5eZ+EqY/9YhjM1pLiO6WTADiyHy78uotHAcNJQEPBWK/VDML9jLuF1A4q6QbposIZQ03LaxqsCkrDEE84oItJ9/CKlPkEhSaskU/ekiS4WeJka0eaTWNHPLWRaI6HAZnyr4hkSmAgUQNDjiZzwSXkm2SbVFc5VR9xgqNJFlrT2jOD4SoAI39wF3EZSQPiluJ3mUNGAQoJmie36JUyQBkDSi6EzZgY4Al9xQJQh13YF6pmaWHPmO+8CBqnPUVhgteQOO+cISPVNSts34gO31D8EPGUcEKjO0QisHwQRhciIx/RQpA5zrrSukcTvsO6L+TganbnwtkxL/my+WK1YSwSkKGwmzKGI/4hhSXMHp1gLbVUrqNOWyG20swZQ1KTaDZAxH8+UzYlPytVCW/1duW6TLJHyhYZVY8k/McUnBT5M15l7oKl8sy9atVb2rlfmCUi20N81ksZhjUk0T2l8+xc5kfhCaN5kRswC3sh1Crn86HRMha0jXoLzpICDzmj0ewYeO1yA97DMxz5iC2PZrimqTBW2nMLnd5Z8peArnelcYXsY5GG4gqrESPxkbpaTfdSI49UZmD3aMvthpzGnSnHrIvSWSCa3AIKKtR6fQRVegzw75Qw7It6xVMor96XIm4l/w6kxocz4JQC/TPBctflhslMPdXogzmoLvUHGAYK6RDEV45JmTuMlQ8QPzmqle1AbCgvQLCmTso9urTNtsBD8JJVpeRDHNuGiqYyQQzu6/vRfYl2R4h04G3htoV78+iuz6s/Axr6M2CAZm+i7x/u/5+4lp9q2bZN2zZt27RPsmnbavufdNqm7rTfGBFviLbP2j776Y+4vRzby7Hts/ZW8w/7rKf7bD9MF/HZ04cutfZR296P7aO2fdS2j9ondj+2hfvzFu71s/pbd/4vNGM9IL8Kxs/rvzoxdEnHIwAA")
      elseif GetMaxGp()>400 then
        UseAutoHookAnonymousPreset("AH4_H4sIAAAAAAAACu1aXW/aMBT9KyjPVIIUwsobo58a6xCw9QH1wSWGWIQ4c5x2rOK/zzeODQ4JUKlSpc5v1D7n+Nj32hebvjq9lNM+SnjSny+c7qtzFaGnEPfC0OlyluK6A50DEuFtp6+6hoxQRvja6Tbrzl1y9WcWpj72t80A20iJ75TOAtDIPrjw6SaeBAwnAQ2FYrPRMAQPK1YbaRx10g/SVclkDDctr22oKioNQzzjwN52usdHpMwnKDRprbzzmiTB1RoneyvSbhsr4qmFREs8Dsicf0UkcwINiWoYczRbCi1h3xTblbrIpYaIExzNstCaaM8MhqsIjPzFfcRlJA2KW4jfeU6ZBCgkaJlco2fKgGU0KLsQNqNjhGf0GQtCE1bhUKiKA3tGf+9JyDjdOQoTvIHE+cMZMlJdq8LyTej4BcV3EU8JJzS6QSQC5J0AnYmMvEcrIeY4m1L0gCa8Aj0UdnC5unPmVPRLvax/O9o4FgnIUNhPGcMRP8lhgXPAJ6Cll9Jx1G7bmi2FOVNIahItRoj4jzWFqZ3VBvSldjMsTLjUnpi2XrfcoKl6T9nK1ByQhP+Yw7RFRk1fswUAipqre9FpdvR0f2GWiPwPcW2QMgyDScVbSpfZTs03xwNG2d/QDpbXsWC3mh3YRAoz5oxGixJU43wHNcALHPmIrauAlzQVCVkYUGdplsN1k+h6F5q3Z+JkZrUxiZowEr/RV6ftnmvmG50Z3APectyY07g355j1UboIRK1awbkIR7beSSqmI/w7JQz74tjhKZyS3pf6RwT6Z4LlyktjclvZ6L9v9AEOMS0c89AMEjLcEF/ZJkNbAVZxh/jJVu2sgrHjfEuCMXVSHvClMfsGj9ELqFLLxzT2gUqmNHEN7cvbyW1BtiJEetvb0/YTnLabennBbemCO0KLF1FhbaW1ldZW2k/1PctWWltp7b3moyttW1fab4yI9zt7o7U3WnujtXXW3mjtjda+H75fnfV0nR2G6SquPZx0qZXbMDcAr967ryfHnxtPpVe/Q75Jwb5F2pdo+zuEvR/bl2h7cP/HPyFuHtWvyvm/r0x1g/xWMH3c/AMAagpYQyMAAA==")
      else
        is_leveling = true
      end
      autohook_preset_loaded = "normal"
    end
  end
end

baits_list = {
  unset = { name = "unset", id = 0},
  versatile = { name = "Versatile Lure", id = 29717 },
  ragworm = { name = "Ragworm", id = 29714 },
  krill = { name = "Krill", id = 29715 },
  plumpworm = { name = "Plump Worm", id = 29716 },
}

ocean_zones = {
  [1] = {id = 237, name = "Galadion Bay", normal_bait = baits_list.krill, daytime = baits_list.ragworm, sunset = baits_list.plumpworm, nighttime = baits_list.krill},
  [2] = {id = 239, name = "Southern Merlthor", normal_bait = baits_list.krill, daytime = baits_list.krill, sunset = baits_list.ragworm, nighttime = baits_list.plumpworm},
  [3] = {id = 243, name = "Northern Merlthor", normal_bait = baits_list.ragworm, daytime = baits_list.plumpworm, sunset = baits_list.ragworm, nighttime = baits_list.krill},
  [4] = {id = 241, name = "Rhotano Sea", normal_bait = baits_list.plumpworm, daytime = baits_list.plumpworm, sunset = baits_list.ragworm, nighttime = baits_list.krill},
  [5] = {id = 246, name = "The Ciedalaes", normal_bait = baits_list.ragworm, daytime = baits_list.krill, sunset = baits_list.plumpworm, nighttime = baits_list.krill},
  [6] = {id = 248, name = "Bloodbrine Sea", normal_bait = baits_list.krill, daytime = baits_list.ragworm, sunset = baits_list.plumpworm, nighttime = baits_list.krill},
  [7] = {id = 250, name = "Rothlyt Sound", normal_bait = baits_list.plumpworm, daytime = baits_list.krill, sunset = baits_list.krill, nighttime = baits_list.krill},
  [8] = {id = 286, name = "Sirensong Sea", normal_bait = baits_list.plumpworm, daytime = baits_list.krill, sunset = baits_list.krill, nighttime = baits_list.krill},
  [9] = {id = 288, name = "Kugane Coast", normal_bait = baits_list.ragworm, daytime = baits_list.krill, sunset = baits_list.ragworm, nighttime = baits_list.plumpworm},
  [10] = {id = 290, name = "Ruby Sea", normal_bait = baits_list.krill, daytime = baits_list.ragworm, sunset = baits_list.plumpworm, nighttime = baits_list.krill},
  [11] = {id = 292, name = "Lower One River", normal_bait = baits_list.krill, daytime = baits_list.ragworm, sunset = baits_list.krill, nighttime = baits_list.krill},
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

function WaitReady(delay, is_not_ready, status, target_zone)
  if is_not_ready then loading_tick = -1
    else loading_tick = 0 end
  if not delay then delay = 3 end
  wait = 0.1
  if type(status)=="number" then wait = wait + (status / 10000) end
  while loading_tick<delay do
    if IsAddonVisible("NowLoading") then loading_tick = 0
    elseif IsPlayerOccupied() then
      if GetCharacterCondition(3) or GetCharacterCondition(11) then  --Emoting or sitting
        yield("/autorun on")
        yield("/autorun off")
      elseif GetCharacterCondition(16) then  --Performance
        yield("/send escape")  --I HATE using sends, it's clumsy. Need to find a better way to end performance.
      else
        loading_tick = 0
      end
    elseif loading_tick == -1 then
      if type(target_zone)=="number" then
        if IsInZone(target_zone) then loading_tick = 0 end
      end
      yield("/wait "..wait)
    else loading_tick = loading_tick + 0.1 end
    yield("/wait "..wait)
    if IsAddonVisible("IKDResult") then break end
    if is_discard=="spam" then yield("/discardall") end
  end
end

function RunDiscard(y)
  if is_discard then
    if is_desynth and y then
      verbose("You have desynth and discard turned on.")
      verbose("Waiting to discard until after desynth!")
    elseif y then
      discarded_on_1 = os.time()+10
      yield("/discardall")
    elseif discarded_on_1 then
      yield("/discardall")
      if os.time()<=discarded_on_1 then yield("/wait "..discarded_on_1-os.time()) end
    else
      yield("/discardall")
      verbose("Waiting 10 seconds to give Discard Helper time to run.")
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

function IsNeedBait()
  if type(buy_baits)~="number" then
    return false
  else
    if GetItemCount(29714)<buy_baits then
      verbose("Need to buy Ragworm!")
      is_purchase_ragworm = true
    end
    if GetItemCount(29715)<buy_baits then
      verbose("Need to buy Krill!")
      is_purchase_krill = true
    end
    if GetItemCount(29716)<buy_baits then
      verbose("Need to buy Plump Worm!")
      is_purchase_plump = true
    end
    if is_purchase_ragworm or is_purchase_krill or is_purchase_plump then
      return true
    else
      return false
    end
  end
end

function IsNeedRepair()
  if type(do_repair)~="string" then
    return false
  else
    repair_threshold = tonumber(string.gsub(do_repair,"%D",""))
    if not repair_threshold then repair_threshold = 99 end
    if NeedsRepair(tonumber(repair_threshold)) then
      if string.find(string.lower(do_repair),"self") then
        return "self"
      else
        return "npc"
      end
    else
      return false
    end
  end
end

function JobCheck()
  while GetClassJobId()~=18 do
    verbose("Switching to fisher!")
    if not job_change_attempts then
      verbose("Attempt 1: SimpleTweaks")
      yield("/equipjob FSH")
      job_change_attempts = 0
    elseif job_change_attempts==1 then
      verbose("Attempt 2: Fisher")
      yield("/gearset change Fisher")
    elseif job_change_attempts==2 then
      verbose("Attempt 3: FSH")
      yield("/gearset change FSH")
    elseif job_change_attempts==3 then
      verbose("Attempt 4: SimpleTweaks, after enabling EquipJobCommand")
      yield("/tweaks e EquipJobCommand")
      yield("/equipjob FSH")
      job_change_attempts = 0
    else
      verbose("Job change hasn't worked!")
      yield("/pcraft stop")
    end
    job_change_attempts = job_change_attempts + 1
    yield("/wait 1."..job_change_attempts)
  end
  job_change_attempts = nil
  if is_equip_recommended_gear then
    yield("/tweaks e RecommendEquipCommand")
    WaitReady(1)
    yield("/equiprecommended")
  end
end

function verbose(verbose_string, throttle)
  if is_verbose then
    if not throttle or ( throttle and os.date("!*t").sec==0 ) or is_debug then
      yield("/echo [FishingRaid] "..verbose_string)
    else
      yield("/wait 0.005")
    end
  end
end

function TimeCheck(context)
  time_state = false
  if is_last_minute_entry then
    if os.date("!*t").hour%2==0 and os.date("!*t").min<15 then
      if os.date("!*t").min>=11 then
        time_state = "queue"
      elseif os.date("!*t").min>=10 then
        time_state = "movewait"
      end
    end
  elseif os.date("!*t").hour%2==0 then
    if is_last_minute_entry and os.date("!*t").min>10 then
      time_state = "queue"
    elseif os.date("!*t").min<15 then
      time_state = "queue"
    end
  elseif os.date("!*t").hour%2==1 then
    if os.date("!*t").min>=55 then
      time_state = "movewait"
    elseif context and os.date("!*t").min>=45 then
      time_state = "early"
    end
  end
  return time_state
end

function EatFood()
  if type(food_to_eat)=="string" then
    eat_food_tick = 0
    while HasStatus("Well Fed")==false and eat_food_tick<8 do
      verbose("Eating "..food_to_eat)
      yield("/item "..food_to_eat)
      yield("/wait 1")
      eat_food_tick = eat_food_tick + 1
    end
    if eat_food_tick>=8 then food_to_eat = false end
  end
end

correct_bait = baits_list.unset
normal_bait = baits_list.unset
spectral_bait = baits_list.unset
current_bait = baits_list.unset
if type(movement_method)~="string" then movement_method = "" end
if type(is_leveling)=="string" then
  if GetLevel()==90 then
    is_leveling = false
  else
    is_leveling = true
  end
end
if type(score_screen_delay)~="number" then score_screen_delay = 3 end
if score_screen_delay<0 or score_screen_delay>500 then score_screen_delay = 3 end
points_earned = 0

::Start::
if IsAddonVisible("IKDResult") then
  goto FishingResults
elseif IsInZone(900) or IsInZone(1163) then
  verbose("We're on the boat!")
  goto OnBoat
elseif TimeCheck("start") then
  verbose("Starting at or near fishing time.")
  if IsInZone(129) and GetDistanceToPoint(-410,4,76)<6.9 then
    verbose("Near the ocean fishing NPC.")
    if GetCharacterCondition(91) then
      verbose("Already in queue.")
      goto Enter
    elseif IsNeedBait() then
      goto BuyBait
    elseif TimeCheck()=="queue" then
      goto PreQueue
    else
      goto WaitForBoat
    end
  else
    verbose("Not near the ocean fishing NPC.")
    goto ReturnFromWait
  end
elseif IsInZone(129) and GetDistanceToPoint(-411,4,72)<20 then
  if GetCharacterCondition(91) then
    goto Enter
  else
    goto DoneFishing
  end
elseif IsInZone(129) or IsInZone(128) then
  goto WaitLocation
elseif fishing_character~="auto" and fishing_character~=GetCharacterName(true) then
  goto MainWait
else
  goto StartAR
end

::MainWait::
while not TimeCheck(false) do
  if os.date("!*t").hour%2==1 then
    time_remaining = 55 - os.date("!*t").min .." minutes."
  elseif os.date("!*t").min<=55 then
    time_remaining = "1 hour and ".. 55 - os.date("!*t").min .." minutes."
  else
    time_remaining = 115 - os.date("!*t").min .." minutes."
  end
  if is_ar_while_waiting then
    verbose("Still running! AutoRetainer for the next ".. time_remaining, true)
  else
    verbose("Still running! Waiting for the next ".. time_remaining, true)
  end
  yield("/wait 1.001")
end

yield("/ays multi d")
while GetCharacterCondition(50) do
  if IsAddonVisible("RetainerList") then
    verbose("Closing retainer list.")
    yield("/pcall RetainerList true -1")
  end
  yield("/wait 1.004")
end
while GetCharacterName(true)~=fishing_character do
  if IsAddonVisible("TitleConnect") or IsAddonVisible("NowLoading") or IsAddonVisible("CharaSelect") or GetCharacterCondition(53) then
    yield("/wait 1.002")
  elseif GetCharacterCondition(50,false) then
    verbose("Relogging to "..fishing_character)
    yield("/ays relog " .. fishing_character)
    WaitReady(3, true)
  else
    verbose("Waiting for AutoRetainer to finish!")
  end
  yield("/wait 1.003")
end

::ReturnFromWait::
if GetCharacterCondition(45) then
  WaitReady(1)
  goto Start
elseif IsAddonVisible("NowLoading") or GetCharacterCondition(35) then
  WaitReady(1)
end
::TeleportToLimsa::
while not ( IsInZone(177) or IsInZone(128) or IsInZone(129) ) do
  if GetCharacterCondition(27, false) and not IsPlayerOccupied() then
    yield("/tp Limsa")
  else
    WaitReady(2)
  end
  yield("/wait 0.3")
end
if IsInZone(129) and GetDistanceToPoint(-84,19,0)<20 then
  verbose("Limsa aetheryte plaza. Aethernet to arcanists guild.")
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
      if IsMoving() then yield("/generalaction Jump") end
      yield("/lockon on")
      yield("/automove on")
    end
    yield("/wait 0.501")
  end
  WaitReady(3, true)
end
::ExitInn::
if IsInZone(177) then
  verbose("In inn. Leaving.")
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
  verbose("Near inn. Moving to aftcastle.")
  if string.find(string.lower(movement_method),"visland") then
    yield("/visland stop")
    yield("/visland exectemponce H4sIAAAAAAAACuWTyWrDMBCGXyXM2QiNFkvyrXQBH9KNQrrQg2hUIqilYistxeTdqzgKCfQNGp3mnxlGvz40I1zbzkEDbQizFGfWpZXrg0tQwcL+fEYf0gDNywi3cfDJxwDNCI/QcEKlqaVUFTxlZYhEJYWo4BkarIlWRqDaZBmDay+goRXc26Vf52GMZDGPX65zIU2VNiTX27e08Gl1U7qPc8Vj9jSs4ve+ks3kae/2Y3CH9skhVnDZxbS/uE2uK+HZ1FHE3doNqcTbwQvr02HiVl3F/jyGZXk43SUffOfmuY9uqj9YKBFSG6WYPuYiJywMCUdTc3Z6WJAILSUKNlERlCCnivMJi6L5K2ltTo+KIJIaLcoOZSp0e/SOCiesVvoEVwg50UxLdqCyA4IEFar6vwN53fwCXs5zv5QFAAA=")
    yield("/wait 3")
    while IsVislandRouteRunning() or IsMoving() do
      yield("/wait 1.035")
    end
    yield("/visland stop")
  else yield("/pcraft stop")
  end
end
::AethernetToArcanist::
if IsInZone(128) and GetDistanceToPoint(14,40,71)<9 then
  verbose("At aftcastle. Aethernet to arcanists guild.")
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

JobCheck()

::MoveToOcean::
if IsInZone(129) and GetDistanceToPoint(-335,12,53)<9 then
  if IsNeedRepair()=="npc" or IsNeedBait() then
    verbose("At arcanists guild. Moving to Merchant & Mender.")
    if string.find(string.lower(movement_method),"visland") then
      yield("/visland stop")
      yield("/visland exectemponce H4sIAAAAAAAACuWTyWrDMBCGXyXMWRWyFmu5hS6QQ7pRcNPSg0hUIqilYCstJfjdKy8hUPoEjU7zj35+Rh+jA9za2oGBebO2wbdpRmeN21nfAILKfu+iD6kF83qA+9j65GMAc4BnMBeME8yJIAzBCkxRYNWrEsELGC6xZqwQossyBre4yg6qETzajd/nPIoJgmX8dLULCUwWi5BcY9ep8ml71/t/9aY581jtNn4db/I8Oe3dfrTuZB+GLBBc1zG5Y1Ry9VTOB8ckHvauTVPdB1fWp1Nir25icxnDZno7GZtPvnbL7CMd+oOMUljKkg9gBNb5cCVGMBpzwUquzhOMZpjpfkcyGD6A0XrgUgosqCJnui9aY1GoEQsbsdDxI8n8rQg923WRWDEp6ASG9GDEuDBSYUappP8fzFv3A6BUZs+lBQAA")
      yield("/wait 3")
      while IsVislandRouteRunning() or IsMoving() do
        yield("/wait 1.036")
      end
      yield("/visland stop")
    else yield("/pcraft stop")
    end
  else
    verbose("At arcanists guild. Moving to ocean fishing.")
    if string.find(string.lower(movement_method),"visland") then
      yield("/visland stop")
      yield("/visland exectemponce H4sIAAAAAAAACuWSy2oDMQxFfyVoPTX22J6xvAt9QBbpi0L6oAszcRpDxy4Zp6WE/Hsdz4R0kS9ItNKVxLV80AZuTWtBw3jVGO+6OIphFBpr/GjhuqXzH1DAzPx+BedjB/ptA/ehc9EFD3oDz6AvOFekRiYLeAHNGFGilCgKeAUtFEEmsNomFbydXIGmBTyauVsnL0aSmIZv21ofc2fio12ZJs5cXN4N0/9rw65ppW4ZfvadtEtyW5jPzh7G84KsgOs2xP3Dk2jbIR3niUE8rG0Xh3xnPDMuHhx36iasLoOfD/+mffHJtXaa5ui2OEKlkkRgyUXGoghNIaueSk0oq7hSx7GUJ41FYcKCss5YJMEUXPVYkDDGKTtLLFgSKcsBCs080gExUZV4hjgErYmiFfZAeL4SxP5MakFqhVKeOpb37R9ZYl91nAUAAA==")
      yield("/wait 3")
      while IsVislandRouteRunning() or IsMoving() do
        yield("/wait 1.036")
      end
      yield("/visland stop")
    else yield("/pcraft stop")
    end
  end
end

::RepairNPC::
if IsNeedRepair()=="npc" then
  if IsInZone(129) and GetDistanceToPoint(-397,3,80)>5 then MoveNear(-398, 3, 78, 2, 5) end
  while not IsAddonVisible("Repair") do
    if GetTargetName()~="Merchant & Mender" then
      yield("/target Merchant & Mender")
    elseif IsAddonVisible("SelectIconString") then
      yield("/pcall SelectIconString true 1")
    elseif GetCharacterCondition(32, false) then
      yield("/lockon on")
      yield("/pinteract")
    end
    yield("/wait 0.592")
  end
  while IsAddonVisible("Repair") do
    if string.gsub(GetNodeText("Repair",2),"%D","")~="0" then
      if IsAddonVisible("SelectYesno") then
        yield("/pcall SelectYesno true 0")
      else
        yield("/pcall Repair true 0")
      end
    else
      yield("/pcall Repair true -1")
      yield("/lockon off")
    end
    yield("/wait 0.305")
  end
end

::BuyBait::
if IsNeedBait() then
  verbose("Buying more bait.")
  if IsInZone(129) and GetDistanceToPoint(-397,3,80)>5 then MoveNear(-398, 3, 78, 2, 5) end
  while not IsAddonVisible("Shop") do
    if GetTargetName()~="Merchant & Mender" then
      yield("/target Merchant & Mender")
    elseif IsAddonVisible("SelectIconString") then
      yield("/pcall SelectIconString true 0")
    elseif GetCharacterCondition(32, false) then
      yield("/lockon on")
      yield("/pinteract")
    end
    yield("/wait 0.591")
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
elseif IsAddonVisible("Shop") then
  yield("/pcall Shop true -1")
  yield("/lockon off")
  goto BuyBait
end

::BackToOcean::
WaitReady(0.3)
if GetDistanceToPoint(-410,4,76)>6.9 then
  verbose("At Merchant & Mender. Moving to Ocean fishing.")
  if string.find(string.lower(movement_method),"visland") then
    yield("/visland stop")
    yield("/visland exectemponce H4sIAAAAAAAACuVQXUvDQBD8K2Wfz3CJqWnurVSFPtSPIsQqPhztSg+825LbKhLy393UK0XxH/g2MzsMs9PBjfUIBpa4s64dMY1ojTaAgsZ+7sgFjmCeO7ij6NhRANPBI5izUp9nuihLBSswZaYVPIGpRMt1PemFUcD5JZi8qBUs7cbtJacYfAt6R4+BwQiZB8bWrrlxvL0d/L+01E7qxC19HC/SQ9Je7VvEk/1QLldw5YnxGMXoE5weHInc7zFywkNwYx2fEgd2Te2Mwib9rL/FB+dxIT7dq78WGWcXdVGNf04iYJJX/2CSl/4LNp/3pk0CAAA=")
    yield("/wait 3")
    while IsVislandRouteRunning() or IsMoving() do
      yield("/wait 1.036")
    end
    yield("/visland stop")
  else yield("/pcraft stop")
  end
end

::RepairSelf::
if IsNeedRepair()=="self" then
  while not IsAddonVisible("Repair") do
    yield("/generalaction repair")
    yield("/wait 0.5")
  end
  yield("/pcall Repair true 0")
  yield("/wait 0.1")
  if IsAddonVisible("SelectYesno") then
    yield("/pcall SelectYesno true 0")
    yield("/wait 0.1")
  end
  while GetCharacterCondition(39) do yield("/wait 1") end
  yield("/wait 1")
  yield("/pcall Repair true -1")
end

::WaitForBoat::
if TimeCheck()=="queue" then goto PreQueue end
while TimeCheck()~="queue" do
  verbose("Still running! ".. 60 - os.date("!*t").min .." minutes until the next boat.", true)
  yield("/wait 1.005")
end

::BotPause::
notabot = math.random(2,8)
verbose("Randomly waiting "..notabot.." seconds. Soooooooo human.")
yield("/wait "..notabot)

::PreQueue::
boat_route = string.lower(boat_route)
if string.find(boat_route,"random") then
  q = math.random(0,1)
elseif string.find(boat_route,"ruby") or string.find(boat_route,"river") or string.find(boat_route,"kugane") then
  q = 1
else
  q = 0
end

JobCheck()

::Queue::
if IsInZone(129) and GetDistanceToPoint(-410,4,76)<6.9 then
  verbose("Queueing up!")
  if q==1 then
    verbose("Ruby route")
  else
    verbose("Indigo route")
  end
  while GetCharacterCondition(91, false) do
    if GetTargetName()~="Dryskthota" then
      yield("/target Dryskthota")
    elseif GetCharacterCondition(32, false) then
      yield("/lockon on")
      yield("/pinteract")
    elseif IsAddonVisible("Talk") then
      yield("/click talk")
    elseif IsAddonReady("SelectString") then
      if GetSelectStringText(0)=="Register to board." then
        yield("/pcall SelectString true 0")
      else
        yield("/pcall SelectString true "..q)
      end
    elseif IsAddonVisible("SelectYesno") then
      yield("/pcall SelectYesno true 0")
    end
    yield("/wait 0.511")
  end
else
  verbose("Zone: "..GetZoneID())
  if IsInZone(129) then verbose("Distance from Dryskthota: "..GetDistanceToPoint(-410,4,76)) end
  verbose("That's not gonna work, chief.")
  yield("/pcraft stop")
end
yield("/lockon off")

::Enter::
while GetCharacterCondition(91) do
  verbose("Waiting for queue to pop.", true)
  if IsAddonVisible("ContentsFinderConfirm") then
    JobCheck()
    yield("/pcall ContentsFinderConfirm true 8")
  end
  yield("/wait 1.007")
end
WaitReady(3)
if not ( IsInZone(900) or IsInZone(1163) ) then
  verbose("Landed in zone "..GetZoneID()..", which isn't ocean fishing!")
  yield("/pcraft stop")
end

::PrepareRandom::
need_to_move_to_rail = true
move_y = math.random(-11000,5000)/1000
move_z = 6.750
if math.ceil(move_y)%2==1 then
  move_x = 7.5
else
  move_x = -7.5
end
verbose("move_x: "..move_x)
verbose("move_y: "..move_y)

::OnBoat::
start_fishing_attempts = 0
is_changed_zone = true
while ( IsInZone(900) or IsInZone(1163) ) and IsAddonVisible("IKDResult")==false do
  ::AlwaysDo::
  AutoHookPresets()
  current_route = routes[GetCurrentOceanFishingRoute()]
  current_zone = current_route[GetCurrentOceanFishingZone()+1]
  normal_bait = ocean_zones[current_zone].normal_bait
  if GetCurrentOceanFishingTimeOfDay()==1 then spectral_bait = ocean_zones[current_zone].daytime end
  if GetCurrentOceanFishingTimeOfDay()==2 then spectral_bait = ocean_zones[current_zone].sunset end
  if GetCurrentOceanFishingTimeOfDay()==3 then spectral_bait = ocean_zones[current_zone].nighttime end
  if OceanFishingIsSpectralActive() then
    if spectral_bait then correct_bait = spectral_bait end
    if is_recast_on_spectral and not is_already_recast then
      is_already_recast = true
      yield("/ac hook")
    end
  else
    if normal_bait then correct_bait = normal_bait end
    is_already_recast = false
  end
  for _, bait in pairs(baits_list) do
    if GetCurrentBait()==bait.id then current_bait = bait end
  end
  verbose("FishingRoute: "..tostring(GetCurrentOceanFishingRoute()), true)
  verbose("FishingZone:  "..tostring(GetCurrentOceanFishingZone()), true)
  verbose("FishingTime:  "..tostring(GetCurrentOceanFishingTimeOfDay()), true)
  verbose("Zone name: "..ocean_zones[current_zone].name, true)
  verbose("Normal bait: "..normal_bait.name, true)
  verbose("Spectral bait: "..spectral_bait.name, true)
  verbose("Should now be using: "..correct_bait.name, true)
  verbose("Script thinks we're using: "..current_bait.name, true)
  verbose("time: "..string.format("%.1f", GetCurrentOceanFishingZoneTimeLeft()), true)
  EatFood()

  ::Ifs::
  ::Loading::
  if IsAddonVisible("NowLoading") or GetCharacterCondition(35) then
    is_changed_zone = true
    WaitReady(2)

  ::ShouldntNeed::
  elseif IsAddonVisible("IKDResult") then
    break

  elseif wasabi_mode and is_changed_zone then
    if math.floor(GetPlayerRawXPos())~=7 and math.floor(GetPlayerRawXPos())~=-7 then
      need_to_move_to_rail = true
      wasabi_move = true
    end

  ::Movement::
  elseif need_to_move_to_rail then
    while is_wait_to_move and ( GetCurrentOceanFishingZoneTimeLeft()>420 or GetCurrentOceanFishingZoneTimeLeft()<0 ) do
      yield("/wait 0.244")
    end
    if GetPlayerRawXPos()>0 then move_x = 7.5 else move_x = -7.5 end
    if wasabi_move then
      move_y = math.floor(GetPlayerRawZPos()*1000)/1000
      verbose("Resetting move_y to: "..move_y)
    end
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
    yield("/visland moveto "..move_x*2 .." "..move_z.." "..move_y)
    yield("/wait 0.200")
    yield("/visland stop")
    need_to_move_to_rail = false

  ::DoNothing::
  elseif GetCurrentOceanFishingZoneTimeLeft()<30 or GetCurrentOceanFishingZoneTimeLeft()>420 then
    yield("/wait 0.05")

  ::BagCheck::
  elseif GetInventoryFreeSlotCount()<=2 then
    for _, command in pairs(bags_full) do
      if command=="/leaveduty" then LeaveDuty() end
      verbose("Running: "..command)
      yield(command)
    end

  ::BaitSwitch::
  elseif bait_and_switch and ( ( current_bait.id~=correct_bait.id and GetItemCount(correct_bait.id)>1 ) or ( current_bait.id==baits_list.versatile and GetItemCount(correct_bait.id)<1 ) ) then
    if GetItemCount(correct_bait.id)>1 and current_bait.id~=correct_bait.id then
      yield("/tweaks e baitcommand")
      verbose("Switching bait to: "..correct_bait.name)
      bait_switch_failsafe = 0
      while GetCurrentBait()~=correct_bait.id and GetCurrentOceanFishingZoneTimeLeft()>30 and GetCurrentOceanFishingZoneTimeLeft()<420 do
        yield("/bait "..correct_bait.name)
        yield("/wait 0.1014")
        if bait_switch_failsafe > 13 then
          for i=1,20 do
            verbose("Bait switch didn't work! Please report this.")
          end
          break
        elseif is_fishing_animation_noticed then
          if GetCharacterCondition(42, false) then
            is_fishing_animation_noticed = false
            bait_switch_failsafe = bait_switch_failsafe + 1
          end
        elseif GetCharacterCondition(42) then
          is_fishing_animation_noticed = true
        end
      end
    else
      verbose("Out of "..correct_bait.name)
      yield("/bait Versatile Lure")
    end
    current_bait = correct_bait
    is_changed_bait = true
    SetAutoHookState(true)

  ::StartFishing::
  elseif --[[ GetCurrentOceanFishingZoneTimeLeft()>30 and ]] GetCharacterCondition(43, false) then
    if not is_changed_bait and not is_changed_zone then
      not_fishing_tick = 0
      while GetCharacterCondition(43, false) and not_fishing_tick<1.5 do
        yield("/wait 0.108")
        not_fishing_tick = not_fishing_tick + 0.1
      end
    end
    is_changed_bait = false
    is_changed_zone = false
    if start_fishing_attempts>9 then
      yield("/echo [FishingRaid] Something has gone horribly wrong!")
      LeaveDuty()
      WaitReady(1,true)
      yield("/ays multi e")
      yield("/pcraft stop")
    elseif start_fishing_attempts>6 then
      if math.floor(GetPlayerRawXPos())~=7 and math.floor(GetPlayerRawXPos())~=-7 then
        verbose("Not standing at the side of the boat? Lets fix that.")
        need_to_move_to_rail = true
        wasabi_move = true
      end
    elseif start_fishing_attempts>1 then
      current_bait = ""
    elseif GetCharacterCondition(43, false) then
      start_fishing_attempts = start_fishing_attempts + 1
      verbose("Starting fishing from: X: ".. math.floor(GetPlayerRawXPos()*1000)/1000 .." Y or Z, depending on which plugin you ask: ".. math.floor(GetPlayerRawZPos()*1000)/1000 )
      verbose("Should now be using: "..correct_bait.name)
      verbose("Script thinks we're using: "..current_bait.name)
      yield("/ac Cast")
      SetAutoHookState(true)
    end

  else
    SetAutoHookState(true)
    start_fishing_attempts = 0
  end
  yield("/wait 1.010")
end

::FishingResults::
score_screen_wait = 500-(((score_screen_delay//60)*100)+(score_screen_delay%60)+40)
if IsAddonVisible("IKDResult") then
  result_timer = 501
  while IsAddonVisible("IKDResult") do
    result_raw = string.gsub(GetNodeText("IKDResult",4),"%D","")
    result_timer = tonumber(result_raw)
    if type(result_timer)~="number" then result_timer = 501 end
    if result_timer<=(score_screen_wait) then
      points_earned_string = ""
      for i=9, 1, -1 do
        if type(GetNodeText("IKDResult",27,i))=="string" then
          points_earned_string = GetNodeText("IKDResult",27,i)..points_earned_string
        end
      end
      points_earned = tonumber(points_earned_string)
      yield("/pcall IKDResult true 0")
      yield("/wait 1")
    end
    yield("/wait 0.266")
  end
  verbose("Points earned: "..points_earned)
end

::DoneFishing::
RunDiscard(1)
DeleteAllAutoHookAnonymousPresets()
WaitReady(3, false, 72)
if IsInZone(129) then
  yield("/echo Landed at: X:"..math.floor(GetPlayerRawXPos()*1000)/1000 .." Z:"..math.floor(GetPlayerRawYPos()*1000)/1000 .." Y:"..math.floor(GetPlayerRawZPos()*1000)/1000)
else
  goto AtWaitLocation
end

::SpendScrips::
if type(spend_scrips_when_above)=="number" then
  if GetItemCount(25200)>spend_scrips_when_above then
    verbose("Spending scrips on "..scrip_item_to_buy)
    while IsInZone(129) and GetDistanceToPoint(-407,3.1,67.5)>6.9 do
      if IsMoving() then while IsMoving() do yield("/wait 0.1") end
      elseif GetDistanceToPoint(-410,4,76)<6.9 then  --ocean
        yield("/visland moveto -407 4 71")
      elseif GetDistanceToPoint(-408.5,3.1,56)<6.9 or GetDistanceToPoint(-396,4.3,69)<6.9 or GetDistanceToPoint(-398,3.1,75.5)<6.9 then
        yield("/visland moveto -404 4 71")  --boardwalk
      end
      yield("/wait 0.1")
    end
    yield("/visland stop")
    while IsAddonReady("InclusionShop")==false do
      if GetTargetName()~="Scrip Exchange" then
        yield("/target Scrip Exchange")
      elseif IsAddonVisible("SelectIconString") then
        yield("/pcall SelectIconString true 0")
        yield("/visland stop")
      else
        yield("/lockon on")
        yield("/facetarget")
        yield("/pinteract")
      end
      yield("/wait 0.521")
    end
    yield("/lockon off")
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
end

::WaitLocation::
if type(wait_location)=="string" then
  if string.find(string.lower(wait_location),"inn") then
    verbose("Returning to inn.")
    RunDiscard(2)
    ::MoveToArcanist::
    if IsInZone(129) and GetDistanceToPoint(-408,4,75)<20 then
      verbose("Near ocean fishing. Moving to arcanists guild.")
      if string.find(string.lower(movement_method),"visland") then
        yield("/visland stop")
        yield("/visland exectemponce H4sIAAAAAAAACuWUy0pDMRCGX6XM+hhyv5ydeIEualWEesFFaFMb8CTSkypS+u4m8ZR24RPYrDLz/0wmH8Ns4cZ2DlqYzp0No6XvVz68jVIc2fXcBt8naGBmvz+iD6mH9mULt7H3yccA7RYeoT1jhiAtjWrgCVqBcAPP0EqBBKeC7nIUgxtfQpuFe7vwm1yFFtckfrrOhVSVcUhubedp5tNqOriPc0OXuZl+Fb/2Su4iV1va994d7LU10sBVF9P+4XFy3XA9r44huNu4Pg33UnhmfTpULNF1XF/EsBh+jH+TD75zk+zDu+YPHtogJhkbeJh8KFeVCtdZ4YbzU8QiDCJYY1m5aITL4XssQhqhT5IKQ4zxMh+ZiqrTolmlkhVsuNIniYXjvFOo5BULIYULF79YKFKYSaKOsBBqTgUMU4hLqo7BkLJrChmOtJGG/H8wr7sfPGs0+LgGAAA=")
        yield("/wait 3")
        while IsVislandRouteRunning() or IsMoving() do
          yield("/wait 1.031")
        end
        yield("/visland stop")
      else yield("/pcraft stop")
      end
    end
    ::AethernetToAftcastle::
    if IsInZone(129) and GetDistanceToPoint(-335,12,53)<9 then
      verbose("At arcanists guild. Aethernet to aftcastle.")
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
    RunDiscard(3)
    ::MoveToInn::
    if IsInZone(128) and GetDistanceToPoint(14,40,71)<9 then
      verbose("Near aftcastle. Moving to inn.")
      if string.find(string.lower(movement_method),"visland") then
        yield("/visland stop")
        yield("/visland exectemponce H4sIAAAAAAAACuWT22rDMAyGX6XoOjNyYseHu7ID9KI7Mei6sYuwetSw2CNxN0bou09JU1rYnmDVlX5JyNKH3MF1VTuwMHVp7Zrg0iTFiQ8BMlhU3x/Rh9SCfe7gNrY++RjAdvAIliNTyCWKDJZgBTLsjdQTWCWYQNRiSyoGN7sAixncVyu/oV45IzGPn652IQ2ZWUiuqV7Twqf1zVh9HBtHpJHadfzaZ2gW6vZWvbfuUD4MyDO4rGPaPzxLrh7d6VAxiruNa9Po940XlU+Hjr26is15DKtxb9wFH3zt5lSH2+w3FcKgi7LM/6LCmVJSmdOjcoaMK11oLsqBS2GY6a0cuIiCFWgwl6cHhnYzXJpc77FIThcyUOGKqOTmFKnwgnGt6RsdH4uWOyw505Jj+e9/0cv2ByD0KqubBQAA")
        yield("/wait 3")
        while IsVislandRouteRunning() or IsMoving() do
          yield("/wait 1.032")
        end
        yield("/visland stop")
      end
    end
    ::EnterInn::
    while IsInZone(128) do
      verbose("Near inn. Entering.")
      if GetDistanceToPoint(13,40,13)<4 then
        if GetTargetName()~="Mytesyn" then
          yield("/target Mytesyn")
        elseif GetCharacterCondition(32, false) then
          yield("/lockon on")
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
    WaitReady(3, true, 32, 177)
  elseif string.find(string.lower(wait_location),"fc")
  or string.find(string.lower(wait_location),"private")
  or string.find(string.lower(wait_location),"personal")
  or string.find(string.lower(wait_location),"apartment")
  or string.find(string.lower(wait_location),"shared")
  then
    if string.find(string.lower(wait_location),"fc") then
      verbose_string = "FC house"
      tp_location = "Estate Hall (Free Company)"
    elseif string.find(string.lower(wait_location),"private") or string.find(string.lower(wait_location),"personal") then
      verbose_string = "private house"
      tp_location = "Estate Hall (Private)"
    elseif string.find(string.lower(wait_location),"apartment") then
      verbose_string = "apartment"
      tp_location = "Apartment"
    elseif string.find(string.lower(wait_location),"shared") then
      verbose_string = "shared estate"
      if string.find(string.lower(wait_location), "Shared Estate (Plot ") then
        tp_location = wait_location
      else
        tp_location = "Shared Estate "
      end
    end
    verbose("Returning to "..verbose_string..".")
    while not ( IsInZone(339) or IsInZone(340) or IsInZone(341) or IsInZone(641) or IsInZone(979) ) do
      if GetCharacterCondition(27, false) and not IsPlayerOccupied() then
        yield("/tp "..tp_location)
      else
        WaitReady()
      end
      yield("/wait 0.31")
      RunDiscard(2)
    end
    verbose("Arrived at "..verbose_string..". Entering.")
    yield("/automove on")
    yield("/wait 1.033")
    yield("/automove off")
    yield("/ays het")
    WaitReady(3, true)
    verbose("Inside "..verbose_string.." (hopefully)")
  end
end

WaitReady()

::AtWaitLocation::
::Desynth::
if is_desynth then
  yield("/tweaks e UiAdjustments@ExtendedDesynthesisWindow")
  verbose("Running desynthesis.")
  is_doing_desynth = true
  failed_click_tick = 0
  open_desynth_attempts = 0
  desynth_last_item = nil
  desynth_prev_item = nil
  item_name = nil
  yield("/wait 0.1")
  while is_doing_desynth do
    verbose("Desynth is running...", true)
    if not IsAddonVisible("SalvageItemSelector") then
      verbose("Opening desynth window")
      yield("/generalaction desynthesis")
      open_desynth_attempts = open_desynth_attempts + 1
      if open_desynth_attempts>5 then
        is_doing_desynth = false
        is_desynth = false
        desynth_last_item = nil
        desynth_prev_item = nil
        item_name = nil
        verbose("Tried too many times to open desynth, and it hasn't worked. Giving up and moving on.")
      end
    elseif desynth_prev_item~=nil and item_name and desynth_last_item==item_name and desynth_prev_item==item_name then
      verbose("Repeat item bug?")
      verbose("Closing desynth window")
      yield("/pcall SalvageItemSelector true -1")
      yield("/wait 1")
    elseif not IsAddonReady("SalvageItemSelector") then
      yield("/wait 0.541")
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
        verbose("Desynth failed!")
        verbose("Closing desynth window")
        yield("/pcall SalvageItemSelector true -1")
        yield("/wait 1")
      end
    elseif GetCharacterCondition(39, false) then
      for i=1,20 do
        if string.gsub(GetNodeText("SalvageItemSelector", 3, 2, 8),"%W","")~="" then
          break
        else
          yield("/wait 0.09")
        end
      end
      for list=2, 16 do
        item_name_raw = string.gsub(GetNodeText("SalvageItemSelector", 3, list, 8),"%W","")
        item_name = string.sub(item_name_raw, 3,-3)
        if string.sub(GetNodeText("SalvageItemSelector", 3, 2, 2),-1,-1)==")" then
          item_level_raw = string.sub(GetNodeText("SalvageItemSelector", 3, list, 2),1,3)
        else
          item_level_raw = string.sub(GetNodeText("SalvageItemSelector", 3, list, 2),-3,-1)
          item_level_raw = string.gsub(item_level_raw,"%d+/","")
        end
        item_level = string.gsub(item_level_raw,"%D","")
        item_type = GetNodeText("SalvageItemSelector", 3, list, 5)
        if item_level=="1" and item_type=="Culinarian" then
          verbose("Desynthing: "..item_name)
          verbose("item_level: "..item_level, true)
          verbose("item_type: "..item_type, true)
          yield("/pcall SalvageItemSelector true 12 "..list-2)
          desynth_prev_item = desynth_last_item
          desynth_last_item = item_name
          is_clicked_desynth = true
          break
        elseif list==16 then
          is_doing_desynth = false
          verbose("Desynth finished!")
          break
        end
      end
    end
    yield("/wait 0.540")
  end
  yield("/pcall SalvageItemSelector true -1")
end

::WrapUp::
RunDiscard()
verbose("You did a good job today!")
verbose("Points earned: "..points_earned)

::StartAR::
if not is_single_run then
  if fishing_character=="auto" then fishing_character = GetCharacterName(true) end
  if is_ar_while_waiting then
    verbose("Enabling AutoRetainer while waiting.")
    if ARRetainersWaitingToBeProcessed() then
      target_tick = 1
      while GetCharacterCondition(50, false) do
        if target_tick > 99 then
          break
        elseif string.lower(GetTargetName())~="summoning bell" then
          verbose("Finding summoning bell...")
          yield("/target Summoning Bell")
          target_tick = target_tick + 1
        elseif GetDistanceToTarget()>5 then
          yield("/lockon on")
          yield("/automove on")
        else
          yield("/automove off")
          yield("/pinteract")
        end
        yield("/lockon on")
        yield("/wait 0.511")
      end
      if GetCharacterCondition(50) then
        yield("/lockon off")
        yield("/ays e")
        while not IsAddonVisible("RetainerList") do yield("/wait 0.100") end
        yield("/wait 0.4")
      end
    end
    yield("/ays multi e")
  else
    verbose("Waiting for the next boat.")
  end
  goto MainWait
end
