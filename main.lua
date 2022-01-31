-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')


--Cette ligne permet de déboguer pas à pas 
if arg[#arg] == "-debug" then require("mobdebug").start() end

local pad = {}
pad.x = 0
pad.y = 0
pad.largueur = 80
pad.hauteur = 30
pad.image = love.graphics.newImage("images/Racket.png")

local balle = {}
balle.x = 0
balle.y = 0
balle.rayon = 10
balle.colle = false
balle.vx = 0
balle.vy = 0

local Brique = {}
local niveau = {}

function Demarre()
  balle.colle = true
  Brique.points = 0
  local l,c --l pour ligne, c pour colonne
  
  niveau = {}
  for l = 1, 6 do
    niveau[l] = {}
    
    for c = 1, 15 do
      niveau[l][c] = 1
    end
  end
  
end

function love.load()
  largueur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  pad.y = hauteur - ( pad.y / 2)
  
  Brique.hauteur = 25
  Brique.largueur = largueur / 15
  Demarre()

end

function love.update(dt)
  pad.x = love.mouse.getX()
  
  
  if balle.colle == true then
    balle.x = pad.x
    balle.y = pad.y - (pad.hauteur/2 + balle.rayon)
    Demarre()
  else
    balle.y = balle.y + (balle.vy * dt)
    balle.x = balle.x + (balle.vx * dt)
  end

  local c = math.floor(balle.x / Brique.largueur) + 1
  local l = math.floor(balle.y / Brique.hauteur) + 1
  
  if  l >= 1 and l<= #niveau and c >= 1 and c <= 15 then
    if niveau[l][c] == 1 then
      balle.vy = 0 - balle.vy + 10
      niveau[l][c] = 0
      Brique.points = Brique.points + 1
      balle.vx = balle.vx + 10
    end
  end
  if balle.x > largueur then
    balle.vx = 0 - balle.vx
    balle.x = largueur
  end
  if balle.x < 0 then
    balle.vx = 0 - balle.vx
    balle.x = 0
  end
  if balle.y < 0 then
    balle.vy = 0 - balle.vy
    balle.y = 0
  end
  if  balle.y > hauteur then
    balle.colle = true
    balle.y = hauteur
    
  end
  
  local CollisionPad = pad.y - (pad.hauteur/2) - balle.rayon
  if balle.y > CollisionPad then
    local dist = math.abs(pad.x - balle.x)
    if dist < pad.largueur/2 then
      balle.vy = 0 - balle.vy
      balle.y = CollisionPad
    end
  end
  
end
function love.draw()
  
  local l,c --l pour ligne, c pour colonne
  local bx, by = 0, 0
  
  for l = 1, 6 do
    for c = 1, 15 do
      if niveau[l][c] == 1 then
        love.graphics.rectangle("fill", bx + 1 , by + 1, Brique.largueur - 2, Brique.hauteur - 2)
      end
      bx = bx + Brique.largueur
      if bx > 15 * Brique.largueur then bx = 0 end
    end
    by = by + Brique.hauteur
  end
  
  love.graphics.rectangle("fill", pad.x - (pad.largueur / 2), pad.y - (pad.hauteur / 2), pad.largueur, pad.hauteur)
  
  love.graphics.circle("fill", balle.x, balle.y, balle.rayon)
  
  love.graphics.print("Points: "..tostring(Brique.points),  250, 250)
end

function love.keypressed(key)
  
  print(key)
  
end

function love.mousepressed(x, y, n)
  if balle.colle == true then
    balle.colle = false
    balle.vx = 200
    balle.vy = -200
  end
end