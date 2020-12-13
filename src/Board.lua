--[[
    NUTCRACKER

    -- Board Class --

    Represents arrangement of sprites on a grid, responsible for keeping track of locations,
    calculating matches and possible matches
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}
    self.level = level

    self.possibleTiles = {}

    self:calculatePossibleTiles()
    self:initializeTiles()
end

function Board:calculatePossibleTiles()
    if self.level == 1 then
        table.insert(self.possibleTiles, {1, 1})
        table.insert(self.possibleTiles, {1, 3})
        table.insert(self.possibleTiles, {1, 6})
        table.insert(self.possibleTiles, {1, 7})
    end

    if self.level == 2 then
        table.insert(self.possibleTiles, {1, 1})
        table.insert(self.possibleTiles, {1, 3})
        table.insert(self.possibleTiles, {1, 5})
        table.insert(self.possibleTiles, {1, 6})
        table.insert(self.possibleTiles, {1, 7})
    end

    if self.level == 3 then
        table.insert(self.possibleTiles, {1, 1})
        table.insert(self.possibleTiles, {1, 3})
        table.insert(self.possibleTiles, {1, 5})
        table.insert(self.possibleTiles, {1, 6})
        table.insert(self.possibleTiles, {1, 7})
        table.insert(self.possibleTiles, {2, 6})
        table.insert(self.possibleTiles, {2, 7})
    end

    --[[if self.level = 4 then
        (1, 1)
        (1, 2)  --NEW
        (1, 3)
        (1, 5) 

        (1, 6)
        (1, 7)
        (2, 6)
        (2, 7)  --NEW!
    end]]
end

function Board:initializeTiles()
    self.tiles = {}

    --[[self.possibleColors = {}
    for i = 1, 12 do
        table.insert(self.possibleColors, math.random(18))
    end]]

    for tileY = 1, 6 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            -- create a new tile at X,Y with a random color and variety dependent on level
            shiny = math.random(40) == 1 and true or false
        
            --mini table containing tileRow and Col in spritesheet
            local tile = self.possibleTiles[math.random(#self.possibleTiles)] 

            table.insert(self.tiles[tileY], Tile(tileX, tileY, tile[1], 
                    tile[2], shiny))

            --[[
            tilerow = math.random(4)
            tilecol = math.random(7)
            if self.level < 7 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, tilerow, 
                    tilecol, shiny))
            else
                table.insert(self.tiles[tileY], Tile(tileX, tileY, tilerow, 
                    tilecol, shiny))
            end
            print("inserted new tile from " ..tostring(tilerow)..tostring(tilecol))]]
        end
    end

    while self:calculateMatches() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1
    local hasShiny = false

    -- horizontal matches first
    for y = 1, 6 do
        local rowToMatch = self.tiles[y][1].row
        local colToMatch = self.tiles[y][1].col

        matchNum = 1
        -- set shiny flag to whatever first block is
        hasShiny = self.tiles[y][1].shiny

        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].row == rowToMatch and self.tiles[y][x].col == colToMatch then
                matchNum = matchNum + 1

                 --if tile is shiny
                if self.tiles[y][x].shiny then
                    hasShiny = true
                end

            else
                
                -- set this as the new row we want to watch for
                rowToMatch = self.tiles[y][x].row
                colToMatch = self.tiles[y][x].col

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    if hasShiny then --shiny match
                        for x2 = 8, 1, -1 do
                            --add entire row as match
                            table.insert(match, self.tiles[y][x2])
                        end
                        break --restart, dont need to check remaining x in row
                    else --normal match

                        -- if it's a shelled nut, switch sprites 
                        if self.tiles[y][x-1].row == 1 and self.tiles[y][x-1].col >= 1 and self.tiles[y][x-1].col <= 5 then
                            
                            print("shelled nut")

                            -- go backwards from here by matchNum
                            for x2 = x - 1, x - matchNum, -1 do
                                self.tiles[y][x2].row = math.random(2, 4)
                            end
                        else
                            -- add match
                            -- go backwards from here by matchNum
                            for x2 = x - 1, x - matchNum, -1 do
                                -- add each tile to the match that's in that match
                                table.insert(match, self.tiles[y][x2])
                            end
                        end
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                    --[[
                    print("match x values")
                    print(match[1].gridX)
                    print(match[2].gridX)
                    print(match[3].gridX)]]
                end

                matchNum = 1
                hasShiny = self.tiles[y][x].shiny

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for match at end of row
        if matchNum >= 3 then
            local match = {}
            
            if hasShiny then --shiny match
                for x = 8, 1, -1 do
                    --add entire row as match
                    table.insert(match, self.tiles[y][x])
                end
            else
                if self.tiles[y][8].row == 1 and self.tiles[y][8].col >= 1 and self.tiles[y][8].col <= 5 then
                            
                    print("shelled nut")
                    
                    -- go backwards from here by matchNum
                    for x = 8, 8 - matchNum + 1, -1 do
                        self.tiles[y][x].row = math.random(2, 4)
                    end
                else
                    -- go backwards from end of last row by matchNum
                    for x = 8, 8 - matchNum + 1, -1 do
                        table.insert(match, self.tiles[y][x])
                    end
                end
            end

            
            table.insert(matches, match)
            --[[
            print("match x values")
            print(match[1].gridX)
            print(match[2].gridX)
            print(match[3].gridX)]]
        end
    end

    -- vertical matches
    for x = 1, 6 do
        local rowToMatch = self.tiles[1][x].row
        local colToMatch = self.tiles[1][x].col

        matchNum = 1
        --set shiny flag to whatever first block is
        hasShiny = self.tiles[1][x].shiny


        -- every vertical tile
        for y = 2, 6 do
            if self.tiles[y][x].row == rowToMatch and self.tiles[y][x].col == colToMatch then
                matchNum = matchNum + 1
                --if tile is shiny, flag match as shiny
                if self.tiles[y][x].shiny then
                    hasShiny = true
                end
            else
                rowToMatch = self.tiles[y][x].row
                colToMatch = self.tiles[y][x].col

                if matchNum >= 3 then
                    local match = {}

                    if hasShiny then --shiny match
                        for y2 = 6, 1, -1 do
                            --add entire column as match
                            table.insert(match, self.tiles[y2][x])
                        end
                        break --restart; dont need to check remaining y in column
                    else
                        if self.tiles[y-1][x].row == 1 and self.tiles[y-1][x].col >= 1 and self.tiles[y-1][x].col <= 5 then
                            
                            print("shelled nut")
                            
                            -- go backwards from here by matchNum
                            for y2 = y - 1, y - matchNum, -1 do
                                self.tiles[y2][x].row = math.random(2, 4)
                            end
                        else
                            for y2 = y - 1, y - matchNum, -1 do
                                table.insert(match, self.tiles[y2][x])
                            end
                        end
                    end

                    table.insert(matches, match)
                    --[[
                    print("match x values")
                    print(match[1].gridX)
                    print(match[2].gridX)
                    print(match[3].gridX)]]
                end

                matchNum = 1
                hasShiny = self.tiles[y][x].shiny

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for match at the bottom of a column
        if matchNum >= 3 then
            local match = {}
            
            if hasShiny then --shiny match
                for y = 6, 1, -1 do
                    --add entire row as match
                    table.insert(match, self.tiles[y][x])
                end
            else
                if self.tiles[6][x].row == 1 and self.tiles[6][x].col >= 1 and self.tiles[6][x].col <= 5 then
                            
                    print("shelled nut")
                    
                    -- go backwards from here by matchNum
                    for y = 6, 6 - matchNum, -1 do
                        print(y)
                        self.tiles[y][x].row = math.random(2, 4)
                    end
                else
                    -- go backwards from end of last row by matchNum
                    for y = 6, 6 - matchNum, -1 do
                        print(y)
                        table.insert(match, self.tiles[y][x])
                    end
                end
            end

            table.insert(matches, match)
            --[[
            print("match x values")
            print(match[1].gridX)
            print(match[2].gridX)
            print(match[3].gridX)]]
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 6
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 90 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 90
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 6, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile dependent on level
                
                shiny = math.random(40) == 1 and true or false

                --mini table containing tileRow and Col in spritesheet
                local tileXY = self.possibleTiles[math.random(#self.possibleTiles)] 
                local tile = Tile(x, y, tileXY[1], tileXY[2], shiny)

                

                --[[
                if self.level < 7 then
                    tile = Tile(x, y, math.random(4), math.random(7), shiny)
                else
                    tile = Tile(x, y, math.random(4), math.random(7), shiny)
                end]]

                tile.y = -90
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 90
                }
            end
        end
    end

    return tweens
end

--[[
    Calculate if potential matches exist
]]
function Board:calculatePotentialMatches()
    --for every tile on board, "pretend" swap with adjacent tiles
    local hasPotentialMatch = false
    for y = 1, 6 do
        for x = 1, 8 do
            local currentTile = self.tiles[y][x]
            local tempX = currentTile.gridX
            local tempY = currentTile.gridY
            local newTile

            --try swapping up
            if y > 1 then 
                newTile = self.tiles[y-1][x]  --tile to swap with
                --if swap results in match, return true
                if self:trySwap(currentTile, tempX, tempY, newTile) then
                    --[[
                    print("swap from")
                    print(tempY)
                    print(tempX)
                    print(currentTile.row)
                    print("to")
                    print(newTile.gridY)
                    print(newTile.gridX)
                    print(newTile.row)]]
                    return true
                end
            end

             --swap down
            if y < 6 then  
                newTile = self.tiles[y+1][x]
                --if swap results in match, return true
                if self:trySwap(currentTile, tempX, tempY, newTile) then
                    --[[
                    print("swap from")
                    print(tempY)
                    print(tempX)
                    print(currentTile.row)
                    print("to")
                    print(newTile.gridY)
                    print(newTile.gridX)
                    print(newTile.row)]]
                    return true
                end
            end

            --swap left
            if x > 1 then   
                newTile = self.tiles[y][x-1]
                --if swap results in match, return true
                if self:trySwap(currentTile, tempX, tempY, newTile) then
                    --[[
                    print("swap from")
                    print(tempY)
                    print(tempX)
                    print(currentTile.row)
                    print("to")
                    print(newTile.gridY)
                    print(newTile.gridX)
                    print(newTile.row)]]
                    return true
                end
            end

            --swap right
            if x < 8 then   
                newTile = self.tiles[y][x+1]
                --if swap results in match, return true
                if self:trySwap(currentTile, tempX, tempY, newTile) then
                    --[[print("swap from")
                    print(tempY)
                    print(tempX)
                    print(currentTile.row)
                    print("to")
                    print(newTile.gridY)
                    print(newTile.gridX)
                    print(newTile.row)]]
                    return true
                end
            end
        end
    end
    return false
end

--[[test if a swap results in a match]]
function Board:trySwap(currentTile, tempX, tempY, newTile)
    local potential = false

    currentTile.gridX = newTile.gridX
    currentTile.gridY = newTile.gridY
    newTile.gridX = tempX
    newTile.gridY = tempY

    self.tiles[currentTile.gridY][currentTile.gridX] = currentTile
    self.tiles[newTile.gridY][newTile.gridX] = newTile

    --if no matches result from this swap, revert back
    if not self:calculateMatches() then
        potential = false
    --if a match does result from this swap, return true
    else
        potential = true
    end

    --revert back to old gridX and gridY
    newTile.gridX = currentTile.gridX
    newTile.gridY = currentTile.gridY
    currentTile.gridX = tempX
    currentTile.gridY = tempY
    --revert positions in tiles table
    self.tiles[currentTile.gridY][currentTile.gridX] = currentTile
    self.tiles[newTile.gridY][newTile.gridX] = newTile

    return potential
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end