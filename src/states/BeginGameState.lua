--[[
    NUTCRACKER

    -- BeginGameState Class --

    Brief stage of game between Start and Play, when gameplay is visible and the level drops down.
]]

BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()
    
    -- start our transition alpha at full, so we fade in
    self.transitionAlpha = 255

    -- start our level # label off-screen
    self.levelLabelY = -300
end

function BeginGameState:enter(def)
     print("new game start")
    -- grab level # from the def we're passed
    self.level = def.level

    -- spawn a board and place it toward the right
    self.board = Board(40, 16, self.level)

    --if no potential matches
    while not self.board:calculatePotentialMatches() and not self.board:calculateMatches() do
        print("no matches, regenerate board")
        self.board = Board(40, 16, self.level)
    end

    --
    -- animate our white screen fade-in, then animate a drop-down with
    -- the level text
    --

    -- first, over a period of 1 second, transition our alpha to 0
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    
    -- once that's finished, start a transition of our text label to
    -- the center of the screen over 0.25 seconds
    :finish(function()
        Timer.tween(0.25, {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 180}
        })
        
        -- after that, pause for one second with Timer.after
        :finish(function()
            Timer.after(2, function()
                
                -- then, animate the label going down past the bottom edge
                Timer.tween(0.25, {
                    [self] = {levelLabelY = VIRTUAL_HEIGHT + 50}
                })
                
                -- once that's complete, we're ready to play!
                :finish(function()
                    gStateMachine:change('play', {
                        level = self.level,
                        board = self.board
                    })
                end)
            end)
        end)
    end)
end

function BeginGameState:update(dt)
    Timer.update(dt)
end

function BeginGameState:render()
    
    -- render board of tiles
    --self.board:render()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['level'], 360, self.levelLabelY)

    love.graphics.setColor(255, 209, 98, 255) --tan
    love.graphics.setFont(gFonts['titlelarge'])
    love.graphics.printf('Level ' .. tostring(self.level),
        0, self.levelLabelY + 130, VIRTUAL_WIDTH, 'center')


    --[[ render Level # label and background rect
    love.graphics.setColor(95, 205, 228, 200)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level),
        0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

    -- our transition foreground rectangle
    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)]]
end