function testCredits()
	if testforButtonClick(ShipX, ShipY, WindowWidth/2-50, WindowHeight-190, 175, 75) then
		if creditsState == 1 then
			creditsHover = true
			if love.keyboard.isDown("return") then
				creditsState = 2
				creditsHover = false
				playState, controlsState, optionsState = 3, 3, 3
			end
		end
	else
		creditsHover = false
	end
end

function testOptions()
	-- Options button on the main screen
	if testforButtonClick(ShipX, ShipY, WindowWidth/2-50, WindowHeight-340, 175, 75) then
		if optionsState == 1 then
			optionsHover = true
			if love.keyboard.isDown("return") then
				optionsState = 2
				optionsHover = false
				creditsState = 3
				playState = 3
				controlsState = 3
			end
		end
	else
		optionsHover = false
	end	
	--Backing out to the main menu
	if optionsState == 2 then
		drawOptionsScreen = true
		if love.keyboard.isDown("escape") then
			drawOptionsScreen = false
			optionsState = 1
			playState = 1
			creditsState = 1
			controlsState = 1
		end
	end
	--If on the Options menu
	if drawOptionsScreen then
		-- Volume up
		if testforButtonClick(ShipX, ShipY, WindowWidth/2-275, 40, 25, 25) then
			if love.keyboard.isDown("return") then
				VolumeLevel = VolumeLevel + .1
				love.audio.setVolume(VolumeLevel)
			end
			if VolumeLevel >= 10 then
				VolumeLevel = 9.9
			end
		-- Volume down
		elseif testforButtonClick(ShipX, ShipY, WindowWidth/2-200, 40, 25, 25) then
			if love.keyboard.isDown("return") then
				VolumeLevel = VolumeLevel - .1
				love.audio.setVolume(VolumeLevel)
			end
			if VolumeLevel <= 0 then
				VolumeLevel = .1
			end
		end
		-- Fullscreen on
		if fullscreenEnabled == false then
			if testforButtonClick(ShipX, ShipY, WindowWidth/2+80, 150, 55, 30) then
				if love.keyboard.isDown("return") then
					fullscreenEnabled = true
				end
			end
		-- Fullscreen off
		elseif fullscreenEnabled == true then
			if testforButtonClick(ShipX, ShipY, WindowWidth/2+175, 150, 55, 30) then
				if love.keyboard.isDown("return") then
					fullscreenEnabled = false
				end
			end
		end
	end
end

function testPlay()
	if testforButtonClick(ShipX, ShipY, WindowWidth/2-50, WindowHeight-640, 175, 75) then
		if playState == 1 then
			playHover = true
			if love.keyboard.isDown("return") then
				onMenu, playHover = false, false
				playState = 2
				optionsState, controlsState, creditsState = 3, 3, 3
				inGame = true
			end
		end
	else
		playHover = false
	end
end

function testControls()
	--Menu button
	if testforButtonClick(ShipX, ShipY, WindowWidth/2-50, WindowHeight-490, 175, 75) then
		if controlsState == 1 then
			controlsHover = true
			if love.keyboard.isDown("return") then
				controlsState = 2
				controlsHover = false
				optionsState, creditsState, playState = 3, 3, 3
			end
		end
	else
		controlsHover = false
	end

	if controlsState == 2 then
		-- Keyboard controls button
		if MouseControls == true then
			if testforButtonClick(ShipX, ShipY, WindowWidth/2 - 122, 150, 330, 25) then
				if love.keyboard.isDown("return") then
					MouseControls = false
				end
			end
		--Mouse controls button
		elseif MouseControls == false then
			if testforButtonClick(ShipX, ShipY, WindowWidth/2 - 150, 50, 330, 25) then
				if love.keyboard.isDown("return") then
					MouseControls = true
				end
			end
		end
		--Leave controls menu
		if love.keyboard.isDown("escape") then
			controlsState, playState, creditsState, optionsState = 1, 1, 1, 1
		end
	end
end

function drawCredits()
	if creditsState == 1 then
		love.graphics.draw(creditsButton, WindowWidth/2, WindowHeight - 150, 0, .9, .9, buttonWidth/2, buttonHeight/2)
	elseif creditsState == 2 then
		love.graphics.printf(
			"Credits:\n\n" ..

			"Music\n" ..
			"Kevin Macleod\n\n" ..
			
			"Sounds\n" ..
			"Jumpsplat120\n" ..
			"Kevin Macleod\n" ..
			"AudioMicro\n\n" ..
			
			"Coders\n" ..
			"Jumpsplat120\n\n" ..
			
			"Artists\n" ..
			"Jumpsplat120\n" ..
			"Kendra Miller\n\n" ..
			
			"Story\n" ..
			"Jumpsplat120\n\n" ..
		
			"Moral Support\n" ..
			"Kendra Miller\n" ..
			"Sugar\n\n" ..
			
			"Beta Testers\n" ..
			"Matthew Apodaca\n" ..
			"Kendra Miller\n" ..
			"Jennifer Apodaca\n\n" ..
			
			"Thank you for playing!", 0, sc - WindowHeight, WindowWidth, "center", r, 1, 1, ox, oy, kx, ky)
			love.graphics.reset()
	elseif creditsState == 3 then
		sc = 0
		love.graphics.reset()
	end
	if creditsHover == true then
		love.graphics.draw(creditsButton, WindowWidth/2, WindowHeight - 150, 0, 1, 1, buttonWidth/2, buttonHeight/2)
	end
