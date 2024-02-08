--[[

  Automatic ocean fishing script. Options for AutoRetainer and returning to inn room between trips.

    Script runs using:
      SomethingNeedDoing (Expanded Edition): https://puni.sh/api/repository/croizat
    Required plugins:
      Autohook: https://raw.githubusercontent.com/InitialDet/MyDalamudPlugins/main/pluginmaster.json
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

is_ar_while_waiting = false  --AutoRetainer multimode enabled in between fishing trips.
wait_location = false  --Can be false, "inn", or "fc"
fishing_character = "auto"  --"auto" requires starting the script while on your fishing character.
is_wait_to_move = true  --Wait for the barrier to drop before moving to the side of the boat.
is_adjust_z = true  --true might cause stuttery movement, false might cause infinite movement. Good luck.
is_discard = false  --Requires Discard Helper. Can set to "spam" to run during cutscenes.
is_desynth = true  --Runs faster with YesAlready, but this isn't required.'
bait_and_switch = true  --Uses /bait command from SimpleTweaks
force_autohook_presets = true
movement_method = "visland route" --"visland route", "visland random"
buy_baits = false  --Minimum number of baits you want. Will buy 99 at a time.
boat_route = "indigo"  --"indigo", "ruby", "random"

is_spend_scrips = false
scrip_category = 1
scrip_subcategory = 6
scrip_item_to_buy = "Regional Folklore Trader's Token C"

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
      DeleteAllAutoHookAnonymousPresets()
      autohook_preset_loaded = false
    end
    if OceanFishingIsSpectralActive() then
      if GetMaxGp()>700 then
        UseAutoHookAnonymousPreset("AH3_H4sIAAAAAAAACu1YQXPaOhD+Kxpf3oV2ICGkyY0HtGEeJJngvhwymY5iC6zBWIwkJ6FM/ntXliVsYxxS6Km+MbufVvvtaj/JrJ1uLFkPCyl605lzuXYGEX4KSTcMnUvJY9Jw+iySPRx5JBwz5gXGrNaMaEQ2a3zj+rZ0A05EwEIwNXdGuCLh0iWv0rl0nIZzjRcQK0kHqdgoCd5whhDj5MtFLmr3iT2TTX5E5KJPcSjA3vUkZZG7WgKy9aYTThFrJ/lx8l7ureYHs/8uCEpQaDg0uXe+HJ77TRSuEsQwkjFVPgs9du01LM394vw4de8F8UIV+0csyH1AIktj8OoR4oskVcskDfQ7rdBegXox5ySSlk3KMMlDc2u3mu0PkNPmUm6M+xTDuKydYfRMuDHccso4las/0Smzp6bSabVbh/XpJOXylYpgsCIiNxhl7Tg7O0Y71HYo2c/25OwoPRnjOZkEdCr/xVQm8w4GYQwTib05cIS9qknuQ9ENqEALOgsk8lg0Dakn0QuVAUqmyQ1wSPH8H4G+4mfGN9RthihJ0WrFhwpQMXG3WFIC0E0nbQk2ruLBLC1C5xidtnvaRneO0mgYsp+kh6VW9e9aXbRSDm+iXt9yApcS0XvozNCHBKmHQxWgDKA2eiaTEC/3K9HJAdr0GZnSIBz5yDYpORZwkMIQRUyiJ4JAOn30AvRQQholrBFOcs0UeuPLHKrjFDs9zEIfZah3zmCm6rSRt98RD7YDfEtpRpUInh4+b1tjlZZlew5NadqHzhsUZ/AqOc69nyzByQteqlTsjfcN083lrTwuU5iCf20SH/hUjs3YfFKd2Io4YpljXBJR+9+JeAsFIDuy1L7SPJ1PTun6XE6l6zXCrk90eUk8KGSYDsiOSpWi9qhXYd2OqpWi9qpdVfbZCpTiCnUszUIfqIpQaUkf1LVKo9kdpv4jumZ8AS+FN7MyZZIHmUCQxIgKeTNVBYFZftg6z8qhlmaK8j/hAjQsJGgUc/tkvzhvncOmV4zN7wmeF8IY8+YhWO7vX7lXRe01vkSuQQ9L5LoIub5xd6DUFCukupPOL/K2zGN745xIzqJZSbraUUVII3KUis53OOVB1aw0NrlrT4vWHDPjHpEZiXzMVyXZWV8VPwvaQdH632G5hasmauFFrttJGwRc9r1YSLawHrUm+xbosxjSL1pdTpfGqnkpKLDdelOldsVg53vDACYxn2IvT25E9GNceFhdM6l1jF9duiB9EmJg2/wMF+qYRkWTYgcfOsrMs0uNsbC8zDyRbNmdSsJ7OIar1kYp2Ed0od7XLe1IJWUiCfBovjX2EY87PHsBhcqoRrtWjVo1atWoVaNCNf7j8GGU0YyzWjNqzag1o9aMCs24DePFEt3nHxudWjhq4aiF428Vjkfzf0f6B9+DNWjxeHh8+wU+cPL/Ih0AAA==")
      else
        UseAutoHookAnonymousPreset("AH3_H4sIAAAAAAAACu1YTXPiOBD9Kypf9kKmICFkkhsLTEItJFTwbA6p1JRiC6xCWJQkh7BU/vtKliV/YBwysKf1jep+avXrVj/JbJ1uJGgPcsF7s7lzs3UGIXwlqEuIcyNYhBpOn4aiB0MPkTGlXmDMas0Ihyhd4xvX7coNGOIBJdLU3BvhDpGVi96Fc+M4DeceLmWsOB2gYoM4eMMZyhjn369zUbuv9A2l+SGeiz6DhEt71xOYhu5mJZGtD51wgtg68Y/zz3JvNb+Y/U+OQIwCw6HJvfP9+NwfQrKJEcNQRFj5LPTUtdewJPfrq9PUvRdES1XsXxFHTwEKLY3Bu4eQz+NULZMk0O+0Qns56EWMoVBYNgnDOA/Nrd1qtr9ATptLuVHmYyjHZesMwzfEjGHCMGVYbP6LTpk9NZVOq906rk/nCZcfmAeDDeK5wShrx+XlKdqhtgPxfrYnlyfpyRgu0DTAM/EnxCKed2ngxjAV0FtIjnKvapKHUHQDzMESzwMBPBrOCPYEWGMRgHia3AASDBd/cPADvlGWUrcZgjhFqxVfKkDFxE2gwEhC007aEqSu4sEsLULnFJ22e9pGd07SaDlk/6AeFFrVf2p10Uo5fAh7fctJupSIPsnODH2ZIPYgUQHKAGqjNzQlcHVYic6P0KZvwJQGwNAHtknxsZAHiRAQUgFeEZDS6YO1pAdi0iBmDWCca6bQqS9zqE5T7OQwc32UZb1zBjNVF428/RF5cjuJbynNqBLBi+PnbWeskrLszqEpTfvYeZPFGbwLBnPvJ0twuoYrlYq98W4hTi9v5XGpwhT8W5P4wMdibMbmTHViJ+KIZo5xSUTt/yTiRBYA7clS+0rzdM6c0vW5nErXa4RdH+vyCnmykCQZkD2VKkUdUK/Cuj1VK0UdVLuq7LMVKMUV6liahT5QFaGSkj6raxWH80eI/RdwT9kSEnAGRnQNbifOhwmRUMqjTcQU33BGmIuHmSqRnO7nnROuHCpGpkx/I8alqhEERhGzj/jrq9aV3P2O0sUTgotCGGNOn4bl/v6de1dUY+OLBVwqZImAFyH3D+4elJprhVS31NV13pZ5fqfOqWA0nJekqx1VhDQiR6no/IRTHlTNSmPj2/eiaM0xM+4RmqPQh2xTkp31VfGzoD0Urf8Tlju4aqIWXuS6m7RByOu/F3FBl9aj1mRfB30ayfS1VTOQRpfhlTFmoJLtzisrsSsGe18gBjCN2Ax6eXIjpJ/n3IPq4kmsY/ju4iXqIwIl2+Y3ecWOcVg0KXby00eZWXapMRaWl5mngq66M4FYD0by8rVRCvYRXqoXd0s7Em2ZCiR5ND8ah4jHI5yvpWZlVKNdq0atGrVq1KpRoRp/MfmplNGMy1ozas2oNaPWjArNmJBouQJP+cdGpxaOWjhq4fi/CseL+b8j+cvv2Rq0eDy/fPwLPjSdUjQdAAA=")
      end
      autohook_preset_loaded = "spectral"
    else
      if GetMaxGp()>700 then
        UseAutoHookAnonymousPreset("AH3_H4sIAAAAAAAACu1YUW/iOBD+K1Ze7qW7gi7Qbd84YLfooK1K9vpQVSs3GGIRYmQ7bTnU/35jOzZJCCkVvG3e0Mzn8Xwzns8OG6+bSNbDQorebO5dbbxBjJ8j0o0i70ryhJx5fRbLHo4DEo0ZC0JrVmtGNCbbNVPr+rnyQ05EyCIwNfZGuCbRyidv0rvyvDPvBi8hlk4HqdhIBz/zhhDj/PtlLmr3mb2QbX5E5KLPcCTA3g0kZbG/XgGy+W4SThEbT/84z+WeLssl32x8Mv1fgiCNQsOhTb7z/fjkb+NorRHDWCZU+Rz01MU3sDT3y4vTFL4XJktV7d+JIA8hiR2NwVtAyFToVE/RCuMVqJdwTmLp2KQMdR6GW6vZaH2CnDGXcmN8SjHMy8Ybxi+EW8Mdp4xTud7tVBm/T7bKbmq4dJqt5nGNOk/J/KAiHKyJ+HA02u1T9ENth/R+rintkzRljBdkEtKZ/BtTqSceDMIaJhIHC+AIe1WTPISiH1KBlnQeShSweBbRQKJXKkOkx8kPcUTx4i+BfuAXxrfUXYZIp+jE4lMFqBi5OywpAei2k64EW9chJ7PdOUWn3Z6u0Z2TNBqm7D/Sw9Lo+i8jL0Yqh7dxr+84gUup6AN0ZjiFBGmAIxWgDKA2eiGTCK8OK9H5EeL0FdnSIBxPkWuSPhZwkKIIxUyiZ4JAO6foFeghTRpp1gjrXDOF3voyh+o0xU4PszBHGeqdM9ipakIxco57EsB+sKCpRKPqwvp2/MDtzFVal91BtLVpHTtwUJ3Bm+Q494RyBCeveKVScXfeT0y317fy+ExhCv6NTXwwpXJs5+aLasVOxBHLnOOSiMb/QcQ7KADZk6XxlebpffFK1+dyKl1vEG69FuYVCaCQUToheypVijqgXoV1e6pWijqodqV5mUOQLUApzHtUdyGN5/eYTp+QxeRqW5V/xQauzu8WlnLJb3nD+FJvOKJC3s5UQWCYH3fOs3KohZmi/Eu4ABGLCBol3L3aLy+aF7DlNWOLB4IXhTDWvH0Klvv71/51UXytT+s1CGKJXhchN7f+HpSaYoVUl9LFZd6WeW5vnRPJWTwvSdc4qggZxD5KxvsBqTyompbB6tv2W9Gao2bdIzIn8RTzdUnuzldF0IFyHEv8H7DcwVUTdfAi192kLQKu+14iJFs6j1qTfQ30WQLpF60+pytrNbwUFNjuvKpSu2Kw98VhAZOEz3CQJzci5jkuAqzumdQ6xm8+XZI+iTCwbXyFG3VM46JJsYNvHWXm2aXWWFheZp5IturOJOE9nMBd66IU7CO6VC/spnGkijKRBHg03s8OUY97PH8F7cnIRquWjVo2atmoZaNKNv7h8G2UEY12LRq1aNSiUYtGlWjcRclyhR7yz41OrRy1ctTK8ccqx5P9zyP9k+/RGYx6PD69/w+iobgTKR0AAA==")
      else
        UseAutoHookAnonymousPreset("AH3_H4sIAAAAAAAACu1YQW/iOhD+K1Yu79KuoAt02xsP2BY9aFFJXw9VtXKDIRYhRrZTyqL+9x3HsUlCSKngtrmhmc/j+WY8nx02TjuSrIOFFJ3pzLneOL0QvwakHQTOteQROXO6LJQdHHokGDLm+cas1gxoSLZrJsZ1s3R9ToTPAjDV9ka4JcHSJe/SuXacM+cOLyBWnA5SsVEc/MzpQ4yLH1eZqO1X9ka2+RGRiT7FgQB725OUhe56Ccj6h044QWyc+MdFJvdkWSb5eu2L6T8KgmIU6vdN8q0fxyd/HwbrGNEPZUSVz0JPXXwNS3K/ujxN4Tt+tFDV/hUJ8uST0NLovXuETESc6ilaob0CdSLOSSgtm4RhnIfm1qjXGl8gp82F3BifUAzzsnH64RvhxjDilHEq17udKuL3xVaZTTWXVr1RP65RFwmZn1T4vTURn45Gs3mKfqjtULyfbUrzJE0Z4jkZ+3Qq/8VUxhMPBmEMY4m9OXCEvcpJHkLR9alACzrzJfJYOA2oJ9GKSh/F4+T6OKB4/o9AP/Eb41vqNkMUp2jF4ksFKBm5EZaUAHTbSVuCreuQk9lsnaLTdk/b6NZJGg1T9pt0sNS6/qjlRUtl/z7sdC0ncCkVfYLO9CeQIPVwoAIUAdRGb2Qc4OVhJbo4Qpy+IVMahMMJsk2KjwUcpCBAIZPolSDQzglaAT0Uk0Yxa4TjXFOF3vpSh+o0xU4Os9BHGeqdMZipqkMxMo4H4sF+sKCuRKPswvp+/MDtzFVSl91BNLVpHDtwUJ3eu+Q484SyBMcrvFSp2DvvBtPt9a08LlOYnH9jEu9NqByauTlXrdiJOGCpc1wQUfs/iTiCApA9WWpfYZ7OuVO4PpNT4XqNsOtjYV4SDwoZJBOyp1KFqAPqlVu3p2qFqINqV5iXPgTpAhTCnGd1F9Jw9oDp5AUZDDpHA7ZCN6NMkcuIlOxkC/5hYAmp7N53jC+yOw+okPdTVSIY7+edE64cKkKqTP8TLkDWAoIGEbfv+KvL+iXsfcvY/IngeS6MMW8fh8X+7q17m5dj44sVHCSyQMHzkLt7dw9KzbVCqmvq8iprSz3At86x5CycFaSrHWWENGIfJe39hFQWVE5LY+P793vemqFm3AMyI+EE83VB7tZXRtCCMhwL/J+w3MGVE7XwPNfdpA0CHgCdSEi2sB61Jv0+6LII0tdWzQCMLqdLY0xBge3OOyuxKwZ73yAGMI74FHtZcgOiH+jCw+rmSaxD/O7SBemSAAPb2je4Y4c0zJsUO/j6UWaeXmqMueVF5rFky/ZUEt7BEdy+NkrOPqAL9eaua0ciLWNJgEft4+wQ9XjAsxWIUEo2GpVsVLJRyUYlG2Wy8R+Hr6WUaDQr0ahEoxKNSjTKRGMURIsleso+N1qVclTKUSnHX6scL+Y/j+Rvv2dr0Orx/PLxB1dtN3E7HQAA")
      end
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
    if is_discard=="spam" then yield("/discardall") end
  end
end

function RunDiscard(y)
  if is_discard then
    if is_desynth and y then
      debug("You have desynth and discard turned on.")
      debug("Waiting to discard until after desynth!")
    elseif y then
      discarded_on_1 = os.time()+10
      yield("/discardall")
    elseif discarded_on_1 then
      yield("/discardall")
      if os.time()<=discarded_on_1 then yield("/wait "..discarded_on_1-os.time()) end
    else
      yield("/discardall")
      debug("Waiting 10 seconds to give Discard Helper time to run.")
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

function HaveEnoughBait()
  if type(buy_baits)~="number" then
    return true
  else
    if GetItemCount(29714)<buy_baits then
      debug("Need to buy Ragworm!")
      is_purchase_ragworm = true
    end
    if GetItemCount(29715)<buy_baits then
      debug("Need to buy Krill!")
      is_purchase_krill = true
    end
    if GetItemCount(29716)<buy_baits then
      debug("Need to buy Plump Worm!")
      is_purchase_plump = true
    end
    if is_purchase_ragworm or is_purchase_krill or is_purchase_plump then
      return false
    else
      return true
    end
  end
end

function debug(debug_string, throttle)
  if is_debug then
    if throttle and os.date("!*t").min~=0 then
      yield("/wait 0.005")
    else
      yield("/echo [FishingRaid] "..debug_string)
    end
  end
end

::Start::
if IsInZone(900) or IsInZone(1163) then
  debug("We're on the boat!")
  goto OnBoat
elseif (os.date("!*t").hour%2==1 and os.date("!*t").min>=45) or (os.date("!*t").hour%2==0 and os.date("!*t").min<15) then
  debug("Starting at or near fishing time.")
  if IsInZone(129) and GetDistanceToPoint(-410,4,76)<6.9 then
    debug("Near the ocean fishing NPC.")
    if GetCharacterCondition(91) then
      goto Enter
    elseif not HaveEnoughBait() then
      goto BuyBait
    elseif os.date("!*t").hour%2==0 and os.date("!*t").min<15 then
      goto PreQueue
    elseif os.date("!*t").hour%2==1 and os.date("!*t").min>=45 then
      goto WaitForBoat
    end
  else
    debug("Not near the ocean fishing NPC.")
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
    debug("Still running! AutoRetainer until 5 minutes before the boat.", true)
    yield("/wait 1.001")
  end
  yield("/ays multi")
  while GetCharacterName(true)~=fishing_character do
    if IsAddonVisible("TitleConnect") or IsAddonVisible("NowLoading") or IsAddonVisible("CharaSelect") or GetCharacterCondition(53) then
      yield("/wait 1.002")
    elseif GetCharacterCondition(50,false) then
      debug("Relogging to "..fishing_character)
      yield("/ays relog " .. fishing_character)
    elseif IsAddonVisible("RetainerList") then
      debug("Closing retainer list.")
      yield("/pcall RetainerList true -1")
    else
      debug("Waiting for AutoRetainer to finish!")
    end
    yield("/wait 1.003")
  end
end

::ReturnFromWait::
WaitReady()
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
  debug("Limsa aetheryte plaza. Aethernet to arcanists guild.")
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
  debug("In inn. Leaving.")
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
  debug("Near inn. Moving to aftcastle.")
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
  debug("At aftcastle. Aethernet to arcanists guild.")
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
  debug("At arcanists guild. Moving to ocean fishing.")
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
  if not HaveEnoughBait() then
    debug("Buying more bait.")
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
  if GetDistanceToPoint(-410,4,76)>6.9 then
    MoveNear(-404, 4, 73, 1, 2)
    MoveNear(-408, 4, 73.5, 2.2, 5)
  end
end

::WaitForBoat::
while not ( os.date("!*t").hour%2==0 and os.date("!*t").min<15 ) do
  debug("Still running! Waiting for the boat.", true)
  yield("/wait 1.005")
end

::BotPause::
notabot = math.random(3,10)
debug("Randomly waiting "..notabot.." seconds. Soooooooo human.")
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

::Queue::
if IsInZone(129) and GetDistanceToPoint(-410,4,76)<6.9 then
  debug("Queueing up!")
  while GetCharacterCondition(91, false) do
    if GetTargetName()~="Dryskthota" then
      yield("/target Dryskthota")
    elseif GetCharacterCondition(32, false) then
      yield("/pinteract")
    elseif IsAddonVisible("Talk") then
      yield("/click talk")
    elseif IsAddonVisible("SelectString") then
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
  debug("Zone: "..GetZoneID())
  if IsInZone(129) then debug("Distance from Dryskthota: "..GetDistanceToPoint(-410,4,76)) end
  debug("That's not gonna work, chief.")
  yield("/pcraft stop")
end

::Enter::
while IsInZone(129) do
  debug("Waiting for queue to pop.", true)
  if IsAddonVisible("ContentsFinderConfirm") then yield("/pcall ContentsFinderConfirm true 8") end
  yield("/wait 1.007")
end
WaitReady(3)

::PrepareRandom::
movement = true
move_y = math.random(-11000,5000)/1000
move_z = 6.750
if math.ceil(move_y)%2==1 then
  move_x = 7.5
else
  move_x = -7.5
end
debug("move_x: "..move_x)
debug("move_y: "..move_y)

::OnBoat::
results_tick = 0
debug_tick = 0
start_fishing_attempts = 0
while IsInZone(900) or IsInZone(1163) do
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
  debug("FishingRoute: "..tostring(GetCurrentOceanFishingRoute()), true)
  debug("FishingZone:  "..tostring(GetCurrentOceanFishingZone()), true)
  debug("FishingTime:  "..tostring(GetCurrentOceanFishingTimeOfDay()), true)
  debug("Zone name: "..baits[current_zone].name, true)
  debug("Normal bait: "..normal_bait, true)
  debug("Spectral bait: "..spectral_bait, true)
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
      debug("Running: "..command)
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
    debug("Switching bait to: "..correct_bait)
    if GetCharacterCondition(43) then
      while GetCharacterCondition(42, false) do yield("/wait 1.012") end
      yield("/ahoff")
      while GetCharacterCondition(43) do yield("/wait 1.013") end
    end
    if bait_count>1 then
      yield("/bait "..correct_bait)
    else
      debug("Out of "..correct_bait)
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
      debug("Starting fishing from: X: ".. math.floor(GetPlayerRawXPos()*1000)/1000 .." Y or Z, depending on which plugin you ask: ".. math.floor(GetPlayerRawZPos()*1000)/1000 )
      for _, command in pairs(start_fishing) do
        debug("Running: "..command)
        yield(command)
      end
    end
  else
    start_fishing_attempts = 0
  end
  yield("/wait 1.010")
end

::DoneFishing::
RunDiscard(1)
if autohook_preset_loaded then
  DeleteAllAutoHookAnonymousPresets()
  autohook_preset_loaded = false
end
WaitReady(3, false, 72)

::SpendScrips::
if is_spend_scrips then
  debug("Spending scrips on "..scrip_item_to_buy)
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
  debug("Returning to inn.")
  ::MoveToArcanist::
  if IsInZone(129) and GetDistanceToPoint(-408,4,75)<20 then
    debug("Near ocean fishing. Moving to arcanists guild.")
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
    debug("At arcanists guild. Aethernet to aftcastle.")
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
  RunDiscard(2)
  ::MoveToInn::
  if IsInZone(128) and GetDistanceToPoint(14,40,71)<9 then
    debug("Near aftcastle. Moving to inn.")
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
    debug("Near inn. Entering.")
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
  debug("Returning to FC house.")
  while not ( IsInZone(339) or IsInZone(340) or IsInZone(341) or IsInZone(641) or IsInZone(979) ) do
    if GetCharacterCondition(27, false) and not IsPlayerOccupied() then
      yield("/tp Estate Hall (Free Company)")
    else
      WaitReady()
    end
    yield("/wait 0.31")
  end
  debug("Arrived at FC house. Entering.")
  yield("/automove on")
  yield("/wait 1.033")
  yield("/automove off")
  yield("/ays het")
  WaitReady(3, true)
  debug("Inside FC house (hopefully)")
end

WaitReady()

::Desynth::
if is_desynth then
  debug("Running desynthesis.")
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
        debug("Tried too many times to open desynth, and it hasn't worked. Giving up and moving on.")
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
          debug("item_name: "..item_name)
          debug("item_level: "..item_level)
          debug("item_type: "..item_type)
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

RunDiscard()

::StartAR::
debug("You did a good job today!")
if is_ar_while_waiting then
  debug("Enabling AutoRetainer while waiting.")
  if fishing_character=="auto" then fishing_character = GetCharacterName(true) end
  yield("/ays multi")
  while GetCharacterCondition(1) do
    yield("/wait 1.040")
  end
  goto ARWait
else
  debug("Waiting for the next boat.")
  goto WaitForBoat
end

goto Start
