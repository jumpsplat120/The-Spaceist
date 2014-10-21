require "Kestral"
require "Cowboy"
require "Titanic"
require "humans"
require "bugs"
require "xEti"

function AssetsToLoad()
	BackgroundImage = love.graphics.newImage("assets/Textures/StarBG.png")
	FaviconSpaceship = love.graphics.newImage("assets/Ships/SpaceistFavicon.png")
	BMSpaceFont = love.graphics.newFont("assets/Fonts/BM Space - by BitmapMania.TTF", 25)
	BMSpaceFont45 = love.graphics.newFont("assets/Fonts/BM Space - by BitmapMania.TTF", 45)
	love.graphics.setFont(BMSpaceFont)
	MenuMusic = love.audio.newSource("assets/Sounds/Music/Thunder Dreams.mp3", "stream")
	GameMusic = love.audio.newSource("assets/Sounds/Music/Space Fighter.mp3", "stream")
	laser = love.audio.newSource("assets/Sounds/soundEffects/laserSound.wav", "static")
	laser2 = love.audio.newSource("assets/Sounds/soundEffects/laserSound.wav", "static")
	creditsButton = love.graphics.newImage("assets/Buttons/CreditsButton.png")
	playButton = love.graphics.newImage("assets/Buttons/PlayButton.png")
	controlsButton = love.graphics.newImage("assets/Buttons/ControlsButton.png")
	optionsButton = love.graphics.newImage("assets/Buttons/OptionsButton.png")
	bigPlayButton = love.graphics.newImage("assets/Buttons/BigPlayButton.png")
	menuShip = love.graphics.newImage("assets/Ships/MenuShip.png")
	kestralShip = love.graphics.newImage("assets/Ships/Kestral.png")
	titanicShip = love.graphics.newImage("assets/Ships/Titanic.png")
	AButton = love.graphics.newImage("assets/Buttons/AButton.png")
	BButton = love.graphics.newImage("assets/Buttons/BButton.png")
	CButton = love.graphics.newImage("assets/Buttons/CButton.png")
	DButton = love.graphics.newImage("assets/Buttons/DButton.png")
	Asteroid = love.graphics.newImage("assets/Objects/Asteroid.png")
	gasStation = love.graphics.newImage("assets/Objects/gasStation.png")
	monster = love.graphics.newImage("assets/Objects/monster.png")
	planet = love.graphics.newImage("assets/Objects/planet.png")
	retire = love.graphics.newImage("assets/Objects/Retire.png")
	hheads()
	hbodies()
end

function SetDefaultValues()
	bigButtonWidth = bigPlayButton:getWidth()
	bigButtonHeight = bigPlayButton:getHeight()
	buttonWidth = creditsButton:getWidth()
	buttonHeight = creditsButton:getHeight()
	ShipX, ShipY = love.window.getWidth()/2, love.window.getHeight()/2

	xvel, yvel, accel, rotate, alpha, alpha2, timer, VolumeLevel, turn, nameLength, shipNameLength, spin, creditAmount, crewAmount, sc, gasAmount = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	menuDrawState, scDrawState = 1, 1
	normSpeed = 35
	friction = 1.0085
	bounce = 0.01
	bulletSpeed = 150
	pathState = math.random(0,3)
	tankCap = 25

	state = menuState
	fullscreenEnabled, pickYourShip, drawKestral, drawRMS, drawCowboy, inGame, Apressed, Bpressed, Cpressed, Dpressed, fadeMain, boughtGas = false,false,false,false,false,false,false,false,false,false,false,false
	MouseControls, drawMenuShip, flip = true, true, true

	test1, test2, test2_5, test3 = false

	love.audio.setVolume(1)

	hheadTable = {hhead1, hhead2, hhead3, hhead4, hhead5, hhead6, hhead7, hhead8, hhead9}
	hbodyTable = {hbody1, hbody2, hbody3, hbody4, hbody5, hbody6}
	musicVolumeTable = {[100] = "Music Volume: ! ! ! ! ! ! ! ! ! !",[90] = "Music Volume: ! ! ! ! ! ! ! ! ! .",[80] ="Music Volume: ! ! ! ! ! ! ! ! . .",[70] = "Music Volume: ! ! ! ! ! ! ! . . .",[60] = "Music Volume: ! ! ! ! ! ! . . . .",[50] = "Music Volume: ! ! ! ! . . . . .",[40] = "Music Volume: ! ! ! ! . . . . . .",[30] = "Music Volume: ! ! ! . . . . . . . .",[20] = "Music Volume: ! ! . . . . . . . .",[10] = "Music Volume: ! . . . . . . . . .",[0] = "Music Volume: . . . . . . . . . ."}
	NameTable = {"Bob", "Mary", "John", "Luke", "Kendra", "Matthew", "Sips", "Jeremy", "Lomidia", "Kim", "Mandrew"}
	ShipNameTable = {"Ship 1", "Ship Two", "Red Ship", "Ship Blue"}
	PlanetNameTable = {"Zathura", "PXC-11ac", "Jumagi", "Dave", "Earth.2"}
    bullets = {}
    player = {heat = 0, heatp = 0.1}

	name = ""
	shipName = ""
