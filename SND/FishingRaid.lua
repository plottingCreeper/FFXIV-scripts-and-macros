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
is_single_run = false  --Only go on 1 fishing trip, then stop.

-- Spend white gatherer scrips (overhaul coming soon:tm:)
spend_scrips_when_above = 100
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
        UseAutoHookAnonymousPreset("AH3_H4sIAAAAAAAACu1ZTU/jOhT9K1Y2b9MZNdCWgcWTOqUM1SsDop1hgdDIpG5j4caV4wAdxH9/13bixGma8tFldnC/fM61fXwDL14/kXyAYxkP5gvv5MUbRviekT5j3okUCWl5pzySAxwFhF1wHoSZWeWMaUTynFnm+rGahoLEIWdgam+tcE7YakqepXfieS3vJ15CLQ0HqdpIF295I6hx8O3Yqdq/548kx0dip/ocsxjs/UBSHk3XK4j0Xw3gNOLF0z8cONjTNAe8334n/F8xQToKjUYZ+N63z4O/jNhaR4wimVDls6H7br4JS7EfH+2n8YMwWapu/0lichOSyNIYPgeEzGINtY7JUa/7Fi7GG6NBIgSJpCWTEtQwDLWO3+68g5sxV1LjjJFA7jxL79yLrKxF639uJzoWrphRDLf7xRtFj0RkhitBuaBynSczxp8uISLAq9HAmv8EJn5MYwB8C1UkWfrQjoNeD26p+g3uVafdfm3lvna753d86z3sFr2uq5To94793Hvgeh2fD0Xv9nodslaZLTAwP7MFB+kWnNE4HK5JvPPIdLvtPRx6tRzS69mz1N3Lyb/AD2QS0rn8jqk+/8oQZ4aJxMEDcIS16km+heI0pDFa0kUoUcCjOaOBRE9UhkhL1jTEjOKHf2J0hh+5yKlbhEhDtIL8rgbUyNoVlpRAaL6TtgW5K82/JnO13BALtp5SBW+H5HV7+9h9i8Nufm8vmw968ZcMsDTv6S8j6+aJGl1Gg1PLG1zq9bqB3RrNACANMFMFqgLUQo9kwvBq83mrOjugBx9u0VeUtQbhaIbsxumjAoeLMRRxie4Jgjdrhp6AHtKkkWaNsMZaaHTuKxy0/TQ7PeCxOd7Qb8eQ3bTDlmu/JgEsJ7Q06janghafUaH6b9arO4KHn7+bG1cwbdfmnc1a1vns3YSmDZ+lwM5Em5+gyRNeKSx2BvmBaT5OKc+Uq5iS/yVDPpxReZHdpy9qizYqjnnhfFdUNP4dFa+gA2QLSuOrxOl98SrzHUyV+SbC5msRX8EMIuDCmpuzpVOVUW/oVylvS9cqo97Uuzr0xQ5Uxnm36uGk0eIa09kdymKc5tYRqFmg0OhrFTTgSSSJSGtCfFoEyBhbytVFNCaPhMFv6N9eGyqpgexyrtoW67msdK+VQ6UXWvebiBgkkBE0ToT91jo+8o9g4XPOH24IfiiVycz5AF/tPz2fnpcvXubTag9yWqH25ZCfl9MtUeqyq0j1pB0du7bCR1LunEjBo0UFXOOoI2QitlEy3h2k3KB6WiZWv9WHZatDLXOPyYJEMyzWFditr46gDXI4Vvh3sNyIqydqw8tcN0FnEeoVS2LJl9ajcoqzxClPAL6xGgZgnAq6yoyFUGC7MaeldsVg67ySBUwSMceBS25MzIAfw3dTXvUCP6uh75QwDGzbX+FBvqBR2aTYwSeqMotiamYspVeZJ5Kv+nNQkwFO4EnOXz3XPqZLNbP7BUcuRU5SqjkTSYCj/vzarSzXePHExbIgKerzs5GURlIaSWkk5UOS8p+AL7KCoHQbQWlmlGZGaWaUj84oVyxZrtCNO6b0GlVpVKVRlUZVKlQF/rlk/saS/u3x1hqMstzevf4PVDiywk8fAAA=")
      else
        UseAutoHookAnonymousPreset("AH3_H4sIAAAAAAAACu1ZS1PjOBD+Kypf9sJMxSEJA7UXJoQhtWFCkcxyoKgp4SixCsVKyTKQpfjv25Js2XIch0cOc/AN+qXva3W32vDinSaS93Es4/584Z28eIMI3zNyyph3IkVCDrwzHsk+jgLCLjkPwkysfEY0IrnPLFP9WE1DQeKQMxC1tka4IGw1Jc/SO/G8A+8nXkIsDQep2EgHP/CGEKP97diJenrPH0mOj8RO9DlmMchPA0l5NF2vwNJ/NYBTixdP/9B2sKduDni/9U74v2KCtBUaDjPwvW+fBz+O2FpbDCOZUKWzpvtOvjFLsR8f7Sfx/TBZqmz/TmJyE5LI0hg8B4TMYg21jslRr/sWLkYbo34iBImkJZMS1DAMtY7f6ryDmxFXUuOMkUDurKV33kUW1qL1P3cTHQtXzCiG7n7xhtEjEZngSlAuqFznzozxpzFYBHg17Fvx78DYj2gMgG8hiiRLH9LR7vWgS9Vv0FedVuv1INe1Wj2/41vtYbeodVUlR7937Ofatqt1dL4T9I+Ac7fX7sxuzlSEgfmZiminFXFO43CwJvHOCu52W3voQXUc0ufZ0u7upREv8QOZhHQuv2Oq21EJ4kwwkTh4AI5wVj3Jt1CchjRGS7oIJQp4NGc0kOiJyhDpCToNMaP44a8YneNHLnLqFiHSEO378K4E1EzZKywpAdP8Jm0KclXqf03m6rgBFmw9pQrejgnc7e3j9i0Oe/ntvVw+jK//SB9L87z/Mq+MeTGH46h/ZnmDSj2mN3BbwxkApAFmKkCVgTrokUwYXm2+tlW1A/Pgwyn6irLUIBzNkL04XSpQXIyhiEt0TxA8oTP0BPSQJo00a4Q11kKic12h0Hp7SXZa4LEpb8i3I8g67fDAlV+TAI4TejTqNKcDLT6nQuXfnFdXgoef782NFkzTtdmzWco6n+1NSNrgWQrsLNh5BU2e8EphsSvRD0zz7U5pplzZlPQvGfLBjMrLrJ++qCvaiDjihfquiGj0OyJeQQbIFpRGV4nT++JV+juYKv2NhfXXQ3wFK5GAhjWdsyVTlVZvyFfJb0vWKq3elLs69MUMVNp5t+rhpNHiGtPZHcpsnOTWEag5oJDoa2XU50kkiUhjgn0aBMgYWcrVRTQij4TBb+jvXgsiqf1wPFdpi/WaWOprpVDuhdT9S0QMI5ARNEqE/fQ7PvKP4OALzh9uCH4ohcnE+fdEtf7sYnpRbrxMp6c9jNOKaV82+TmebrFSza4s1ZN2dOzKCt9suXIiBY8WFXCNoo6QsdhGyWh3kHKN6mkZW/1WH5alDrVMPSILEs2wWFdgt7o6gtbI4Vih38Fyw66eqDUvc90EnVmoVyyJJV9ajfIp7hJnPAH4RmoYgHAq6CoTFkyB7caelsoVg637SmYwScQcBy65ETELfgyfcXnUS/yslr4zwjCwbX2FB/mSRmWRYgdfzEosiq6ZsOReJZ5IvjqdwzTp4wSe5PzVc+UjulQ7u19Q5KPIcUpnzkQS4Kg/v3ZPlmu8eOJiWRgp6mu4GSnNSGlGSjNSPjRS/hHwRVYYKN1moDQ7SrOjNDvKR3eUK5YsV+jGXVN6zVRppkozVZqpUjFV4J9L5m8s6d8eb63ATJbbu9f/AVP0+3XeHwAA")
      end
    elseif OceanFishingIsSpectralActive() then
      if GetMaxGp()>700 then
        UseAutoHookAnonymousPreset("AH3_H4sIAAAAAAAACu1YTXPiOBD9Kypf9sJMQQJkkhsLzIRaSFLBszmkUlOKEViFkChJTsJQ+e8rWZb8gTHJwp7WN6q71XqvpX5qs/V6kWR9KKTozxfe1dYbUvhMUI8Q70ryCDW8AaOyD2mAyISxILRmvWaMKUrXzKzrx9oPORIhI8rU3JvhGpG1j96kd+V5De8GrlSuGA7QuUGcvOGNVI6zb5e5rL1n9oJSfEjkss8hEcreCyRm1N+sVWTr3QBOIrZe/OPsEPZW85PofwoE4igwGlns3W/HY7+lZBNHjKiMsPa50FPX3oQl2C8vTlP3fhitdLF/RQI9hIg6GsO3AKGZiKE6Jkmif3MUxitAP+IcUenYJAxjHIZbu9Vsf4KcMZdyY4SgQObuUhmDTx6GTevQto47iraDy2cYqu7eeiP6grg13HHMOJab/+Ji2T0Nl26rfSSXs4TLdyzC4QaJg7XvdE5xe/R2IN7PHUrnJFdoApdoGuK5/BPi+CJpg7CGqYTBUnFUe1WT/AhFP8QCrPAilCBgdE5wIMErliGIm98PIcFw+YcA3+EL4yl1hxDEEJ20faoAFQJxByVGKjQ9SVeC1JWsv0dzvd0QcrLxsYZ3SDw63VMcvwPiTr97ktNXnfcb9aE0L9NPo5BG7Ue3tD9wnJRLPwQP6rhGMwUQB5DoBGUBeqMXNCVwvdvQZSU6O0JfvwJbGgDpDLiTi++Kul2EAMokeEZAyf8MvCp6ICYNYtYAxlgzhU59mZt2mmInN1yY+63qnTPYVjtv5O33KFDbqfiWFpIqZTw/vgl3ei0py25z2tK0j21CVZzhm+QwNwOmN2X6Ctcai3u2f0CcTiDa4zMdU/BvLfLhDMuJ7Zsv+ih2Mo5Z5h6XZDT+AxnvVAXQHpTGV4rT++KVrs9hKl1vItz6WK3X6tXmqjFNh+ypVGnUB+pVWLenaqVRH6pdFfpsBUrjCnUsRWFuZUWqpKSQMvrrUb+4mC7uIZ49gRvGV2qIeLfLEzr5IJtNIRljIW/nuiqqox93Jn3t0EszlfkbcaGUjCAwjrj7+Li8aF2oTa8ZWz4guCykseZ0pC33D67962JfWV8s2koVS0S7GHJz6++J0r2sI/XLdHGZt2U+G1LnVHJGFyVwjaOKkInIUSo6D3DKB1WzMrHxi3tetOaYWfcYLRCdQb4pQed8Vfxc0B6Kzn+A5U5cNVEXXuS6C9pGqCe/HwnJVs6j12QnggGLFPyi1ed4ba2Glw5VbHfGrcSuGeydOmzANOJzGOTJjZGZ00UA9WOTWCfwTc9uA0SgYtv8qp7VCaZFk2anPtm0mWeXWmNheZl5Ktm6N5eI92GkHtz0Tcvbx3ilR++WcSSSMpVI8Wi+Nz4iHvdw8aoUKqMa+pOrVo1aNWrVqFVjn2r8xdXnUUYzOrVm1JNGPWnUk0bFpHFHotUaPOSHjW4tHLVw1MLxfxWOJ/t/R/I336MzGPF4fHr/B4+oiaDsHQAA")
      elseif GetMaxGp()>400 then
        UseAutoHookAnonymousPreset("AH3_H4sIAAAAAAAACu1YXW/iOhD9K1Ze7gtdQQt02zcusC260KKSvX2oqpUbDLEwMbKdUhb1v68dx84HIbQL+7R5QzPj8Tljz/GErdMJBe1CLnh3Nneut04/gC8EdQhxrgULUc3p0UB0YeAhMqLU841ZrRniACVrpsZ1s3J9hrhPiTTV92a4RWTlojfhXDtOzbmDS5krggNUbhAlrzkDmeP861Uma+eFvqIEH+KZ7DNIuLR3PIFp4G5WMrLxrgHHEVsn+nF+CHuj/kn03zkCURQYDAz29tfjsd8HZBNFDAIRYuWzoaeuvQ6LsV9dnqbuXT9cqmL/CDl69FFgafTfPISmPIJqmcSJfucotJeDbsgYCoRlEzOMcGhuzUa9+Qly2lzIjRKCPJG5S0UMPnkYJq1F2zjuKJoWLptiKLt76wyCV8SMYcwwZVhs/sTFMntqLu1G80gu5zGXb5j7/Q3iB2vfap3i9qjtQLSfPZTWSa7QCC7QxMcz8S/E0UVSBm4MEwG9heQo9yon+RGKro85WOK5L4BHgxnBngBrLHwQNb/rQ4Lh4h8OvsFXyhLqFiGIIFpp+1QBSgRiDAVGMjQ5SVuCxBWvf0AztV0fMrJxsYJ3SDxa7VMcvwViT799ktOXnfcTdaHQL9N3rZBa7Qf3QbdnOUmXegge5XENphIg9iBRCYoC1EavaELgarehi0p0foS+fgGmNAAGU2BPLror8nYRAgIqwAsCUv6nYC3pgYg0iFgDGGFNFTrxpW7aaYod33Cu77esd8ZgWu2ilrU/IE9uJ+MbSkjKlPHi+Cbc6bW4LLvNaUrTPLYJZXH6b4LBzAyY3JTJGq4UFvts30CcTCDK41IVk/NvDfL+FIuR6ZszdRQ7GYc0dY8LMmr/gYxjWQG0B6X2FeJ0zpzC9RlMhet1hF0fqfVKvtpMNqbukD2VKoz6QL1y6/ZUrTDqQ7UrQ5+uQGFcro6FKPStLEkVl/RJPbY4mD9APH0Gd5QtIQFnYEjX4GbsvJsUMaVstMmYxNecIebifqZKJNv7aWfsVw6VI1Wm/xHjUtYIAsOQ2S+Rq8vGpdz9ltLFI4KLXBpjTubbYn/v1r3NN5nxRQouJbJAwfMhd/funijV2CpSPVOXV1lb6hsicU4Eo8G8AK52lBHSERlKeecBTtmgclY6Nnp+L/LWDDPjHqI5CqaQbQrQWV8ZPxu0h6L1H2C5E1dO1Ibnue6CNhHy/e+GXNCl9ag16fGgR0MJX1s1A2l0GV4ZYypUst2ZvWK7YrB3BDEBk5DNoJclN0R6aOceVC9PbB3BNzXI9RCBkm39i3xjRzjImxQ7+f2mzCy91Bhzy4vME0FXnZlArAtD+fomD1zWPsRLNYc3tCPWlolAkkf9vfYR8XiA87XUrJRqqO+vSjUq1ahUo1KNfarxH5PfSinNaFWaUU0a1aRRTRolk8aYhMsVeMwOG+1KOCrhqITjbxWOZ/N/R/yf35M1aPF4en7/BRDOl5f5HQAA")
      else
        is_leveling = true
      end
      autohook_preset_loaded = "spectral"
    else
      if GetMaxGp()>700 then
        UseAutoHookAnonymousPreset("AH3_H4sIAAAAAAAACu1YS3PiOBD+Kypf9pKZggyPSW4sMBNqIUkFz+aQSm0pRmAVwqIkOQlD5b+vHpb8wBiycFvfqO6vpe9rqVtttl4vFrQPueD9+cK73nrDCL4Q1CPEuxYsRhfegEaiD6MAkQmlQWjNKmaMI5TGzKzr59oPGeIhJdLU2LvCDSJrH70L79rzLrxbuJJraTpArQ304hfeSK5x+f0qt2rvhb6ilB/iudXnkHBp7wUC08jfrCWy+WEIJ4itp39c5rgnYTnyzcYn6f/iCGgUGI0s+c7308nfRWSjEaNIxFj5HPTcyTewhPtV9zyJ74fxSmX7n5ijxxBFTsbwPUBoxjXVKiXdTvsYLcbLQT9mDEXCiUkEahpGWqvZaH1CmzGXSqOEoEAcvEufPAu7rGPbPO0kWo4um2Eoq3vrjaJXxKzhnmHKsNjs3quziDGbGjGdZutEMZeJmB+Yh8MN4geT3243znB91HZA7+dOpX2WOzSBSzQN8Vz8CbG+ScrArWEqYLCUGuVe1SKPkeiHmIMVXoQCBDSaExwI8IZFCHTx+yEkGC7/4OAHfKUsle4YAk3RtbZPJaCiQdxDgZGEpifpUpC6kvgHNFfbDSEjGx8reo1Dmemc4/gdEXf6nbOcviy936gPhXmafpkOabr96C7qD5wm6VIPwaM8rtFMEsQBJGqBMoDa6BVNCVwfV9GXjf+eoq/ApgbAaAbcyem7Im8XISCiArwgINv/DLxJeUCLBlo1gJprJtGpL3PTzpPs5IZzc79lvnMGW2pNmYyc4wEFcj8Z0GwfeKm+nV6FO8WW5GW3Om1uWqdWoczO8F0wmJsC06syfYNrxcW92z8hTkcQ5fGpwhT8W8t8OMNiYgvnizqLnRXHNHORS1Y0/gMr3ssMoD0sja+Up/fFK43PcSqNNwgXr9v1Wr7bTFamKZE9mSpFHZGvQtyerJWijspdFftsBkpx3pN6InG0eIB49gwsJpfcKgEVG7hEf1hYIia/5S1lK73hGHNxN1cZkeX8tPONohwqMJOVvxHjso0RBMYxc58eV91mV255Q+nyEcFlYRlrTufZcv/gxr8p1pT16Y4tW2JJxy5Cbu/8PShVxwqpnqXuVd6W+WZInVPBaLQooWscVYIMYp8k4z0gKg+qlmWw+r39VrTmpFn3GC1QNINsU8Ld+aoEOlBOY4n/gModXLVQBy9q3SVtEfLB78dc0JXzqJjsPDCgsaRftPoMr63V6FJQqXZn2ErsSsHemcMCpjGbwyAvbozMlM4DqF6axDqB72pyGyACpdrGV/mmTnBUNCl18otNmVk21BoL4WXmqaDr3lwg1oexfG3TBy1vH+OVGrybxpF0lKlAUkfj4+KY7vEAF2+y92TahvriqttG3TbqtlG3jb1t4y8mv44yTaNdN4161qhnjXrWqJo17km8WoPH/LjRqTtH3TnqzvG/7RzP9j+P5G++J2cw3ePp+eNfQgSXCu4dAAA=")
      elseif GetMaxGp()>400 then
        UseAutoHookAnonymousPreset("AH3_H4sIAAAAAAAACu1YUW/iOBD+K1Ze7qVdQRfotm8csC06aFHJXh+qauUGQyxMjBynlEP97zeOYyeBEKjgbfOGZsbj7xt7Pk/YOO1I8g4OZdiZzpzbjdML8BsjbcacWykicuF0eSA7OPAIG3Lu+cas1gxoQNI1E+O6W7q+IKHPGZhqezPcE7Z0yYd0bh3nwnnAC8gVw0EqN4qTXzh9yHH14yaXtf3G30mKj4S57FPMQrC3PUl54K6XEFn/1ICTiI0T/7jKYU+W5cDXa1+E/yskKI5C/b4B3/pxOvjHgK3jiH4gI6p8NvTcxddhCfab6/MUvuNHC1Xt31FInn0SWBq9D4+QSRhDPcdRaG+IOpEQJJCWTcIwxqG5Neq1xhfIaXMhN84Y8eTBy/TFwzBpLdr6aUfRsHDFhGJo743TD96JMIaRoFxQud69WGchozfVZFr1xolkrhIyP2no99YkPFj8ZvMc10dth+L97Kk0z3KHhnhOxj6dyr8xjW+SMoTGMJbYmwNH2Kuc5DEUXZ+GaEFnvkQeD6aMehKtqPRR3P2ujxnF879C9BO/c5FStwhRDNFq25cKUKIQIywpgdD0JG0JUley/olM1XY9LNjapQreIfVots5x/BaIPf3WWU4fWu8/0sFSv02/tERque8/Bp2u5QQu9RI8w3H1JwCQepipBEUBaqN3MmZ4eVxHX50gsN+QKQ3CwQTZk4vvCtwuxlDAJXojCPR/glZAD8WkUcwa4RhrptCpL3PTzlPs5IaH+n5DvXMG02p1KEbO8UQ82A8W1JWSlD2630/vwp1mS+qy252mNo1TuxCq0/uQAufGwPSqjFd4qbDYh/sO03QGUR6Xq5gt/8Yg702oHJrGuVRnsZNxwDMXuSCj9h/IOIIKkD0ota8Qp3PpFK7PYSpcryPs+liul/BuC+hM3SJ7KlUYdUS9ttbtqVph1FG1K0OfrUBhnPOinkgazJ4wnbwiE4Mu0YCv0N0oV+UyJiU72Yp/mrCEVX7vBy4W+Z0HNJSPU1UjaPCXnc8W5VAZMnX6l4gQhI0RNIiE/Rq5ua5fw973nM+fCZ5vpTHmdMQt9nfv3fvtLjO+WMNBJAs0fDvk4dHdE6U6W0Wqh+r6Jm/LfEakzrEUPJgVwNWOMkI6Yh8l7T1AKh9UTkvHxi/w921rjppxD8iMBBMs1gXYra+MoA3KcSzwH2C5E1dO1IZvc90FbSJgBOhEoeQL61FrshNCl0cAX1s1AzC6gi6NMRMKbHfGr8SuGOydQkzAOBJT7OXJDYie20MPq7cnsQ7xh5rluoRhYFv7Bq/skAbbJsUOvuGUWWSXGuPW8iLzWPJleyqJ6OAI3t/0icvbB3ShRvG6diTSMpYEeNQ+L45Rjyc8W4EIZWRDfYNVslHJRiUblWzslY1/BHwvZUSjWYlGNWtUs0Y1a5TNGiMWLZboOT9utCrlqJSjUo4/VjlezX8eyR9/L9ag1ePl9fN/02kSawEeAAA=")
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
    elseif IsPlayerOccupied() then loading_tick = 0
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
  if os.date("!*t").hour%2==0 and os.date("!*t").min<15 then
    if is_last_minute_entry and os.date("!*t").min>10 then
      return true
    end
  end
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
elseif (os.date("!*t").hour%2==1 and os.date("!*t").min>=45) or (os.date("!*t").hour%2==0 and os.date("!*t").min<15) then
  verbose("Starting at or near fishing time.")
  if IsInZone(129) and GetDistanceToPoint(-410,4,76)<6.9 then
    verbose("Near the ocean fishing NPC.")
    if GetCharacterCondition(91) then
      verbose("Already in queue.")
      goto Enter
    elseif IsNeedBait() then
      goto BuyBait
    elseif os.date("!*t").hour%2==0 and os.date("!*t").min<15 then
      goto PreQueue
    elseif os.date("!*t").hour%2==1 and os.date("!*t").min>=45 then
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
while not ( os.date("!*t").hour%2==1 and os.date("!*t").min>=55 ) do
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
    yield("/visland exectemponce H4sIAAAAAAAACuWTyWrDMBCGXyXM2QiNFkvyrXQBH9KNQrrQg2hUIqilYistxeTdqzgKCfQNGp3mnxlGvz40I1zbzkEDbQizFGfWpZXrg0tQwcL+fEYf0gDNywi3cfDJxwDNCI/QcEKlqaVUFTxlZYhEJYWo4BkarIlWRqDaZBmDay+goRXc26Vf52GMZDGPX65zIU2VNiTX27e08Gl1U7qPc8Vj9jSs4ve+ks3kae/2Y3CH9skhVnDZxbS/uE2uK+HZ1FHE3doNqcTbwQvr02HiVl3F/jyGZXk43SUffOfmuY9uqj9YKBFSG6WYPuYiJywMCUdTc3Z6WJAILSUKNlERlCCnivMJi6L5K2ltTo+KIJIaLcoOZSp0e/SOCiesVvoEVwg50UxLdqCyA4IEFar6vwN53fwCXs5zv5QFAAA=")
    yield("/wait 3")
    while IsVislandRouteRunning() or IsMoving() do
      yield("/wait 1.035")
    end
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
      yield("/visland exectemponce H4sIAAAAAAAACuWTyWrDMBCGXyXMWRWyFmu5hS6QQ7pRcNPSg0hUIqilYCstJfjdKy8hUPoEjU7zj35+Rh+jA9za2oGBebO2wbdpRmeN21nfAILKfu+iD6kF83qA+9j65GMAc4BnMBeME8yJIAzBCkxRYNWrEsELGC6xZqwQossyBre4yg6qETzajd/nPIoJgmX8dLULCUwWi5BcY9ep8ml71/t/9aY581jtNn4db/I8Oe3dfrTuZB+GLBBc1zG5Y1Ry9VTOB8ckHvauTVPdB1fWp1Nir25icxnDZno7GZtPvnbL7CMd+oOMUljKkg9gBNb5cCVGMBpzwUquzhOMZpjpfkcyGD6A0XrgUgosqCJnui9aY1GoEQsbsdDxI8n8rQg923WRWDEp6ASG9GDEuDBSYUappP8fzFv3A6BUZs+lBQAA")
      yield("/wait 3")
      while IsVislandRouteRunning() or IsMoving() do
        yield("/wait 1.036")
      end
    else yield("/pcraft stop")
    end
  else
    verbose("At arcanists guild. Moving to ocean fishing.")
    if string.find(string.lower(movement_method),"visland") then
      yield("/visland exectemponce H4sIAAAAAAAACuWSy2oDMQxFfyVoPTX22J6xvAt9QBbpi0L6oAszcRpDxy4Zp6WE/Hsdz4R0kS9ItNKVxLV80AZuTWtBw3jVGO+6OIphFBpr/GjhuqXzH1DAzPx+BedjB/ptA/ehc9EFD3oDz6AvOFekRiYLeAHNGFGilCgKeAUtFEEmsNomFbydXIGmBTyauVsnL0aSmIZv21ofc2fio12ZJs5cXN4N0/9rw65ppW4ZfvadtEtyW5jPzh7G84KsgOs2xP3Dk2jbIR3niUE8rG0Xh3xnPDMuHhx36iasLoOfD/+mffHJtXaa5ui2OEKlkkRgyUXGoghNIaueSk0oq7hSx7GUJ41FYcKCss5YJMEUXPVYkDDGKTtLLFgSKcsBCs080gExUZV4hjgErYmiFfZAeL4SxP5MakFqhVKeOpb37R9ZYl91nAUAAA==")
      yield("/wait 3")
      while IsVislandRouteRunning() or IsMoving() do
        yield("/wait 1.036")
      end
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
  goto BuyBait
