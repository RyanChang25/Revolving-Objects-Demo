local EventController = {}

function EventController.FireAllClients()
	game.ReplicatedStorage.ServerRemote.OnServerEvent:Connect(function(plr, value, number)
		game.ReplicatedStorage.ServerRemote:FireAllClients(plr, value, number)
	end)
end

return EventController
