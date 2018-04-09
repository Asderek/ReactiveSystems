function retangulo (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  return {
              draw =
                function ()
                  love.graphics.rectangle("line", rx, ry, rw, rh)
                end
              ,
              keypressed =
                function (key)
                    local mx, my = love.mouse.getPosition()
                  
                    io.write("mx = ",mx,"\n")
                    io.write("my = ",my,"\n")
                    io.write("x = ",x,"\n")
                    io.write("y = ",y,"\n")
                    io.write("w = ",w,"\n")
                    io.write("h = ",h,"\n")
                  
                    if love.keyboard.isDown("up") and naimagem (mx, my, rx, ry, w, h) then
                      ry = ry-10
                    end
                    
                    if love.keyboard.isDown("down") and naimagem (mx, my, rx, ry, w, h)  then
                      ry = ry+10
                    end
                    
                    if love.keyboard.isDown("left") and naimagem (mx, my, rx, ry, w, h)  then
                      rx = rx-10
                    end
                    
                    if love.keyboard.isDown("right") and naimagem (mx, my, rx, ry, w, h)  then
                      rx = rx+10
                    end
                    
                end
  }
end


  
function love.load()
  ret={}
  
  math.randomseed(os.time())
  
  for i=1,7 do
    ret[i] = retangulo(math.random(0,600), math.random(0,600), 50, 40)
  end
  
end

function naimagem (mx, my, x, y, w, h) 
  io.write("mx = ",mx,"\n")
  io.write("my = ",my,"\n")
  io.write("x = ",x,"\n")
  io.write("y = ",y,"\n")
  io.write("w = ",w,"\n")
  io.write("h = ",h,"\n")
  
  return (mx>x) and (mx<x+w) and (my>y) and (my<y+h)
end

function love.keypressed(key)
	
 local mx, my = love.mouse.getPosition()   

  for i = 1, #ret do

    if love.keyboard.isDown("up") then
      ret[i].keypressed("up")
    end
    if love.keyboard.isDown("down") then
      ret[i].keypressed("down")
    end
    if love.keyboard.isDown("left") then
      ret[i].keypressed("left")
    end
    if love.keyboard.isDown("right") then
      ret[i].keypressed("right")
    end
  end
  
end

function love.update (dt)  

end

function love.draw ()
  for i = 1, #ret do
    ret[i].draw()
  end
  
end

