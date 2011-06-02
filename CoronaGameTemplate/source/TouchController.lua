--[[
###############################################################################
##	Mike Ziray
##	LTZLLC.com
##	LTZ, LLC
##
###############################################################################
]]--

module(..., package.seeall)


system.activate( "multitouch" ) 


local rightThumbAButton
local rightThumbBButton



--===========================================================================--
--== INITIALIZE =============================================================--
--===========================================================================--
function TouchController:initialize()

	-- Set up the graphics for your touch controller

	thumbAButton = display.newImage("ButtonBase.png")
	thumbAButton.y = 420
	thumbAButton.x = 130
	
	thumbBButton = display.newImage("ButtonBase.png")
	thumbBButton.y = 420
	thumbBButton.x = 50
end


--===========================================================================--
--== TURN TOUCH CONTROLS ON =================================================--
--===========================================================================--
function TouchController:turnTouchControlsOn()

	thumbAButton:addEventListener("touch", thumbAButtonHandler )
	thumbBButton:addEventListener("touch", thumbBButtonHandler )
end


--===========================================================================--
--== RIGHT THUMB A BUTTON HANDLER =============================================--
--===========================================================================--
function thumbAButtonHandler( event )
	DisplayController:setTextDebugThree( "'A' hit!" )
end

--===========================================================================--
--== RIGHT THUMB B BUTTON HANDLER =============================================--
--===========================================================================--
function thumbBButtonHandler( event )
	DisplayController:setTextDebugThree( "'B' hit!" )
end



--===========================================================================--
--== TURN TOUCH CONTROLS OFF ================================================--
--===========================================================================--
function TouchController:turnTouchControlsOff()
	thumbAButton:removeEventListener("touch", thumbAButtonHandler )
	thumbBButton:removeEventListener("touch", thumbBButtonHandler )
end