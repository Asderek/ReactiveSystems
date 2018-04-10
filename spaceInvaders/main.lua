function wait (seconds, blip)
    
  blip.setActive(seconds)
  coroutine.yield()
  
  
  
  
  
end


function newblip (i)
  local x, y, width, height = 0, 10, 30, 10
  local sleepTime, startTime = 0,0
  
  --local velocidade = math.random(0.3,1)
  local velocidade = i
  local posIncrement = 45
  local color ={math.random(0,255), math.random(0,255), math.random(0,255)}
  
  
  
  local co = coroutine.wrap( 
        function (self)
          local screenWidth, screenHeight = love.graphics.getDimensions()
          
          
          while(1) do
            sleepTime = 0
            startTime = 0
            x = x+posIncrement
            if ((x+width/2) > screenWidth) then
              x = 0
            end
            
            
            wait(velocidade, self)
          end
        
        end)
      
  return {
    update = co,
        
    affected = function (pos)
      if pos>x-width/2 and pos<x+width/2 then
      -- "pegou" o blip
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
    end
    
    
    
  }
end



function newplayer ()
  local x, y, width, height = 0, 200, 30, 10
  local screenWidth, screenHeight = love.graphics.getDimensions( )
  return {
    try = function ()
      return x
    end,
  
    update = function ()
      x = x + width/10
      if (x+width/2) > screenWidth then
        x = 0
      end
    end,
    
    draw = function ()
      love.graphics.rectangle("line", x, y, width, height)
    end
  }
end



function love.keypressed(key)
  if key == 'a' then
    pos = player.try()
    for i in ipairs(listabls) do
      local hit = listabls[i].affected(pos)
      if hit then
        table.remove(listabls, i) -- esse blip "morre" 
        return -- assumo que apenas um blip morre
      end
    end
  end
end

function love.load()
  math.randomseed(os.time())
  player =  newplayer()
  listabls = {}
  for i = 1, 5 do
    listabls[i] = newblip(i)
    print(listabls[i].wakeUp());
  end
end

function love.draw()
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end
end

function love.update()
  player.update()
  for i = 1,#listabls do
    
    if(listabls[i].wakeUp()) then
      listabls[i]:update()
    
      
    end
  end
end

