--[[
###############################################################################
##	Mike Ziray
##	LTZLLC.com
##	LTZ, LLC
##
###############################################################################
]]--

module(..., package.seeall)


local currentLevel = 1
local score = 0

--=====================================================================================--
--== GET CURRENT LEVEL NUMBER =========================================================--
--=====================================================================================--
function GameStats:getCurrentLevelNumber()
	return currentLevel
end