--[[ Any functions and variables that we want to use "globally" can be declared as local up here.
      The advantage of doing this here is that we can treat them like globals below, while also
      retaining the compiler optimization that results from local variables in Lua.
      (Note: this comment also demonstrates multi-line Lua comment syntax.)
  ]]

local main, newBall, moveBall, gameOver, killBrick, removeBrick, createBall, removeBall, newLevel
local ball, paddle, brick, brickImage, brickValue, brickCounter

-- Total number of lives
local lives = 5

-- Initialize score
local score = 0

-- Initial x and y velocity of ball, in pixels (increase these values to make the game faster)
local vx = 3
local vy = 3
-- Note that this velocity is increased by 40% in the function "newLevel()", so the actual 
--  starting value is 5, rather than 3

-- This function sets up and launches the game; it is called at the very end of the code
main = function()

	-- Hide the iPhone status bar, for more screen space
	display.setStatusBar( display.HiddenStatusBar )

	-- Create display group for all game objects
	-- The advantage of doing this is that you can later move or hide the entire game
	--  screen as one unified object, if you choose to.
	gamescreen = display.newGroup()

	-- Add background to display group created above. Note that groups can also be added
	--  to other groups, as will occur below when we add the rotating-cube animation group.
	local background = display.newImage("background.png")
	gamescreen:insert( background )

	-- Display objects are stacked in the order they are inserted, newest on top.
	-- If you want to restack a previous object to the top, just issue a new "insert" 
	--  command (there is no need to delete and recreate the object to restack it).
	paddle = display.newImage("paddle.png")
	gamescreen:insert( paddle )
	paddle.x = 160; paddle.y = 420

	-- The score textfield, yellow and 14 point type. The ".." joins two strings in Lua.	
	scoreTextfield = display.newText( "score: " .. score, 20, 10, nil, 14 )
	scoreTextfield:setTextColor( 255, 255, 190, 255 )

	-- The lives-remaining textfield, blue and 14 point type
	livesTextfield = display.newText( "lives: " .. lives, 260, 10, nil, 14 )
	livesTextfield:setTextColor( 190, 190, 255, 255 )

	-- Text for demo purposes, to avoid confusing the different code versions (alpha = 30)
	versionTextfield = display.newText( "- bricky6 -", 90, 440, nil, 26 )
	versionTextfield:setTextColor( 255, 255, 255, 30 )
	


	-- This function makes the paddle "draggable" by matching its x position to the
	--  x position of the touch every time there is a "moved" touch event detected
	function touchListener(touch)

		local phase = touch.phase
	
		if (phase == "moved") then
			paddle.x = touch.x
		end
	end

	-- Touch-enable the paddle by applying the above function via an event listener
	paddle:addEventListener("touch", touchListener)

	-- Create sound objects from audio files
	paddleSound = media.newEventSound( "paddle.caf" )
	brickSound = media.newEventSound( "brick.caf" )
	levelupSound = media.newEventSound( "levelup.caf" )
	loseSound = media.newEventSound( "lose.caf" )

	-- Finally, draw the first level to the screen and start playing
	--  (The "newLevel()" function in turn calls "newBall()" to launch a ball.)
	newLevel()

end


newBall = function()
	
	-- Remove the previous listener, in case it already exists
	Runtime:removeEventListener( "enterFrame", moveBall )

	-- Remove the previous ball (need to check if display object exists first)
	if (ball) then 
		ball.parent:remove( ball ) 
	end
	
	-- Add new ball (actually a small animated cube) to screen
	createBall()
	gamescreen:insert( ball )

	-- You can put multiple lines of Lua code on the same line by using a semicolon:
	ball.x = 160; ball.y = 150
	
	-- Start ball moving by adding new listener to enterFrame.
	-- This will call the function "moveBall()" on every frame until stopped.
	-- (The display updates at 30 frames per second.)
	Runtime:addEventListener( "enterFrame", moveBall )
	
end


