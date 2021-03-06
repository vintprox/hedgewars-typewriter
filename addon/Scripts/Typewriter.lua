--- Typewriter Hedgewars Lua library
-- @module Typewriter
-- @author Rodion Borisov <vintprox@gmail.com>

HedgewarsScriptLoad("/Scripts/Animate.lua")

local last_mission_anim

--- Module defaults
-- @table Typewriter
-- @field utf8                            Whether to use shims in favor of strings containing Unicode characters
-- @field Mission                         Values related to AddMissionAnim
-- @field Mission.gear                    Gear that is being focused by camera
-- @field Mission.swh_after               Whether to switch camera's position to gear after whole animation
-- @field Mission.caption                 Default caption for ShowMission
-- @field Mission.subcaption              Default subcaption for ShowMission
-- @field Mission.text                    Default text for ShowMission
-- @field Mission.icon                    Default icon for ShowMission
-- @field Mission.sound_typing            Sound that is played for typing
-- @field Mission.sound_return            Sound that is played after whole animation is considered complete (after return delay)
-- @field Mission.delay_caption_start     Delay before caption animation starts
-- @field Mission.delay_caption_char      Typing delay for caption animation
-- @field Mission.delay_subcaption_start  Delay before subcaption animation starts
-- @field Mission.delay_subcaption_char   Typing delay for subcaption animation
-- @field Mission.delay_text_start        Delay before text animation starts
-- @field Mission.delay_text_char         Typing delay for text animation
-- @field Mission.delay_return            Delay before whole animation is considered complete (return delay)
-- @field Mission.display_time_after      Time for ShowMission after all animations end (concurrent to the return delay)
-- @field Mission.force_display_after     Whether to forcedly display mission panel after all animations end
-- @field Mission.modal                   Whether mission panel will be important to look at after skipping animation
Typewriter = {
  utf8 = false,
  Mission = {
    gear = nil,
    swh_after = true,
    caption = " ",
    subcaption = "",
    text = "",
    icon = 10,
    sound_typing = sndRopeRelease,
    sound_return = sndRopeAttach,
    delay_caption_start = 600,
    delay_caption_char = 100,
    delay_subcaption_start = 200,
    delay_subcaption_char = 100,
    delay_text_start = 200,
    delay_text_char = 50,
    delay_return = 800,
    display_time_after = 0,
    force_display_after = false,
    modal = true
  }
}

--- Determine the length of string. Use case depends on Typewriter.utf8
-- @tparam string s Input string
-- @treturn int
local function string_len(s)
  if Typewriter.utf8 then
    return select(2, string.gsub(s, ".[\128-\191]*", ""))
  else
    return string.len(s)
  end
end

--- Truncate string to certain length. Use case depends on Typewriter.utf8
-- @tparam string s Input string
-- @tparam int to Desired length
-- @treturn string
local function string_truncate(s, to)
  if Typewriter.utf8 then
    return string.gsub(s, "^(" .. string.rep(".[\128-\191]*", to) .. ").*", "%1")
  else
    return string.sub(s, 1, to)
  end
end

--- Add whole typewriter animation for mission panel
-- @tparam table overrides Optional overrides for drawing mission panel; default values come from Typewriter.Mission
function Typewriter.AddMissionAnim(overrides)
  local t = {}
  for key, value in pairs(Typewriter.Mission) do
    if overrides[key] ~= nil then
      t[key] = overrides[key]
    else
      t[key] = value
    end
  end
  if not t.gear then t.swh_after = false end
  local anim = {}
  if overrides.caption then
    table.insert(anim, { func = ShowMission, args = { " ", "", "", t.icon, 0, true }, swh = false })
    table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_caption_start }, swh = false })
    for l = 1, string_len(t.caption) do
      if t.sound_typing then
        table.insert(anim, { func = PlaySound, args = { t.sound_typing }, swh = false })
      end
      table.insert(anim, { func = ShowMission, args = { string_truncate(t.caption, l), "", "", t.icon, 0, true }, swh = false })
      table.insert(anim, { func = AnimWait, args = { gear, t.delay_caption_char }, swh = false })
    end
  end
  if overrides.subcaption then
    table.insert(anim, { func = ShowMission, args = { t.caption, "", "", t.icon, 0, true }, swh = false })
    table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_subcaption_start }, swh = false })
    for l = 1, string_len(t.subcaption) do
      if t.sound_typing then
        table.insert(anim, { func = PlaySound, args = { t.sound_typing }, swh = false })
      end
      table.insert(anim, { func = ShowMission, args = { t.caption, string_truncate(t.subcaption, l), "", t.icon, 0, true }, swh = false })
      table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_subcaption_char }, swh = false })
    end
  end
  if overrides.text then
    table.insert(anim, { func = ShowMission, args = { t.caption, t.subcaption, "", t.icon, 0, true }, swh = false })
    table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_text_start }, swh = false })
    for l = 1, string_len(t.text) do
      if t.sound_typing then
        table.insert(anim, { func = PlaySound, args = { t.sound_typing }, swh = false })
      end
      table.insert(anim, { func = ShowMission, args = { t.caption, t.subcaption, string_truncate(t.text, l), t.icon, 0, true }, swh = false })
      table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_text_char }, swh = false })
    end
  end
  table.insert(anim, { func = ShowMission, args = { t.caption, t.subcaption, t.text, t.icon, t.display_time_after, t.force_display_after }, swh = false })
  table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_return }, swh = false })
  if t.sound_return then
    table.insert(anim, { func = PlaySound, args = { t.sound_return }, swh = false })
  end
  if t.swh_after then
    table.insert(anim, { func = AnimSwitchHog, args = { t.gear }, swh = false })
  end
  AddSkipFunction(anim, function ()
    ShowMission(t.caption, t.subcaption, t.text, t.icon, t.display_time_after, t.force_display_after)
    if t.modal and last_mission_anim == anim then
      if t.sound_return then
        PlaySound(t.sound_return)
      end
      if t.swh_after then
        AnimSwitchHog(t.gear)
      end
    else
      HideMission()
    end
  end, {})
  AddAnim(anim)
  last_mission_anim = anim
end
