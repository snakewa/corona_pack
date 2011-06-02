--[[
###############################################################################
##	Mike Ziray
##	LTZLLC.com
##	LTZ, LLC
##
###############################################################################
]]--


module(..., package.seeall)

local debugScreen
local debugOne
local debugTwo
local debugThree
local debugFour

local mainMenuDisplayGroup


--=====================================================================================--
--== SHOW BACKGROUND ==================================================================--
--=====================================================================================--
function DisplayController:showBackground( backgroundImageFileName )
	---------------------------------------------------------------------------
	-- Set up static background and place in a group
	---------------------------------------------------------------------------
	local levelDisplayGroup = display.newGroup()
	local backgroundImage = display.newImage( backgroundImageFileName )
	backgroundImage.x = 160
	backgroundImage.y = 240
	levelDisplayGroup:insert( backgroundImage )
	
	return levelDisplayGroup
end


--=====================================================================================--
--== HIDE MAIN MENU ===================================================================--
--=====================================================================================--
function DisplayController:hideMainMenu()
	mainMenuDisplayGroup.isVisible = false
end


--=====================================================================================--
--== SHOW MAIN MENU ===================================================================--
--=====================================================================================--
function DisplayController:showMainMenu()
	mainMenuDisplayGroup.isVisible = true
end


--=====================================================================================--
--== CREATE MAIN MENU =================================================================--
--=====================================================================================--
function DisplayController:createMainMenu()

	mainMenuDisplayGroup = display.newGroup()
	
	local startGameButton = display.newImage( mainMenuDisplayGroup, "MainScreen_ButtonBackground.png" )
	local optionsButton   = display.newImage( mainMenuDisplayGroup, "MainScreen_ButtonBackground.png" )
	local creditsButton   = display.newImage( mainMenuDisplayGroup, "MainScreen_ButtonBackground.png" )
	
	local buttonY_num = 370
	startGameButton.y = buttonY_num
	optionsButton.y = buttonY_num
	creditsButton.y = buttonY_num

	local buttonMargin_num = 20

	local startGameXPosition = 170
	startGameButton.x = startGameXPosition
	local startGameText = display.newText( mainMenuDisplayGroup, "Start Game", startGameXPosition-60, buttonY_num-20, nil, 22)
	startGameText:setTextColor( 10, 10, 10)
	startGameText.rotation = 90
	
	
	local optionsXPosition_num = startGameButton.x - startGameButton.width - buttonMargin_num
	optionsButton.x = optionsXPosition_num
	local optionsText = display.newText( mainMenuDisplayGroup, "Options", optionsXPosition_num-40, buttonY_num-20, nil, 22)
	optionsText:setTextColor( 10, 10, 10)
	optionsText.rotation = 90
	
	
	local creditsXPosition_num = optionsButton.x - optionsButton.width - buttonMargin_num
	creditsButton.x = creditsXPosition_num
	local creditsText = display.newText(mainMenuDisplayGroup, "Credits", creditsXPosition_num-40, buttonY_num-20, nil, 22)
	creditsText:setTextColor( 10, 10, 10)
	creditsText.rotation = 90
	
	local buttons = {start = startGameButton, options = optionsButton, credits = creditsButton}
	
	return buttons
end


--=====================================================================================--
--== SET TEXT DEBUG ONE ===============================================================--
--=====================================================================================--
function DisplayController:setTextDebugOne( textToSet )
	debugOne.text = textToSet
end


--=====================================================================================--
--== SET TEXT DEBUG TWO ===============================================================--
--=====================================================================================--
function DisplayController:setTextDebugTwo( textToSet )
	debugTwo.text = textToSet
end


--=====================================================================================--
--== SET TEXT DEBUG THREE =============================================================--
--=====================================================================================--
function DisplayController:setTextDebugThree( textToSet )
	debugThree.text = textToSet
end


--=====================================================================================--
--== SET TEXT DEBUG FOUR ==============================================================--
--=====================================================================================--
function DisplayController:setTextDebugFour( textToSet )
	debugFour.text = textToSet
end


--=====================================================================================--
--== SHOW DEBUG OUTPUT ================================================================--
--=====================================================================================--
function DisplayController:showDebugOutput()

	debugScreen = display.newRoundedRect( 170, 60, 125, 120, 10 ) 
	debugScreen:setFillColor( 255, 255, 255)
	debugScreen.alpha = .5

	debugOne = display.newText("-", 250, 90, nil, 16)
	debugOne:setTextColor(0,0,0)
	debugOne.rotation = 90
		
		
		
	debugTwo = display.newText("-", 230, 90, nil, 16)
	debugTwo:setTextColor(0,0,0)
	debugTwo.rotation = 90
		
		
	debugThree = display.newText("-", 210, 90, nil, 16)
	debugThree:setTextColor(0,0,0)
	debugThree.rotation = 90
		
	debugFour = display.newText("-", 180, 90, nil, 16)
	debugFour:setTextColor(0,0,0)
	debugFour.rotation = 90
		
	print("Debug mode")
end