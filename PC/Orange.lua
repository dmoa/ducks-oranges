Orange = {}
Orange.new = function()
  local self = {}

  self.x = windowWidth / 2 - (orangeImg:getWidth() / 2)
  self.y = 50
  self.yv = 0
  self.exploded = false

  self.draw = function()
    if self.exploded then
      love.graphics.draw(orangeExplodedImg, self.x, self.y)
    else
      love.graphics.draw(orangeImg, self.x, self.y)
    end
  end

  self.update = function()
    if knife.y < self.y then
      self.exploded = true
    else
      self.exploded = false
    end
  end

  return self
end
