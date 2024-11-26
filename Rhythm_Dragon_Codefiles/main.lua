---@diagnostic disable: lowercase-global, deprecated, duplicate-set-field
_G.love = require("love")
--io.stdout:setvbuf("no")

--local game_header


local audio = require "wave"
local background = love.audio.newSource("sounds/mountain-emperor.mp3", "stream")
local backgroundStart = 0
local roar = love.audio.newSource("sounds/dragon-roar.wav", "static")
local music = audio:newSource("sounds/woodblock.mp3", "stream")
local reload = love.audio.newSource("sounds/reload.mp3", "static")
local cheer = love.audio.newSource("sounds/cheer.wav", "static")
local shootSound = audio:newSource("sounds/shoot.wav", "static")
shootSound:setOffset(250)

local counts = 1
local countoff = {"4", "3", "2", "1"}
local font = nil
local onbeat = false
local timer = 0
local target = 1
local win = false
local lose = false
local newGame = true
local titleFont = nil
local hitPoints = 1
local startBpm = 60

EnemyBody = 1200
BodyPosition = 1
Button_Height = 64
Chamber = 0
BodyCount = 0
BulletTimer = 0
Level = 1


local game = {
    current_stage = {
        menu = true,
        running = false
    }
}

music:setBPM(startBpm)
music:onBeat(function()
    print("boom")
    timer = .55
    onbeat = true
    if game.current_stage["running"] then
        counts = counts + 1
    end
end)

local function newButton(text, func)
    return {
        text = text,
        func = func,
        now = false,
        last = false
    }
end
local buttons = {}

function love.load()
    font = love.graphics.newFont(32)
    titleFont = love.graphics.newFont(100)
    --game_header = love.graphics.newImage("images/rhythm-dragon.png")
    Object = require "classic"
    if game.current_stage["menu"] then
        table.insert(buttons, newButton(
            "Level One",
            function()
                game.current_stage.menu = false
                game.current_stage.running = true
                win = false
                lose = false
                Level = 1
                love.load()
            end))
        table.insert(buttons, newButton(
            "Level Two",
            function()
                game.current_stage.menu = false
                game.current_stage.running = true
                win = false
                lose = false
                Level = 2
                love.load()
            end))
        table.insert(buttons, newButton(
            "Level Three",
            function()
                game.current_stage.menu = false
                game.current_stage.running = true
                win = false
                lose = false
                Level = 3
                love.load()
            end))
        table.insert(buttons, newButton(
            "Level Four",
            function()
                game.current_stage.menu = false
                game.current_stage.running = true
                win = false
                lose = false
                Level = 4
                love.load()
            end))
        table.insert(buttons, newButton(
            "Exit",
            function()
                love.event.quit(0)
            end))    
    end
    if game.current_stage["running"] then
        music:play()
        background:seek(backgroundStart)
        background:play()
        require "player"
        require "enemy"
        require "bullet"
        
        player = Player()
        enemy = Enemy()
        body_table = {}
        for i = 1, 4 do
            body_table[i] = Body()
            Chamber = Chamber + body_table[i].id
        end
        BodyCount = #body_table
        listOfBullets = {}
        hitPoints = body_table[target].id
    end
    backgroundImage = love.graphics.newImage("background.jpg")
end



function love.keypressed(key)
    if counts > 4 and Chamber > 0 then
        if key == "space" then
            if Chamber > -1 then
                table.insert(listOfBullets, Bullet(player.x, player.y))
                Chamber = Chamber - 1
                BulletTimer = .3
                shootSound:play()
            end
            if onbeat == true and Chamber >= 0 then
                print("Match")
                hitPoints = hitPoints - 1
                print("current hitpoints after fire: " .. hitPoints)
                onbeat = false
            end
        end
    end
end

