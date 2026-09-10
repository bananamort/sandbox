local Players = game:GetService("Players")

local function greet(player)
  print("hello from KeyForge, " .. player.Name)
end

local value = 20 + 22
print("answer:", value)

Players.PlayerAdded:Connect(greet)
