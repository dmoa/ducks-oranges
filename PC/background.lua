function backgroundTileSetup()
  waterGrid = {}
  for j = 1, waterTilesH do
    waterGrid[j] = {}
    for i = 1, waterTilesW do
      waterGrid[j][i] = math.random(1, 3)
    end
  end
end

function tileFlip()
  for j = 1, waterTilesH do
    for i = 1, waterTilesW do
      if waterGrid[j][i] == 1 then
        waterGrid[j][i] = 2
        else if waterGrid[j][i] == 2 then
          waterGrid[j][i] = 3
        else
          waterGrid[j][i] = 1
        end
      end
    end
  end
end

function drawBackground()
  for j = 1, waterTilesH do
    for i = 1, waterTilesW do
      if waterGrid[j][i] == 1 then
        love.graphics.draw(waterTile, (i - 1) * waterTile:getWidth(), (j - 1) * waterTile:getHeight())
        else if waterGrid[j][i] == 2 then
          love.graphics.draw(waterTile2, (i - 1) * waterTile:getWidth(), (j - 1) * waterTile:getHeight())
        else
          love.graphics.draw(waterTile3, (i - 1) * waterTile:getWidth(), (j - 1) * waterTile:getHeight())
        end
      end
    end
  end
end