function love.update(dt)
    if game.current_stage["running"] == true then
        newGame = false
        enemy:checkCollision(player)
        if counts == 4 then
            startBpm = startBpm * body_table[target].id
            music:setBPM(startBpm)
        end
        BulletTimer = BulletTimer - dt
        timer = timer - dt
        if timer < 0 then
            onbeat = false
        end
        local hit_count = 1
        music:update(dt)
        player:update(dt)
        enemy:update(dt)
        for i = 1, 4 do
            body_table[i]:update(dt)
        end
        --citing steveEducation on follow logic for bullet tracking
        for i, v in ipairs(listOfBullets) do
            v.y = v.y - v.speed * dt
            if BulletTimer < .3 then
                if body_table[target].x - v.x > 0 then
                    v.x = v.x + dt*5000
                elseif body_table[target].x - v.x < 0 then
                    v.x = v.x - dt*5000
                end
                if body_table[target].y - v.y > 0 then
                    v.y = v.y + dt*5000
                elseif body_table[target].y - v.y < 0 then
                    v.y = v.y - dt*5000
                end
            end
            if BulletTimer < .26 then
                table.remove(listOfBullets, i)
            end
        end

        if hitPoints == 0 then
            body_table[target].hit = true
            body_table[target].image = nil
            if target < 4 then
                target = target + 1
            end
            startBpm = 60 * body_table[target].id
            music:setBPM(startBpm)
            hitPoints = body_table[target].id
            print("current target is: " .. target)
            print("new enemy hitPoints are: " .. hitPoints)
            print("current BPM is: " .. startBpm)
        end

        if body_table[1].x == 1000 then
            Chamber = 0
            for i = 1, 4 do
                Chamber = Chamber + body_table[i].id
            end
            reload:play()
        end

        if enemy.x == 1000 then
            startBpm = 60
            music:setBPM(startBpm)
            counts = 1
            hit_count = 1
            target = 1
            hitPoints = body_table[target].id
        end

        for i = 1, 4 do
            if body_table[i].hit == true then
                hit_count = hit_count + 1
            end
        end

        if hit_count > 4 then
            music:stop()
            background:stop()
            game.current_stage["menu"] = true
            game.current_stage["running"] = false
            EnemyBody = 1100
            BodyPosition = 1
            hit_count = 1
            target = 1
            counts = 1
            startBpm = 60
            music:setBPM(startBpm)
            win = true
            cheer:play()
        end

        if player.dead == true then
            music:stop()
            background:stop()
            game.current_stage["menu"] = true
            game.current_stage["running"] = false
            EnemyBody = 1100
            BodyPosition = 1
            hit_count = 1
            target = 1
            counts = 1
            startBpm = 60
            music:setBPM(startBpm)
            lose = true
            roar:play()
        end
    end
end

function love.draw()
    if game.current_stage["menu"] == true then
        if newGame == true then
            love.graphics.setColor(235, 52, 52, 1)
            love.graphics.print("Rhythm Dragon", titleFont, 150, 150)
        end
        
        if win == true then
            love.graphics.setColor(255, 255, 255, 1)
            love.graphics.print("You Win!", font, 400, 200)
        end

        if lose == true then
            love.graphics.setColor(235, 52, 52, 1)
            love.graphics.print("Game Over", font, 400, 200)
        end

        -- citing menu UI tutorial from SkyVaultGames for basic menu layout without library
        local windowWidth = love.graphics.getWidth()
        local windowHeight = love.graphics.getHeight()
        local button_width = windowWidth * .33
        local margin = 16
        local total_height = (Button_Height + margin) * #buttons
        local cursor_y = 0
        for i, button in ipairs(buttons) do
            button.last = button.now
            local button_x = (windowWidth * 0.5) - (button_width * 0.5)
            local button_y = (windowHeight * 0.5) - (total_height * 0.5) + cursor_y
            local color = {0.4, 0.4, 0.5, 1.0}
            local mx, my = love.mouse.getPosition()
            local hover = mx > button_x and mx < button_x + button_width and
                          my > button_y and my < button_y + Button_Height
            if hover then
                color = {0.8, 0.8, 0.8, 1}
            end
            button.now = love.mouse.isDown(1)
            if button.now and not button.last and hover then
                button.func()
            end
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle(
                "fill",
                (windowWidth * 0.5) - (button_width * 0.5),
                (windowHeight * 0.5) - (total_height * 0.5) + cursor_y,
                button_width,
                Button_Height
            )
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.print(
                button.text,
                font,
                button_x, 
                button_y
            )
            cursor_y = cursor_y + (Button_Height + margin)
        end
    end

    if game.current_stage["running"] == true then
        love.graphics.draw(backgroundImage, 0, 0, 0, 0.4, 0.3513703443429375)
        if counts < 5 then
            love.graphics.setColor(255, 255, 255, 1)
            love.graphics.print(countoff[counts], font, 500, 500)
        end
        if Chamber >= 0 then
            love.graphics.setColor(255, 255, 255, 1)
            love.graphics.print("Bullets: " .. Chamber, font, 825, 950)
        end
        if Chamber < 0 then
            love.graphics.setColor(255, 255, 255, 1)
            love.graphics.print("Bullets: " .. (Chamber + 1), font, 825, 950)
        end

        player:draw()
        enemy:draw()
        for i = 1, 4 do
            body_table[i]:draw()
        end
        love.graphics.setColor(255, 255, 255, 1)
        for i, v in ipairs(listOfBullets) do
            v:draw()
        end
    end 
end

function love.mousemoved(x, y, dx, dy, istouch)
end