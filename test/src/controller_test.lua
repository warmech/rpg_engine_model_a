function love.load()
    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
    buttons = joystick:getButtonCount()
    axes = joystick:getAxisCount()
 
    position = {x = 400, y = 300}
    speed = 300
end
 
function love.update(dt)
    if not joystick then return end

    if joystick:isDown(1) then
        button1 = "Pressed"
    else
    	button1 = "Not Pressed"
    end

    if joystick:isDown(2) then
        button2 = "Pressed"
    else
    	button2 = "Not Pressed"
    end

    if joystick:isDown(3) then
        button3 = "Pressed"
    else
    	button3 = "Not Pressed"
    end

    if joystick:isDown(4) then
        button4 = "Pressed"
    else
    	button4 = "Not Pressed"
    end

    if joystick:isDown(5) then
        button5 = "Pressed"
    else
    	button5 = "Not Pressed"
    end

    if joystick:isDown(6) then
        button6 = "Pressed"
    else
    	button6 = "Not Pressed"
    end

    if joystick:isDown(7) then
        button7 = "Pressed"
    else
    	button7 = "Not Pressed"
    end

    if joystick:isDown(8) then
        button8 = "Pressed"
    else
    	button8 = "Not Pressed"
    end

    direction1 = joystick:getAxis(1)
    direction2 = joystick:getAxis(2)
    direction3 = joystick:getAxis(3)
    direction4 = joystick:getAxis(4)
    direction5 = joystick:getAxis(5)

end
 
function love.draw()
    love.graphics.print("Button 1: "..button1, 10, 20)
    love.graphics.print("Button 2: "..button2, 10, 30)
    love.graphics.print("Button 3: "..button3, 10, 40)
    love.graphics.print("Button 4: "..button4, 10, 50)
    love.graphics.print("Button 5: "..button5, 10, 60)
    love.graphics.print("Button 6: "..button6, 10, 70)
    love.graphics.print("Button 7: "..button7, 10, 80)
    love.graphics.print("Button 8: "..button8, 10, 90)
    love.graphics.print("Button Count: "..buttons, 10, 150)
    love.graphics.print("Axis Count: "..axes, 10, 160)
    love.graphics.print("Axis 1: "..direction1, 10, 170)
    love.graphics.print("Axis 2: "..direction2, 10, 180)
    love.graphics.print("Axis 3: "..direction3, 10, 190)
    love.graphics.print("Axis 4: "..direction4, 10, 200)
    love.graphics.print("Axis 5: "..direction5, 10, 210)

end


















