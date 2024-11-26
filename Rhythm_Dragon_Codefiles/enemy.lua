require "bullet"
require "main"
Enemy = Object:extend()
Body = Object:extend()

math.randomseed(os.time())

local enemyBodies = {
    "dragon-assets/quarter.png",
    "dragon-assets/eighth.png",
    "dragon-assets/triplet.png",
    "dragon-assets/sixteenth.png"
}

local speed = 130
local xstart = 1000


function Enemy:new()
    self.image = love.graphics.newImage("dragon-assets/dragon_head.png")
    self.x = 1000
    self.y = 100
    self.speed = speed
    self.width = self.image:getWidth() * 0.3
    self.height = self.image:getHeight() * 0.3
end

function Enemy:update(dt)
    self.x = self.x - self.speed * dt

    if self.x < -100 then  
        self.image = love.graphics.newImage("dragon-assets/dragon_head.png")
        self.x = xstart
        self.y = self.y + 200
    end
end

function Enemy:draw()   
    love.graphics.draw(self.image, self.x, self.y, 0, 0.3, 0.3)
end

-- citing sheepolution for collision check logic
function Enemy:checkCollision(obj)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    if self_right > obj_left
    and self_left < obj_right
    and self_bottom > obj_top
    and self_top < obj_bottom then
        obj.dead = true
    end
end


function Body:new()
    local selectBody = 1
    if BodyPosition == 1 then
        selectBody = 1
        BodyPosition = BodyPosition + 1
    else
        selectBody = math.random(1, Level)
    end
    self.image = love.graphics.newImage(enemyBodies[selectBody])
    self.y = 100
    self.speed = speed
    self.x = EnemyBody
    self.width = (self.image:getWidth() * 0.043)
    self.height = self.image:getHeight() * 0.028
    self.hit = false
    if selectBody == 1 then
        self.id = 1
    elseif selectBody == 2 then
        self.id = 2
    elseif selectBody == 3 then
        self.id = 3
    elseif selectBody == 4 then
        self.id = 4
    end
    EnemyBody = EnemyBody + 150
end

function Body:update(dt)
    self.x = self.x - self.speed * dt

    if self.x < -100 then
        self.image = love.graphics.newImage(enemyBodies[self.id])
        self.hit = false
        self.x = xstart
        self.y = self.y + 200
    end
end

function Body:draw()
    if self.image ~= nil then
        if self.id == 1 then
            love.graphics.draw(self.image, self.x, self.y, 0, 0.043, 0.028) -- dimensions for quarters
        elseif self.id == 2 then
            love.graphics.draw(self.image, self.x, self.y, 0, 0.105, 0.074) -- dimensions for eighths
        elseif self.id == 3 then
            love.graphics.draw(self.image, self.x, self.y, 0, 0.134, 0.096) -- dimensions for triplets
        elseif self.id == 4 then
            love.graphics.draw(self.image, self.x, self.y, 0, 0.055, 0.048) -- dimensions for sixteenths
        end
    end
end

