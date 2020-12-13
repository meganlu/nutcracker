--[[
    NUTCRACKER

    -- Dependencies --

    Organizes all needed classes and files
]]

--
-- libraries
--
Class = require 'lib/class'

push = require 'lib/push'

-- used for timers and tweening
Timer = require 'lib/knife.timer'

--
-- our own code
--

-- utility
require 'src/StateMachine'
require 'src/Util'

-- game pieces
require 'src/Board'
require 'src/Tile'

-- game states
require 'src/states/BaseState'
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/StartState'

gSounds = {
    ['music'] = love.audio.newSource('sounds/music3.mp3'),
    ['select'] = love.audio.newSource('sounds/select.wav'),
    ['error'] = love.audio.newSource('sounds/error.wav'),
    ['match'] = love.audio.newSource('sounds/match.wav'),
    ['clock'] = love.audio.newSource('sounds/clock.wav'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav')
}

gTextures = {
    ['main'] = love.graphics.newImage('graphics/blocks.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['shiny'] = love.graphics.newImage('graphics/shiny.png'),
    ['tree'] = love.graphics.newImage('graphics/tree.png'),
    ['signs'] = love.graphics.newImage('graphics/signs.png'),
    ['title'] = love.graphics.newImage('graphics/title.png'),
    ['level'] = love.graphics.newImage('graphics/levellabel.png')
}

gFrames = {
    
    -- divided into sets for each tile type in this game, instead of one large
    -- table of Quads
    ['tiles'] = GenerateTileQuads(gTextures['main'])
}

-- this time, we're keeping our fonts in a global table for readability
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),

    ['titlelarge'] = love.graphics.newFont('fonts/grinched.otf', 90),
    ['titlesmall'] = love.graphics.newFont('fonts/grinched.otf', 55),
    ['textlarge'] = love.graphics.newFont('fonts/lemonjuice.otf', 65),
    ['textsmall'] = love.graphics.newFont('fonts/lemonjuice.otf', 45)
}