end

function SeedSetter()
	while seed == nil do
		seed = os.time() + 42
		if seed ~= nil then
			math.randomseed(seed)
			rng = math.random(6)
			break
		end
	end
end

function debugMenufnct()
	if pkey == "f1" then
		debugMenu = true
	end
	if debugMenu then
		if pkey == "1" then
			alpha = 255
			crewAmount, creditAmount, gasAmount = 5, 1000, 3
			state = kestralState
			pathState = 1
			runMain, drawKestral, drawMainScreen, canRetire = true, true, true, true
			name = "debug"
			shipName = "Bob"
			debugMenu, drawMenuShip = false, false
		elseif pkey == "2" then
			alpha = 255
			playState, optionsState, controlsState, creditsState = 3, 3, 3, 3
			runMain, drawKestral = true, true
			pathState = 2
			name = "debug"
			shipName = "Bob"
			debugMenu, drawMenuShip = false, false
		elseif pkey == "3" then
			alpha = 255
			playState, optionsState, controlsState, creditsState = 3, 3, 3, 3
			runMain, drawKestral = true, true
			pathState = 3
			name = "debug"
			shipName = "Bob"
			debugMenu, drawMenuShip = false, false
		end
	end
end

function shootBullets()
	if love.mouse.isDown('l') and player.heat <= 0 then
			local direction = math.atan2(love.mouse.getY() - ShipY, love.mouse.getX() - ShipX)
			table.insert(bullets, {
			x = ShipX,
			y = ShipY,
			dir = direction,
			speed = 400
			})
			player.heat = 1
			if flip then
					laser:setVolume(.5)
					laser:play()
					flip = false
			elseif flip == false then
	    			laser2:setVolume(.5)
	    			laser2:play()
	    			flip = true
    		end
		end
		local i, o
			for i, o in ipairs(bullets) do
				o.x = o.x + math.cos(o.dir) * o.speed * pdt
				o.y = o.y + math.sin(o.dir) * o.speed * pdt
				if (o.x < -10) or (o.x > love.graphics.getWidth() + 10)
				or (o.y < -10) or (o.y > love.graphics.getHeight() + 10) then
					table.remove(bullets, i)
				end
			end
end

function collisionDetect()
	if ShipX-10 <= 0 then
		xvel = xvel * -1 * bounce
		ShipX = 10
	end
	if ShipX+10 >= love.window.getWidth() then
		xvel = xvel * -1 * bounce
		ShipX = love.window.getWidth()-10
	end
	if ShipY-10 <= 0 then
		yvel = yvel * -1 * bounce
		ShipY = 10
	end
	if ShipY+10 >= love.window.getHeight() then
		yvel = yvel * -1 * bounce
		ShipY = love.window.getHeight()-10
	end
end

function fade(state)
	if name ~= "debug" then
		if state == "in" then
			if alpha <= 255 then
				alpha = (alpha + (pdt * (255/4)))
			end
		elseif state == "out" then
			if alpha >= 0 then
   				alpha = (alpha - (pdt * (255/4)))
   			end
		else
			error("Invalid state", level)
		end
	else
		if state == "in" then
			alpha = 255
		elseif state == "out" then
			alpha = 0
		end
	end
end

function drawShip()
	if MouseControls then
			if drawMenuShip then
				love.graphics.draw(menuShip, ShipX, ShipY, rotate + 1.6, 1.2, 1.2, 20, 20)
			elseif drawKestral then
				love.graphics.draw(kestralShip, ShipX, ShipY, rotate + 1.6, 1, 1, 20, 35)
		    elseif drawRMS then
		    	love.graphics.draw(titanicShip, ShipX, ShipY, rotate + 1.6, 1, 1, 20, 35)
		    elseif drawCowboy then
		    	love.graphics.circle("fill")
		    else
		    	love.graphics.print("broken")
			end
		elseif MouseControls == false then
			if drawMenuShip then
				love.graphics.draw(menuShip, ShipX, ShipY, turn + 1.6, 1.2, 1.2, 20, 20)
			elseif drawKestral then
				love.graphics.circle("fill")
		    elseif drawRMS then
		    	love.graphics.circle("fill")
		    elseif drawCowboy then
		    	love.graphics.reset()
		    	love.graphics.circle("fill")
		    end
		end
