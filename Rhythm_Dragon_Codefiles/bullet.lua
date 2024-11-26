Bullet = Object:extend()

function Bullet:new(x, y)
    self.image = "fill"
    self.x = x + 65
    self.y = y - 65
    self.speed = 7000
end


function Bullet:draw()
    love.graphics.circle(self.image, self.x, self.y, 10)
end


