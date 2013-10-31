-- these must be odd...?
quarryX = 15
quarryZ = 15

fuelSlot = 1
smooth = 14
dirt = 15
gravel = 16


print("enter GO to begin, else to refuel")
print("load stone,dirt,gravel in 14,15,16")

turtle.select(1)
turtle.refuel(64)

function compare(slot, func)
  return turtle.select(slot) and func()
end
function crapPerFunc(func)
  local result = compare(smooth,func) or compare(dirt,func) or compare(gravel,func)
  turtle.select(1)
  return result
end

function crapForward()
  return (not turtle.detect()) or crapPerFunc(turtle.compare)
end
function crapUp()
  return (not turtle.detectUp()) or crapPerFunc(turtle.compareUp)
end
function crapDown()
  return (not turtle.detectDown()) or crapPerFunc(turtle.compareDown)
end

function dig()
  turtle.dig()
  while not turtle.forward() do
    turtle.dig()
    sleep(0.5)
  end
  turtle.drop(64)
end
function digDown()
  turtle.digDown()
  while not turtle.down() do
    sleep(0.5)
  end
  turtle.drop(64)
end
function digUp()
  print("digUp() called")
  turtle.digUp()
  while not turtle.up() do
    turtle.digUp()
    sleep(0.5)
  end
  turtle.drop(64)
end

aboveMyY = 0 -- how high are we currently above our mining level

function attemptDigForward()
  -- if we're above the designated mining level, try to lower
  while aboveMyY > 0 do
    print("aDF above:"..aboveMyY)
    if not crapDown() then break end
    print("crapdown, going digging")
    digDown()
    aboveMyY = aboveMyY - 1
  end

  if crapForward() then
    dig()
  else
    while not crapForward() do
      if crapUp() then
        digUp()
        aboveMyY = aboveMyY + 1
      else
        -- we entered under an overhang
        print("yolo.")
        digUp()
        aboveMyY = aboveMyY + 1
      end
    end
    dig()
  end
end

function savedY()
  if not fs.exists("memory") then return 0 end
  
  fp = fs.open("memory", "r")
  y = fp.readLine()
  i = fp.readLine()
  j = fp.readLine()
  fp.close()
  
  return tonumber(y)
end

function savedI()
  if not fs.exists("memory") then return 1 end
  
  fp = fs.open("memory", "r")
  y = fp.readLine()
  i = fp.readLine()
  j = fp.readLine()
  fp.close()
  
  return tonumber(i)
end

function savedJ()
  if not fs.exists("memory") then return 1 end
  
  fp = fs.open("memory", "r")
  y = fp.readLine()
  i = fp.readLine()
  j = fp.readLine()
  fp.close()
  
  return tonumber(j)
end

function save(y,i,j)
  print("saving:"..i.." "..j)
  
  fp = fs.open("memory", "w")
  fp.writeLine(y)
  fp.writeLine(i)
  fp.writeLine(j)
  fp.close()
end

y = savedY()
while true do
  -- y is our y-level sort of :/
  y = y + 1
  -- i is our across-the-quarry
  for i=savedI(),quarryX do
    -- j is our forward-back
    for j=savedJ(),quarryZ do
      save(y,i,j)
      attemptDigForward()
    end
    
    -- end of line, turn around
    -- if it's the last line, don't dig for an extra row
    -- if we're digging an even level down, go the other way
    if (i+y)%2==0 then
      turtle.turnRight()
      if i~=quarryX then attemptDigForward() end
      turtle.turnRight()
    else
      turtle.turnLeft()
      if i~=quarryX then attemptDigForward() end
      turtle.turnLeft()
    end
    -- overwrite the saved j with the initial value
    save(y,i,1)
  end
  
  -- end of level, dig down
  digDown()
  -- overwrite the saved i,j with the initial values
  save(y,1,1)
end