end

function drawBullets()
	love.graphics.setColor(255, 255, 255)
	local i, o
	for i, o in ipairs(bullets) do
		love.graphics.circle('fill', o.x, o.y, 5, 15)
	end
end

function keyboardControls()
	if love.keyboard.isDown("w") then
	xvel = xvel + math.cos(turn)*(normSpeed/16)
	yvel = yvel + math.sin(turn)*(normSpeed/16)
	end

	if love.keyboard.isDown("s") then
	xvel = xvel - math.cos(turn)*(normSpeed/16)
	yvel = yvel - math.sin(turn)*(normSpeed/16)
	end
	if love.keyboard.isDown("a") then
		turn = turn - .1
	elseif love.keyboard.isDown("d") then
		turn = turn + .1
	end
	if love.keyboard.isDown(" ") then
		friction = 1.05
	else
		friction = 1.0085
	end
end

function MouseControl()
  if love.keyboard.isDown("w") then
	accel = accel + .5
	xvel = math.cos(rotate)*accel
	yvel = math.sin(rotate)*accel
	else
		if accel > 0 then
			accel = accel - 1
		end
	end
	if love.keyboard.isDown("s") then
	xvel = -math.cos(rotate)*accel
	yvel = -math.sin(rotate)*accel
	end
	if love.keyboard.isDown(" ") then
		friction = 1.05
		accel = accel - 5
	else
		friction = 1.01
  end
end

function testforButtonClick(Mx,My,tlx,tly,w,h)
   return Mx > tlx and
   		  Mx < tlx+w and 
   		  My > tly and 
   		  My < tly+h
end

