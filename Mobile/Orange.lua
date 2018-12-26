Orange = {}
Orange.new = function()
  local self = {}

  self.x = WW / 2 - (orangeImg:getWidth() / 2)
  self.y = WH / 20
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
