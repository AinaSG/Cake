require("TEsound") --Llibreria per a controlar so
TEsound.playLooping("art/siad.mp3", "music")
love.mouse.setVisible(false)

function love.load()
	--Carreguem fondos
	bg = {}
	bg[0] = love.graphics.newImage("art/bg0.png")
	bg[1] = love.graphics.newImage("art/bg1.png")
	bg[2] = love.graphics.newImage("art/bg2.png")
	bg[3] = love.graphics.newImage("art/bg3.png")

	--carreguem imatges de decoració
	img_vegetables = love.graphics.newImage("art/vegetables.png")
	img_cake = love.graphics.newImage("art/cake.png")
	img_crap = love.graphics.newImage("art/crap.png")
	img_sitingfatrobot = love.graphics.newImage("art/sitingfatrobot.png");
	img_aina_backward = love.graphics.newImage("art/aina_backward.png")
	img_aina_forward = love.graphics.newImage("art/aina_forward.png")
	img_aina = love.graphics.newImage("art/aina.png")
	img_key = {}
	img_key[1] = love.graphics.newImage("art/key_1.png")
	img_key[3] = love.graphics.newImage("art/key_3.png")

	--carreguem imatges de logro de nivell
	levelthing = {}
	levelthing[1] = {}
	levelthing[1].stand = love.graphics.newImage("art/manya1.png")
	levelthing[1].move = love.graphics.newImage("art/manya2.png")
	levelthing[2] = {}
	levelthing[2].stand = love.graphics.newImage("art/fatrobot1.png")
	levelthing[2].move = love.graphics.newImage("art/fatrobot2.png")
	levelthing[3] = {}
	levelthing[3].stand = love.graphics.newImage("art/aleix1.png")
	levelthing[3].move = love.graphics.newImage("art/aleix2.png")

	--Nivell actual
	current_level = 1

	--Carreguem Player
	laia = {}
	laia.stand = love.graphics.newImage("art/standing.png")
	laia.move_left = love.graphics.newImage("art/left.png")
	laia.move_right = love.graphics.newImage("art/right.png")

	--carreguem fonts
	title_font = love.graphics.newFont("art/font.ttf",128)
	text_font = love.graphics.newFont("art/font.ttf",64)
	key_font = love.graphics.newFont("art/font.ttf",48)

	--Carreguem material per a title
	title_laia = love.graphics.newImage("art/title.png")
  	title_dt = 0

  	--Indicador d'estat
  	state = "title"

  	--Carreguem velocitats d'spawn i temps de duració
	rate_cake_dt = 0
	life_cake = 4
	rate_craps_dt = 0
	life_craps = 10 
	rate_vegetables_dt = 0
	life_vegetables = 9

	--Carreguem jugador i dades de jugador
	jugador = {}
	jugador.x = 400
	jugador.y = 400
	jugador.jumping = false
	jugador.img = laia.stand
	jugador.facing = "left"
	jugador.rad = 100
	jugador.cake = 0
	jugador.level_cake = {}
	jugador.level_fail = {}
	jugador.level_cake[1] = 0
	jugador.level_cake[2] = 0
	jugador.level_cake[3] = 0

	--Iniciem el joc
	level_init()
end