function drawABC(x,y,letters)
	if letters == "a" then
		love.graphics.draw(AButton, love.window.getWidth()/2, love.window.getHeight() - y, r, 1, 1, 37, 37)
		if testforButtonClick(ShipX, ShipY, love.window.getWidth()/2-37, (love.window.getHeight() - y)-37, 75, 75) then
			love.graphics.draw(AButton, love.window.getWidth()/2, love.window.getHeight() - y, r, 1.1, 1.1, 37, 37)
		else
			love.graphics.draw(AButton, love.window.getWidth()/2, love.window.getHeight() - y, r, 1, 1, 37, 37)
		end
	end
	if letters == "ab" then
		love.graphics.draw(AButton, love.window.getWidth()/2 - x, love.window.getHeight() - y, r, 1, 1, 37, 37)
		love.graphics.draw(BButton, love.window.getWidth()/2 + x, love.window.getHeight() - y, r, 1, 1, 37, 37)
		if testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) - x, (love.window.getHeight() - y)-37, 75, 75) then
			love.graphics.draw(AButton, love.window.getWidth()/2 - x, love.window.getHeight() - y, r, 1.1, 1.1, 37, 37)
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) + x, (love.window.getHeight() - y)-37, 75, 75) then
			love.graphics.draw(BButton, love.window.getWidth()/2 + x, love.window.getHeight() - y, r, 1.1, 1.1, 37, 37)
		else
			love.graphics.draw(AButton, love.window.getWidth()/2 - x, love.window.getHeight() - y, r, 1, 1, 37, 37)
			love.graphics.draw(BButton, love.window.getWidth()/2 + x, love.window.getHeight() - y, r, 1, 1, 37, 37)
		end
	end
	if letters == "abc" then
		love.graphics.draw(AButton, love.window.getWidth()/2 - x, love.window.getHeight() - y, r, 1, 1, 37, 37)
		love.graphics.draw(BButton, love.window.getWidth()/2, love.window.getHeight() - y, r, 1, 1, 37, 37)
		love.graphics.draw(CButton, love.window.getWidth()/2 + x, love.window.getHeight() - y, r, 1, 1, 37, 37)
		if testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) - x, (love.window.getHeight() - y)-37, 75, 75) then
			love.graphics.draw(AButton, love.window.getWidth()/2 - x, love.window.getHeight() - y, r, 1.1, 1.1, 37, 37)
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37), (love.window.getHeight() - y)-37, 75, 75) then
			love.graphics.draw(BButton, love.window.getWidth()/2, love.window.getHeight() - y, r, 1.1, 1.1, 37, 37)
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) + x, (love.window.getHeight() - y)-37, 75, 75) then
			love.graphics.draw(CButton, love.window.getWidth()/2 + x, love.window.getHeight() - y, r, 1.1, 1.1, 37, 37)
		else
			love.graphics.draw(AButton, love.window.getWidth()/2 - x, love.window.getHeight() - y, r, 1, 1, 37, 37)
			love.graphics.draw(BButton, love.window.getWidth()/2, love.window.getHeight() - y, r, 1, 1, 37, 37)
			love.graphics.draw(CButton, love.window.getWidth()/2 + x, love.window.getHeight() - y, r, 1, 1, 37, 37)
		end
	end
	if letters == "abcd" then
		love.graphics.draw(AButton, love.window.getWidth()/2 - (x + (x/2)), love.window.getHeight() - y, r, 1, 1, 37, 37)
		love.graphics.draw(BButton, love.window.getWidth()/2 - (x/2), love.window.getHeight() - y, r, 1, 1, 37, 37)
		love.graphics.draw(CButton, love.window.getWidth()/2 + (x/2), love.window.getHeight() - y, r, 1, 1, 37, 37)
		love.graphics.draw(DButton, love.window.getWidth()/2 + (x + (x/2)), love.window.getHeight() - y, r, 1, 1, 37, 37)
		if testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) - (x + (x/2)), (love.window.getHeight() - y)-37, 75, 75) then
			love.graphics.draw(AButton, love.window.getWidth()/2 - (x + (x/2)), love.window.getHeight() - y, r, 1.1, 1.1, 37, 37)
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) - x/2, (love.window.getHeight() - y)-37, 75, 75) then
			love.graphics.draw(BButton, love.window.getWidth()/2 - x/2, love.window.getHeight() - y, r, 1.1, 1.1, 37, 37)
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) + x/2, (love.window.getHeight() - y)-37, 75, 75) then
			love.graphics.draw(CButton, love.window.getWidth()/2 + x/2, love.window.getHeight() - y, r, 1.1, 1.1, 37, 37)
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) + (x + (x/2)), (love.window.getHeight() - y)-37, 75, 75) then
			love.graphics.draw(DButton, love.window.getWidth()/2 + (x + (x/2)), love.window.getHeight() - y, r, 1.1, 1.1, 37, 37)
		else		
			love.graphics.draw(AButton, love.window.getWidth()/2 - (x + (x/2)), love.window.getHeight() - y, r, 1, 1, 37, 37)
			love.graphics.draw(BButton, love.window.getWidth()/2 - x/2, love.window.getHeight() - y, r, 1, 1, 37, 37)
			love.graphics.draw(CButton, love.window.getWidth()/2 + x/2, love.window.getHeight() - y, r, 1, 1, 37, 37)
			love.graphics.draw(DButton, love.window.getWidth()/2 + (x + (x/2)), love.window.getHeight() - y, r, 1, 1, 37, 37)
		end
	end
end

function testABC(x,y,letters)
	if letters == "a" then
		if testforButtonClick(ShipX, ShipY, love.window.getWidth()/2-37, (love.window.getHeight() - y)-37, 75, 75) then
			testA = true
		else
			testA = false
		end
	elseif letters == "ab" then
		if testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) - x, (love.window.getHeight() - y)-37, 75, 75) then
			testA = true
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) + x, (love.window.getHeight() - y)-37, 75, 75) then
			testB = true
		else
			testA, testB = false, false
		end
	elseif letters == "abc" then
		if testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) - x, (love.window.getHeight() - y)-37, 75, 75) then
			testA = true
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37), (love.window.getHeight() - y)-37, 75, 75) then
			testB = true
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) + x, (love.window.getHeight() - y)-37, 75, 75) then
			testC = true
		else
			testA, testB, testC = false, false, false
		end
	elseif letters == "abcd" then
		if testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) - (x + (x/2)), (love.window.getHeight() - y)-37, 75, 75) then
			testA = true
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) - x/2, (love.window.getHeight() - y)-37, 75, 75) then
			testB = true
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) + x/2, (love.window.getHeight() - y)-37, 75, 75) then
			testC = true
		elseif testforButtonClick(ShipX, ShipY, (love.window.getWidth()/2-37) + (x + (x/2)), (love.window.getHeight() - y)-37, 75, 75) then
			testD = true
		else
			testA, testB, testC, testD = false, false, false, false
		end
	end