end

function drawPlay()
	if playHover == true then
		love.graphics.draw(bigPlayButton, WindowWidth/2, WindowHeight - WindowHeight + 150, 0, .9, .9, bigButtonWidth/2, bigButtonHeight/2)
		creditsState, controlsState, optionsState = 3, 3, 3
	elseif playState == 1 then
		creditsState, controlsState, optionsState = 1, 1, 1
		love.graphics.draw(playButton, WindowWidth/2, WindowHeight - 600, 0, .9, .9, buttonWidth/2, buttonHeight/2)
	elseif playState == 2 then
		welcomeTo = true
			love.graphics.printf("Welcome to \"The Spaceist\".\n\n\nPlease enter your name:", 1, WindowHeight/2 - 50, WindowWidth, "center", r, sx, sy, 25)
	elseif playState == 3 then
		love.graphics.reset()
	end
end

function drawControls()
	if controlsState == 1 then
		love.graphics.draw(controlsButton, WindowWidth/2, WindowHeight - 450, 0, .9, .9, buttonWidth/2, buttonHeight/2)
	elseif controlsState == 2 then
		love.graphics.printf("Press enter to select choices with the ship.\nFly the ship around with either the mouse or the WASD keys.\nClick on the ship to pull up your crew's info, as well as credits, gas and other important info.\nPress Shift+O to open the options menu, or Shift+C for the controls at any time.", 1, 450, WindowWidth, "center")
		if MouseControls == true then
		love.graphics.print("Keyboard Control", WindowWidth/2, 150, r, sx, sy, 150)
		love.graphics.print("MOUSE CONTROLS", WindowWidth/2, 50, r, sx, sy, 145)
		elseif MouseControls == false then
		love.graphics.print("KEYBOARD CONTROLS", WindowWidth/2, 150, r, sx, sy, 150)
		love.graphics.print("  Mouse Control", WindowWidth/2, 50, r, sx, sy, 122)
		end
	elseif controlsState == 3 then
		love.graphics.reset()
	end
	if controlsHover == true then
		love.graphics.draw(controlsButton, WindowWidth/2, WindowHeight - 450, 0, 1, 1, buttonWidth/2, buttonHeight/2)
	end
end

function drawOptions()
	if drawOptionsScreen then
		if musicVolume == 10 then
			love.graphics.print("Music Volume: ! ! ! ! ! ! ! ! ! !", WindowWidth/2, 50 , r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		elseif musicVolume < 1 then
			love.graphics.print("Music Volume: . . . . . . . . . .", WindowWidth/2, 50, r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		elseif musicVolume < 2 then
			love.graphics.print("Music Volume: ! . . . . . . . . .", WindowWidth/2, 50, r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		elseif musicVolume < 3 then
			love.graphics.print("Music Volume: ! ! . . . . . . . .", WindowWidth/2, 50, r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		elseif musicVolume < 4 then
			love.graphics.print("Music Volume: ! ! ! . . . . . . .", WindowWidth/2, 50, r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		elseif musicVolume < 5 then
			love.graphics.print("Music Volume: ! ! ! ! . . . . . .", WindowWidth/2, 50, r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		elseif musicVolume < 6 then
			love.graphics.print("Music Volume: ! ! ! ! ! . . . . .", WindowWidth/2, 50, r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		elseif musicVolume < 7 then
			love.graphics.print("Music Volume: ! ! ! ! ! ! . . . .", WindowWidth/2, 50, r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		elseif musicVolume < 8 then
			love.graphics.print("Music Volume: ! ! ! ! ! ! ! . . .", WindowWidth/2, 50, r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		elseif musicVolume < 9 then
			love.graphics.print("Music Volume: ! ! ! ! ! ! ! ! . .", WindowWidth/2, 50, r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		elseif musicVolume < 10 then
			love.graphics.print("Music Volume: ! ! ! ! ! ! ! ! ! .", WindowWidth/2, 50, r, sx, sy, 150, oy, kx, ky)
			love.graphics.setFont(BMSpaceFont45)
			love.graphics.print("+  -", WindowWidth/2 - 275, 40)
			love.graphics.setFont(BMSpaceFont)
		end
		love.graphics.print("Fullscreen: ", WindowWidth/2, 150, r, sx, sy, 150, oy, kx, ky)
		if fullscreenEnabled == true then
			love.graphics.reset()
			love.window.setFullscreen(true, "normal")
			love.graphics.print("ON", WindowWidth/2 + 135, 150, r, sx, sy, 50, oy, kx, ky)
			love.graphics.print("off", WindowWidth/2 + 200, 150, r, sx, sy, 50)
		elseif fullscreenEnabled == false then
			love.graphics.reset()
			love.window.setFullscreen(false)
			love.graphics.print("OFF", WindowWidth/2 + 200, 150, r, sx, sy, 50)
			love.graphics.print("on", WindowWidth/2 + 135, 150, r, sx, sy, 50)
		end
	end

	if optionsState == 1 then
		love.graphics.reset()
		love.graphics.draw(optionsButton, WindowWidth/2, WindowHeight - 300, 0, .9, .9, buttonWidth/2, buttonHeight/2)
	elseif optionsState == 2 then
		--Code
	elseif optionsState == 3 then
		love.graphics.reset()
	end
	if optionsHover == true then
		love.graphics.draw(optionsButton, WindowWidth/2, WindowHeight - 300, 0, 1, 1, buttonWidth/2, buttonHeight/2)
	end
end