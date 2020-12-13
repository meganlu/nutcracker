--[[
    NUTCRACKER

    -- Tile Class --

    Individual tile sprites that make up the board. Keeps track of location of tile and its shinyness
]]

Tile = Class{}

function Tile:init(x, y, row, col, shiny)
    
    -- board positions
    self.gridX = x                 
    self.gridY = y

    -- coordinate positions on board
    self.x = (self.gridX - 1) * 70
    self.y = (self.gridY - 1) * 90

    -- location on spritesheet
    self.row = row                  
    self.col = col

    --tile bonus
    self.shiny = shiny
end

function Tile:render(x, y)
    
    --[[ draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.row][self.col],
        self.x + x + 2, self.y + y + 2)
    ]]

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.row][self.col],
        self.x + x, self.y + y)
    --print("quad: " ..tostring(gFrames['tiles'][self.row][self.col]))

     -- draw shinyness
    if self.shiny then
        love.graphics.draw(gTextures['shiny'], self.x + x, self.y + y)
    end
end