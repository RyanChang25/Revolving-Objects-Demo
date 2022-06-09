repeat wait() until game:GetService('Players').LocalPlayer.PlayerGui:WaitForChild("UserInterface").TableGUI
local ButtonController = require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientMain.ButtonController)
local PrototypeController = require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientMain.PrototypeController)
local PrototypeHandler = require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientMain.PrototypeController.PrototypeHandler)
local PreloadController = require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientMain.PreloadController)
local TableGUI = game:GetService("Players").LocalPlayer.PlayerGui.UserInterface.TableGUI
local ServerRemote = game.ReplicatedStorage.ServerRemote
------------------------------------------------------------------------------------------------------------
--<<: Preloading Assets & Core Services
PreloadController.PreloadAssets()
--<<: Loads and handling the user interface
ButtonController.LoadUserInterface(TableGUI, ServerRemote)
--<<: Creating prototype class objects and rendering them
PrototypeController.CreateObject(ServerRemote)
PrototypeHandler.RenderObjects()