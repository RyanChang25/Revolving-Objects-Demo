local PrototypeHandler = {}
-- By indexing the table with it self, it makes it so the objects can call upon the functions without being in the object creating class!
-- This optimizes prototype class objects because now functions are loaded in upon creation, and we don't have to create an extra table!
PrototypeHandler.__index = PrototypeHandler
-- Services for persistent state
local RunService = game:GetService("RunService")
local TS = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
-- Private Encapsulation
local fullCircle = 2 * math.pi
local INCREMENT = 0
local Number = 0
local SineRatioNumber = 1
local RadiusNumber = 8
local Parts = {}
---------------------------------------------------------------------------------------

local function resetCFrame(numberValue, plr)
	if tonumber(numberValue) == 0 then
		TS:Create(workspace:FindFirstChild(plr.Name.." Parts").BlockRoot, 
			TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = plr.Character.HumanoidRootPart.CFrame}):Play()
	end
end

local function InstanceBlock(plr)
	if workspace:FindFirstChild(plr.Name.." Parts") == nil then
		local model = Instance.new("Model", workspace)
		model.Name = (plr.Name.." Parts")
		game.ReplicatedStorage.GameObjects.BlockRoot:Clone().Parent = model
	end
	workspace:FindFirstChild(plr.Name.." Parts").BlockRoot.PartCount.Value = workspace:FindFirstChild(plr.Name.." Parts").BlockRoot.PartCount.Value + 1
	local genBlock = game.ReplicatedStorage.GameObjects.Part:Clone()
	genBlock.Parent = workspace:FindFirstChild(plr.Name.." Parts")
	genBlock.Name = (workspace:FindFirstChild(plr.Name.." Parts").BlockRoot.PartCount.Value).."-Part"

	return genBlock
end

--Creates an object and links it to the module, so the object is able to index functions from it
-- Also inserted Block into a table so it can be rendered

function PrototypeHandler.new(plr, color)
	local Block = {}
	Block.Part = InstanceBlock(plr)
	Block.Color = color or "Neon orange"
	Block.IterationValue = workspace:FindFirstChild(plr.Name.." Parts").BlockRoot.PartCount.Value
	Block.Root = workspace:FindFirstChild(plr.Name.." Parts").BlockRoot
	Block.Owner = plr.Character
	table.insert(Parts, Block)
	return setmetatable(Block, PrototypeHandler)
end

function PrototypeHandler:SetPhysicalProperties(color, rad, sine)
	self.Part.BrickColor = BrickColor.new(color)
	self.Part.Radius.Value = rad
	self.Part.SineRatio.Value = sine
end

function PrototypeHandler.getXAndZPositions(angle, radius)
	--<<: We only need x and z to be changed since y is constant
	if radius == nil then return end
	local x = math.cos(angle) * radius --<<: The x can be found by cos(angle)
	local z = math.sin(angle) * radius --<<: y on a unit circle can be found by sin(angle) but since y is constant we change it to z
	return x, z
end

function PrototypeHandler.Destroy(plr)
	for i, block in pairs(Parts) do
		local partName = (workspace:FindFirstChild(plr.Name.." Parts").BlockRoot.PartCount.Value).."-Part"
		local mostRecentPart = workspace:FindFirstChild(plr.Name.." Parts")
		if block.Part == mostRecentPart:FindFirstChild(partName) and mostRecentPart.BlockRoot.PartCount.Value ~= 0 then
			table.remove(Parts, i)
			mostRecentPart.BlockRoot.PartCount.Value = mostRecentPart.BlockRoot.PartCount.Value - 1
			mostRecentPart[partName]:Destroy()
		end
	end
end

function PrototypeHandler.Reset(plr)
	if workspace:FindFirstChild(plr.Name.." Parts") then
		local RemoveParts = {}
		for i, block in pairs(Parts) do
			if block.Owner == plr.Character then
				table.insert(RemoveParts, i)
			end
		end
		for i, iteration in pairs(RemoveParts) do
			table.remove(Parts, iteration-i+1)
		end
		workspace:FindFirstChild(plr.Name.." Parts"):Destroy()
		print (plr.Character.Name.." has reset their Blocks!")
	end
end

function PrototypeHandler.Radius(plr, numberValue)
	workspace:FindFirstChild(plr.Name.." Parts").BlockRoot.Radius.Value = tonumber(numberValue)--<<: Setting default SineRatio for objects
	for i, block in pairs(Parts) do
		if block.Owner.Name == plr.Name then
			TS:Create(block.Part.Radius, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Value = tonumber(numberValue)}):Play()
		end
	end
