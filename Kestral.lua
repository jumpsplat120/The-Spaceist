function drawks1()
	if drawMainScreen then
		love.graphics.setColor(255, 255, 255, alpha)
		love.graphics.draw(Asteroid, 150, 150, spin, .5, .5, 290, 290)
		love.graphics.draw(monster,	WindowWidth - 150, 150, spin*1.3, .5, .5, 200, 200)
		love.graphics.draw(planet, 150, WindowHeight - 150, spin*.05, .5, .5, 300, 300)
		love.graphics.draw(gasStation,	WindowWidth/2, WindowHeight - 150, spin*1.75, .3, .3, 150, 150)
		if hoverAstroid then
			love.graphics.print("Mine an asteroid.", 150, 325, r, sx, sy, ox, oy, kx, ky)
		elseif hoverMonster then
			love.graphics.print("Go looking for trouble.", WindowWidth - 150, 250, r, sx, sy, ox, oy, kx, ky)
		elseif hoverPlanet then
			love.graphics.print("Fly to the nearest planet.", 150, WindowHeight - 175, r, sx, sy, ox, oy, kx, ky)
		elseif hovergasStation then
			love.graphics.print("Refuel!", WindowWidth/2, WindowHeight - 175, r, sx, sy, ox, oy, kx, ky)
		end
		if canRetire then
			love.graphics.draw(retire, WindowWidth - 120, WindowHeight - 120, r, .8, .8, 150, 150)
		end
	end
end

function testks1()
	if drawMainScreen then
		hoverAstroid, hoverMonster, hoverPlanet, hovergasStation = false, false, false, false
		if testforButtonClick(ShipX, ShipY, 0, 0, 290, 290) then
			hoverAstroid = true
		elseif testforButtonClick(ShipX, ShipY, WindowWidth-200, 50, 200, 200) then
			hoverMonster = true
		elseif testforButtonClick(ShipX, ShipY, 0, WindowHeight - 300, 300, 300) then
			hoverPlanet = true
		elseif testforButtonClick(ShipX, ShipY, WindowWidth/2 - 75, WindowHeight - 200, 150, 150) then
			hovergasStation = true
		end
		if canRetire then
			if testforButtonClick(ShipX, ShipY, WindowWidth - 50, WindowHeight - 50, 75, 75) then
				fadeMain = true
				timer = 0
			else
				fadeMain = false
				if alpha < 254 then
					fade("in")
				end
			end
		end
	end
end

function drawks2()
end

function testks2()
end

function drawks3()
end

function testks3()
end

function dlft1a()
	if pathState == 1 then
		if lftPath == 1 then
			love.graphics.printf("You have come upon a derilict space station, floating in the middle of nowhere. You take one look at it, and you and your crew agree that there is some good loot on that ship. However, as a grizzled captain, you know that a derilict space stations like this one don't end up floating in the middle of nowhere for nothing. You guys talk amongst yourselves and come up with three different choices. You can...", 10, 150, WindowWidth - 10, "center")
		end
	end
end

function dlft2a()
	if pathState == 1 then
		if lftPath == 2 then
		end
	end
end

function dlft3a()
	if pathState == 1 then
		if lftPath == 3 then
		end
	end
end

function dlft1b()
	if pathState == 2 then
		if lftPath == 1 then
		end
	end
end

function dlft2b()
	if pathState == 2 then
		if lftPath == 2 then
		end
	end
end

function dlft3b()
	if pathState == 2 then
		if lftPath == 3 then
		end
	end
end

function dlft1c()
	if pathState == 3 then
		if lftPath == 1 then
		end
	end
end

function dlft2c()
	if pathState == 3 then
		if lftPath == 2 then
		end
	end
end

function dlft3c()
	if pathState == 3 then
		if lftPath == 3 then
		end
	end
end