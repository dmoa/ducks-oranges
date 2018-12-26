Duck = {}
Duck.new = function(y, speed, index)
  local self = {}
  self.x = -200
  self.y = y
  self.xv = speed
  self.onScreen = false
  self.exploded = false

  --shush
  self.killedx = 0
  self.killedxv = 0

  self.draw = function()
    if not self.exploded then
      if self.xv > 0 then
        love.graphics.draw(duckRightImg, self.x, self.y)
      else
        love.graphics.draw(duckLeftImg, self.x, self.y)
      end
    else
      if self.killedxv < 0 then
        love.graphics.draw(explodedDuckLeftImg, self.x, self.y)
      else
        love.graphics.draw(explodedDuckRightImg, self.x, self.y)
      end
    end
  end

  self.update = function(dt)
    self.x = self.x + (self.xv * dt)
    if self.x + duckLeftImg:getWidth() > windowWidth or self.x < 0 then
      if self.onScreen then
        self.xv = self.xv * - 1
      end
    else
      self.onScreen = true
    end
    if knife.y < self.y + duckLeftImg:getHeight() and knife.y > self.y and
    knife.x + knifeImg:getWidth() > self.x and knife.x < self.x + duckLeftImg:getWidth() and not gameTransitioning then
      self.killedx = self.x
      self.killedxv = self.xv
      gameRestart()
      self.x = self.killedx
      self.onScreen = true
      self.exploded = true
    end
  end

  return self
end


function updateAllDucks(dt)
  for k, v in pairs(lotsofducks) do
    lotsofducks[k].update(dt)
  end
end

function drawAllDucks()
  for k, v in pairs(lotsofducks) do
    lotsofducks[k].draw()
  end
end
