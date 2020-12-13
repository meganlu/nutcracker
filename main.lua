--[[
    NUTCRACKER

    Megan Lu

    
    Match-3 style game where player matches various types of nuts and seeds. 
    Some nuts (such as acorns and walnuts) are multi-layered, and may be cracked
    apart into the inner layer by matching. For example, brown acorns can be 
    matched with other brown acorns, and eacb will subsequently shed its outer 
    shell to reveal 1 of 3 types of inner acorn varieties. 
    As levels increase, more types of nuts and seeds become available to crack.
    When no matches are left on the board, the board will regenerate.

    All sprites, backgrounds, and UI were designed and illustrated in Adobe Photoshop.

    Music credit: http://freemusicarchive.org/music/RoccoW/
]]

-- initialize our nearest-neighbor filter
love.graphics.setDefaultFilter('nearest', 'nearest')

-- this time, we're keeping all requires and assets in our Dependencies.lua file
require 'src/Dependencies'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 1024
VIRTUAL_HEIGHT = 576

-- speed at which our background texture will scroll
BACKGROUND_SCROLL_SPEED = 100

function love.load()
    
    -- window bar title
    love.window.setTitle('Match 3')

    -- seed the RNG
    math.randomseed(os.time())

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    -- set music to loop and start
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    -- keep track of scrolling our background on the X axis
    backgroundX = 0

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    
    -- scroll background, used across all states
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt
    
    -- if we've scrolled the entire image, reset it to 0
    if backgroundX <= -900 then -- -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- scrolling background drawn behind every state
    love.graphics.draw(gTextures['background'], backgroundX, 0)
    love.graphics.draw(gTextures['tree'], VIRTUAL_WIDTH - 377)
    
    gStateMachine:render()
    push:finish()
end