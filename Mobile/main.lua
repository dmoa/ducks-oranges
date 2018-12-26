require("Knife")
require("bg")
require("Orange")
require("Duck")
function love.load()

  WW = love.graphics.getWidth()
  WH = love.graphics.getHeight()

  waterTile = love.graphics.newImage("img/waterTile.png")
  waterTile2 = love.graphics.newImage("img/waterTile2.png")
  waterTile3 = love.graphics.newImage("img/waterTile3.png")
  waterTilesW = math.ceil(WW / waterTile:getWidth())
  waterTilesH = math.ceil(WH / waterTile:getHeight())

  backgroundTileSetup()
  timeLeftForTileSwitch = 2

  knifeImg = love.graphics.newImage("img/knife.png")
  knife = Knife.new()

  orangeImg = love.graphics.newImage("img/orange.png")
  orangeExplodedImg = love.graphics.newImage("img/orangeExploded.png")
  orange = Orange.new()

  lotsofducks = {}
  duckLeftImg = love.graphics.newImage("img/duckLeft.png")
  duckRightImg = love.graphics.newImage("img/duckRight.png")
  explodedDuckLeftImg = love.graphics.newImage("img/duckExplodedLeft.png")
  explodedDuckRightImg = love.graphics.newImage("img/duckExplodedRight.png")

  activeDucks = 0
  maxDucks = math.floor((WH - (orangeImg:getHeight()) - knifeImg:getHeight() - 10 - 25) / (duckLeftImg:getHeight() + (WH / 10 - duckLeftImg:getHeight())))

  for i = 1, maxDucks do
    lotsofducks[i] = Duck.new((WH / 10 * (i - 1)) + WH / 5, 0, i)
  end

  playingGame = false
  gameTransitioning = false
  timeLeftForTransition = 1

  score = 0

  defaultfont = love.graphics.newFont("default.ttf", 100)
  defaultfont:setFilter("nearest", "nearest")
  mainText = love.graphics.newText(defaultfont, score)

  shootSound = love.audio.newSource("hit.wav", "static")
  loseSound = love.audio.newSource("lose.wav", "static")
end

function love.touchpressed()
  clickReaction()
end

function love.keypressed(key, unicode)
  if key == "space" then
    clickReaction()
  end
end

function love.draw()
  drawBackground()
  orange.draw()
  drawText()
  knife.draw()
  drawAllDucks()
end

function love.update(dt)
  timeLeftForTileSwitch = timeLeftForTileSwitch - dt
  if timeLeftForTileSwitch < 0 then
    tileFlip()
    timeLeftForTileSwitch = 2
  end
  knife.update(dt)
  orange.update()
  updateAllDucks(dt)

  if gameTransitioning then
    timeLeftForTransition = timeLeftForTransition - dt
  end
  if timeLeftForTransition < 0 then
    gameContinue()
    gameTransitioning = false
    timeLeftForTransition = 1
  end
end

function clickReaction()
  if playingGame then
    if not gameTransitioning then
      knife.yv = -400
    end
  else
    lotsofducks[1].xv = 200
    lotsofducks[1].onScreen = true
    activeDucks = 1
  end
  playingGame = true
  mainText:setf(score, love.graphics.getWidth(), "left")
end

function gameRestart()
  gameTransitioning = true
  for k, v in pairs(lotsofducks) do
    lotsofducks[k].y = (WH / 10 * (k - 1)) + WH / 5
    lotsofducks[k].x = -200
    lotsofducks[k].xv = 0
    lotsofducks[k].onScreen = false
  end
  knife.yv = 0

  score = 0
  mainText:setf(score, love.graphics.getWidth(), "left")
  activeDucks = 0
  love.audio.play(loseSound)
end

function gameContinue()
  knife.x = WW / 2 - (knifeImg:getWidth() / 2)
  knife.y = WH - knifeImg:getHeight() - 10
  for k, v in pairs(lotsofducks) do
    lotsofducks[k].y = (WH / 10 * (k - 1)) + WH / 5
    lotsofducks[k].x = -200
    lotsofducks[k].xv = 0
    lotsofducks[k].onScreen = false
    lotsofducks[k].exploded = false
  end
  lotsofducks[1].xv = 200
  lotsofducks[1].onScreen = true
  activeDucks = 1
end

function drawText()
  love.graphics.draw(mainText, love.graphics.getWidth() / 2 - mainText:getWidth() / 2,
  love.graphics.getHeight() / 2 - mainText:getHeight() / 2)
end
