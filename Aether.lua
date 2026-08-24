-- [StarterPlayerScripts > LocalScript: HaroonHub_V12_Ultimate_Cross_Executor_Fixed]
repeat task.wait() until game:IsLoaded()
task.wait(1)

--------------------------------------------------------------------------------
-- 1. الخدمات والريموتات الأساسية (Services & Net Modules)
--------------------------------------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- استخراج الريموتات الرسمية بأمان
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not Remotes then
    warn("Haroon Hub: Remotes folder not found in ReplicatedStorage!")
    return
end

local CommF_ = Remotes:FindFirstChild("CommF_")
local CommE = Remotes:FindFirstChild("CommE")

if not CommF_ then warn("Haroon Hub: CommF_ remote not found!") end
if not CommE then warn("Haroon Hub: CommE remote not found!") end

local Net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
local ShootGunEvent = Net and Net:FindFirstChild("RE/ShootGunEvent")

local RegisterHit = nil
local success_getupvalue, result_getupvalue = pcall(function()
    if getrenv and getrenv()._G and getrenv()._G.SendHitsToServer then
        RegisterHit = debug.getupvalue(getrenv()._G.SendHitsToServer, 1)
    end
end)

if not RegisterHit and Net and Net:FindFirstChild("RE/RegisterHit") then
    RegisterHit = Net:FindFirstChild("RE/RegisterHit")
end

-- تحديد العالم الحالي
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then World2 = true
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then World3 = true end

-- إعدادات الإضاءة
Lighting.Ambient = Color3.new(0.695, 0.695, 0.695)
Lighting.ColorShift_Bottom = Color3.new(0.695, 0.695, 0.695)
Lighting.ColorShift_Top = Color3.new(0.695, 0.695, 0.695)
Lighting.Brightness = 2
Lighting.FogEnd = 1e10

--------------------------------------------------------------------------------
-- 2. مصفوفة الإعدادات العامة (جميع الـ Toggles تبدأ بحالة false / OFF)
--------------------------------------------------------------------------------
_G.Settings = {
    Main = {
        ["Auto Farm Level"] = false,
        ["Include Boss Quests"] = false,
        ["Select Weapon"] = "Melee",
        ["Farm Distance"] = 28,
        ["Player Tween Speed"] = 180,
        ["Fast Attack"] = false,
        ["Selected Material"] = "Leather + Scrap Metal",
        ["Auto Farm Material"] = false,
        ["Selected Boss"] = "The Gorilla King",
        ["Auto Farm Boss"] = false,
        ["Auto Farm All Boss"] = false
    },
    Combat = {
        ["Selected Player"] = nil,
        ["Spectate Player"] = false,
        ["Teleport To Player"] = false,
        ["Aimbot Gun"] = false,
        ["Auto PvP Escape"] = false,
        ["Escape HP %"] = 30,
        ["Return HP %"] = 70,
    },
    Fruits = {
        ["Fruit ESP"] = false,
        ["Fruit Sniper"] = false,
        ["Auto Store Fruit"] = false,
        ["Show All Fruits"] = false,
    },
    SubFarm = {
        ["Auto Elite Hunter"] = false,
        ["Auto Elite Hunter Hop"] = false,
        ["Auto Farm Bone"] = false,
        ["Auto Chest Tween"] = false,
        ["Auto Chest Instant"] = false,
        ["Auto Stop Items"] = false,
        ["Auto Farm Leviathan"] = false,
        ["Auto Buy Leviathan Bait"] = false,
        ["Auto Spawn Leviathan Boat"] = false,
        ["Auto Mastery Melee"] = false,
        ["Auto Mastery Swords"] = false,
        ["Auto Mastery Blox Fruits"] = false,
        ["Auto Mastery Guns"] = false,
    },
    Cake = {
        ["Auto Katakuri"] = false,
        ["Auto Spawn Cake Prince"] = false,
        ["Auto Kill Cake Prince"] = false,
        ["Auto Kill Dough King"] = false
    },
    Race = {
        ["Auto Find Mirage"] = false,
        ["Tween To Highest Mirage"] = false,
        ["Teleport To Blue Gear"] = false,
        ["Look Moon Ability"] = false,
        ["Teleport To Race Door"] = false,
        ["Auto Race V2 Quest"] = false,
        ["Auto Race V3 Quest"] = false,
        ["Selected Race V3"] = "Human",
        ["Auto Race V3 Ability"] = false,
        ["Auto Train"] = false,
        ["Auto Trial"] = false,
        ["Auto Buy Gear"] = false
    },
    Sea = {
        ["Selected Boat"] = "Guardian",
        ["Selected Zone"] = "Zone 5",
        ["Boat Tween Speed"] = 200,
        ["Sail Boat"] = false,
        ["Auto Farm Shark"] = false,
        ["Auto Farm Piranha"] = false,
        ["Auto Farm Fish Crew Member"] = false,
        ["Auto Farm Ghost Ship"] = false,
        ["Auto Farm Terrorshark"] = false,
        ["Auto Farm Seabeasts"] = false,
        ["Dodge Seabeasts Attack"] = true,
        ["Auto Find Kitsune Island"] = false,
        ["Auto Prehistoric Island"] = false,
        ["Auto Complete Prehistoric Island"] = false,
        ["Auto Draco Trail"] = false,
    },
    Raid = {
        ["Selected Chip"] = "Flame",
        ["Auto Dungeon / Raid"] = false,
        ["Auto Buy Chip & Start"] = false,
        ["Auto Clear Dungeon Waves"] = false,
        ["Auto Next Island"] = false,
        ["Auto Awaken"] = false,
        ["Law Raid"] = false,
    },
    Stats = {
        ["Auto Stats"] = false,
        ["Selected Stat"] = "Melee",
        ["Points Per Tick"] = 1,
    },
    Teleports = {
        ["TP_Windmill"] = false,
        ["TP_Jungle"] = false,
        ["TP_Pirate Village"] = false,
        ["TP_Desert"] = false,
        ["TP_Snow Island"] = false,
        ["TP_Marineford"] = false,
        ["TP_Colosseum"] = false,
        ["TP_Sky Island"] = false,
        ["TP_Prison"] = false,
        ["TP_Magma Village"] = false,
        ["TP_Fountain City"] = false,
        ["TP_Cafe"] = false,
        ["TP_Green Zone"] = false,
        ["TP_Cursed Ship"] = false,
        ["TP_Ice Castle"] = false,
        ["TP_Hot & Cold"] = false,
        ["TP_Snow Mountain"] = false,
        ["TP_Graveyard"] = false,
        ["TP_Factory"] = false,
        ["TP_Colosseum Sea 2"] = false,
        ["TP_Dark Arena"] = false,
        ["TP_Mansion"] = false,
        ["TP_Port Town"] = false,
        ["TP_Hydra Island"] = false,
        ["TP_Floating Turtle"] = false,
        ["TP_Haunted Castle"] = false,
        ["TP_Tiki Outpost"] = false,
        ["TP_Great Tree"] = false,
        ["TP_Castle on the Sea"] = false,
        ["TP_Cake Land"] = false,
        ["TP_Peanut Island"] = false,
    },
    Visuals = {
        ["ESP Players"] = false,
        ["ESP Bosses"] = false,
        ["ESP Fruits"] = false,
        ["ESP Chests"] = false,
        ["ESP Enemies"] = false,
        ["ESP Mirage Island"] = false,
        ["ESP Kitsune Island"] = false,
    },
    FarmingQuests = {
        ["Auto Sword Quest"] = false,
        ["Selected Sword Quest"] = "Saber V2",
        ["Auto Farm CDK"] = false,
        ["Auto Farm TTK"] = false,
    },
    Misc = {
        ["Auto Ken (Buso Haki)"] = false,
        ["Set Team to Marines"] = false,
        ["Set Team to Pirates"] = false,
    }
}

_G.MobHeight = _G.MobHeight or 20

--------------------------------------------------------------------------------
-- 3. محرك الحماية والتثبيت الرأسي وإيقاف الحركة الآمن
--------------------------------------------------------------------------------
local currentTween = nil

local function GetCharacter(): (Model?, BasePart?, Humanoid?)
    local char = LocalPlayer.Character
    if not char then char = LocalPlayer.CharacterAdded:Wait() end
    local hrp = char:FindFirstChild("HumanoidRootPart") :: BasePart?
    local hum = char:FindFirstChildOfClass("Humanoid") :: Humanoid?
    return char, hrp, hum
end

RunService.Stepped:Connect(function()
    local active = _G.Settings.Main["Auto Farm Level"] or _G.Settings.Main["Auto Farm Material"] or
                   _G.Settings.Main["Auto Farm Boss"] or _G.Settings.Main["Auto Farm All Boss"] or
                   _G.Settings.SubFarm["Auto Farm Bone"] or _G.Settings.Cake["Auto Katakuri"] or
                   _G.Settings.Sea["Sail Boat"] or _G.Settings.SubFarm["Auto Chest Tween"] or
                   _G.Settings.Race["Auto Train"] or _G.Settings.SubFarm["Auto Farm Leviathan"] or
                   _G.Settings.FarmingQuests["Auto Sword Quest"] or _G.Settings.Race["Auto Race V2 Quest"] or 
                   _G.Settings.Race["Auto Race V3 Quest"] or _G.Settings.FarmingQuests["Auto Farm CDK"] or 
                   _G.Settings.FarmingQuests["Auto Farm TTK"] or _G.Settings.SubFarm["Auto Mastery Melee"] or 
                   _G.Settings.SubFarm["Auto Mastery Swords"] or _G.Settings.SubFarm["Auto Mastery Blox Fruits"] or 
                   _G.Settings.SubFarm["Auto Mastery Guns"] or _G.Settings.Race["Auto Find Mirage"] or 
                   _G.Settings.Sea["Auto Find Kitsune Island"] or _G.Settings.Raid["Auto Dungeon / Raid"] or 
                   _G.Settings.Combat["Auto PvP Escape"] or _G.Settings.Fruits["Fruit Sniper"] or
                   _G.Settings.Sea["Auto Farm Shark"] or _G.Settings.Sea["Auto Farm Piranha"] or
                   _G.Settings.Sea["Auto Farm Fish Crew Member"] or _G.Settings.Sea["Auto Farm Ghost Ship"] or
                   _G.Settings.Sea["Auto Farm Terrorshark"] or _G.Settings.Sea["Auto Farm Seabeasts"] or
                   _G.Settings.Sea["Auto Prehistoric Island"] or _G.Settings.Sea["Auto Complete Prehistoric Island"] or
                   _G.Settings.Sea["Auto Draco Trail"] or _G.Settings.Raid["Auto Next Island"]

    local char, hrp, hum = GetCharacter()
    if not char or not hrp or not hum then return end

    if active then
        pcall(function()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            if not hrp:FindFirstChild("HaroonBV") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "HaroonBV"
                bv.Parent = hrp
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.zero
            end
        end)
    else
        pcall(function()
            if hrp:FindFirstChild("HaroonBV") then
                hrp.HaroonBV:Destroy()
            end
        end)
    end
end)

local function TweenPlayer(pos: CFrame | Vector3 | BasePart, offset: Vector3?): Tween?
    local char, hrp, hum = GetCharacter()
    if not char or not hrp or not hum then return nil end
    if hum.Sit then hum.Sit = false end

    local targetCFrame: CFrame
    if typeof(pos) == "CFrame" then targetCFrame = pos
    elseif typeof(pos) == "Vector3" then targetCFrame = CFrame.new(pos)
    elseif pos:IsA("BasePart") then targetCFrame = pos.CFrame
    else return nil end

    if offset then targetCFrame = targetCFrame * CFrame.new(offset) end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local uprightCFrame = CFrame.new(targetCFrame.Position, targetCFrame.Position + Vector3.new(targetCFrame.LookVector.X, 0, targetCFrame.LookVector.Z))

    if distance <= 25 then
        hrp.CFrame = uprightCFrame
        if currentTween then currentTween:Cancel() end
        return nil
    end

    local speed = _G.Settings.Main["Player Tween Speed"] or 180
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)

    if currentTween then currentTween:Cancel() end
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = uprightCFrame})
    currentTween:Play()
    return currentTween
end

local function StopTween()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    local _, hrp = GetCharacter()
    if hrp and hrp:FindFirstChild("HaroonBV") then
        hrp.HaroonBV:Destroy()
    end
end

local function AutoHaki()
    local char = LocalPlayer.Character
    if char and not CollectionService:HasTag(char, "Ken") then
        if CommE then pcall(function() CommE:FireServer("Ken", true) end) end
    end
end

local function EquipWeapon(weaponType: string)
    pcall(function()
        local char, _, hum = GetCharacter()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack or not hum or not char then return end

        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == weaponType or (weaponType == "Melee" and tool.ToolTip == "Melee") or (weaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit") or (weaponType == "Gun" and tool.ToolTip == "Gun") or (weaponType == "Sword" and tool.ToolTip == "Sword")) then
                return
            end
        end

        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == weaponType or (weaponType == "Melee" and tool.ToolTip == "Melee") or (weaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit") or (weaponType == "Gun" and tool.ToolTip == "Gun") or (weaponType == "Sword" and tool.ToolTip == "Sword")) then
                hum:EquipTool(tool)
                break
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- 4. المحرك الذكي للهجوم والـ Aimbot والـ 80% Damage Mechanic
--------------------------------------------------------------------------------
local function AimAtTarget(targetPosition: Vector3)
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetPosition)
        end
    end)
end

local function FastAttackTarget(targetEnemy: Model)
    if not targetEnemy or not targetEnemy:FindFirstChild("HumanoidRootPart") then return end
    local head = targetEnemy:FindFirstChild("Head") or targetEnemy.HumanoidRootPart

    if RegisterAttack then
        pcall(function()
            RegisterAttack:FireServer(0)
            RegisterAttack:FireServer(1)
            RegisterAttack:FireServer(2)
            RegisterAttack:FireServer(3)
        end)
    end

    if RegisterHit then
        pcall(function()
            if typeof(RegisterHit) == "thread" or typeof(RegisterHit) == "function" then
                coroutine.resume(RegisterHit, head, {})
            elseif typeof(RegisterHit) == "Instance" then
                RegisterHit:FireServer(head, {})
            end
        end)
    end
end

local function SmartAttackMob(targetMob: Model, weaponOverride: string?): boolean
    local selectedWep = weaponOverride or _G.Settings.Main["Select Weapon"]
    local mobHum = targetMob:FindFirstChildOfClass("Humanoid")
    local mobRoot = targetMob:FindFirstChild("HumanoidRootPart") or targetMob:FindFirstChild("Head")
    if not mobHum or mobHum.Health <= 0 or not mobRoot then return false end

    local hpPercent = mobHum.Health / mobHum.MaxHealth

    if selectedWep == "Blox Fruit" or selectedWep == "Gun" then
        if hpPercent > 0.20 then
            EquipWeapon("Melee")
            FastAttackTarget(targetMob)
        else
            EquipWeapon(selectedWep)
            AimAtTarget(mobRoot.Position)

            if selectedWep == "Blox Fruit" then
                for _, key in pairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.F}) do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end
            elseif selectedWep == "Gun" then
                for _, key in pairs({Enum.KeyCode.Z, Enum.KeyCode.X}) do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end
                if ShootGunEvent then
                    pcall(function() ShootGunEvent:FireServer(mobRoot.Position, {mobRoot}) end)
                end
            end

            VirtualInputManager:SendMouseButtonEvent(mobRoot.Position.X, mobRoot.Position.Y, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(mobRoot.Position.X, mobRoot.Position.Y, 0, false, game, 0)
            FastAttackTarget(targetMob)
        end
    else
        EquipWeapon(selectedWep)
        FastAttackTarget(targetMob)
    end

    return true
end

--------------------------------------------------------------------------------
-- 5. قواعد البيانات الشاملة للمهمات والجزر (Quests & Islands Database)
--------------------------------------------------------------------------------
local CurrentQuest = {
    Mon = "Bandit",
    LevelQuest = 1,
    NameQuest = "BanditQuest1",
    NameMon = "Bandit",
    CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42),
    CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
}

local function CheckQuest()
    local MyLevel = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")) and LocalPlayer.Data.Level.Value or 1
    if World1 then
        if MyLevel <= 9 then
            CurrentQuest = {Mon = "Bandit", LevelQuest = 1, NameQuest = "BanditQuest1", NameMon = "Bandit", CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42), CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)}
        elseif MyLevel <= 14 then
            CurrentQuest = {Mon = "Monkey", LevelQuest = 1, NameQuest = "JungleQuest", NameMon = "Monkey", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)}
        elseif MyLevel <= 29 then
            if _G.Settings.Main["Include Boss Quests"] and MyLevel >= 20 then
                CurrentQuest = {Mon = "The Gorilla King", LevelQuest = 3, NameQuest = "JungleQuest", NameMon = "The Gorilla King", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)}
            else
                CurrentQuest = {Mon = "Gorilla", LevelQuest = 2, NameQuest = "JungleQuest", NameMon = "Gorilla", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)}
            end
        elseif MyLevel <= 39 then
            CurrentQuest = {Mon = "Pirate", LevelQuest = 1, NameQuest = "BuggyQuest1", NameMon = "Pirate", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)}
        elseif MyLevel <= 59 then
            if _G.Settings.Main["Include Boss Quests"] and MyLevel >= 55 then
                CurrentQuest = {Mon = "Bobby", LevelQuest = 3, NameQuest = "BuggyQuest1", NameMon = "Bobby", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)}
            else
                CurrentQuest = {Mon = "Brute", LevelQuest = 2, NameQuest = "BuggyQuest1", NameMon = "Brute", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)}
            end
        elseif MyLevel <= 74 then
            CurrentQuest = {Mon = "Desert Bandit", LevelQuest = 1, NameQuest = "DesertQuest", NameMon = "Desert Bandit", CFrameQuest = CFrame.new(894.48, 5.14, 4392.43), CFrameMon = CFrame.new(924.79, 6.44, 4481.58)}
        elseif MyLevel <= 89 then
            CurrentQuest = {Mon = "Desert Officer", LevelQuest = 2, NameQuest = "DesertQuest", NameMon = "Desert Officer", CFrameQuest = CFrame.new(894.48, 5.14, 4392.43), CFrameMon = CFrame.new(1608.28, 8.61, 4371.00)}
        elseif MyLevel <= 99 then
            CurrentQuest = {Mon = "Snow Bandit", LevelQuest = 1, NameQuest = "SnowQuest", NameMon = "Snow Bandit", CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90), CFrameMon = CFrame.new(1354.34, 87.27, -1393.94)}
        elseif MyLevel <= 119 then
            CurrentQuest = {Mon = "Snowman", LevelQuest = 2, NameQuest = "SnowQuest", NameMon = "Snowman", CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90), CFrameMon = CFrame.new(1201.64, 144.57, -1550.06)}
        elseif MyLevel <= 149 then
            CurrentQuest = {Mon = "Chief Petty Officer", LevelQuest = 1, NameQuest = "MarineQuest2", NameMon = "Chief Petty Officer", CFrameQuest = CFrame.new(-5039.58, 27.35, 4324.68), CFrameMon = CFrame.new(-4881.23, 22.65, 4273.75)}
        elseif MyLevel <= 174 then
            CurrentQuest = {Mon = "Sky Bandit", LevelQuest = 1, NameQuest = "SkyQuest", NameMon = "Sky Bandit", CFrameQuest = CFrame.new(-4839.53, 716.36, -2619.44), CFrameMon = CFrame.new(-4953.20, 295.74, -2899.22)}
        elseif MyLevel <= 189 then
            CurrentQuest = {Mon = "Dark Master", LevelQuest = 2, NameQuest = "SkyQuest", NameMon = "Dark Master", CFrameQuest = CFrame.new(-4839.53, 716.36, -2619.44), CFrameMon = CFrame.new(-5259.84, 391.39, -2229.03)}
        elseif MyLevel <= 209 then
            CurrentQuest = {Mon = "Prisoner", LevelQuest = 1, NameQuest = "PrisonerQuest", NameMon = "Prisoner", CFrameQuest = CFrame.new(5308.93, 1.65, 475.12), CFrameMon = CFrame.new(5098.97, -0.32, 474.23)}
        elseif MyLevel <= 249 then
            CurrentQuest = {Mon = "Dangerous Prisoner", LevelQuest = 2, NameQuest = "PrisonerQuest", NameMon = "Dangerous Prisoner", CFrameQuest = CFrame.new(5308.93, 1.65, 475.12), CFrameMon = CFrame.new(5654.56, 15.63, 866.29)}
        elseif MyLevel <= 274 then
            CurrentQuest = {Mon = "Toga Warrior", LevelQuest = 1, NameQuest = "ColosseumQuest", NameMon = "Toga Warrior", CFrameQuest = CFrame.new(-1580.04, 6.35, -2986.47), CFrameMon = CFrame.new(-1820.21, 51.68, -2740.66)}
        elseif MyLevel <= 299 then
            CurrentQuest = {Mon = "Gladiator", LevelQuest = 2, NameQuest = "ColosseumQuest", NameMon = "Gladiator", CFrameQuest = CFrame.new(-1580.04, 6.35, -2986.47), CFrameMon = CFrame.new(-1292.83, 56.38, -3339.03)}
        elseif MyLevel <= 324 then
            CurrentQuest = {Mon = "Military Soldier", LevelQuest = 1, NameQuest = "MagmaQuest", NameMon = "Military Soldier", CFrameQuest = CFrame.new(-5313.37, 10.95, 8515.29), CFrameMon = CFrame.new(-5411.16, 11.08, 8454.29)}
        elseif MyLevel <= 374 then
            CurrentQuest = {Mon = "Military Spy", LevelQuest = 2, NameQuest = "MagmaQuest", NameMon = "Military Spy", CFrameQuest = CFrame.new(-5313.37, 10.95, 8515.29), CFrameMon = CFrame.new(-5802.86, 86.26, 8828.85)}
        elseif MyLevel <= 399 then
            CurrentQuest = {Mon = "Fishman Warrior", LevelQuest = 1, NameQuest = "FishmanQuest", NameMon = "Fishman Warrior", CFrameQuest = CFrame.new(61122.65, 18.49, 1569.39), CFrameMon = CFrame.new(60878.30, 18.48, 1543.75)}
        elseif MyLevel <= 449 then
            CurrentQuest = {Mon = "Fishman Commando", LevelQuest = 2, NameQuest = "FishmanQuest", NameMon = "Fishman Commando", CFrameQuest = CFrame.new(61122.65, 18.49, 1569.39), CFrameMon = CFrame.new(61922.63, 18.48, 1493.93)}
        elseif MyLevel <= 474 then
            CurrentQuest = {Mon = "God's Guard", LevelQuest = 1, NameQuest = "SkyExp1Quest", NameMon = "God's Guard", CFrameQuest = CFrame.new(-4721.88, 843.87, -1949.96), CFrameMon = CFrame.new(-4710.04, 845.27, -1927.30)}
        elseif MyLevel <= 524 then
            CurrentQuest = {Mon = "Shanda", LevelQuest = 2, NameQuest = "SkyExp1Quest", NameMon = "Shanda", CFrameQuest = CFrame.new(-7859.09, 5544.19, -381.47), CFrameMon = CFrame.new(-7678.48, 5566.40, -497.21)}
        elseif MyLevel <= 549 then
            CurrentQuest = {Mon = "Royal Squad", LevelQuest = 1, NameQuest = "SkyExp2Quest", NameMon = "Royal Squad", CFrameQuest = CFrame.new(-7906.81, 5634.66, -1411.99), CFrameMon = CFrame.new(-7624.25, 5658.13, -1467.35)}
        elseif MyLevel <= 624 then
            CurrentQuest = {Mon = "Royal Soldier", LevelQuest = 2, NameQuest = "SkyExp2Quest", NameMon = "Royal Soldier", CFrameQuest = CFrame.new(-7906.81, 5634.66, -1411.99), CFrameMon = CFrame.new(-7836.75, 5645.66, -1790.62)}
        elseif MyLevel <= 649 then
            CurrentQuest = {Mon = "Galley Pirate", LevelQuest = 1, NameQuest = "FountainQuest", NameMon = "Galley Pirate", CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02), CFrameMon = CFrame.new(5551.02, 78.90, 3930.41)}
        else
            CurrentQuest = {Mon = "Galley Captain", LevelQuest = 2, NameQuest = "FountainQuest", NameMon = "Galley Captain", CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02), CFrameMon = CFrame.new(5441.95, 42.50, 4950.09)}
        end
    elseif World2 then
        if MyLevel <= 724 then
            CurrentQuest = {Mon = "Raider", LevelQuest = 1, NameQuest = "Area1Quest", NameMon = "Raider", CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18), CFrameMon = CFrame.new(-728.32, 52.77, 2345.77)}
        elseif MyLevel <= 774 then
            CurrentQuest = {Mon = "Mercenary", LevelQuest = 2, NameQuest = "Area1Quest", NameMon = "Mercenary", CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18), CFrameMon = CFrame.new(-1004.32, 80.15, 1424.61)}
        elseif MyLevel <= 799 then
            CurrentQuest = {Mon = "Swan Pirate", LevelQuest = 1, NameQuest = "Area2Quest", NameMon = "Swan Pirate", CFrameQuest = CFrame.new(638.43, 71.76, 918.28), CFrameMon = CFrame.new(1068.66, 137.61, 1322.10)}
        elseif MyLevel <= 874 then
            CurrentQuest = {Mon = "Factory Staff", LevelQuest = 2, NameQuest = "Area2Quest", NameMon = "Factory Staff", CFrameQuest = CFrame.new(632.69, 73.10, 918.66), CFrameMon = CFrame.new(73.07, 81.86, -27.47)}
        elseif MyLevel <= 899 then
            CurrentQuest = {Mon = "Marine Lieutenant", LevelQuest = 1, NameQuest = "MarineQuest3", NameMon = "Marine Lieutenant", CFrameQuest = CFrame.new(-2440.79, 71.71, -3216.06), CFrameMon = CFrame.new(-2821.37, 75.89, -3070.08)}
        elseif MyLevel <= 949 then
            CurrentQuest = {Mon = "Marine Captain", LevelQuest = 2, NameQuest = "MarineQuest3", NameMon = "Marine Captain", CFrameQuest = CFrame.new(-2440.79, 71.71, -3216.06), CFrameMon = CFrame.new(-1861.23, 80.17, -3254.69)}
        elseif MyLevel <= 974 then
            CurrentQuest = {Mon = "Zombie", LevelQuest = 1, NameQuest = "ZombieQuest", NameMon = "Zombie", CFrameQuest = CFrame.new(-5497.06, 47.59, -795.23), CFrameMon = CFrame.new(-5657.77, 78.96, -928.68)}
        elseif MyLevel <= 999 then
            CurrentQuest = {Mon = "Vampire", LevelQuest = 2, NameQuest = "ZombieQuest", NameMon = "Vampire", CFrameQuest = CFrame.new(-5497.06, 47.59, -795.23), CFrameMon = CFrame.new(-6037.66, 32.18, -1340.65)}
        elseif MyLevel <= 1049 then
            CurrentQuest = {Mon = "Snow Trooper", LevelQuest = 1, NameQuest = "SnowMountainQuest", NameMon = "Snow Trooper", CFrameQuest = CFrame.new(609.85, 400.11, -5372.25), CFrameMon = CFrame.new(549.14, 427.38, -5563.69)}
        elseif MyLevel <= 1099 then
            CurrentQuest = {Mon = "Winter Warrior", LevelQuest = 2, NameQuest = "SnowMountainQuest", NameMon = "Winter Warrior", CFrameQuest = CFrame.new(609.85, 400.11, -5372.25), CFrameMon = CFrame.new(1142.74, 475.63, -5199.41)}
        elseif MyLevel <= 1124 then
            CurrentQuest = {Mon = "Lab Subordinate", LevelQuest = 1, NameQuest = "IceSideQuest", NameMon = "Lab Subordinate", CFrameQuest = CFrame.new(-6064.06, 15.24, -4902.97), CFrameMon = CFrame.new(-5707.47, 15.95, -4513.39)}
        elseif MyLevel <= 1174 then
            CurrentQuest = {Mon = "Horned Warrior", LevelQuest = 2, NameQuest = "IceSideQuest", NameMon = "Horned Warrior", CFrameQuest = CFrame.new(-6064.06, 15.24, -4902.97), CFrameMon = CFrame.new(-6341.36, 15.95, -5723.16)}
        elseif MyLevel <= 1199 then
            CurrentQuest = {Mon = "Magma Ninja", LevelQuest = 1, NameQuest = "FireSideQuest", NameMon = "Magma Ninja", CFrameQuest = CFrame.new(-5428.03, 15.06, -5299.43), CFrameMon = CFrame.new(-5449.67, 76.65, -5808.20)}
        elseif MyLevel <= 1249 then
            CurrentQuest = {Mon = "Lava Pirate", LevelQuest = 2, NameQuest = "FireSideQuest", NameMon = "Lava Pirate", CFrameQuest = CFrame.new(-5428.03, 15.06, -5299.43), CFrameMon = CFrame.new(-5213.33, 49.73, -4701.45)}
        elseif MyLevel <= 1274 then
            CurrentQuest = {Mon = "Ship Deckhand", LevelQuest = 1, NameQuest = "ShipQuest1", NameMon = "Ship Deckhand", CFrameQuest = CFrame.new(1037.80, 125.09, 32911.60), CFrameMon = CFrame.new(1212.01, 150.79, 33059.24)}
        elseif MyLevel <= 1299 then
            CurrentQuest = {Mon = "Ship Engineer", LevelQuest = 2, NameQuest = "ShipQuest1", NameMon = "Ship Engineer", CFrameQuest = CFrame.new(1037.80, 125.09, 32911.60), CFrameMon = CFrame.new(919.47, 43.54, 32779.96)}
        elseif MyLevel <= 1324 then
            CurrentQuest = {Mon = "Ship Steward", LevelQuest = 1, NameQuest = "ShipQuest2", NameMon = "Ship Steward", CFrameQuest = CFrame.new(968.80, 125.09, 33244.12), CFrameMon = CFrame.new(919.43, 129.55, 33436.03)}
        elseif MyLevel <= 1349 then
            CurrentQuest = {Mon = "Ship Officer", LevelQuest = 2, NameQuest = "ShipQuest2", NameMon = "Ship Officer", CFrameQuest = CFrame.new(968.80, 125.09, 33244.12), CFrameMon = CFrame.new(1036.01, 181.43, 33315.72)}
        elseif MyLevel <= 1374 then
            CurrentQuest = {Mon = "Arctic Warrior", LevelQuest = 1, NameQuest = "FrostQuest", NameMon = "Arctic Warrior", CFrameQuest = CFrame.new(5667.65, 26.79, -6486.08), CFrameMon = CFrame.new(5966.24, 62.97, -6179.38)}
        elseif MyLevel <= 1424 then
            CurrentQuest = {Mon = "Snow Lurker", LevelQuest = 2, NameQuest = "FrostQuest", NameMon = "Snow Lurker", CFrameQuest = CFrame.new(5667.65, 26.79, -6486.08), CFrameMon = CFrame.new(5407.07, 69.19, -6880.88)}
        elseif MyLevel <= 1449 then
            CurrentQuest = {Mon = "Sea Soldier", LevelQuest = 1, NameQuest = "ForgottenQuest", NameMon = "Sea Soldier", CFrameQuest = CFrame.new(-3054.44, 235.54, -10142.81), CFrameMon = CFrame.new(-3028.22, 64.67, -9775.42)}
        else
            CurrentQuest = {Mon = "Water Fighter", LevelQuest = 2, NameQuest = "ForgottenQuest", NameMon = "Water Fighter", CFrameQuest = CFrame.new(-3054.44, 235.54, -10142.81), CFrameMon = CFrame.new(-3352.90, 285.01, -10534.84)}
        end
    elseif World3 then
        if MyLevel <= 1524 then
            CurrentQuest = {Mon = "Pirate Millionaire", LevelQuest = 1, NameQuest = "PiratePortQuest", NameMon = "Pirate Millionaire", CFrameQuest = CFrame.new(-290.07, 42.90, 5581.58), CFrameMon = CFrame.new(-245.99, 47.30, 5584.10)}
        elseif MyLevel <= 1574 then
            CurrentQuest = {Mon = "Pistol Billionaire", LevelQuest = 2, NameQuest = "PiratePortQuest", NameMon = "Pistol Billionaire", CFrameQuest = CFrame.new(-290.07, 42.90, 5581.58), CFrameMon = CFrame.new(-187.33, 86.23, 6013.51)}
        elseif MyLevel <= 1599 then
            CurrentQuest = {Mon = "Dragon Crew Warrior", LevelQuest = 1, NameQuest = "AmazonQuest", NameMon = "Dragon Crew Warrior", CFrameQuest = CFrame.new(5832.83, 51.68, -1101.51), CFrameMon = CFrame.new(6141.14, 51.35, -1340.73)}
        elseif MyLevel <= 1624 then
            CurrentQuest = {Mon = "Dragon Crew Archer", LevelQuest = 2, NameQuest = "AmazonQuest", NameMon = "Dragon Crew Archer", CFrameQuest = CFrame.new(5833.11, 51.60, -1103.06), CFrameMon = CFrame.new(6616.41, 441.76, 446.04)}
        elseif MyLevel <= 1649 then
            CurrentQuest = {Mon = "Female Islander", LevelQuest = 1, NameQuest = "AmazonQuest2", NameMon = "Female Islander", CFrameQuest = CFrame.new(5446.87, 601.62, 749.45), CFrameMon = CFrame.new(4685.25, 735.80, 815.34)}
        elseif MyLevel <= 1699 then
            CurrentQuest = {Mon = "Giant Islander", LevelQuest = 2, NameQuest = "AmazonQuest2", NameMon = "Giant Islander", CFrameQuest = CFrame.new(5446.87, 601.62, 749.45), CFrameMon = CFrame.new(4729.09, 590.43, -36.97)}
        elseif MyLevel <= 1724 then
            CurrentQuest = {Mon = "Marine Commodore", LevelQuest = 1, NameQuest = "MarineTreeIsland", NameMon = "Marine Commodore", CFrameQuest = CFrame.new(2180.54, 27.81, -6741.54), CFrameMon = CFrame.new(2286.00, 73.13, -7159.80)}
        elseif MyLevel <= 1774 then
            CurrentQuest = {Mon = "Marine Rear Admiral", LevelQuest = 2, NameQuest = "MarineTreeIsland", NameMon = "Marine Rear Admiral", CFrameQuest = CFrame.new(2179.98, 28.73, -6740.05), CFrameMon = CFrame.new(3656.77, 160.52, -7001.59)}
        elseif MyLevel <= 1799 then
            CurrentQuest = {Mon = "Fishman Raider", LevelQuest = 1, NameQuest = "DeepForestIsland3", NameMon = "Fishman Raider", CFrameQuest = CFrame.new(-10581.65, 330.87, -8761.18), CFrameMon = CFrame.new(-10407.52, 331.76, -8368.51)}
        elseif MyLevel <= 1824 then
            CurrentQuest = {Mon = "Fishman Captain", LevelQuest = 2, NameQuest = "DeepForestIsland3", NameMon = "Fishman Captain", CFrameQuest = CFrame.new(-10581.65, 330.87, -8761.18), CFrameMon = CFrame.new(-10994.70, 352.38, -9002.11)}
        elseif MyLevel <= 1849 then
            CurrentQuest = {Mon = "Forest Pirate", LevelQuest = 1, NameQuest = "DeepForestIsland", NameMon = "Forest Pirate", CFrameQuest = CFrame.new(-13234.04, 331.48, -7625.40), CFrameMon = CFrame.new(-13274.47, 332.37, -7769.58)}
        elseif MyLevel <= 1899 then
            CurrentQuest = {Mon = "Mythological Pirate", LevelQuest = 2, NameQuest = "DeepForestIsland", NameMon = "Mythological Pirate", CFrameQuest = CFrame.new(-13234.04, 331.48, -7625.40), CFrameMon = CFrame.new(-13680.60, 501.08, -6991.18)}
        elseif MyLevel <= 1924 then
            CurrentQuest = {Mon = "Jungle Pirate", LevelQuest = 1, NameQuest = "DeepForestIsland2", NameMon = "Jungle Pirate", CFrameQuest = CFrame.new(-12680.38, 389.97, -9902.01), CFrameMon = CFrame.new(-12256.16, 331.73, -10485.83)}
        elseif MyLevel <= 1974 then
            CurrentQuest = {Mon = "Musketeer Pirate", LevelQuest = 2, NameQuest = "DeepForestIsland2", NameMon = "Musketeer Pirate", CFrameQuest = CFrame.new(-12680.38, 389.97, -9902.01), CFrameMon = CFrame.new(-13457.90, 391.54, -9859.17)}
        elseif MyLevel <= 1999 then
            CurrentQuest = {Mon = "Reborn Skeleton", LevelQuest = 1, NameQuest = "HauntedQuest1", NameMon = "Reborn Skeleton", CFrameQuest = CFrame.new(-9479.21, 141.21, 5566.09), CFrameMon = CFrame.new(-8763.72, 165.72, 6159.86)}
        elseif MyLevel <= 2024 then
            CurrentQuest = {Mon = "Living Zombie", LevelQuest = 2, NameQuest = "HauntedQuest1", NameMon = "Living Zombie", CFrameQuest = CFrame.new(-9479.21, 141.21, 5566.09), CFrameMon = CFrame.new(-10144.13, 138.62, 5838.08)}
        elseif MyLevel <= 2049 then
            CurrentQuest = {Mon = "Demonic Soul", LevelQuest = 1, NameQuest = "HauntedQuest2", NameMon = "Demonic Soul", CFrameQuest = CFrame.new(-9516.99, 172.01, 6078.46), CFrameMon = CFrame.new(-9505.87, 172.10, 6158.99)}
        elseif MyLevel <= 2074 then
            CurrentQuest = {Mon = "Posessed Mummy", LevelQuest = 2, NameQuest = "HauntedQuest2", NameMon = "Posessed Mummy", CFrameQuest = CFrame.new(-9516.99, 172.01, 6078.46), CFrameMon = CFrame.new(-9582.02, 6.25, 6205.47)}
        elseif MyLevel <= 2099 then
            CurrentQuest = {Mon = "Peanut Scout", LevelQuest = 1, NameQuest = "NutsIslandQuest", NameMon = "Peanut Scout", CFrameQuest = CFrame.new(-2104.39, 38.10, -10194.21), CFrameMon = CFrame.new(-2143.24, 47.72, -10029.99)}
        elseif MyLevel <= 2124 then
            CurrentQuest = {Mon = "Peanut President", LevelQuest = 2, NameQuest = "NutsIslandQuest", NameMon = "Peanut President", CFrameQuest = CFrame.new(-2104.39, 38.10, -10194.21), CFrameMon = CFrame.new(-1859.35, 38.10, -10422.42)}
        elseif MyLevel <= 2149 then
            CurrentQuest = {Mon = "Ice Cream Chef", LevelQuest = 1, NameQuest = "IceCreamIslandQuest", NameMon = "Ice Cream Chef", CFrameQuest = CFrame.new(-820.64, 65.81, -10965.79), CFrameMon = CFrame.new(-872.24, 65.81, -10919.95)}
        elseif MyLevel <= 2199 then
            CurrentQuest = {Mon = "Ice Cream Commander", LevelQuest = 2, NameQuest = "IceCreamIslandQuest", NameMon = "Ice Cream Commander", CFrameQuest = CFrame.new(-820.64, 65.81, -10965.79), CFrameMon = CFrame.new(-558.06, 112.04, -11290.77)}
        elseif MyLevel <= 2224 then
            CurrentQuest = {Mon = "Cookie Crafter", LevelQuest = 1, NameQuest = "CakeQuest1", NameMon = "Cookie Crafter", CFrameQuest = CFrame.new(-2021.32, 37.79, -12028.72), CFrameMon = CFrame.new(-2374.13, 37.79, -12125.30)}
        elseif MyLevel <= 2249 then
            CurrentQuest = {Mon = "Cake Guard", LevelQuest = 2, NameQuest = "CakeQuest1", NameMon = "Cake Guard", CFrameQuest = CFrame.new(-2021.32, 37.79, -12028.72), CFrameMon = CFrame.new(-1598.30, 43.77, -12244.58)}
        elseif MyLevel <= 2274 then
            CurrentQuest = {Mon = "Baking Staff", LevelQuest = 1, NameQuest = "CakeQuest2", NameMon = "Baking Staff", CFrameQuest = CFrame.new(-1927.91, 37.79, -12842.53), CFrameMon = CFrame.new(-1887.80, 77.61, -12998.35)}
        elseif MyLevel <= 2299 then
            CurrentQuest = {Mon = "Head Baker", LevelQuest = 2, NameQuest = "CakeQuest2", NameMon = "Head Baker", CFrameQuest = CFrame.new(-1927.91, 37.79, -12842.53), CFrameMon = CFrame.new(-2216.18, 82.88, -12869.29)}
        elseif MyLevel <= 2324 then
            CurrentQuest = {Mon = "Cocoa Warrior", LevelQuest = 1, NameQuest = "ChocQuest1", NameMon = "Cocoa Warrior", CFrameQuest = CFrame.new(233.22, 29.87, -12201.23), CFrameMon = CFrame.new(-21.55, 80.57, -12352.38)}
        elseif MyLevel <= 2349 then
            CurrentQuest = {Mon = "Chocolate Bar Battler", LevelQuest = 2, NameQuest = "ChocQuest1", NameMon = "Chocolate Bar Battler", CFrameQuest = CFrame.new(233.22, 29.87, -12201.23), CFrameMon = CFrame.new(582.59, 77.18, -12463.16)}
        elseif MyLevel <= 2374 then
            CurrentQuest = {Mon = "Sweet Thief", LevelQuest = 1, NameQuest = "ChocQuest2", NameMon = "Sweet Thief", CFrameQuest = CFrame.new(150.50, 30.69, -12774.50), CFrameMon = CFrame.new(165.18, 76.05, -12600.83)}
        elseif MyLevel <= 2399 then
            CurrentQuest = {Mon = "Candy Rebel", LevelQuest = 2, NameQuest = "ChocQuest2", NameMon = "Candy Rebel", CFrameQuest = CFrame.new(150.50, 30.69, -12774.50), CFrameMon = CFrame.new(134.86, 77.24, -12876.54)}
        elseif MyLevel <= 2424 then
            CurrentQuest = {Mon = "Candy Pirate", LevelQuest = 1, NameQuest = "CandyQuest1", NameMon = "Candy Pirate", CFrameQuest = CFrame.new(-1150.04, 20.37, -14446.33), CFrameMon = CFrame.new(-1310.50, 26.01, -14562.40)}
        elseif MyLevel <= 2449 then
            CurrentQuest = {Mon = "Snow Demon", LevelQuest = 2, NameQuest = "CandyQuest1", NameMon = "Snow Demon", CFrameQuest = CFrame.new(-1150.04, 20.37, -14446.33), CFrameMon = CFrame.new(-880.20, 71.24, -14538.60)}
        elseif MyLevel <= 2474 then
            CurrentQuest = {Mon = "Isle Outlaw", LevelQuest = 1, NameQuest = "TikiQuest1", NameMon = "Isle Outlaw", CFrameQuest = CFrame.new(-16547.74, 61.13, -173.41), CFrameMon = CFrame.new(-16442.81, 116.13, -264.46)}
        elseif MyLevel <= 2524 then
            CurrentQuest = {Mon = "Island Boy", LevelQuest = 2, NameQuest = "TikiQuest1", NameMon = "Island Boy", CFrameQuest = CFrame.new(-16547.74, 61.13, -173.41), CFrameMon = CFrame.new(-16901.26, 84.06, -192.88)}
        else
            CurrentQuest = {Mon = "Skull Slayer", LevelQuest = 2, NameQuest = "TikiQuest3", NameMon = "Skull Slayer", CFrameQuest = CFrame.new(-16661.89, 105.28, 1576.69), CFrameMon = CFrame.new(-16885.20, 114.12, 1627.94)}
        end
    end
end

local FullIslandLocations = {
    Sea1 = {
        ["Windmill"] = CFrame.new(979.79, 16.51, 1429.04),
        ["Jungle"] = CFrame.new(-1612.79, 36.85, 149.12),
        ["Pirate Village"] = CFrame.new(-1181.30, 4.75, 3803.54),
        ["Desert"] = CFrame.new(944.15, 20.91, 4373.30),
        ["Snow Island"] = CFrame.new(1347.80, 104.66, -1319.73),
        ["Marineford"] = CFrame.new(-4914.82, 50.96, 4281.02),
        ["Colosseum"] = CFrame.new(-1427.62, 7.28, -2792.77),
        ["Sky Island"] = CFrame.new(-4869.10, 733.46, -2667.01),
        ["Prison"] = CFrame.new(4875.33, 5.65, 734.85),
        ["Magma Village"] = CFrame.new(-5247.71, 12.88, 8504.96),
        ["Fountain City"] = CFrame.new(5259.81, 37.35, 4050.02),
    },
    Sea2 = {
        ["Cafe"] = CFrame.new(-380.47, 77.22, 255.82),
        ["Green Zone"] = CFrame.new(-2448.53, 73.01, -3210.63),
        ["Cursed Ship"] = CFrame.new(923.40, 125.05, 32885.87),
        ["Ice Castle"] = CFrame.new(6148.41, 294.38, -6741.11),
        ["Hot & Cold"] = CFrame.new(-5428.03, 15.06, -5299.43),
        ["Snow Mountain"] = CFrame.new(609.85, 400.11, -5372.25),
        ["Graveyard"] = CFrame.new(-5497.06, 47.59, -795.23),
        ["Factory"] = CFrame.new(632.69, 73.10, 918.66),
        ["Colosseum Sea 2"] = CFrame.new(-1580.04, 6.35, -2986.47),
        ["Dark Arena"] = CFrame.new(1000, 100, 1000),
    },
    Sea3 = {
        ["Mansion"] = CFrame.new(-12471.16, 374.94, -7551.67),
        ["Port Town"] = CFrame.new(-290.73, 6.72, 5343.55),
        ["Hydra Island"] = CFrame.new(5291.24, 1005.44, 393.76),
        ["Floating Turtle"] = CFrame.new(-13274.52, 531.82, -7579.22),
        ["Haunted Castle"] = CFrame.new(-9515.37, 164.00, 5786.06),
        ["Tiki Outpost"] = CFrame.new(-16218.68, 9.08, 445.61),
        ["Great Tree"] = CFrame.new(2180.54, 27.81, -6741.54),
        ["Castle on the Sea"] = CFrame.new(-5039.58, 27.35, 4324.68),
        ["Cake Land"] = CFrame.new(-2021.32, 37.79, -12028.72),
        ["Peanut Island"] = CFrame.new(-2104.39, 38.10, -10194.21),
    }
}

local DungeonChips = {
    "Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Dough"
}

local BossList = (World1 and {
    "The Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral",
    "Saber Expert", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord",
    "Wysper", "Thunder God", "Cyborg", "Ice Admiral", "Greybeard", "Darkbeard"
}) or (World2 and {
    "Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral",
    "Tide Keeper", "Darkbeard", "Cursed Captain", "Order"
}) or (World3 and {
    "Stone", "Hydra Leader", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate",
    "Cake Queen", "Longma", "Soul Reaper", "Dough King", "Katakuri", "Island Boy"
})

local MaterialList = (World1 and {
    "Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail", "Wood Planks"
}) or (World2 and {
    "Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet",
    "Magma Ore", "Vampire Fang"
}) or (World3 and {
    "Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder",
    "Fish Tail", "Mini Tusk", "Azure Ember"
})

local MobSpecificTeleports = {
    ["Darkbeard"] = CFrame.new(1000, 100, 1000),
    ["Longma"] = CFrame.new(-13510, 584, -6987),
    ["Terrorshark"] = CFrame.new(-40000, 30, -2000),
    ["Leviathan"] = CFrame.new(-148073.35, 9.00, 7721.05),
    ["Tide Keeper"] = CFrame.new(6148.41, 294.38, -6741.11),
    ["Thunder God"] = CFrame.new(-4869.10, 733.46, -2667.01),
    ["Don Swan"] = CFrame.new(638.43, 71.76, 918.28),
    ["Cursed Captain"] = CFrame.new(923.40, 125.05, 32885.87),
    ["Order"] = CFrame.new(-408.09, 16.04, 247.43),
    ["Indra"] = CFrame.new(-12471.16, 374.94, -7551.67),
    ["Kitsune Island"] = CFrame.new(-16526, 108, 752),
    ["Mirage Island"] = CFrame.new(29221.82, 14890.97, -205.99),
    ["Prehistoric Island"] = CFrame.new(-16471, 528, 539),
    ["Island Boy"] = CFrame.new(-16901.26, 84.06, -192.88),
}

local ZoneCFrames = {
    ["Zone 1"] = CFrame.new(-21998.37, 30.00, -682.30),
    ["Zone 2"] = CFrame.new(-26779.52, 30.00, -822.85),
    ["Zone 3"] = CFrame.new(-31171.95, 30.00, -2256.93),
    ["Zone 4"] = CFrame.new(-34054.68, 30.21, -2560.12),
    ["Zone 5"] = CFrame.new(-38887.55, 30.00, -2162.99),
    ["Zone 6"] = CFrame.new(-44541.76, 30.00, -1244.85),
    ["Infinite"] = CFrame.new(-148073.35, 9.00, 7721.05)
}

local function GetMaterialConfig(mat: string): ({string}, CFrame)
    if mat == "Radioactive Material" and World2 then return {"Factory Staff"}, CFrame.new(-507.78, 72.99, -126.45)
    elseif mat == "Mystic Droplet" and World2 then return {"Water Fighter"}, CFrame.new(-3352.90, 285.01, -10534.84)
    elseif mat == "Magma Ore" and World1 then return {"Military Spy"}, CFrame.new(-5850.28, 77.28, 8848.67)
    elseif mat == "Magma Ore" and World2 then return {"Lava Pirate"}, CFrame.new(-5234.60, 51.95, -4732.27)
    elseif mat == "Angel Wings" and World1 then return {"Royal Soldier"}, CFrame.new(-7827.15, 5606.91, -1705.58)
    elseif mat == "Leather + Scrap Metal" and World1 then return {"Pirate", "Brute"}, CFrame.new(-1211.87, 4.78, 3916.83)
    elseif mat == "Leather + Scrap Metal" and World2 then return {"Marine Captain", "Mercenary"}, CFrame.new(-2010.50, 73.00, -3326.62)
    elseif mat == "Scrap Metal" and World3 then return {"Pirate Millionaire"}, CFrame.new(-289.63, 43.82, 5583.66)
    elseif mat == "Ectoplasm" and World2 then return {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"}, CFrame.new(911.35, 125.95, 33159.53)
    elseif mat == "Conjured Cocoa" and World3 then return {"Chocolate Bar Battler"}, CFrame.new(744.79, 24.76, -12637.72)
    elseif mat == "Dragon Scale" and World3 then return {"Dragon Crew Warrior"}, CFrame.new(5824.06, 51.38, -1106.69)
    elseif mat == "Gunpowder" and World3 then return {"Pistol Billionaire"}, CFrame.new(-379.61, 73.84, 5928.52)
    elseif mat == "Fish Tail" and World3 then return {"Fishman Captain"}, CFrame.new(-10961.01, 331.79, -8914.29)
    elseif mat == "Mini Tusk" and World3 then return {"Mythological Pirate"}, CFrame.new(-13516.04, 469.81, -6899.16)
    elseif mat == "Vampire Fang" and World2 then return {"Vampire"}, CFrame.new(-6037.66, 32.18, -1340.65)
    elseif mat == "Demonic Wisp" and World3 then return {"Demonic Soul"}, CFrame.new(-9579, 6, 6194)
    elseif mat == "Wood Planks" and World3 then return {"Tree"}, CFrame.new(-16471, 528, 539)
    elseif mat == "Azure Ember" and World3 then return {"Kitsune Shrine"}, CFrame.new(-16526, 108, 752)
    end
    return {}, CFrame.new(0,0,0)
end

--------------------------------------------------------------------------------
-- 6. دمج واجهة AetherUI والتابات الكاملة
--------------------------------------------------------------------------------
local AetherUI = nil
local success_ui, err_ui = pcall(function()
    AetherUI = loadstring(game:HttpGet("https://pastebin.com/raw/yeULgMe0"))()
end)

if not success_ui or not AetherUI then
    warn("Haroon Hub: Failed to load AetherUI library. Error:", err_ui)
    return
end

AetherUI:InitLoadingScreen("Haroon Hub V12 Ultimate Master Edition", "Initializing Fruits, Raids & Safe Motors...", function()
    AetherUI:InitKeySystem({"HAROON-2025-VIP", "HAROON-KEY-100"}, function()
        AetherUI:Notify({Title = "🔥 Haroon Hub V12 Active", Content = "تم دمج مكتبتك بالنظام الجديد بنجاح 100%!", Duration = 4})

        local Window = AetherUI:CreateWindow({
            Title = "Haroon Hub | Blox Fruits Master",
            Subtitle = "by: 3amek4222",
            ToggleKey = Enum.KeyCode.RightControl
        })

        local MainTab = Window:CreateTab("Main", "rbxassetid://6034287594")
        local CombatTab = Window:CreateTab("Combat", "rbxassetid://6034834832")
        local FruitsTab = Window:CreateTab("Fruits Tab", "rbxassetid://6034453535")
        local RaidTab = Window:CreateTab("Dungeon / Raid", "rbxassetid://6034834832")
        local FarmingQuestsTab = Window:CreateTab("Farming Quests", "rbxassetid://6034453535")
        local RaceTab = Window:CreateTab("Race V4 & Mirage", "rbxassetid://6034453535")
        local SubFarmTab = Window:CreateTab("Sub Farming", "rbxassetid://6034834832")
        local CakeTab = Window:CreateTab("Cake & Dough", "rbxassetid://6034453535")
        local SeaTab = Window:CreateTab("Sea Farming", "rbxassetid://6034453535")
        local AutoQuestsTab = Window:CreateTab("Auto Quests", "rbxassetid://6034453535")
        local TeleportsTab = Window:CreateTab("Teleports", "rbxassetid://6034453535")
        local VisualTab = Window:CreateTab("Visuals & ESP", "rbxassetid://6034453535")
        local MiscTab = Window:CreateTab("Misc", "rbxassetid://6031280882")
        local SettingsTab = Window:CreateTab("Settings", "rbxassetid://6031280882")

        ---------------------------------------------------------
        -- 📌 1. TAB: MAIN
        ---------------------------------------------------------
        MainTab:CreateSection("خيارات التلفيل الأساسية (Level Farm)")

        MainTab:CreateToggle("تفعيل التجميع التلقائي (Auto Farm Level)", "AutoFarmFlag", false, function(state)
            _G.Settings.Main["Auto Farm Level"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateToggle("تضمين مهمات الزعماء بالتلفيل (Include Bosses)", "IncludeBossQuestFlag", false, function(state)
            _G.Settings.Main["Include Boss Quests"] = state
        end)

        MainTab:CreateDropdown("اختر السلاح الفعال (Weapon)", "WeaponFlag", {"Melee", "Sword", "Blox Fruit", "Gun"}, "Melee", function(selected)
            _G.Settings.Main["Select Weapon"] = selected
        end)

        MainTab:CreateSlider("ارتفاع الطيران فوق العدو (Farm Distance)", "FarmDistFlag", 10, 50, 28, function(val)
            _G.Settings.Main["Farm Distance"] = val
        end)

        MainTab:CreateSlider("سرعة الانتقال الآمنة (Safe Tween Speed)", "TweenSpeedFlag", 100, 300, 180, function(val)
            _G.Settings.Main["Player Tween Speed"] = val
        end)

        MainTab:CreateToggle("الضرب السريع الخارق (Fast Attack)", "FastAttackFlag", false, function(state)
            _G.Settings.Main["Fast Attack"] = state
        end)

        MainTab:CreateSection("تجميع الماتيريال (Auto Farm Materials)")

        MainTab:CreateDropdown("اختر الماتيريال (Select Material)", "MatDropdownFlag", MaterialList, MaterialList[1], function(selected)
            _G.Settings.Main["Selected Material"] = selected
        end)

        MainTab:CreateToggle("تفعيل تجميع الماتيريال (Farm Material)", "FarmMatFlag", false, function(state)
            _G.Settings.Main["Auto Farm Material"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateSection("قتل الزعماء (Auto Farm Bosses)")

        MainTab:CreateDropdown("اختر البوس (Select Boss)", "BossDropdownFlag", BossList, BossList[1], function(selected)
            _G.Settings.Main["Selected Boss"] = selected
        end)

        MainTab:CreateToggle("تفعيل قتل البوس المحدد (Auto Farm Boss)", "FarmBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm Boss"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateToggle("تفعيل قتل جميع البوسات المتوفرة (Farm All Bosses)", "FarmAllBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm All Boss"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 2. TAB: COMBAT (PVP)
        ---------------------------------------------------------
        CombatTab:CreateSection("قتال اللاعبين والـ PVP")

        local playerList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(playerList, p.Name) end
        end

        CombatTab:CreateDropdown("اختر اللاعب المستهدف", "PVPPlayerDropdown", playerList, playerList[1] or "None", function(selected)
            _G.Settings.Combat["Selected Player"] = selected
        end)

        CombatTab:CreateToggle("مراقبة اللاعب (Spectate Player)", "SpectateFlag", false, function(state)
            _G.Settings.Combat["Spectate Player"] = state
            if state and _G.Settings.Combat["Selected Player"] then
                local target = Players:FindFirstChild(_G.Settings.Combat["Selected Player"])
                if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                    workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
                end
            else
                local char, hum = GetCharacter()
                if char and hum then
                    workspace.CurrentCamera.CameraSubject = hum
                end
            end
        end)

        CombatTab:CreateToggle("الانتقال إلى اللاعب (Teleport To Player)", "TPPlayerFlag", false, function(state)
            _G.Settings.Combat["Teleport To Player"] = state
            if not state then StopTween() end
            task.spawn(function()
                while _G.Settings.Combat["Teleport To Player"] do
                    task.wait()
                    pcall(function()
                        local target = Players:FindFirstChild(_G.Settings.Combat["Selected Player"])
                        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            TweenPlayer(target.Character.HumanoidRootPart.CFrame)
                        end
                    end)
                end
            end)
        end)

        CombatTab:CreateToggle("تصويب المسدسات التلقائي (Aimbot Gun)", "AimbotGunFlag", false, function(state)
            _G.Settings.Combat["Aimbot Gun"] = state
        end)

        CombatTab:CreateSection("خيارات الهروب والعودة في الـ PVP")
        CombatTab:CreateToggle("تفعيل الهروب والعودة التلقائي (Auto PvP Escape)", "AutoPvPEscapeFlag", false, function(state)
            _G.Settings.Combat["Auto PvP Escape"] = state
            if not state then StopTween() end
        end)
        CombatTab:CreateSlider("نسبة HP للهروب (Escape HP %)", "EscapeHPSlider", 10, 90, 30, function(val)
            _G.Settings.Combat["Escape HP %"] = val
        end)
        CombatTab:CreateSlider("نسبة HP للعودة (Return HP %)", "ReturnHPSlider", 20, 100, 70, function(val)
            _G.Settings.Combat["Return HP %"] = val
        end)

        ---------------------------------------------------------
        -- 📌 3. TAB: FRUITS TAB
        ---------------------------------------------------------
        FruitsTab:CreateSection("نظام الفواكه والتخزين (Blox Fruits Engine)")
        
        FruitsTab:CreateToggle("🍎 Fruit Notifier (ESP)", "FruitESPFlag", false, function(state)
            _G.Settings.Fruits["Fruit ESP"] = state
            _G.Settings.Visuals["ESP Fruits"] = state
        end)

        FruitsTab:CreateToggle("🏃 Fruit Sniper (Auto-Collect)", "FruitSniperFlag", false, function(state)
            _G.Settings.Fruits["Fruit Sniper"] = state
            if not state then StopTween() end
        end)

        FruitsTab:CreateToggle("🔄 Auto-Store Fruit", "AutoStoreFruitFlag", false, function(state)
            _G.Settings.Fruits["Auto Store Fruit"] = state
        end)

        FruitsTab:CreateButton("🗺️ Show All Fruit Locations", function()
            _G.Settings.Fruits["Show All Fruits"] = true
            AetherUI:Notify({Title = "Fruits Scanner", Content = "جاري مسح كافة الفواكه على الخريطة...", Duration = 3})
            task.wait(5)
            _G.Settings.Fruits["Show All Fruits"] = false
        end)

        FruitsTab:CreateButton("🛒 Buy Random Fruit (Cousin)", function()
            if CommF_ then
                local res = CommF_:InvokeServer("Cousin", "Buy")
                AetherUI:Notify({Title = "Fruit Dealer", Content = tostring(res), Duration = 4})
            end
        end)

        ---------------------------------------------------------
        -- 📌 4. TAB: DUNGEON / RAID (Auto Next Island المستخرج)
        ---------------------------------------------------------
        RaidTab:CreateSection("نظام الـ Dungeon و غارات الفواكه (Dungeon System)")

        RaidTab:CreateDropdown("Select Raid Chip (اختر شريحة الريد)", "DungeonChipDropdown", DungeonChips, DungeonChips[1], function(selected)
            _G.Settings.Raid["Selected Chip"] = selected
        end)

        RaidTab:CreateToggle("⚡ Auto Dungeon / Fruits Raid (تفعيل الريد)", "AutoDungeonFlag", false, function(state)
            _G.Settings.Raid["Auto Dungeon / Raid"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("🛒 Buy Chip & Start Raid (شراء وبدء تلقائي)", "AutoBuyStartRaidFlag", false, function(state)
            _G.Settings.Raid["Auto Buy Chip & Start"] = state
        end)

        RaidTab:CreateToggle("⚔️ Auto Clear Dungeon Waves (مسح وحوش الريد)", "AutoClearDungeonFlag", false, function(state)
            _G.Settings.Raid["Auto Clear Dungeon Waves"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("🏝️ Auto Next Island (الانتقال للجزيرة التالية تلقائياً)", "AutoNextIslandFlag", false, function(state)
            _G.Settings.Raid["Auto Next Island"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("✨ Auto Awaken Skills (إيقاظ المهارات التلقائي)", "AutoAwakenSkillsFlag", false, function(state)
            _G.Settings.Raid["Auto Awaken"] = state
        end)

        RaidTab:CreateToggle("⚡ Law Raid (ريد لاو التلقائي)", "LawRaidFlag", false, function(state)
            _G.Settings.Raid["Law Raid"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 5. TAB: FARMING QUESTS (CDK & TTK المستخرج بالكامل)
        ---------------------------------------------------------
        FarmingQuestsTab:CreateSection("مهمات السيوف الأسطورية (Legendary Swords)")

        FarmingQuestsTab:CreateDropdown("اختر مهمة السيف", "SwordQuestDropdown", {"Saber V2", "Yama", "Tushita"}, "Saber V2", function(selected)
            _G.Settings.FarmingQuests["Selected Sword Quest"] = selected
        end)

        FarmingQuestsTab:CreateToggle("تفعيل أتمتة مهمة السيف", "AutoSwordQuestFlag", false, function(state)
            _G.Settings.FarmingQuests["Auto Sword Quest"] = state
            if not state then StopTween() end
        end)

        FarmingQuestsTab:CreateSection("مهمات السيوف المدمجة الأسطورية (CDK & TTK Engine)")

        FarmingQuestsTab:CreateToggle("⚔️ أتمتة Cursed Dual Katana بالكامل (Auto CDK)", "AutoFarmCDKFlag", false, function(state)
            _G.Settings.FarmingQuests["Auto Farm CDK"] = state
            if not state then StopTween() end
        end)

        FarmingQuestsTab:CreateToggle("⚔️ أتمتة True Triple Katana بالكامل (Auto TTK)", "AutoFarmTTKFlag", false, function(state)
            _G.Settings.FarmingQuests["Auto Farm TTK"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 6. TAB: RACE V2, V3, V4 & MIRAGE (النظام المستخرج الكامل)
        ---------------------------------------------------------
        RaceTab:CreateSection("ترقية الأجناس (Race V2 & V3 Quests)")

        RaceTab:CreateToggle("🧬 أتمتة مهمة Race V2 (Auto Race V2 Quest)", "AutoRaceV2QuestFlag", false, function(state)
            _G.Settings.Race["Auto Race V2 Quest"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateDropdown("اختر مهمة Race V3", "RaceV3QuestDropdown", {"Human", "Fishman", "Skypian", "Mink", "Ghoul", "Cyborg"}, "Human", function(selected)
            _G.Settings.Race["Selected Race V3"] = selected
        end)

        RaceTab:CreateToggle("🧬 أتمتة مهمة Race V3 (Auto Race V3 Quest)", "AutoRaceV3QuestFlag", false, function(state)
            _G.Settings.Race["Auto Race V3 Quest"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("تفعيل مهارة V3 تلقائياً (Auto Race V3 Ability)", "AutoV3AbilityFlag", false, function(state)
            _G.Settings.Race["Auto Race V3 Ability"] = state
            task.spawn(function()
                while _G.Settings.Race["Auto Race V3 Ability"] do
                    task.wait(1)
                    if CommE then pcall(function() CommE:FireServer("ActivateAbility") end) end
                end
            end)
        end)

        RaceTab:CreateSection("حزمة الميراج و الترس الأزرق (Mirage Island Suite)")

        RaceTab:CreateToggle("🏝️ البحث التلقائي عن Mirage Island والإبحار لها", "AutoFindMirageFlag", false, function(state)
            _G.Settings.Race["Auto Find Mirage"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("🏔️ الانتقال لقمة الميراج (Tween To Highest Mirage)", "TweenMirageFlag", false, function(state)
            _G.Settings.Race["Tween To Highest Mirage"] = state
            if not state then StopTween() end
            task.spawn(function()
                while _G.Settings.Race["Tween To Highest Mirage"] do
                    task.wait()
                    pcall(function()
                        if workspace.Map:FindFirstChild("MysticIsland") then
                            for _, v in pairs(workspace.Map.MysticIsland:GetDescendants()) do
                                if v:IsA("MeshPart") and v.MeshId == "rbxassetid://6745037796" then
                                    TweenPlayer(v.CFrame, Vector3.new(0, 212, 0))
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("⚙️ الانتقال وأخذ الترس الأزرق (Teleport to Gear)", "TeleportToGearFlag", false, function(state)
            _G.Settings.Race["Teleport To Blue Gear"] = state
            if not state then StopTween() end
            task.spawn(function()
                while _G.Settings.Race["Teleport To Blue Gear"] do
                    task.wait(0.2)
                    pcall(function()
                        if workspace.Map:FindFirstChild("MysticIsland") then
                            for _, v in pairs(workspace.Map.MysticIsland:GetChildren()) do
                                if v:IsA("MeshPart") and (v.Material == Enum.Material.Neon or string.find(v.Name:lower(), "gear")) then
                                    TweenPlayer(v.CFrame)
                                    if (LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude < 15 then
                                        if CommF_ then CommF_:InvokeServer("InteractGear", v) end
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("🌕 النظر للقمر وتفعيل المهارة (Look Moon)", "LookMoonFlag", false, function(state)
            _G.Settings.Race["Look Moon Ability"] = state
            task.spawn(function()
                while _G.Settings.Race["Look Moon Ability"] do
                    task.wait()
                    pcall(function()
                        local moonDir = game.Lighting:GetMoonDirection()
                        local lookAtPos = workspace.CurrentCamera.CFrame.p + moonDir * 100
                        workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.p, lookAtPos)
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("🚪 الانتقال لباب الترايل تلقائياً (Teleport To Race Door)", "TPDoorFlag", false, function(state)
            _G.Settings.Race["Teleport To Race Door"] = state
            if not state then StopTween() end
            if state then
                local myRace = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Race")) and LocalPlayer.Data.Race.Value or "Human"
                local raceDoors = {
                    ["Human"] = CFrame.new(29221.82, 14890.97, -205.99),
                    ["Skypian"] = CFrame.new(28960.15, 14919.62, 235.03),
                    ["Fishman"] = CFrame.new(28231.17, 14890.97, -211.64),
                    ["Cyborg"] = CFrame.new(28502.68, 14895.97, -423.72),
                    ["Ghoul"] = CFrame.new(28674.24, 14890.67, 445.43),
                    ["Mink"] = CFrame.new(29012.34, 14890.97, -380.14)
                }
                local char, hrp = GetCharacter()
                if char and hrp then
                    hrp.CFrame = CFrame.new(28286.35, 14895.30, 102.62)
                    task.wait(0.3)
                    if raceDoors[myRace] then TweenPlayer(raceDoors[myRace]) end
                end
            end
        end)

        RaceTab:CreateSection("التدريب واجتياز الترايل (Race V4 Train & Trial)")

        RaceTab:CreateToggle("التدريب التلقائي للـ V4 (Auto Train)", "AutoTrainFlag", false, function(state)
            _G.Settings.Race["Auto Train"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("اجتياز الترايل تلقائياً (Auto Trial)", "AutoTrialFlag", false, function(state)
            _G.Settings.Race["Auto Trial"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 7. TAB: SUB FARMING
        ---------------------------------------------------------
        SubFarmTab:CreateSection("صياد النخبة والعظام (Elite & Bones)")

        SubFarmTab:CreateToggle("صياد النخبة التلقائي (Auto Elite Hunter)", "EliteFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("صياد النخبة مع السيرفر هوب (Elite Hop)", "EliteHopFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter Hop"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("تجميع العظام التلقائي (Auto Farm Bones)", "BoneFlag", false, function(state)
            _G.Settings.SubFarm["Auto Farm Bone"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateSection("تجميع الصناديق التلقائي (Auto Chests)")

        SubFarmTab:CreateToggle("جمع الصناديق بالطيران (Chest Tween)", "ChestTweenFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Tween"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("جمع الصناديق الفوري (Chest Instant)", "ChestInstantFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Instant"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("توقف عند الحصول على دروب نادر (Stop on Items)", "StopItemsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Stop Items"] = state
        end)

        SubFarmTab:CreateSection("تلفيل الماستري التلقائي (Auto Mastery)")

        SubFarmTab:CreateToggle("تلفيل ماستري Melee (لـ 400)", "AutoMasteryMeleeFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Melee"] = state
            if not state then StopTween() end
        end)
        SubFarmTab:CreateToggle("تلفيل ماستري Swords (لـ 400)", "AutoMasterySwordsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Swords"] = state
            if not state then StopTween() end
        end)
        SubFarmTab:CreateToggle("تلفيل ماستري Blox Fruits (لـ 400)", "AutoMasteryBloxFruitsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Blox Fruits"] = state
            if not state then StopTween() end
        end)
        SubFarmTab:CreateToggle("تلفيل ماستري Guns (لـ 400)", "AutoMasteryGunsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Guns"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 8. TAB: CAKE PRINCE & DOUGH KING
        ---------------------------------------------------------
        CakeTab:CreateSection("الكيك برنس و دو كينغ")

        CakeTab:CreateToggle("تلفيل وقتل الكاتكوري بالكامل (Auto Katakuri)", "KatakuriFlag", false, function(state)
            _G.Settings.Cake["Auto Katakuri"] = state
            if not state then StopTween() end
        end)

        CakeTab:CreateToggle("استدعاء الكيك برنس التلقائي (Auto Spawn Prince)", "SpawnPrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Spawn Cake Prince"] = state
        end)

        CakeTab:CreateToggle("قتل الكيك برنس فور ظهوره (Auto Kill Cake Prince)", "KillPrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Cake Prince"] = state
            if not state then StopTween() end
        end)

        CakeTab:CreateToggle("قتل دو كينغ فور ظهوره (Auto Kill Dough King)", "KillDoughFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Dough King"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 9. TAB: SEA FARMING (Prehistoric & Draco Trail)
        ---------------------------------------------------------
        SeaTab:CreateSection("الجزيرة القديمة وما قبل التاريخ (Prehistoric Engine)")

        SeaTab:CreateButton("🏝️ Teleport Prehistoric Island (انتقال فوري)", function()
            TweenPlayer(MobSpecificTeleports["Prehistoric Island"])
            AetherUI:Notify({Title = "Teleport", Content = "جاري الانتقال إلى الجزيرة القديمة...", Duration = 2})
        end)

        SeaTab:CreateToggle("🦖 أتمتة الجزيرة القديمة (Auto Prehistoric Island)", "AutoPrehistoricFlag", false, function(state)
            _G.Settings.Sea["Auto Prehistoric Island"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🔥 إنهاء الجزيرة والشعلات (Auto Complete Prehistoric Island)", "AutoCompletePrehistoricFlag", false, function(state)
            _G.Settings.Sea["Auto Complete Prehistoric Island"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🐉 تدريب دراكو وقهر الوحوش (Auto Draco Trail)", "AutoDracoTrailFlag", false, function(state)
            _G.Settings.Sea["Auto Draco Trail"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateSection("إبحار وأحداث البحر والبحث عن الجزر")

        SeaTab:CreateDropdown("اختر القارب (Select Boat)", "BoatDropdownFlag", {"Guardian", "Beast Hunter", "PirateGrandBrigade", "MarineGrandBrigade"}, "Guardian", function(selected)
            _G.Settings.Sea["Selected Boat"] = selected
        end)

        SeaTab:CreateDropdown("اختر منطقة الإبحار (Select Zone)", "ZoneDropdownFlag", {"Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5", "Zone 6", "Infinite"}, "Zone 5", function(selected)
            _G.Settings.Sea["Selected Zone"] = selected
        end)

        SeaTab:CreateToggle("تفعيل الإبحار التلقائي (Sail Boat)", "SailBoatFlag", false, function(state)
            _G.Settings.Sea["Sail Boat"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateSection("قتال مخلوقات وحوش البحر (Sea Mobs Farming)")

        SeaTab:CreateToggle("🦈 قتل أسماك القرش (Auto Farm Shark)", "SharkFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Shark"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🐟 قتل البيرانا (Auto Farm Piranha)", "PiranhaFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Piranha"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🧜‍♂️ قتل طاقم الأسماك (Fish Crew Member)", "CrewFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Fish Crew Member"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("👻 قتل السفن الشبحية (Ghost Ship)", "GhostShipFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Ghost Ship"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🦖 قتل التيرور شارك (Terrorshark)", "TerrorFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Terrorshark"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🌊 قتل السي بيست (Seabeasts)", "SeabeastFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Seabeasts"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🛡️ تفادي هجمات السي بيست (Dodge Seabeasts)", "DodgeSBFlag", true, function(state)
            _G.Settings.Sea["Dodge Seabeasts Attack"] = state
        end)

        SeaTab:CreateToggle("🦊 البحث التلقائي عن Kitsune Island والإبحار لها", "AutoFindKitsuneIslandFlag", false, function(state)
            _G.Settings.Sea["Auto Find Kitsune Island"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 10. TAB: AUTO QUESTS
        ---------------------------------------------------------
        AutoQuestsTab:CreateSection("أخذ وإنهاء المهمات المباشرة")

        AutoQuestsTab:CreateButton("أخذ مهمة القرود (Jungle Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "JungleQuest", 1) end
        end)
        AutoQuestsTab:CreateButton("أخذ مهمة القراصنة (Buggy Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "BuggyQuest1", 1) end
        end)
        AutoQuestsTab:CreateButton("إلغاء المهمة الحالية (Abandon Quest)", function()
            if CommF_ then CommF_:InvokeServer("AbandonQuest") end
        end)

        ---------------------------------------------------------
        -- 📌 11. TAB: TELEPORTS (أزرار للبحار وتوغلات للجزر)
        ---------------------------------------------------------
        TeleportsTab:CreateSection("الانتقال بين البحار (Sea Travel Buttons)")

        TeleportsTab:CreateButton("🌊 الانتقال إلى Sea 1 (World 1)", function()
            if CommF_ then CommF_:InvokeServer("TravelMain") end
        end)

        TeleportsTab:CreateButton("🌊 الانتقال إلى Sea 2 (World 2)", function()
            if CommF_ then CommF_:InvokeServer("TravelDressrosa") end
        end)

        TeleportsTab:CreateButton("🌊 الانتقال إلى Sea 3 (World 3)", function()
            if CommF_ then CommF_:InvokeServer("TravelZou") end
        end)

        TeleportsTab:CreateSection("انتقالات جزر العالم الأول (Sea 1 Toggles)")
        for islandName, cf in pairs(FullIslandLocations.Sea1) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("📍 انتقال إلى " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf)
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        TeleportsTab:CreateSection("انتقالات جزر العالم الثاني (Sea 2 Toggles)")
        for islandName, cf in pairs(FullIslandLocations.Sea2) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("📍 انتقال إلى " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf)
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        TeleportsTab:CreateSection("انتقالات جزر العالم الثالث (Sea 3 Toggles)")
        for islandName, cf in pairs(FullIslandLocations.Sea3) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("📍 انتقال إلى " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf)
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        ---------------------------------------------------------
        -- 📌 12. TAB: VISUALS & ESP (جميع التوغلات Off افتراضياً)
        ---------------------------------------------------------
        VisualTab:CreateSection("كاشفات العناصر ورادار المسافات (All Toggles Off)")

        VisualTab:CreateToggle("👤 ESP Players (كاشف اللاعبين)", "ESPPlayersFlag", false, function(state)
            _G.Settings.Visuals["ESP Players"] = state
        end)

        VisualTab:CreateToggle("💀 ESP Bosses (كاشف الزعماء)", "ESPBossesFlag", false, function(state)
            _G.Settings.Visuals["ESP Bosses"] = state
        end)

        VisualTab:CreateToggle("🍎 ESP Fruits (كاشف الفواكه)", "ESPFruitsFlag", false, function(state)
            _G.Settings.Visuals["ESP Fruits"] = state
        end)

        VisualTab:CreateToggle("📦 ESP Chests (كاشف الصناديق)", "ESPChestsFlag", false, function(state)
            _G.Settings.Visuals["ESP Chests"] = state
        end)

        VisualTab:CreateToggle("👾 ESP Enemies (كاشف الوحوش والأعداء)", "ESPEnemiesFlag", false, function(state)
            _G.Settings.Visuals["ESP Enemies"] = state
        end)

        VisualTab:CreateToggle("🏝️ ESP Mirage Island", "ESPMirageFlag", false, function(state)
            _G.Settings.Visuals["ESP Mirage Island"] = state
        end)

        VisualTab:CreateToggle("🦊 ESP Kitsune Island", "ESPKitsuneFlag", false, function(state)
            _G.Settings.Visuals["ESP Kitsune Island"] = state
        end)

        ---------------------------------------------------------
        -- 📌 13. TAB: MISC (Auto Stats وحالة السيرفر)
        ---------------------------------------------------------
        MiscTab:CreateSection("توزيع النقاط التلقائي (Auto Stats Engine)")

        MiscTab:CreateDropdown("اختر الخاصية (Select Stat)", "SelectStatDropdown", {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}, "Melee", function(selected)
            _G.Settings.Stats["Selected Stat"] = selected
        end)

        MiscTab:CreateSlider("عدد النقاط لكل دورة (Points Per Tick)", "StatPointsSlider", 1, 100, 1, function(val)
            _G.Settings.Stats["Points Per Tick"] = val
        end)

        MiscTab:CreateToggle("⚡ تفعيل توزيع النقاط التلقائي (Auto Stats)", "AutoStatsToggleFlag", false, function(state)
            _G.Settings.Stats["Auto Stats"] = state
        end)

        MiscTab:CreateSection("حالة السيرفر والعدادات المباشرة (Server Status)")

        local serverClockParagraph = MiscTab:CreateParagraph({
            Title = "⏰ Server Clock Time (ساعة السيرفر)",
            Desc = "جارٍ التحميل...",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local playerTimeParagraph = MiscTab:CreateParagraph({
            Title = "⏱️ Time Connected In Server (مدة بقائك بالسيرفر)",
            Desc = "0 Hours 0 Minutes 0 Seconds",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local cakePrinceCountParagraph = MiscTab:CreateParagraph({
            Title = "👑 Cake Prince Status (عداد الأعداء المتبقي)",
            Desc = "جارٍ جلب البيانات الحية...",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local mirageStatusParagraph = MiscTab:CreateParagraph({
            Title = "🏝️ Mirage Island Status",
            Desc = "جارٍ الفحص...",
            Image = "rbxassetid://6034453535",
            ImageSize = 20
        })

        local kitsuneStatusParagraph = MiscTab:CreateParagraph({
            Title = "🦊 Kitsune Island Status",
            Desc = "جارٍ الفحص...",
            Image = "rbxassetid://6034453535",
            ImageSize = 20
        })

        task.spawn(function()
            while task.wait(1) do
                pcall(function()
                    local clockTime = game.Lighting.ClockTime
                    local hours = math.floor(clockTime)
                    local minutes = math.floor((clockTime - hours) * 60)
                    serverClockParagraph:SetDesc(string.format("%02d:%02d", hours, minutes))

                    local gameTime = math.floor(workspace.DistributedGameTime + 0.5)
                    local sH = math.floor(gameTime / 3600) % 24
                    local sM = math.floor(gameTime / 60) % 60
                    local sS = math.floor(gameTime) % 60
                    playerTimeParagraph:SetDesc(sH .. " Hours " .. sM .. " Minutes " .. sS .. " Seconds")

                    if World3 and CommF_ then
                        local princeData = CommF_:InvokeServer("CakePrinceSpawner")
                        if typeof(princeData) == "string" then
                            if string.find(princeData, "spawned") or string.find(princeData, "ready") then
                                cakePrinceCountParagraph:SetDesc("👑 Cake Prince Is Spawned! (تم استدعاء الكيك برنس!)")
                            else
                                local rem = string.match(princeData, "%d+")
                                cakePrinceCountParagraph:SetDesc(rem and ("⚔️ متبقي " .. rem .. " بوت/عدو لاستدعاء Cake Prince") or princeData)
                            end
                        end
                    else
                        cakePrinceCountParagraph:SetDesc("متوفر في العالم الثالث فقط (Sea 3 Only)")
                    end

                    local mirageIsland = workspace.Map:FindFirstChild("MysticIsland")
                    if mirageIsland then
                        local char, hrp = GetCharacter()
                        local dist = hrp and math.floor((hrp.Position - mirageIsland.WorldPivot.Position).Magnitude) or 0
                        mirageStatusParagraph:SetDesc("✅ ظهرت بالفعل! | المسافة: " .. dist .. "m")
                    else
                        mirageStatusParagraph:SetDesc("❌ لم تظهر بعد")
                    end

                    local kitsuneIsland = workspace.Map:FindFirstChild("KitsuneIsland")
                    if kitsuneIsland then
                        local char, hrp = GetCharacter()
                        local dist = hrp and math.floor((hrp.Position - kitsuneIsland.WorldPivot.Position).Magnitude) or 0
                        kitsuneStatusParagraph:SetDesc("✅ ظهرت بالفعل! | المسافة: " .. dist .. "m")
                    else
                        kitsuneStatusParagraph:SetDesc("❌ لم تظهر بعد")
                    end
                end)
            end
        end)

        MiscTab:CreateSection("إعدادات الفريق والـ Haki")

        MiscTab:CreateToggle("تفعيل الـ Ken (Buso Haki) تلقائياً", "AutoKenFlag", false, function(state)
            _G.Settings.Misc["Auto Ken (Buso Haki)"] = state
        end)

        MiscTab:CreateToggle("الانضمام إلى فريق المارينز", "SetTeamMarinesFlag", false, function(state)
            _G.Settings.Misc["Set Team to Marines"] = state
            if state and CommF_ then CommF_:InvokeServer("SetTeam", "Marines") end
        end)

        MiscTab:CreateToggle("الانضمام إلى فريق القراصنة", "SetTeamPiratesFlag", false, function(state)
            _G.Settings.Misc["Set Team to Pirates"] = state
            if state and CommF_ then CommF_:InvokeServer("SetTeam", "Pirates") end
        end)

        ---------------------------------------------------------
        -- 📌 14. TAB: SETTINGS
        ---------------------------------------------------------
        SettingsTab:CreateSection("إعدادات وتحكم السكربت")

        SettingsTab:CreateButton("إعادة دخول السيرفر (Rejoin)", function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)

        SettingsTab:CreateButton("إغلاق السكربت بالكامل (Destroy Hub)", function()
            local master = game:GetService("CoreGui"):FindFirstChild("HaroonHub_Master") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("HaroonHub_Master")
            if master then master:Destroy() end
        end)
    end)
end)

--------------------------------------------------------------------------------
-- 7. حلقة التلفيل الفردي والانتقال المباشر (Single-Target Master Loop)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.08) do
        if _G.Settings.Main["Auto Farm Level"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum or hum.Health <= 0 then return end

                CheckQuest()
                AutoHaki()

                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")

                if not questGui or not questGui.Visible or not string.find(questGui.Container.QuestTitle.Title.Text, CurrentQuest.NameMon) then
                    if CommF_ then CommF_:InvokeServer("AbandonQuest") end
                    TweenPlayer(CurrentQuest.CFrameQuest, Vector3.new(0, 5, 0))

                    if (hrp.Position - CurrentQuest.CFrameQuest.Position).Magnitude <= 20 then
                        if CommF_ then CommF_:InvokeServer("StartQuest", CurrentQuest.NameQuest, CurrentQuest.LevelQuest) end
                    end
                else
                    local targetMob = nil
                    local closestDistance = math.huge

                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v:IsA("Model") and v.Name == CurrentQuest.Mon then
                            local root = v:FindFirstChild("HumanoidRootPart")
                            local mobHum = v:FindFirstChildOfClass("Humanoid")
                            if root and mobHum and mobHum.Health > 0 then
                                local dist = (hrp.Position - root.Position).Magnitude
                                if dist < closestDistance then
                                    closestDistance = dist
                                    targetMob = v
                                end
                            end
                        end
                    end

                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        TweenPlayer(targetMob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(targetMob)
                    else
                        TweenPlayer(CurrentQuest.CFrameMon, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 8. محرك الإبحار والقتال البحري والجزيرة القديمة (Sea & Prehistoric Engine)
--------------------------------------------------------------------------------
local function GetMyBoat(boatName: string): Model?
    if workspace:FindFirstChild("Boats") then
        for _, b in pairs(workspace.Boats:GetChildren()) do
            if b.Name == boatName and b:FindFirstChild("VehicleSeat") then
                return b
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.2) do
        if World3 then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                -- 1. أتمتة الجزيرة القديمة وما قبل التاريخ Prehistoric Engine
                if _G.Settings.Sea["Auto Prehistoric Island"] or _G.Settings.Sea["Auto Complete Prehistoric Island"] or _G.Settings.Sea["Auto Draco Trail"] then
                    local targetPreMob = nil
                    for _, mName in pairs({"Isle Outlaw", "Island Boy", "Sun-kissed Warrior", "Terrorshark"}) do
                        local mob = workspace.Enemies:FindFirstChild(mName)
                        if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                            targetPreMob = mob
                            break
                        end
                    end

                    if targetPreMob then
                        AutoHaki()
                        TweenPlayer(targetPreMob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(targetPreMob)
                        return
                    else
                        TweenPlayer(MobSpecificTeleports["Prehistoric Island"], Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                    end
                end

                -- 2. فحص وهجوم أعداء ومخلوقات البحر
                local targetSeaEnemy = nil
                local allowedEnemies = {}
                if _G.Settings.Sea["Auto Farm Shark"] then table.insert(allowedEnemies, "Shark") end
                if _G.Settings.Sea["Auto Farm Piranha"] then table.insert(allowedEnemies, "Piranha") end
                if _G.Settings.Sea["Auto Farm Fish Crew Member"] then table.insert(allowedEnemies, "Fish Crew Member") end
                if _G.Settings.Sea["Auto Farm Ghost Ship"] then table.insert(allowedEnemies, "Ghost Ship") table.insert(allowedEnemies, "FishBoat") end
                if _G.Settings.Sea["Auto Farm Terrorshark"] then table.insert(allowedEnemies, "Terrorshark") end

                if #allowedEnemies > 0 and workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if table.find(allowedEnemies, enemy.Name) and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                            targetSeaEnemy = enemy
                            break
                        end
                    end
                end

                if targetSeaEnemy then
                    if hum.Sit then hum.Sit = false end
                    AutoHaki()
                    TweenPlayer(targetSeaEnemy.HumanoidRootPart.CFrame, Vector3.new(0, 25, 0))
                    SmartAttackMob(targetSeaEnemy)
                    return
                end

                -- قتال السي بيست (SeaBeasts)
                if _G.Settings.Sea["Auto Farm Seabeasts"] and workspace:FindFirstChild("SeaBeasts") then
                    for _, sb in pairs(workspace.SeaBeasts:GetChildren()) do
                        if sb:FindFirstChild("HumanoidRootPart") and sb:FindFirstChildOfClass("Humanoid") and sb.Humanoid.Health > 0 then
                            if hum.Sit then hum.Sit = false end
                            AutoHaki()
                            local dodgeOffset = _G.Settings.Sea["Dodge Seabeasts Attack"] and Vector3.new(math.random(-50, 50), 55, math.random(-50, 50)) or Vector3.new(0, 55, 0)
                            TweenPlayer(sb.HumanoidRootPart.CFrame, dodgeOffset)
                            FastAttackTarget(sb)
                            return
                        end
                    end
                end

                -- الفحص الفوري عن Mirage أو Kitsune Island
                local mirage = workspace.Map:FindFirstChild("MysticIsland")
                local kitsune = workspace.Map:FindFirstChild("KitsuneIsland")

                if _G.Settings.Race["Auto Find Mirage"] and mirage then
                    TweenPlayer(mirage.WorldPivot)
                    return
                end

                if _G.Settings.Sea["Auto Find Kitsune Island"] and kitsune then
                    TweenPlayer(kitsune.WorldPivot)
                    return
                end

                -- الإبحار التلقائي بالقارب
                if _G.Settings.Sea["Sail Boat"] or _G.Settings.Race["Auto Find Mirage"] or _G.Settings.Sea["Auto Find Kitsune Island"] then
                    local boat = GetMyBoat(_G.Settings.Sea["Selected Boat"])
                    if not boat then
                        local buyPos = MobSpecificTeleports["Kitsune Island"]
                        if (hrp.Position - buyPos.Position).Magnitude > 30 then
                            TweenPlayer(buyPos)
                        else
                            if CommF_ then CommF_:InvokeServer("BuyBoat", _G.Settings.Sea["Selected Boat"]) end
                        end
                    else
                        if not hum.Sit then
                            hrp.CFrame = boat.VehicleSeat.CFrame * CFrame.new(0, 1.5, 0)
                        else
                            local targetZone = ZoneCFrames[_G.Settings.Sea["Selected Zone"]] or ZoneCFrames["Zone 5"]
                            local dist = (boat.VehicleSeat.Position - targetZone.Position).Magnitude
                            if dist > 100 then
                                local tween = TweenService:Create(boat.VehicleSeat, TweenInfo.new(dist / _G.Settings.Sea["Boat Tween Speed"], Enum.EasingStyle.Linear), {CFrame = targetZone})
                                tween:Play()
                            end
                        end
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 9. محرك تجميع وسرقة وتخزين الفواكه (Fruits Automation Loop)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Fruits["Auto Store Fruit"] then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") and (string.find(tool.Name, "Fruit") or tool.ToolTip == "Blox Fruit") then
                            if CommF_ then CommF_:InvokeServer("StoreFruit", tool.Name, tool) end
                        end
                    end
                end
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and (string.find(tool.Name, "Fruit") or tool.ToolTip == "Blox Fruit") then
                        if CommF_ then CommF_:InvokeServer("StoreFruit", tool.Name, tool) end
                    end
                end
            end)
        end

        if _G.Settings.Fruits["Fruit Sniper"] then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Tool") and (string.find(obj.Name, "Fruit") or string.find(obj.Name, "Blox")) then
                        local handle = obj:FindFirstChild("Handle") or obj.PrimaryPart
                        if handle then
                            TweenPlayer(handle.CFrame)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 10. محرك الـ Dungeon / Fruits Raid (مع Auto Next Island)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Raid["Auto Dungeon / Raid"] or _G.Settings.Raid["Auto Buy Chip & Start"] or _G.Settings.Raid["Auto Clear Dungeon Waves"] or _G.Settings.Raid["Auto Next Island"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                -- شراء الشريحة وبدء الريد
                if _G.Settings.Raid["Auto Buy Chip & Start"] then
                    if CommF_ then
                        CommF_:InvokeServer("RaidsNpc", "Select", _G.Settings.Raid["Selected Chip"])
                        task.wait(0.5)
                        CommF_:InvokeServer("RaidsNpc", "Start")
                    end
                end

                -- تنظيف وتصفية وحوش الريد
                if _G.Settings.Raid["Auto Clear Dungeon Waves"] and workspace:FindFirstChild("Enemies") then
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                            AutoHaki()
                            TweenPlayer(mob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                            SmartAttackMob(mob)
                            break
                        end
                    end
                end

                -- الانتقال التلقائي للجزيرة التالية في الريد فور انتهاء الموجة
                if _G.Settings.Raid["Auto Next Island"] and workspace:FindFirstChild("Locations") then
                    for _, loc in pairs(workspace.Locations:GetChildren()) do
                        if string.find(loc.Name:lower(), "island") or string.find(loc.Name:lower(), "raid") then
                            TweenPlayer(loc.CFrame * CFrame.new(0, 30, 0))
                            break
                        end
                    end
                end

                -- إيقاظ الفاكهة التلقائي
                if _G.Settings.Raid["Auto Awaken"] and CommF_ then
                    CommF_:InvokeServer("AwakeningExpert", "Awaken")
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 11. محرك الـ Auto Stats
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Stats["Auto Stats"] then
            pcall(function()
                local points = LocalPlayer.Data.Points.Value
                if points and points > 0 then
                    local targetStat = _G.Settings.Stats["Selected Stat"]
                    local addCount = math.min(points, _G.Settings.Stats["Points Per Tick"] or 1)
                    if CommF_ then
                        CommF_:InvokeServer("AddPoint", targetStat, addCount)
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 12. محرك ترقية الأجناس الاحترافي (Race V2 & V3 Master Loop)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        -- أتمتة Race V2 الكاملة (جمع الأزهار والتسليم)
        if _G.Settings.Race["Auto Race V2 Quest"] and World2 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local flowers = {"Flower1", "Flower2", "Flower3"}
                local foundFlower = false

                for _, fName in pairs(flowers) do
                    local flowerObj = workspace:FindFirstChild(fName) or (workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild(fName))
                    if flowerObj and flowerObj:IsA("BasePart") then
                        foundFlower = true
                        TweenPlayer(flowerObj.CFrame)
                        break
                    end
                end

                if not foundFlower then
                    local alchemistPos = CFrame.new(-2440.79, 71.71, -3216.06)
                    if (hrp.Position - alchemistPos.Position).Magnitude > 20 then
                        TweenPlayer(alchemistPos)
                    else
                        if CommF_ then CommF_:InvokeServer("Alchemist", "1") end
                    end
                end
            end)
        end

        -- أتمتة Race V3 الكاملة بحسب متطلبات الجنس
        if _G.Settings.Race["Auto Race V3 Quest"] and World2 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local selectedRace = _G.Settings.Race["Selected Race V3"]
                local arouPos = CFrame.new(-2440.79, 71.71, -3216.06)

                if selectedRace == "Human" then
                    -- قتل الزعماء الثلاثة للـ Human V3
                    for _, bossName in pairs({"Jeremy", "Diamond", "Fajita"}) do
                        local boss = workspace.Enemies:FindFirstChild(bossName)
                        if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChildOfClass("Humanoid") and boss.Humanoid.Health > 0 then
                            AutoHaki()
                            TweenPlayer(boss.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                            SmartAttackMob(boss)
                            return
                        end
                    end
                end

                -- التحدث إلى NPC Arou
                if (hrp.Position - arouPos.Position).Magnitude > 20 then
                    TweenPlayer(arouPos)
                else
                    if CommF_ then CommF_:InvokeServer("Wenlocktoad", "1") end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 13. محرك السيوف الأسطورية المدمجة (CDK & TTK Auto Quests)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        -- أتمتة Cursed Dual Katana (CDK)
        if _G.Settings.FarmingQuests["Auto Farm CDK"] and World3 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local cryptPos = CFrame.new(-12471.16, 374.94, -7551.67)
                if (hrp.Position - cryptPos.Position).Magnitude > 25 then
                    TweenPlayer(cryptPos)
                else
                    if CommF_ then
                        CommF_:InvokeServer("CDKQuest", "Start")
                        CommF_:InvokeServer("CDKQuest", "Progress")
                    end
                end
            end)
        end

        -- أتمتة True Triple Katana (TTK)
        if _G.Settings.FarmingQuests["Auto Farm TTK"] and World2 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local swordDealerPos = CFrame.new(-2448.53, 73.01, -3210.63)
                if CommF_ then
                    CommF_:InvokeServer("LegendarySwordDealer", "1")
                    CommF_:InvokeServer("LegendarySwordDealer", "2")
                    CommF_:InvokeServer("LegendarySwordDealer", "3")
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 14. محرك الـ ESP المتكامل والحي (Advanced ESP Engine with Distance & HP)
--------------------------------------------------------------------------------
local ESPCache = {}

local function RemoveESP(obj)
    if ESPCache[obj] then
        ESPCache[obj]:Destroy()
        ESPCache[obj] = nil
    end
end

local function CreateUniversalESP(part: BasePart, text: string, color: Color3, showHP: boolean, maxHP: number?, currentHP: number?)
    if not part then return end
    if ESPCache[part] then RemoveESP(part) end

    local bill = Instance.new("BillboardGui")
    bill.Name = "HaroonESP"
    bill.Adornee = part
    bill.Size = UDim2.new(0, 150, 0, showHP and 45 or 28)
    bill.AlwaysOnTop = true

    local frame = Instance.new("Frame", bill)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BackgroundTransparency = 0.25
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

    local txt = Instance.new("TextLabel", frame)
    txt.Name = "ESPTitle"
    txt.Size = UDim2.new(1, 0, 0, 14)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = color
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 10

    local distLabel = Instance.new("TextLabel", frame)
    distLabel.Name = "ESPDist"
    distLabel.Size = UDim2.new(1, 0, 0, 12)
    distLabel.Position = UDim2.new(0, 0, 0, 13)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 9
    distLabel.Text = "Dist: ?m"

    if showHP and maxHP and currentHP then
        local hpBg = Instance.new("Frame", frame)
        hpBg.Size = UDim2.new(1, -10, 0, 4)
        hpBg.Position = UDim2.new(0, 5, 0, 28)
        hpBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        local hpFill = Instance.new("Frame", hpBg)
        hpFill.Name = "HPFill"
        hpFill.Size = UDim2.new(math.clamp(currentHP / maxHP, 0, 1), 0, 1, 0)
        hpFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end

    bill.Parent = part
    ESPCache[part] = bill
end

task.spawn(function()
    while task.wait(0.2) do
        local char, hrp = GetCharacter()
        if not char or not hrp then continue end

        -- 1. Players ESP
        if _G.Settings.Visuals["ESP Players"] then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
                    local pHrp = p.Character.HumanoidRootPart
                    local pHum = p.Character.Humanoid
                    local dist = math.floor((hrp.Position - pHrp.Position).Magnitude)
                    
                    CreateUniversalESP(pHrp, p.Name, Color3.fromRGB(255, 85, 85), true, pHum.MaxHealth, pHum.Health)
                    if ESPCache[pHrp] and ESPCache[pHrp]:FindFirstChild("Frame") then
                        ESPCache[pHrp].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                    end
                end
            end
        end

        -- 2. Fruits ESP
        if _G.Settings.Visuals["ESP Fruits"] then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Tool") and (string.find(v.Name, "Fruit") or string.find(v.Name, "Blox")) then
                    local handle = v:FindFirstChild("Handle") or v.PrimaryPart
                    if handle then
                        local dist = math.floor((hrp.Position - handle.Position).Magnitude)
                        CreateUniversalESP(handle, "🍎 " .. v.Name, Color3.fromRGB(255, 170, 0), false)
                        if ESPCache[handle] and ESPCache[handle]:FindFirstChild("Frame") then
                            ESPCache[handle].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                        end
                    end
                end
            end
        end

        -- 3. Chests ESP
        if _G.Settings.Visuals["ESP Chests"] and workspace:FindFirstChild("ChestModels") then
            for _, chest in pairs(workspace.ChestModels:GetChildren()) do
                if chest:FindFirstChild("RootPart") then
                    local dist = math.floor((hrp.Position - chest.RootPart.Position).Magnitude)
                    CreateUniversalESP(chest.RootPart, "📦 " .. chest.Name, Color3.fromRGB(255, 255, 0), false)
                    if ESPCache[chest.RootPart] and ESPCache[chest.RootPart]:FindFirstChild("Frame") then
                        ESPCache[chest.RootPart].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                    end
                end
            end
        end

        -- 4. Bosses & Enemies ESP
        if (_G.Settings.Visuals["ESP Bosses"] or _G.Settings.Visuals["ESP Enemies"]) and workspace:FindFirstChild("Enemies") then
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                    local eHrp = enemy.HumanoidRootPart
                    local eHum = enemy.Humanoid
                    if eHum.Health > 0 then
                        local dist = math.floor((hrp.Position - eHrp.Position).Magnitude)
                        CreateUniversalESP(eHrp, enemy.Name, Color3.fromRGB(255, 0, 127), true, eHum.MaxHealth, eHum.Health)
                        if ESPCache[eHrp] and ESPCache[eHrp]:FindFirstChild("Frame") then
                            ESPCache[eHrp].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                        end
                    end
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- 15. حلقات الصناديق والماتيريال والزعماء المتبقية
--------------------------------------------------------------------------------

-- Chest Farm Loop
task.spawn(function()
    while task.wait(0.2) do
        if _G.Settings.SubFarm["Auto Chest Tween"] or _G.Settings.SubFarm["Auto Chest Instant"] then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local closestChest = nil
                local shortestDist = math.huge
                if workspace:FindFirstChild("ChestModels") then
                    for _, v in pairs(workspace.ChestModels:GetChildren()) do
                        if string.find(v.Name, "Chest") and v:FindFirstChild("RootPart") then
                            local dist = (hrp.Position - v.RootPart.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestChest = v
                            end
                        end
                    end
                end

                if closestChest then
                    if _G.Settings.SubFarm["Auto Chest Instant"] then
                        hrp.CFrame = closestChest.RootPart.CFrame
                    else
                        TweenPlayer(closestChest.RootPart.CFrame)
                    end
                end
            end)
        end
    end
end)

-- Material Farm Loop
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Main["Auto Farm Material"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                local mobs, pos = GetMaterialConfig(_G.Settings.Main["Selected Material"])
                local found = false

                for _, mName in pairs(mobs) do
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == mName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                            found = true
                            AutoHaki()
                            TweenPlayer(v.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                            SmartAttackMob(v)
                            break
                        end
                    end
                    if found then break end
                end

                if not found then
                    TweenPlayer(pos, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                end
            end)
        end
    end
end)

-- Boss Farm Loop
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Main["Auto Farm Boss"] or _G.Settings.Main["Auto Farm All Boss"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                local bTarget = _G.Settings.Main["Selected Boss"]
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if (v.Name == bTarget or _G.Settings.Main["Auto Farm All Boss"]) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                        AutoHaki()
                        TweenPlayer(v.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(v)
                        break
                    end
                end
            end)
        end
    end
end)       _G.Settings.Sea["Auto Draco Trail"] or _G.Settings.Raid["Auto Next Island"]

    local char, hrp, hum = GetCharacter()
    if not char or not hrp or not hum then return end

    if active then
        pcall(function()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            if not hrp:FindFirstChild("HaroonBV") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "HaroonBV"
                bv.Parent = hrp
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.zero
            end
        end)
    else
        pcall(function()
            if hrp:FindFirstChild("HaroonBV") then
                hrp.HaroonBV:Destroy()
            end
        end)
    end
end)

local function TweenPlayer(pos: CFrame | Vector3 | BasePart, offset: Vector3?): Tween?
    local char, hrp, hum = GetCharacter()
    if not char or not hrp or not hum then return nil end
    if hum.Sit then hum.Sit = false end

    local targetCFrame: CFrame
    if typeof(pos) == "CFrame" then targetCFrame = pos
    elseif typeof(pos) == "Vector3" then targetCFrame = CFrame.new(pos)
    elseif pos:IsA("BasePart") then targetCFrame = pos.CFrame
    else return nil end

    if offset then targetCFrame = targetCFrame * CFrame.new(offset) end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local uprightCFrame = CFrame.new(targetCFrame.Position, targetCFrame.Position + Vector3.new(targetCFrame.LookVector.X, 0, targetCFrame.LookVector.Z))

    if distance <= 25 then
        hrp.CFrame = uprightCFrame
        if currentTween then currentTween:Cancel() end
        return nil
    end

    local speed = _G.Settings.Main["Player Tween Speed"] or 180
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)

    if currentTween then currentTween:Cancel() end
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = uprightCFrame})
    currentTween:Play()
    return currentTween
end

local function StopTween()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    local _, hrp = GetCharacter()
    if hrp and hrp:FindFirstChild("HaroonBV") then
        hrp.HaroonBV:Destroy()
    end
end

local function AutoHaki()
    local char = LocalPlayer.Character
    if char and not CollectionService:HasTag(char, "Ken") then
        if CommE then pcall(function() CommE:FireServer("Ken", true) end) end
    end
end

local function EquipWeapon(weaponType: string)
    pcall(function()
        local char, _, hum = GetCharacter()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack or not hum or not char then return end

        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == weaponType or (weaponType == "Melee" and tool.ToolTip == "Melee") or (weaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit") or (weaponType == "Gun" and tool.ToolTip == "Gun") or (weaponType == "Sword" and tool.ToolTip == "Sword")) then
                return
            end
        end

        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == weaponType or (weaponType == "Melee" and tool.ToolTip == "Melee") or (weaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit") or (weaponType == "Gun" and tool.ToolTip == "Gun") or (weaponType == "Sword" and tool.ToolTip == "Sword")) then
                hum:EquipTool(tool)
                break
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- 4. المحرك الذكي للهجوم والـ Aimbot والـ 80% Damage Mechanic
--------------------------------------------------------------------------------
local function AimAtTarget(targetPosition: Vector3)
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetPosition)
        end
    end)
end

local function FastAttackTarget(targetEnemy: Model)
    if not targetEnemy or not targetEnemy:FindFirstChild("HumanoidRootPart") then return end
    local head = targetEnemy:FindFirstChild("Head") or targetEnemy.HumanoidRootPart

    if RegisterAttack then
        pcall(function()
            RegisterAttack:FireServer(0)
            RegisterAttack:FireServer(1)
            RegisterAttack:FireServer(2)
            RegisterAttack:FireServer(3)
        end)
    end

    if RegisterHit then
        pcall(function()
            if typeof(RegisterHit) == "thread" or typeof(RegisterHit) == "function" then
                coroutine.resume(RegisterHit, head, {})
            elseif typeof(RegisterHit) == "Instance" then
                RegisterHit:FireServer(head, {})
            end
        end)
    end
end

local function SmartAttackMob(targetMob: Model, weaponOverride: string?): boolean
    local selectedWep = weaponOverride or _G.Settings.Main["Select Weapon"]
    local mobHum = targetMob:FindFirstChildOfClass("Humanoid")
    local mobRoot = targetMob:FindFirstChild("HumanoidRootPart") or targetMob:FindFirstChild("Head")
    if not mobHum or mobHum.Health <= 0 or not mobRoot then return false end

    local hpPercent = mobHum.Health / mobHum.MaxHealth

    if selectedWep == "Blox Fruit" or selectedWep == "Gun" then
        if hpPercent > 0.20 then
            EquipWeapon("Melee")
            FastAttackTarget(targetMob)
        else
            EquipWeapon(selectedWep)
            AimAtTarget(mobRoot.Position)

            if selectedWep == "Blox Fruit" then
                for _, key in pairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.F}) do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end
            elseif selectedWep == "Gun" then
                for _, key in pairs({Enum.KeyCode.Z, Enum.KeyCode.X}) do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end
                if ShootGunEvent then
                    pcall(function() ShootGunEvent:FireServer(mobRoot.Position, {mobRoot}) end)
                end
            end

            VirtualInputManager:SendMouseButtonEvent(mobRoot.Position.X, mobRoot.Position.Y, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(mobRoot.Position.X, mobRoot.Position.Y, 0, false, game, 0)
            FastAttackTarget(targetMob)
        end
    else
        EquipWeapon(selectedWep)
        FastAttackTarget(targetMob)
    end

    return true
end

--------------------------------------------------------------------------------
-- 5. قواعد البيانات الشاملة للمهمات والجزر (Quests & Islands Database)
--------------------------------------------------------------------------------
local CurrentQuest = {
    Mon = "Bandit",
    LevelQuest = 1,
    NameQuest = "BanditQuest1",
    NameMon = "Bandit",
    CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42),
    CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
}

local function CheckQuest()
    local MyLevel = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")) and LocalPlayer.Data.Level.Value or 1
    if World1 then
        if MyLevel <= 9 then
            CurrentQuest = {Mon = "Bandit", LevelQuest = 1, NameQuest = "BanditQuest1", NameMon = "Bandit", CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42), CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)}
        elseif MyLevel <= 14 then
            CurrentQuest = {Mon = "Monkey", LevelQuest = 1, NameQuest = "JungleQuest", NameMon = "Monkey", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)}
        elseif MyLevel <= 29 then
            if _G.Settings.Main["Include Boss Quests"] and MyLevel >= 20 then
                CurrentQuest = {Mon = "The Gorilla King", LevelQuest = 3, NameQuest = "JungleQuest", NameMon = "The Gorilla King", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)}
            else
                CurrentQuest = {Mon = "Gorilla", LevelQuest = 2, NameQuest = "JungleQuest", NameMon = "Gorilla", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)}
            end
        elseif MyLevel <= 39 then
            CurrentQuest = {Mon = "Pirate", LevelQuest = 1, NameQuest = "BuggyQuest1", NameMon = "Pirate", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)}
        elseif MyLevel <= 59 then
            if _G.Settings.Main["Include Boss Quests"] and MyLevel >= 55 then
                CurrentQuest = {Mon = "Bobby", LevelQuest = 3, NameQuest = "BuggyQuest1", NameMon = "Bobby", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)}
            else
                CurrentQuest = {Mon = "Brute", LevelQuest = 2, NameQuest = "BuggyQuest1", NameMon = "Brute", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)}
            end
        elseif MyLevel <= 74 then
            CurrentQuest = {Mon = "Desert Bandit", LevelQuest = 1, NameQuest = "DesertQuest", NameMon = "Desert Bandit", CFrameQuest = CFrame.new(894.48, 5.14, 4392.43), CFrameMon = CFrame.new(924.79, 6.44, 4481.58)}
        elseif MyLevel <= 89 then
            CurrentQuest = {Mon = "Desert Officer", LevelQuest = 2, NameQuest = "DesertQuest", NameMon = "Desert Officer", CFrameQuest = CFrame.new(894.48, 5.14, 4392.43), CFrameMon = CFrame.new(1608.28, 8.61, 4371.00)}
        elseif MyLevel <= 99 then
            CurrentQuest = {Mon = "Snow Bandit", LevelQuest = 1, NameQuest = "SnowQuest", NameMon = "Snow Bandit", CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90), CFrameMon = CFrame.new(1354.34, 87.27, -1393.94)}
        elseif MyLevel <= 119 then
            CurrentQuest = {Mon = "Snowman", LevelQuest = 2, NameQuest = "SnowQuest", NameMon = "Snowman", CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90), CFrameMon = CFrame.new(1201.64, 144.57, -1550.06)}
        elseif MyLevel <= 149 then
            CurrentQuest = {Mon = "Chief Petty Officer", LevelQuest = 1, NameQuest = "MarineQuest2", NameMon = "Chief Petty Officer", CFrameQuest = CFrame.new(-5039.58, 27.35, 4324.68), CFrameMon = CFrame.new(-4881.23, 22.65, 4273.75)}
        elseif MyLevel <= 174 then
            CurrentQuest = {Mon = "Sky Bandit", LevelQuest = 1, NameQuest = "SkyQuest", NameMon = "Sky Bandit", CFrameQuest = CFrame.new(-4839.53, 716.36, -2619.44), CFrameMon = CFrame.new(-4953.20, 295.74, -2899.22)}
        elseif MyLevel <= 189 then
            CurrentQuest = {Mon = "Dark Master", LevelQuest = 2, NameQuest = "SkyQuest", NameMon = "Dark Master", CFrameQuest = CFrame.new(-4839.53, 716.36, -2619.44), CFrameMon = CFrame.new(-5259.84, 391.39, -2229.03)}
        elseif MyLevel <= 209 then
            CurrentQuest = {Mon = "Prisoner", LevelQuest = 1, NameQuest = "PrisonerQuest", NameMon = "Prisoner", CFrameQuest = CFrame.new(5308.93, 1.65, 475.12), CFrameMon = CFrame.new(5098.97, -0.32, 474.23)}
        elseif MyLevel <= 249 then
            CurrentQuest = {Mon = "Dangerous Prisoner", LevelQuest = 2, NameQuest = "PrisonerQuest", NameMon = "Dangerous Prisoner", CFrameQuest = CFrame.new(5308.93, 1.65, 475.12), CFrameMon = CFrame.new(5654.56, 15.63, 866.29)}
        elseif MyLevel <= 274 then
            CurrentQuest = {Mon = "Toga Warrior", LevelQuest = 1, NameQuest = "ColosseumQuest", NameMon = "Toga Warrior", CFrameQuest = CFrame.new(-1580.04, 6.35, -2986.47), CFrameMon = CFrame.new(-1820.21, 51.68, -2740.66)}
        elseif MyLevel <= 299 then
            CurrentQuest = {Mon = "Gladiator", LevelQuest = 2, NameQuest = "ColosseumQuest", NameMon = "Gladiator", CFrameQuest = CFrame.new(-1580.04, 6.35, -2986.47), CFrameMon = CFrame.new(-1292.83, 56.38, -3339.03)}
        elseif MyLevel <= 324 then
            CurrentQuest = {Mon = "Military Soldier", LevelQuest = 1, NameQuest = "MagmaQuest", NameMon = "Military Soldier", CFrameQuest = CFrame.new(-5313.37, 10.95, 8515.29), CFrameMon = CFrame.new(-5411.16, 11.08, 8454.29)}
        elseif MyLevel <= 374 then
            CurrentQuest = {Mon = "Military Spy", LevelQuest = 2, NameQuest = "MagmaQuest", NameMon = "Military Spy", CFrameQuest = CFrame.new(-5313.37, 10.95, 8515.29), CFrameMon = CFrame.new(-5802.86, 86.26, 8828.85)}
        elseif MyLevel <= 399 then
            CurrentQuest = {Mon = "Fishman Warrior", LevelQuest = 1, NameQuest = "FishmanQuest", NameMon = "Fishman Warrior", CFrameQuest = CFrame.new(61122.65, 18.49, 1569.39), CFrameMon = CFrame.new(60878.30, 18.48, 1543.75)}
        elseif MyLevel <= 449 then
            CurrentQuest = {Mon = "Fishman Commando", LevelQuest = 2, NameQuest = "FishmanQuest", NameMon = "Fishman Commando", CFrameQuest = CFrame.new(61122.65, 18.49, 1569.39), CFrameMon = CFrame.new(61922.63, 18.48, 1493.93)}
        elseif MyLevel <= 474 then
            CurrentQuest = {Mon = "God's Guard", LevelQuest = 1, NameQuest = "SkyExp1Quest", NameMon = "God's Guard", CFrameQuest = CFrame.new(-4721.88, 843.87, -1949.96), CFrameMon = CFrame.new(-4710.04, 845.27, -1927.30)}
        elseif MyLevel <= 524 then
            CurrentQuest = {Mon = "Shanda", LevelQuest = 2, NameQuest = "SkyExp1Quest", NameMon = "Shanda", CFrameQuest = CFrame.new(-7859.09, 5544.19, -381.47), CFrameMon = CFrame.new(-7678.48, 5566.40, -497.21)}
        elseif MyLevel <= 549 then
            CurrentQuest = {Mon = "Royal Squad", LevelQuest = 1, NameQuest = "SkyExp2Quest", NameMon = "Royal Squad", CFrameQuest = CFrame.new(-7906.81, 5634.66, -1411.99), CFrameMon = CFrame.new(-7624.25, 5658.13, -1467.35)}
        elseif MyLevel <= 624 then
            CurrentQuest = {Mon = "Royal Soldier", LevelQuest = 2, NameQuest = "SkyExp2Quest", NameMon = "Royal Soldier", CFrameQuest = CFrame.new(-7906.81, 5634.66, -1411.99), CFrameMon = CFrame.new(-7836.75, 5645.66, -1790.62)}
        elseif MyLevel <= 649 then
            CurrentQuest = {Mon = "Galley Pirate", LevelQuest = 1, NameQuest = "FountainQuest", NameMon = "Galley Pirate", CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02), CFrameMon = CFrame.new(5551.02, 78.90, 3930.41)}
        else
            CurrentQuest = {Mon = "Galley Captain", LevelQuest = 2, NameQuest = "FountainQuest", NameMon = "Galley Captain", CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02), CFrameMon = CFrame.new(5441.95, 42.50, 4950.09)}
        end
    elseif World2 then
        if MyLevel <= 724 then
            CurrentQuest = {Mon = "Raider", LevelQuest = 1, NameQuest = "Area1Quest", NameMon = "Raider", CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18), CFrameMon = CFrame.new(-728.32, 52.77, 2345.77)}
        elseif MyLevel <= 774 then
            CurrentQuest = {Mon = "Mercenary", LevelQuest = 2, NameQuest = "Area1Quest", NameMon = "Mercenary", CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18), CFrameMon = CFrame.new(-1004.32, 80.15, 1424.61)}
        elseif MyLevel <= 799 then
            CurrentQuest = {Mon = "Swan Pirate", LevelQuest = 1, NameQuest = "Area2Quest", NameMon = "Swan Pirate", CFrameQuest = CFrame.new(638.43, 71.76, 918.28), CFrameMon = CFrame.new(1068.66, 137.61, 1322.10)}
        elseif MyLevel <= 874 then
            CurrentQuest = {Mon = "Factory Staff", LevelQuest = 2, NameQuest = "Area2Quest", NameMon = "Factory Staff", CFrameQuest = CFrame.new(632.69, 73.10, 918.66), CFrameMon = CFrame.new(73.07, 81.86, -27.47)}
        elseif MyLevel <= 899 then
            CurrentQuest = {Mon = "Marine Lieutenant", LevelQuest = 1, NameQuest = "MarineQuest3", NameMon = "Marine Lieutenant", CFrameQuest = CFrame.new(-2440.79, 71.71, -3216.06), CFrameMon = CFrame.new(-2821.37, 75.89, -3070.08)}
        elseif MyLevel <= 949 then
            CurrentQuest = {Mon = "Marine Captain", LevelQuest = 2, NameQuest = "MarineQuest3", NameMon = "Marine Captain", CFrameQuest = CFrame.new(-2440.79, 71.71, -3216.06), CFrameMon = CFrame.new(-1861.23, 80.17, -3254.69)}
        elseif MyLevel <= 974 then
            CurrentQuest = {Mon = "Zombie", LevelQuest = 1, NameQuest = "ZombieQuest", NameMon = "Zombie", CFrameQuest = CFrame.new(-5497.06, 47.59, -795.23), CFrameMon = CFrame.new(-5657.77, 78.96, -928.68)}
        elseif MyLevel <= 999 then
            CurrentQuest = {Mon = "Vampire", LevelQuest = 2, NameQuest = "ZombieQuest", NameMon = "Vampire", CFrameQuest = CFrame.new(-5497.06, 47.59, -795.23), CFrameMon = CFrame.new(-6037.66, 32.18, -1340.65)}
        elseif MyLevel <= 1049 then
            CurrentQuest = {Mon = "Snow Trooper", LevelQuest = 1, NameQuest = "SnowMountainQuest", NameMon = "Snow Trooper", CFrameQuest = CFrame.new(609.85, 400.11, -5372.25), CFrameMon = CFrame.new(549.14, 427.38, -5563.69)}
        elseif MyLevel <= 1099 then
            CurrentQuest = {Mon = "Winter Warrior", LevelQuest = 2, NameQuest = "SnowMountainQuest", NameMon = "Winter Warrior", CFrameQuest = CFrame.new(609.85, 400.11, -5372.25), CFrameMon = CFrame.new(1142.74, 475.63, -5199.41)}
        elseif MyLevel <= 1124 then
            CurrentQuest = {Mon = "Lab Subordinate", LevelQuest = 1, NameQuest = "IceSideQuest", NameMon = "Lab Subordinate", CFrameQuest = CFrame.new(-6064.06, 15.24, -4902.97), CFrameMon = CFrame.new(-5707.47, 15.95, -4513.39)}
        elseif MyLevel <= 1174 then
            CurrentQuest = {Mon = "Horned Warrior", LevelQuest = 2, NameQuest = "IceSideQuest", NameMon = "Horned Warrior", CFrameQuest = CFrame.new(-6064.06, 15.24, -4902.97), CFrameMon = CFrame.new(-6341.36, 15.95, -5723.16)}
        elseif MyLevel <= 1199 then
            CurrentQuest = {Mon = "Magma Ninja", LevelQuest = 1, NameQuest = "FireSideQuest", NameMon = "Magma Ninja", CFrameQuest = CFrame.new(-5428.03, 15.06, -5299.43), CFrameMon = CFrame.new(-5449.67, 76.65, -5808.20)}
        elseif MyLevel <= 1249 then
            CurrentQuest = {Mon = "Lava Pirate", LevelQuest = 2, NameQuest = "FireSideQuest", NameMon = "Lava Pirate", CFrameQuest = CFrame.new(-5428.03, 15.06, -5299.43), CFrameMon = CFrame.new(-5213.33, 49.73, -4701.45)}
        elseif MyLevel <= 1274 then
            CurrentQuest = {Mon = "Ship Deckhand", LevelQuest = 1, NameQuest = "ShipQuest1", NameMon = "Ship Deckhand", CFrameQuest = CFrame.new(1037.80, 125.09, 32911.60), CFrameMon = CFrame.new(1212.01, 150.79, 33059.24)}
        elseif MyLevel <= 1299 then
            CurrentQuest = {Mon = "Ship Engineer", LevelQuest = 2, NameQuest = "ShipQuest1", NameMon = "Ship Engineer", CFrameQuest = CFrame.new(1037.80, 125.09, 32911.60), CFrameMon = CFrame.new(919.47, 43.54, 32779.96)}
        elseif MyLevel <= 1324 then
            CurrentQuest = {Mon = "Ship Steward", LevelQuest = 1, NameQuest = "ShipQuest2", NameMon = "Ship Steward", CFrameQuest = CFrame.new(968.80, 125.09, 33244.12), CFrameMon = CFrame.new(919.43, 129.55, 33436.03)}
        elseif MyLevel <= 1349 then
            CurrentQuest = {Mon = "Ship Officer", LevelQuest = 2, NameQuest = "ShipQuest2", NameMon = "Ship Officer", CFrameQuest = CFrame.new(968.80, 125.09, 33244.12), CFrameMon = CFrame.new(1036.01, 181.43, 33315.72)}
        elseif MyLevel <= 1374 then
            CurrentQuest = {Mon = "Arctic Warrior", LevelQuest = 1, NameQuest = "FrostQuest", NameMon = "Arctic Warrior", CFrameQuest = CFrame.new(5667.65, 26.79, -6486.08), CFrameMon = CFrame.new(5966.24, 62.97, -6179.38)}
        elseif MyLevel <= 1424 then
            CurrentQuest = {Mon = "Snow Lurker", LevelQuest = 2, NameQuest = "FrostQuest", NameMon = "Snow Lurker", CFrameQuest = CFrame.new(5667.65, 26.79, -6486.08), CFrameMon = CFrame.new(5407.07, 69.19, -6880.88)}
        elseif MyLevel <= 1449 then
            CurrentQuest = {Mon = "Sea Soldier", LevelQuest = 1, NameQuest = "ForgottenQuest", NameMon = "Sea Soldier", CFrameQuest = CFrame.new(-3054.44, 235.54, -10142.81), CFrameMon = CFrame.new(-3028.22, 64.67, -9775.42)}
        else
            CurrentQuest = {Mon = "Water Fighter", LevelQuest = 2, NameQuest = "ForgottenQuest", NameMon = "Water Fighter", CFrameQuest = CFrame.new(-3054.44, 235.54, -10142.81), CFrameMon = CFrame.new(-3352.90, 285.01, -10534.84)}
        end
    elseif World3 then
        if MyLevel <= 1524 then
            CurrentQuest = {Mon = "Pirate Millionaire", LevelQuest = 1, NameQuest = "PiratePortQuest", NameMon = "Pirate Millionaire", CFrameQuest = CFrame.new(-290.07, 42.90, 5581.58), CFrameMon = CFrame.new(-245.99, 47.30, 5584.10)}
        elseif MyLevel <= 1574 then
            CurrentQuest = {Mon = "Pistol Billionaire", LevelQuest = 2, NameQuest = "PiratePortQuest", NameMon = "Pistol Billionaire", CFrameQuest = CFrame.new(-290.07, 42.90, 5581.58), CFrameMon = CFrame.new(-187.33, 86.23, 6013.51)}
        elseif MyLevel <= 1599 then
            CurrentQuest = {Mon = "Dragon Crew Warrior", LevelQuest = 1, NameQuest = "AmazonQuest", NameMon = "Dragon Crew Warrior", CFrameQuest = CFrame.new(5832.83, 51.68, -1101.51), CFrameMon = CFrame.new(6141.14, 51.35, -1340.73)}
        elseif MyLevel <= 1624 then
            CurrentQuest = {Mon = "Dragon Crew Archer", LevelQuest = 2, NameQuest = "AmazonQuest", NameMon = "Dragon Crew Archer", CFrameQuest = CFrame.new(5833.11, 51.60, -1103.06), CFrameMon = CFrame.new(6616.41, 441.76, 446.04)}
        elseif MyLevel <= 1649 then
            CurrentQuest = {Mon = "Female Islander", LevelQuest = 1, NameQuest = "AmazonQuest2", NameMon = "Female Islander", CFrameQuest = CFrame.new(5446.87, 601.62, 749.45), CFrameMon = CFrame.new(4685.25, 735.80, 815.34)}
        elseif MyLevel <= 1699 then
            CurrentQuest = {Mon = "Giant Islander", LevelQuest = 2, NameQuest = "AmazonQuest2", NameMon = "Giant Islander", CFrameQuest = CFrame.new(5446.87, 601.62, 749.45), CFrameMon = CFrame.new(4729.09, 590.43, -36.97)}
        elseif MyLevel <= 1724 then
            CurrentQuest = {Mon = "Marine Commodore", LevelQuest = 1, NameQuest = "MarineTreeIsland", NameMon = "Marine Commodore", CFrameQuest = CFrame.new(2180.54, 27.81, -6741.54), CFrameMon = CFrame.new(2286.00, 73.13, -7159.80)}
        elseif MyLevel <= 1774 then
            CurrentQuest = {Mon = "Marine Rear Admiral", LevelQuest = 2, NameQuest = "MarineTreeIsland", NameMon = "Marine Rear Admiral", CFrameQuest = CFrame.new(2179.98, 28.73, -6740.05), CFrameMon = CFrame.new(3656.77, 160.52, -7001.59)}
        elseif MyLevel <= 1799 then
            CurrentQuest = {Mon = "Fishman Raider", LevelQuest = 1, NameQuest = "DeepForestIsland3", NameMon = "Fishman Raider", CFrameQuest = CFrame.new(-10581.65, 330.87, -8761.18), CFrameMon = CFrame.new(-10407.52, 331.76, -8368.51)}
        elseif MyLevel <= 1824 then
            CurrentQuest = {Mon = "Fishman Captain", LevelQuest = 2, NameQuest = "DeepForestIsland3", NameMon = "Fishman Captain", CFrameQuest = CFrame.new(-10581.65, 330.87, -8761.18), CFrameMon = CFrame.new(-10994.70, 352.38, -9002.11)}
        elseif MyLevel <= 1849 then
            CurrentQuest = {Mon = "Forest Pirate", LevelQuest = 1, NameQuest = "DeepForestIsland", NameMon = "Forest Pirate", CFrameQuest = CFrame.new(-13234.04, 331.48, -7625.40), CFrameMon = CFrame.new(-13274.47, 332.37, -7769.58)}
        elseif MyLevel <= 1899 then
            CurrentQuest = {Mon = "Mythological Pirate", LevelQuest = 2, NameQuest = "DeepForestIsland", NameMon = "Mythological Pirate", CFrameQuest = CFrame.new(-13234.04, 331.48, -7625.40), CFrameMon = CFrame.new(-13680.60, 501.08, -6991.18)}
        elseif MyLevel <= 1924 then
            CurrentQuest = {Mon = "Jungle Pirate", LevelQuest = 1, NameQuest = "DeepForestIsland2", NameMon = "Jungle Pirate", CFrameQuest = CFrame.new(-12680.38, 389.97, -9902.01), CFrameMon = CFrame.new(-12256.16, 331.73, -10485.83)}
        elseif MyLevel <= 1974 then
            CurrentQuest = {Mon = "Musketeer Pirate", LevelQuest = 2, NameQuest = "DeepForestIsland2", NameMon = "Musketeer Pirate", CFrameQuest = CFrame.new(-12680.38, 389.97, -9902.01), CFrameMon = CFrame.new(-13457.90, 391.54, -9859.17)}
        elseif MyLevel <= 1999 then
            CurrentQuest = {Mon = "Reborn Skeleton", LevelQuest = 1, NameQuest = "HauntedQuest1", NameMon = "Reborn Skeleton", CFrameQuest = CFrame.new(-9479.21, 141.21, 5566.09), CFrameMon = CFrame.new(-8763.72, 165.72, 6159.86)}
        elseif MyLevel <= 2024 then
            CurrentQuest = {Mon = "Living Zombie", LevelQuest = 2, NameQuest = "HauntedQuest1", NameMon = "Living Zombie", CFrameQuest = CFrame.new(-9479.21, 141.21, 5566.09), CFrameMon = CFrame.new(-10144.13, 138.62, 5838.08)}
        elseif MyLevel <= 2049 then
            CurrentQuest = {Mon = "Demonic Soul", LevelQuest = 1, NameQuest = "HauntedQuest2", NameMon = "Demonic Soul", CFrameQuest = CFrame.new(-9516.99, 172.01, 6078.46), CFrameMon = CFrame.new(-9505.87, 172.10, 6158.99)}
        elseif MyLevel <= 2074 then
            CurrentQuest = {Mon = "Posessed Mummy", LevelQuest = 2, NameQuest = "HauntedQuest2", NameMon = "Posessed Mummy", CFrameQuest = CFrame.new(-9516.99, 172.01, 6078.46), CFrameMon = CFrame.new(-9582.02, 6.25, 6205.47)}
        elseif MyLevel <= 2099 then
            CurrentQuest = {Mon = "Peanut Scout", LevelQuest = 1, NameQuest = "NutsIslandQuest", NameMon = "Peanut Scout", CFrameQuest = CFrame.new(-2104.39, 38.10, -10194.21), CFrameMon = CFrame.new(-2143.24, 47.72, -10029.99)}
        elseif MyLevel <= 2124 then
            CurrentQuest = {Mon = "Peanut President", LevelQuest = 2, NameQuest = "NutsIslandQuest", NameMon = "Peanut President", CFrameQuest = CFrame.new(-2104.39, 38.10, -10194.21), CFrameMon = CFrame.new(-1859.35, 38.10, -10422.42)}
        elseif MyLevel <= 2149 then
            CurrentQuest = {Mon = "Ice Cream Chef", LevelQuest = 1, NameQuest = "IceCreamIslandQuest", NameMon = "Ice Cream Chef", CFrameQuest = CFrame.new(-820.64, 65.81, -10965.79), CFrameMon = CFrame.new(-872.24, 65.81, -10919.95)}
        elseif MyLevel <= 2199 then
            CurrentQuest = {Mon = "Ice Cream Commander", LevelQuest = 2, NameQuest = "IceCreamIslandQuest", NameMon = "Ice Cream Commander", CFrameQuest = CFrame.new(-820.64, 65.81, -10965.79), CFrameMon = CFrame.new(-558.06, 112.04, -11290.77)}
        elseif MyLevel <= 2224 then
            CurrentQuest = {Mon = "Cookie Crafter", LevelQuest = 1, NameQuest = "CakeQuest1", NameMon = "Cookie Crafter", CFrameQuest = CFrame.new(-2021.32, 37.79, -12028.72), CFrameMon = CFrame.new(-2374.13, 37.79, -12125.30)}
        elseif MyLevel <= 2249 then
            CurrentQuest = {Mon = "Cake Guard", LevelQuest = 2, NameQuest = "CakeQuest1", NameMon = "Cake Guard", CFrameQuest = CFrame.new(-2021.32, 37.79, -12028.72), CFrameMon = CFrame.new(-1598.30, 43.77, -12244.58)}
        elseif MyLevel <= 2274 then
            CurrentQuest = {Mon = "Baking Staff", LevelQuest = 1, NameQuest = "CakeQuest2", NameMon = "Baking Staff", CFrameQuest = CFrame.new(-1927.91, 37.79, -12842.53), CFrameMon = CFrame.new(-1887.80, 77.61, -12998.35)}
        elseif MyLevel <= 2299 then
            CurrentQuest = {Mon = "Head Baker", LevelQuest = 2, NameQuest = "CakeQuest2", NameMon = "Head Baker", CFrameQuest = CFrame.new(-1927.91, 37.79, -12842.53), CFrameMon = CFrame.new(-2216.18, 82.88, -12869.29)}
        elseif MyLevel <= 2324 then
            CurrentQuest = {Mon = "Cocoa Warrior", LevelQuest = 1, NameQuest = "ChocQuest1", NameMon = "Cocoa Warrior", CFrameQuest = CFrame.new(233.22, 29.87, -12201.23), CFrameMon = CFrame.new(-21.55, 80.57, -12352.38)}
        elseif MyLevel <= 2349 then
            CurrentQuest = {Mon = "Chocolate Bar Battler", LevelQuest = 2, NameQuest = "ChocQuest1", NameMon = "Chocolate Bar Battler", CFrameQuest = CFrame.new(233.22, 29.87, -12201.23), CFrameMon = CFrame.new(582.59, 77.18, -12463.16)}
        elseif MyLevel <= 2374 then
            CurrentQuest = {Mon = "Sweet Thief", LevelQuest = 1, NameQuest = "ChocQuest2", NameMon = "Sweet Thief", CFrameQuest = CFrame.new(150.50, 30.69, -12774.50), CFrameMon = CFrame.new(165.18, 76.05, -12600.83)}
        elseif MyLevel <= 2399 then
            CurrentQuest = {Mon = "Candy Rebel", LevelQuest = 2, NameQuest = "ChocQuest2", NameMon = "Candy Rebel", CFrameQuest = CFrame.new(150.50, 30.69, -12774.50), CFrameMon = CFrame.new(134.86, 77.24, -12876.54)}
        elseif MyLevel <= 2424 then
            CurrentQuest = {Mon = "Candy Pirate", LevelQuest = 1, NameQuest = "CandyQuest1", NameMon = "Candy Pirate", CFrameQuest = CFrame.new(-1150.04, 20.37, -14446.33), CFrameMon = CFrame.new(-1310.50, 26.01, -14562.40)}
        elseif MyLevel <= 2449 then
            CurrentQuest = {Mon = "Snow Demon", LevelQuest = 2, NameQuest = "CandyQuest1", NameMon = "Snow Demon", CFrameQuest = CFrame.new(-1150.04, 20.37, -14446.33), CFrameMon = CFrame.new(-880.20, 71.24, -14538.60)}
        elseif MyLevel <= 2474 then
            CurrentQuest = {Mon = "Isle Outlaw", LevelQuest = 1, NameQuest = "TikiQuest1", NameMon = "Isle Outlaw", CFrameQuest = CFrame.new(-16547.74, 61.13, -173.41), CFrameMon = CFrame.new(-16442.81, 116.13, -264.46)}
        elseif MyLevel <= 2524 then
            CurrentQuest = {Mon = "Island Boy", LevelQuest = 2, NameQuest = "TikiQuest1", NameMon = "Island Boy", CFrameQuest = CFrame.new(-16547.74, 61.13, -173.41), CFrameMon = CFrame.new(-16901.26, 84.06, -192.88)}
        else
            CurrentQuest = {Mon = "Skull Slayer", LevelQuest = 2, NameQuest = "TikiQuest3", NameMon = "Skull Slayer", CFrameQuest = CFrame.new(-16661.89, 105.28, 1576.69), CFrameMon = CFrame.new(-16885.20, 114.12, 1627.94)}
        end
    end
end

local FullIslandLocations = {
    Sea1 = {
        ["Windmill"] = CFrame.new(979.79, 16.51, 1429.04),
        ["Jungle"] = CFrame.new(-1612.79, 36.85, 149.12),
        ["Pirate Village"] = CFrame.new(-1181.30, 4.75, 3803.54),
        ["Desert"] = CFrame.new(944.15, 20.91, 4373.30),
        ["Snow Island"] = CFrame.new(1347.80, 104.66, -1319.73),
        ["Marineford"] = CFrame.new(-4914.82, 50.96, 4281.02),
        ["Colosseum"] = CFrame.new(-1427.62, 7.28, -2792.77),
        ["Sky Island"] = CFrame.new(-4869.10, 733.46, -2667.01),
        ["Prison"] = CFrame.new(4875.33, 5.65, 734.85),
        ["Magma Village"] = CFrame.new(-5247.71, 12.88, 8504.96),
        ["Fountain City"] = CFrame.new(5259.81, 37.35, 4050.02),
    },
    Sea2 = {
        ["Cafe"] = CFrame.new(-380.47, 77.22, 255.82),
        ["Green Zone"] = CFrame.new(-2448.53, 73.01, -3210.63),
        ["Cursed Ship"] = CFrame.new(923.40, 125.05, 32885.87),
        ["Ice Castle"] = CFrame.new(6148.41, 294.38, -6741.11),
        ["Hot & Cold"] = CFrame.new(-5428.03, 15.06, -5299.43),
        ["Snow Mountain"] = CFrame.new(609.85, 400.11, -5372.25),
        ["Graveyard"] = CFrame.new(-5497.06, 47.59, -795.23),
        ["Factory"] = CFrame.new(632.69, 73.10, 918.66),
        ["Colosseum Sea 2"] = CFrame.new(-1580.04, 6.35, -2986.47),
        ["Dark Arena"] = CFrame.new(1000, 100, 1000),
    },
    Sea3 = {
        ["Mansion"] = CFrame.new(-12471.16, 374.94, -7551.67),
        ["Port Town"] = CFrame.new(-290.73, 6.72, 5343.55),
        ["Hydra Island"] = CFrame.new(5291.24, 1005.44, 393.76),
        ["Floating Turtle"] = CFrame.new(-13274.52, 531.82, -7579.22),
        ["Haunted Castle"] = CFrame.new(-9515.37, 164.00, 5786.06),
        ["Tiki Outpost"] = CFrame.new(-16218.68, 9.08, 445.61),
        ["Great Tree"] = CFrame.new(2180.54, 27.81, -6741.54),
        ["Castle on the Sea"] = CFrame.new(-5039.58, 27.35, 4324.68),
        ["Cake Land"] = CFrame.new(-2021.32, 37.79, -12028.72),
        ["Peanut Island"] = CFrame.new(-2104.39, 38.10, -10194.21),
    }
}

local DungeonChips = {
    "Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Dough"
}

local BossList = (World1 and {
    "The Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral",
    "Saber Expert", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord",
    "Wysper", "Thunder God", "Cyborg", "Ice Admiral", "Greybeard", "Darkbeard"
}) or (World2 and {
    "Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral",
    "Tide Keeper", "Darkbeard", "Cursed Captain", "Order"
}) or (World3 and {
    "Stone", "Hydra Leader", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate",
    "Cake Queen", "Longma", "Soul Reaper", "Dough King", "Katakuri", "Island Boy"
})

local MaterialList = (World1 and {
    "Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail", "Wood Planks"
}) or (World2 and {
    "Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet",
    "Magma Ore", "Vampire Fang"
}) or (World3 and {
    "Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder",
    "Fish Tail", "Mini Tusk", "Azure Ember"
})

local MobSpecificTeleports = {
    ["Darkbeard"] = CFrame.new(1000, 100, 1000),
    ["Longma"] = CFrame.new(-13510, 584, -6987),
    ["Terrorshark"] = CFrame.new(-40000, 30, -2000),
    ["Leviathan"] = CFrame.new(-148073.35, 9.00, 7721.05),
    ["Tide Keeper"] = CFrame.new(6148.41, 294.38, -6741.11),
    ["Thunder God"] = CFrame.new(-4869.10, 733.46, -2667.01),
    ["Don Swan"] = CFrame.new(638.43, 71.76, 918.28),
    ["Cursed Captain"] = CFrame.new(923.40, 125.05, 32885.87),
    ["Order"] = CFrame.new(-408.09, 16.04, 247.43),
    ["Indra"] = CFrame.new(-12471.16, 374.94, -7551.67),
    ["Kitsune Island"] = CFrame.new(-16526, 108, 752),
    ["Mirage Island"] = CFrame.new(29221.82, 14890.97, -205.99),
    ["Prehistoric Island"] = CFrame.new(-16471, 528, 539),
    ["Island Boy"] = CFrame.new(-16901.26, 84.06, -192.88),
}

local ZoneCFrames = {
    ["Zone 1"] = CFrame.new(-21998.37, 30.00, -682.30),
    ["Zone 2"] = CFrame.new(-26779.52, 30.00, -822.85),
    ["Zone 3"] = CFrame.new(-31171.95, 30.00, -2256.93),
    ["Zone 4"] = CFrame.new(-34054.68, 30.21, -2560.12),
    ["Zone 5"] = CFrame.new(-38887.55, 30.00, -2162.99),
    ["Zone 6"] = CFrame.new(-44541.76, 30.00, -1244.85),
    ["Infinite"] = CFrame.new(-148073.35, 9.00, 7721.05)
}

local function GetMaterialConfig(mat: string): ({string}, CFrame)
    if mat == "Radioactive Material" and World2 then return {"Factory Staff"}, CFrame.new(-507.78, 72.99, -126.45)
    elseif mat == "Mystic Droplet" and World2 then return {"Water Fighter"}, CFrame.new(-3352.90, 285.01, -10534.84)
    elseif mat == "Magma Ore" and World1 then return {"Military Spy"}, CFrame.new(-5850.28, 77.28, 8848.67)
    elseif mat == "Magma Ore" and World2 then return {"Lava Pirate"}, CFrame.new(-5234.60, 51.95, -4732.27)
    elseif mat == "Angel Wings" and World1 then return {"Royal Soldier"}, CFrame.new(-7827.15, 5606.91, -1705.58)
    elseif mat == "Leather + Scrap Metal" and World1 then return {"Pirate", "Brute"}, CFrame.new(-1211.87, 4.78, 3916.83)
    elseif mat == "Leather + Scrap Metal" and World2 then return {"Marine Captain", "Mercenary"}, CFrame.new(-2010.50, 73.00, -3326.62)
    elseif mat == "Scrap Metal" and World3 then return {"Pirate Millionaire"}, CFrame.new(-289.63, 43.82, 5583.66)
    elseif mat == "Ectoplasm" and World2 then return {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"}, CFrame.new(911.35, 125.95, 33159.53)
    elseif mat == "Conjured Cocoa" and World3 then return {"Chocolate Bar Battler"}, CFrame.new(744.79, 24.76, -12637.72)
    elseif mat == "Dragon Scale" and World3 then return {"Dragon Crew Warrior"}, CFrame.new(5824.06, 51.38, -1106.69)
    elseif mat == "Gunpowder" and World3 then return {"Pistol Billionaire"}, CFrame.new(-379.61, 73.84, 5928.52)
    elseif mat == "Fish Tail" and World3 then return {"Fishman Captain"}, CFrame.new(-10961.01, 331.79, -8914.29)
    elseif mat == "Mini Tusk" and World3 then return {"Mythological Pirate"}, CFrame.new(-13516.04, 469.81, -6899.16)
    elseif mat == "Vampire Fang" and World2 then return {"Vampire"}, CFrame.new(-6037.66, 32.18, -1340.65)
    elseif mat == "Demonic Wisp" and World3 then return {"Demonic Soul"}, CFrame.new(-9579, 6, 6194)
    elseif mat == "Wood Planks" and World3 then return {"Tree"}, CFrame.new(-16471, 528, 539)
    elseif mat == "Azure Ember" and World3 then return {"Kitsune Shrine"}, CFrame.new(-16526, 108, 752)
    end
    return {}, CFrame.new(0,0,0)
end

--------------------------------------------------------------------------------
-- 6. دمج واجهة AetherUI والتابات الكاملة
--------------------------------------------------------------------------------
local AetherUI = nil
local success_ui, err_ui = pcall(function()
    AetherUI = loadstring(game:HttpGet("https://pastebin.com/raw/yeULgMe0"))()
end)

if not success_ui or not AetherUI then
    warn("Haroon Hub: Failed to load AetherUI library. Error:", err_ui)
    return
end

AetherUI:InitLoadingScreen("Haroon Hub V12 Ultimate Master Edition", "Initializing Fruits, Raids & Safe Motors...", function()
    AetherUI:InitKeySystem({"HAROON-2025-VIP", "HAROON-KEY-100"}, function()
        AetherUI:Notify({Title = "🔥 Haroon Hub V12 Active", Content = "تم دمج مكتبتك بالنظام الجديد بنجاح 100%!", Duration = 4})

        local Window = AetherUI:CreateWindow({
            Title = "Haroon Hub | Blox Fruits Master",
            Subtitle = "by: 3amek4222",
            ToggleKey = Enum.KeyCode.RightControl
        })

        local MainTab = Window:CreateTab("Main", "rbxassetid://6034287594")
        local CombatTab = Window:CreateTab("Combat", "rbxassetid://6034834832")
        local FruitsTab = Window:CreateTab("Fruits Tab", "rbxassetid://6034453535")
        local RaidTab = Window:CreateTab("Dungeon / Raid", "rbxassetid://6034834832")
        local FarmingQuestsTab = Window:CreateTab("Farming Quests", "rbxassetid://6034453535")
        local RaceTab = Window:CreateTab("Race V4 & Mirage", "rbxassetid://6034453535")
        local SubFarmTab = Window:CreateTab("Sub Farming", "rbxassetid://6034834832")
        local CakeTab = Window:CreateTab("Cake & Dough", "rbxassetid://6034453535")
        local SeaTab = Window:CreateTab("Sea Farming", "rbxassetid://6034453535")
        local AutoQuestsTab = Window:CreateTab("Auto Quests", "rbxassetid://6034453535")
        local TeleportsTab = Window:CreateTab("Teleports", "rbxassetid://6034453535")
        local VisualTab = Window:CreateTab("Visuals & ESP", "rbxassetid://6034453535")
        local MiscTab = Window:CreateTab("Misc", "rbxassetid://6031280882")
        local SettingsTab = Window:CreateTab("Settings", "rbxassetid://6031280882")

        ---------------------------------------------------------
        -- 📌 1. TAB: MAIN
        ---------------------------------------------------------
        MainTab:CreateSection("خيارات التلفيل الأساسية (Level Farm)")

        MainTab:CreateToggle("تفعيل التجميع التلقائي (Auto Farm Level)", "AutoFarmFlag", false, function(state)
            _G.Settings.Main["Auto Farm Level"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateToggle("تضمين مهمات الزعماء بالتلفيل (Include Bosses)", "IncludeBossQuestFlag", false, function(state)
            _G.Settings.Main["Include Boss Quests"] = state
        end)

        MainTab:CreateDropdown("اختر السلاح الفعال (Weapon)", "WeaponFlag", {"Melee", "Sword", "Blox Fruit", "Gun"}, "Melee", function(selected)
            _G.Settings.Main["Select Weapon"] = selected
        end)

        MainTab:CreateSlider("ارتفاع الطيران فوق العدو (Farm Distance)", "FarmDistFlag", 10, 50, 28, function(val)
            _G.Settings.Main["Farm Distance"] = val
        end)

        MainTab:CreateSlider("سرعة الانتقال الآمنة (Safe Tween Speed)", "TweenSpeedFlag", 100, 300, 180, function(val)
            _G.Settings.Main["Player Tween Speed"] = val
        end)

        MainTab:CreateToggle("الضرب السريع الخارق (Fast Attack)", "FastAttackFlag", false, function(state)
            _G.Settings.Main["Fast Attack"] = state
        end)

        MainTab:CreateSection("تجميع الماتيريال (Auto Farm Materials)")

        MainTab:CreateDropdown("اختر الماتيريال (Select Material)", "MatDropdownFlag", MaterialList, MaterialList[1], function(selected)
            _G.Settings.Main["Selected Material"] = selected
        end)

        MainTab:CreateToggle("تفعيل تجميع الماتيريال (Farm Material)", "FarmMatFlag", false, function(state)
            _G.Settings.Main["Auto Farm Material"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateSection("قتل الزعماء (Auto Farm Bosses)")

        MainTab:CreateDropdown("اختر البوس (Select Boss)", "BossDropdownFlag", BossList, BossList[1], function(selected)
            _G.Settings.Main["Selected Boss"] = selected
        end)

        MainTab:CreateToggle("تفعيل قتل البوس المحدد (Auto Farm Boss)", "FarmBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm Boss"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateToggle("تفعيل قتل جميع البوسات المتوفرة (Farm All Bosses)", "FarmAllBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm All Boss"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 2. TAB: COMBAT (PVP)
        ---------------------------------------------------------
        CombatTab:CreateSection("قتال اللاعبين والـ PVP")

        local playerList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(playerList, p.Name) end
        end

        CombatTab:CreateDropdown("اختر اللاعب المستهدف", "PVPPlayerDropdown", playerList, playerList[1] or "None", function(selected)
            _G.Settings.Combat["Selected Player"] = selected
        end)

        CombatTab:CreateToggle("مراقبة اللاعب (Spectate Player)", "SpectateFlag", false, function(state)
            _G.Settings.Combat["Spectate Player"] = state
            if state and _G.Settings.Combat["Selected Player"] then
                local target = Players:FindFirstChild(_G.Settings.Combat["Selected Player"])
                if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                    workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
                end
            else
                local char, hum = GetCharacter()
                if char and hum then
                    workspace.CurrentCamera.CameraSubject = hum
                end
            end
        end)

        CombatTab:CreateToggle("الانتقال إلى اللاعب (Teleport To Player)", "TPPlayerFlag", false, function(state)
            _G.Settings.Combat["Teleport To Player"] = state
            if not state then StopTween() end
            task.spawn(function()
                while _G.Settings.Combat["Teleport To Player"] do
                    task.wait()
                    pcall(function()
                        local target = Players:FindFirstChild(_G.Settings.Combat["Selected Player"])
                        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            TweenPlayer(target.Character.HumanoidRootPart.CFrame)
                        end
                    end)
                end
            end)
        end)

        CombatTab:CreateToggle("تصويب المسدسات التلقائي (Aimbot Gun)", "AimbotGunFlag", false, function(state)
            _G.Settings.Combat["Aimbot Gun"] = state
        end)

        CombatTab:CreateSection("خيارات الهروب والعودة في الـ PVP")
        CombatTab:CreateToggle("تفعيل الهروب والعودة التلقائي (Auto PvP Escape)", "AutoPvPEscapeFlag", false, function(state)
            _G.Settings.Combat["Auto PvP Escape"] = state
            if not state then StopTween() end
        end)
        CombatTab:CreateSlider("نسبة HP للهروب (Escape HP %)", "EscapeHPSlider", 10, 90, 30, function(val)
            _G.Settings.Combat["Escape HP %"] = val
        end)
        CombatTab:CreateSlider("نسبة HP للعودة (Return HP %)", "ReturnHPSlider", 20, 100, 70, function(val)
            _G.Settings.Combat["Return HP %"] = val
        end)

        ---------------------------------------------------------
        -- 📌 3. TAB: FRUITS TAB
        ---------------------------------------------------------
        FruitsTab:CreateSection("نظام الفواكه والتخزين (Blox Fruits Engine)")
        
        FruitsTab:CreateToggle("🍎 Fruit Notifier (ESP)", "FruitESPFlag", false, function(state)
            _G.Settings.Fruits["Fruit ESP"] = state
            _G.Settings.Visuals["ESP Fruits"] = state
        end)

        FruitsTab:CreateToggle("🏃 Fruit Sniper (Auto-Collect)", "FruitSniperFlag", false, function(state)
            _G.Settings.Fruits["Fruit Sniper"] = state
            if not state then StopTween() end
        end)

        FruitsTab:CreateToggle("🔄 Auto-Store Fruit", "AutoStoreFruitFlag", false, function(state)
            _G.Settings.Fruits["Auto Store Fruit"] = state
        end)

        FruitsTab:CreateButton("🗺️ Show All Fruit Locations", function()
            _G.Settings.Fruits["Show All Fruits"] = true
            AetherUI:Notify({Title = "Fruits Scanner", Content = "جاري مسح كافة الفواكه على الخريطة...", Duration = 3})
            task.wait(5)
            _G.Settings.Fruits["Show All Fruits"] = false
        end)

        FruitsTab:CreateButton("🛒 Buy Random Fruit (Cousin)", function()
            if CommF_ then
                local res = CommF_:InvokeServer("Cousin", "Buy")
                AetherUI:Notify({Title = "Fruit Dealer", Content = tostring(res), Duration = 4})
            end
        end)

        ---------------------------------------------------------
        -- 📌 4. TAB: DUNGEON / RAID (Auto Next Island المستخرج)
        ---------------------------------------------------------
        RaidTab:CreateSection("نظام الـ Dungeon و غارات الفواكه (Dungeon System)")

        RaidTab:CreateDropdown("Select Raid Chip (اختر شريحة الريد)", "DungeonChipDropdown", DungeonChips, DungeonChips[1], function(selected)
            _G.Settings.Raid["Selected Chip"] = selected
        end)

        RaidTab:CreateToggle("⚡ Auto Dungeon / Fruits Raid (تفعيل الريد)", "AutoDungeonFlag", false, function(state)
            _G.Settings.Raid["Auto Dungeon / Raid"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("🛒 Buy Chip & Start Raid (شراء وبدء تلقائي)", "AutoBuyStartRaidFlag", false, function(state)
            _G.Settings.Raid["Auto Buy Chip & Start"] = state
        end)

        RaidTab:CreateToggle("⚔️ Auto Clear Dungeon Waves (مسح وحوش الريد)", "AutoClearDungeonFlag", false, function(state)
            _G.Settings.Raid["Auto Clear Dungeon Waves"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("🏝️ Auto Next Island (الانتقال للجزيرة التالية تلقائياً)", "AutoNextIslandFlag", false, function(state)
            _G.Settings.Raid["Auto Next Island"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("✨ Auto Awaken Skills (إيقاظ المهارات التلقائي)", "AutoAwakenSkillsFlag", false, function(state)
            _G.Settings.Raid["Auto Awaken"] = state
        end)

        RaidTab:CreateToggle("⚡ Law Raid (ريد لاو التلقائي)", "LawRaidFlag", false, function(state)
            _G.Settings.Raid["Law Raid"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 5. TAB: FARMING QUESTS (CDK & TTK المستخرج بالكامل)
        ---------------------------------------------------------
        FarmingQuestsTab:CreateSection("مهمات السيوف الأسطورية (Legendary Swords)")

        FarmingQuestsTab:CreateDropdown("اختر مهمة السيف", "SwordQuestDropdown", {"Saber V2", "Yama", "Tushita"}, "Saber V2", function(selected)
            _G.Settings.FarmingQuests["Selected Sword Quest"] = selected
        end)

        FarmingQuestsTab:CreateToggle("تفعيل أتمتة مهمة السيف", "AutoSwordQuestFlag", false, function(state)
            _G.Settings.FarmingQuests["Auto Sword Quest"] = state
            if not state then StopTween() end
        end)

        FarmingQuestsTab:CreateSection("مهمات السيوف المدمجة الأسطورية (CDK & TTK Engine)")

        FarmingQuestsTab:CreateToggle("⚔️ أتمتة Cursed Dual Katana بالكامل (Auto CDK)", "AutoFarmCDKFlag", false, function(state)
            _G.Settings.FarmingQuests["Auto Farm CDK"] = state
            if not state then StopTween() end
        end)

        FarmingQuestsTab:CreateToggle("⚔️ أتمتة True Triple Katana بالكامل (Auto TTK)", "AutoFarmTTKFlag", false, function(state)
            _G.Settings.FarmingQuests["Auto Farm TTK"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 6. TAB: RACE V2, V3, V4 & MIRAGE (النظام المستخرج الكامل)
        ---------------------------------------------------------
        RaceTab:CreateSection("ترقية الأجناس (Race V2 & V3 Quests)")

        RaceTab:CreateToggle("🧬 أتمتة مهمة Race V2 (Auto Race V2 Quest)", "AutoRaceV2QuestFlag", false, function(state)
            _G.Settings.Race["Auto Race V2 Quest"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateDropdown("اختر مهمة Race V3", "RaceV3QuestDropdown", {"Human", "Fishman", "Skypian", "Mink", "Ghoul", "Cyborg"}, "Human", function(selected)
            _G.Settings.Race["Selected Race V3"] = selected
        end)

        RaceTab:CreateToggle("🧬 أتمتة مهمة Race V3 (Auto Race V3 Quest)", "AutoRaceV3QuestFlag", false, function(state)
            _G.Settings.Race["Auto Race V3 Quest"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("تفعيل مهارة V3 تلقائياً (Auto Race V3 Ability)", "AutoV3AbilityFlag", false, function(state)
            _G.Settings.Race["Auto Race V3 Ability"] = state
            task.spawn(function()
                while _G.Settings.Race["Auto Race V3 Ability"] do
                    task.wait(1)
                    if CommE then pcall(function() CommE:FireServer("ActivateAbility") end) end
                end
            end)
        end)

        RaceTab:CreateSection("حزمة الميراج و الترس الأزرق (Mirage Island Suite)")

        RaceTab:CreateToggle("🏝️ البحث التلقائي عن Mirage Island والإبحار لها", "AutoFindMirageFlag", false, function(state)
            _G.Settings.Race["Auto Find Mirage"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("🏔️ الانتقال لقمة الميراج (Tween To Highest Mirage)", "TweenMirageFlag", false, function(state)
            _G.Settings.Race["Tween To Highest Mirage"] = state
            if not state then StopTween() end
            task.spawn(function()
                while _G.Settings.Race["Tween To Highest Mirage"] do
                    task.wait()
                    pcall(function()
                        if workspace.Map:FindFirstChild("MysticIsland") then
                            for _, v in pairs(workspace.Map.MysticIsland:GetDescendants()) do
                                if v:IsA("MeshPart") and v.MeshId == "rbxassetid://6745037796" then
                                    TweenPlayer(v.CFrame, Vector3.new(0, 212, 0))
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("⚙️ الانتقال وأخذ الترس الأزرق (Teleport to Gear)", "TeleportToGearFlag", false, function(state)
            _G.Settings.Race["Teleport To Blue Gear"] = state
            if not state then StopTween() end
            task.spawn(function()
                while _G.Settings.Race["Teleport To Blue Gear"] do
                    task.wait(0.2)
                    pcall(function()
                        if workspace.Map:FindFirstChild("MysticIsland") then
                            for _, v in pairs(workspace.Map.MysticIsland:GetChildren()) do
                                if v:IsA("MeshPart") and (v.Material == Enum.Material.Neon or string.find(v.Name:lower(), "gear")) then
                                    TweenPlayer(v.CFrame)
                                    if (LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude < 15 then
                                        if CommF_ then CommF_:InvokeServer("InteractGear", v) end
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("🌕 النظر للقمر وتفعيل المهارة (Look Moon)", "LookMoonFlag", false, function(state)
            _G.Settings.Race["Look Moon Ability"] = state
            task.spawn(function()
                while _G.Settings.Race["Look Moon Ability"] do
                    task.wait()
                    pcall(function()
                        local moonDir = game.Lighting:GetMoonDirection()
                        local lookAtPos = workspace.CurrentCamera.CFrame.p + moonDir * 100
                        workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.p, lookAtPos)
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("🚪 الانتقال لباب الترايل تلقائياً (Teleport To Race Door)", "TPDoorFlag", false, function(state)
            _G.Settings.Race["Teleport To Race Door"] = state
            if not state then StopTween() end
            if state then
                local myRace = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Race")) and LocalPlayer.Data.Race.Value or "Human"
                local raceDoors = {
                    ["Human"] = CFrame.new(29221.82, 14890.97, -205.99),
                    ["Skypian"] = CFrame.new(28960.15, 14919.62, 235.03),
                    ["Fishman"] = CFrame.new(28231.17, 14890.97, -211.64),
                    ["Cyborg"] = CFrame.new(28502.68, 14895.97, -423.72),
                    ["Ghoul"] = CFrame.new(28674.24, 14890.67, 445.43),
                    ["Mink"] = CFrame.new(29012.34, 14890.97, -380.14)
                }
                local char, hrp = GetCharacter()
                if char and hrp then
                    hrp.CFrame = CFrame.new(28286.35, 14895.30, 102.62)
                    task.wait(0.3)
                    if raceDoors[myRace] then TweenPlayer(raceDoors[myRace]) end
                end
            end
        end)

        RaceTab:CreateSection("التدريب واجتياز الترايل (Race V4 Train & Trial)")

        RaceTab:CreateToggle("التدريب التلقائي للـ V4 (Auto Train)", "AutoTrainFlag", false, function(state)
            _G.Settings.Race["Auto Train"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("اجتياز الترايل تلقائياً (Auto Trial)", "AutoTrialFlag", false, function(state)
            _G.Settings.Race["Auto Trial"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 7. TAB: SUB FARMING
        ---------------------------------------------------------
        SubFarmTab:CreateSection("صياد النخبة والعظام (Elite & Bones)")

        SubFarmTab:CreateToggle("صياد النخبة التلقائي (Auto Elite Hunter)", "EliteFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("صياد النخبة مع السيرفر هوب (Elite Hop)", "EliteHopFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter Hop"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("تجميع العظام التلقائي (Auto Farm Bones)", "BoneFlag", false, function(state)
            _G.Settings.SubFarm["Auto Farm Bone"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateSection("تجميع الصناديق التلقائي (Auto Chests)")

        SubFarmTab:CreateToggle("جمع الصناديق بالطيران (Chest Tween)", "ChestTweenFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Tween"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("جمع الصناديق الفوري (Chest Instant)", "ChestInstantFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Instant"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("توقف عند الحصول على دروب نادر (Stop on Items)", "StopItemsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Stop Items"] = state
        end)

        SubFarmTab:CreateSection("تلفيل الماستري التلقائي (Auto Mastery)")

        SubFarmTab:CreateToggle("تلفيل ماستري Melee (لـ 400)", "AutoMasteryMeleeFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Melee"] = state
            if not state then StopTween() end
        end)
        SubFarmTab:CreateToggle("تلفيل ماستري Swords (لـ 400)", "AutoMasterySwordsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Swords"] = state
            if not state then StopTween() end
        end)
        SubFarmTab:CreateToggle("تلفيل ماستري Blox Fruits (لـ 400)", "AutoMasteryBloxFruitsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Blox Fruits"] = state
            if not state then StopTween() end
        end)
        SubFarmTab:CreateToggle("تلفيل ماستري Guns (لـ 400)", "AutoMasteryGunsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Guns"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 8. TAB: CAKE PRINCE & DOUGH KING
        ---------------------------------------------------------
        CakeTab:CreateSection("الكيك برنس و دو كينغ")

        CakeTab:CreateToggle("تلفيل وقتل الكاتكوري بالكامل (Auto Katakuri)", "KatakuriFlag", false, function(state)
            _G.Settings.Cake["Auto Katakuri"] = state
            if not state then StopTween() end
        end)

        CakeTab:CreateToggle("استدعاء الكيك برنس التلقائي (Auto Spawn Prince)", "SpawnPrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Spawn Cake Prince"] = state
        end)

        CakeTab:CreateToggle("قتل الكيك برنس فور ظهوره (Auto Kill Cake Prince)", "KillPrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Cake Prince"] = state
            if not state then StopTween() end
        end)

        CakeTab:CreateToggle("قتل دو كينغ فور ظهوره (Auto Kill Dough King)", "KillDoughFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Dough King"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 9. TAB: SEA FARMING (Prehistoric & Draco Trail)
        ---------------------------------------------------------
        SeaTab:CreateSection("الجزيرة القديمة وما قبل التاريخ (Prehistoric Engine)")

        SeaTab:CreateButton("🏝️ Teleport Prehistoric Island (انتقال فوري)", function()
            TweenPlayer(MobSpecificTeleports["Prehistoric Island"])
            AetherUI:Notify({Title = "Teleport", Content = "جاري الانتقال إلى الجزيرة القديمة...", Duration = 2})
        end)

        SeaTab:CreateToggle("🦖 أتمتة الجزيرة القديمة (Auto Prehistoric Island)", "AutoPrehistoricFlag", false, function(state)
            _G.Settings.Sea["Auto Prehistoric Island"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🔥 إنهاء الجزيرة والشعلات (Auto Complete Prehistoric Island)", "AutoCompletePrehistoricFlag", false, function(state)
            _G.Settings.Sea["Auto Complete Prehistoric Island"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🐉 تدريب دراكو وقهر الوحوش (Auto Draco Trail)", "AutoDracoTrailFlag", false, function(state)
            _G.Settings.Sea["Auto Draco Trail"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateSection("إبحار وأحداث البحر والبحث عن الجزر")

        SeaTab:CreateDropdown("اختر القارب (Select Boat)", "BoatDropdownFlag", {"Guardian", "Beast Hunter", "PirateGrandBrigade", "MarineGrandBrigade"}, "Guardian", function(selected)
            _G.Settings.Sea["Selected Boat"] = selected
        end)

        SeaTab:CreateDropdown("اختر منطقة الإبحار (Select Zone)", "ZoneDropdownFlag", {"Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5", "Zone 6", "Infinite"}, "Zone 5", function(selected)
            _G.Settings.Sea["Selected Zone"] = selected
        end)

        SeaTab:CreateToggle("تفعيل الإبحار التلقائي (Sail Boat)", "SailBoatFlag", false, function(state)
            _G.Settings.Sea["Sail Boat"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateSection("قتال مخلوقات وحوش البحر (Sea Mobs Farming)")

        SeaTab:CreateToggle("🦈 قتل أسماك القرش (Auto Farm Shark)", "SharkFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Shark"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🐟 قتل البيرانا (Auto Farm Piranha)", "PiranhaFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Piranha"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🧜‍♂️ قتل طاقم الأسماك (Fish Crew Member)", "CrewFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Fish Crew Member"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("👻 قتل السفن الشبحية (Ghost Ship)", "GhostShipFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Ghost Ship"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🦖 قتل التيرور شارك (Terrorshark)", "TerrorFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Terrorshark"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🌊 قتل السي بيست (Seabeasts)", "SeabeastFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Seabeasts"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🛡️ تفادي هجمات السي بيست (Dodge Seabeasts)", "DodgeSBFlag", true, function(state)
            _G.Settings.Sea["Dodge Seabeasts Attack"] = state
        end)

        SeaTab:CreateToggle("🦊 البحث التلقائي عن Kitsune Island والإبحار لها", "AutoFindKitsuneIslandFlag", false, function(state)
            _G.Settings.Sea["Auto Find Kitsune Island"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 10. TAB: AUTO QUESTS
        ---------------------------------------------------------
        AutoQuestsTab:CreateSection("أخذ وإنهاء المهمات المباشرة")

        AutoQuestsTab:CreateButton("أخذ مهمة القرود (Jungle Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "JungleQuest", 1) end
        end)
        AutoQuestsTab:CreateButton("أخذ مهمة القراصنة (Buggy Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "BuggyQuest1", 1) end
        end)
        AutoQuestsTab:CreateButton("إلغاء المهمة الحالية (Abandon Quest)", function()
            if CommF_ then CommF_:InvokeServer("AbandonQuest") end
        end)

        ---------------------------------------------------------
        -- 📌 11. TAB: TELEPORTS (أزرار للبحار وتوغلات للجزر)
        ---------------------------------------------------------
        TeleportsTab:CreateSection("الانتقال بين البحار (Sea Travel Buttons)")

        TeleportsTab:CreateButton("🌊 الانتقال إلى Sea 1 (World 1)", function()
            if CommF_ then CommF_:InvokeServer("TravelMain") end
        end)

        TeleportsTab:CreateButton("🌊 الانتقال إلى Sea 2 (World 2)", function()
            if CommF_ then CommF_:InvokeServer("TravelDressrosa") end
        end)

        TeleportsTab:CreateButton("🌊 الانتقال إلى Sea 3 (World 3)", function()
            if CommF_ then CommF_:InvokeServer("TravelZou") end
        end)

        TeleportsTab:CreateSection("انتقالات جزر العالم الأول (Sea 1 Toggles)")
        for islandName, cf in pairs(FullIslandLocations.Sea1) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("📍 انتقال إلى " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf)
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        TeleportsTab:CreateSection("انتقالات جزر العالم الثاني (Sea 2 Toggles)")
        for islandName, cf in pairs(FullIslandLocations.Sea2) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("📍 انتقال إلى " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf)
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        TeleportsTab:CreateSection("انتقالات جزر العالم الثالث (Sea 3 Toggles)")
        for islandName, cf in pairs(FullIslandLocations.Sea3) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("📍 انتقال إلى " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf)
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        ---------------------------------------------------------
        -- 📌 12. TAB: VISUALS & ESP (جميع التوغلات Off افتراضياً)
        ---------------------------------------------------------
        VisualTab:CreateSection("كاشفات العناصر ورادار المسافات (All Toggles Off)")

        VisualTab:CreateToggle("👤 ESP Players (كاشف اللاعبين)", "ESPPlayersFlag", false, function(state)
            _G.Settings.Visuals["ESP Players"] = state
        end)

        VisualTab:CreateToggle("💀 ESP Bosses (كاشف الزعماء)", "ESPBossesFlag", false, function(state)
            _G.Settings.Visuals["ESP Bosses"] = state
        end)

        VisualTab:CreateToggle("🍎 ESP Fruits (كاشف الفواكه)", "ESPFruitsFlag", false, function(state)
            _G.Settings.Visuals["ESP Fruits"] = state
        end)

        VisualTab:CreateToggle("📦 ESP Chests (كاشف الصناديق)", "ESPChestsFlag", false, function(state)
            _G.Settings.Visuals["ESP Chests"] = state
        end)

        VisualTab:CreateToggle("👾 ESP Enemies (كاشف الوحوش والأعداء)", "ESPEnemiesFlag", false, function(state)
            _G.Settings.Visuals["ESP Enemies"] = state
        end)

        VisualTab:CreateToggle("🏝️ ESP Mirage Island", "ESPMirageFlag", false, function(state)
            _G.Settings.Visuals["ESP Mirage Island"] = state
        end)

        VisualTab:CreateToggle("🦊 ESP Kitsune Island", "ESPKitsuneFlag", false, function(state)
            _G.Settings.Visuals["ESP Kitsune Island"] = state
        end)

        ---------------------------------------------------------
        -- 📌 13. TAB: MISC (Auto Stats وحالة السيرفر)
        ---------------------------------------------------------
        MiscTab:CreateSection("توزيع النقاط التلقائي (Auto Stats Engine)")

        MiscTab:CreateDropdown("اختر الخاصية (Select Stat)", "SelectStatDropdown", {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}, "Melee", function(selected)
            _G.Settings.Stats["Selected Stat"] = selected
        end)

        MiscTab:CreateSlider("عدد النقاط لكل دورة (Points Per Tick)", "StatPointsSlider", 1, 100, 1, function(val)
            _G.Settings.Stats["Points Per Tick"] = val
        end)

        MiscTab:CreateToggle("⚡ تفعيل توزيع النقاط التلقائي (Auto Stats)", "AutoStatsToggleFlag", false, function(state)
            _G.Settings.Stats["Auto Stats"] = state
        end)

        MiscTab:CreateSection("حالة السيرفر والعدادات المباشرة (Server Status)")

        local serverClockParagraph = MiscTab:CreateParagraph({
            Title = "⏰ Server Clock Time (ساعة السيرفر)",
            Desc = "جارٍ التحميل...",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local playerTimeParagraph = MiscTab:CreateParagraph({
            Title = "⏱️ Time Connected In Server (مدة بقائك بالسيرفر)",
            Desc = "0 Hours 0 Minutes 0 Seconds",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local cakePrinceCountParagraph = MiscTab:CreateParagraph({
            Title = "👑 Cake Prince Status (عداد الأعداء المتبقي)",
            Desc = "جارٍ جلب البيانات الحية...",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local mirageStatusParagraph = MiscTab:CreateParagraph({
            Title = "🏝️ Mirage Island Status",
            Desc = "جارٍ الفحص...",
            Image = "rbxassetid://6034453535",
            ImageSize = 20
        })

        local kitsuneStatusParagraph = MiscTab:CreateParagraph({
            Title = "🦊 Kitsune Island Status",
            Desc = "جارٍ الفحص...",
            Image = "rbxassetid://6034453535",
            ImageSize = 20
        })

        task.spawn(function()
            while task.wait(1) do
                pcall(function()
                    local clockTime = game.Lighting.ClockTime
                    local hours = math.floor(clockTime)
                    local minutes = math.floor((clockTime - hours) * 60)
                    serverClockParagraph:SetDesc(string.format("%02d:%02d", hours, minutes))

                    local gameTime = math.floor(workspace.DistributedGameTime + 0.5)
                    local sH = math.floor(gameTime / 3600) % 24
                    local sM = math.floor(gameTime / 60) % 60
                    local sS = math.floor(gameTime) % 60
                    playerTimeParagraph:SetDesc(sH .. " Hours " .. sM .. " Minutes " .. sS .. " Seconds")

                    if World3 and CommF_ then
                        local princeData = CommF_:InvokeServer("CakePrinceSpawner")
                        if typeof(princeData) == "string" then
                            if string.find(princeData, "spawned") or string.find(princeData, "ready") then
                                cakePrinceCountParagraph:SetDesc("👑 Cake Prince Is Spawned! (تم استدعاء الكيك برنس!)")
                            else
                                local rem = string.match(princeData, "%d+")
                                cakePrinceCountParagraph:SetDesc(rem and ("⚔️ متبقي " .. rem .. " بوت/عدو لاستدعاء Cake Prince") or princeData)
                            end
                        end
                    else
                        cakePrinceCountParagraph:SetDesc("متوفر في العالم الثالث فقط (Sea 3 Only)")
                    end

                    local mirageIsland = workspace.Map:FindFirstChild("MysticIsland")
                    if mirageIsland then
                        local char, hrp = GetCharacter()
                        local dist = hrp and math.floor((hrp.Position - mirageIsland.WorldPivot.Position).Magnitude) or 0
                        mirageStatusParagraph:SetDesc("✅ ظهرت بالفعل! | المسافة: " .. dist .. "m")
                    else
                        mirageStatusParagraph:SetDesc("❌ لم تظهر بعد")
                    end

                    local kitsuneIsland = workspace.Map:FindFirstChild("KitsuneIsland")
                    if kitsuneIsland then
                        local char, hrp = GetCharacter()
                        local dist = hrp and math.floor((hrp.Position - kitsuneIsland.WorldPivot.Position).Magnitude) or 0
                        kitsuneStatusParagraph:SetDesc("✅ ظهرت بالفعل! | المسافة: " .. dist .. "m")
                    else
                        kitsuneStatusParagraph:SetDesc("❌ لم تظهر بعد")
                    end
                end)
            end
        end)

        MiscTab:CreateSection("إعدادات الفريق والـ Haki")

        MiscTab:CreateToggle("تفعيل الـ Ken (Buso Haki) تلقائياً", "AutoKenFlag", false, function(state)
            _G.Settings.Misc["Auto Ken (Buso Haki)"] = state
        end)

        MiscTab:CreateToggle("الانضمام إلى فريق المارينز", "SetTeamMarinesFlag", false, function(state)
            _G.Settings.Misc["Set Team to Marines"] = state
            if state and CommF_ then CommF_:InvokeServer("SetTeam", "Marines") end
        end)

        MiscTab:CreateToggle("الانضمام إلى فريق القراصنة", "SetTeamPiratesFlag", false, function(state)
            _G.Settings.Misc["Set Team to Pirates"] = state
            if state and CommF_ then CommF_:InvokeServer("SetTeam", "Pirates") end
        end)

        ---------------------------------------------------------
        -- 📌 14. TAB: SETTINGS
        ---------------------------------------------------------
        SettingsTab:CreateSection("إعدادات وتحكم السكربت")

        SettingsTab:CreateButton("إعادة دخول السيرفر (Rejoin)", function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)

        SettingsTab:CreateButton("إغلاق السكربت بالكامل (Destroy Hub)", function()
            local master = game:GetService("CoreGui"):FindFirstChild("HaroonHub_Master") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("HaroonHub_Master")
            if master then master:Destroy() end
        end)
    end)
end)

--------------------------------------------------------------------------------
-- 7. حلقة التلفيل الفردي والانتقال المباشر (Single-Target Master Loop)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.08) do
        if _G.Settings.Main["Auto Farm Level"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum or hum.Health <= 0 then return end

                CheckQuest()
                AutoHaki()

                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")

                if not questGui or not questGui.Visible or not string.find(questGui.Container.QuestTitle.Title.Text, CurrentQuest.NameMon) then
                    if CommF_ then CommF_:InvokeServer("AbandonQuest") end
                    TweenPlayer(CurrentQuest.CFrameQuest, Vector3.new(0, 5, 0))

                    if (hrp.Position - CurrentQuest.CFrameQuest.Position).Magnitude <= 20 then
                        if CommF_ then CommF_:InvokeServer("StartQuest", CurrentQuest.NameQuest, CurrentQuest.LevelQuest) end
                    end
                else
                    local targetMob = nil
                    local closestDistance = math.huge

                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v:IsA("Model") and v.Name == CurrentQuest.Mon then
                            local root = v:FindFirstChild("HumanoidRootPart")
                            local mobHum = v:FindFirstChildOfClass("Humanoid")
                            if root and mobHum and mobHum.Health > 0 then
                                local dist = (hrp.Position - root.Position).Magnitude
                                if dist < closestDistance then
                                    closestDistance = dist
                                    targetMob = v
                                end
                            end
                        end
                    end

                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        TweenPlayer(targetMob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(targetMob)
                    else
                        TweenPlayer(CurrentQuest.CFrameMon, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 8. محرك الإبحار والقتال البحري والجزيرة القديمة (Sea & Prehistoric Engine)
--------------------------------------------------------------------------------
local function GetMyBoat(boatName: string): Model?
    if workspace:FindFirstChild("Boats") then
        for _, b in pairs(workspace.Boats:GetChildren()) do
            if b.Name == boatName and b:FindFirstChild("VehicleSeat") then
                return b
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.2) do
        if World3 then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                -- 1. أتمتة الجزيرة القديمة وما قبل التاريخ Prehistoric Engine
                if _G.Settings.Sea["Auto Prehistoric Island"] or _G.Settings.Sea["Auto Complete Prehistoric Island"] or _G.Settings.Sea["Auto Draco Trail"] then
                    local targetPreMob = nil
                    for _, mName in pairs({"Isle Outlaw", "Island Boy", "Sun-kissed Warrior", "Terrorshark"}) do
                        local mob = workspace.Enemies:FindFirstChild(mName)
                        if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                            targetPreMob = mob
                            break
                        end
                    end

                    if targetPreMob then
                        AutoHaki()
                        TweenPlayer(targetPreMob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(targetPreMob)
                        return
                    else
                        TweenPlayer(MobSpecificTeleports["Prehistoric Island"], Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                    end
                end

                -- 2. فحص وهجوم أعداء ومخلوقات البحر
                local targetSeaEnemy = nil
                local allowedEnemies = {}
                if _G.Settings.Sea["Auto Farm Shark"] then table.insert(allowedEnemies, "Shark") end
                if _G.Settings.Sea["Auto Farm Piranha"] then table.insert(allowedEnemies, "Piranha") end
                if _G.Settings.Sea["Auto Farm Fish Crew Member"] then table.insert(allowedEnemies, "Fish Crew Member") end
                if _G.Settings.Sea["Auto Farm Ghost Ship"] then table.insert(allowedEnemies, "Ghost Ship") table.insert(allowedEnemies, "FishBoat") end
                if _G.Settings.Sea["Auto Farm Terrorshark"] then table.insert(allowedEnemies, "Terrorshark") end

                if #allowedEnemies > 0 and workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if table.find(allowedEnemies, enemy.Name) and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                            targetSeaEnemy = enemy
                            break
                        end
                    end
                end

                if targetSeaEnemy then
                    if hum.Sit then hum.Sit = false end
                    AutoHaki()
                    TweenPlayer(targetSeaEnemy.HumanoidRootPart.CFrame, Vector3.new(0, 25, 0))
                    SmartAttackMob(targetSeaEnemy)
                    return
                end

                -- قتال السي بيست (SeaBeasts)
                if _G.Settings.Sea["Auto Farm Seabeasts"] and workspace:FindFirstChild("SeaBeasts") then
                    for _, sb in pairs(workspace.SeaBeasts:GetChildren()) do
                        if sb:FindFirstChild("HumanoidRootPart") and sb:FindFirstChildOfClass("Humanoid") and sb.Humanoid.Health > 0 then
                            if hum.Sit then hum.Sit = false end
                            AutoHaki()
                            local dodgeOffset = _G.Settings.Sea["Dodge Seabeasts Attack"] and Vector3.new(math.random(-50, 50), 55, math.random(-50, 50)) or Vector3.new(0, 55, 0)
                            TweenPlayer(sb.HumanoidRootPart.CFrame, dodgeOffset)
                            FastAttackTarget(sb)
                            return
                        end
                    end
                end

                -- الفحص الفوري عن Mirage أو Kitsune Island
                local mirage = workspace.Map:FindFirstChild("MysticIsland")
                local kitsune = workspace.Map:FindFirstChild("KitsuneIsland")

                if _G.Settings.Race["Auto Find Mirage"] and mirage then
                    TweenPlayer(mirage.WorldPivot)
                    return
                end

                if _G.Settings.Sea["Auto Find Kitsune Island"] and kitsune then
                    TweenPlayer(kitsune.WorldPivot)
                    return
                end

                -- الإبحار التلقائي بالقارب
                if _G.Settings.Sea["Sail Boat"] or _G.Settings.Race["Auto Find Mirage"] or _G.Settings.Sea["Auto Find Kitsune Island"] then
                    local boat = GetMyBoat(_G.Settings.Sea["Selected Boat"])
                    if not boat then
                        local buyPos = MobSpecificTeleports["Kitsune Island"]
                        if (hrp.Position - buyPos.Position).Magnitude > 30 then
                            TweenPlayer(buyPos)
                        else
                            if CommF_ then CommF_:InvokeServer("BuyBoat", _G.Settings.Sea["Selected Boat"]) end
                        end
                    else
                        if not hum.Sit then
                            hrp.CFrame = boat.VehicleSeat.CFrame * CFrame.new(0, 1.5, 0)
                        else
                            local targetZone = ZoneCFrames[_G.Settings.Sea["Selected Zone"]] or ZoneCFrames["Zone 5"]
                            local dist = (boat.VehicleSeat.Position - targetZone.Position).Magnitude
                            if dist > 100 then
                                local tween = TweenService:Create(boat.VehicleSeat, TweenInfo.new(dist / _G.Settings.Sea["Boat Tween Speed"], Enum.EasingStyle.Linear), {CFrame = targetZone})
                                tween:Play()
                            end
                        end
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 9. محرك تجميع وسرقة وتخزين الفواكه (Fruits Automation Loop)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Fruits["Auto Store Fruit"] then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") and (string.find(tool.Name, "Fruit") or tool.ToolTip == "Blox Fruit") then
                            if CommF_ then CommF_:InvokeServer("StoreFruit", tool.Name, tool) end
                        end
                    end
                end
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and (string.find(tool.Name, "Fruit") or tool.ToolTip == "Blox Fruit") then
                        if CommF_ then CommF_:InvokeServer("StoreFruit", tool.Name, tool) end
                    end
                end
            end)
        end

        if _G.Settings.Fruits["Fruit Sniper"] then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Tool") and (string.find(obj.Name, "Fruit") or string.find(obj.Name, "Blox")) then
                        local handle = obj:FindFirstChild("Handle") or obj.PrimaryPart
                        if handle then
                            TweenPlayer(handle.CFrame)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 10. محرك الـ Dungeon / Fruits Raid (مع Auto Next Island)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Raid["Auto Dungeon / Raid"] or _G.Settings.Raid["Auto Buy Chip & Start"] or _G.Settings.Raid["Auto Clear Dungeon Waves"] or _G.Settings.Raid["Auto Next Island"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                -- شراء الشريحة وبدء الريد
                if _G.Settings.Raid["Auto Buy Chip & Start"] then
                    if CommF_ then
                        CommF_:InvokeServer("RaidsNpc", "Select", _G.Settings.Raid["Selected Chip"])
                        task.wait(0.5)
                        CommF_:InvokeServer("RaidsNpc", "Start")
                    end
                end

                -- تنظيف وتصفية وحوش الريد
                if _G.Settings.Raid["Auto Clear Dungeon Waves"] and workspace:FindFirstChild("Enemies") then
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                            AutoHaki()
                            TweenPlayer(mob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                            SmartAttackMob(mob)
                            break
                        end
                    end
                end

                -- الانتقال التلقائي للجزيرة التالية في الريد فور انتهاء الموجة
                if _G.Settings.Raid["Auto Next Island"] and workspace:FindFirstChild("Locations") then
                    for _, loc in pairs(workspace.Locations:GetChildren()) do
                        if string.find(loc.Name:lower(), "island") or string.find(loc.Name:lower(), "raid") then
                            TweenPlayer(loc.CFrame * CFrame.new(0, 30, 0))
                            break
                        end
                    end
                end

                -- إيقاظ الفاكهة التلقائي
                if _G.Settings.Raid["Auto Awaken"] and CommF_ then
                    CommF_:InvokeServer("AwakeningExpert", "Awaken")
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 11. محرك الـ Auto Stats
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Stats["Auto Stats"] then
            pcall(function()
                local points = LocalPlayer.Data.Points.Value
                if points and points > 0 then
                    local targetStat = _G.Settings.Stats["Selected Stat"]
                    local addCount = math.min(points, _G.Settings.Stats["Points Per Tick"] or 1)
                    if CommF_ then
                        CommF_:InvokeServer("AddPoint", targetStat, addCount)
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 12. محرك ترقية الأجناس الاحترافي (Race V2 & V3 Master Loop)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        -- أتمتة Race V2 الكاملة (جمع الأزهار والتسليم)
        if _G.Settings.Race["Auto Race V2 Quest"] and World2 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local flowers = {"Flower1", "Flower2", "Flower3"}
                local foundFlower = false

                for _, fName in pairs(flowers) do
                    local flowerObj = workspace:FindFirstChild(fName) or (workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild(fName))
                    if flowerObj and flowerObj:IsA("BasePart") then
                        foundFlower = true
                        TweenPlayer(flowerObj.CFrame)
                        break
                    end
                end

                if not foundFlower then
                    local alchemistPos = CFrame.new(-2440.79, 71.71, -3216.06)
                    if (hrp.Position - alchemistPos.Position).Magnitude > 20 then
                        TweenPlayer(alchemistPos)
                    else
                        if CommF_ then CommF_:InvokeServer("Alchemist", "1") end
                    end
                end
            end)
        end

        -- أتمتة Race V3 الكاملة بحسب متطلبات الجنس
        if _G.Settings.Race["Auto Race V3 Quest"] and World2 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local selectedRace = _G.Settings.Race["Selected Race V3"]
                local arouPos = CFrame.new(-2440.79, 71.71, -3216.06)

                if selectedRace == "Human" then
                    -- قتل الزعماء الثلاثة للـ Human V3
                    for _, bossName in pairs({"Jeremy", "Diamond", "Fajita"}) do
                        local boss = workspace.Enemies:FindFirstChild(bossName)
                        if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChildOfClass("Humanoid") and boss.Humanoid.Health > 0 then
                            AutoHaki()
                            TweenPlayer(boss.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                            SmartAttackMob(boss)
                            return
                        end
                    end
                end

                -- التحدث إلى NPC Arou
                if (hrp.Position - arouPos.Position).Magnitude > 20 then
                    TweenPlayer(arouPos)
                else
                    if CommF_ then CommF_:InvokeServer("Wenlocktoad", "1") end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 13. محرك السيوف الأسطورية المدمجة (CDK & TTK Auto Quests)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        -- أتمتة Cursed Dual Katana (CDK)
        if _G.Settings.FarmingQuests["Auto Farm CDK"] and World3 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local cryptPos = CFrame.new(-12471.16, 374.94, -7551.67)
                if (hrp.Position - cryptPos.Position).Magnitude > 25 then
                    TweenPlayer(cryptPos)
                else
                    if CommF_ then
                        CommF_:InvokeServer("CDKQuest", "Start")
                        CommF_:InvokeServer("CDKQuest", "Progress")
                    end
                end
            end)
        end

        -- أتمتة True Triple Katana (TTK)
        if _G.Settings.FarmingQuests["Auto Farm TTK"] and World2 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local swordDealerPos = CFrame.new(-2448.53, 73.01, -3210.63)
                if CommF_ then
                    CommF_:InvokeServer("LegendarySwordDealer", "1")
                    CommF_:InvokeServer("LegendarySwordDealer", "2")
                    CommF_:InvokeServer("LegendarySwordDealer", "3")
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 14. محرك الـ ESP المتكامل والحي (Advanced ESP Engine with Distance & HP)
--------------------------------------------------------------------------------
local ESPCache = {}

local function RemoveESP(obj)
    if ESPCache[obj] then
        ESPCache[obj]:Destroy()
        ESPCache[obj] = nil
    end
end

local function CreateUniversalESP(part: BasePart, text: string, color: Color3, showHP: boolean, maxHP: number?, currentHP: number?)
    if not part then return end
    if ESPCache[part] then RemoveESP(part) end

    local bill = Instance.new("BillboardGui")
    bill.Name = "HaroonESP"
    bill.Adornee = part
    bill.Size = UDim2.new(0, 150, 0, showHP and 45 or 28)
    bill.AlwaysOnTop = true

    local frame = Instance.new("Frame", bill)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BackgroundTransparency = 0.25
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

    local txt = Instance.new("TextLabel", frame)
    txt.Name = "ESPTitle"
    txt.Size = UDim2.new(1, 0, 0, 14)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = color
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 10

    local distLabel = Instance.new("TextLabel", frame)
    distLabel.Name = "ESPDist"
    distLabel.Size = UDim2.new(1, 0, 0, 12)
    distLabel.Position = UDim2.new(0, 0, 0, 13)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 9
    distLabel.Text = "Dist: ?m"

    if showHP and maxHP and currentHP then
        local hpBg = Instance.new("Frame", frame)
        hpBg.Size = UDim2.new(1, -10, 0, 4)
        hpBg.Position = UDim2.new(0, 5, 0, 28)
        hpBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        local hpFill = Instance.new("Frame", hpBg)
        hpFill.Name = "HPFill"
        hpFill.Size = UDim2.new(math.clamp(currentHP / maxHP, 0, 1), 0, 1, 0)
        hpFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end

    bill.Parent = part
    ESPCache[part] = bill
end

task.spawn(function()
    while task.wait(0.2) do
        local char, hrp = GetCharacter()
        if not char or not hrp then continue end

        -- 1. Players ESP
        if _G.Settings.Visuals["ESP Players"] then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
                    local pHrp = p.Character.HumanoidRootPart
                    local pHum = p.Character.Humanoid
                    local dist = math.floor((hrp.Position - pHrp.Position).Magnitude)
                    
                    CreateUniversalESP(pHrp, p.Name, Color3.fromRGB(255, 85, 85), true, pHum.MaxHealth, pHum.Health)
                    if ESPCache[pHrp] and ESPCache[pHrp]:FindFirstChild("Frame") then
                        ESPCache[pHrp].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                    end
                end
            end
        end

        -- 2. Fruits ESP
        if _G.Settings.Visuals["ESP Fruits"] then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Tool") and (string.find(v.Name, "Fruit") or string.find(v.Name, "Blox")) then
                    local handle = v:FindFirstChild("Handle") or v.PrimaryPart
                    if handle then
                        local dist = math.floor((hrp.Position - handle.Position).Magnitude)
                        CreateUniversalESP(handle, "🍎 " .. v.Name, Color3.fromRGB(255, 170, 0), false)
                        if ESPCache[handle] and ESPCache[handle]:FindFirstChild("Frame") then
                            ESPCache[handle].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                        end
                    end
                end
            end
        end

        -- 3. Chests ESP
        if _G.Settings.Visuals["ESP Chests"] and workspace:FindFirstChild("ChestModels") then
            for _, chest in pairs(workspace.ChestModels:GetChildren()) do
                if chest:FindFirstChild("RootPart") then
                    local dist = math.floor((hrp.Position - chest.RootPart.Position).Magnitude)
                    CreateUniversalESP(chest.RootPart, "📦 " .. chest.Name, Color3.fromRGB(255, 255, 0), false)
                    if ESPCache[chest.RootPart] and ESPCache[chest.RootPart]:FindFirstChild("Frame") then
                        ESPCache[chest.RootPart].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                    end
                end
            end
        end

        -- 4. Bosses & Enemies ESP
        if (_G.Settings.Visuals["ESP Bosses"] or _G.Settings.Visuals["ESP Enemies"]) and workspace:FindFirstChild("Enemies") then
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                    local eHrp = enemy.HumanoidRootPart
                    local eHum = enemy.Humanoid
                    if eHum.Health > 0 then
                        local dist = math.floor((hrp.Position - eHrp.Position).Magnitude)
                        CreateUniversalESP(eHrp, enemy.Name, Color3.fromRGB(255, 0, 127), true, eHum.MaxHealth, eHum.Health)
                        if ESPCache[eHrp] and ESPCache[eHrp]:FindFirstChild("Frame") then
                            ESPCache[eHrp].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                        end
                    end
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- 15. حلقات الصناديق والماتيريال والزعماء المتبقية
--------------------------------------------------------------------------------

-- Chest Farm Loop
task.spawn(function()
    while task.wait(0.2) do
        if _G.Settings.SubFarm["Auto Chest Tween"] or _G.Settings.SubFarm["Auto Chest Instant"] then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local closestChest = nil
                local shortestDist = math.huge
                if workspace:FindFirstChild("ChestModels") then
                    for _, v in pairs(workspace.ChestModels:GetChildren()) do
                        if string.find(v.Name, "Chest") and v:FindFirstChild("RootPart") then
                            local dist = (hrp.Position - v.RootPart.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestChest = v
                            end
                        end
                    end
                end

                if closestChest then
                    if _G.Settings.SubFarm["Auto Chest Instant"] then
                        hrp.CFrame = closestChest.RootPart.CFrame
                    else
                        TweenPlayer(closestChest.RootPart.CFrame)
                    end
                end
            end)
        end
    end
end)

-- Material Farm Loop
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Main["Auto Farm Material"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                local mobs, pos = GetMaterialConfig(_G.Settings.Main["Selected Material"])
                local found = false

                for _, mName in pairs(mobs) do
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == mName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                            found = true
                            AutoHaki()
                            TweenPlayer(v.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                            SmartAttackMob(v)
                            break
                        end
                    end
                    if found then break end
                end

                if not found then
                    TweenPlayer(pos, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                end
            end)
        end
    end
end)

-- Boss Farm Loop
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Main["Auto Farm Boss"] or _G.Settings.Main["Auto Farm All Boss"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                local bTarget = _G.Settings.Main["Selected Boss"]
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if (v.Name == bTarget or _G.Settings.Main["Auto Farm All Boss"]) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                        AutoHaki()
                        TweenPlayer(v.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(v)
                        break
                    end
                end
            end)
        end
    end
end)       _G.Settings.Sea["Auto Draco Trail"] or _G.Settings.Raid["Auto Next Island"]

    local char, hrp, hum = GetCharacter()
    if not char or not hrp or not hum then return end

    if active then
        pcall(function()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            if not hrp:FindFirstChild("HaroonBV") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "HaroonBV"
                bv.Parent = hrp
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.zero
            end
        end)
    else
        pcall(function()
            if hrp:FindFirstChild("HaroonBV") then
                hrp.HaroonBV:Destroy()
            end
        end)
    end
end)

local function TweenPlayer(pos: CFrame | Vector3 | BasePart, offset: Vector3?): Tween?
    local char, hrp, hum = GetCharacter()
    if not char or not hrp or not hum then return nil end
    if hum.Sit then hum.Sit = false end

    local targetCFrame: CFrame
    if typeof(pos) == "CFrame" then targetCFrame = pos
    elseif typeof(pos) == "Vector3" then targetCFrame = CFrame.new(pos)
    elseif pos:IsA("BasePart") then targetCFrame = pos.CFrame
    else return nil end

    if offset then targetCFrame = targetCFrame * CFrame.new(offset) end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local uprightCFrame = CFrame.new(targetCFrame.Position, targetCFrame.Position + Vector3.new(targetCFrame.LookVector.X, 0, targetCFrame.LookVector.Z))

    if distance <= 25 then
        hrp.CFrame = uprightCFrame
        if currentTween then currentTween:Cancel() end
        return nil
    end

    local speed = _G.Settings.Main["Player Tween Speed"] or 180
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)

    if currentTween then currentTween:Cancel() end
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = uprightCFrame})
    currentTween:Play()
    return currentTween
end

local function StopTween()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    local _, hrp = GetCharacter()
    if hrp and hrp:FindFirstChild("HaroonBV") then
        hrp.HaroonBV:Destroy()
    end
end

local function AutoHaki()
    local char = LocalPlayer.Character
    if char and not CollectionService:HasTag(char, "Ken") then
        if CommE then pcall(function() CommE:FireServer("Ken", true) end) end
    end
end

local function EquipWeapon(weaponType: string)
    pcall(function()
        local char, _, hum = GetCharacter()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack or not hum or not char then return end

        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == weaponType or (weaponType == "Melee" and tool.ToolTip == "Melee") or (weaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit") or (weaponType == "Gun" and tool.ToolTip == "Gun") or (weaponType == "Sword" and tool.ToolTip == "Sword")) then
                return
            end
        end

        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == weaponType or (weaponType == "Melee" and tool.ToolTip == "Melee") or (weaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit") or (weaponType == "Gun" and tool.ToolTip == "Gun") or (weaponType == "Sword" and tool.ToolTip == "Sword")) then
                hum:EquipTool(tool)
                break
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- 4. المحرك الذكي للهجوم والـ Aimbot والـ 80% Damage Mechanic
--------------------------------------------------------------------------------
local function AimAtTarget(targetPosition: Vector3)
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetPosition)
        end
    end)
end

local function FastAttackTarget(targetEnemy: Model)
    if not targetEnemy or not targetEnemy:FindFirstChild("HumanoidRootPart") then return end
    local head = targetEnemy:FindFirstChild("Head") or targetEnemy.HumanoidRootPart

    if RegisterAttack then
        pcall(function()
            RegisterAttack:FireServer(0)
            RegisterAttack:FireServer(1)
            RegisterAttack:FireServer(2)
            RegisterAttack:FireServer(3)
        end)
    end

    if RegisterHit then
        pcall(function()
            if typeof(RegisterHit) == "thread" or typeof(RegisterHit) == "function" then
                coroutine.resume(RegisterHit, head, {})
            elseif typeof(RegisterHit) == "Instance" then
                RegisterHit:FireServer(head, {})
            end
        end)
    end
end

local function SmartAttackMob(targetMob: Model, weaponOverride: string?): boolean
    local selectedWep = weaponOverride or _G.Settings.Main["Select Weapon"]
    local mobHum = targetMob:FindFirstChildOfClass("Humanoid")
    local mobRoot = targetMob:FindFirstChild("HumanoidRootPart") or targetMob:FindFirstChild("Head")
    if not mobHum or mobHum.Health <= 0 or not mobRoot then return false end

    local hpPercent = mobHum.Health / mobHum.MaxHealth

    if selectedWep == "Blox Fruit" or selectedWep == "Gun" then
        if hpPercent > 0.20 then
            EquipWeapon("Melee")
            FastAttackTarget(targetMob)
        else
            EquipWeapon(selectedWep)
            AimAtTarget(mobRoot.Position)

            if selectedWep == "Blox Fruit" then
                for _, key in pairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.F}) do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end
            elseif selectedWep == "Gun" then
                for _, key in pairs({Enum.KeyCode.Z, Enum.KeyCode.X}) do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end
                if ShootGunEvent then
                    pcall(function() ShootGunEvent:FireServer(mobRoot.Position, {mobRoot}) end)
                end
            end

            VirtualInputManager:SendMouseButtonEvent(mobRoot.Position.X, mobRoot.Position.Y, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(mobRoot.Position.X, mobRoot.Position.Y, 0, false, game, 0)
            FastAttackTarget(targetMob)
        end
    else
        EquipWeapon(selectedWep)
        FastAttackTarget(targetMob)
    end

    return true
end

--------------------------------------------------------------------------------
-- 5. قواعد البيانات الشاملة للمهمات والجزر (Quests & Islands Database)
--------------------------------------------------------------------------------
local CurrentQuest = {
    Mon = "Bandit",
    LevelQuest = 1,
    NameQuest = "BanditQuest1",
    NameMon = "Bandit",
    CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42),
    CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
}

local function CheckQuest()
    local MyLevel = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")) and LocalPlayer.Data.Level.Value or 1
    if World1 then
        if MyLevel <= 9 then
            CurrentQuest = {Mon = "Bandit", LevelQuest = 1, NameQuest = "BanditQuest1", NameMon = "Bandit", CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42), CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)}
        elseif MyLevel <= 14 then
            CurrentQuest = {Mon = "Monkey", LevelQuest = 1, NameQuest = "JungleQuest", NameMon = "Monkey", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)}
        elseif MyLevel <= 29 then
            if _G.Settings.Main["Include Boss Quests"] and MyLevel >= 20 then
                CurrentQuest = {Mon = "The Gorilla King", LevelQuest = 3, NameQuest = "JungleQuest", NameMon = "The Gorilla King", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)}
            else
                CurrentQuest = {Mon = "Gorilla", LevelQuest = 2, NameQuest = "JungleQuest", NameMon = "Gorilla", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)}
            end
        elseif MyLevel <= 39 then
            CurrentQuest = {Mon = "Pirate", LevelQuest = 1, NameQuest = "BuggyQuest1", NameMon = "Pirate", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)}
        elseif MyLevel <= 59 then
            if _G.Settings.Main["Include Boss Quests"] and MyLevel >= 55 then
                CurrentQuest = {Mon = "Bobby", LevelQuest = 3, NameQuest = "BuggyQuest1", NameMon = "Bobby", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)}
            else
                CurrentQuest = {Mon = "Brute", LevelQuest = 2, NameQuest = "BuggyQuest1", NameMon = "Brute", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)}
            end
        elseif MyLevel <= 74 then
            CurrentQuest = {Mon = "Desert Bandit", LevelQuest = 1, NameQuest = "DesertQuest", NameMon = "Desert Bandit", CFrameQuest = CFrame.new(894.48, 5.14, 4392.43), CFrameMon = CFrame.new(924.79, 6.44, 4481.58)}
        elseif MyLevel <= 89 then
            CurrentQuest = {Mon = "Desert Officer", LevelQuest = 2, NameQuest = "DesertQuest", NameMon = "Desert Officer", CFrameQuest = CFrame.new(894.48, 5.14, 4392.43), CFrameMon = CFrame.new(1608.28, 8.61, 4371.00)}
        elseif MyLevel <= 99 then
            CurrentQuest = {Mon = "Snow Bandit", LevelQuest = 1, NameQuest = "SnowQuest", NameMon = "Snow Bandit", CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90), CFrameMon = CFrame.new(1354.34, 87.27, -1393.94)}
        elseif MyLevel <= 119 then
            CurrentQuest = {Mon = "Snowman", LevelQuest = 2, NameQuest = "SnowQuest", NameMon = "Snowman", CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90), CFrameMon = CFrame.new(1201.64, 144.57, -1550.06)}
        elseif MyLevel <= 149 then
            CurrentQuest = {Mon = "Chief Petty Officer", LevelQuest = 1, NameQuest = "MarineQuest2", NameMon = "Chief Petty Officer", CFrameQuest = CFrame.new(-5039.58, 27.35, 4324.68), CFrameMon = CFrame.new(-4881.23, 22.65, 4273.75)}
        elseif MyLevel <= 174 then
            CurrentQuest = {Mon = "Sky Bandit", LevelQuest = 1, NameQuest = "SkyQuest", NameMon = "Sky Bandit", CFrameQuest = CFrame.new(-4839.53, 716.36, -2619.44), CFrameMon = CFrame.new(-4953.20, 295.74, -2899.22)}
        elseif MyLevel <= 189 then
            CurrentQuest = {Mon = "Dark Master", LevelQuest = 2, NameQuest = "SkyQuest", NameMon = "Dark Master", CFrameQuest = CFrame.new(-4839.53, 716.36, -2619.44), CFrameMon = CFrame.new(-5259.84, 391.39, -2229.03)}
        elseif MyLevel <= 209 then
            CurrentQuest = {Mon = "Prisoner", LevelQuest = 1, NameQuest = "PrisonerQuest", NameMon = "Prisoner", CFrameQuest = CFrame.new(5308.93, 1.65, 475.12), CFrameMon = CFrame.new(5098.97, -0.32, 474.23)}
        elseif MyLevel <= 249 then
            CurrentQuest = {Mon = "Dangerous Prisoner", LevelQuest = 2, NameQuest = "PrisonerQuest", NameMon = "Dangerous Prisoner", CFrameQuest = CFrame.new(5308.93, 1.65, 475.12), CFrameMon = CFrame.new(5654.56, 15.63, 866.29)}
        elseif MyLevel <= 274 then
            CurrentQuest = {Mon = "Toga Warrior", LevelQuest = 1, NameQuest = "ColosseumQuest", NameMon = "Toga Warrior", CFrameQuest = CFrame.new(-1580.04, 6.35, -2986.47), CFrameMon = CFrame.new(-1820.21, 51.68, -2740.66)}
        elseif MyLevel <= 299 then
            CurrentQuest = {Mon = "Gladiator", LevelQuest = 2, NameQuest = "ColosseumQuest", NameMon = "Gladiator", CFrameQuest = CFrame.new(-1580.04, 6.35, -2986.47), CFrameMon = CFrame.new(-1292.83, 56.38, -3339.03)}
        elseif MyLevel <= 324 then
            CurrentQuest = {Mon = "Military Soldier", LevelQuest = 1, NameQuest = "MagmaQuest", NameMon = "Military Soldier", CFrameQuest = CFrame.new(-5313.37, 10.95, 8515.29), CFrameMon = CFrame.new(-5411.16, 11.08, 8454.29)}
        elseif MyLevel <= 374 then
            CurrentQuest = {Mon = "Military Spy", LevelQuest = 2, NameQuest = "MagmaQuest", NameMon = "Military Spy", CFrameQuest = CFrame.new(-5313.37, 10.95, 8515.29), CFrameMon = CFrame.new(-5802.86, 86.26, 8828.85)}
        elseif MyLevel <= 399 then
            CurrentQuest = {Mon = "Fishman Warrior", LevelQuest = 1, NameQuest = "FishmanQuest", NameMon = "Fishman Warrior", CFrameQuest = CFrame.new(61122.65, 18.49, 1569.39), CFrameMon = CFrame.new(60878.30, 18.48, 1543.75)}
        elseif MyLevel <= 449 then
            CurrentQuest = {Mon = "Fishman Commando", LevelQuest = 2, NameQuest = "FishmanQuest", NameMon = "Fishman Commando", CFrameQuest = CFrame.new(61122.65, 18.49, 1569.39), CFrameMon = CFrame.new(61922.63, 18.48, 1493.93)}
        elseif MyLevel <= 474 then
            CurrentQuest = {Mon = "God's Guard", LevelQuest = 1, NameQuest = "SkyExp1Quest", NameMon = "God's Guard", CFrameQuest = CFrame.new(-4721.88, 843.87, -1949.96), CFrameMon = CFrame.new(-4710.04, 845.27, -1927.30)}
        elseif MyLevel <= 524 then
            CurrentQuest = {Mon = "Shanda", LevelQuest = 2, NameQuest = "SkyExp1Quest", NameMon = "Shanda", CFrameQuest = CFrame.new(-7859.09, 5544.19, -381.47), CFrameMon = CFrame.new(-7678.48, 5566.40, -497.21)}
        elseif MyLevel <= 549 then
            CurrentQuest = {Mon = "Royal Squad", LevelQuest = 1, NameQuest = "SkyExp2Quest", NameMon = "Royal Squad", CFrameQuest = CFrame.new(-7906.81, 5634.66, -1411.99), CFrameMon = CFrame.new(-7624.25, 5658.13, -1467.35)}
        elseif MyLevel <= 624 then
            CurrentQuest = {Mon = "Royal Soldier", LevelQuest = 2, NameQuest = "SkyExp2Quest", NameMon = "Royal Soldier", CFrameQuest = CFrame.new(-7906.81, 5634.66, -1411.99), CFrameMon = CFrame.new(-7836.75, 5645.66, -1790.62)}
        elseif MyLevel <= 649 then
            CurrentQuest = {Mon = "Galley Pirate", LevelQuest = 1, NameQuest = "FountainQuest", NameMon = "Galley Pirate", CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02), CFrameMon = CFrame.new(5551.02, 78.90, 3930.41)}
        else
            CurrentQuest = {Mon = "Galley Captain", LevelQuest = 2, NameQuest = "FountainQuest", NameMon = "Galley Captain", CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02), CFrameMon = CFrame.new(5441.95, 42.50, 4950.09)}
        end
    elseif World2 then
        if MyLevel <= 724 then
            CurrentQuest = {Mon = "Raider", LevelQuest = 1, NameQuest = "Area1Quest", NameMon = "Raider", CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18), CFrameMon = CFrame.new(-728.32, 52.77, 2345.77)}
        elseif MyLevel <= 774 then
            CurrentQuest = {Mon = "Mercenary", LevelQuest = 2, NameQuest = "Area1Quest", NameMon = "Mercenary", CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18), CFrameMon = CFrame.new(-1004.32, 80.15, 1424.61)}
        elseif MyLevel <= 799 then
            CurrentQuest = {Mon = "Swan Pirate", LevelQuest = 1, NameQuest = "Area2Quest", NameMon = "Swan Pirate", CFrameQuest = CFrame.new(638.43, 71.76, 918.28), CFrameMon = CFrame.new(1068.66, 137.61, 1322.10)}
        elseif MyLevel <= 874 then
            CurrentQuest = {Mon = "Factory Staff", LevelQuest = 2, NameQuest = "Area2Quest", NameMon = "Factory Staff", CFrameQuest = CFrame.new(632.69, 73.10, 918.66), CFrameMon = CFrame.new(73.07, 81.86, -27.47)}
        elseif MyLevel <= 899 then
            CurrentQuest = {Mon = "Marine Lieutenant", LevelQuest = 1, NameQuest = "MarineQuest3", NameMon = "Marine Lieutenant", CFrameQuest = CFrame.new(-2440.79, 71.71, -3216.06), CFrameMon = CFrame.new(-2821.37, 75.89, -3070.08)}
        elseif MyLevel <= 949 then
            CurrentQuest = {Mon = "Marine Captain", LevelQuest = 2, NameQuest = "MarineQuest3", NameMon = "Marine Captain", CFrameQuest = CFrame.new(-2440.79, 71.71, -3216.06), CFrameMon = CFrame.new(-1861.23, 80.17, -3254.69)}
        elseif MyLevel <= 974 then
            CurrentQuest = {Mon = "Zombie", LevelQuest = 1, NameQuest = "ZombieQuest", NameMon = "Zombie", CFrameQuest = CFrame.new(-5497.06, 47.59, -795.23), CFrameMon = CFrame.new(-5657.77, 78.96, -928.68)}
        elseif MyLevel <= 999 then
            CurrentQuest = {Mon = "Vampire", LevelQuest = 2, NameQuest = "ZombieQuest", NameMon = "Vampire", CFrameQuest = CFrame.new(-5497.06, 47.59, -795.23), CFrameMon = CFrame.new(-6037.66, 32.18, -1340.65)}
        elseif MyLevel <= 1049 then
            CurrentQuest = {Mon = "Snow Trooper", LevelQuest = 1, NameQuest = "SnowMountainQuest", NameMon = "Snow Trooper", CFrameQuest = CFrame.new(609.85, 400.11, -5372.25), CFrameMon = CFrame.new(549.14, 427.38, -5563.69)}
        elseif MyLevel <= 1099 then
            CurrentQuest = {Mon = "Winter Warrior", LevelQuest = 2, NameQuest = "SnowMountainQuest", NameMon = "Winter Warrior", CFrameQuest = CFrame.new(609.85, 400.11, -5372.25), CFrameMon = CFrame.new(1142.74, 475.63, -5199.41)}
        elseif MyLevel <= 1124 then
            CurrentQuest = {Mon = "Lab Subordinate", LevelQuest = 1, NameQuest = "IceSideQuest", NameMon = "Lab Subordinate", CFrameQuest = CFrame.new(-6064.06, 15.24, -4902.97), CFrameMon = CFrame.new(-5707.47, 15.95, -4513.39)}
        elseif MyLevel <= 1174 then
            CurrentQuest = {Mon = "Horned Warrior", LevelQuest = 2, NameQuest = "IceSideQuest", NameMon = "Horned Warrior", CFrameQuest = CFrame.new(-6064.06, 15.24, -4902.97), CFrameMon = CFrame.new(-6341.36, 15.95, -5723.16)}
        elseif MyLevel <= 1199 then
            CurrentQuest = {Mon = "Magma Ninja", LevelQuest = 1, NameQuest = "FireSideQuest", NameMon = "Magma Ninja", CFrameQuest = CFrame.new(-5428.03, 15.06, -5299.43), CFrameMon = CFrame.new(-5449.67, 76.65, -5808.20)}
        elseif MyLevel <= 1249 then
            CurrentQuest = {Mon = "Lava Pirate", LevelQuest = 2, NameQuest = "FireSideQuest", NameMon = "Lava Pirate", CFrameQuest = CFrame.new(-5428.03, 15.06, -5299.43), CFrameMon = CFrame.new(-5213.33, 49.73, -4701.45)}
        elseif MyLevel <= 1274 then
            CurrentQuest = {Mon = "Ship Deckhand", LevelQuest = 1, NameQuest = "ShipQuest1", NameMon = "Ship Deckhand", CFrameQuest = CFrame.new(1037.80, 125.09, 32911.60), CFrameMon = CFrame.new(1212.01, 150.79, 33059.24)}
        elseif MyLevel <= 1299 then
            CurrentQuest = {Mon = "Ship Engineer", LevelQuest = 2, NameQuest = "ShipQuest1", NameMon = "Ship Engineer", CFrameQuest = CFrame.new(1037.80, 125.09, 32911.60), CFrameMon = CFrame.new(919.47, 43.54, 32779.96)}
        elseif MyLevel <= 1324 then
            CurrentQuest = {Mon = "Ship Steward", LevelQuest = 1, NameQuest = "ShipQuest2", NameMon = "Ship Steward", CFrameQuest = CFrame.new(968.80, 125.09, 33244.12), CFrameMon = CFrame.new(919.43, 129.55, 33436.03)}
        elseif MyLevel <= 1349 then
            CurrentQuest = {Mon = "Ship Officer", LevelQuest = 2, NameQuest = "ShipQuest2", NameMon = "Ship Officer", CFrameQuest = CFrame.new(968.80, 125.09, 33244.12), CFrameMon = CFrame.new(1036.01, 181.43, 33315.72)}
        elseif MyLevel <= 1374 then
            CurrentQuest = {Mon = "Arctic Warrior", LevelQuest = 1, NameQuest = "FrostQuest", NameMon = "Arctic Warrior", CFrameQuest = CFrame.new(5667.65, 26.79, -6486.08), CFrameMon = CFrame.new(5966.24, 62.97, -6179.38)}
        elseif MyLevel <= 1424 then
            CurrentQuest = {Mon = "Snow Lurker", LevelQuest = 2, NameQuest = "FrostQuest", NameMon = "Snow Lurker", CFrameQuest = CFrame.new(5667.65, 26.79, -6486.08), CFrameMon = CFrame.new(5407.07, 69.19, -6880.88)}
        elseif MyLevel <= 1449 then
            CurrentQuest = {Mon = "Sea Soldier", LevelQuest = 1, NameQuest = "ForgottenQuest", NameMon = "Sea Soldier", CFrameQuest = CFrame.new(-3054.44, 235.54, -10142.81), CFrameMon = CFrame.new(-3028.22, 64.67, -9775.42)}
        else
            CurrentQuest = {Mon = "Water Fighter", LevelQuest = 2, NameQuest = "ForgottenQuest", NameMon = "Water Fighter", CFrameQuest = CFrame.new(-3054.44, 235.54, -10142.81), CFrameMon = CFrame.new(-3352.90, 285.01, -10534.84)}
        end
    elseif World3 then
        if MyLevel <= 1524 then
            CurrentQuest = {Mon = "Pirate Millionaire", LevelQuest = 1, NameQuest = "PiratePortQuest", NameMon = "Pirate Millionaire", CFrameQuest = CFrame.new(-290.07, 42.90, 5581.58), CFrameMon = CFrame.new(-245.99, 47.30, 5584.10)}
        elseif MyLevel <= 1574 then
            CurrentQuest = {Mon = "Pistol Billionaire", LevelQuest = 2, NameQuest = "PiratePortQuest", NameMon = "Pistol Billionaire", CFrameQuest = CFrame.new(-290.07, 42.90, 5581.58), CFrameMon = CFrame.new(-187.33, 86.23, 6013.51)}
        elseif MyLevel <= 1599 then
            CurrentQuest = {Mon = "Dragon Crew Warrior", LevelQuest = 1, NameQuest = "AmazonQuest", NameMon = "Dragon Crew Warrior", CFrameQuest = CFrame.new(5832.83, 51.68, -1101.51), CFrameMon = CFrame.new(6141.14, 51.35, -1340.73)}
        elseif MyLevel <= 1624 then
            CurrentQuest = {Mon = "Dragon Crew Archer", LevelQuest = 2, NameQuest = "AmazonQuest", NameMon = "Dragon Crew Archer", CFrameQuest = CFrame.new(5833.11, 51.60, -1103.06), CFrameMon = CFrame.new(6616.41, 441.76, 446.04)}
        elseif MyLevel <= 1649 then
            CurrentQuest = {Mon = "Female Islander", LevelQuest = 1, NameQuest = "AmazonQuest2", NameMon = "Female Islander", CFrameQuest = CFrame.new(5446.87, 601.62, 749.45), CFrameMon = CFrame.new(4685.25, 735.80, 815.34)}
        elseif MyLevel <= 1699 then
            CurrentQuest = {Mon = "Giant Islander", LevelQuest = 2, NameQuest = "AmazonQuest2", NameMon = "Giant Islander", CFrameQuest = CFrame.new(5446.87, 601.62, 749.45), CFrameMon = CFrame.new(4729.09, 590.43, -36.97)}
        elseif MyLevel <= 1724 then
            CurrentQuest = {Mon = "Marine Commodore", LevelQuest = 1, NameQuest = "MarineTreeIsland", NameMon = "Marine Commodore", CFrameQuest = CFrame.new(2180.54, 27.81, -6741.54), CFrameMon = CFrame.new(2286.00, 73.13, -7159.80)}
        elseif MyLevel <= 1774 then
            CurrentQuest = {Mon = "Marine Rear Admiral", LevelQuest = 2, NameQuest = "MarineTreeIsland", NameMon = "Marine Rear Admiral", CFrameQuest = CFrame.new(2179.98, 28.73, -6740.05), CFrameMon = CFrame.new(3656.77, 160.52, -7001.59)}
        elseif MyLevel <= 1799 then
            CurrentQuest = {Mon = "Fishman Raider", LevelQuest = 1, NameQuest = "DeepForestIsland3", NameMon = "Fishman Raider", CFrameQuest = CFrame.new(-10581.65, 330.87, -8761.18), CFrameMon = CFrame.new(-10407.52, 331.76, -8368.51)}
        elseif MyLevel <= 1824 then
            CurrentQuest = {Mon = "Fishman Captain", LevelQuest = 2, NameQuest = "DeepForestIsland3", NameMon = "Fishman Captain", CFrameQuest = CFrame.new(-10581.65, 330.87, -8761.18), CFrameMon = CFrame.new(-10994.70, 352.38, -9002.11)}
        elseif MyLevel <= 1849 then
            CurrentQuest = {Mon = "Forest Pirate", LevelQuest = 1, NameQuest = "DeepForestIsland", NameMon = "Forest Pirate", CFrameQuest = CFrame.new(-13234.04, 331.48, -7625.40), CFrameMon = CFrame.new(-13274.47, 332.37, -7769.58)}
        elseif MyLevel <= 1899 then
            CurrentQuest = {Mon = "Mythological Pirate", LevelQuest = 2, NameQuest = "DeepForestIsland", NameMon = "Mythological Pirate", CFrameQuest = CFrame.new(-13234.04, 331.48, -7625.40), CFrameMon = CFrame.new(-13680.60, 501.08, -6991.18)}
        elseif MyLevel <= 1924 then
            CurrentQuest = {Mon = "Jungle Pirate", LevelQuest = 1, NameQuest = "DeepForestIsland2", NameMon = "Jungle Pirate", CFrameQuest = CFrame.new(-12680.38, 389.97, -9902.01), CFrameMon = CFrame.new(-12256.16, 331.73, -10485.83)}
        elseif MyLevel <= 1974 then
            CurrentQuest = {Mon = "Musketeer Pirate", LevelQuest = 2, NameQuest = "DeepForestIsland2", NameMon = "Musketeer Pirate", CFrameQuest = CFrame.new(-12680.38, 389.97, -9902.01), CFrameMon = CFrame.new(-13457.90, 391.54, -9859.17)}
        elseif MyLevel <= 1999 then
            CurrentQuest = {Mon = "Reborn Skeleton", LevelQuest = 1, NameQuest = "HauntedQuest1", NameMon = "Reborn Skeleton", CFrameQuest = CFrame.new(-9479.21, 141.21, 5566.09), CFrameMon = CFrame.new(-8763.72, 165.72, 6159.86)}
        elseif MyLevel <= 2024 then
            CurrentQuest = {Mon = "Living Zombie", LevelQuest = 2, NameQuest = "HauntedQuest1", NameMon = "Living Zombie", CFrameQuest = CFrame.new(-9479.21, 141.21, 5566.09), CFrameMon = CFrame.new(-10144.13, 138.62, 5838.08)}
        elseif MyLevel <= 2049 then
            CurrentQuest = {Mon = "Demonic Soul", LevelQuest = 1, NameQuest = "HauntedQuest2", NameMon = "Demonic Soul", CFrameQuest = CFrame.new(-9516.99, 172.01, 6078.46), CFrameMon = CFrame.new(-9505.87, 172.10, 6158.99)}
        elseif MyLevel <= 2074 then
            CurrentQuest = {Mon = "Posessed Mummy", LevelQuest = 2, NameQuest = "HauntedQuest2", NameMon = "Posessed Mummy", CFrameQuest = CFrame.new(-9516.99, 172.01, 6078.46), CFrameMon = CFrame.new(-9582.02, 6.25, 6205.47)}
        elseif MyLevel <= 2099 then
            CurrentQuest = {Mon = "Peanut Scout", LevelQuest = 1, NameQuest = "NutsIslandQuest", NameMon = "Peanut Scout", CFrameQuest = CFrame.new(-2104.39, 38.10, -10194.21), CFrameMon = CFrame.new(-2143.24, 47.72, -10029.99)}
        elseif MyLevel <= 2124 then
            CurrentQuest = {Mon = "Peanut President", LevelQuest = 2, NameQuest = "NutsIslandQuest", NameMon = "Peanut President", CFrameQuest = CFrame.new(-2104.39, 38.10, -10194.21), CFrameMon = CFrame.new(-1859.35, 38.10, -10422.42)}
        elseif MyLevel <= 2149 then
            CurrentQuest = {Mon = "Ice Cream Chef", LevelQuest = 1, NameQuest = "IceCreamIslandQuest", NameMon = "Ice Cream Chef", CFrameQuest = CFrame.new(-820.64, 65.81, -10965.79), CFrameMon = CFrame.new(-872.24, 65.81, -10919.95)}
        elseif MyLevel <= 2199 then
            CurrentQuest = {Mon = "Ice Cream Commander", LevelQuest = 2, NameQuest = "IceCreamIslandQuest", NameMon = "Ice Cream Commander", CFrameQuest = CFrame.new(-820.64, 65.81, -10965.79), CFrameMon = CFrame.new(-558.06, 112.04, -11290.77)}
        elseif MyLevel <= 2224 then
            CurrentQuest = {Mon = "Cookie Crafter", LevelQuest = 1, NameQuest = "CakeQuest1", NameMon = "Cookie Crafter", CFrameQuest = CFrame.new(-2021.32, 37.79, -12028.72), CFrameMon = CFrame.new(-2374.13, 37.79, -12125.30)}
        elseif MyLevel <= 2249 then
            CurrentQuest = {Mon = "Cake Guard", LevelQuest = 2, NameQuest = "CakeQuest1", NameMon = "Cake Guard", CFrameQuest = CFrame.new(-2021.32, 37.79, -12028.72), CFrameMon = CFrame.new(-1598.30, 43.77, -12244.58)}
        elseif MyLevel <= 2274 then
            CurrentQuest = {Mon = "Baking Staff", LevelQuest = 1, NameQuest = "CakeQuest2", NameMon = "Baking Staff", CFrameQuest = CFrame.new(-1927.91, 37.79, -12842.53), CFrameMon = CFrame.new(-1887.80, 77.61, -12998.35)}
        elseif MyLevel <= 2299 then
            CurrentQuest = {Mon = "Head Baker", LevelQuest = 2, NameQuest = "CakeQuest2", NameMon = "Head Baker", CFrameQuest = CFrame.new(-1927.91, 37.79, -12842.53), CFrameMon = CFrame.new(-2216.18, 82.88, -12869.29)}
        elseif MyLevel <= 2324 then
            CurrentQuest = {Mon = "Cocoa Warrior", LevelQuest = 1, NameQuest = "ChocQuest1", NameMon = "Cocoa Warrior", CFrameQuest = CFrame.new(233.22, 29.87, -12201.23), CFrameMon = CFrame.new(-21.55, 80.57, -12352.38)}
        elseif MyLevel <= 2349 then
            CurrentQuest = {Mon = "Chocolate Bar Battler", LevelQuest = 2, NameQuest = "ChocQuest1", NameMon = "Chocolate Bar Battler", CFrameQuest = CFrame.new(233.22, 29.87, -12201.23), CFrameMon = CFrame.new(582.59, 77.18, -12463.16)}
        elseif MyLevel <= 2374 then
            CurrentQuest = {Mon = "Sweet Thief", LevelQuest = 1, NameQuest = "ChocQuest2", NameMon = "Sweet Thief", CFrameQuest = CFrame.new(150.50, 30.69, -12774.50), CFrameMon = CFrame.new(165.18, 76.05, -12600.83)}
        elseif MyLevel <= 2399 then
            CurrentQuest = {Mon = "Candy Rebel", LevelQuest = 2, NameQuest = "ChocQuest2", NameMon = "Candy Rebel", CFrameQuest = CFrame.new(150.50, 30.69, -12774.50), CFrameMon = CFrame.new(134.86, 77.24, -12876.54)}
        elseif MyLevel <= 2424 then
            CurrentQuest = {Mon = "Candy Pirate", LevelQuest = 1, NameQuest = "CandyQuest1", NameMon = "Candy Pirate", CFrameQuest = CFrame.new(-1150.04, 20.37, -14446.33), CFrameMon = CFrame.new(-1310.50, 26.01, -14562.40)}
        elseif MyLevel <= 2449 then
            CurrentQuest = {Mon = "Snow Demon", LevelQuest = 2, NameQuest = "CandyQuest1", NameMon = "Snow Demon", CFrameQuest = CFrame.new(-1150.04, 20.37, -14446.33), CFrameMon = CFrame.new(-880.20, 71.24, -14538.60)}
        elseif MyLevel <= 2474 then
            CurrentQuest = {Mon = "Isle Outlaw", LevelQuest = 1, NameQuest = "TikiQuest1", NameMon = "Isle Outlaw", CFrameQuest = CFrame.new(-16547.74, 61.13, -173.41), CFrameMon = CFrame.new(-16442.81, 116.13, -264.46)}
        elseif MyLevel <= 2524 then
            CurrentQuest = {Mon = "Island Boy", LevelQuest = 2, NameQuest = "TikiQuest1", NameMon = "Island Boy", CFrameQuest = CFrame.new(-16547.74, 61.13, -173.41), CFrameMon = CFrame.new(-16901.26, 84.06, -192.88)}
        else
            CurrentQuest = {Mon = "Skull Slayer", LevelQuest = 2, NameQuest = "TikiQuest3", NameMon = "Skull Slayer", CFrameQuest = CFrame.new(-16661.89, 105.28, 1576.69), CFrameMon = CFrame.new(-16885.20, 114.12, 1627.94)}
        end
    end
end

local FullIslandLocations = {
    Sea1 = {
        ["Windmill"] = CFrame.new(979.79, 16.51, 1429.04),
        ["Jungle"] = CFrame.new(-1612.79, 36.85, 149.12),
        ["Pirate Village"] = CFrame.new(-1181.30, 4.75, 3803.54),
        ["Desert"] = CFrame.new(944.15, 20.91, 4373.30),
        ["Snow Island"] = CFrame.new(1347.80, 104.66, -1319.73),
        ["Marineford"] = CFrame.new(-4914.82, 50.96, 4281.02),
        ["Colosseum"] = CFrame.new(-1427.62, 7.28, -2792.77),
        ["Sky Island"] = CFrame.new(-4869.10, 733.46, -2667.01),
        ["Prison"] = CFrame.new(4875.33, 5.65, 734.85),
        ["Magma Village"] = CFrame.new(-5247.71, 12.88, 8504.96),
        ["Fountain City"] = CFrame.new(5259.81, 37.35, 4050.02),
    },
    Sea2 = {
        ["Cafe"] = CFrame.new(-380.47, 77.22, 255.82),
        ["Green Zone"] = CFrame.new(-2448.53, 73.01, -3210.63),
        ["Cursed Ship"] = CFrame.new(923.40, 125.05, 32885.87),
        ["Ice Castle"] = CFrame.new(6148.41, 294.38, -6741.11),
        ["Hot & Cold"] = CFrame.new(-5428.03, 15.06, -5299.43),
        ["Snow Mountain"] = CFrame.new(609.85, 400.11, -5372.25),
        ["Graveyard"] = CFrame.new(-5497.06, 47.59, -795.23),
        ["Factory"] = CFrame.new(632.69, 73.10, 918.66),
        ["Colosseum Sea 2"] = CFrame.new(-1580.04, 6.35, -2986.47),
        ["Dark Arena"] = CFrame.new(1000, 100, 1000),
    },
    Sea3 = {
        ["Mansion"] = CFrame.new(-12471.16, 374.94, -7551.67),
        ["Port Town"] = CFrame.new(-290.73, 6.72, 5343.55),
        ["Hydra Island"] = CFrame.new(5291.24, 1005.44, 393.76),
        ["Floating Turtle"] = CFrame.new(-13274.52, 531.82, -7579.22),
        ["Haunted Castle"] = CFrame.new(-9515.37, 164.00, 5786.06),
        ["Tiki Outpost"] = CFrame.new(-16218.68, 9.08, 445.61),
        ["Great Tree"] = CFrame.new(2180.54, 27.81, -6741.54),
        ["Castle on the Sea"] = CFrame.new(-5039.58, 27.35, 4324.68),
        ["Cake Land"] = CFrame.new(-2021.32, 37.79, -12028.72),
        ["Peanut Island"] = CFrame.new(-2104.39, 38.10, -10194.21),
    }
}

local DungeonChips = {
    "Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Dough"
}

local BossList = (World1 and {
    "The Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral",
    "Saber Expert", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord",
    "Wysper", "Thunder God", "Cyborg", "Ice Admiral", "Greybeard", "Darkbeard"
}) or (World2 and {
    "Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral",
    "Tide Keeper", "Darkbeard", "Cursed Captain", "Order"
}) or (World3 and {
    "Stone", "Hydra Leader", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate",
    "Cake Queen", "Longma", "Soul Reaper", "Dough King", "Katakuri", "Island Boy"
})

local MaterialList = (World1 and {
    "Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail", "Wood Planks"
}) or (World2 and {
    "Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet",
    "Magma Ore", "Vampire Fang"
}) or (World3 and {
    "Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder",
    "Fish Tail", "Mini Tusk", "Azure Ember"
})

local MobSpecificTeleports = {
    ["Darkbeard"] = CFrame.new(1000, 100, 1000),
    ["Longma"] = CFrame.new(-13510, 584, -6987),
    ["Terrorshark"] = CFrame.new(-40000, 30, -2000),
    ["Leviathan"] = CFrame.new(-148073.35, 9.00, 7721.05),
    ["Tide Keeper"] = CFrame.new(6148.41, 294.38, -6741.11),
    ["Thunder God"] = CFrame.new(-4869.10, 733.46, -2667.01),
    ["Don Swan"] = CFrame.new(638.43, 71.76, 918.28),
    ["Cursed Captain"] = CFrame.new(923.40, 125.05, 32885.87),
    ["Order"] = CFrame.new(-408.09, 16.04, 247.43),
    ["Indra"] = CFrame.new(-12471.16, 374.94, -7551.67),
    ["Kitsune Island"] = CFrame.new(-16526, 108, 752),
    ["Mirage Island"] = CFrame.new(29221.82, 14890.97, -205.99),
    ["Prehistoric Island"] = CFrame.new(-16471, 528, 539),
    ["Island Boy"] = CFrame.new(-16901.26, 84.06, -192.88),
}

local ZoneCFrames = {
    ["Zone 1"] = CFrame.new(-21998.37, 30.00, -682.30),
    ["Zone 2"] = CFrame.new(-26779.52, 30.00, -822.85),
    ["Zone 3"] = CFrame.new(-31171.95, 30.00, -2256.93),
    ["Zone 4"] = CFrame.new(-34054.68, 30.21, -2560.12),
    ["Zone 5"] = CFrame.new(-38887.55, 30.00, -2162.99),
    ["Zone 6"] = CFrame.new(-44541.76, 30.00, -1244.85),
    ["Infinite"] = CFrame.new(-148073.35, 9.00, 7721.05)
}

local function GetMaterialConfig(mat: string): ({string}, CFrame)
    if mat == "Radioactive Material" and World2 then return {"Factory Staff"}, CFrame.new(-507.78, 72.99, -126.45)
    elseif mat == "Mystic Droplet" and World2 then return {"Water Fighter"}, CFrame.new(-3352.90, 285.01, -10534.84)
    elseif mat == "Magma Ore" and World1 then return {"Military Spy"}, CFrame.new(-5850.28, 77.28, 8848.67)
    elseif mat == "Magma Ore" and World2 then return {"Lava Pirate"}, CFrame.new(-5234.60, 51.95, -4732.27)
    elseif mat == "Angel Wings" and World1 then return {"Royal Soldier"}, CFrame.new(-7827.15, 5606.91, -1705.58)
    elseif mat == "Leather + Scrap Metal" and World1 then return {"Pirate", "Brute"}, CFrame.new(-1211.87, 4.78, 3916.83)
    elseif mat == "Leather + Scrap Metal" and World2 then return {"Marine Captain", "Mercenary"}, CFrame.new(-2010.50, 73.00, -3326.62)
    elseif mat == "Scrap Metal" and World3 then return {"Pirate Millionaire"}, CFrame.new(-289.63, 43.82, 5583.66)
    elseif mat == "Ectoplasm" and World2 then return {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"}, CFrame.new(911.35, 125.95, 33159.53)
    elseif mat == "Conjured Cocoa" and World3 then return {"Chocolate Bar Battler"}, CFrame.new(744.79, 24.76, -12637.72)
    elseif mat == "Dragon Scale" and World3 then return {"Dragon Crew Warrior"}, CFrame.new(5824.06, 51.38, -1106.69)
    elseif mat == "Gunpowder" and World3 then return {"Pistol Billionaire"}, CFrame.new(-379.61, 73.84, 5928.52)
    elseif mat == "Fish Tail" and World3 then return {"Fishman Captain"}, CFrame.new(-10961.01, 331.79, -8914.29)
    elseif mat == "Mini Tusk" and World3 then return {"Mythological Pirate"}, CFrame.new(-13516.04, 469.81, -6899.16)
    elseif mat == "Vampire Fang" and World2 then return {"Vampire"}, CFrame.new(-6037.66, 32.18, -1340.65)
    elseif mat == "Demonic Wisp" and World3 then return {"Demonic Soul"}, CFrame.new(-9579, 6, 6194)
    elseif mat == "Wood Planks" and World3 then return {"Tree"}, CFrame.new(-16471, 528, 539)
    elseif mat == "Azure Ember" and World3 then return {"Kitsune Shrine"}, CFrame.new(-16526, 108, 752)
    end
    return {}, CFrame.new(0,0,0)
end

--------------------------------------------------------------------------------
-- 6. دمج واجهة AetherUI والتابات الكاملة
--------------------------------------------------------------------------------
local AetherUI = nil
local success_ui, err_ui = pcall(function()
    AetherUI = loadstring(game:HttpGet("https://pastebin.com/raw/yeULgMe0"))()
end)

if not success_ui or not AetherUI then
    warn("Haroon Hub: Failed to load AetherUI library. Error:", err_ui)
    return
end

AetherUI:InitLoadingScreen("Haroon Hub V12 Ultimate Master Edition", "Initializing Fruits, Raids & Safe Motors...", function()
    AetherUI:InitKeySystem({"HAROON-2025-VIP", "HAROON-KEY-100"}, function()
        AetherUI:Notify({Title = "🔥 Haroon Hub V12 Active", Content = "تم دمج مكتبتك بالنظام الجديد بنجاح 100%!", Duration = 4})

        local Window = AetherUI:CreateWindow({
            Title = "Haroon Hub | Blox Fruits Master",
            Subtitle = "by: 3amek4222",
            ToggleKey = Enum.KeyCode.RightControl
        })

        local MainTab = Window:CreateTab("Main", "rbxassetid://6034287594")
        local CombatTab = Window:CreateTab("Combat", "rbxassetid://6034834832")
        local FruitsTab = Window:CreateTab("Fruits Tab", "rbxassetid://6034453535")
        local RaidTab = Window:CreateTab("Dungeon / Raid", "rbxassetid://6034834832")
        local FarmingQuestsTab = Window:CreateTab("Farming Quests", "rbxassetid://6034453535")
        local RaceTab = Window:CreateTab("Race V4 & Mirage", "rbxassetid://6034453535")
        local SubFarmTab = Window:CreateTab("Sub Farming", "rbxassetid://6034834832")
        local CakeTab = Window:CreateTab("Cake & Dough", "rbxassetid://6034453535")
        local SeaTab = Window:CreateTab("Sea Farming", "rbxassetid://6034453535")
        local AutoQuestsTab = Window:CreateTab("Auto Quests", "rbxassetid://6034453535")
        local TeleportsTab = Window:CreateTab("Teleports", "rbxassetid://6034453535")
        local VisualTab = Window:CreateTab("Visuals & ESP", "rbxassetid://6034453535")
        local MiscTab = Window:CreateTab("Misc", "rbxassetid://6031280882")
        local SettingsTab = Window:CreateTab("Settings", "rbxassetid://6031280882")

        ---------------------------------------------------------
        -- 📌 1. TAB: MAIN
        ---------------------------------------------------------
        MainTab:CreateSection("خيارات التلفيل الأساسية (Level Farm)")

        MainTab:CreateToggle("تفعيل التجميع التلقائي (Auto Farm Level)", "AutoFarmFlag", false, function(state)
            _G.Settings.Main["Auto Farm Level"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateToggle("تضمين مهمات الزعماء بالتلفيل (Include Bosses)", "IncludeBossQuestFlag", false, function(state)
            _G.Settings.Main["Include Boss Quests"] = state
        end)

        MainTab:CreateDropdown("اختر السلاح الفعال (Weapon)", "WeaponFlag", {"Melee", "Sword", "Blox Fruit", "Gun"}, "Melee", function(selected)
            _G.Settings.Main["Select Weapon"] = selected
        end)

        MainTab:CreateSlider("ارتفاع الطيران فوق العدو (Farm Distance)", "FarmDistFlag", 10, 50, 28, function(val)
            _G.Settings.Main["Farm Distance"] = val
        end)

        MainTab:CreateSlider("سرعة الانتقال الآمنة (Safe Tween Speed)", "TweenSpeedFlag", 100, 300, 180, function(val)
            _G.Settings.Main["Player Tween Speed"] = val
        end)

        MainTab:CreateToggle("الضرب السريع الخارق (Fast Attack)", "FastAttackFlag", false, function(state)
            _G.Settings.Main["Fast Attack"] = state
        end)

        MainTab:CreateSection("تجميع الماتيريال (Auto Farm Materials)")

        MainTab:CreateDropdown("اختر الماتيريال (Select Material)", "MatDropdownFlag", MaterialList, MaterialList[1], function(selected)
            _G.Settings.Main["Selected Material"] = selected
        end)

        MainTab:CreateToggle("تفعيل تجميع الماتيريال (Farm Material)", "FarmMatFlag", false, function(state)
            _G.Settings.Main["Auto Farm Material"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateSection("قتل الزعماء (Auto Farm Bosses)")

        MainTab:CreateDropdown("اختر البوس (Select Boss)", "BossDropdownFlag", BossList, BossList[1], function(selected)
            _G.Settings.Main["Selected Boss"] = selected
        end)

        MainTab:CreateToggle("تفعيل قتل البوس المحدد (Auto Farm Boss)", "FarmBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm Boss"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateToggle("تفعيل قتل جميع البوسات المتوفرة (Farm All Bosses)", "FarmAllBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm All Boss"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 2. TAB: COMBAT (PVP)
        ---------------------------------------------------------
        CombatTab:CreateSection("قتال اللاعبين والـ PVP")

        local playerList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(playerList, p.Name) end
        end

        CombatTab:CreateDropdown("اختر اللاعب المستهدف", "PVPPlayerDropdown", playerList, playerList[1] or "None", function(selected)
            _G.Settings.Combat["Selected Player"] = selected
        end)

        CombatTab:CreateToggle("مراقبة اللاعب (Spectate Player)", "SpectateFlag", false, function(state)
            _G.Settings.Combat["Spectate Player"] = state
            if state and _G.Settings.Combat["Selected Player"] then
                local target = Players:FindFirstChild(_G.Settings.Combat["Selected Player"])
                if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                    workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
                end
            else
                local char, hum = GetCharacter()
                if char and hum then
                    workspace.CurrentCamera.CameraSubject = hum
                end
            end
        end)

        CombatTab:CreateToggle("الانتقال إلى اللاعب (Teleport To Player)", "TPPlayerFlag", false, function(state)
            _G.Settings.Combat["Teleport To Player"] = state
            if not state then StopTween() end
            task.spawn(function()
                while _G.Settings.Combat["Teleport To Player"] do
                    task.wait()
                    pcall(function()
                        local target = Players:FindFirstChild(_G.Settings.Combat["Selected Player"])
                        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            TweenPlayer(target.Character.HumanoidRootPart.CFrame)
                        end
                    end)
                end
            end)
        end)

        CombatTab:CreateToggle("تصويب المسدسات التلقائي (Aimbot Gun)", "AimbotGunFlag", false, function(state)
            _G.Settings.Combat["Aimbot Gun"] = state
        end)

        CombatTab:CreateSection("خيارات الهروب والعودة في الـ PVP")
        CombatTab:CreateToggle("تفعيل الهروب والعودة التلقائي (Auto PvP Escape)", "AutoPvPEscapeFlag", false, function(state)
            _G.Settings.Combat["Auto PvP Escape"] = state
            if not state then StopTween() end
        end)
        CombatTab:CreateSlider("نسبة HP للهروب (Escape HP %)", "EscapeHPSlider", 10, 90, 30, function(val)
            _G.Settings.Combat["Escape HP %"] = val
        end)
        CombatTab:CreateSlider("نسبة HP للعودة (Return HP %)", "ReturnHPSlider", 20, 100, 70, function(val)
            _G.Settings.Combat["Return HP %"] = val
        end)

        ---------------------------------------------------------
        -- 📌 3. TAB: FRUITS TAB
        ---------------------------------------------------------
        FruitsTab:CreateSection("نظام الفواكه والتخزين (Blox Fruits Engine)")
        
        FruitsTab:CreateToggle("🍎 Fruit Notifier (ESP)", "FruitESPFlag", false, function(state)
            _G.Settings.Fruits["Fruit ESP"] = state
            _G.Settings.Visuals["ESP Fruits"] = state
        end)

        FruitsTab:CreateToggle("🏃 Fruit Sniper (Auto-Collect)", "FruitSniperFlag", false, function(state)
            _G.Settings.Fruits["Fruit Sniper"] = state
            if not state then StopTween() end
        end)

        FruitsTab:CreateToggle("🔄 Auto-Store Fruit", "AutoStoreFruitFlag", false, function(state)
            _G.Settings.Fruits["Auto Store Fruit"] = state
        end)

        FruitsTab:CreateButton("🗺️ Show All Fruit Locations", function()
            _G.Settings.Fruits["Show All Fruits"] = true
            AetherUI:Notify({Title = "Fruits Scanner", Content = "جاري مسح كافة الفواكه على الخريطة...", Duration = 3})
            task.wait(5)
            _G.Settings.Fruits["Show All Fruits"] = false
        end)

        FruitsTab:CreateButton("🛒 Buy Random Fruit (Cousin)", function()
            if CommF_ then
                local res = CommF_:InvokeServer("Cousin", "Buy")
                AetherUI:Notify({Title = "Fruit Dealer", Content = tostring(res), Duration = 4})
            end
        end)

        ---------------------------------------------------------
        -- 📌 4. TAB: DUNGEON / RAID (Auto Next Island المستخرج)
        ---------------------------------------------------------
        RaidTab:CreateSection("نظام الـ Dungeon و غارات الفواكه (Dungeon System)")

        RaidTab:CreateDropdown("Select Raid Chip (اختر شريحة الريد)", "DungeonChipDropdown", DungeonChips, DungeonChips[1], function(selected)
            _G.Settings.Raid["Selected Chip"] = selected
        end)

        RaidTab:CreateToggle("⚡ Auto Dungeon / Fruits Raid (تفعيل الريد)", "AutoDungeonFlag", false, function(state)
            _G.Settings.Raid["Auto Dungeon / Raid"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("🛒 Buy Chip & Start Raid (شراء وبدء تلقائي)", "AutoBuyStartRaidFlag", false, function(state)
            _G.Settings.Raid["Auto Buy Chip & Start"] = state
        end)

        RaidTab:CreateToggle("⚔️ Auto Clear Dungeon Waves (مسح وحوش الريد)", "AutoClearDungeonFlag", false, function(state)
            _G.Settings.Raid["Auto Clear Dungeon Waves"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("🏝️ Auto Next Island (الانتقال للجزيرة التالية تلقائياً)", "AutoNextIslandFlag", false, function(state)
            _G.Settings.Raid["Auto Next Island"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("✨ Auto Awaken Skills (إيقاظ المهارات التلقائي)", "AutoAwakenSkillsFlag", false, function(state)
            _G.Settings.Raid["Auto Awaken"] = state
        end)

        RaidTab:CreateToggle("⚡ Law Raid (ريد لاو التلقائي)", "LawRaidFlag", false, function(state)
            _G.Settings.Raid["Law Raid"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 5. TAB: FARMING QUESTS (CDK & TTK المستخرج بالكامل)
        ---------------------------------------------------------
        FarmingQuestsTab:CreateSection("مهمات السيوف الأسطورية (Legendary Swords)")

        FarmingQuestsTab:CreateDropdown("اختر مهمة السيف", "SwordQuestDropdown", {"Saber V2", "Yama", "Tushita"}, "Saber V2", function(selected)
            _G.Settings.FarmingQuests["Selected Sword Quest"] = selected
        end)

        FarmingQuestsTab:CreateToggle("تفعيل أتمتة مهمة السيف", "AutoSwordQuestFlag", false, function(state)
            _G.Settings.FarmingQuests["Auto Sword Quest"] = state
            if not state then StopTween() end
        end)

        FarmingQuestsTab:CreateSection("مهمات السيوف المدمجة الأسطورية (CDK & TTK Engine)")

        FarmingQuestsTab:CreateToggle("⚔️ أتمتة Cursed Dual Katana بالكامل (Auto CDK)", "AutoFarmCDKFlag", false, function(state)
            _G.Settings.FarmingQuests["Auto Farm CDK"] = state
            if not state then StopTween() end
        end)

        FarmingQuestsTab:CreateToggle("⚔️ أتمتة True Triple Katana بالكامل (Auto TTK)", "AutoFarmTTKFlag", false, function(state)
            _G.Settings.FarmingQuests["Auto Farm TTK"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 6. TAB: RACE V2, V3, V4 & MIRAGE (النظام المستخرج الكامل)
        ---------------------------------------------------------
        RaceTab:CreateSection("ترقية الأجناس (Race V2 & V3 Quests)")

        RaceTab:CreateToggle("🧬 أتمتة مهمة Race V2 (Auto Race V2 Quest)", "AutoRaceV2QuestFlag", false, function(state)
            _G.Settings.Race["Auto Race V2 Quest"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateDropdown("اختر مهمة Race V3", "RaceV3QuestDropdown", {"Human", "Fishman", "Skypian", "Mink", "Ghoul", "Cyborg"}, "Human", function(selected)
            _G.Settings.Race["Selected Race V3"] = selected
        end)

        RaceTab:CreateToggle("🧬 أتمتة مهمة Race V3 (Auto Race V3 Quest)", "AutoRaceV3QuestFlag", false, function(state)
            _G.Settings.Race["Auto Race V3 Quest"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("تفعيل مهارة V3 تلقائياً (Auto Race V3 Ability)", "AutoV3AbilityFlag", false, function(state)
            _G.Settings.Race["Auto Race V3 Ability"] = state
            task.spawn(function()
                while _G.Settings.Race["Auto Race V3 Ability"] do
                    task.wait(1)
                    if CommE then pcall(function() CommE:FireServer("ActivateAbility") end) end
                end
            end)
        end)

        RaceTab:CreateSection("حزمة الميراج و الترس الأزرق (Mirage Island Suite)")

        RaceTab:CreateToggle("🏝️ البحث التلقائي عن Mirage Island والإبحار لها", "AutoFindMirageFlag", false, function(state)
            _G.Settings.Race["Auto Find Mirage"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("🏔️ الانتقال لقمة الميراج (Tween To Highest Mirage)", "TweenMirageFlag", false, function(state)
            _G.Settings.Race["Tween To Highest Mirage"] = state
            if not state then StopTween() end
            task.spawn(function()
                while _G.Settings.Race["Tween To Highest Mirage"] do
                    task.wait()
                    pcall(function()
                        if workspace.Map:FindFirstChild("MysticIsland") then
                            for _, v in pairs(workspace.Map.MysticIsland:GetDescendants()) do
                                if v:IsA("MeshPart") and v.MeshId == "rbxassetid://6745037796" then
                                    TweenPlayer(v.CFrame, Vector3.new(0, 212, 0))
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("⚙️ الانتقال وأخذ الترس الأزرق (Teleport to Gear)", "TeleportToGearFlag", false, function(state)
            _G.Settings.Race["Teleport To Blue Gear"] = state
            if not state then StopTween() end
            task.spawn(function()
                while _G.Settings.Race["Teleport To Blue Gear"] do
                    task.wait(0.2)
                    pcall(function()
                        if workspace.Map:FindFirstChild("MysticIsland") then
                            for _, v in pairs(workspace.Map.MysticIsland:GetChildren()) do
                                if v:IsA("MeshPart") and (v.Material == Enum.Material.Neon or string.find(v.Name:lower(), "gear")) then
                                    TweenPlayer(v.CFrame)
                                    if (LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude < 15 then
                                        if CommF_ then CommF_:InvokeServer("InteractGear", v) end
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("🌕 النظر للقمر وتفعيل المهارة (Look Moon)", "LookMoonFlag", false, function(state)
            _G.Settings.Race["Look Moon Ability"] = state
            task.spawn(function()
                while _G.Settings.Race["Look Moon Ability"] do
                    task.wait()
                    pcall(function()
                        local moonDir = game.Lighting:GetMoonDirection()
                        local lookAtPos = workspace.CurrentCamera.CFrame.p + moonDir * 100
                        workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.p, lookAtPos)
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("🚪 الانتقال لباب الترايل تلقائياً (Teleport To Race Door)", "TPDoorFlag", false, function(state)
            _G.Settings.Race["Teleport To Race Door"] = state
            if not state then StopTween() end
            if state then
                local myRace = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Race")) and LocalPlayer.Data.Race.Value or "Human"
                local raceDoors = {
                    ["Human"] = CFrame.new(29221.82, 14890.97, -205.99),
                    ["Skypian"] = CFrame.new(28960.15, 14919.62, 235.03),
                    ["Fishman"] = CFrame.new(28231.17, 14890.97, -211.64),
                    ["Cyborg"] = CFrame.new(28502.68, 14895.97, -423.72),
                    ["Ghoul"] = CFrame.new(28674.24, 14890.67, 445.43),
                    ["Mink"] = CFrame.new(29012.34, 14890.97, -380.14)
                }
                local char, hrp = GetCharacter()
                if char and hrp then
                    hrp.CFrame = CFrame.new(28286.35, 14895.30, 102.62)
                    task.wait(0.3)
                    if raceDoors[myRace] then TweenPlayer(raceDoors[myRace]) end
                end
            end
        end)

        RaceTab:CreateSection("التدريب واجتياز الترايل (Race V4 Train & Trial)")

        RaceTab:CreateToggle("التدريب التلقائي للـ V4 (Auto Train)", "AutoTrainFlag", false, function(state)
            _G.Settings.Race["Auto Train"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("اجتياز الترايل تلقائياً (Auto Trial)", "AutoTrialFlag", false, function(state)
            _G.Settings.Race["Auto Trial"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 7. TAB: SUB FARMING
        ---------------------------------------------------------
        SubFarmTab:CreateSection("صياد النخبة والعظام (Elite & Bones)")

        SubFarmTab:CreateToggle("صياد النخبة التلقائي (Auto Elite Hunter)", "EliteFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("صياد النخبة مع السيرفر هوب (Elite Hop)", "EliteHopFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter Hop"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("تجميع العظام التلقائي (Auto Farm Bones)", "BoneFlag", false, function(state)
            _G.Settings.SubFarm["Auto Farm Bone"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateSection("تجميع الصناديق التلقائي (Auto Chests)")

        SubFarmTab:CreateToggle("جمع الصناديق بالطيران (Chest Tween)", "ChestTweenFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Tween"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("جمع الصناديق الفوري (Chest Instant)", "ChestInstantFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Instant"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("توقف عند الحصول على دروب نادر (Stop on Items)", "StopItemsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Stop Items"] = state
        end)

        SubFarmTab:CreateSection("تلفيل الماستري التلقائي (Auto Mastery)")

        SubFarmTab:CreateToggle("تلفيل ماستري Melee (لـ 400)", "AutoMasteryMeleeFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Melee"] = state
            if not state then StopTween() end
        end)
        SubFarmTab:CreateToggle("تلفيل ماستري Swords (لـ 400)", "AutoMasterySwordsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Swords"] = state
            if not state then StopTween() end
        end)
        SubFarmTab:CreateToggle("تلفيل ماستري Blox Fruits (لـ 400)", "AutoMasteryBloxFruitsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Blox Fruits"] = state
            if not state then StopTween() end
        end)
        SubFarmTab:CreateToggle("تلفيل ماستري Guns (لـ 400)", "AutoMasteryGunsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Guns"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 8. TAB: CAKE PRINCE & DOUGH KING
        ---------------------------------------------------------
        CakeTab:CreateSection("الكيك برنس و دو كينغ")

        CakeTab:CreateToggle("تلفيل وقتل الكاتكوري بالكامل (Auto Katakuri)", "KatakuriFlag", false, function(state)
            _G.Settings.Cake["Auto Katakuri"] = state
            if not state then StopTween() end
        end)

        CakeTab:CreateToggle("استدعاء الكيك برنس التلقائي (Auto Spawn Prince)", "SpawnPrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Spawn Cake Prince"] = state
        end)

        CakeTab:CreateToggle("قتل الكيك برنس فور ظهوره (Auto Kill Cake Prince)", "KillPrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Cake Prince"] = state
            if not state then StopTween() end
        end)

        CakeTab:CreateToggle("قتل دو كينغ فور ظهوره (Auto Kill Dough King)", "KillDoughFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Dough King"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 9. TAB: SEA FARMING (Prehistoric & Draco Trail)
        ---------------------------------------------------------
        SeaTab:CreateSection("الجزيرة القديمة وما قبل التاريخ (Prehistoric Engine)")

        SeaTab:CreateButton("🏝️ Teleport Prehistoric Island (انتقال فوري)", function()
            TweenPlayer(MobSpecificTeleports["Prehistoric Island"])
            AetherUI:Notify({Title = "Teleport", Content = "جاري الانتقال إلى الجزيرة القديمة...", Duration = 2})
        end)

        SeaTab:CreateToggle("🦖 أتمتة الجزيرة القديمة (Auto Prehistoric Island)", "AutoPrehistoricFlag", false, function(state)
            _G.Settings.Sea["Auto Prehistoric Island"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🔥 إنهاء الجزيرة والشعلات (Auto Complete Prehistoric Island)", "AutoCompletePrehistoricFlag", false, function(state)
            _G.Settings.Sea["Auto Complete Prehistoric Island"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🐉 تدريب دراكو وقهر الوحوش (Auto Draco Trail)", "AutoDracoTrailFlag", false, function(state)
            _G.Settings.Sea["Auto Draco Trail"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateSection("إبحار وأحداث البحر والبحث عن الجزر")

        SeaTab:CreateDropdown("اختر القارب (Select Boat)", "BoatDropdownFlag", {"Guardian", "Beast Hunter", "PirateGrandBrigade", "MarineGrandBrigade"}, "Guardian", function(selected)
            _G.Settings.Sea["Selected Boat"] = selected
        end)

        SeaTab:CreateDropdown("اختر منطقة الإبحار (Select Zone)", "ZoneDropdownFlag", {"Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5", "Zone 6", "Infinite"}, "Zone 5", function(selected)
            _G.Settings.Sea["Selected Zone"] = selected
        end)

        SeaTab:CreateToggle("تفعيل الإبحار التلقائي (Sail Boat)", "SailBoatFlag", false, function(state)
            _G.Settings.Sea["Sail Boat"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateSection("قتال مخلوقات وحوش البحر (Sea Mobs Farming)")

        SeaTab:CreateToggle("🦈 قتل أسماك القرش (Auto Farm Shark)", "SharkFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Shark"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🐟 قتل البيرانا (Auto Farm Piranha)", "PiranhaFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Piranha"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🧜‍♂️ قتل طاقم الأسماك (Fish Crew Member)", "CrewFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Fish Crew Member"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("👻 قتل السفن الشبحية (Ghost Ship)", "GhostShipFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Ghost Ship"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🦖 قتل التيرور شارك (Terrorshark)", "TerrorFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Terrorshark"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🌊 قتل السي بيست (Seabeasts)", "SeabeastFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Seabeasts"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("🛡️ تفادي هجمات السي بيست (Dodge Seabeasts)", "DodgeSBFlag", true, function(state)
            _G.Settings.Sea["Dodge Seabeasts Attack"] = state
        end)

        SeaTab:CreateToggle("🦊 البحث التلقائي عن Kitsune Island والإبحار لها", "AutoFindKitsuneIslandFlag", false, function(state)
            _G.Settings.Sea["Auto Find Kitsune Island"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 10. TAB: AUTO QUESTS
        ---------------------------------------------------------
        AutoQuestsTab:CreateSection("أخذ وإنهاء المهمات المباشرة")

        AutoQuestsTab:CreateButton("أخذ مهمة القرود (Jungle Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "JungleQuest", 1) end
        end)
        AutoQuestsTab:CreateButton("أخذ مهمة القراصنة (Buggy Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "BuggyQuest1", 1) end
        end)
        AutoQuestsTab:CreateButton("إلغاء المهمة الحالية (Abandon Quest)", function()
            if CommF_ then CommF_:InvokeServer("AbandonQuest") end
        end)

        ---------------------------------------------------------
        -- 📌 11. TAB: TELEPORTS (أزرار للبحار وتوغلات للجزر)
        ---------------------------------------------------------
        TeleportsTab:CreateSection("الانتقال بين البحار (Sea Travel Buttons)")

        TeleportsTab:CreateButton("🌊 الانتقال إلى Sea 1 (World 1)", function()
            if CommF_ then CommF_:InvokeServer("TravelMain") end
        end)

        TeleportsTab:CreateButton("🌊 الانتقال إلى Sea 2 (World 2)", function()
            if CommF_ then CommF_:InvokeServer("TravelDressrosa") end
        end)

        TeleportsTab:CreateButton("🌊 الانتقال إلى Sea 3 (World 3)", function()
            if CommF_ then CommF_:InvokeServer("TravelZou") end
        end)

        TeleportsTab:CreateSection("انتقالات جزر العالم الأول (Sea 1 Toggles)")
        for islandName, cf in pairs(FullIslandLocations.Sea1) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("📍 انتقال إلى " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf)
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        TeleportsTab:CreateSection("انتقالات جزر العالم الثاني (Sea 2 Toggles)")
        for islandName, cf in pairs(FullIslandLocations.Sea2) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("📍 انتقال إلى " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf)
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        TeleportsTab:CreateSection("انتقالات جزر العالم الثالث (Sea 3 Toggles)")
        for islandName, cf in pairs(FullIslandLocations.Sea3) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("📍 انتقال إلى " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf)
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        ---------------------------------------------------------
        -- 📌 12. TAB: VISUALS & ESP (جميع التوغلات Off افتراضياً)
        ---------------------------------------------------------
        VisualTab:CreateSection("كاشفات العناصر ورادار المسافات (All Toggles Off)")

        VisualTab:CreateToggle("👤 ESP Players (كاشف اللاعبين)", "ESPPlayersFlag", false, function(state)
            _G.Settings.Visuals["ESP Players"] = state
        end)

        VisualTab:CreateToggle("💀 ESP Bosses (كاشف الزعماء)", "ESPBossesFlag", false, function(state)
            _G.Settings.Visuals["ESP Bosses"] = state
        end)

        VisualTab:CreateToggle("🍎 ESP Fruits (كاشف الفواكه)", "ESPFruitsFlag", false, function(state)
            _G.Settings.Visuals["ESP Fruits"] = state
        end)

        VisualTab:CreateToggle("📦 ESP Chests (كاشف الصناديق)", "ESPChestsFlag", false, function(state)
            _G.Settings.Visuals["ESP Chests"] = state
        end)

        VisualTab:CreateToggle("👾 ESP Enemies (كاشف الوحوش والأعداء)", "ESPEnemiesFlag", false, function(state)
            _G.Settings.Visuals["ESP Enemies"] = state
        end)

        VisualTab:CreateToggle("🏝️ ESP Mirage Island", "ESPMirageFlag", false, function(state)
            _G.Settings.Visuals["ESP Mirage Island"] = state
        end)

        VisualTab:CreateToggle("🦊 ESP Kitsune Island", "ESPKitsuneFlag", false, function(state)
            _G.Settings.Visuals["ESP Kitsune Island"] = state
        end)

        ---------------------------------------------------------
        -- 📌 13. TAB: MISC (Auto Stats وحالة السيرفر)
        ---------------------------------------------------------
        MiscTab:CreateSection("توزيع النقاط التلقائي (Auto Stats Engine)")

        MiscTab:CreateDropdown("اختر الخاصية (Select Stat)", "SelectStatDropdown", {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}, "Melee", function(selected)
            _G.Settings.Stats["Selected Stat"] = selected
        end)

        MiscTab:CreateSlider("عدد النقاط لكل دورة (Points Per Tick)", "StatPointsSlider", 1, 100, 1, function(val)
            _G.Settings.Stats["Points Per Tick"] = val
        end)

        MiscTab:CreateToggle("⚡ تفعيل توزيع النقاط التلقائي (Auto Stats)", "AutoStatsToggleFlag", false, function(state)
            _G.Settings.Stats["Auto Stats"] = state
        end)

        MiscTab:CreateSection("حالة السيرفر والعدادات المباشرة (Server Status)")

        local serverClockParagraph = MiscTab:CreateParagraph({
            Title = "⏰ Server Clock Time (ساعة السيرفر)",
            Desc = "جارٍ التحميل...",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local playerTimeParagraph = MiscTab:CreateParagraph({
            Title = "⏱️ Time Connected In Server (مدة بقائك بالسيرفر)",
            Desc = "0 Hours 0 Minutes 0 Seconds",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local cakePrinceCountParagraph = MiscTab:CreateParagraph({
            Title = "👑 Cake Prince Status (عداد الأعداء المتبقي)",
            Desc = "جارٍ جلب البيانات الحية...",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local mirageStatusParagraph = MiscTab:CreateParagraph({
            Title = "🏝️ Mirage Island Status",
            Desc = "جارٍ الفحص...",
            Image = "rbxassetid://6034453535",
            ImageSize = 20
        })

        local kitsuneStatusParagraph = MiscTab:CreateParagraph({
            Title = "🦊 Kitsune Island Status",
            Desc = "جارٍ الفحص...",
            Image = "rbxassetid://6034453535",
            ImageSize = 20
        })

        task.spawn(function()
            while task.wait(1) do
                pcall(function()
                    local clockTime = game.Lighting.ClockTime
                    local hours = math.floor(clockTime)
                    local minutes = math.floor((clockTime - hours) * 60)
                    serverClockParagraph:SetDesc(string.format("%02d:%02d", hours, minutes))

                    local gameTime = math.floor(workspace.DistributedGameTime + 0.5)
                    local sH = math.floor(gameTime / 3600) % 24
                    local sM = math.floor(gameTime / 60) % 60
                    local sS = math.floor(gameTime) % 60
                    playerTimeParagraph:SetDesc(sH .. " Hours " .. sM .. " Minutes " .. sS .. " Seconds")

                    if World3 and CommF_ then
                        local princeData = CommF_:InvokeServer("CakePrinceSpawner")
                        if typeof(princeData) == "string" then
                            if string.find(princeData, "spawned") or string.find(princeData, "ready") then
                                cakePrinceCountParagraph:SetDesc("👑 Cake Prince Is Spawned! (تم استدعاء الكيك برنس!)")
                            else
                                local rem = string.match(princeData, "%d+")
                                cakePrinceCountParagraph:SetDesc(rem and ("⚔️ متبقي " .. rem .. " بوت/عدو لاستدعاء Cake Prince") or princeData)
                            end
                        end
                    else
                        cakePrinceCountParagraph:SetDesc("متوفر في العالم الثالث فقط (Sea 3 Only)")
                    end

                    local mirageIsland = workspace.Map:FindFirstChild("MysticIsland")
                    if mirageIsland then
                        local char, hrp = GetCharacter()
                        local dist = hrp and math.floor((hrp.Position - mirageIsland.WorldPivot.Position).Magnitude) or 0
                        mirageStatusParagraph:SetDesc("✅ ظهرت بالفعل! | المسافة: " .. dist .. "m")
                    else
                        mirageStatusParagraph:SetDesc("❌ لم تظهر بعد")
                    end

                    local kitsuneIsland = workspace.Map:FindFirstChild("KitsuneIsland")
                    if kitsuneIsland then
                        local char, hrp = GetCharacter()
                        local dist = hrp and math.floor((hrp.Position - kitsuneIsland.WorldPivot.Position).Magnitude) or 0
                        kitsuneStatusParagraph:SetDesc("✅ ظهرت بالفعل! | المسافة: " .. dist .. "m")
                    else
                        kitsuneStatusParagraph:SetDesc("❌ لم تظهر بعد")
                    end
                end)
            end
        end)

        MiscTab:CreateSection("إعدادات الفريق والـ Haki")

        MiscTab:CreateToggle("تفعيل الـ Ken (Buso Haki) تلقائياً", "AutoKenFlag", false, function(state)
            _G.Settings.Misc["Auto Ken (Buso Haki)"] = state
        end)

        MiscTab:CreateToggle("الانضمام إلى فريق المارينز", "SetTeamMarinesFlag", false, function(state)
            _G.Settings.Misc["Set Team to Marines"] = state
            if state and CommF_ then CommF_:InvokeServer("SetTeam", "Marines") end
        end)

        MiscTab:CreateToggle("الانضمام إلى فريق القراصنة", "SetTeamPiratesFlag", false, function(state)
            _G.Settings.Misc["Set Team to Pirates"] = state
            if state and CommF_ then CommF_:InvokeServer("SetTeam", "Pirates") end
        end)

        ---------------------------------------------------------
        -- 📌 14. TAB: SETTINGS
        ---------------------------------------------------------
        SettingsTab:CreateSection("إعدادات وتحكم السكربت")

        SettingsTab:CreateButton("إعادة دخول السيرفر (Rejoin)", function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)

        SettingsTab:CreateButton("إغلاق السكربت بالكامل (Destroy Hub)", function()
            local master = game:GetService("CoreGui"):FindFirstChild("HaroonHub_Master") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("HaroonHub_Master")
            if master then master:Destroy() end
        end)
    end)
end)

--------------------------------------------------------------------------------
-- 7. حلقة التلفيل الفردي والانتقال المباشر (Single-Target Master Loop)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.08) do
        if _G.Settings.Main["Auto Farm Level"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum or hum.Health <= 0 then return end

                CheckQuest()
                AutoHaki()

                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")

                if not questGui or not questGui.Visible or not string.find(questGui.Container.QuestTitle.Title.Text, CurrentQuest.NameMon) then
                    if CommF_ then CommF_:InvokeServer("AbandonQuest") end
                    TweenPlayer(CurrentQuest.CFrameQuest, Vector3.new(0, 5, 0))

                    if (hrp.Position - CurrentQuest.CFrameQuest.Position).Magnitude <= 20 then
                        if CommF_ then CommF_:InvokeServer("StartQuest", CurrentQuest.NameQuest, CurrentQuest.LevelQuest) end
                    end
                else
                    local targetMob = nil
                    local closestDistance = math.huge

                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v:IsA("Model") and v.Name == CurrentQuest.Mon then
                            local root = v:FindFirstChild("HumanoidRootPart")
                            local mobHum = v:FindFirstChildOfClass("Humanoid")
                            if root and mobHum and mobHum.Health > 0 then
                                local dist = (hrp.Position - root.Position).Magnitude
                                if dist < closestDistance then
                                    closestDistance = dist
                                    targetMob = v
                                end
                            end
                        end
                    end

                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        TweenPlayer(targetMob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(targetMob)
                    else
                        TweenPlayer(CurrentQuest.CFrameMon, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 8. محرك الإبحار والقتال البحري والجزيرة القديمة (Sea & Prehistoric Engine)
--------------------------------------------------------------------------------
local function GetMyBoat(boatName: string): Model?
    if workspace:FindFirstChild("Boats") then
        for _, b in pairs(workspace.Boats:GetChildren()) do
            if b.Name == boatName and b:FindFirstChild("VehicleSeat") then
                return b
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.2) do
        if World3 then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                -- 1. أتمتة الجزيرة القديمة وما قبل التاريخ Prehistoric Engine
                if _G.Settings.Sea["Auto Prehistoric Island"] or _G.Settings.Sea["Auto Complete Prehistoric Island"] or _G.Settings.Sea["Auto Draco Trail"] then
                    local targetPreMob = nil
                    for _, mName in pairs({"Isle Outlaw", "Island Boy", "Sun-kissed Warrior", "Terrorshark"}) do
                        local mob = workspace.Enemies:FindFirstChild(mName)
                        if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                            targetPreMob = mob
                            break
                        end
                    end

                    if targetPreMob then
                        AutoHaki()
                        TweenPlayer(targetPreMob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(targetPreMob)
                        return
                    else
                        TweenPlayer(MobSpecificTeleports["Prehistoric Island"], Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                    end
                end

                -- 2. فحص وهجوم أعداء ومخلوقات البحر
                local targetSeaEnemy = nil
                local allowedEnemies = {}
                if _G.Settings.Sea["Auto Farm Shark"] then table.insert(allowedEnemies, "Shark") end
                if _G.Settings.Sea["Auto Farm Piranha"] then table.insert(allowedEnemies, "Piranha") end
                if _G.Settings.Sea["Auto Farm Fish Crew Member"] then table.insert(allowedEnemies, "Fish Crew Member") end
                if _G.Settings.Sea["Auto Farm Ghost Ship"] then table.insert(allowedEnemies, "Ghost Ship") table.insert(allowedEnemies, "FishBoat") end
                if _G.Settings.Sea["Auto Farm Terrorshark"] then table.insert(allowedEnemies, "Terrorshark") end

                if #allowedEnemies > 0 and workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if table.find(allowedEnemies, enemy.Name) and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy.Humanoid.Health > 0 then
                            targetSeaEnemy = enemy
                            break
                        end
                    end
                end

                if targetSeaEnemy then
                    if hum.Sit then hum.Sit = false end
                    AutoHaki()
                    TweenPlayer(targetSeaEnemy.HumanoidRootPart.CFrame, Vector3.new(0, 25, 0))
                    SmartAttackMob(targetSeaEnemy)
                    return
                end

                -- قتال السي بيست (SeaBeasts)
                if _G.Settings.Sea["Auto Farm Seabeasts"] and workspace:FindFirstChild("SeaBeasts") then
                    for _, sb in pairs(workspace.SeaBeasts:GetChildren()) do
                        if sb:FindFirstChild("HumanoidRootPart") and sb:FindFirstChildOfClass("Humanoid") and sb.Humanoid.Health > 0 then
                            if hum.Sit then hum.Sit = false end
                            AutoHaki()
                            local dodgeOffset = _G.Settings.Sea["Dodge Seabeasts Attack"] and Vector3.new(math.random(-50, 50), 55, math.random(-50, 50)) or Vector3.new(0, 55, 0)
                            TweenPlayer(sb.HumanoidRootPart.CFrame, dodgeOffset)
                            FastAttackTarget(sb)
                            return
                        end
                    end
                end

                -- الفحص الفوري عن Mirage أو Kitsune Island
                local mirage = workspace.Map:FindFirstChild("MysticIsland")
                local kitsune = workspace.Map:FindFirstChild("KitsuneIsland")

                if _G.Settings.Race["Auto Find Mirage"] and mirage then
                    TweenPlayer(mirage.WorldPivot)
                    return
                end

                if _G.Settings.Sea["Auto Find Kitsune Island"] and kitsune then
                    TweenPlayer(kitsune.WorldPivot)
                    return
                end

                -- الإبحار التلقائي بالقارب
                if _G.Settings.Sea["Sail Boat"] or _G.Settings.Race["Auto Find Mirage"] or _G.Settings.Sea["Auto Find Kitsune Island"] then
                    local boat = GetMyBoat(_G.Settings.Sea["Selected Boat"])
                    if not boat then
                        local buyPos = MobSpecificTeleports["Kitsune Island"]
                        if (hrp.Position - buyPos.Position).Magnitude > 30 then
                            TweenPlayer(buyPos)
                        else
                            if CommF_ then CommF_:InvokeServer("BuyBoat", _G.Settings.Sea["Selected Boat"]) end
                        end
                    else
                        if not hum.Sit then
                            hrp.CFrame = boat.VehicleSeat.CFrame * CFrame.new(0, 1.5, 0)
                        else
                            local targetZone = ZoneCFrames[_G.Settings.Sea["Selected Zone"]] or ZoneCFrames["Zone 5"]
                            local dist = (boat.VehicleSeat.Position - targetZone.Position).Magnitude
                            if dist > 100 then
                                local tween = TweenService:Create(boat.VehicleSeat, TweenInfo.new(dist / _G.Settings.Sea["Boat Tween Speed"], Enum.EasingStyle.Linear), {CFrame = targetZone})
                                tween:Play()
                            end
                        end
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 9. محرك تجميع وسرقة وتخزين الفواكه (Fruits Automation Loop)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Fruits["Auto Store Fruit"] then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") and (string.find(tool.Name, "Fruit") or tool.ToolTip == "Blox Fruit") then
                            if CommF_ then CommF_:InvokeServer("StoreFruit", tool.Name, tool) end
                        end
                    end
                end
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and (string.find(tool.Name, "Fruit") or tool.ToolTip == "Blox Fruit") then
                        if CommF_ then CommF_:InvokeServer("StoreFruit", tool.Name, tool) end
                    end
                end
            end)
        end

        if _G.Settings.Fruits["Fruit Sniper"] then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Tool") and (string.find(obj.Name, "Fruit") or string.find(obj.Name, "Blox")) then
                        local handle = obj:FindFirstChild("Handle") or obj.PrimaryPart
                        if handle then
                            TweenPlayer(handle.CFrame)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 10. محرك الـ Dungeon / Fruits Raid (مع Auto Next Island)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Raid["Auto Dungeon / Raid"] or _G.Settings.Raid["Auto Buy Chip & Start"] or _G.Settings.Raid["Auto Clear Dungeon Waves"] or _G.Settings.Raid["Auto Next Island"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                -- شراء الشريحة وبدء الريد
                if _G.Settings.Raid["Auto Buy Chip & Start"] then
                    if CommF_ then
                        CommF_:InvokeServer("RaidsNpc", "Select", _G.Settings.Raid["Selected Chip"])
                        task.wait(0.5)
                        CommF_:InvokeServer("RaidsNpc", "Start")
                    end
                end

                -- تنظيف وتصفية وحوش الريد
                if _G.Settings.Raid["Auto Clear Dungeon Waves"] and workspace:FindFirstChild("Enemies") then
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                            AutoHaki()
                            TweenPlayer(mob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                            SmartAttackMob(mob)
                            break
                        end
                    end
                end

                -- الانتقال التلقائي للجزيرة التالية في الريد فور انتهاء الموجة
                if _G.Settings.Raid["Auto Next Island"] and workspace:FindFirstChild("Locations") then
                    for _, loc in pairs(workspace.Locations:GetChildren()) do
                        if string.find(loc.Name:lower(), "island") or string.find(loc.Name:lower(), "raid") then
                            TweenPlayer(loc.CFrame * CFrame.new(0, 30, 0))
                            break
                        end
                    end
                end

                -- إيقاظ الفاكهة التلقائي
                if _G.Settings.Raid["Auto Awaken"] and CommF_ then
                    CommF_:InvokeServer("AwakeningExpert", "Awaken")
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 11. محرك الـ Auto Stats
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.Stats["Auto Stats"] then
            pcall(function()
                local points = LocalPlayer.Data.Points.Value
                if points and points > 0 then
                    local targetStat = _G.Settings.Stats["Selected Stat"]
                    local addCount = math.min(points, _G.Settings.Stats["Points Per Tick"] or 1)
                    if CommF_ then
                        CommF_:InvokeServer("AddPoint", targetStat, addCount)
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 12. محرك ترقية الأجناس الاحترافي (Race V2 & V3 Master Loop)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        -- أتمتة Race V2 الكاملة (جمع الأزهار والتسليم)
        if _G.Settings.Race["Auto Race V2 Quest"] and World2 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local flowers = {"Flower1", "Flower2", "Flower3"}
                local foundFlower = false

                for _, fName in pairs(flowers) do
                    local flowerObj = workspace:FindFirstChild(fName) or (workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild(fName))
                    if flowerObj and flowerObj:IsA("BasePart") then
                        foundFlower = true
                        TweenPlayer(flowerObj.CFrame)
                        break
                    end
                end

                if not foundFlower then
                    local alchemistPos = CFrame.new(-2440.79, 71.71, -3216.06)
                    if (hrp.Position - alchemistPos.Position).Magnitude > 20 then
                        TweenPlayer(alchemistPos)
                    else
                        if CommF_ then CommF_:InvokeServer("Alchemist", "1") end
                    end
                end
            end)
        end

        -- أتمتة Race V3 الكاملة بحسب متطلبات الجنس
        if _G.Settings.Race["Auto Race V3 Quest"] and World2 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local selectedRace = _G.Settings.Race["Selected Race V3"]
                local arouPos = CFrame.new(-2440.79, 71.71, -3216.06)

                if selectedRace == "Human" then
                    -- قتل الزعماء الثلاثة للـ Human V3
                    for _, bossName in pairs({"Jeremy", "Diamond", "Fajita"}) do
                        local boss = workspace.Enemies:FindFirstChild(bossName)
                        if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChildOfClass("Humanoid") and boss.Humanoid.Health > 0 then
                            AutoHaki()
                            TweenPlayer(boss.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                            SmartAttackMob(boss)
                            return
                        end
                    end
                end

                -- التحدث إلى NPC Arou
                if (hrp.Position - arouPos.Position).Magnitude > 20 then
                    TweenPlayer(arouPos)
                else
                    if CommF_ then CommF_:InvokeServer("Wenlocktoad", "1") end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 13. محرك السيوف الأسطورية المدمجة (CDK & TTK Auto Quests)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        -- أتمتة Cursed Dual Katana (CDK)
        if _G.Settings.FarmingQuests["Auto Farm CDK"] and World3 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local cryptPos = CFrame.new(-12471.16, 374.94, -7551.67)
                if (hrp.Position - cryptPos.Position).Magnitude > 25 then
                    TweenPlayer(cryptPos)
                else
                    if CommF_ then
                        CommF_:InvokeServer("CDKQuest", "Start")
                        CommF_:InvokeServer("CDKQuest", "Progress")
                    end
                end
            end)
        end

        -- أتمتة True Triple Katana (TTK)
        if _G.Settings.FarmingQuests["Auto Farm TTK"] and World2 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local swordDealerPos = CFrame.new(-2448.53, 73.01, -3210.63)
                if CommF_ then
                    CommF_:InvokeServer("LegendarySwordDealer", "1")
                    CommF_:InvokeServer("LegendarySwordDealer", "2")
                    CommF_:InvokeServer("LegendarySwordDealer", "3")
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 14. محرك الـ ESP المتكامل والحي (Advanced ESP Engine with Distance & HP)
--------------------------------------------------------------------------------
local ESPCache = {}

local function RemoveESP(obj)
    if ESPCache[obj] then
        ESPCache[obj]:Destroy()
        ESPCache[obj] = nil
    end
end

local function CreateUniversalESP(part: BasePart, text: string, color: Color3, showHP: boolean, maxHP: number?, currentHP: number?)
    if not part then return end
    if ESPCache[part] then RemoveESP(part) end

    local bill = Instance.new("BillboardGui")
    bill.Name = "HaroonESP"
    bill.Adornee = part
    bill.Size = UDim2.new(0, 150, 0, showHP and 45 or 28)
    bill.AlwaysOnTop = true

    local frame = Instance.new("Frame", bill)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BackgroundTransparency = 0.25
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

    local txt = Instance.new("TextLabel", frame)
    txt.Name = "ESPTitle"
    txt.Size = UDim2.new(1, 0, 0, 14)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = color
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 10

    local distLabel = Instance.new("TextLabel", frame)
    distLabel.Name = "ESPDist"
    distLabel.Size = UDim2.new(1, 0, 0, 12)
    distLabel.Position = UDim2.new(0, 0, 0, 13)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 9
    distLabel.Text = "Dist: ?m"

    if showHP and maxHP and currentHP then
        local hpBg = Instance.new("Frame", frame)
        hpBg.Size = UDim2.new(1, -10, 0, 4)
        hpBg.Position = UDim2.new(0, 5, 0, 28)
        hpBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        local hpFill = Instance.new("Frame", hpBg)
        hpFill.Name = "HPFill"
        hpFill.Size = UDim2.new(math.clamp(currentHP / maxHP, 0, 1), 0, 1, 0)
        hpFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end

    bill.Parent = part
    ESPCache[part] = bill
end

task.spawn(function()
    while task.wait(0.2) do
        local char, hrp = GetCharacter()
        if not char or not hrp then continue end

        -- 1. Players ESP
        if _G.Settings.Visuals["ESP Players"] then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
                    local pHrp = p.Character.HumanoidRootPart
                    local pHum = p.Character.Humanoid
                    local dist = math.floor((hrp.Position - pHrp.Position).Magnitude)
                    
                    CreateUniversalESP(pHrp, p.Name, Color3.fromRGB(255, 85, 85), true, pHum.MaxHealth, pHum.Health)
                    if ESPCache[pHrp] and ESPCache[pHrp]:FindFirstChild("Frame") then
                        ESPCache[pHrp].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                    end
                end
            end
        end

        -- 2. Fruits ESP
        if _G.Settings.Visuals["ESP Fruits"] then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Tool") and (string.find(v.Name, "Fruit") or string.find(v.Name, "Blox")) then
                    local handle = v:FindFirstChild("Handle") or v.PrimaryPart
                    if handle then
                        local dist = math.floor((hrp.Position - handle.Position).Magnitude)
                        CreateUniversalESP(handle, "🍎 " .. v.Name, Color3.fromRGB(255, 170, 0), false)
                        if ESPCache[handle] and ESPCache[handle]:FindFirstChild("Frame") then
                            ESPCache[handle].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                        end
                    end
                end
            end
        end

        -- 3. Chests ESP
        if _G.Settings.Visuals["ESP Chests"] and workspace:FindFirstChild("ChestModels") then
            for _, chest in pairs(workspace.ChestModels:GetChildren()) do
                if chest:FindFirstChild("RootPart") then
                    local dist = math.floor((hrp.Position - chest.RootPart.Position).Magnitude)
                    CreateUniversalESP(chest.RootPart, "📦 " .. chest.Name, Color3.fromRGB(255, 255, 0), false)
                    if ESPCache[chest.RootPart] and ESPCache[chest.RootPart]:FindFirstChild("Frame") then
                        ESPCache[chest.RootPart].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                    end
                end
            end
        end

        -- 4. Bosses & Enemies ESP
        if (_G.Settings.Visuals["ESP Bosses"] or _G.Settings.Visuals["ESP Enemies"]) and workspace:FindFirstChild("Enemies") then
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                    local eHrp = enemy.HumanoidRootPart
                    local eHum = enemy.Humanoid
                    if eHum.Health > 0 then
                        local dist = math.floor((hrp.Position - eHrp.Position).Magnitude)
                        CreateUniversalESP(eHrp, enemy.Name, Color3.fromRGB(255, 0, 127), true, eHum.MaxHealth, eHum.Health)
                        if ESPCache[eHrp] and ESPCache[eHrp]:FindFirstChild("Frame") then
                            ESPCache[eHrp].Frame.ESPDist.Text = "Dist: " .. dist .. " Studs"
                        end
                    end
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- 15. حلقات الصناديق والماتيريال والزعماء المتبقية
--------------------------------------------------------------------------------

-- Chest Farm Loop
task.spawn(function()
    while task.wait(0.2) do
        if _G.Settings.SubFarm["Auto Chest Tween"] or _G.Settings.SubFarm["Auto Chest Instant"] then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local closestChest = nil
                local shortestDist = math.huge
                if workspace:FindFirstChild("ChestModels") then
                    for _, v in pairs(workspace.ChestModels:GetChildren()) do
                        if string.find(v.Name, "Chest") and v:FindFirstChild("RootPart") then
                            local dist = (hrp.Position - v.RootPart.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestChest = v
                            end
                        end
                    end
                end

                if closestChest then
                    if _G.Settings.SubFarm["Auto Chest Instant"] then
                        hrp.CFrame = closestChest.RootPart.CFrame
                    else
                        TweenPlayer(closestChest.RootPart.CFrame)
                    end
                end
            end)
        end
    end
end)

-- Material Farm Loop
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Main["Auto Farm Material"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                local mobs, pos = GetMaterialConfig(_G.Settings.Main["Selected Material"])
                local found = false

                for _, mName in pairs(mobs) do
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == mName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                            found = true
                            AutoHaki()
                            TweenPlayer(v.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                            SmartAttackMob(v)
                            break
                        end
                    end
                    if found then break end
                end

                if not found then
                    TweenPlayer(pos, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                end
            end)
        end
    end
end)

-- Boss Farm Loop
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Main["Auto Farm Boss"] or _G.Settings.Main["Auto Farm All Boss"] then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum then return end

                local bTarget = _G.Settings.Main["Selected Boss"]
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if (v.Name == bTarget or _G.Settings.Main["Auto Farm All Boss"]) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                        AutoHaki()
                        TweenPlayer(v.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(v)
                        break
                    end
                end
            end)
        end
    end
end)        ["Teleport To Player"] = false,
        ["Aimbot Gun"] = false
    },
    SubFarm = {
        ["Auto Elite Hunter"] = false,
        ["Auto Elite Hunter Hop"] = false,
        ["Auto Farm Bone"] = false,
        ["Auto Pirate Raid"] = false,
        ["Auto Chest Tween"] = false,
        ["Auto Chest Instant"] = false,
        ["Auto Stop Items"] = false
    },
    Cake = {
        ["Auto Katakuri"] = false,
        ["Auto Spawn Cake Prince"] = false,
        ["Auto Kill Cake Prince"] = false,
        ["Auto Kill Dough King"] = false
    },
    Race = {
        ["Auto Race V3"] = false,
        ["Auto Train"] = false,
        ["Tween To Highest Mirage"] = false,
        ["Find Blue Gear"] = false,
        ["Look Moon Ability"] = false,
        ["Auto Trial"] = false,
        ["Auto Buy Gear"] = false
    },
    Sea = {
        ["Selected Boat"] = "Guardian",
        ["Selected Zone"] = "Zone 5",
        ["Boat Tween Speed"] = 200,
        ["Sail Boat"] = false,
        ["Auto Farm Shark"] = false,
        ["Auto Farm Piranha"] = false,
        ["Auto Farm Fish Crew Member"] = false,
        ["Auto Farm Ghost Ship"] = false,
        ["Auto Farm Terrorshark"] = false,
        ["Auto Farm Seabeasts"] = false,
        ["Dodge Seabeasts Attack"] = true
    },
    Raid = {
        ["Selected Chip"] = "Flame",
        ["Auto Raid"] = false,
        ["Auto Awaken"] = false,
        ["Law Raid"] = false
    },
    Visuals = {
        ["ESP Enemies"] = false
    }
}

--------------------------------------------------------------------------------
-- 3. محرك الحماية والتثبيت الرأسي (Safe Anti-Fall & Simulation Shield)
--------------------------------------------------------------------------------
local currentTween = nil

local function GetCharacter()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    return char, hrp, hum
end

-- رفع نطاق المحاكاة لحماية وصول الطلبات دون طرد
task.spawn(function()
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            end
        end)
    end)
end)

-- NoClip و حماية الجسم من السقوط والارتداد
RunService.Stepped:Connect(function()
    local active = _G.Settings.Main["Auto Farm Level"] or _G.Settings.Main["Auto Farm Material"] or 
                   _G.Settings.Main["Auto Farm Boss"] or _G.Settings.Main["Auto Farm All Boss"] or 
                   _G.Settings.SubFarm["Auto Farm Bone"] or _G.Settings.Cake["Auto Katakuri"] or 
                   _G.Settings.Sea["Sail Boat"] or _G.Settings.SubFarm["Auto Chest Tween"] or 
                   _G.Settings.Race["Auto Train"]

    if active then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                if char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    if not hrp:FindFirstChild("HaroonBV") then
                        local bv = Instance.new("BodyVelocity")
                        bv.Name = "HaroonBV"
                        bv.Parent = hrp
                        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                        bv.Velocity = Vector3.zero
                    end
                end
            end
        end)
    else
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("HaroonBV") then
                char.HumanoidRootPart.HaroonBV:Destroy()
            end
        end)
    end
end)

local function TweenPlayer(pos)
    local char, hrp, hum = GetCharacter()
    if hum.Sit then hum.Sit = false end

    local targetCFrame = (typeof(pos) == "CFrame" and pos) or (typeof(pos) == "Vector3" and CFrame.new(pos)) or (pos:IsA("BasePart") and pos.CFrame)
    if not targetCFrame then return end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local uprightCFrame = CFrame.new(targetCFrame.Position, targetCFrame.Position + Vector3.new(targetCFrame.LookVector.X, 0, targetCFrame.LookVector.Z))

    if distance <= 25 then
        hrp.CFrame = uprightCFrame
        if currentTween then currentTween:Cancel() end
        return
    end

    local speed = _G.Settings.Main["Player Tween Speed"] or 180
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)

    if currentTween then currentTween:Cancel() end
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = uprightCFrame})
    currentTween:Play()
    return currentTween
end

local function AutoHaki()
    if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("HasBuso") and CommF_ then
        CommF_:InvokeServer("Buso")
    end
end

local function EquipWeapon(weaponType)
    pcall(function()
        local char, _, hum = GetCharacter()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack or not hum then return end

        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == weaponType or (weaponType == "Melee" and tool.ToolTip == "Melee") or (weaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit")) then
                return
            end
        end

        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == weaponType or (weaponType == "Melee" and tool.ToolTip == "Melee") or (weaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit")) then
                hum:EquipTool(tool)
                break
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- 4. المحرك الذكي للهجوم والمهارات (Smart Fast Attack Engine)
--------------------------------------------------------------------------------
local function FastAttackTarget(targetEnemy)
    if not targetEnemy or not targetEnemy:FindFirstChild("HumanoidRootPart") then return end
    local head = targetEnemy:FindFirstChild("Head") or targetEnemy.HumanoidRootPart

    if RegisterAttack then
        RegisterAttack:FireServer(0)
        RegisterAttack:FireServer(1)
        RegisterAttack:FireServer(2)
        RegisterAttack:FireServer(3)
    end
    if typeof(RegisterHit) == "thread" or typeof(RegisterHit) == "function" then
        coroutine.resume(RegisterHit, head, {})
    elseif typeof(RegisterHit) == "Instance" then
        RegisterHit:FireServer(head, {})
    end
end

local function SmartAttackMob(targetMob)
    local selectedWep = _G.Settings.Main["Select Weapon"]
    local mobHum = targetMob:FindFirstChildOfClass("Humanoid")
    if not mobHum or mobHum.Health <= 0 then return end

    local hpRatio = mobHum.Health / mobHum.MaxHealth

    if selectedWep == "Blox Fruit" then
        if hpRatio > 0.25 then
            EquipWeapon("Melee")
            if _G.Settings.Main["Fast Attack"] then FastAttackTarget(targetMob) end
        else
            EquipWeapon("Blox Fruit")
            for _, key in pairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}) do
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                task.wait(0.04)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
            end
        end
    elseif selectedWep == "Gun" then
        if hpRatio > 0.25 then
            EquipWeapon("Melee")
            if _G.Settings.Main["Fast Attack"] then FastAttackTarget(targetMob) end
        else
            EquipWeapon("Gun")
            for _, key in pairs({Enum.KeyCode.Z, Enum.KeyCode.X}) do
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                task.wait(0.04)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
            end
            if ShootGunEvent then
                ShootGunEvent:FireServer(targetMob.HumanoidRootPart.Position, {targetMob.HumanoidRootPart})
            end
        end
    else
        EquipWeapon(selectedWep)
        if _G.Settings.Main["Fast Attack"] then FastAttackTarget(targetMob) end
    end
end

--------------------------------------------------------------------------------
-- 5. جداول المهمات والتنقلات (Quests & Teleports Database)
--------------------------------------------------------------------------------
local CurrentQuest = {
    Mon = "Bandit",
    LevelQuest = 1,
    NameQuest = "BanditQuest1",
    NameMon = "Bandit",
    CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42),
    CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
}

local function CheckQuest()
    local MyLevel = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")) and LocalPlayer.Data.Level.Value or 1
    if World1 then
        if MyLevel <= 9 then
            CurrentQuest = {Mon = "Bandit", LevelQuest = 1, NameQuest = "BanditQuest1", NameMon = "Bandit", CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42), CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)}
        elseif MyLevel <= 14 then
            CurrentQuest = {Mon = "Monkey", LevelQuest = 1, NameQuest = "JungleQuest", NameMon = "Monkey", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)}
        elseif MyLevel <= 29 then
            if _G.Settings.Main["Include Boss Quests"] and MyLevel >= 20 then
                CurrentQuest = {Mon = "The Gorilla King", LevelQuest = 3, NameQuest = "JungleQuest", NameMon = "The Gorilla King", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)}
            else
                CurrentQuest = {Mon = "Gorilla", LevelQuest = 2, NameQuest = "JungleQuest", NameMon = "Gorilla", CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37), CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)}
            end
        elseif MyLevel <= 39 then
            CurrentQuest = {Mon = "Pirate", LevelQuest = 1, NameQuest = "BuggyQuest1", NameMon = "Pirate", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)}
        elseif MyLevel <= 59 then
            if _G.Settings.Main["Include Boss Quests"] and MyLevel >= 55 then
                CurrentQuest = {Mon = "Bobby", LevelQuest = 3, NameQuest = "BuggyQuest1", NameMon = "Bobby", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)}
            else
                CurrentQuest = {Mon = "Brute", LevelQuest = 2, NameQuest = "BuggyQuest1", NameMon = "Brute", CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54), CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)}
            end
        elseif MyLevel <= 74 then
            CurrentQuest = {Mon = "Desert Bandit", LevelQuest = 1, NameQuest = "DesertQuest", NameMon = "Desert Bandit", CFrameQuest = CFrame.new(894.48, 5.14, 4392.43), CFrameMon = CFrame.new(924.79, 6.44, 4481.58)}
        elseif MyLevel <= 89 then
            CurrentQuest = {Mon = "Desert Officer", LevelQuest = 2, NameQuest = "DesertQuest", NameMon = "Desert Officer", CFrameQuest = CFrame.new(894.48, 5.14, 4392.43), CFrameMon = CFrame.new(1608.28, 8.61, 4371.00)}
        elseif MyLevel <= 99 then
            CurrentQuest = {Mon = "Snow Bandit", LevelQuest = 1, NameQuest = "SnowQuest", NameMon = "Snow Bandit", CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90), CFrameMon = CFrame.new(1354.34, 87.27, -1393.94)}
        elseif MyLevel <= 119 then
            CurrentQuest = {Mon = "Snowman", LevelQuest = 2, NameQuest = "SnowQuest", NameMon = "Snowman", CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90), CFrameMon = CFrame.new(1201.64, 144.57, -1550.06)}
        elseif MyLevel <= 149 then
            CurrentQuest = {Mon = "Chief Petty Officer", LevelQuest = 1, NameQuest = "MarineQuest2", NameMon = "Chief Petty Officer", CFrameQuest = CFrame.new(-5039.58, 27.35, 4324.68), CFrameMon = CFrame.new(-4881.23, 22.65, 4273.75)}
        elseif MyLevel <= 174 then
            CurrentQuest = {Mon = "Sky Bandit", LevelQuest = 1, NameQuest = "SkyQuest", NameMon = "Sky Bandit", CFrameQuest = CFrame.new(-4839.53, 716.36, -2619.44), CFrameMon = CFrame.new(-4953.20, 295.74, -2899.22)}
        elseif MyLevel <= 189 then
            CurrentQuest = {Mon = "Dark Master", LevelQuest = 2, NameQuest = "SkyQuest", NameMon = "Dark Master", CFrameQuest = CFrame.new(-4839.53, 716.36, -2619.44), CFrameMon = CFrame.new(-5259.84, 391.39, -2229.03)}
        elseif MyLevel <= 209 then
            CurrentQuest = {Mon = "Prisoner", LevelQuest = 1, NameQuest = "PrisonerQuest", NameMon = "Prisoner", CFrameQuest = CFrame.new(5308.93, 1.65, 475.12), CFrameMon = CFrame.new(5098.97, -0.32, 474.23)}
        elseif MyLevel <= 249 then
            CurrentQuest = {Mon = "Dangerous Prisoner", LevelQuest = 2, NameQuest = "PrisonerQuest", NameMon = "Dangerous Prisoner", CFrameQuest = CFrame.new(5308.93, 1.65, 475.12), CFrameMon = CFrame.new(5654.56, 15.63, 866.29)}
        elseif MyLevel <= 274 then
            CurrentQuest = {Mon = "Toga Warrior", LevelQuest = 1, NameQuest = "ColosseumQuest", NameMon = "Toga Warrior", CFrameQuest = CFrame.new(-1580.04, 6.35, -2986.47), CFrameMon = CFrame.new(-1820.21, 51.68, -2740.66)}
        elseif MyLevel <= 299 then
            CurrentQuest = {Mon = "Gladiator", LevelQuest = 2, NameQuest = "ColosseumQuest", NameMon = "Gladiator", CFrameQuest = CFrame.new(-1580.04, 6.35, -2986.47), CFrameMon = CFrame.new(-1292.83, 56.38, -3339.03)}
        elseif MyLevel <= 324 then
            CurrentQuest = {Mon = "Military Soldier", LevelQuest = 1, NameQuest = "MagmaQuest", NameMon = "Military Soldier", CFrameQuest = CFrame.new(-5313.37, 10.95, 8515.29), CFrameMon = CFrame.new(-5411.16, 11.08, 8454.29)}
        elseif MyLevel <= 374 then
            CurrentQuest = {Mon = "Military Spy", LevelQuest = 2, NameQuest = "MagmaQuest", NameMon = "Military Spy", CFrameQuest = CFrame.new(-5313.37, 10.95, 8515.29), CFrameMon = CFrame.new(-5802.86, 86.26, 8828.85)}
        elseif MyLevel <= 399 then
            CurrentQuest = {Mon = "Fishman Warrior", LevelQuest = 1, NameQuest = "FishmanQuest", NameMon = "Fishman Warrior", CFrameQuest = CFrame.new(61122.65, 18.49, 1569.39), CFrameMon = CFrame.new(60878.30, 18.48, 1543.75)}
        elseif MyLevel <= 449 then
            CurrentQuest = {Mon = "Fishman Commando", LevelQuest = 2, NameQuest = "FishmanQuest", NameMon = "Fishman Commando", CFrameQuest = CFrame.new(61122.65, 18.49, 1569.39), CFrameMon = CFrame.new(61922.63, 18.48, 1493.93)}
        elseif MyLevel <= 474 then
            CurrentQuest = {Mon = "God's Guard", LevelQuest = 1, NameQuest = "SkyExp1Quest", NameMon = "God's Guard", CFrameQuest = CFrame.new(-4721.88, 843.87, -1949.96), CFrameMon = CFrame.new(-4710.04, 845.27, -1927.30)}
        elseif MyLevel <= 524 then
            CurrentQuest = {Mon = "Shanda", LevelQuest = 2, NameQuest = "SkyExp1Quest", NameMon = "Shanda", CFrameQuest = CFrame.new(-7859.09, 5544.19, -381.47), CFrameMon = CFrame.new(-7678.48, 5566.40, -497.21)}
        elseif MyLevel <= 549 then
            CurrentQuest = {Mon = "Royal Squad", LevelQuest = 1, NameQuest = "SkyExp2Quest", NameMon = "Royal Squad", CFrameQuest = CFrame.new(-7906.81, 5634.66, -1411.99), CFrameMon = CFrame.new(-7624.25, 5658.13, -1467.35)}
        elseif MyLevel <= 624 then
            CurrentQuest = {Mon = "Royal Soldier", LevelQuest = 2, NameQuest = "SkyExp2Quest", NameMon = "Royal Soldier", CFrameQuest = CFrame.new(-7906.81, 5634.66, -1411.99), CFrameMon = CFrame.new(-7836.75, 5645.66, -1790.62)}
        elseif MyLevel <= 649 then
            CurrentQuest = {Mon = "Galley Pirate", LevelQuest = 1, NameQuest = "FountainQuest", NameMon = "Galley Pirate", CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02), CFrameMon = CFrame.new(5551.02, 78.90, 3930.41)}
        else
            CurrentQuest = {Mon = "Galley Captain", LevelQuest = 2, NameQuest = "FountainQuest", NameMon = "Galley Captain", CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02), CFrameMon = CFrame.new(5441.95, 42.50, 4950.09)}
        end
    elseif World2 then
        if MyLevel <= 724 then
            CurrentQuest = {Mon = "Raider", LevelQuest = 1, NameQuest = "Area1Quest", NameMon = "Raider", CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18), CFrameMon = CFrame.new(-728.32, 52.77, 2345.77)}
        elseif MyLevel <= 774 then
            CurrentQuest = {Mon = "Mercenary", LevelQuest = 2, NameQuest = "Area1Quest", NameMon = "Mercenary", CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18), CFrameMon = CFrame.new(-1004.32, 80.15, 1424.61)}
        elseif MyLevel <= 799 then
            CurrentQuest = {Mon = "Swan Pirate", LevelQuest = 1, NameQuest = "Area2Quest", NameMon = "Swan Pirate", CFrameQuest = CFrame.new(638.43, 71.76, 918.28), CFrameMon = CFrame.new(1068.66, 137.61, 1322.10)}
        elseif MyLevel <= 874 then
            CurrentQuest = {Mon = "Factory Staff", LevelQuest = 2, NameQuest = "Area2Quest", NameMon = "Factory Staff", CFrameQuest = CFrame.new(632.69, 73.10, 918.66), CFrameMon = CFrame.new(73.07, 81.86, -27.47)}
        elseif MyLevel <= 899 then
            CurrentQuest = {Mon = "Marine Lieutenant", LevelQuest = 1, NameQuest = "MarineQuest3", NameMon = "Marine Lieutenant", CFrameQuest = CFrame.new(-2440.79, 71.71, -3216.06), CFrameMon = CFrame.new(-2821.37, 75.89, -3070.08)}
        elseif MyLevel <= 949 then
            CurrentQuest = {Mon = "Marine Captain", LevelQuest = 2, NameQuest = "MarineQuest3", NameMon = "Marine Captain", CFrameQuest = CFrame.new(-2440.79, 71.71, -3216.06), CFrameMon = CFrame.new(-1861.23, 80.17, -3254.69)}
        elseif MyLevel <= 974 then
            CurrentQuest = {Mon = "Zombie", LevelQuest = 1, NameQuest = "ZombieQuest", NameMon = "Zombie", CFrameQuest = CFrame.new(-5497.06, 47.59, -795.23), CFrameMon = CFrame.new(-5657.77, 78.96, -928.68)}
        elseif MyLevel <= 999 then
            CurrentQuest = {Mon = "Vampire", LevelQuest = 2, NameQuest = "ZombieQuest", NameMon = "Vampire", CFrameQuest = CFrame.new(-5497.06, 47.59, -795.23), CFrameMon = CFrame.new(-6037.66, 32.18, -1340.65)}
        elseif MyLevel <= 1049 then
            CurrentQuest = {Mon = "Snow Trooper", LevelQuest = 1, NameQuest = "SnowMountainQuest", NameMon = "Snow Trooper", CFrameQuest = CFrame.new(609.85, 400.11, -5372.25), CFrameMon = CFrame.new(549.14, 427.38, -5563.69)}
        elseif MyLevel <= 1099 then
            CurrentQuest = {Mon = "Winter Warrior", LevelQuest = 2, NameQuest = "SnowMountainQuest", NameMon = "Winter Warrior", CFrameQuest = CFrame.new(609.85, 400.11, -5372.25), CFrameMon = CFrame.new(1142.74, 475.63, -5199.41)}
        elseif MyLevel <= 1124 then
            CurrentQuest = {Mon = "Lab Subordinate", LevelQuest = 1, NameQuest = "IceSideQuest", NameMon = "Lab Subordinate", CFrameQuest = CFrame.new(-6064.06, 15.24, -4902.97), CFrameMon = CFrame.new(-5707.47, 15.95, -4513.39)}
        elseif MyLevel <= 1174 then
            CurrentQuest = {Mon = "Horned Warrior", LevelQuest = 2, NameQuest = "IceSideQuest", NameMon = "Horned Warrior", CFrameQuest = CFrame.new(-6064.06, 15.24, -4902.97), CFrameMon = CFrame.new(-6341.36, 15.95, -5723.16)}
        elseif MyLevel <= 1199 then
            CurrentQuest = {Mon = "Magma Ninja", LevelQuest = 1, NameQuest = "FireSideQuest", NameMon = "Magma Ninja", CFrameQuest = CFrame.new(-5428.03, 15.06, -5299.43), CFrameMon = CFrame.new(-5449.67, 76.65, -5808.20)}
        elseif MyLevel <= 1249 then
            CurrentQuest = {Mon = "Lava Pirate", LevelQuest = 2, NameQuest = "FireSideQuest", NameMon = "Lava Pirate", CFrameQuest = CFrame.new(-5428.03, 15.06, -5299.43), CFrameMon = CFrame.new(-5213.33, 49.73, -4701.45)}
        elseif MyLevel <= 1274 then
            CurrentQuest = {Mon = "Ship Deckhand", LevelQuest = 1, NameQuest = "ShipQuest1", NameMon = "Ship Deckhand", CFrameQuest = CFrame.new(1037.80, 125.09, 32911.60), CFrameMon = CFrame.new(1212.01, 150.79, 33059.24)}
        elseif MyLevel <= 1299 then
            CurrentQuest = {Mon = "Ship Engineer", LevelQuest = 2, NameQuest = "ShipQuest1", NameMon = "Ship Engineer", CFrameQuest = CFrame.new(1037.80, 125.09, 32911.60), CFrameMon = CFrame.new(919.47, 43.54, 32779.96)}
        elseif MyLevel <= 1324 then
            CurrentQuest = {Mon = "Ship Steward", LevelQuest = 1, NameQuest = "ShipQuest2", NameMon = "Ship Steward", CFrameQuest = CFrame.new(968.80, 125.09, 33244.12), CFrameMon = CFrame.new(919.43, 129.55, 33436.03)}
        elseif MyLevel <= 1349 then
            CurrentQuest = {Mon = "Ship Officer", LevelQuest = 2, NameQuest = "ShipQuest2", NameMon = "Ship Officer", CFrameQuest = CFrame.new(968.80, 125.09, 33244.12), CFrameMon = CFrame.new(1036.01, 181.43, 33315.72)}
        elseif MyLevel <= 1374 then
            CurrentQuest = {Mon = "Arctic Warrior", LevelQuest = 1, NameQuest = "FrostQuest", NameMon = "Arctic Warrior", CFrameQuest = CFrame.new(5667.65, 26.79, -6486.08), CFrameMon = CFrame.new(5966.24, 62.97, -6179.38)}
        elseif MyLevel <= 1424 then
            CurrentQuest = {Mon = "Snow Lurker", LevelQuest = 2, NameQuest = "FrostQuest", NameMon = "Snow Lurker", CFrameQuest = CFrame.new(5667.65, 26.79, -6486.08), CFrameMon = CFrame.new(5407.07, 69.19, -6880.88)}
        elseif MyLevel <= 1449 then
            CurrentQuest = {Mon = "Sea Soldier", LevelQuest = 1, NameQuest = "ForgottenQuest", NameMon = "Sea Soldier", CFrameQuest = CFrame.new(-3054.44, 235.54, -10142.81), CFrameMon = CFrame.new(-3028.22, 64.67, -9775.42)}
        else
            CurrentQuest = {Mon = "Water Fighter", LevelQuest = 2, NameQuest = "ForgottenQuest", NameMon = "Water Fighter", CFrameQuest = CFrame.new(-3054.44, 235.54, -10142.81), CFrameMon = CFrame.new(-3352.90, 285.01, -10534.84)}
        end
    elseif World3 then
        if MyLevel <= 1524 then
            CurrentQuest = {Mon = "Pirate Millionaire", LevelQuest = 1, NameQuest = "PiratePortQuest", NameMon = "Pirate Millionaire", CFrameQuest = CFrame.new(-290.07, 42.90, 5581.58), CFrameMon = CFrame.new(-245.99, 47.30, 5584.10)}
        elseif MyLevel <= 1574 then
            CurrentQuest = {Mon = "Pistol Billionaire", LevelQuest = 2, NameQuest = "PiratePortQuest", NameMon = "Pistol Billionaire", CFrameQuest = CFrame.new(-290.07, 42.90, 5581.58), CFrameMon = CFrame.new(-187.33, 86.23, 6013.51)}
        elseif MyLevel <= 1599 then
            CurrentQuest = {Mon = "Dragon Crew Warrior", LevelQuest = 1, NameQuest = "AmazonQuest", NameMon = "Dragon Crew Warrior", CFrameQuest = CFrame.new(5832.83, 51.68, -1101.51), CFrameMon = CFrame.new(6141.14, 51.35, -1340.73)}
        elseif MyLevel <= 1624 then
            CurrentQuest = {Mon = "Dragon Crew Archer", LevelQuest = 2, NameQuest = "AmazonQuest", NameMon = "Dragon Crew Archer", CFrameQuest = CFrame.new(5833.11, 51.60, -1103.06), CFrameMon = CFrame.new(6616.41, 441.76, 446.04)}
        elseif MyLevel <= 1649 then
            CurrentQuest = {Mon = "Female Islander", LevelQuest = 1, NameQuest = "AmazonQuest2", NameMon = "Female Islander", CFrameQuest = CFrame.new(5446.87, 601.62, 749.45), CFrameMon = CFrame.new(4685.25, 735.80, 815.34)}
        elseif MyLevel <= 1699 then
            CurrentQuest = {Mon = "Giant Islander", LevelQuest = 2, NameQuest = "AmazonQuest2", NameMon = "Giant Islander", CFrameQuest = CFrame.new(5446.87, 601.62, 749.45), CFrameMon = CFrame.new(4729.09, 590.43, -36.97)}
        elseif MyLevel <= 1724 then
            CurrentQuest = {Mon = "Marine Commodore", LevelQuest = 1, NameQuest = "MarineTreeIsland", NameMon = "Marine Commodore", CFrameQuest = CFrame.new(2180.54, 27.81, -6741.54), CFrameMon = CFrame.new(2286.00, 73.13, -7159.80)}
        elseif MyLevel <= 1774 then
            CurrentQuest = {Mon = "Marine Rear Admiral", LevelQuest = 2, NameQuest = "MarineTreeIsland", NameMon = "Marine Rear Admiral", CFrameQuest = CFrame.new(2179.98, 28.73, -6740.05), CFrameMon = CFrame.new(3656.77, 160.52, -7001.59)}
        elseif MyLevel <= 1799 then
            CurrentQuest = {Mon = "Fishman Raider", LevelQuest = 1, NameQuest = "DeepForestIsland3", NameMon = "Fishman Raider", CFrameQuest = CFrame.new(-10581.65, 330.87, -8761.18), CFrameMon = CFrame.new(-10407.52, 331.76, -8368.51)}
        elseif MyLevel <= 1824 then
            CurrentQuest = {Mon = "Fishman Captain", LevelQuest = 2, NameQuest = "DeepForestIsland3", NameMon = "Fishman Captain", CFrameQuest = CFrame.new(-10581.65, 330.87, -8761.18), CFrameMon = CFrame.new(-10994.70, 352.38, -9002.11)}
        elseif MyLevel <= 1849 then
            CurrentQuest = {Mon = "Forest Pirate", LevelQuest = 1, NameQuest = "DeepForestIsland", NameMon = "Forest Pirate", CFrameQuest = CFrame.new(-13234.04, 331.48, -7625.40), CFrameMon = CFrame.new(-13274.47, 332.37, -7769.58)}
        elseif MyLevel <= 1899 then
            CurrentQuest = {Mon = "Mythological Pirate", LevelQuest = 2, NameQuest = "DeepForestIsland", NameMon = "Mythological Pirate", CFrameQuest = CFrame.new(-13234.04, 331.48, -7625.40), CFrameMon = CFrame.new(-13680.60, 501.08, -6991.18)}
        elseif MyLevel <= 1924 then
            CurrentQuest = {Mon = "Jungle Pirate", LevelQuest = 1, NameQuest = "DeepForestIsland2", NameMon = "Jungle Pirate", CFrameQuest = CFrame.new(-12680.38, 389.97, -9902.01), CFrameMon = CFrame.new(-12256.16, 331.73, -10485.83)}
        elseif MyLevel <= 1974 then
            CurrentQuest = {Mon = "Musketeer Pirate", LevelQuest = 2, NameQuest = "DeepForestIsland2", NameMon = "Musketeer Pirate", CFrameQuest = CFrame.new(-12680.38, 389.97, -9902.01), CFrameMon = CFrame.new(-13457.90, 391.54, -9859.17)}
        elseif MyLevel <= 1999 then
            CurrentQuest = {Mon = "Reborn Skeleton", LevelQuest = 1, NameQuest = "HauntedQuest1", NameMon = "Reborn Skeleton", CFrameQuest = CFrame.new(-9479.21, 141.21, 5566.09), CFrameMon = CFrame.new(-8763.72, 165.72, 6159.86)}
        elseif MyLevel <= 2024 then
            CurrentQuest = {Mon = "Living Zombie", LevelQuest = 2, NameQuest = "HauntedQuest1", NameMon = "Living Zombie", CFrameQuest = CFrame.new(-9479.21, 141.21, 5566.09), CFrameMon = CFrame.new(-10144.13, 138.62, 5838.08)}
        elseif MyLevel <= 2049 then
            CurrentQuest = {Mon = "Demonic Soul", LevelQuest = 1, NameQuest = "HauntedQuest2", NameMon = "Demonic Soul", CFrameQuest = CFrame.new(-9516.99, 172.01, 6078.46), CFrameMon = CFrame.new(-9505.87, 172.10, 6158.99)}
        elseif MyLevel <= 2074 then
            CurrentQuest = {Mon = "Posessed Mummy", LevelQuest = 2, NameQuest = "HauntedQuest2", NameMon = "Posessed Mummy", CFrameQuest = CFrame.new(-9516.99, 172.01, 6078.46), CFrameMon = CFrame.new(-9582.02, 6.25, 6205.47)}
        elseif MyLevel <= 2099 then
            CurrentQuest = {Mon = "Peanut Scout", LevelQuest = 1, NameQuest = "NutsIslandQuest", NameMon = "Peanut Scout", CFrameQuest = CFrame.new(-2104.39, 38.10, -10194.21), CFrameMon = CFrame.new(-2143.24, 47.72, -10029.99)}
        elseif MyLevel <= 2124 then
            CurrentQuest = {Mon = "Peanut President", LevelQuest = 2, NameQuest = "NutsIslandQuest", NameMon = "Peanut President", CFrameQuest = CFrame.new(-2104.39, 38.10, -10194.21), CFrameMon = CFrame.new(-1859.35, 38.10, -10422.42)}
        elseif MyLevel <= 2149 then
            CurrentQuest = {Mon = "Ice Cream Chef", LevelQuest = 1, NameQuest = "IceCreamIslandQuest", NameMon = "Ice Cream Chef", CFrameQuest = CFrame.new(-820.64, 65.81, -10965.79), CFrameMon = CFrame.new(-872.24, 65.81, -10919.95)}
        elseif MyLevel <= 2199 then
            CurrentQuest = {Mon = "Ice Cream Commander", LevelQuest = 2, NameQuest = "IceCreamIslandQuest", NameMon = "Ice Cream Commander", CFrameQuest = CFrame.new(-820.64, 65.81, -10965.79), CFrameMon = CFrame.new(-558.06, 112.04, -11290.77)}
        elseif MyLevel <= 2224 then
            CurrentQuest = {Mon = "Cookie Crafter", LevelQuest = 1, NameQuest = "CakeQuest1", NameMon = "Cookie Crafter", CFrameQuest = CFrame.new(-2021.32, 37.79, -12028.72), CFrameMon = CFrame.new(-2374.13, 37.79, -12125.30)}
        elseif MyLevel <= 2249 then
            CurrentQuest = {Mon = "Cake Guard", LevelQuest = 2, NameQuest = "CakeQuest1", NameMon = "Cake Guard", CFrameQuest = CFrame.new(-2021.32, 37.79, -12028.72), CFrameMon = CFrame.new(-1598.30, 43.77, -12244.58)}
        elseif MyLevel <= 2274 then
            CurrentQuest = {Mon = "Baking Staff", LevelQuest = 1, NameQuest = "CakeQuest2", NameMon = "Baking Staff", CFrameQuest = CFrame.new(-1927.91, 37.79, -12842.53), CFrameMon = CFrame.new(-1887.80, 77.61, -12998.35)}
        elseif MyLevel <= 2299 then
            CurrentQuest = {Mon = "Head Baker", LevelQuest = 2, NameQuest = "CakeQuest2", NameMon = "Head Baker", CFrameQuest = CFrame.new(-1927.91, 37.79, -12842.53), CFrameMon = CFrame.new(-2216.18, 82.88, -12869.29)}
        elseif MyLevel <= 2324 then
            CurrentQuest = {Mon = "Cocoa Warrior", LevelQuest = 1, NameQuest = "ChocQuest1", NameMon = "Cocoa Warrior", CFrameQuest = CFrame.new(233.22, 29.87, -12201.23), CFrameMon = CFrame.new(-21.55, 80.57, -12352.38)}
        elseif MyLevel <= 2349 then
            CurrentQuest = {Mon = "Chocolate Bar Battler", LevelQuest = 2, NameQuest = "ChocQuest1", NameMon = "Chocolate Bar Battler", CFrameQuest = CFrame.new(233.22, 29.87, -12201.23), CFrameMon = CFrame.new(582.59, 77.18, -12463.16)}
        elseif MyLevel <= 2374 then
            CurrentQuest = {Mon = "Sweet Thief", LevelQuest = 1, NameQuest = "ChocQuest2", NameMon = "Sweet Thief", CFrameQuest = CFrame.new(150.50, 30.69, -12774.50), CFrameMon = CFrame.new(165.18, 76.05, -12600.83)}
        elseif MyLevel <= 2399 then
            CurrentQuest = {Mon = "Candy Rebel", LevelQuest = 2, NameQuest = "ChocQuest2", NameMon = "Candy Rebel", CFrameQuest = CFrame.new(150.50, 30.69, -12774.50), CFrameMon = CFrame.new(134.86, 77.24, -12876.54)}
        elseif MyLevel <= 2424 then
            CurrentQuest = {Mon = "Candy Pirate", LevelQuest = 1, NameQuest = "CandyQuest1", NameMon = "Candy Pirate", CFrameQuest = CFrame.new(-1150.04, 20.37, -14446.33), CFrameMon = CFrame.new(-1310.50, 26.01, -14562.40)}
        elseif MyLevel <= 2449 then
            CurrentQuest = {Mon = "Snow Demon", LevelQuest = 2, NameQuest = "CandyQuest1", NameMon = "Snow Demon", CFrameQuest = CFrame.new(-1150.04, 20.37, -14446.33), CFrameMon = CFrame.new(-880.20, 71.24, -14538.60)}
        elseif MyLevel <= 2474 then
            CurrentQuest = {Mon = "Isle Outlaw", LevelQuest = 1, NameQuest = "TikiQuest1", NameMon = "Isle Outlaw", CFrameQuest = CFrame.new(-16547.74, 61.13, -173.41), CFrameMon = CFrame.new(-16442.81, 116.13, -264.46)}
        elseif MyLevel <= 2524 then
            CurrentQuest = {Mon = "Island Boy", LevelQuest = 2, NameQuest = "TikiQuest1", NameMon = "Island Boy", CFrameQuest = CFrame.new(-16547.74, 61.13, -173.41), CFrameMon = CFrame.new(-16901.26, 84.06, -192.88)}
        elseif MyLevel <= 2549 then
            CurrentQuest = {Mon = "Isle Champion", LevelQuest = 2, NameQuest = "TikiQuest2", NameMon = "Isle Champion", CFrameQuest = CFrame.new(-16539.07, 55.68, 1051.57), CFrameMon = CFrame.new(-16641.67, 235.78, 1031.28)}
        elseif MyLevel <= 2574 then
            CurrentQuest = {Mon = "Serpent Hunter", LevelQuest = 1, NameQuest = "TikiQuest3", NameMon = "Serpent Hunter", CFrameQuest = CFrame.new(-16661.89, 105.28, 1576.69), CFrameMon = CFrame.new(-16587.89, 154.21, 1533.40)}
        else
            CurrentQuest = {Mon = "Skull Slayer", LevelQuest = 2, NameQuest = "TikiQuest3", NameMon = "Skull Slayer", CFrameQuest = CFrame.new(-16661.89, 105.28, 1576.69), CFrameMon = CFrame.new(-16885.20, 114.12, 1627.94)}
        end
    end
end

local IslandTeleports = {
    World1 = {
        ["Windmill"] = CFrame.new(979.79, 16.51, 1429.04),
        ["Jungle"] = CFrame.new(-1612.79, 36.85, 149.12),
        ["Pirate Village"] = CFrame.new(-1181.30, 4.75, 3803.54),
        ["Desert"] = CFrame.new(944.15, 20.91, 4373.30),
        ["Snow Island"] = CFrame.new(1347.80, 104.66, -1319.73),
        ["Marineford"] = CFrame.new(-4914.82, 50.96, 4281.02),
        ["Colosseum"] = CFrame.new(-1427.62, 7.28, -2792.77),
        ["Sky Island"] = CFrame.new(-4869.10, 733.46, -2667.01),
        ["Prison"] = CFrame.new(4875.33, 5.65, 734.85),
        ["Magma Village"] = CFrame.new(-5247.71, 12.88, 8504.96),
    },
    World2 = {
        ["Cafe"] = CFrame.new(-380.47, 77.22, 255.82),
        ["Green Zone"] = CFrame.new(-2448.53, 73.01, -3210.63),
        ["Cursed Ship"] = CFrame.new(923.40, 125.05, 32885.87),
        ["Ice Castle"] = CFrame.new(6148.41, 294.38, -6741.11),
    },
    World3 = {
        ["Mansion"] = CFrame.new(-12471.16, 374.94, -7551.67),
        ["Port Town"] = CFrame.new(-290.73, 6.72, 5343.55),
        ["Hydra Island"] = CFrame.new(5291.24, 1005.44, 393.76),
        ["Floating Turtle"] = CFrame.new(-13274.52, 531.82, -7579.22),
        ["Haunted Castle"] = CFrame.new(-9515.37, 164.00, 5786.06),
        ["Tiki Outpost"] = CFrame.new(-16218.68, 9.08, 445.61)
    }
}

local NpcTeleports = {
    World1 = {
        ["Random Devil Fruit"] = CFrame.new(-1436.19, 61.87, 4.75),
        ["Blox Fruits Dealer"] = CFrame.new(-923.25, 7.67, 1608.61),
        ["Ability Teacher"] = CFrame.new(-1057.67, 9.65, 1799.49)
    },
    World2 = {
        ["Dargon Breath"] = CFrame.new(703.37, 186.98, 654.52),
        ["Mysterious Man"] = CFrame.new(-2574.43, 1627.92, -3739.35),
        ["Awakening Expert"] = CFrame.new(-408.09, 16.04, 247.43)
    },
    World3 = {
        ["Elite Hunter"] = CFrame.new(-5420, 314, -2828),
        ["Player Hunter"] = CFrame.new(-5559, 314, -2840),
        ["Uzoth"] = CFrame.new(-9785, 852, 6667)
    }
}

local MaterialList = (World1 and {"Magma Ore", "Angel Wings", "Leather", "Scrap Metal"}) or (World2 and {"Radioactive", "Mystic Droplet", "Magma Ore", "Leather", "Ectoplasm", "Scrap Metal"}) or {"Leather", "Scrap Metal", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk"}

local function GetMaterialConfig(mat)
    if mat == "Radioactive" and World2 then return {"Factory Staff"}, CFrame.new(-507.78, 72.99, -126.45)
    elseif mat == "Mystic Droplet" and World2 then return {"Water Fighter"}, CFrame.new(-3352.90, 285.01, -10534.84)
    elseif mat == "Magma Ore" and World1 then return {"Military Spy"}, CFrame.new(-5850.28, 77.28, 8848.67)
    elseif mat == "Magma Ore" and World2 then return {"Lava Pirate"}, CFrame.new(-5234.60, 51.95, -4732.27)
    elseif mat == "Angel Wings" and World1 then return {"Royal Soldier"}, CFrame.new(-7827.15, 5606.91, -1705.58)
    elseif mat == "Leather" and World1 then return {"Pirate"}, CFrame.new(-1211.87, 4.78, 3916.83)
    elseif mat == "Leather" and World2 then return {"Marine Captain"}, CFrame.new(-2010.50, 73.00, -3326.62)
    elseif mat == "Leather" and World3 then return {"Jungle Pirate"}, CFrame.new(-11975.78, 331.77, -10620.03)
    elseif mat == "Ectoplasm" and World2 then return {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"}, CFrame.new(911.35, 125.95, 33159.53)
    elseif mat == "Scrap Metal" and World1 then return {"Brute"}, CFrame.new(-1132.42, 14.84, 4293.30)
    elseif mat == "Scrap Metal" and World2 then return {"Mercenary"}, CFrame.new(-972.30, 73.04, 1419.29)
    elseif mat == "Scrap Metal" and World3 then return {"Pirate Millionaire"}, CFrame.new(-289.63, 43.82, 5583.66)
    elseif mat == "Conjured Cocoa" and World3 then return {"Chocolate Bar Battler"}, CFrame.new(744.79, 24.76, -12637.72)
    elseif mat == "Dragon Scale" and World3 then return {"Dragon Crew Warrior"}, CFrame.new(5824.06, 51.38, -1106.69)
    elseif mat == "Gunpowder" and World3 then return {"Pistol Billionaire"}, CFrame.new(-379.61, 73.84, 5928.52)
    elseif mat == "Fish Tail" and World3 then return {"Fishman Captain"}, CFrame.new(-10961.01, 331.79, -8914.29)
    elseif mat == "Mini Tusk" and World3 then return {"Mythological Pirate"}, CFrame.new(-13516.04, 469.81, -6899.16)
    end
    return {}, CFrame.new(0,0,0)
end

local BossList = (World1 and {"The Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Saber Expert"}) or (World2 and {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Cursed Captain", "Darkbeard", "Order", "Awakened Ice Admiral", "Tide Keeper"}) or {"Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "rip_indra True Form", "Longma", "Soul Reaper", "Cake Queen"}

--------------------------------------------------------------------------------
-- 6. دمج واجهة AetherUI والتابات الكاملة
--------------------------------------------------------------------------------
local AetherUI = loadstring(game:HttpGet("https://pastebin.com/raw/yeULgMe0"))()

AetherUI:InitLoadingScreen("Haroon Hub V12 Ultimate", "Configuring Protection & Sea Engines...", function()
    AetherUI:InitKeySystem({"HAROON-2025-VIP", "HAROON-KEY-100"}, function()
        AetherUI:Notify({Title = "🔥 Haroon Hub V12 Active", Content = "تم بنجاح تشغيل جميع الأنظمة مع الحماية القصوى!", Duration = 4})

        local Window = AetherUI:CreateWindow({
            Title = "Haroon Hub | Blox Fruits Master",
            Subtitle = "by: 3amek4222",
            ToggleKey = Enum.KeyCode.RightControl
        })

        local MainTab = Window:CreateTab("Main", "rbxassetid://6034287594")
        local CombatTab = Window:CreateTab("Combat", "rbxassetid://6034834832")
        local RaceTab = Window:CreateTab("Race V4", "rbxassetid://6034453535")
        local SubFarmTab = Window:CreateTab("Sub Farming", "rbxassetid://6034834832")
        local CakeTab = Window:CreateTab("Cake & Dough", "rbxassetid://6034453535")
        local SeaTab = Window:CreateTab("Sea Farming", "rbxassetid://6034453535")
        local RaidTab = Window:CreateTab("Raids", "rbxassetid://6034834832")
        local AutoQuestsTab = Window:CreateTab("Auto Quests", "rbxassetid://6034453535")
        local TeleportsTab = Window:CreateTab("Teleports", "rbxassetid://6034453535")
        local VisualTab = Window:CreateTab("Visuals", "rbxassetid://6034453535")
        local MiscTab = Window:CreateTab("Misc", "rbxassetid://6031280882")
        local SettingsTab = Window:CreateTab("Settings", "rbxassetid://6031280882")

        ---------------------------------------------------------
        -- 📌 1. TAB: MAIN
        ---------------------------------------------------------
        MainTab:CreateSection("خيارات التلفيل الأساسية (Level Farm)")

        MainTab:CreateToggle("تفعيل التجميع التلقائي (Auto Farm Level)", "AutoFarmFlag", false, function(state)
            _G.Settings.Main["Auto Farm Level"] = state
        end)

        MainTab:CreateToggle("تضمين مهمات الزعماء بالتلفيل (Include Bosses)", "IncludeBossQuestFlag", false, function(state)
            _G.Settings.Main["Include Boss Quests"] = state
        end)

        MainTab:CreateDropdown("اختر السلاح الفعال (Weapon)", "WeaponFlag", {"Melee", "Sword", "Blox Fruit", "Gun"}, "Melee", function(selected)
            _G.Settings.Main["Select Weapon"] = selected
        end)

        MainTab:CreateSlider("ارتفاع الطيران فوق العدو (Farm Distance)", "FarmDistFlag", 10, 50, 28, function(val)
            _G.Settings.Main["Farm Distance"] = val
        end)

        MainTab:CreateSlider("سرعة الانتقال الآمنة (Safe Tween Speed)", "TweenSpeedFlag", 100, 300, 180, function(val)
            _G.Settings.Main["Player Tween Speed"] = val
        end)

        MainTab:CreateToggle("الضرب السريع الخارق (Fast Attack)", "FastAttackFlag", false, function(state)
            _G.Settings.Main["Fast Attack"] = state
        end)

        MainTab:CreateSection("تجميع الماتيريال (Auto Farm Materials)")

        MainTab:CreateDropdown("اختر الماتيريال (Select Material)", "MatDropdownFlag", MaterialList, MaterialList[1], function(selected)
            _G.Settings.Main["Selected Material"] = selected
        end)

        MainTab:CreateToggle("تفعيل تجميع الماتيريال (Farm Material)", "FarmMatFlag", false, function(state)
            _G.Settings.Main["Auto Farm Material"] = state
        end)

        MainTab:CreateSection("قتل الزعماء (Auto Farm Bosses)")

        MainTab:CreateDropdown("اختر البوس (Select Boss)", "BossDropdownFlag", BossList, BossList[1], function(selected)
            _G.Settings.Main["Selected Boss"] = selected
        end)

        MainTab:CreateToggle("تفعيل قتل البوس المحدد (Auto Farm Boss)", "FarmBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm Boss"] = state
        end)

        MainTab:CreateToggle("تفعيل قتل جميع البوسات المتوفرة (Farm All Bosses)", "FarmAllBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm All Boss"] = state
        end)

        ---------------------------------------------------------
        -- 📌 2. TAB: COMBAT (PVP)
        ---------------------------------------------------------
        CombatTab:CreateSection("قتال اللاعبين والـ PVP")

        local playerList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(playerList, p.Name) end
        end

        CombatTab:CreateDropdown("اختر اللاعب المستهدف", "PVPPlayerDropdown", playerList, playerList[1] or "None", function(selected)
            _G.Settings.Combat["Selected Player"] = selected
        end)

        CombatTab:CreateToggle("مراقبة اللاعب (Spectate Player)", "SpectateFlag", false, function(state)
            _G.Settings.Combat["Spectate Player"] = state
            if state and _G.Settings.Combat["Selected Player"] then
                local target = Players:FindFirstChild(_G.Settings.Combat["Selected Player"])
                if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                    workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
                end
            else
                workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end)

        CombatTab:CreateToggle("الانتقال إلى اللاعب (Teleport To Player)", "TPPlayerFlag", false, function(state)
            _G.Settings.Combat["Teleport To Player"] = state
            task.spawn(function()
                while _G.Settings.Combat["Teleport To Player"] do
                    task.wait()
                    pcall(function()
                        local target = Players:FindFirstChild(_G.Settings.Combat["Selected Player"])
                        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            TweenPlayer(target.Character.HumanoidRootPart.CFrame)
                        end
                    end)
                end
            end)
        end)

        CombatTab:CreateToggle("تصويب المسدسات التلقائي (Aimbot Gun)", "AimbotGunFlag", false, function(state)
            _G.Settings.Combat["Aimbot Gun"] = state
        end)

        ---------------------------------------------------------
        -- 📌 3. TAB: RACE V4
        ---------------------------------------------------------
        RaceTab:CreateSection("ترقية الأجناس وتفعيل Race V3 & V4")

        RaceTab:CreateToggle("تفعيل مهارة V3 تلقائياً (Auto Race V3)", "AutoV3Flag", false, function(state)
            _G.Settings.Race["Auto Race V3"] = state
            task.spawn(function()
                while _G.Settings.Race["Auto Race V3"] do
                    task.wait(1)
                    if CommE then CommE:FireServer("ActivateAbility") end
                end
            end)
        end)

        RaceTab:CreateToggle("التدريب التلقائي للـ V4 (Auto Train)", "AutoTrainFlag", false, function(state)
            _G.Settings.Race["Auto Train"] = state
        end)

        RaceTab:CreateToggle("الانتقال لقمة الميراج (Tween To Highest Mirage)", "TweenMirageFlag", false, function(state)
            _G.Settings.Race["Tween To Highest Mirage"] = state
            task.spawn(function()
                while _G.Settings.Race["Tween To Highest Mirage"] do
                    task.wait()
                    pcall(function()
                        if workspace.Map:FindFirstChild("MysticIsland") then
                            for _, v in pairs(workspace.Map.MysticIsland:GetDescendants()) do
                                if v:IsA("MeshPart") and v.MeshId == "rbxassetid://6745037796" then
                                    TweenPlayer(v.CFrame * CFrame.new(0, 212, 0))
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("البحث عن الترس الأزرق (Find Blue Gear)", "FindGearFlag", false, function(state)
            _G.Settings.Race["Find Blue Gear"] = state
            task.spawn(function()
                while _G.Settings.Race["Find Blue Gear"] do
                    task.wait(0.2)
                    pcall(function()
                        if workspace.Map:FindFirstChild("MysticIsland") then
                            for _, v in pairs(workspace.Map.MysticIsland:GetChildren()) do
                                if v:IsA("MeshPart") and v.Material == Enum.Material.Neon then
                                    TweenPlayer(v.CFrame)
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("النظر للقمر وتفعيل المهارة (Look Moon)", "LookMoonFlag", false, function(state)
            _G.Settings.Race["Look Moon Ability"] = state
            task.spawn(function()
                while _G.Settings.Race["Look Moon Ability"] do
                    task.wait()
                    pcall(function()
                        local moonDir = game.Lighting:GetMoonDirection()
                        local lookAtPos = workspace.CurrentCamera.CFrame.p + moonDir * 100
                        workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.p, lookAtPos)
                    end)
                end
            end)
        end)

        RaceTab:CreateToggle("اجتياز الترايل تلقائياً (Auto Trial)", "AutoTrialFlag", false, function(state)
            _G.Settings.Race["Auto Trial"] = state
        end)

        RaceTab:CreateButton("شراء ترقية التروس (Buy Gear Upgrade)", function()
            if CommF_ then CommF_:InvokeServer("UpgradeRace", "Buy") end
        end)

        RaceTab:CreateButton("الانتقال إلى باب الترايل (Teleport To Race Door)", function()
            local myRace = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Race")) and LocalPlayer.Data.Race.Value or "Human"
            local raceDoors = {
                ["Human"] = CFrame.new(29221.82, 14890.97, -205.99),
                ["Skypiea"] = CFrame.new(28960.15, 14919.62, 235.03),
                ["Fishman"] = CFrame.new(28231.17, 14890.97, -211.64),
                ["Cyborg"] = CFrame.new(28502.68, 14895.97, -423.72),
                ["Ghoul"] = CFrame.new(28674.24, 14890.67, 445.43),
                ["Mink"] = CFrame.new(29012.34, 14890.97, -380.14)
            }
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35, 14895.30, 102.62)
            task.wait(0.3)
            if raceDoors[myRace] then TweenPlayer(raceDoors[myRace]) end
        end)

        ---------------------------------------------------------
        -- 📌 4. TAB: SUB FARMING
        ---------------------------------------------------------
        SubFarmTab:CreateSection("صياد النخبة والعظام (Elite & Bones)")

        SubFarmTab:CreateToggle("صياد النخبة التلقائي (Auto Elite Hunter)", "EliteFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter"] = state
        end)

        SubFarmTab:CreateToggle("صياد النخبة مع السيرفر هوب (Elite Hop)", "EliteHopFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter Hop"] = state
        end)

        SubFarmTab:CreateToggle("تجميع العظام التلقائي (Auto Farm Bones)", "BoneFlag", false, function(state)
            _G.Settings.SubFarm["Auto Farm Bone"] = state
        end)

        SubFarmTab:CreateButton("شراء رول العظام (Random Surprise)", function()
            if CommF_ then CommF_:InvokeServer("Bones", "Buy", 1, 1) end
        end)

        SubFarmTab:CreateSection("تجميع الصناديق التلقائي (Auto Chests)")

        SubFarmTab:CreateToggle("جمع الصناديق بالطيران (Chest Tween)", "ChestTweenFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Tween"] = state
        end)

        SubFarmTab:CreateToggle("جمع الصناديق الفوري (Chest Instant)", "ChestInstantFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Instant"] = state
        end)

        SubFarmTab:CreateToggle("توقف عند الحصول على دروب نادر (Stop on Items)", "StopItemsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Stop Items"] = state
        end)

        ---------------------------------------------------------
        -- 📌 5. TAB: CAKE PRINCE & DOUGH KING
        ---------------------------------------------------------
        CakeTab:CreateSection("الكيك برنس و دو كينغ")

        CakeTab:CreateToggle("تلفيل وقتل الكاتكوري بالكامل (Auto Katakuri)", "KatakuriFlag", false, function(state)
            _G.Settings.Cake["Auto Katakuri"] = state
        end)

        CakeTab:CreateToggle("استدعاء الكيك برنس التلقائي (Auto Spawn Prince)", "SpawnPrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Spawn Cake Prince"] = state
        end)

        CakeTab:CreateToggle("قتل الكيك برنس فور ظهوره (Auto Kill Cake Prince)", "KillPrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Cake Prince"] = state
        end)

        CakeTab:CreateToggle("قتل دو كينغ فور ظهوره (Auto Kill Dough King)", "KillDoughFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Dough King"] = state
        end)

        ---------------------------------------------------------
        -- 📌 6. TAB: SEA FARMING (Fixed & Fully Operational)
        ---------------------------------------------------------
        SeaTab:CreateSection("إبحار وأحداث البحر (Sea Events Engine)")

        SeaTab:CreateDropdown("اختر القارب (Select Boat)", "BoatDropdownFlag", {"Guardian", "Beast Hunter", "PirateGrandBrigade", "MarineGrandBrigade", "PirateBrigade", "MarineBrigade", "PirateSloop", "MarineSloop"}, "Guardian", function(selected)
            _G.Settings.Sea["Selected Boat"] = selected
        end)

        SeaTab:CreateDropdown("اختر منطقة الإبحار (Select Zone)", "ZoneDropdownFlag", {"Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5", "Zone 6", "Infinite"}, "Zone 5", function(selected)
            _G.Settings.Sea["Selected Zone"] = selected
        end)

        SeaTab:CreateToggle("تفعيل الإبحار التلقائي (Sail Boat)", "SailBoatFlag", false, function(state)
            _G.Settings.Sea["Sail Boat"] = state
        end)

        SeaTab:CreateToggle("قتل أسماك القرش (Auto Farm Shark)", "SharkFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Shark"] = state
        end)

        SeaTab:CreateToggle("قتل البيرانا (Auto Farm Piranha)", "PiranhaFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Piranha"] = state
        end)

        SeaTab:CreateToggle("قتل طاقم الأسماك (Fish Crew Member)", "CrewFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Fish Crew Member"] = state
        end)

        SeaTab:CreateToggle("قتل السفن الشبحية (Ghost Ship)", "GhostShipFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Ghost Ship"] = state
        end)

        SeaTab:CreateToggle("قتل التيرور شارك (Terrorshark)", "TerrorFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Terrorshark"] = state
        end)

        SeaTab:CreateToggle("قتل السي بيست (Seabeasts)", "SeabeastFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Seabeasts"] = state
        end)

        ---------------------------------------------------------
        -- 📌 7. TAB: RAIDS
        ---------------------------------------------------------
        RaidTab:CreateSection("الغارات والريدات (Raids & Dungeons)")

        RaidTab:CreateDropdown("اختر الشريحة (Select Raid Chip)", "RaidChipFlag", {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand", "Dough"}, "Flame", function(selected)
            _G.Settings.Raid["Selected Chip"] = selected
        end)

        RaidTab:CreateToggle("تفعيل الريد التلقائي (Auto Raid)", "AutoRaidFlag", false, function(state)
            _G.Settings.Raid["Auto Raid"] = state
        end)

        RaidTab:CreateToggle("تفعيل ريد Law التلقائي (Law Raid)", "LawRaidFlag", false, function(state)
            _G.Settings.Raid["Law Raid"] = state
        end)

        RaidTab:CreateToggle("إيقاظ الفواكه التلقائي (Auto Awaken)", "AwakenFlag", false, function(state)
            _G.Settings.Raid["Auto Awaken"] = state
        end)

        RaidTab:CreateButton("شراء شريحة ريد (Buy Microchip)", function()
            if CommF_ then
                CommF_:InvokeServer("BlackbeardReward", "Microchip", "1")
                CommF_:InvokeServer("BlackbeardReward", "Microchip", "2")
            end
        end)

        ---------------------------------------------------------
        -- 📌 8. TAB: AUTO QUESTS
        ---------------------------------------------------------
        AutoQuestsTab:CreateSection("أخذ وإنهاء المهمات المباشرة")

        AutoQuestsTab:CreateButton("أخذ مهمة القرود (Jungle Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "JungleQuest", 1) end
        end)

        AutoQuestsTab:CreateButton("أخذ مهمة الغوريلا (Jungle Quest 2)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "JungleQuest", 2) end
        end)

        AutoQuestsTab:CreateButton("أخذ مهمة القراصنة (Buggy Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "BuggyQuest1", 1) end
        end)

        AutoQuestsTab:CreateButton("أخذ مهمة المارينز (Marine Quest 2)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "MarineQuest2", 1) end
        end)

        AutoQuestsTab:CreateButton("أخذ مهمة السماء (Sky Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "SkyQuest", 1) end
        end)

        AutoQuestsTab:CreateButton("أخذ مهمة الزومبي (Zombie Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "ZombieQuest", 1) end
        end)

        AutoQuestsTab:CreateButton("أخذ مهمة العظام (Haunted Quest 2)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "HauntedQuest2", 1) end
        end)

        AutoQuestsTab:CreateButton("أخذ مهمة Tiki (Tiki Quest 1)", function()
            if CommF_ then CommF_:InvokeServer("StartQuest", "TikiQuest1", 1) end
        end)

        AutoQuestsTab:CreateButton("إلغاء المهمة الحالية (Abandon Quest)", function()
            if CommF_ then CommF_:InvokeServer("AbandonQuest") end
        end)

        ---------------------------------------------------------
        -- 📌 9. TAB: TELEPORTS
        ---------------------------------------------------------
        TeleportsTab:CreateSection("الانتقال السريع للجزر (Island Teleports)")

        local currentWorldIslands = (World1 and IslandTeleports.World1) or (World2 and IslandTeleports.World2) or IslandTeleports.World3
        for islandName, cf in pairs(currentWorldIslands) do
            TeleportsTab:CreateButton("الانتقال إلى " .. islandName, function()
                TweenPlayer(cf)
                AetherUI:Notify({Title = "Teleport", Content = "جاري الانتقال إلى " .. islandName, Duration = 2})
            end)
        end

        TeleportsTab:CreateSection("الانتقال السريع للشخصيات (NPC Teleports)")

        local currentWorldNpcs = (World1 and NpcTeleports.World1) or (World2 and NpcTeleports.World2) or NpcTeleports.World3
        for npcName, cf in pairs(currentWorldNpcs) do
            TeleportsTab:CreateButton("الانتقال إلى " .. npcName, function()
                TweenPlayer(cf)
                AetherUI:Notify({Title = "Teleport", Content = "جاري الانتقال إلى " .. npcName, Duration = 2})
            end)
        end

        ---------------------------------------------------------
        -- 📌 10. TAB: VISUALS
        ---------------------------------------------------------
        VisualTab:CreateSection("كاشف الأعداء ورادار HP")

        VisualTab:CreateToggle("تفعيل كاشف الوحوش (Mob ESP + HP)", "ESPFlag", false, function(state)
            _G.Settings.Visuals["ESP Enemies"] = state
        end)

        ---------------------------------------------------------
        -- 📌 11. TAB: MISC (Enhanced & Server Hops)
        ---------------------------------------------------------
        MiscTab:CreateSection("حالة السيرفر والوحوش (Live Server Info)")

        local serverTimeParagraph = MiscTab:CreateParagraph({
            Title = "وقت السيرفر",
            Desc = "جارٍ التحميل...",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local timeInServerParagraph = MiscTab:CreateParagraph({
            Title = "الوقت في السيرفر",
            Desc = "0 Hours 0 Minute 0 Second",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local cakePrinceCountParagraph = MiscTab:CreateParagraph({
            Title = "عداد الكيك برنس المتبقي",
            Desc = "جارٍ التحميل...",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local moonStatusParagraph = MiscTab:CreateParagraph({
            Title = "حالة اكتمال القمر",
            Desc = "جارٍ التحميل...",
            Image = "rbxassetid://6034453535",
            ImageSize = 20
        })

        -- تحديث دوري للمعلومات
        task.spawn(function()
            while task.wait(1) do
                pcall(function()
                    local clockTime = game.Lighting.ClockTime
                    local hours = math.floor(clockTime)
                    local minutes = math.floor((clockTime - hours) * 60)
                    serverTimeParagraph:SetDesc(string.format("%02d:%02d", hours, minutes))

                    local gameTime = math.floor(workspace.DistributedGameTime + 0.5)
                    local sH = math.floor(gameTime / 3600) % 24
                    local sM = math.floor(gameTime / 60) % 60
                    local sS = math.floor(gameTime) % 60
                    timeInServerParagraph:SetDesc(sH .. " Hours " .. sM .. " Minute " .. sS .. " Second")

                    if World3 and CommF_ then
                        local princeData = CommF_:InvokeServer("CakePrinceSpawner")
                        if typeof(princeData) == "string" then
                            if string.find(princeData, "spawned") or string.find(princeData, "ready") then
                                cakePrinceCountParagraph:SetDesc("Cake Prince Is Spawned!")
                            else
                                local rem = string.match(princeData, "%d+")
                                cakePrinceCountParagraph:SetDesc(rem and (rem .. " Enemies Remaining") or princeData)
                            end
                        end
                    else
                        cakePrinceCountParagraph:SetDesc("Sea 3 Only")
                    end

                    local sky = game.Lighting:FindFirstChildOfClass("Sky")
                    if sky then
                        if sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then
                            moonStatusParagraph:SetDesc("🌕 Full Moon 100%")
                        elseif sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149052" then
                            moonStatusParagraph:SetDesc("🌖 Full Moon 75%")
                        elseif sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709143733" then
                            moonStatusParagraph:SetDesc("🌗 Full Moon 50%")
                        else
                            moonStatusParagraph:SetDesc("🌑 Moon Low / Normal")
                        end
                    end
                end)
            end
        end)

        MiscTab:CreateSection("الانتقال لسيرفرات مخصصة (Custom Server Hops)")

        local function ServerHopCustom()
            local module = loadstring(game:HttpGet("https://raw.githubusercontent.com/raw-scriptpastebin/FE/main/Server_Hop_Settings"))()
            module:Teleport(game.PlaceId)
        end

        MiscTab:CreateButton("Join Full Moon Server", function()
            AetherUI:Notify({Title = "Server Hop", Content = "جاري البحث عن سيرفر Full Moon...", Duration = 3})
            ServerHopCustom()
        end)

        MiscTab:CreateButton("Join 4+ Hours Server", function()
            AetherUI:Notify({Title = "Server Hop", Content = "جاري البحث عن سيرفر قديم...", Duration = 3})
            ServerHopCustom()
        end)

        MiscTab:CreateButton("Join Mirage Server", function()
            AetherUI:Notify({Title = "Server Hop", Content = "جاري البحث عن سيرفر يحتوي على ميراج...", Duration = 3})
            ServerHopCustom()
        end)

        MiscTab:CreateButton("Join Factory Server (Sea 2)", function()
            if World2 then
                AetherUI:Notify({Title = "Server Hop", Content = "جاري البحث عن سيرفر مصنع...", Duration = 3})
                ServerHopCustom()
            else
                AetherUI:Notify({Title = "Warning", Content = "هذا الخيار يعمل في Sea 2 فقط!", Duration = 3})
            end
        end)

        ---------------------------------------------------------
        -- 📌 12. TAB: SETTINGS
        ---------------------------------------------------------
        SettingsTab:CreateSection("إعدادات السكربت")

        SettingsTab:CreateButton("إعادة دخول السيرفر (Rejoin)", function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)

        SettingsTab:CreateButton("إغلاق السكربت بالكامل (Destroy Hub)", function()
            local master = game:GetService("CoreGui"):FindFirstChild("HaroonHub_Master")
            if master then master:Destroy() end
        end)
    end)
end)

--------------------------------------------------------------------------------
-- 7. حلقة التلفيل الفردي والانتقال المباشر (Single-Target Master Loop)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.08) do
        if _G.Settings.Main["Auto Farm Level"] then
            pcall(function()
                local _, hrp, hum = GetCharacter()
                if hum.Health <= 0 then return end

                CheckQuest()
                AutoHaki()

                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")

                if not questGui or not questGui.Visible or not string.find(questGui.Container.QuestTitle.Title.Text, CurrentQuest.NameMon) then
                    if CommF_ then CommF_:InvokeServer("AbandonQuest") end
                    TweenPlayer(CurrentQuest.CFrameQuest * CFrame.new(0, 5, 0))

                    if (hrp.Position - CurrentQuest.CFrameQuest.Position).Magnitude <= 20 then
                        if CommF_ then CommF_:InvokeServer("StartQuest", CurrentQuest.NameQuest, CurrentQuest.LevelQuest) end
                    end
                else
                    local targetMob = nil
                    local closestDistance = math.huge

                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v:IsA("Model") and v.Name == CurrentQuest.Mon then
                            local root = v:FindFirstChild("HumanoidRootPart")
                            local mobHum = v:FindFirstChildOfClass("Humanoid")
                            if root and mobHum and mobHum.Health > 0 then
                                local dist = (hrp.Position - root.Position).Magnitude
                                if dist < closestDistance then
                                    closestDistance = dist
                                    targetMob = v
                                end
                            end
                        end
                    end

                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        local enemyRoot = targetMob.HumanoidRootPart
                        local farmPos = enemyRoot.CFrame * CFrame.new(0, _G.Settings.Main["Farm Distance"], 0)
                        
                        TweenPlayer(farmPos)
                        SmartAttackMob(targetMob)
                    else
                        TweenPlayer(CurrentQuest.CFrameMon * CFrame.new(0, _G.Settings.Main["Farm Distance"], 0))
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 8. محرك الـ Sea Farming المتكامل (Fixed Sea Events Engine)
--------------------------------------------------------------------------------
local ZoneCFrames = {
    ["Zone 1"] = CFrame.new(-21998.37, 30.00, -682.30),
    ["Zone 2"] = CFrame.new(-26779.52, 30.00, -822.85),
    ["Zone 3"] = CFrame.new(-31171.95, 30.00, -2256.93),
    ["Zone 4"] = CFrame.new(-34054.68, 30.21, -2560.12),
    ["Zone 5"] = CFrame.new(-38887.55, 30.00, -2162.99),
    ["Zone 6"] = CFrame.new(-44541.76, 30.00, -1244.85),
    ["Infinite"] = CFrame.new(-148073.35, 9.00, 7721.05)
}

local function GetMyBoat()
    if workspace:FindFirstChild("Boats") then
        for _, b in pairs(workspace.Boats:GetChildren()) do
            if b.Name == _G.Settings.Sea["Selected Boat"] and b:FindFirstChild("VehicleSeat") then
                return b
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.2) do
        if _G.Settings.Sea["Sail Boat"] and World3 then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                local boat = GetMyBoat()

                -- 1. فحص وجود أعداء البحر والتحليق لمهاجمتهم
                local seaEnemy = nil
                for _, enemyName in pairs({"Shark", "Piranha", "Fish Crew Member", "FishBoat", "PirateBrigade", "PirateGrandBrigade", "Terrorshark"}) do
                    local found = workspace.Enemies:FindFirstChild(enemyName)
                    if found and found:FindFirstChild("HumanoidRootPart") and found:FindFirstChild("Humanoid") and found.Humanoid.Health > 0 then
                        seaEnemy = found
                        break
                    end
                end

                if seaEnemy then
                    if hum.Sit then hum.Sit = false end
                    AutoHaki()
                    TweenPlayer(seaEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                    SmartAttackMob(seaEnemy)
                    return
                end

                -- فحص السي بيست
                if _G.Settings.Sea["Auto Farm Seabeasts"] and workspace:FindFirstChild("SeaBeasts") then
                    for _, sb in pairs(workspace.SeaBeasts:GetChildren()) do
                        if sb:FindFirstChild("HumanoidRootPart") and sb:FindFirstChild("Humanoid") and sb.Humanoid.Health > 0 then
                            if hum.Sit then hum.Sit = false end
                            AutoHaki()
                            local dodgeOffset = _G.Settings.Sea["Dodge Seabeasts Attack"] and Vector3.new(math.random(-50, 50), 60, math.random(-50, 50)) or Vector3.new(0, 60, 0)
                            TweenPlayer(sb.HumanoidRootPart.CFrame * CFrame.new(dodgeOffset))
                            FastAttackTarget(sb)
                            return
                        end
                    end
                end

                -- 2. شراء القارب أو ركوبه والإبحار نحو المنطقة
                if not boat then
                    local buyPos = CFrame.new(-16927.45, 9.08, 433.86)
                    if (hrp.Position - buyPos.Position).Magnitude > 30 then
                        TweenPlayer(buyPos)
                    else
                        if CommF_ then CommF_:InvokeServer("BuyBoat", _G.Settings.Sea["Selected Boat"]) end
                    end
                else
                    if not hum.Sit then
                        hrp.CFrame = boat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
                        task.wait(0.2)
                    else
                        local targetZone = ZoneCFrames[_G.Settings.Sea["Selected Zone"]] or ZoneCFrames["Zone 5"]
                        local dist = (boat.VehicleSeat.Position - targetZone.Position).Magnitude
                        if dist > 100 then
                            local tween = TweenService:Create(boat.VehicleSeat, TweenInfo.new(dist / _G.Settings.Sea["Boat Tween Speed"], Enum.EasingStyle.Linear), {CFrame = targetZone})
                            tween:Play()
                        end
                    end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 9. حلقات الصناديق والماتيريال والزعماء
--------------------------------------------------------------------------------

-- حلقة تجميع الصناديق
task.spawn(function()
    while task.wait(0.2) do
        if _G.Settings.SubFarm["Auto Chest Tween"] or _G.Settings.SubFarm["Auto Chest Instant"] then
            pcall(function()
                if _G.Settings.SubFarm["Auto Stop Items"] then
                    local bp = LocalPlayer.Backpack
                    local ch = LocalPlayer.Character
                    if bp:FindFirstChild("God's Chalice") or (ch and ch:FindFirstChild("God's Chalice")) or 
                       bp:FindFirstChild("Fist of Darkness") or (ch and ch:FindFirstChild("Fist of Darkness")) then
                        _G.Settings.SubFarm["Auto Chest Tween"] = false
                        _G.Settings.SubFarm["Auto Chest Instant"] = false
                        AetherUI:Notify({Title = "Chest Farm", Content = "تم إيقاف جمع الصناديق: تم العثور على دروب نادر!", Duration = 3})
                        return
                    end
                end

                local closestChest = nil
                local shortestDist = math.huge
                if workspace:FindFirstChild("ChestModels") then
                    for _, v in pairs(workspace.ChestModels:GetChildren()) do
                        if string.find(v.Name, "Chest") and v:FindFirstChild("RootPart") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.RootPart.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestChest = v
                            end
                        end
                    end
                end

                if closestChest then
                    if _G.Settings.SubFarm["Auto Chest Instant"] then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = closestChest.RootPart.CFrame
                    else
                        TweenPlayer(closestChest.RootPart.CFrame)
                    end
                end
            end)
        end
    end
end)

-- حلقة تجميع الماتيريال
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Main["Auto Farm Material"] then
            pcall(function()
                local mobs, pos = GetMaterialConfig(_G.Settings.Main["Selected Material"])
                local found = false

                for _, mName in pairs(mobs) do
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == mName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            found = true
                            AutoHaki()
                            TweenPlayer(v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.Main["Farm Distance"], 0))
                            SmartAttackMob(v)
                            break
                        end
                    end
                    if found then break end
                end

                if not found then
                    TweenPlayer(pos * CFrame.new(0, _G.Settings.Main["Farm Distance"], 0))
                end
            end)
        end
    end
end)

-- حلقة قتل الزعماء
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Main["Auto Farm Boss"] or _G.Settings.Main["Auto Farm All Boss"] then
            pcall(function()
                local bTarget = _G.Settings.Main["Selected Boss"]
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if (v.Name == bTarget or _G.Settings.Main["Auto Farm All Boss"]) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        AutoHaki()
                        TweenPlayer(v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(v)
                        break
                    end
                end
            end)
        end
    end
end)

-- حلقة الكيك برنس و دو كينغ
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.Cake["Auto Katakuri"] or _G.Settings.Cake["Auto Kill Cake Prince"] or _G.Settings.Cake["Auto Kill Dough King"] then
            pcall(function()
                for _, name in pairs({"Dough King", "Cake Prince"}) do
                    local boss = workspace.Enemies:FindFirstChild(name)
                    if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        AutoHaki()
                        TweenPlayer(boss.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(boss)
                        return
                    end
                end

                if _G.Settings.Cake["Auto Katakuri"] then
                    for _, kMob in pairs({"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}) do
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == kMob and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                AutoHaki()
                                TweenPlayer(v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.Main["Farm Distance"], 0))
                                SmartAttackMob(v)
                                return
                            end
                        end
                    end
                    TweenPlayer(CFrame.new(-2091.91, 70.00, -12142.83))
                end
            end)
        end
    end
end)

-- حلقة كاشف الوحوش (ESP Loop)
task.spawn(function()
    while task.wait(0.2) do
        if _G.Settings.Visuals["ESP Enemies"] and workspace:FindFirstChild("Enemies") then
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    if not v.HumanoidRootPart:FindFirstChild("HaroonESP") then
                        local bill = Instance.new("BillboardGui")
                        bill.Name = "HaroonESP"
                        bill.Adornee = v.HumanoidRootPart
                        bill.Size = UDim2.new(0, 140, 0, 55)
                        bill.StudsOffset = Vector3.new(0, 3.5, 0)
                        bill.AlwaysOnTop = true
                        bill.Parent = v.HumanoidRootPart

                        local frame = Instance.new("Frame", bill)
                        frame.Size = UDim2.new(1, 0, 1, 0)
                        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                        frame.BackgroundTransparency = 0.25
                        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

                        local nameLabel = Instance.new("TextLabel", frame)
                        nameLabel.Size = UDim2.new(1, -10, 0, 14)
                        nameLabel.Position = UDim2.new(0, 5, 0, 4)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = v.Name
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.TextSize = 10

                        local distLabel = Instance.new("TextLabel", frame)
                        distLabel.Name = "DistLabel"
                        distLabel.Size = UDim2.new(1, -10, 0, 12)
                        distLabel.Position = UDim2.new(0, 5, 0, 20)
                        distLabel.BackgroundTransparency = 1
                        distLabel.Text = "Distance: 0m"
                        distLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
                        distLabel.Font = Enum.Font.Gotham
                        distLabel.TextSize = 9

                        local hpBg = Instance.new("Frame", frame)
                        hpBg.Size = UDim2.new(1, -10, 0, 6)
                        hpBg.Position = UDim2.new(0, 5, 0, 38)
                        hpBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                        Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

                        local hpFill = Instance.new("Frame", hpBg)
                        hpFill.Name = "HPFill"
                        hpFill.Size = UDim2.new(1, 0, 1, 0)
                        hpFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                        Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)
                    else
                        local esp = v.HumanoidRootPart.HaroonESP
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local dist = math.floor((char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude)
                            local hpPercent = math.clamp(v.Humanoid.Health / v.Humanoid.MaxHealth, 0, 1)
                            esp.Frame.DistLabel.Text = "📍 Dist: " .. tostring(dist) .. " Studs"
                            esp.Frame.Frame.HPFill.Size = UDim2.new(hpPercent, 0, 1, 0)
                            esp.Frame.Frame.HPFill.BackgroundColor3 = Color3.fromHSV(hpPercent * 0.3, 0.9, 0.9)
                        end
                    end
                end
            end
        end
    end
end)
