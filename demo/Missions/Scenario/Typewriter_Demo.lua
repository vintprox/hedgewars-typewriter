--- Typewriter Demo
-- @author Rodion Borisov <vintprox@gmail.com>
-- @see https://www.hedgewars.org/node/9156

HedgewarsScriptLoad("/Scripts/Animate.lua")
HedgewarsScriptLoad("/Scripts/Typewriter.lua")

local hh

function onGameInit()
  EnableGameFlags(gfOneClanMode)
  Seed = 0
  CaseFreq = 0

  Map = "Hedgewars"
  Theme = "Hoggywood"
  
  AddMissionTeam(-1)
  hh = AddMissionHog(100)

  AnimInit(true)
end

function onGameStart()
  Typewriter.Mission.gear = hh
  Typewriter.Mission.caption = "Typewriter Demo"
  Typewriter.AddMissionAnim({
    caption = "Say \"Cheese\"!",
    subcaption = "Welcome to Typewriter Demo!",
    text = "As you can see, text in this mission box|is being typed letter by letter.",
    icon = -amGasBomb,
    sound_return = false,
    delay_text_start = 600
  })
  Typewriter.AddMissionAnim({
    text = "Let's see what else you can do with Typewriter!",
    delay_return = 1500
  })
  Typewriter.AddMissionAnim({
    subcaption = "Smack this barrel!",
    icon = -amBaseballBat,
    sound_return = sndMineTick,
    display_time_after = 10000,
    force_display_after = true
  })
  AddFunction({ func = SpawnSupplyCrate, args = { GetX(hh) + 50, GetY(hh), amBaseballBat, AMMO_INFINITE } })
end

function ProcessAnimation()
  AnimUnWait()
  if ShowAnimation() == false then
    return
  end
  ExecuteAfterAnimations()
  CheckEvents()
end

function onGameTick()
  ProcessAnimation()
  if not AnimInProgress() and TurnTimeLeft > MAX_TURN_TIME - 10 then
    EndTurn(true)
  end
end

function onPrecise()
  if AnimInProgress() then
    SetAnimSkip(true)
  end
end

function onGearDelete(gear)
  if GameTime < 10 then
    return
  end
  local type = GetGearType(gear)
  if type == gtCase then
    SetNextWeapon()
  end
  if type == gtExplosives then
    Typewriter.AddMissionAnim({
      subcaption = "Kaboom!",
      text = "Ah, satisfying flame...|But for now, demo is over, thanks for playing!|Stay in touch for updates.",
      icon = -amNapalm,
      delay_text_char = 100
    })
  end
end
