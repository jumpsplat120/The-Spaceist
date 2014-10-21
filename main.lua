require "functions"
require "Kestral"
require "Titanic"
require "Cowboy"
require "lovedebug"

function love.load()
	SeedSetter()
	AssetsToLoad()
	SetDefaultValues()
end

function love.update(dt)
	pdt = dt
	sc = sc + (pdt*10)
	timer = timer + pdt
	spin = spin + pdt
	ShipX = ShipX + xvel/10
	ShipY = ShipY + yvel/10
	xvel = xvel/friction
	yvel = yvel/friction

	state.update()
	collisionDetect()
--	testmain()
--	testGas()
--	testKestral()
	
	if MouseControls then
		rotate = math.atan2(love.mouse.getY() - ShipY, love.mouse.getX() - ShipX )
		turn = rotate
		MouseControl()
	elseif MouseControls == false then
		keyboardControls()
	end

--	if drawShipSelectScreen then
--		fade("in")
--	end

	test1 = true
end

function love.draw()
	for w = 0, love.graphics.getWidth() / BackgroundImage:getWidth() do
		for h = 0, love.graphics.getHeight() / BackgroundImage:getHeight() do
			love.graphics.draw(BackgroundImage, w * BackgroundImage:getWidth(), h * BackgroundImage:getHeight())
		end
	end

	state.draw()
--	drawShipSelect()
--	drawShipRename()
--	drawmain()
--	retireScreen()
--	drawGas()
	drawShip()

	if test1 then
		love.graphics.print("true")
	end
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
	pkey = key
	debugMenufnct()
	shipRenameAsk()
	shipRenameInput()
end

function love.keyreleased(key)
	if testA then
		if key == "return" then
			Apressed = true
		end
	elseif testB then
		if key == "return" then
			Bpressed = true
		end
	elseif testC then
		if key == "return" then
			Cpressed = true
		end
	elseif testD then
		if key == "return" then
			Dpressed = true
		end
	end

	if hovergasStation and key == "return" then
		gasHead = math.floor(math.random(1,9))
		gasBody = math.floor(math.random(1,6))
		runGas = true
		drawMainScreen, Apressed, Bpressed, Cpressed, Dpressed, hovergasStation = false, false, false, false, false
	end
	if runGas and key == "escape" then
		drawMainScreen = true
		runGas, boughtGas, Apressed, Bpressed, Cpressed, Dpressed = false,false, false, false, false, false
		enoughCredits = nil
	end
	if hoverMonster and key == "return" then
		--switch to random later
		lftPath = 1
		drawMainScreen = false
	end

	if menuDrawState == 1 then
	elseif menuDrawState == 2 and key == "escape" then menuDrawState = 1
	elseif menuDrawState == 3 and key == "escape" then menuDrawState = 1
	elseif menuDrawState == 4 then
		if testforButtonClick(ShipX, ShipY, love.window.getWidth()/2-275, 40, 25, 25) and key == "return" then
				VolumeLevel = VolumeLevel + .1
				love.audio.setVolume(VolumeLevel)
		elseif testforButtonClick(ShipX, ShipY, love.window.getWidth()/2-200, 40, 25, 25) and  key == "return" then
				VolumeLevel = VolumeLevel - .1
				love.audio.setVolume(VolumeLevel)
		end
		if key == "escape" then
			menuDrawState = 1
		end
	end
end

function love.textinput(text)
	if inGameUpdateState == 1 then
		if nameLength <= 25 then
			name = name .. text
			nameLength = nameLength + 1
			printName = true
		end
	elseif inGameUpdateState == 2 then
		if shipNameLength <= 25 then
			shipName = shipName .. text
			shipNameLength = shipNameLength + 1
		end
	end
