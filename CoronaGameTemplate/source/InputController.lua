--[[
###############################################################################
##	Mike Ziray
##	LTZLLC.com
##	LTZ, LLC
##
###############################################################################
]]--


module(..., package.seeall)

require("OrientationController")
require("TouchController")


--=====================================================================================--
--== TURN ON INPUTS ===================================================================--
--=====================================================================================--
function InputController:turnOnInputs()

	TouchController:initialize()
	TouchController:turnTouchControlsOn()

	-- Register for orientation
	OrientationController:turnOrientationInputOn()
	
end


--=====================================================================================--
--== TURN OFF INPUTS ==================================================================--
--=====================================================================================--
function InputController:turnOffInputs()

	TouchController:initialize()
	TouchController:turnTouchControlsOff()

	-- Register for orientation
	OrientationController:turnOrientationInputOff()
	
end