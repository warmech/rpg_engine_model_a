function openTextBox( ... )
    -- body
end


function selectFont(fontName)
	--love.graphics.setDefaultFilter("nearest","nearest")

	local fontPath = "/gfx/font/"..fontName..".png"
	local font = love.graphics.newImageFont(fontPath," !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_abcdefghijklmnopqrstuvwxyz{|}~")
	
	love.graphics.setFont(font)

    --[[
    font2 = love.graphics.newImageFont("text_inv_vwf.png"," ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{}:;,.?/<>~\"'\\")
	love.graphics.setFont(font2)
    love.graphics.print("Hello World! This is a test\nof the printing system.",100,400,0,4,4)
    ]]
end