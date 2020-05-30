# Hedgewars Typewriter
[![Hedgewars](https://img.shields.io/badge/Hedgewars-1.0.0-gray?logo=lua&labelColor=d66bcb)](https://hg.hedgewars.org/hedgewars/rev/1.0.0-release)
[![LDoc](https://img.shields.io/badge/LDoc-compliant-green?logo=lua&labelColor=2c2d72)](https://stevedonovan.github.io/ldoc/)

Typewriter Hedgewars Lua library, which wraps up text visuals in Hedgewars with typewriter animations.

Right now, the only function supported is `Typewriter.AddMissionAnim`. It adds ability to draw mission panel with caption, subcaption and text animated in typewriter sequence. See its action in this video:

[![](https://img.youtube.com/vi/eU_wjuqNyDg/0.jpg)](https://youtu.be/eU_wjuqNyDg)

It's not a secret that animations bring more attention than static panels. You may find it useful for embedding in your campaigns, missions and even multiplayer game styles.

I plan to add more typewriting animations of tags and other GUI with dynamic text, so stay in touch: [press "Watch" here](https://github.com/vintprox/hedgewars-typewriter), give a star and/or fork repository!

## Installation
Take the desired release [here](https://github.com/vintprox/hedgewars-typewriter/releases) in form of `Typewriter_v*.hwp` file, which is recommended for loading addon in Hedgewars. Inside the [user directory](https://www.hedgewars.org/node/6761) find folder `Data` and place downloaded `*.hwp` there.

## Usage

### AddMissionAnim
Add whole typewriter animation for mission panel

```lua
HedgewarsScriptLoad("/Scripts/Typewriter.lua")

function onGameStart()
    Typewriter.AddMissionAnim({
        caption = "Hello World",
        subcaption = "<3",
        text = "This is just working, alright?"
    })
end
```

Options set is not limited to sole visuals: address to [Typewriter.lua](./addon/Scripts/Typewriter.lua) for more verbose information.

#### Everything's optional
Of course, table is here to not confuse order of parameters, it can be ordered however you like. Actually, you can omit everything, because they are optional as long as you have proper globals set up. Here's the example:
```lua
Typewriter.Mission.caption = "My Super Campaign"
Typewriter.AddMissionAnim({
    text = "Your fort is in danger! | Go place some girders.",
    icon = 2
})
```
This way, only detail text appears animated, caption will be shown instantly as common mark between your missions (same applies to subcaption, here it's empty by default). You also can set icon passed to [ShowMission](https://www.hedgewars.org/kb/LuaGUI#ShowMission(caption,_subcaption,_text,_icon,_time_[,_forceDisplay])).

#### Customize or disable sounds
```lua
Typewriter.AddMissionAnim({
    text = "Collect box on the other side of street",
    sound_typing = nil,
    sound_return = sndWhack
})
```
Here we completely disabled typing sound, but changed sound that plays, when whole animation is considered complete, to hammer impact.

#### Change behavior on animations' end
```lua
Typewriter.AddMissionAnim({
    subcaption = "same day, 9:00 PM",
    text = "Suppose we have a long text here...",
    display_time_after = 5000,
    force_display_after = true
})
```
Usually, we forcedly display mission panel only during animations. When all text was typed, default display time is ~3000ms, and player can easily hide panel by pressing <kbd>M</kbd>. But if `force_display_after` is truthy, mission panel will be shown no matter what during `display_time_after` extra time.

#### Set delays
You would probably like to set delays globally, so here is an example:
```
Typewriter.Mission.delay_caption_start = 1000
Typewriter.Mission.delay_caption_char = 200
Typewriter.Mission.delay_subcaption_start = 500
Typewriter.Mission.delay_subcaption_char = 150
Typewriter.Mission.delay_text_start = 400
Typewriter.Mission.delay_text_char = 100
Typewriter.Mission.delay_return = 2000
```
This particular example guarantees irritatingly slower experience for player. 😜 However, you can find more optimal values based on your mission's setting.