--Draw
function love.draw()
	--Draw del titol
  if state == "title" then
    love.graphics.draw(bg[0],0,0)
    love.graphics.setColor(0,0,0,255)
    love.graphics.setFont(title_font)
    love.graphics.printf("Cake!",0,48,800,"center")
    love.graphics.setFont(text_font)
    love.graphics.printf("Un joc sobre aconseguir prou pastís per a tothom.",0,136,800,"center")
    love.graphics.printf("Apreta Espai!",0,136+40,800,"center")
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(title_laia,400,400,math.sin(title_dt)/4,1,1,200,150)

    --Draw de la pantalla de sortir
  elseif state == "quit" then
    love.graphics.setColor(255,255,255,255)
    love.graphics.setFont(text_font)
    love.graphics.draw(img_aina,0,0)
    love.graphics.draw(img_sitingfatrobot,600-img_sitingfatrobot:getWidth()/2,550-img_sitingfatrobot:getHeight())
    love.graphics.printf("Per mots anys i gracies per jugar! :D \nProgramació i art: Aina!\n Framework: Love2d.org",420,20,360,"center")

    --Draw de la intro i instruccions 
  elseif state == "intro" then
    love.graphics.draw(bg[0],0,0)
    love.graphics.setColor(0,0,0,255)
    love.graphics.setFont(title_font)
    love.graphics.printf("Com jugar",0,96,800,"center")
    love.graphics.setFont(text_font)
    love.graphics.printf("Utilitza WASD per controlar al jugador!",0,232,800,"center")
    love.graphics.setColor(255,255,255,255)
    local key_x = 90
    local key_y = 350-17
    love.graphics.draw(img_key[1],64+key_x,key_y,0,.5)
    love.graphics.draw(img_key[1],key_x,64+key_y,0,.5)
    love.graphics.draw(img_key[1],64+key_x,64+key_y,0,.5)    
    love.graphics.draw(img_key[1],128+key_x,64+key_y,0,.5)
    love.graphics.draw(img_key[3],key_x,128+key_y,0,.5)
    love.graphics.setFont(key_font)
    love.graphics.setColor(0,0,0,255)
    love.graphics.printf("W",64+key_x,key_y,64,"center")
    love.graphics.printf("S",64+key_x,64+key_y,64,"center")
    love.graphics.printf("A",key_x,64+key_y,64,"center")
    love.graphics.printf("D",128+key_x,64+key_y,64,"center")
    love.graphics.printf("ESPAI",key_x,128+key_y,192,"center")
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(img_cake,400,360,0,1,1,33,33)
    love.graphics.draw(img_vegetables,400,430,0,1,1,32,24)
    love.graphics.draw(img_crap,400,500,0,1,1,27,37)
    love.graphics.setColor(0,0,0,255)
    love.graphics.print("Pastís: Agafa! (+1)",450,360-35)
    love.graphics.print("Verdura: Mai! Quin fàstic! (-4)",450,430-35)
    love.graphics.print("Caca de gos: Ewwww! (-16)",450,500-35)
    love.graphics.setColor(255,255,255,255)

    --Draw del joc YAAAAAAAAY!
  elseif state == "game" then
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(bg[current_level],0,0) --Carreguem el fondo del nivell actual

    for i,v in ipairs(craps) do --Dibuixem les caques
      if v.time + life_craps > love.timer.getTime() then
        if v.time + life_craps - 1 < love.timer.getTime() then
          if (love.timer.getTime()*1000)%240 > 120 then
            love.graphics.draw(img_crap,v.x,v.y,0,-1+(2*v.rot),1,27,37)
          end
        else
          love.graphics.draw(img_crap,v.x,v.y,0,-1+(2*v.rot),1,27,37)
        end
      end
    end

    for i,v in ipairs(cake_lost) do 
      love.graphics.draw(img_cake,v.x,v.y,0,0.5,0.5,img_cake:getWidth()/2,img_cake:getWidth()/2)
    end
    love.graphics.setColor(255,255,255,255)
    if scamper_for_level then
      local temp_frame = love.timer.getTime()*1000%480
      if temp_frame > 360 then
        love.graphics.draw(scamper_for_level.img.stand,scamper_for_level.x,scamper_for_level.y,0,1,1,scamper_for_level.img.stand:getWidth()/2)
      elseif temp_frame > 240 then
        love.graphics.draw(scamper_for_level.img.move,scamper_for_level.x,scamper_for_level.y,0,1,1,scamper_for_level.img.move:getWidth()/2)
      elseif temp_frame > 120 then
        love.graphics.draw(scamper_for_level.img.stand,scamper_for_level.x,scamper_for_level.y,0,-1,1,scamper_for_level.img.stand:getWidth()/2)
      else -- temp_frame <= 120
        love.graphics.draw(scamper_for_level.img.move,scamper_for_level.x,scamper_for_level.y,0,-1,1,scamper_for_level.img.move:getWidth()/2)
      end
    end

    local jrot = 0
    if jugador.jumping and jugador.timeleft < 0 then
      jrot = jugador.jumping / 180 * math.pi*2
    end
    if jugador.facing == "left" then
      love.graphics.draw(jugador.img,jugador.x,jugador.y,jrot,1,1,150,150)
    else
      love.graphics.draw(jugador.img,jugador.x,jugador.y,jrot,-1,1,150,150)
    end
    
    --love.graphics.circle("line",jugador.x,jugador.y,100,100) --intersecció del jugador per a fer debug
    
    for i,v in ipairs(cake) do --Dibuixem els pastissos
      if v.time + life_cake > love.timer.getTime() then
        if v.time + life_cake - 1 < love.timer.getTime() then
          if (love.timer.getTime()*1000)%240 > 120 then
            love.graphics.draw(img_cake,v.x,v.y,v.rot,1,1,33,33)
          end
        else
          love.graphics.draw(img_cake,v.x,v.y,v.rot,1,1,33,33)
        end
      end
    end

    for i,v in ipairs(vegetabless) do --Dibuixem els vegetals
      if v.time + life_vegetables > love.timer.getTime() then
        love.graphics.draw(img_vegetables,v.x,v.y,v.rot+math.sin(love.timer.getTime()-v.time),v.v_x/100,1,32,24)
      end
    end
    draw_indicadors() --Dibuixem els indicadors
    love.graphics.setColor(0,0,0,255)

  --Draw del final de la partida
  elseif state == "gameover" then
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(bg[0],0,0)
    love.graphics.setColor(0,0,0,255)
    love.graphics.setFont(title_font)
    love.graphics.printf("Game Over!",0,48,800,"center")
    love.graphics.setFont(text_font)
    love.graphics.printf("Pastissos totals:"..string.format("%.2f",(jugador.level_cake[1]+jugador.level_cake[2]+jugador.level_cake[3])),0,136,800,"center")
    local temp_frame = love.timer.getTime()*1000%480
    for i = 1,3 do
      local i_x = 600 * i / 3 - 100
      local i_y = 330
      love.graphics.setColor(0,0,0,255)
      love.graphics.printf("NIVELL"..i,i_x,i_y-96-8,200,"center")
      if not jugador.level_fail[i] then
        love.graphics.printf(string.format("%.2f",jugador.level_cake[i]),i_x,i_y-64,200,"center")
        love.graphics.setColor(255,255,255,255)
        if i == 2 then
          i_x = i_x - 25 -- PEAZO ROBO.
        end
        if temp_frame > 360 then
          love.graphics.draw(levelthing[i].stand,i_x+levelthing[i].stand:getWidth()/2,i_y,0,1,1,levelthing[i].stand:getWidth()/2)
        elseif temp_frame > 240 then
          love.graphics.draw(levelthing[i].move,i_x+levelthing[i].move:getWidth()/2,i_y,0,1,1,levelthing[i].move:getWidth()/2)        
        elseif temp_frame > 120 then
          love.graphics.draw(levelthing[i].stand,i_x+levelthing[i].stand:getWidth()/2,i_y,0,-1,1,levelthing[i].stand:getWidth()/2)
        else -- temp_frame <= 120
          love.graphics.draw(levelthing[i].move,i_x+levelthing[i].move:getWidth()/2,i_y,0,-1,1,levelthing[i].move:getWidth()/2)        
        end
      else
        love.graphics.printf("FAIL",i_x,i_y-64,200,"center")
        love.graphics.setColor(255,255,255,255)
        if temp_frame > 360 then
          love.graphics.draw(img_aina_forward,i_x+img_aina_forward:getWidth()/2,i_y,0,1,1,img_aina_forward:getWidth()/2)
        elseif temp_frame > 240 then
          love.graphics.draw(img_aina_backward,i_x+img_aina_backward:getWidth()/2,i_y,0,1,1,img_aina_backward:getWidth()/2)        
        elseif temp_frame > 120 then
          love.graphics.draw(img_aina_forward,i_x+img_aina_forward:getWidth()/2,i_y,0,-1,1,img_aina_forward:getWidth()/2)
        else -- temp_frame <= 120
          love.graphics.draw(img_aina_backward,i_x+img_aina_backward:getWidth()/2,i_y,0,-1,1,img_aina_backward:getWidth()/2)        
        end
      end
    end
  end
