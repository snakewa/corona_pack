--[[
###############################################################################
##	Mike Ziray
##	LTZLLC.com
##	LTZ, LLC
##
###############################################################################
]]--


module(..., package.seeall)


local currentX
local currentY
local currentZ



--===========================================================================--
--== ORIENTATION INPUT LISTENER =============================================--
--===========================================================================--
local function orientationInputListener( event )

	currentX = event.XGravity
	currentY = event.yGravity	
	currentZ = event.zGravity
	
end


--===========================================================================--
--== TURN ORIENTATION INPUT ON ==============================================--
--===========================================================================--
function OrientationController:turnOrientationInputOn()

	-- slow this down for a more delayed response
	system.setAccelerometerInterval( 60 ) 

	Runtime:addEventListener( "accelerometer", orientationInputListener )

end


--===========================================================================--
--== TURN ORIENTATION INPUT OFF =============================================--
--===========================================================================--
function OrientationController:turnOrientationInputOff()
	Runtime:removeEventListener( "accelerometer", orientationInputListener )

end


--===========================================================================--
--== GET CURRENT X ==========================================================--
--===========================================================================--
function OrientationController:getCurrentX()

	return currentX
end


--===========================================================================--
--== GET CURRENT Y ==========================================================--
--===========================================================================--
function OrientationController:getCurrentY()

	return currentY
end


--===========================================================================--
--== GET CURRENT Z ==========================================================--
--===========================================================================--
function OrientationController:getCurrentZ()

	return currentZ
end