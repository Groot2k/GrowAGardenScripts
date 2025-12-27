local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- DATA
local playerData = player:WaitForChild("PlayerData")
local petsFolder = playerData:WaitForChild("Pets")

-- REMOTE
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local setPetSlotRemote =
    remotes:FindFirstChild("SetPetSlot")
    or remotes:FindFirstChild("EquipPet")
    or remotes:FindFirstChild("SwitchPet")

if not setPetSlotRemote then
    warn("Remote tidak ditemukan")
    return
end

-- STATE
local running = false
local TARGET_AGE = 100
local TARGET_SLOT = 3

--================ GUI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AutoPetGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 220)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Grow a Garden | Auto Pet Switch"
title.TextColor3 = Color3.fromRGB(0, 255, 140)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- INPUT AGE
local ageBox = Instance.new("TextBox", frame)
ageBox.Position = UDim2.fromOffset(20, 60)
ageBox.Size = UDim2.fromOffset(260, 35)
ageBox.Text = "100"
ageBox.PlaceholderText = "Target Age"
ageBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ageBox.TextColor3 = Color3.new(1,1,1)
ageBox.Font = Enum.Font.Gotham
ageBox.TextSize = 14
Instance.new("UICorner", ageBox).CornerRadius = UDim.new(0,8)

-- INPUT SLOT
local slotBox = Instance.new("TextBox", frame)
slotBox.Position = UDim2.fromOffset(20, 105)
slotBox.Size = UDim2.fromOffset(260, 35)
slotBox.Text = "3"
slotBox.PlaceholderText = "Slot Tujuan (1-8)"
slotBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
slotBox.TextColor3 = Color3.new(1,1,1)
slotBox.Font = Enum.Font.Gotham
slotBox.TextSize = 14
Instance.new("UICorner", slotBox).CornerRadius = UDim.new(0,8)

-- STATUS
local status = Instance.new("TextLabel", frame)
status.Position = UDim2.fromOffset(20, 150)
status.Size = UDim2.fromOffset(260, 25)
status.BackgroundTransparency = 1
status.Text = "Status: OFF"
status.TextColor3 = Color3.fromRGB(255, 100, 100)
status.Font = Enum.Font.Gotham
status.TextSize = 13

-- BUTTON
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Position = UDim2.fromOffset(20, 180)
toggleBtn.Size = UDim2.fromOffset(260, 35)
toggleBtn.Text = "START"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,10)

--================ LOGIC =================

local function getPetAge(pet)
    local age = pet:FindFirstChild("Age")
    return age and age.Value or 0
end

local function findQualifiedPet()
    for _, pet in ipairs(petsFolder:GetChildren()) do
        if getPetAge(pet) >= TARGET_AGE then
            return pet
        end
    end
end

task.spawn(function()
    while task.wait(2) do
        if running then
            local pet = findQualifiedPet()
            if pet then
                setPetSlotRemote:FireServer(pet.Name, TARGET_SLOT)
                status.Text = "Pet dipindah: "..pet.Name
                status.TextColor3 = Color3.fromRGB(0, 255, 140)
                running = false
                toggleBtn.Text = "START"
            end
        end
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    running = not running

    TARGET_AGE = tonumber(ageBox.Text) or TARGET_AGE
    TARGET_SLOT = tonumber(slotBox.Text) or TARGET_SLOT

    if running then
        status.Text = "Status: RUNNING"
        status.TextColor3 = Color3.fromRGB(0, 255, 140)
        toggleBtn.Text = "STOP"
    else
        status.Text = "Status: OFF"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleBtn.Text = "START"
    end
end)
