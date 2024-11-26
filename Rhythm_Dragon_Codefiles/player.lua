---@diagnostic disable: undefined-global
require "bullet"
require "main"
require "enemy"
local audio = require "wave"
local shootSound = audio:newSource("sounds/shoot.wav", "static")
shootSound:setOffset(150)
Player = Object:extend()

function Player:new()
    self.image = love.graphics.newImage("player-assets/cannon.png")
    self.x = (love.graphics.getWidth() / 2) - 70
    self.y = love.graphics.getHeight() - 175
    self.height = self.image:getHeight() * 0.1
    self.width = self.image:getWidth() * 0.1
    self.dead = false
end

function Player:update(dt)
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 0.1, 0.1)
end

