--[[
###############################################################################
##	Mike Ziray
##	LTZLLC.com
##	LTZ, LLC
##
###############################################################################
]]--

module(..., package.seeall)

require("DisplayController")
require("GameStats")
require("GameClock")
require("InputController")

require("LevelLoader")

local now
local elapsed

--=====================================================================================--
--== GAME EVENT LOOP ==================================================================--
--=====================================================================================--
local function gameEventLoop(event)

	local currentTime = GameClock:getCurrentTime()
	elapsed = currentTime - now
	now = currentTime
	
	local fps = math.floor(1000/elapsed)
	DisplayController:setTextDebugTwo( "FPS: ".. fps  )
	
	local tilt = OrientationController:getCurrentY()
	
	
	local yPosition = 140
	
	if( tilt ~= nil ) then

		if( tilt > 0 ) then
			yPosition = 240 - tilt * 240
		else
			yPosition = 240 + (tilt * 240) * -1
		end
	end
	yPosition = math.ceil(yPosition )
	DisplayController:setTextDebugOne( "Orient: "..  yPosition )
	
end


--=====================================================================================--
--== DISPLAY MAIN SCREEN ==============================================================--
--=====================================================================================--
function GameController:main( )
	
	DisplayController:showBackground( "Background.png" )
	
	-------------------------------------------------------
	-- Display title --------------------------------------
	-------------------------------------------------------
	local titleText = "LTZLLC.com Game Template"
	
	local titleShadow = display.newText(titleText, 92, 174, nil, 24)
	titleShadow:setTextColor( 20, 20, 20)
	titleShadow.rotation = 90
	titleShadow.alpha = .6
	
	local title = display.newText(titleText, 95, 170, nil, 24)
	title:setTextColor( 255, 255, 255)
	title.rotation = 90

	
	-------------------------------------------------------
	-- Display and set up main menu buttons ---------------
	-------------------------------------------------------
	local buttons = DisplayController:createMainMenu()
	--DisplayController:hideMainMenu()
	DisplayController:showMainMenu()
	
	buttons.start:addEventListener("tap", loadStartGameScreen )
	buttons.options:addEventListener("tap", loadOptionsScreen )
	buttons.credits:addEventListener("tap", loadCreditsScreen )


end


--=====================================================================================--
--== LOAD START GAME SCREEN ===========================================================--
--=====================================================================================--
function GameController:loadStartGameScreen( touchEvent )
	print("-------------------------------------------------")
	DisplayController:hideMainMenu()
	beginGameSequence()
end


--=====================================================================================--
--== LOAD OPTIONS SCREEN ==============================================================--
--=====================================================================================--
function GameController:loadOptionsScreen( touchEvent )
	print("Loaded options screen!!")
	DisplayController:hideMainMenu()
end


--=====================================================================================--
--== LOAD CREDITS SCREEN ==============================================================--
--=====================================================================================--
function GameController:loadCreditsScreen( touchEvent )
	print("Loaded credits screen!!")
	DisplayController:hideMainMenu()
end


--=====================================================================================--
--== BEGIN GAME SEQUENCE ==============================================================--
--=====================================================================================--
function GameController:beginGameSequence()
	
	-- Load level
	loadLevel()
	DisplayController:showBackground( level.levelInfo.bgimage..".png" )
	
	
	if( isDebugMode == true ) then
		DisplayController:showDebugOutput()
	end

	
	-- Start game clock
	GameClock:beginGameClock()
	now = GameClock:getCurrentTime()
	
	-- Turn on inputs
	InputController:turnOnInputs()
	
	
	-- Initialize the level here, drawing background, loading music, etc
	
	
	-- Run game loop
	Runtime:addEventListener( "enterFrame", gameEventLoop )
end


--=====================================================================================--
--== LOAD LEVEL =======================================================================--
--=====================================================================================--
function GameController:loadLevel()
	
	level = LevelLoader:loadLevel( GameStats:getCurrentLevelNumber() )
end




