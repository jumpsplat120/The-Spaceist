require "functions"
require "Kestral"
require "Titanic"
require "Cowboy"
require "libs/loveframes"
require "menu"
require "lovedebug"

function love.load()
	SeedSetter()
	AssetsToLoad()
	SetDefaultValues()
end

function love.update(dt)

pdt = dt

MouseX = love.mouse.getX()
MouseY = love.mouse.getY()
WindowWidth = love.graphics.getWidth()
WindowHeight = love.graphics.getHeight()
musicVolume = love.audio.getVolume()

sc = sc + (pdt*10)
timer = timer + pdt
spin = spin + pdt

if inGame == false then
	love.audio.play(MenuMusic)
else
	MenuMusic:stop()
	love.audio.play(GameMusic)
	setupChar()
end

if player.heat > 0 then
	player.heat = player.heat - .1
end

if drawMenuShip then
	shootBullets()
end

if MouseControls then
	rotate = math.atan2(MouseY - ShipY, MouseX - ShipX )
	turn = rotate
	MouseControl()
elseif MouseControls == false then
	keyboardControls()
end

collisionDetect()
testCredits()
testOptions()
testPlay()
testControls()
testmain()
testGas()
testKestral()

if creditsState == 2 then
	fade("in")
end
if drawShipSelectScreen then
	fade("in")
end

	ShipX = ShipX + xvel/10
	ShipY = ShipY + yvel/10

	xvel = xvel/friction
	yvel = yvel/friction

	if accel < 0 then
		accel = .1
	end

	loveframes.update(dt)
end

function love.draw()
	for w = 0, love.graphics.getWidth() / BackgroundImage:getWidth() do
		for h = 0, love.graphics.getHeight() / BackgroundImage:getHeight() do
			love.graphics.draw(BackgroundImage, w * BackgroundImage:getWidth(), h * BackgroundImage:getHeight())
		end
	end

drawOptions()
drawControls()
drawPlay()
drawCredits()
drawShipSelect()
drawShipRename()
drawmain()
retireScreen()
drawGas()

if printName then
	love.graphics.print(name, WindowWidth/2, WindowHeight/2 + 100, r, sx, sy, nameLength*12)
end

if drawMenuShip then
	drawBullets()
end

drawShip()
loveframes.draw()
end

function love.mousepressed(x, y, button)

	loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)

	loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
	pkey = key
	debugMenufnct()
	welcomeToInput()
	shipRenameAsk()
	shipRenameInput()
	loveframes.keypressed(key, unicode)
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
	if hovergasStation then
		if key == "return" then
				gasHead = math.floor(math.random(1,9))
				gasBody = math.floor(math.random(1,6))
				runGas = true
				drawMainScreen, Apressed, Bpressed, Cpressed, Dpressed, hovergasStation = false, false, false, false, false
		end
	end
	if runGas then
		if key == "escape" then
			drawMainScreen = true
			runGas, boughtGas, Apressed, Bpressed, Cpressed, Dpressed = false,false, false, false, false, false
			enoughCredits = nil
		end
	end
	if hoverMonster then
		if key == "return" then
			--switch to random later
			lftPath = 1
			drawMainScreen = false
		end
	end
	if creditsState == 2 then
		if key == "escape" then
			alpha = 0
			creditsState, playState, optionsState, controlsState = 1, 1, 1, 1
		end
	end
	loveframes.keyreleased(key)
end

function love.textinput(text)
	if welcomeTo then
		if nameLength <= 25 then
			name = name .. text
			nameLength = nameLength + 1
			printName = true
		end
	end
	if drawShipRenameScreen2 then
		if shipNameLength <= 25 then
			shipName = shipName .. text
			shipNameLength = shipNameLength + 1
		end
	end
loveframes.textinput(text)
end