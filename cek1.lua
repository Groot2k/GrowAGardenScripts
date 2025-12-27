-- ===============================
-- Grow a Garden | Auto Switch Pet
-- Delta Executor Compatible
-- ===============================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Folder data player (Grow a Garden)
local playerData = player:WaitForChild("PlayerData")
local petsFolder = playerData:WaitForChild("Pets")

-- CONFIG
local TARGET_AGE = 100
local TARGET_SLOT = 3
local CHECK_DELAY = 3

-- Cari Remote (sesuaikan jika beda)
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local setPetSlotRemote =
    remotes:FindFirstChild("SetPetSlot")
    or remotes:FindFirstChild("EquipPet")
    or remotes:FindFirstChild("SwitchPet")

if not setPetSlotRemote then
    warn("❌ Remote SetPetSlot / EquipPet tidak ditemukan")
    return
end

-- Ambil Age pet
local function getPetAge(pet)
    local age = pet:FindFirstChild("Age")
    if age and age:IsA("IntValue") then
        return age.Value
    end
    return 0
end

-- Cari pet yang memenuhi target age
local function findQualifiedPet()
    for _, pet in ipairs(petsFolder:GetChildren()) do
        if getPetAge(pet) >= TARGET_AGE then
            return pet
        end
    end
    return nil
end

-- Pindahkan pet ke slot tujuan
local function movePetToSlot(pet, slot)
    pcall(function()
        setPetSlotRemote:FireServer(pet.Name, slot)
    end)
end

-- LOOP
task.spawn(function()
    while task.wait(CHECK_DELAY) do
        local pet = findQualifiedPet()
        if pet then
            movePetToSlot(pet, TARGET_SLOT)
            warn("✅ Pet dipindahkan:", pet.Name, "→ Slot", TARGET_SLOT)
            break
        end
    end
end)