end

--Funció Update
function love.update(dt)
  TEsound.cleanup()

  --Update del Titol
  if state == "title" then
    title_dt = (title_dt + dt) % (math.pi*2)

  --Update de durant el joc
  elseif state == "game" then
    
    jugador.timeleft = jugador.timeleft - dt
    
    if not scamper_for_level and jugador.timeleft <= 0 then
      scamper_for_level = {
        x = -150,
        y = 270,
        img = levelthing[current_level]
      }
      TEsound.play("art/level"..current_level..".ogg")
    end
    
    if scamper_for_level then
      scamper_for_level.x = scamper_for_level.x + 3*210*dt
    end
    
    if jugador.timeleft < -5 then
      if jugador.level_fail[current_level] then
        jugador.level_cake[current_level] = 0      
      else
        jugador.level_cake[current_level] = jugador.cake
      end
      jugador.cake = 0
      if current_level < 3 then
        current_level = current_level + 1
        level_init()
      else
        state = "gameover"
      end
    end
    
    -- Update dels pastissos
    
    rate_cake_dt = rate_cake_dt + dt --Si toca, creem pastis nou
    if rate_cake_dt >= rate_cake and jugador.timeleft > 0 then
      rate_cake_dt = 0
      local cakes = {
        x = math.random(0,800),
        y = math.random(0,400),
        time = love.timer.getTime(),
        rot = math.random(-1,1)
      }
      table.insert(cake,cakes)
    end
    
    for i,v in ipairs(cake) do --Calculem si s ha d'eliminar un cake
      if v.time + life_cake < love.timer.getTime() then --Per vida
        table.remove(cake,i)
      end
      if distance(jugador,v)<jugador.rad then --O perque l hem pillat
        table.remove(cake,i)
        jugador.cake = jugador.cake + 1
        TEsound.play("art/cake.ogg")
      end
    end
    
    -- Update de les caques
    
    rate_craps_dt = rate_craps_dt + dt --Si toca, creem una caca nova
    if rate_craps_dt >= rate_craps and jugador.timeleft > 0 then
      rate_craps_dt = 0
      local crap = {
        x = math.random(0,800),
        y = -33,
        time = love.timer.getTime(),
        rot = math.random(0,1)
      }
      table.insert(craps,crap)
    end
    
    for i,v in ipairs(craps) do --Calculem si toca eliminar una caca
      if v.time + life_craps < love.timer.getTime() then --Per temps
        table.remove(craps,i)
      end
      if v.y < 470 then
        v.y = v.y + 100*dt
      else
        v.y = 470
      end
      if distance(jugador,v)<jugador.rad then --O perque l'hem xafat (ew...)
        table.remove(craps,i)
        add_cake_lost(16)
        TEsound.play("art/cake_lost_crap.ogg")
      end
    end
    
    -- vegetablesS
    
    rate_vegetables_dt = rate_vegetables_dt + dt --Calculem si toca crear vegetals
    if rate_vegetables_dt >= rate_vegetables and jugador.timeleft > 0 then
      rate_vegetables_dt = 0
      local dir = math.random(0,1)
      local vegetables = {
        x = dir*866-33,
        y = math.random(1,4)*100,
        time = love.timer.getTime(),
        rot = 0,
        v_x = dir*-200+100
      }
      table.insert(vegetabless,vegetables)
    end
    
    for i,v in ipairs(vegetabless) do --Calculem si toca eliminar vegetals
      if v.time + life_vegetables < love.timer.getTime() then --Per temps
        table.remove(vegetabless,i)
      end
      v.x = v.x + v.v_x * dt
      if distance(jugador,v)<jugador.rad then --O per tocat
        table.remove(vegetabless,i)
        add_cake_lost(4)
          TEsound.play("art/cake_lost_vegetables.ogg")
      end
    end
    
    -- Moviment, caminar, saltar
    
    if key_pressed.w then --SALTAR
      if not jugador.jumping then
        jugador.jumping = 0
        TEsound.play("art/jump.ogg")
      end
    end
    if jugador.jumping then
      jugador.jumping = jugador.jumping + dt*200
      if jugador.jumping < 180 then
        jugador.y = 400 - 300*math.sin(jugador.jumping / 180 * math.pi)^0.5
      else
        jugador.jumping = false
        jugador.y = 400
      end
    end

    if key_pressed.a then --ESQUERRA
      jugador.x = jugador.x - 400*dt
      jugador.facing = "left"
    end

    if key_pressed.d then --DRETA
      jugador.x = jugador.x + 400*dt
      jugador.facing = "right"
    end

    if key_pressed.s then --CAURE
      if jugador.jumping and jugador.jumping > 90 then
        jugador.jumping = jugador.jumping + dt*400
      end
    end
    
    -- IMATGES DEL JUGADOR
    
    if (key_pressed.a or key_pressed.d) and not jugador.jumping then
      local temp_frame = (love.timer.getTime()*1000)%480
      if temp_frame > 320 then
        jugador.img = laia.move_right
      elseif temp_frame > 240 then
        jugador.img = laia.stand
      elseif temp_frame > 120 then
        jugador.img = laia.move_left
      else -- temp_frame <= 120
        jugador.img = laia.stand
      end
    else
      if jugador.jumping then
        jugador.img = laia.move_left
      else
        jugador.img = laia.stand
      end
    end
    --Bordes del jugaador amb la pantalla  
    if jugador.x <= 0 then
      jugador.x = 0
    end
    if jugador.x > 800 then
      jugador.x = 800
    end
    
    for i,v in ipairs(cake_lost) do --Coses que surten disparades al perdre pastel
      if v.y > 650 then
        table.remove(cake_lost,i)
      else
        v.x = v.x + math.sin(v.dir)*100*dt
        v.y = v.y + math.abs(math.cos(v.dir)*100*dt) + 1
      end
    end
    
  end