end

::BackToOcean::
WaitReady(0.3)
if GetDistanceToPoint(-410,4,76)>6.9 then
  verbose("At Merchant & Mender. Moving to Ocean fishing.")
  if string.find(string.lower(movement_method),"visland") then
    yield("/visland exectemponce H4sIAAAAAAAACuVQXUvDQBD8K2Wfz3CJqWnurVSFPtSPIsQqPhztSg+825LbKhLy393UK0XxH/g2MzsMs9PBjfUIBpa4s64dMY1ojTaAgsZ+7sgFjmCeO7ij6NhRANPBI5izUp9nuihLBSswZaYVPIGpRMt1PemFUcD5JZi8qBUs7cbtJacYfAt6R4+BwQiZB8bWrrlxvL0d/L+01E7qxC19HC/SQ9Je7VvEk/1QLldw5YnxGMXoE5weHInc7zFywkNwYx2fEgd2Te2Mwib9rL/FB+dxIT7dq78WGWcXdVGNf04iYJJX/2CSl/4LNp/3pk0CAAA=")
    yield("/wait 3")
    while IsVislandRouteRunning() or IsMoving() do
      yield("/wait 1.036")
    end
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
if os.date("!*t").hour%2==0 and os.date("!*t").min<15 then goto PreQueue end
while not ( os.date("!*t").hour%2==0 and os.date("!*t").min<15 ) do
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
  while GetCharacterCondition(91, false) do
    if GetTargetName()~="Dryskthota" then
      yield("/target Dryskthota")
    elseif GetCharacterCondition(32, false) then
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
        yield("/visland exectemponce H4sIAAAAAAAACuWUy0pDMRCGX6XM+hhyv5ydeIEualWEesFFaFMb8CTSkypS+u4m8ZR24RPYrDLz/0wmH8Ns4cZ2DlqYzp0No6XvVz68jVIc2fXcBt8naGBmvz+iD6mH9mULt7H3yccA7RYeoT1jhiAtjWrgCVqBcAPP0EqBBKeC7nIUgxtfQpuFe7vwm1yFFtckfrrOhVSVcUhubedp5tNqOriPc0OXuZl+Fb/2Su4iV1va994d7LU10sBVF9P+4XFy3XA9r44huNu4Pg33UnhmfTpULNF1XF/EsBh+jH+TD75zk+zDu+YPHtogJhkbeJh8KFeVCtdZ4YbzU8QiDCJYY1m5aITL4XssQhqhT5IKQ4zxMh+ZiqrTolmlkhVsuNIniYXjvFOo5BULIYULF79YKFKYSaKOsBBqTgUMU4hLqo7BkLJrChmOtJGG/H8wr7sfPGs0+LgGAAA=")
        yield("/wait 3")
        while IsVislandRouteRunning() or IsMoving() do
          yield("/wait 1.031")
        end
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
        yield("/visland exectemponce H4sIAAAAAAAACuWT22rDMAyGX6XoOjNyYseHu7ID9KI7Mei6sYuwetSw2CNxN0bou09JU1rYnmDVlX5JyNKH3MF1VTuwMHVp7Zrg0iTFiQ8BMlhU3x/Rh9SCfe7gNrY++RjAdvAIliNTyCWKDJZgBTLsjdQTWCWYQNRiSyoGN7sAixncVyu/oV45IzGPn652IQ2ZWUiuqV7Twqf1zVh9HBtHpJHadfzaZ2gW6vZWvbfuUD4MyDO4rGPaPzxLrh7d6VAxiruNa9Po940XlU+Hjr26is15DKtxb9wFH3zt5lSH2+w3FcKgi7LM/6LCmVJSmdOjcoaMK11oLsqBS2GY6a0cuIiCFWgwl6cHhnYzXJpc77FIThcyUOGKqOTmFKnwgnGt6RsdH4uWOyw505Jj+e9/0cv2ByD0KqubBQAA")
        yield("/wait 3")
        while IsVislandRouteRunning() or IsMoving() do
          yield("/wait 1.032")
        end
      end
    end
    ::EnterInn::
    while IsInZone(128) do
      verbose("Near inn. Entering.")
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
  yield("/wait 0.1")
  while is_doing_desynth do
    verbose("Desynth is running...", true)
    if not IsAddonVisible("SalvageItemSelector") then
      yield("/generalaction desynthesis")
      open_desynth_attempts = open_desynth_attempts + 1
      if open_desynth_attempts>5 then
        is_doing_desynth = false
        is_desynth = false
        verbose("Tried too many times to open desynth, and it hasn't worked. Giving up and moving on.")
      end
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
        yield("/pcall SalvageItemSelector true -1")
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
          verbose("item_name: "..item_name)
          verbose("item_level: "..item_level)
          verbose("item_type: "..item_type)
          yield("/pcall SalvageItemSelector true 12 "..list-2)
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

RunDiscard()

::StartAR::
verbose("You did a good job today!")
verbose("Points earned: "..points_earned)
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
