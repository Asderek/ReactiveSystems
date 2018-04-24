screenWidth, screenHeight = 800, 600
love.window.setMode(screenWidth,screenHeight);
turnAround = false;
advance = false;
doOnce = false;
gameover = false;
endgame = false;
pause = false;
tiro = {}





function wait (seconds, blip)
   
  blip.setActive(seconds)
  coroutine.yield()
   
end


function newblip (i)
  local x, y, width, height
  local sleepTime, startTime = 0,0
 
  width = 30
  height = 10
 
  i= i-1
 
  if i<10 then
    x = i*45
    y = 1*50
  elseif i<20 then
    x = (i%10)*45
    y = 2*50
  else
    x = (i%20)*45
    y = 3*50
  end 
 
  --local velocidade = math.random(0.3,1)
  local velocidade = 0.1
  local posIncrement = 45
  local color ={math.random(0,255), math.random(0,255), math.random(0,255)}
 
 
 
  local co = coroutine.wrap(
        function (self)         
         
          while(1) do
            sleepTime = 0
            startTime = 0
            x = x+posIncrement
           
            if ((x+width/2) > screenWidth-width) then
              turnAround = true;
            end
           
            if ((x-width/2) < 0+width) then
              turnAround = true;
              advance = true;
            end           
           
            wait(velocidade, self)
          end
       
        end)
     
  return {
    update = co,
       
    affected = function (pos)
      if pos>x-width/2 and pos<x+width/2 then
        return true
      else
        return false
      end
    end,
   
    draw = function ()
      love.graphics.setColor(255,255,255)
      love . graphics . print (velocidade , x+width/2 , y+height)
     
      love.graphics.setColor(color[1],color[2],color[3])
      love.graphics.rectangle("line", x, y, width, height)
    end,
   
    setActive = function (sleep)
      sleepTime = sleep
      startTime = os.clock()
    end,
   
    wakeUp = function ()
      return (os.clock() - startTime) > sleepTime
    end,
   
    turnAround = function ()
      posIncrement = posIncrement * -1
    end,
   
    advance = function ()
      if (y > screenHeight) then
        gameover = true
      end
      y = y+50;
      if (y > screenHeight) then
        gameover = true
      end
    end,
   
    checkHit = function (shotX, shotY)
      if (shotX >= x) and (shotX < x+width) then
        if (shotY <= y) and (shotY > y-height) then
          return true
        end
      end
     
    end,
    
    getMetric = function ()
      return x+width/2,y+width/2, width, height
    end
   
  }
end

function newplayer ()
  local x, y, width, height = 0, 200, 30, 10
  local color ={math.random(0,255), math.random(0,255), math.random(0,255)}
  
  local checkMovement = function ()
    if love.keyboard.isDown("w") then
        if (y < height) then
          return
        end
       
        y = y - height
      end
      if love.keyboard.isDown("a") then
        if (x-width/2 < 0) then
          return
        end
       
        x = x - width/2
      end
      if love.keyboard.isDown("s") then
        if (y+height > screenHeight) then
          return
        end
       
        y = y + height
      end
      if love.keyboard.isDown("d") then
        if (x+width/2 > screenWidth) then
          return
        end
        x = x + width/2
      end
  end
  
  local reset = function ()
      x = 0
      y = 200
  end
  
  local checkEndGame = function ()
    if #listabls <= 0 then
      if (doOnce == false) then
        doOnce = true
        io.write("Papapapaaaa pan pan paan papaannn\n");
        endgame = true;
      end
    end
  end

  local checkGetHit = function ()
    for index, value in ipairs(listabls) do
      enemyX, enemyY, enemyWidth, enemyHeight = listabls[index].getMetric()
      if ((x >= enemyX) and x < enemyX + enemyWidth) then
        if ((y >= enemyY) and y < enemyY + enemyHeight) then
          reset()
          gameover = true;
        end
      end
      
    end
  end
  
  
  
  return {
    try = function ()
      return x+width/2, y+height/2
    end,
 
    update = function ()
      checkMovement()
      checkEndGame()
      checkGetHit()
      
     
    end,
    
    draw = function ()
      love.graphics.setColor(color[1],color[2],color[3])
      love.graphics.rectangle("line", x, y, width, height)
    end,
    
    getColor = function ()
      return color
    end
      
    
  }
end

function newTiro (posX, posY, currentIndex)
  local x, y, width, height = posX, posY+10, 5, 10
  local myIndex = currentIndex
  local color = player.getColor()
 
 
  local checkDestroy = function ()
      if (y < height/2) then
        table.remove(tiro,myIndex)
       
        for index,value in ipairs(tiro) do
          tiro[index].updateIndex()
        end
      end
    end
   
  local checkHit = function ()
    for index, value in ipairs(listabls) do
      if (listabls[index].checkHit(x,y)) then
        table.remove(tiro,myIndex)
        table.remove(listabls,index)
        return
      end
    end
   
  end
 
 
  return {
    try = function ()
      return x+width/2, y+height/2
    end,
 
    update = function ()
      y = y - height
     
      checkHit()
     
      checkDestroy()
    
    end,
   
    draw = function ()
      love.graphics.setColor(color[1],color[2],color[3])
      love.graphics.rectangle("line", x, y, width, height)
    end,
   
    updateIndex = function ()
      myIndex = myIndex - 1
    end
   
   
   
  }
end



function love.keypressed(key)
  if key == 'r' then
    posX, posY = player.try()
    table.insert(tiro, newTiro(posX,posY, #tiro+1))
  end
  
  if key == 'p' then
    pause= not pause
  end
end

function love.load()
 
  major, minor, revision, codename = love.getVersion( )
  io.write("major = ",major, "  minor = ",minor, "  revision = ", revision, "  codename = ",codename)
 
 
  love.window.setMode(800,600)
  math.randomseed(os.time())
  player =  newplayer()
  listabls = {}
  for i = 1, 30 do
    listabls[i] = newblip(i)
  end
end

function love.draw()
  if gameover == true then
    love.graphics.setBackgroundColor(1,0,0,1)
    love.graphics.print("Game Over", screenWidth/2 - 100, screenHeight/2)
    return
  end
  
  if endgame == true then
    love.graphics.setBackgroundColor(1,0,0,1)
    love.graphics.print("Congrats you Won!!", screenWidth/2 - 100, screenHeight/2)
    return
  end
  
  
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end
 
  for index, value in ipairs(tiro) do
    tiro[index].draw()
  end
end

function love.update()
    if (pause == true) then
      return
    end
      
    if (player == nil) then
      return
    end
    
    
    player.update()
   
   
    for index, value in ipairs(tiro) do
      tiro[index].update()
    end
   
    for i = 1,#listabls do
      if(listabls[i].wakeUp()) then
        listabls[i]:update()
      end
    end
   
    if (turnAround == true) then
      for index, value in ipairs(listabls) do
        listabls[index].turnAround()
      end
      turnAround = false
    end
   
    if (advance == true) then
      for index, value in ipairs(listabls) do
        listabls[index].advance()
      end
      advance = false
    end
 
 
end

