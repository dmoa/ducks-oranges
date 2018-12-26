require("background")
require("Duck")
require("Knife")
require("Orange")
function love.load()
  love.window.setFullscreen(true)

  love.mouse.setVisible(false)

  windowWidth = love.graphics.getWidth()
  windowHeight = love.graphics.getHeight()

  waterTile = love.graphics.newImage("img/waterTile.png")
  waterTile2 = love.graphics.newImage("img/waterTile2.png")
  waterTile3 = love.graphics.newImage("img/waterTile3.png")
  waterTilesW = math.ceil(windowWidth / waterTile:getWidth())
  waterTilesH = math.ceil(windowHeight / waterTile:getHeight())

  backgroundTileSetup()
  timeLeftForTileSwitch = 2

  knifeImg = love.graphics.newImage("img/knife.png")
  knife = Knife.new()

  orangeImg = love.graphics.newImage("img/orange.png")
  orangeExplodedImg = love.graphics.newImage("img/explodedOrange.png")
  orange = Orange.new()

  duckLeftImg = love.graphics.newImage("img/duckLeft.png")
  duckRightImg = love.graphics.newImage("img/duckRight.png")
  explodedDuckLeftImg = love.graphics.newImage("img/duckExplodedLeft.png")
  explodedDuckRightImg = love.graphics.newImage("img/duckExplodedRight.png")

  timeLeftForTransition = 1
  gameTransitioning = false

  lotsofducks = {}

  activeDucks = 0
  maxDucks = 8

  for i = 1, maxDucks do
    lotsofducks[i] = Duck.new((i + 2) * 100, 0, i)
  end

  shootSound = love.audio.newSource("hit.wav", "static")
  loseSound = love.audio.newSource("lose.wav", "static")

  defaultfont = love.graphics.newFont("default.ttf", 100)
  defaultfont:setFilter("nearest", "nearest")
  mainText = love.graphics.newText(defaultfont, "PRESS SPACEBAR TO START")

  exitFont = love.graphics.newFont("default.ttf", 25)
  exitFont:setFilter("nearest", "nearest")
  exitText = love.graphics.newText(exitFont, "ESC TO EXIT")

  tutorialText = love.graphics.newText(exitFont, "SPACE TO SHOOT, AVOID THE DUCKS")

  score = 0

  playingGame = false

  firstTimePlaying = true
end

function love.keypressed(key, unicode)
  if key == "space" then
    spaceBarReaction()
  end
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  drawBackground()
  drawText()
  drawAllDucks()
  orange.draw()
  knife.draw()
end

function love.update(dt)

  if gameTransitioning then
    timeLeftForTransition = timeLeftForTransition - dt
    print("counting down")
  end
  if timeLeftForTransition < 0 then
    gameContinue()
    gameTransitioning = false
    timeLeftForTransition = 1
  end

  timeLeftForTileSwitch = timeLeftForTileSwitch - dt
  if timeLeftForTileSwitch < 0 then
    tileFlip()
    timeLeftForTileSwitch = 2
  end

  updateAllDucks(dt)
  knife.update(dt)
  orange.update()
end

function spaceBarReaction()
  if playingGame then
    if not gameTransitioning then
      knife.yv = -400
    end
  else
    lotsofducks[1].xv = 200
    activeDucks = 1
  end
  playingGame = true
  mainText:setf(score, love.graphics.getWidth(), "left")
end

function gameRestart()
  print("restarting")
  gameTransitioning = true
  for k, v in pairs(lotsofducks) do
    lotsofducks[k].y = (k + 2) * 100
    lotsofducks[k].x = -200
    lotsofducks[k].xv = 0
    lotsofducks[k].onScreen = false
  end
  knife.yv = 0
  score = 0
  mainText:setf(score, love.graphics.getWidth(), "left")
  firstTimePlaying = false
  activeDucks = 0
  love.audio.play(loseSound)
end

function gameContinue()
  knife.x = windowWidth / 2 - (knifeImg:getWidth() / 2)
  knife.y = windowHeight - knifeImg:getHeight() - 10
  for k, v in pairs(lotsofducks) do
    lotsofducks[k].y = (k + 2) * 100
    lotsofducks[k].x = -200
    lotsofducks[k].xv = 0
    lotsofducks[k].onScreen = false
    lotsofducks[k].exploded = false
  end
  lotsofducks[1].xv = 200
  activeDucks = 1
end


function drawText()
  love.graphics.setColor(0, 0, 0, 0.8)
  love.graphics.draw(mainText, love.graphics.getWidth() / 2 - mainText:getWidth() / 2,
  love.graphics.getHeight() / 2 - mainText:getHeight() / 2)
  if score < 3 and playingGame and firstTimePlaying then
    love.graphics.draw(tutorialText, love.graphics.getWidth() / 2 - tutorialText:getWidth() / 2 + 300,
    love.graphics.getHeight() / 2 - tutorialText:getHeight() / 2)
  end
  love.graphics.draw(exitText, 5, 5)
  love.graphics.setColor(1, 1, 1)
end
