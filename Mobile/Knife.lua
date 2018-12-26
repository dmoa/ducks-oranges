Knife = {}
canchangescore = true
Knife.new = function()
  local self = {}

  self.x = WW / 2 - (knifeImg:getWidth() / 2)
  self.y = WH - knifeImg:getHeight() - 10
  self.yv = 0

  self.draw = function()
    love.graphics.draw(knifeImg, self.x, self.y)
  end

  self.update = function(dt)
    self.y = self.y + (self.yv * dt)
    if self.y < - 150 then
      self.y = WH - knifeImg:getHeight() - 10
      self.yv = 0
      canchangescore = true
    end
    if self.y < orange.y and canchangescore then
      canchangescore = false
      score = score + 1
      love.audio.play(shootSound)
      mainText:setf(score, love.graphics.getWidth(), "left")
      if score % 3 == 0 then
        if maxDucks > activeDucks then
          lotsofducks[activeDucks + 1].xv = love.math.random(200, 400)
          lotsofducks[activeDucks + 1].onScreen = true
          activeDucks = activeDucks + 1
        else
          temporaryindex = love.math.random(1, maxDucks)
          lotsofducks[temporaryindex].xv = lotsofducks[temporaryindex].xv * 1.5
        end
      end

      return self
    end
