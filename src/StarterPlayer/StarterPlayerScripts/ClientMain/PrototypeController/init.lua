local PrototypeController = {}

local PrototypeHandler = require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientMain:WaitForChild("PrototypeController").PrototypeHandler)

function PrototypeController.CreateObject(ServerRemote)
	ServerRemote.OnClientEvent:Connect(function(plr,value, numberValue)
		if value == "Instance" then --<<: Creates the BlockRoot for player, and default Block object.
			local BlockObject = PrototypeHandler.new(plr) 
			BlockObject:SetPhysicalProperties("Neon orange", BlockObject.Root.Radius.Value, BlockObject.Root.SineRatio.Value)
		else
			PrototypeHandler[value](plr, numberValue) --<<: Executes function based on the value passed from client.
		end	
	end)
end

return PrototypeController