end

--Util per al calcul de distancies
function distance(a,b)
  return math.sqrt((a.x-b.x)^2 + (a.y-b.y)^2)
end

--Funcions de dibuix d'indicadors
function draw_indicadors()
  love.graphics.setColor(0,0,0,255)
  if jugador.timeleft < 0 and current_level ~= 3 then
    love.graphics.printf("PRÔXIM NIVELL EN... "..string.format("%.0f",5-math.abs(jugador.timeleft)),0,514-8,800,"center")      
  else
    love.graphics.printf("NIVELL "..current_level,0,514-8,800,"center")
  end
  love.graphics.printf(string.format("%.2f",jugador.cake),0,550-8,150,"center")
  if jugador.timeleft > 0 then
    love.graphics.printf(string.format("%.0f",jugador.timeleft).."s",650,550-8,150,"center")
  end
  local cakew = img_cake:getWidth()/2
  local spacing = (800-300-cakew) / jugador.cake
  if spacing > cakew then
    spacing = cakew
  end
  love.graphics.setColor(255,255,255,255)
  for i = 1,jugador.cake do
    love.graphics.draw(img_cake,150+i*spacing,550,0,0.5,0.5,0,0)
  end
end

--Funciions per als pastissos perduts
cake_lost = {}
function add_cake_lost(x)
  if jugador.cake < x then
    x = jugador.cake
    jugador.cake = 0
    jugador.timeleft = 0
    jugador.level_fail[current_level] = true
  else
    jugador.cake = jugador.cake - x
  end
  for i = 1,x do
    local cake = {
      x = jugador.x,
      y = jugador.y,
      dir = math.random(1,360)
    }
    table.insert(cake_lost,cake)
  end
