local ButtonController = {}

local ButtonHandler = require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientMain.ButtonController.ButtonHandler)

function ButtonController.LoadUserInterface(TableGUI, ServerRemote)
	ButtonHandler.UpdateTextboxes(TableGUI.RadiusButton, TableGUI.SineButton, TableGUI.AngularX, TableGUI.AngularY, TableGUI.AngularZ)
	ButtonHandler.TextboxFocusLost("X", TableGUI.AngularX, game.Players.LocalPlayer, ServerRemote)
	ButtonHandler.TextboxFocusLost("Y", TableGUI.AngularY, game.Players.LocalPlayer, ServerRemote)
	ButtonHandler.TextboxFocusLost("Z", TableGUI.AngularZ, game.Players.LocalPlayer, ServerRemote)
	ButtonHandler.TextboxFocusLost("Radius", TableGUI.RadiusButton, game.Players.LocalPlayer, ServerRemote)
	ButtonHandler.TextboxFocusLost("Sine", TableGUI.SineButton, game.Players.LocalPlayer, ServerRemote)
	ButtonHandler.UpdateTable("Instance", 1, ServerRemote, TableGUI.Add)
	ButtonHandler.UpdateTable("Destroy", -1, ServerRemote, TableGUI.Delete)
	ButtonHandler.ResetTable("Reset", 0, ServerRemote, TableGUI.Reset)
	ButtonHandler.PrintTable("Print", 0, ServerRemote, TableGUI.PrintTable)
end

return ButtonController
