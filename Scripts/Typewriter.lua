--- Typewriter Hedgewars Lua library
-- @module Typewritter
-- @author Rodion Borisov <vintprox@gmail.com>

HedgewarsScriptLoad("/Scripts/Animate.lua")

--- Module defaults
-- @table Typewriter
-- @field utf8                              Whether to use shims in favor of strings containing Unicode characters
-- @field Mission                           ShowMission-related values
-- @field Mission.gear                      Gear that is being focused by camera
-- @field Mission.swh                       Whether to switch camera's position to gear during whole animation
-- @field Mission.swh_after                 Whether to switch camera's position to gear after whole animation
-- @field Mission.caption                   Default caption for ShowMission
-- @field Mission.subcaption                Default subcaption for ShowMission
-- @field Mission.text                      Default text for ShowMission
-- @field Mission.icon                      Default icon for ShowMission
-- @field Mission.sound_typing              Sound that is played for typing
-- @field Mission.sound_return              Sound that is played after whole animation is considered complete (after return delay)
-- @field Mission.delay_caption_start       Delay before caption animation starts
-- @field Mission.delay_caption_char        Typing delay for caption animation
-- @field Mission.delay_subcaption_start    Delay before subcaption animation starts
-- @field Mission.delay_subcaption_char     Typing delay for subcaption animation
-- @field Mission.delay_text_start          Delay before text animation starts
-- @field Mission.delay_text_char           Typing delay for text animation
-- @field Mission.delay_return              Delay before whole animation is considered complete (return delay)
-- @field Mission.display_time_after        Time for ShowMission after all animations end (concurrent to the return delay)
-- @field Mission.force_display_after       Whether to forcedly display mission panel after all animations end
Typewriter = {
    utf8 = false,
    Mission = {
        gear = nil,
        swh = false,
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
        force_display_after = false
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

--- Draw mission with typewriter animations
-- @tparam table overrides Optional overrides for drawing mission; default values come from Typewriter.Mission
function Typewriter.ShowMission(overrides)
    local t = {}
    for key, value in pairs(Typewriter.Mission) do
        t[key] = overrides[key] or value
    end
    local anim = {}
    if overrides.caption then
        table.insert(anim, { func = ShowMission, args = { " ", "", "", t.icon, 0, true }, swh = false })
        table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_caption_start }, swh = t.swh })
        for l = 1, string_len(t.caption) do
            if t.sound_typing then
                table.insert(anim, { func = PlaySound, args = { t.sound_typing } })
            end
            table.insert(anim, { func = ShowMission, args = { string_truncate(t.caption, l), "", "", t.icon, 0, true } })
            table.insert(anim, { func = AnimWait, args = { gear, t.delay_caption_char }, swh = t.swh })
        end
    end
    if overrides.subcaption then
        table.insert(anim, { func = ShowMission, args = { t.caption, "", "", t.icon, 0, true }, swh = false })
        table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_subcaption_start }, swh = t.swh })
        for l = 1, string_len(t.subcaption) do
            if t.sound_typing then
                table.insert(anim, { func = PlaySound, args = { t.sound_typing }, swh = false })
            end
            table.insert(anim, { func = ShowMission, args = { t.caption, string_truncate(t.subcaption, l), "", t.icon, 0, true }, swh = false })
            table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_subcaption_char }, swh = t.swh })
        end
    end
    if overrides.text then
        table.insert(anim, { func = ShowMission, args = { t.caption, t.subcaption, "", t.icon, 0, true }, swh = false })
        table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_text_start }, swh = t.swh })
        for l = 1, string_len(t.text) do
            if t.sound_typing then
                table.insert(anim, { func = PlaySound, args = { t.sound_typing }, swh = false })
            end
            table.insert(anim, { func = ShowMission, args = { t.caption, t.subcaption, string_truncate(t.text, l), t.icon, 0, true }, swh = false })
            table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_text_char }, swh = t.swh })
        end
    end
    table.insert(anim, { func = ShowMission, args = { t.caption, t.subcaption, t.text, t.icon, t.display_time_after, t.force_display_after }, swh = false })
    table.insert(anim, { func = AnimWait, args = { t.gear, t.delay_return }, swh = t.swh_after })
    if t.sound_return then
        table.insert(anim, { func = PlaySound, args = { t.sound_return }, swh = false })
    end
    AddAnim(anim)
end