end

function PrototypeHandler.Sine(plr, numberValue)
	workspace:FindFirstChild(plr.Name.." Parts").BlockRoot.SineRatio.Value = tonumber(numberValue)--<<: Setting default SineRatio for objects
	for i, block in pairs(Parts) do
		if block.Owner.Name == plr.Name then
			TS:Create(block.Part.SineRatio, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Value = tonumber(numberValue)}):Play()
		end
	end
end

function PrototypeHandler.X(plr, numberValue)
	local AngularVelo = workspace:FindFirstChild(plr.Name.." Parts").BlockRoot.BodyAngularVelocity
	AngularVelo.AngularVelocity = Vector3.new(numberValue, AngularVelo.AngularVelocity.Y, AngularVelo.AngularVelocity.Z)
	resetCFrame(numberValue, plr)
end

function PrototypeHandler.Y(plr, numberValue)
	local AngularVelo = workspace:FindFirstChild(plr.Name.." Parts").BlockRoot.BodyAngularVelocity
	AngularVelo.AngularVelocity = Vector3.new(AngularVelo.AngularVelocity.X, numberValue, AngularVelo.AngularVelocity.Z)
	resetCFrame(numberValue, plr)
end

function PrototypeHandler.Z(plr, numberValue)
	local AngularVelo = workspace:FindFirstChild(plr.Name.." Parts").BlockRoot.BodyAngularVelocity
	AngularVelo.AngularVelocity = Vector3.new(AngularVelo.AngularVelocity.X, AngularVelo.AngularVelocity.Y, numberValue)
	resetCFrame(numberValue, plr)
end

function PrototypeHandler.Print(plr, numberValue)
	for i,v in pairs (Parts) do
		print (i..". Owned by "..tostring(v.Owner).." with iteration of "..tostring(v.IterationValue))
	end
end

function PrototypeHandler.RenderObjects()
	RunService.Stepped:Connect(function()
		INCREMENT = INCREMENT + 0.025 --:<< How fast the block spins
		Number = Number + 5 --:<< How fast the block bobs
		--[[
		local Players = {}
		for i,v in pairs (game.Players:GetChildren()) do
			table.insert(Players, v.Character)
		end		
		]]
		for i, block in pairs(Parts) do
			block.Root.BodyPosition.Position = block.Owner.HumanoidRootPart.Position
			--block.Root.BodyGyro.CFrame = block.Owner.HumanoidRootPart.CFrame 
			--<<: If you want to make the objects CFrame relative to the roots CFrame (To use add a bodygyro and make the maxtorque y = 400000)
			local angle = block.IterationValue * (fullCircle / (block.Root.PartCount.Value)) 
			--<<: Divides the full circle by the amount of blocks in the table then multiplies it by its iteration.
			local x, z = PrototypeHandler.getXAndZPositions(angle, block.Part.Radius.Value, PrototypeHandler)
			--<<: Gets angle then the radius value stored in the BlockRoot part
			local Number2 = math.rad(Number) --<<: Convert degrees to radians
			local Number3 = math.sin(Number2) * block.Part.SineRatio.Value --<<: Converts radians to sine, sineRatio increases/decreases the amplitude of the circle
			--<<: By multiplying the CFrames, it combines them:
			local position = (block.Root.CFrame * CFrame.new(x, Number3, z)).p --<<: Makes it the same data type as the lookAt value
			local lookAt = block.Root.Position
			--<<: A CFrame constructor that takes a position and a lookAt value and returns a CFrame looking that that position, 
			--<<: I added a CFrame angles to add a rotation
			block.Part.CFrame = CFrame.new(position, lookAt) * CFrame.Angles(INCREMENT,0,INCREMENT)
			--[[
			for i,Target in pairs (Players) do
				if (Target.HumanoidRootPart.Position - block.Part.Position).Magnitude <= 3 and Target.Name ~= block.Owner.Name then
					if Target:FindFirstChild(Target.Name.."'s DamageDebounce-"..block.Part.Name) == nil and Target.Humanoid.Health > 1 then
						print("Hit!")
						Target.Humanoid.Health = Target.Humanoid.Health - 1
						local DamageDebounce = Instance.new("ObjectValue", Target)
						DamageDebounce.Name = Target.Name.."'s DamageDebounce-"..block.Part.Name
						DamageDebounce.Value = Target
						DebrisService:AddItem(DamageDebounce,1)
					end
				end
			end			
			]]
		end
	end)
end

return PrototypeHandler
