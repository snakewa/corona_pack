--[[
###############################################################################
##	Mike Ziray
##	LTZLLC.com
##	LTZ, LLC
##
###############################################################################
]]--


module(..., package.seeall)

local levelInfo = {}


--=====================================================================================--
--== LOAD LEVEL =======================================================================--
--=====================================================================================--
function LevelLoader:loadLevel( levelToLoad )
	
	---------------------------------------------------------------------------
	-- Load level config file
	---------------------------------------------------------------------------
	local path = system.pathForFile( "level".. levelToLoad ..".ltz")
	local levelInfo = LevelLoader:parseLevelFile( path )
	
	---------------------------------------------------------------------------
	-- Create actual level object
	---------------------------------------------------------------------------
	local level       = {}
	level.levelInfo   = levelInfo
	level.levelNumber = levelToLoad
	level.bgDisplay   = levelDisplayGroup
	level.name        = levelInfo.name
	
	--print(level.name)
	return level
end


--=====================================================================================--
--== PARSE LEVEL FILE =================================================================--
--=====================================================================================--
function LevelLoader:parseLevelFile( filePath )
	
	-------------------------------------------------------
	-- Open file and place in variable --------------------
	-------------------------------------------------------
	local contents = ""
	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( filePath, "r" )
	if file then
		contents = file:read( "*a" ) -- read all contents of file into a string
		io.close( file )
	else
		-- file doesn't exist
	end


	-------------------------------------------------------
	-- Load in key = value pairs --------------------------
	-------------------------------------------------------
	-- Search and extract all key = value pairs
	for key, value in string.gmatch(contents, "(%w+)%s*=%s*(%w+)") do
		levelInfo[key] = value
	end
	
	
	-------------------------------------------------------
	-- Load in enemy data --------------------------------
	-------------------------------------------------------
	local enemiesData = string.match(contents, "enemies:\n(.*)")
	
	levelInfo["enemies"] = {}
	
	local count = 1
	for enemySet in string.gmatch( enemiesData, "%[(.-)%]" ) do

		levelInfo["enemies"][count] = {}
		
		for deploymentTime, location, enemyType in string.gmatch( enemySet, "(%d+),(%d+),(%a+)\n" ) do
			table.insert( levelInfo["enemies"][count], { time=deploymentTime, position=location, type=enemyType } )
		end
		
		count = count + 1
	end
	
	return levelInfo
end