end

	menuState = {
   		update = function()
   				shootBullets()
   				if player.heat > 0 then
					player.heat = player.heat - .1
				end
   				love.audio.play(MenuMusic)
   				--Main Menu
   				if menuDrawState == 1 then
   					if testforButtonClick(ShipX, ShipY, love.window.getWidth()/2-50, love.window.getHeight()/(8/6), 175, 75) then
						creditsHover = true
						if love.keyboard.isDown("return") then
							menuDrawState = 2
							creditsHover = false
							sc = 0
						end
					elseif testforButtonClick(ShipX, ShipY, love.window.getWidth()/2-50, love.window.getHeight()/(8/5), 175, 75) then
						optionsHover = true
						if love.keyboard.isDown("return") then
							menuDrawState = 3
							optionsHover = false
						end
					elseif testforButtonClick(ShipX, ShipY, love.window.getWidth()/2-50, love.window.getHeight()/(8/4), 175, 75) then
						playHover = true
						if love.keyboard.isDown("return") then
							state = inGameState
							playHover = false
						end
					elseif testforButtonClick(ShipX, ShipY, love.window.getWidth()/2-50, love.window.getHeight()/(8/3), 175, 75) then
						controlsHover = true
						if love.keyboard.isDown("return") then
							menuDrawState = 4
							controlsHover = false
						end
					else
						optionsHover, creditsHover, playHover, controlsHover = false, false, false, false
					end
				--Credits
				elseif menuDrawState == 2 then
				--Controls
				elseif menuDrawState == 3 then
					if MouseControls then
						if testforButtonClick(ShipX, ShipY, love.window.getWidth()/2 - 122, 150, 330, 25) then
							if love.keyboard.isDown("return") then
								MouseControls = false
							end
						end
					elseif MouseControls == false then
						if testforButtonClick(ShipX, ShipY, love.window.getWidth()/2 - 150, 50, 330, 25) then
							if love.keyboard.isDown("return") then
								MouseControls = true
							end
						end
					end
				--Options
				elseif menuDrawState == 4 then
					if fullscreenEnabled == false then
						if testforButtonClick(ShipX, ShipY, love.window.getWidth()/2+80, 150, 55, 30) then
							if love.keyboard.isDown("return") then
								fullscreenEnabled = true
							end
						end
					elseif fullscreenEnabled == true then
						if testforButtonClick(ShipX, ShipY, love.window.getWidth()/2+175, 150, 55, 30) then
							if love.keyboard.isDown("return") then
								fullscreenEnabled = false
							end
						end
					end
					if VolumeLevel > 1 then VolumeLevel = 1
					elseif VolumeLevel < 0 then VolumeLevel = 0
					end
				end
   			end;
   		draw = function()
   			drawBullets()
   			if menuDrawState == 1 then
   				love.graphics.reset()
   				love.graphics.draw(playButton, love.window.getWidth()/2, love.window.getHeight()/(8/6), 0, .9, .9, buttonWidth/2, buttonHeight/2)
				love.graphics.draw(creditsButton, love.window.getWidth()/2, love.window.getHeight()/(8/5), 0, .9, .9, buttonWidth/2, buttonHeight/2)
				love.graphics.draw(optionsButton, love.window.getWidth()/2, love.window.getHeight()/(8/4), 0, .9, .9, buttonWidth/2, buttonHeight/2)
				love.graphics.draw(controlsButton, love.window.getWidth()/2, love.window.getHeight()/(8/3), 0, .9, .9, buttonWidth/2, buttonHeight/2)
			elseif menuDrawState == 2 then
				love.graphics.reset()
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
				
				"Thank you for playing!", 0, sc - love.window.getHeight(), love.window.getWidth(), "center", r, 1, 1, ox, oy, kx, ky)
			elseif menuDrawState == 3 then
				love.graphics.printf("Press enter to select choices with the ship.\nFly the ship around with either the mouse or the WASD keys.\nClick on the ship to pull up your crew's info, as well as credits, gas and other important info.\nPress Shift+O to open the options menu, or Shift+C for the controls at any time.", 1, 450, love.window.getWidth(), "center")
				if MouseControls == true then
					love.graphics.print("Keyboard Controls", love.window.getWidth()/2, 150, r, sx, sy, BMSpaceFont:getWidth("Keyboard Controls")/2)
					love.graphics.print("MOUSE CONTROLS", love.window.getWidth()/2, 50, r, sx, sy, BMSpaceFont:getWidth("MOUSE CONTROLS")/2)
				elseif MouseControls == false then
					love.graphics.print("KEYBOARD CONTROLS", love.window.getWidth()/2, 150, r, sx, sy, BMSpaceFont:getWidth("KEYBOARD CONTROLS")/2)
					love.graphics.print("Mouse Controls", love.window.getWidth()/2, 50, r, sx, sy, BMSpaceFont:getWidth("Mouse Controls")/2)
				end
			elseif menuDrawState == 4 then
				love.graphics.print("Music Volume", love.window.getWidth()/2, 75, r, sx, sy, BMSpaceFont:getWidth("Music Volume")/2)
				love.graphics.print(musicVolumeTable[(love.audio.getVolume()*10)], love.window.getWidth()/2, 50, r, sx, sy, 150)
				love.graphics.setFont(BMSpaceFont45)
				love.graphics.print("+  -", love.window.getWidth()/2 - 275, 40)
				love.graphics.setFont(BMSpaceFont)
				love.graphics.print("Fullscreen: ", love.window.getWidth()/2, 150, r, sx, sy, BMSpaceFont:getWidth("Fullscreen:")/2)
				if fullscreenEnabled then
					love.graphics.reset()
					love.window.setFullscreen(true, "normal")
					love.graphics.print("ON", love.window.getWidth()/2 + 135, 150, r, sx, sy, BMSpaceFont:getWidth("ON")/2)
					love.graphics.print("off", love.window.getWidth()/2 + 200, 150, r, sx, sy, BMSpaceFont:getWidth("off")/2)
				elseif fullscreenEnabled == false then
					love.graphics.reset()
					love.window.setFullscreen(false)
					love.graphics.print("OFF", love.window.getWidth()/2 + 200, 150, r, sx, sy, BMSpaceFont:getWidth("on")/2)
					love.graphics.print("on", love.window.getWidth()/2 + 135, 150, r, sx, sy, BMSpaceFont:getWidth("OFF")/2)
				end
			elseif menuDrawState == 5 then
				love.graphics.reset()
			end
			if creditsHover then
				love.graphics.draw(creditsButton, love.window.getWidth()/2, love.window.getHeight()/2 - 150, 0, 1, 1, buttonWidth/2, buttonHeight/2)
			elseif playHover then
				love.graphics.draw(bigPlayButton, love.window.getWidth()/2, love.window.getHeight()/2 + 150, 0, .9, .9, bigButtonWidth/2, bigButtonHeight/2)
			elseif controlsHover then
				love.graphics.draw(controlsButton, love.window.getWidth()/2, love.window.getHeight()/2 + 75, 0, 1, 1, buttonWidth/2, buttonHeight/2)
			elseif optionsHover then
				love.graphics.draw(optionsButton, love.window.getWidth()/2, love.window.getHeight()/2 - 75, 0, 1, 1, buttonWidth/2, buttonHeight/2)
			end
		  end
	}

	setupCharState = {
  	 	update = function()
					MenuMusic:stop()
					love.audio.play(GameMusic)
					if scDrawState == 1 then
						if pkey == "backspace" then 
							name = name:sub(1, -2)
							nameLength = nameLength - 1
							if nameLength <= 0 then
								nameLength = 0
							end
						end
						if pkey == "return" then
							scDrawState = 2
						end
					elseif scDrawState == 2 then
						if Apressed then
							scDrawState = 3
							alpha = 0
							drawKestral = true
							drawRMS, drawCowboy, drawMenuShip, Apressed = false, false, false, false
						elseif Bpressed then
							scDrawState = 3
							alpha = 0
							drawRMS = true
							drawKestral, drawCowboy, drawMenuShip, Bpressed = false, false, false, false
						elseif Cpressed then
							scDrawState = 3
							alpha = 0
							drawCowboy = true
							drawKestral, drawRMS, drawMenuShip, Cpreseed = false, false, false, false
						end
					elseif scDrawState == 3 then
					end
  	 		  	 end;
   		draw = function()  
   				if scDrawState == 1 then
   					love.graphics.printf("Welcome to \"The Spaceist\".\n\n\nPlease enter your name:", 1, love.window.getWidth()/2 - 50, love.window.getWidth(), "center", r, sx, sy, 25)
   					love.graphics.print(name, love.window.getWidth()/2, love.window.getHeight()/2 + 100, r, sx, sy, BMSpaceFont:getWidth(name)/2)
   				elseif scDrawState == 2 then
   					if alpha ~= 256 then
						fade("in")
					end
					love.graphics.setColor(255,255,255,alpha)
					love.graphics.printf("Welcome, " .. name .. ".", 1, love.window.getWidth()/2 - 50, WindowWidth, "center", r, sx, sy, 25)
					if alpha >= 255 then
						love.graphics.printf("\n\nPlease select your ship.", 1, love.window.getWidth()/2 - 50, WindowWidth, "center", r, sx, sy, 25)
						love.graphics.draw(kestralShip, WindowWidth/2 - 350, love.window.getWidth() - 175, math.pi/2, sx, sy, 21, 36, kx, ky)
						love.graphics.draw(titanicShip, WindowWidth/2, love.window.getWidth() - 175, math.pi/2, sx, sy, 16, 54)
						love.graphics.print("Kestral", WindowWidth/2 - 350, love.window.getWidth() - 50, r, sx, sy, BMSpaceFont:getWidth("Kestral")/2)
						love.graphics.print("RMS Titanic", WindowWidth/2, love.window.getWidth() - 50, r, sx, sy, BMSpaceFont:getWidth("RMS Titanic")/2)
						love.graphics.print("US FUCKING COWBOY", WindowWidth/2 + 350, love.window.getWidth() - 50, r, sx, sy, BMSpaceFont:getWidth("US FUCKING COWBOY")/2)
						drawABC(350, 100, "abc")
						testABC(350, 100, "abc")
					end
   				elseif scDrawState == 3 then
   				end
    		   end
	}

	kestralState = {
  		update = function()  end;
  		draw = function()  end
	}