end

function drawShipRename()
	if drawShipRenameScreen then
		love.graphics.printf("Would you like to rename your ship?\n\nPress Y for yes or N for no.", 1, love.window.getHeight()/2 - 50, love.window.getWidth(), "center", r, sx, sy, 25)
	end
	if drawShipRenameScreen2 then
		love.graphics.printf("What would you like to name your ship?", 1, love.window.getHeight()/2 - 50, love.window.getWidth(), "center", r, sx, sy, 25)
	end
	if printShipName then
		love.graphics.print(shipName, love.window.getWidth()/2, love.window.getHeight()/2 + 100, r, sx, sy, shipNameLength*12)
	end
end

function drawmain()
  if runMain then
	if drawKestral then
		drawKestralMenu(pathState)
	elseif drawRMS then
		drawTitanicMenu(pathState)
	elseif drawCowboy then
		drawCowboyMenu(pathState)
	end
  end
end

function testmain()
  if runMain then
	if drawKestral then
		testKestralMenu(pathState)
	elseif drawRMS then
		testTitanicMenu(pathState)
	elseif drawCowboy then
		testCowboyMenu(pathState)
	end
  end
end

function testKestralMenu(state)
	if state == 1 then
		testks1()
	elseif state == 2 then
		testks2()
	elseif state == 3 then
		testks3()
	end
end

function testTitanicMenu(state)
	if state == 1 then
		testtm1()
	elseif state == 2 then
		testtm2()
	elseif state == 3 then
		testtm3()
	end
end

function testCowboyMenu(state)
	if state == 1 then
		testcm1()
	elseif state == 2 then
		testcm2()
	elseif state == 3 then
		testcm3()
	end
end

function drawKestralMenu(state)
	if state == 1 then
		drawks1()
	elseif state == 2 then
		drawks2()
	elseif state == 3 then
		drawks3()
	end
end

function drawTitanicMenu(state)
	if state == 1 then
		drawtm1()
	elseif state == 2 then
		drawtm2()
	elseif state == 3 then
		drawtm3()
	end
end

function drawCowboyMenu(state)
	if state == 1 then
		drawcm1()
	elseif state == 2 then
		drawcm2()
	elseif state == 3 then
		drawcm3()
	end
end

function testGas()
	if runGas then
		testABC(150,300,"abcd")
		if Apressed then
			if creditAmount >= 150 then
				enoughCredits = true
				boughtGas = true
				creditAmount = creditAmount - 150
				gasAmount = gasAmount + 1
			else
				enoughCredits = false
				boughtGas = true
			end
			Apressed = false
		end
		if Bpressed then
			if creditAmount >= 500 then
				enoughCredits = true
				boughtGas = true
				creditAmount = creditAmount - 500
				gasAmount = gasAmount + 5
			else
				enoughCredits = false
				boughtGas = true
			end
			Bpressed = false
		end
		if Cpressed then
			if creditAmount >= 1000 then
				enoughCredits = true
				boughtGas = true
				creditAmount = creditAmount - 1000
				gasAmount = gasAmount + 10
			else
				enoughCredits = false
				boughtGas = true
			end
			Cpressed = false
		end
		if Dpressed then
			if creditAmount >= 5000 then
				enoughCredits = true
				boughtGas = true
				creditAmount = creditAmount - 5000
				gasAmount = tankCap
			else
				enoughCredits = false
				boughtGas = true
			end
			Dpressed = false
		end
	end
end

