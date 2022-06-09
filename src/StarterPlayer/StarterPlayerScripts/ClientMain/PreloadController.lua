local PreloadController = {}

-- Services for persistent state
local ContentProvider = game:GetService('ContentProvider')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PlayerGui = game:GetService('PlayerGui')
local PlayerScripts = game:GetService('PlayerScripts')

function PreloadController.PreloadAssets()
	ContentProvider:PreloadAsync({workspace, ReplicatedStorage, PlayerGui, PlayerScripts})

	game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
		Text = "[GAME] Welcome to the Revolving Parts Demo!";
		Color = Color3.fromRGB(255, 255, 0);
		Font = Enum.Font.SourceSansBold;	
		FontSize = Enum.FontSize.Size32;
	})
	
	game:GetService("StarterGui"):SetCore('ResetButtonCallback', false)

end

return PreloadController