moveBall = function()
	-- Much of the game logic falls within this "moveBall()" function, which runs every frame.

	-- To begin with, in each frame, move ball by its x and y velocity (vx, vy).
	ball.x = ball.x + vx
	ball.y = ball.y + vy
	
	-- If the ball hits the left or right side of the screen, change direction and play a sound
	if ((ball.x < 0) or (ball.x > 320)) then
		media.playEventSound( paddleSound )
		vx = -vx
	end
	
	-- If the ball hits the top of the screen, change direction and play a sound
	if (ball.y < 0) then
		media.playEventSound( paddleSound )
		vy = -vy
	
	-- Is the ball's vertical position the same as the paddle?
	--  (Note that Lua uses "elseif", not "else if" as two words)
	elseif ((ball.y > 400) and (ball.y < 440)) then
	
		-- If so, is it hitting or missing the paddle?
		-- (The paddle is 70px wide, so we check if the ball is within 35px left and right)
		if (math.abs(paddle.x - ball.x) < 35) then
			vy = -vy
			
			-- Adjust bounce angle (by adjusting vx) according to where on the paddle 
			--  the ball actually strikes. This allows the player to "steer" the ball.
			--  (The number "4" below is obtained by trial and error playtesting; a lower
			--  number would lead to a wider range of bounce angles, but if the range
			--  is too great, the game becomes too chaotic. Try different numbers to see this.
			vx = -(paddle.x - ball.x)/4
			media.playEventSound( paddleSound )
		end

	-- Has the ball fallen way off the bottom of the iPhone screen (which is 480px high)?		
	elseif (ball.y > 600) then

		-- If so, then do we have any lives left?
		if (lives > 1) then
		
			-- Subtract one life, update counter on screen, and launch a new ball
			lives = lives - 1
			livesTextfield.text = "lives: " .. lives
			
			media.playEventSound( loseSound )
			newBall()
		else
		
			-- No more lives, so show the "game over" animation
			media.playEventSound( loseSound )
			gameOver()
		end
	end

	
	-- Is the ball near the bricks?
	if ((ball.y > 60) and (ball.y < 120)) then
		
		-- If so, which brick position (row, column) does the ball currently occupy?
		row = math.ceil( (ball.y-60)/20 )
		column = math.ceil( ball.x/40 )
		currentBrick = brick[row][column]

		-- Does that brick still exist? (we use brickValue as a lookup table for this)
		if (brickValue[row][column] > 0) then
		
			-- If so, then destroy it and add its value to the score
			-- Also, remove its value from brickValue so we don't hit it again
			killBrick()
			score = score + brickValue[row][column]
			scoreTextfield.text = "score: " .. score
			brickValue[row][column] = 0
			vy = -vy
		end
	end
	
end


killBrick = function()
	-- The current brick "falls" and fades out; 
	-- at end of animation remove the brick entirely (see below)
	transition.to(currentBrick, {time=500, y = currentBrick.y + 100, alpha = 0, transition = easing.inQuad, onComplete = removeBrick} )
	media.playEventSound( brickSound )
end


removeBrick = function()
	-- Remove the current brick entirely, to free memory
	if (currentBrick) then
		currentBrick.parent:remove(currentBrick)

		brickCounter = brickCounter - 1
		print(brickCounter)
		if (brickCounter <= 0) then
			media.playEventSound( levelupSound )
			newLevel()
		end
	end
end


createBall = function()
	-- Create the "spinning cube" animation, using an array of images
	--  (you can substitute any list of PNG files here)
	ball = display.newGroup()
	local animFile = {"cube01.png", "cube02.png", "cube03.png", "cube04.png", "cube05.png", "cube06.png"}
	local animFrame = {}
	
	local i = 1
	while animFile[i] do
		-- Add all the images to the display group named "ball"
		animFrame[i] = display.newImage(animFile[i])
		ball:insert(animFrame[i], true)
		
		-- Initially hide all the images
		animFrame[i].isVisible = false
		i = i + 1
	end	

	local currentFrame = 1

	local nextFrame = function()
		-- Show the animation sequence, one image at a time
		
		-- First, turn off the current frame...
		animFrame[currentFrame].isVisible = false
		currentFrame = currentFrame + 1
		if (currentFrame > #animFrame) then
			currentFrame = 1
		end
		
		-- ...then, show the following frame
		animFrame[currentFrame].isVisible = true
	end
	
	-- Call the above "nextFrame" function continuously, to create an animation
	Runtime:addEventListener( "enterFrame", nextFrame )
	
end


newLevel = function()
	-- Initial number of bricks (to keep track of when the level is cleared)
	brickCounter = 24
	brick = {}

	-- Set of images for the bricks
	--  (any 40px x 20px PNG files will work here, including "brickYellow.png")
	brickImage = {"brickRed.png", "brickGreen.png", "brickBlue.png"}
	
	-- Set of brick point values, populated below
	brickValue = {}

	-- Add all bricks to the screen, looping through rows and columns
	for row = 1, 3 do
	brick[row] = {}
	brickValue[row] = {}
		for column = 1, 8 do
			brick[row][column] = display.newImage( brickImage[row] )
			gamescreen:insert( brick[row][column] )
			brick[row][column].x = -20 + (column * 40)
			brick[row][column].y = 50 + (row * 20)
			
			-- The point value depends on the row (row 1 = 30, row 2 = 20, row 3 = 10)
			brickValue[row][column] = (4 - row) * 10
		end
	end
	
	-- In each new level, increase ball velocity by 40% to add increasing difficulty
	vx = vx * 1.4
	vy = vy * 1.4
	
	newBall()
end


gameOver = function()
	-- Stop ball animation
	Runtime:removeEventListener( "enterFrame", moveBall )
	
	-- One final update of lives display, so the user understands what has happened
	lives = 0
	livesTextfield.text = "lives: " .. lives
	
	-- Show "game over" text animation
	gameOverImage = display.newImage("gameover.png")
	gamescreen:insert(gameOverImage)
	gameOverImage.x = 160
	gameOverImage.y = 230
	gameOverImage.alpha = 0
	transition.to(gameOverImage, {time=2000, alpha = 1.0, transition = easing.outQuad} )
	
	-- As a further improvement, you could record a "high score" here, using
	--  the Corona file-saving functions
end

-- Finally, calling "main()" launches the application, since we've designed this as the setup
--  function at the beginning of this code.

main()


--[[ NOTE: the deleted line below is for delaying the splash screen, because otherwise
     it passes too quickly in the simulator. In production code, you wouldn't add this,
     since the actual iPhone takes longer to initialize and therefore the splash screen 
     time would most likely be adequate. Always test on device!
  ]]

-- timer.performWithDelay(2000, main) -- initial delay for demo purposes only