function drawGas()
	if runGas then
		love.graphics.draw(hheadTable[gasHead], love.window.getWidth()/2 - 50, y, r, 1, 1)
		love.graphics.draw(hbodyTable[gasBody], love.window.getWidth()/2 - 50, y, r, 1, 1)
		drawABC(150,300,"abcd")
		love.graphics.print("    1 gal/\n150 credits", love.window.getWidth()/2 - 225, love.window.getHeight() - 400, r, sx, sy, BMSpaceFont:getWidth("150 credits")/2, oy, kx, ky)
		love.graphics.print("    5 gal/\n500 credits", love.window.getWidth()/2 - 75, love.window.getHeight() - 250, r, sx, sy, BMSpaceFont:getWidth("500 credits")/2, oy, kx, ky)
		love.graphics.print("    10 gal/\n1000 credits", love.window.getWidth()/2 + 75, love.window.getHeight() - 400, r, sx, sy, BMSpaceFont:getWidth("1000 credits")/2, oy, kx, ky)
		love.graphics.print("Fill up your tank!\n  5000 credits.", love.window.getWidth()/2 + 250, love.window.getHeight() - 250, -math.pi/6, sx, sy, BMSpaceFont:getWidth("Fill up your tank!")/2, oy, kx, ky)
		if boughtGas ~= true then
			love.graphics.printf("Welcome, to the gas station! Would you like to buy some gas?", 1, love.window.getHeight() - 550, love.window.getWidth(), "center")	
			love.graphics.printf("Your tank can hold " .. tankCap .. " gallons!\nYou have " .. creditAmount .. " credits.\nYou have " .. gasAmount .. " gallons of gas.", 1, love.window.getHeight() - 525, love.window.getWidth(), "center")
		else
			if enoughCredits then
				love.graphics.printf("Enjoy your gas!", 1, love.window.getHeight() - 500, love.window.getWidth(), "center")
			else
				love.graphics.printf("You don't have enough credits!", 1, love.window.getHeight() - 500, love.window.getWidth(), "center")
			end
		end
	end
end

function crewScreen()
end

function setupChar()
	if pickYourShip then
		drawShipSelectScreen = true
	end
	if drawShipRenameScreen then
		drawShipSelectScreen = false
	end
end

function shipRenameAsk()
	if drawShipRenameScreen then
		if pkey == "y" then
			drawShipRenameScreen, pickYourShip = false, false
			drawShipRenameScreen2 = true
			printShipName = true
		elseif pkey == "n" then
			drawShipRenameScreen, pickYourShip = false, false
			runMain = true
		end
	end
end

function shipRenameInput()
	if drawShipRenameScreen2 then
		if pkey == "backspace" then 
			shipName = shipName:sub(1, -2)
			shipNameLength = shipNameLength - 1
			if shipNameLength <= 0 then
				shipNameLength = 0
			end
		end
		if pkey == "return" then
			drawShipRenameScreen2, printShipName = false, false
			runMain = true
		end
	end
end

function drawCoords()
	sxloc = math.floor(ShipX)
	syloc = math.floor(ShipY)
	love.graphics.print(sxloc, x, 100)
	love.graphics.print(syloc, 150, 100)
end

function retireScreen()
	if fadeMain then
		fade("out")
		if alpha <= 1 then
			fadeMain, drawMainScreen = false, false
			drawRetire = true
			alpha = 0
		end
	end
	if drawRetire then
		love.graphics.printf("Congratulations, " .. name .. "!", 1, sc + 50, love.window.getWidth(), "center", r, sx, sy, ox, oy, kx, ky)
		love.graphics.printf("You and your crew have decided to retire.", 1, sc + 75, love.window.getWidth(), "center", r, sx, sy, ox, oy, kx, ky)
		love.graphics.printf("You earned " .. creditAmount .. " credits and have "  .. crewAmount .. " crew members left.", 1, sc + 100, love.window.getWidth(), "center", r, sx, sy, ox, oy, kx, ky)
		if creditAmount > 1000000000 then
			love.graphics.printf("Holy shit, you're a billionare! Try not to get robbed, and enjoy life!!", 1, sc + 125, love.window.getWidth(), "center", r, sx, sy, ox, oy, kx, ky)
		elseif creditAmount > 1000000 then
			love.graphics.printf("A million credits. You'll never want for anything again.", 1, sc + 125, love.window.getWidth(), "center", r, sx, sy, ox, oy, kx, ky)
		elseif creditAmount > 1000 then
			love.graphics.printf("With more than a thousand credits, you and your crew lived large for about a month, before becoming totally broke. Not really much of a retirement.", 1, 75, love.window.getWidth(), "center", r, sx, sy, ox, oy, kx, ky)
		elseif creditAmount > 150 then
			love.graphics.printf("Did you even play the game?", 1, sc + 125, love.window.getWidth(), "center", r, sx, sy, ox, oy, kx, ky)
		else 
			love.graphics.printf("Retiring with no money? Really?", 1, sc + 125, love.window.getWidth(), "center", r, sx, sy, ox, oy, kx, ky)
		end
		if timer >= 10 then
			creditsState = 2
		end
	end
end

function testShipClick()
	if drawKestral then
		if testforButtonClick(love.mouse.getX(), love.mouse.getY(), ShipX, ShipY, 42, 74) then
		end
	elseif drawRMS then
		if testforButtonClick(love.mouse.getX(), love.mouse.getY(), ShipX, ShipY, 34, 108) then
		end
	elseif drawCowboy then
	end
end