end

--Carregador del nivell
function level_init()
  scamper_for_level = nil
  jugador.timeleft = 60
  cake = {}
  craps = {}
  vegetabless = {}
  if current_level == 1 then
    rate_cake = 2
    rate_craps = 32
    rate_vegetables = 8
  elseif current_level == 2 then
    rate_cake = 1
    rate_craps = 16
    rate_vegetables = 4
  else -- level 3
    rate_cake = 0.5
    rate_craps = 8
    rate_vegetables = 2
  end
end

--Disparadors de tecles
key_pressed = {}
key_pressed.w = false;
key_pressed.s = false;
key_pressed.a = false;
key_pressed.d = false;
key_pressed.space = false;

function love.keypressed(key)
  if key == "escape" then
    if state == "quit" then
      love.event.push("q")    
    else
      state = "quit"
    end

  elseif key == "f11" then
    love.window.setFullscreen() --Rebenta (versió?) Arreglar

  elseif key == "w" then
    key_pressed.w = true

  elseif key == "a" then
    key_pressed.a = true

  elseif key == "s" then
    key_pressed.s = true

  elseif key == "d" then
    key_pressed.d = true

  elseif key == " " then --L'espai te varies funcions depenent del estat del joc 
    if state == "title" then
      love.load() --Cridem a love.load again
      state = "intro"
    elseif state == "intro" then
      state = "game"
    elseif state == "game" then
      -- Wheee!
    elseif state == "gameover" then
      state = "title" --I tornem al inici
    end
  end
end

--Disparadors de tecles no apretades
function love.keyreleased(key)
  if key == "w" then
    key_pressed.w = false
  elseif key == "a" then
    key_pressed.a = false
  elseif key == "s" then
    key_pressed.s = false
  elseif key == "d" then
    key_pressed.d = false
  end
end
