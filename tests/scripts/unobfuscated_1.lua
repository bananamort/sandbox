local partsFolder = game.ReplicatedStorage:WaitForChild("Parts")
local allParts = partsFolder:GetChildren()

while task.wait(5) do
    local randomPart = allParts[math.random(1, #allParts)]
    local clone = randomPart:Clone()
    clone.Parent = workspace
    clone.Position = Vector3.new(math.random(-10, 10), 5, math.random(-10, 10))
end
