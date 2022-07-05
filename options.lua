
local speed = 0.0092*5000
local maxDist = 64
local useMusic = true
local canDie = false

function init()
    if(HasKey("savegame.mod.nextbot_extra.speed")) then
        speed = GetFloat("savegame.mod.nextbot_extra.speed")*5000
    end
    if(HasKey("savegame.mod.nextbot_extra.maxdist")) then
        maxDist = GetFloat("savegame.mod.nextbot_extra.maxdist")
    end
    if(HasKey("savegame.mod.nextbot_extra.music")) then
        useMusic = GetBool("savegame.mod.nextbot_extra.music")
    end
    if(HasKey("savegame.mod.nextbot_extra.candie")) then
        canDie = GetBool("savegame.mod.nextbot_extra.candie")
    end
end

function draw()
    UiFont("regular.ttf", 24)
    UiPush()
        UiAlign("right middle")
        UiTranslate(UiCenter()-200, UiMiddle())
        UiText("Nextbot speed:")
        UiTranslate(100, 0)
        UiAlign("left middle")
        UiColor(1, 1, 1,0.5)
        UiRect(200, 3)
        UiColor(1, 1, 1,1)
        UiAlign("center middle")
        speed = math.floor(UiSlider("ui/common/dot.png", "x", speed, 1, 200))
        UiAlign("left middle")
        UiTranslate(210, 0)
        UiText(speed .. "")
        SetFloat("savegame.mod.nextbot_extra.speed", speed/5000)
    UiPop()
    UiPush()
        UiAlign("right middle")
        UiTranslate(UiCenter()-200, UiMiddle()+50)
        UiText("Nextbot max distance view:")
        UiTranslate(100, 0)
        UiAlign("left middle")
        UiColor(1, 1, 1,0.5)
        UiRect(200, 3)
        UiColor(1, 1, 1,1)
        UiAlign("center middle")
        maxDist = math.floor(UiSlider("ui/common/dot.png", "x", maxDist, 1, 200))
        UiAlign("left middle")
        UiTranslate(210, 0)
        UiText(maxDist .. "m")
        SetFloat("savegame.mod.nextbot_extra.maxdist", maxDist)
    UiPop()

    UiPush()
    UiAlign("center middle")
    UiTranslate(UiCenter(), UiMiddle()+100)
    if UiTextButton("Use sounds/music: " .. tostring(useMusic)) then
        if(useMusic) then
            useMusic = false
        else
            useMusic = true
        end
        SetBool("savegame.mod.nextbot_extra.music", useMusic)
    end
    UiPop()

    UiPush()
    UiAlign("center middle")
    UiTranslate(UiCenter(), UiMiddle()+150)
    if UiTextButton("Bot Dies: " .. tostring(canDie)) then
        if(canDie) then
            canDie = false
        else
            canDie = true
        end
        SetBool("savegame.mod.nextbot_extra.candie", canDie)
    end
    UiPop()

    UiPush()
    UiAlign("center middle")
    UiTranslate(UiCenter(), UiMiddle()+200)
    if UiTextButton("Reset") then
        speed = 0.0092*5000
        maxDist = 64
        useMusic = false
        canDie = false
    end
    UiPop()
end