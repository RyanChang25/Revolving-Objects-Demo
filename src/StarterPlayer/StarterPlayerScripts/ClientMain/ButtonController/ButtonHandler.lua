local ButtonHandler = {}

--Public Encapsulation
ButtonHandler.TEXT_INCREMENT = 0

local function getPropertySignal(textBox)
	textBox:GetPropertyChangedSignal("Text"):Connect(function()
		textBox.Text = textBox.Text:gsub("%D", '')
	end)
end

function ButtonHandler.UpdateTable(value, num, ServerRemote, button)
	button.MouseButton1Click:Connect(function()
		ButtonHandler.TEXT_INCREMENT = ButtonHandler.TEXT_INCREMENT + num
		if ButtonHandler.TEXT_INCREMENT < 0 then ButtonHandler.TEXT_INCREMENT = 0 elseif ButtonHandler.TEXT_INCREMENT > 30 then ButtonHandler.TEXT_INCREMENT = 30 return end
		ServerRemote:FireServer(value)
		button.Parent.BlockData.Text = "OBJECTS IN TABLE: "..(ButtonHandler.TEXT_INCREMENT)
	end)
end

function ButtonHandler.ResetTable(value, num, ServerRemote, button)
	button.MouseButton1Click:Connect(function()
		ButtonHandler.TEXT_INCREMENT = 0
		ServerRemote:FireServer(value)
		button.Parent.AngularX.Text = 0
		button.Parent.AngularY.Text = 1
		button.Parent.AngularZ.Text = 0
		button.Parent.RadiusButton.Text = 8
		button.Parent.SineButton.Text = 1
		button.Parent.BlockData.Text = "OBJECTS IN TABLE: "..(ButtonHandler.TEXT_INCREMENT)
	end)
end

function ButtonHandler.PrintTable(value, num, ServerRemote, button)
	button.MouseButton1Click:Connect(function()
		ServerRemote:FireServer(value)
	end)
end

function ButtonHandler.UpdateTextboxes(textBox1, textBox2, textBox3, textBox4, textBox5)
	getPropertySignal(textBox1)
	getPropertySignal(textBox2)
	getPropertySignal(textBox3)
	getPropertySignal(textBox4)
	getPropertySignal(textBox5)
end

function ButtonHandler.TextboxFocusLost(value,textBox, plr, ServerRemote)
	textBox.FocusLost:Connect(function(enterPressed)
		local MaxValue = 0
		print (textBox.Name)
		if textBox.Name == "AngularX" or textBox.Name == "AngularY" or textBox.Name == "AngularZ" or textBox.Name == "SineButton" then
			MaxValue = 10
		else
			MaxValue = 50
		end
		if textBox.Text ~= "" and workspace:FindFirstChild(plr.Name.." Parts") then
			if tonumber(textBox.Text) > MaxValue then
				textBox.Text = tostring(MaxValue)
			end
			ServerRemote:FireServer(value, textBox.Text)
		end
	end)
end

return ButtonHandler
