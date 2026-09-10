-- T3 pair-1 environment setup (runs FIRST via Execute in the same job).
-- Materializes the services a real place file would contain, so direct
-- indexing (game.ReplicatedStorage) resolves exactly as in-game.
-- Uses only the engine's own public API (GetService creates on demand).
local rs = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local sss = game:GetService("ServerScriptService")
local lighting = game:GetService("Lighting")

local parts = rs:FindFirstChild("Parts")
if parts == nil then
    parts = Instance.new("Folder")
    parts.Name = "Parts"
    parts.Parent = rs
end
if #parts:GetChildren() == 0 then
    for i = 1, 3 do
        local p = Instance.new("Part")
        p.Name = "Part" .. i
        p.Position = Vector3.new(i * 4, 5, 0)
        p.Parent = parts
    end
end
print("T3_SETUP_OK parts=" .. #parts:GetChildren())
return "setup-ok"
