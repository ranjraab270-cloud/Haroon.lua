-- [StarterPlayerScripts > LocalScript: HaroonHub_V12_Ultimate_Cross_Executor_Fixed]
repeat task.wait() until game:IsLoaded()
task.wait(1)

--------------------------------------------------------------------------------
-- 1. Core Services & Network Remotes
--------------------------------------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer:FindFirstChild("PlayerGui")

local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not Remotes then
    warn("Haroon Hub: Remotes folder not found in ReplicatedStorage!")
    return
end

local CommF_ = Remotes:FindFirstChild("CommF_")
local CommE = Remotes:FindFirstChild("CommE")

local Net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
local ShootGunEvent = Net and Net:FindFirstChild("RE/ShootGunEvent")

local RegisterHit = nil
pcall(function()
    if getrenv and getrenv()._G and getrenv()._G.SendHitsToServer then
        RegisterHit = debug.getupvalue(getrenv()._G.SendHitsToServer, 1)
    end
end)

if not RegisterHit and Net and Net:FindFirstChild("RE/RegisterHit") then
    RegisterHit = Net:FindFirstChild("RE/RegisterHit")
end

-- World Detection
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then World2 = true
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then World3 = true end

-- Lighting Optimizations
Lighting.Ambient = Color3.new(0.695, 0.695, 0.695)
Lighting.ColorShift_Bottom = Color3.new(0.695, 0.695, 0.695)
Lighting.ColorShift_Top = Color3.new(0.695, 0.695, 0.695)
Lighting.Brightness = 2
Lighting.FogEnd = 1e10

--------------------------------------------------------------------------------
-- 2. Global Settings Structure (All Default to False)
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
        ["Kill Aura"] = false,
        ["Kill Aura Range"] = 25,
        ["Attack Speed"] = 1,
        ["Auto Enable Haki"] = false,
    },
    Fruits = {
        ["Fruit ESP"] = false,
        ["Player ESP"] = false,
        ["Chest ESP"] = false,
        ["Island ESP"] = false,
        ["Fruit Sniper"] = false,
        ["Auto Store Fruit"] = false,
        ["Auto Drop Fruit"] = false,
        ["Auto Roll Fruit"] = false,
    },
    SubFarm = {
        ["Auto Elite Hunter"] = false,
        ["Auto Elite Hunter Hop"] = false,
        ["Auto Farm Bone"] = false,
        ["Auto Accept Bone Quest"] = false,
        ["Auto Random Surprise"] = false,
        ["Auto Chest Tween"] = false,
        ["Auto Chest Instant"] = false,
        ["Auto Stop Items"] = false,
        ["Auto Farm Leviathan"] = false,
        ["Auto Buy Leviathan Bait"] = false,
        ["Auto Spawn Leviathan Boat"] = false,
        ["Auto Mastery Melee (Tiki)"] = false,
        ["Auto Mastery Swords"] = false,
        ["Auto Mastery Blox Fruits"] = false,
        ["Auto Mastery Guns"] = false,
        ["Mastery Target HP %"] = 25,
    },
    DragonDojo = {
        ["Auto Farm Blaze Ember"] = false,
        ["Auto Collect Blaze Ember"] = false,
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
        ["Teleport To Mirage"] = false,
        ["Teleport To Blue Gear"] = false,
        ["Look Moon Ability"] = false,
        ["Teleport To Race Door"] = false,
        ["Auto Race V2 Quest"] = false,
        ["Auto Race V3 Quest"] = false,
        ["Selected Race V3"] = "Human",
        ["Auto Race V3 Ability"] = false,
        ["Auto Train"] = false,
        ["Auto Trial"] = false,
        ["Auto Buy Gear"] = false,
        ["Auto Collect Flowers"] = false,
        ["Auto Race V1-V4"] = false,
    },
    Sea = {
        ["Selected Boat"] = "Guardian",
        ["Selected Zone"] = "Zone 5",
        ["Boat Tween Speed"] = 200,
        ["Sail Boat"] = false,
        ["Ship Noclip"] = false,
        ["Auto Attack Sea Events"] = false,
        ["Sea Event Attack Range"] = 50,
        ["Auto Farm Shark"] = false,
        ["Auto Farm Piranha"] = false,
        ["Auto Farm Fish Crew Member"] = false,
        ["Auto Farm Ghost Ship"] = false,
        ["Auto Farm Terrorshark"] = false,
        ["Auto Farm Seabeasts"] = false,
        ["Dodge Seabeasts Attack"] = true,
        ["Auto Find Kitsune Island"] = false,
        ["Teleport To Kitsune Island"] = false,
        ["Auto Prehistoric Island"] = false,
        ["Auto Complete Prehistoric Island"] = false,
        ["Auto Draco Trail"] = false,
        ["Auto Frozen Dimension"] = false,
        ["Auto Drive Hydra"] = false,
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
        ["Auto Melee"] = false,
        ["Auto Defense"] = false,
        ["Auto Sword"] = false,
        ["Auto Gun"] = false,
        ["Auto Blox Fruit"] = false,
    },
    Teleports = {},
    Visuals = {
        ["ESP Players"] = false,
        ["ESP Bosses"] = false,
        ["ESP Fruits"] = false,
        ["ESP Chests"] = false,
        ["ESP Enemies"] = false,
        ["ESP Mirage Island"] = false,
        ["ESP Kitsune Island"] = false,
    },
    ItemsQuests = {
        ["Auto Sword Quest"] = false,
        ["Selected Sword Quest"] = "Saber V2",
        ["Auto Farm CDK"] = false,
        ["Auto Farm TTK"] = false,
        ["Auto Soul Guitar"] = false,
        ["Auto Godhuman"] = false,
        ["CDK Trial Type"] = "Quest Yama",
        ["Auto Buy Legendary Swords"] = false,
        ["Auto Buy Fighting Styles"] = false,
    },
    Quests = {
        ["Auto Citizen Quest"] = false,
        ["Auto Yama Puzzle"] = false,
        ["Auto Tushita Puzzle"] = false,
        ["Auto Colosseum Puzzle"] = false,
        ["Auto Dough Challenges"] = false,
        ["Auto Soul Guitar Puzzle"] = false,
    },
    Crafting = {
        ["SharkToothNecklace"] = false,
        ["TerrorJaw"] = false,
        ["MonsterMagnet"] = false,
        ["SharkAnchor"] = false,
        ["LeviathanShield"] = false,
        ["LeviathanBoat"] = false,
        ["LeviathanCrown"] = false,
        ["LegendaryScroll"] = false,
        ["MythicalScroll"] = false,
    },
    Misc = {
        ["Anti AFK"] = false,
        ["Auto Ken (Buso Haki)"] = false,
        ["Set Team to Marines"] = false,
        ["Set Team to Pirates"] = false,
        ["Walk On Water"] = false,
        ["Auto Server Hop VIP"] = false,
        ["Bypass Anticheat"] = false,
        ["Show Ping"] = false,
        ["Show FPS"] = false,
    }
}

--------------------------------------------------------------------------------
-- 3. Promo Codes Master Engine
--------------------------------------------------------------------------------
local GameCodes = {
    "LIGHTNINGABUSE", "1LOSTADMIN", "ADMINFIGHT", "NOMOREHACK", "BANEXPLOIT",
    "krazydares", "TRIPLEABUSE", "24NOADMIN", "REWARDFUN", "Chandler",
    "NEWTROLL", "KITT_RESET", "Magicbus", "Starcodeheo", "fudd10_v2",
    "Sub2UncleKizaru", "Fudd10", "Bignews", "SECRET_ADMIN", "SUB2GAMERROBOT_RESET1",
    "SUB2OFFICIALNOOBIE", "AXIORE", "BIGNEWS", "BLUXXY", "CHANDLER",
    "ENYU_IS_PRO", "FUDD10", "FUDD10_V2", "KITTGAMING", "MAGICBUS",
    "STARCODEHEO", "STRAWHATMAINE", "SUB2CAPTAINMAUI", "SUB2DAIGROCK", "SUB2FER999",
    "SUB2NOOBMASTER123", "TANTAIGAMING", "THEGREATACE", "WildDares", "BossBuild",
    "GetPranked", "FIGHT4FRUIT", "EARN_FRUITS"
}

local function RedeemAllCodes()
    task.spawn(function()
        for _, codeName in ipairs(GameCodes) do
            pcall(function()
                ReplicatedStorage.Remotes.Redeem:InvokeServer(codeName)
            end)
            task.wait(0.3)
        end
    end)
end

--------------------------------------------------------------------------------
-- 4. Anti-Fall & Vertical Safety Engine
--------------------------------------------------------------------------------
local currentTween = nil
local currentTweenOwner = nil

local function GetCharacter(): (Model?, BasePart?, Humanoid?)
    local char = LocalPlayer.Character
    if not char then char = LocalPlayer.CharacterAdded:Wait() end
    local hrp = char:FindFirstChild("HumanoidRootPart") :: BasePart?
    local hum = char:FindFirstChildOfClass("Humanoid") :: Humanoid?
    return char, hrp, hum
end

local function AnyMovementFeatureActive()
    local S = _G.Settings
    return S.Main["Auto Farm Level"] or S.Main["Auto Farm Material"] or S.Main["Auto Farm Boss"] or
           S.Main["Auto Farm All Boss"] or S.SubFarm["Auto Farm Bone"] or S.Cake["Auto Katakuri"] or
           S.Sea["Sail Boat"] or S.Race["Auto Find Mirage"] or S.Sea["Auto Find Kitsune Island"] or
           S.Raid["Auto Dungeon / Raid"] or S.Cake["Auto Kill Cake Prince"] or S.Cake["Auto Kill Dough King"] or S.Main["Auto Farm Material"] or S.SubFarm["Auto Farm Leviathan"] or S.Sea["Auto Frozen Dimension"] or S.Sea["Auto Drive Hydra"] or S.SubFarm["Auto Chest Tween"] or S.Race["Auto Train"] or
           S.SubFarm["Auto Farm Leviathan"] or S.ItemsQuests["Auto Sword Quest"] or S.ItemsQuests["Auto Farm CDK"] or
           S.ItemsQuests["Auto Farm TTK"] or S.Race["Auto Race V2 Quest"] or S.Race["Auto Race V3 Quest"] or
           S.Sea["Auto Prehistoric Island"] or S.Sea["Auto Complete Prehistoric Island"] or
           S.Sea["Auto Draco Trail"] or S.Raid["Auto Next Island"] or S.Fruits["Fruit Sniper"] or S.Quests["Auto Yama Puzzle"] or S.Quests["Auto Tushita Puzzle"] or S.Quests["Auto Colosseum Puzzle"] or S.Quests["Auto Dough Challenges"] or S.Quests["Auto Soul Guitar Puzzle"]
end

RunService.Stepped:Connect(function()
    local active = AnyMovementFeatureActive()
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
            if hrp:FindFirstChild("HaroonBV") then hrp.HaroonBV:Destroy() end
        end)
    end
end)

local function TweenPlayer(pos: CFrame | Vector3 | BasePart, offset: Vector3?, owner: string?): Tween?
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
        currentTween = nil
        currentTweenOwner = nil
        return nil
    end

    local speed = _G.Settings.Main["Player Tween Speed"] or 180
    local tweenInfo = TweenInfo.new(math.max(0.05, distance / speed), Enum.EasingStyle.Linear)
    if currentTween then currentTween:Cancel() end
    currentTweenOwner = owner or "Generic"
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = uprightCFrame})
    currentTween:Play()
    return currentTween
end

local function StopTween(owner: string?)
    if owner and currentTweenOwner and currentTweenOwner ~= owner and AnyMovementFeatureActive() then
        return
    end
    if currentTween then currentTween:Cancel() end
    currentTween = nil
    currentTweenOwner = nil
    local _, hrp = GetCharacter()
    if hrp and hrp:FindFirstChild("HaroonBV") and not AnyMovementFeatureActive() then
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
-- 5. Combat & Fast Attack Engine
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
        if hpPercent > (_G.Settings.SubFarm["Mastery Target HP %"] / 100) then
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
-- 6. Quests & Islands Database
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
    "Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail"
}) or (World2 and {
    "Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet",
    "Magma Ore", "Vampire Fang"
}) or (World3 and {
    "Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder",
    "Fish Tail", "Mini Tusk"
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
    ["Tiki Mastery Farm"] = CFrame.new(-16547.74, 61.13, -173.41),
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
-- Integrated Blox Fruits Systems From Attachment
--------------------------------------------------------------------------------
local IntegratedMaterialByWorld = {
    [1] = {
        ["Angel Wings"]={Mobs={"God's Guard","Shanda","Royal Squad","Royal Soldier","Wysper","Thunder God"},Position=CFrame.new(-4698,845,-1912),Entrance=Vector3.new(-4607.8,872.5,-1667.5)},
        ["Leather + Scrap Metal"]={Mobs={"Brute","Pirate"},Position=CFrame.new(-1145,15,4350)},
        ["Magma Ore"]={Mobs={"Military Soldier","Military Spy","Magma Admiral"},Position=CFrame.new(-5815,84,8820)},
        ["Fish Tail"]={Mobs={"Fishman Warrior","Fishman Commando","Fishman Lord"},Position=CFrame.new(61123,19,1569),Entrance=Vector3.new(61163.8,5.3,1819.7)},
    },
    [2] = {
        ["Leather + Scrap Metal"]={Mobs={"Marine Captain","Mercenary"},Position=CFrame.new(-2010,73,-3326)},
        ["Magma Ore"]={Mobs={"Magma Ninja","Lava Pirate"},Position=CFrame.new(-5428,78,-5959)},
        ["Ectoplasm"]={Mobs={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"},Position=CFrame.new(911,125,33159),Entrance=Vector3.new(61163.8,5.3,1819.7)},
        ["Mystic Droplet"]={Mobs={"Water Fighter"},Position=CFrame.new(-3385,239,-10542)},
        ["Radioactive Material"]={Mobs={"Factory Staff"},Position=CFrame.new(295,73,-56)},
        ["Vampire Fang"]={Mobs={"Vampire"},Position=CFrame.new(-6033,7,-1317)},
    },
    [3] = {
        ["Scrap Metal"]={Mobs={"Jungle Pirate","Forest Pirate","Pirate Millionaire"},Position=CFrame.new(-11975,332,-10620)},
        ["Fish Tail"]={Mobs={"Fishman Raider","Fishman Captain"},Position=CFrame.new(-10993,332,-8940)},
        ["Conjured Cocoa"]={Mobs={"Chocolate Bar Battler","Cocoa Warrior"},Position=CFrame.new(620,79,-12581)},
        ["Dragon Scale"]={Mobs={"Dragon Crew Archer","Dragon Crew Warrior"},Position=CFrame.new(6594,383,139)},
        ["Gunpowder"]={Mobs={"Pistol Billionaire"},Position=CFrame.new(-84,86,6132)},
        ["Mini Tusk"]={Mobs={"Mythological Pirate"},Position=CFrame.new(-13545,470,-6917)},
        ["Demonic Wisp"]={Mobs={"Demonic Soul"},Position=CFrame.new(-9495,454,5977)},
    },
}

local function integratedFindEnemy(names,center,radius)
    if type(names)=="string" then names={names} end
    local enemies=workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local best,bestD=nil,math.huge
    for _,name in ipairs(names) do
        local obj=enemies:FindFirstChild(name)
        if obj then
            local hum=obj:FindFirstChildOfClass("Humanoid"); local root=obj:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health>0 and root then
                local d=center and (root.Position-center).Magnitude or 0
                if (not radius or d<=radius) and d<bestD then best,bestD=obj,d end
            end
        end
    end
    if best then return best end
    for _,obj in ipairs(enemies:GetChildren()) do
        if obj:IsA("Model") and table.find(names,obj.Name) then
            local hum=obj:FindFirstChildOfClass("Humanoid"); local root=obj:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health>0 and root then
                local d=center and (root.Position-center).Magnitude or 0
                if (not radius or d<=radius) and d<bestD then best,bestD=obj,d end
            end
        end
    end
    return best
end

local function integratedItem(name)
    local bp=LocalPlayer:FindFirstChildOfClass("Backpack")
    local c=LocalPlayer.Character
    return (bp and bp:FindFirstChild(name)) or (c and c:FindFirstChild(name))
end

local function integratedMaterialCount(name)
    local data=LocalPlayer:FindFirstChild("Data")
    local inv=data and data:FindFirstChild("Inventory")
    local val=inv and inv:FindFirstChild(name)
    if val and val:IsA("NumberValue") then return val.Value end
    local result
    local ok=pcall(function() result=CommF_:InvokeServer("getInventory") end)
    if ok and type(result)=="table" then
        for _,item in pairs(result) do
            if type(item)=="table" and item.Name==name then return tonumber(item.Count or item.Amount or 0) or 0 end
        end
    end
    return 0
end

local function integratedCakeProgress()
    if not World3 then return 0,500,false end
    local result
    local ok=pcall(function() result=CommF_:InvokeServer("CakePrinceSpawner") end)
    if not ok then return 0,500,false end
    if tostring(result):lower():find("spawned") or integratedFindEnemy("Cake Prince") then return 500,0,true end
    local n=tonumber(string.match(tostring(result or ""),"%d+"))
    if n then n=math.clamp(n,0,500); return 500-n,n,false end
    return 0,500,false
end

local function getCakePrinceProgressIntegrated()
    local killed,remaining,spawned=integratedCakeProgress()
    if spawned then return "🟢 Spawned | Progress: 500/500 | Remaining: 0" end
    return string.format("🔴 Not Spawned | Progress: %d/500 | Remaining: %d", killed or 0, remaining or 500)
end

local function getDoughKingStatusText()
    if not World3 then return "🔴 Third Sea only | Progress: 0/500 | Remaining: 500 | Sweet Chalice: ❌" end
    local boss=integratedFindEnemy("Dough King")
    local sweet=integratedItem("Sweet Chalice") ~= nil
    local chalice=integratedItem("God's Chalice") ~= nil
    local killed,remaining,spawned=integratedCakeProgress()
    if boss then return "🟢 Spawned | Progress: 500/500 | Remaining: 0 | Sweet Chalice: "..(sweet and "✅" or "❌") end
    if sweet then return "🟢 Ready | Progress: 500/500 | Remaining: 0 | Sweet Chalice: ✅" end
    return string.format("🔴 Not Spawned | Progress: %d/500 | Remaining: %d | God's Chalice: %s", killed or 0, remaining or 500, chalice and "✅" or "❌")
end

local function integratedCakeStep()
    local boss=integratedFindEnemy("Cake Prince")
    if boss then
        AutoHaki(); TweenPlayer(boss.HumanoidRootPart.CFrame,Vector3.new(0,25,0),"CakePrince"); SmartAttackMob(boss); return
    end
    local mob=integratedFindEnemy({"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"})
    if mob then AutoHaki(); TweenPlayer(mob.HumanoidRootPart.CFrame,Vector3.new(0,25,0),"CakePrince"); SmartAttackMob(mob); return end
    TweenPlayer(CFrame.new(-2077,252,-12373),nil,"CakePrince")
end

local function integratedSummonCake()
    local _,remaining,spawned=integratedCakeProgress()
    if spawned or remaining>0 then return end
    local map=workspace:FindFirstChild("Map")
    local cakeMap=map and cakeMap or nil
    local mirror=cakeMap and cakeMap:FindFirstChild("CakeLoaf") and cakeMap.CakeLoaf:FindFirstChild("BigMirror")
    if mirror then
        local other=mirror:FindFirstChild("Other")
        if other and other:IsA("BasePart") and other.Transparency>0 then
            pcall(function() CommF_:InvokeServer("CakePrinceSpawner",true) end)
        end
    else
        pcall(function() CommF_:InvokeServer("CakePrinceSpawner",true) end)
    end
end

local function integratedDoughStep()
    local boss=integratedFindEnemy("Dough King")
    if boss then
        AutoHaki(); TweenPlayer(boss.HumanoidRootPart.CFrame,Vector3.new(0,30,0),"DoughKing"); SmartAttackMob(boss); return
    end
    if integratedMaterialCount("Conjured Cocoa") < 10 then
        local mob=integratedFindEnemy({"Cocoa Warrior","Chocolate Bar Battler"})
        if mob then AutoHaki(); TweenPlayer(mob.HumanoidRootPart.CFrame,Vector3.new(0,25,0),"DoughKing"); SmartAttackMob(mob)
        else TweenPlayer(CFrame.new(402,81,-12259),nil,"DoughKing") end
        return
    end
    if integratedItem("God's Chalice") then pcall(function() CommF_:InvokeServer("SweetChaliceNpc") end) end
    if integratedItem("Sweet Chalice") then pcall(function() CommF_:InvokeServer("CakePrinceSpawner",true) end) end
end

local MaterialState={Target=nil,LastMaterial=nil}
local function buildMaterialConfig(material)
    local cfg=IntegratedMaterialByWorld[World] and IntegratedMaterialByWorld[World][material]
    if cfg then return cfg end
    local mobs,pos=GetMaterialConfig(material)
    if mobs and #mobs>0 then return {Mobs=mobs,Position=pos} end
end

local function findMaterialTarget(cfg,origin)
    if not cfg or not cfg.Mobs then return nil end
    local target=integratedFindEnemy(cfg.Mobs,origin,1500)
    if target then return target end
    return integratedFindEnemy(cfg.Mobs,nil,nil)
end

local function integratedMaterialStep()
    local material=_G.Settings.Main["Selected Material"]
    if MaterialState.LastMaterial~=material then MaterialState.Target=nil; MaterialState.LastMaterial=material end
    local cfg=buildMaterialConfig(material)
    if not cfg then return end
    local _,hrp,hum=GetCharacter(); if not hrp or not hum or hum.Health<=0 then return end
    local target=MaterialState.Target
    local valid=target and target.Parent and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChildOfClass("Humanoid") and target.Humanoid.Health>0 and table.find(cfg.Mobs,target.Name)
    if not valid then target=findMaterialTarget(cfg,hrp.Position); MaterialState.Target=target end
    if target then
        local tr=target:FindFirstChild("HumanoidRootPart"); local th=target:FindFirstChildOfClass("Humanoid")
        if tr and th and th.Health>0 then
            local desired=tr.Position+Vector3.new(0,math.max(22,tonumber(_G.Settings.Main["Farm Distance"]) or 28),0)
            if (hrp.Position-desired).Magnitude>12 then TweenPlayer(CFrame.new(desired),nil,"Material") else
                if currentTween and currentTweenOwner=="Material" then pcall(function() currentTween:Cancel() end); currentTween=nil end
                currentTweenOwner="Material"; pcall(function() hrp.CFrame=CFrame.new(desired); hrp.AssemblyLinearVelocity=Vector3.zero; hrp.AssemblyAngularVelocity=Vector3.zero end)
            end
            AutoHaki(); SmartAttackMob(target); return
        end
    end
    MaterialState.Target=nil
    if cfg.Entrance and (hrp.Position-cfg.Entrance).Magnitude>1000 then pcall(function() CommF_:InvokeServer("requestEntrance",cfg.Entrance) end); task.wait(0.25) end
    local desired=cfg.Position.Position+Vector3.new(0,28,0)
    if (hrp.Position-desired).Magnitude>30 then TweenPlayer(cfg.Position,Vector3.new(0,28,0),"Material") end
end

local function integratedLeviathanStep()
    local sea=workspace:FindFirstChild("SeaBeasts")
    local levi=sea and (sea:FindFirstChild("Leviathan") or sea:FindFirstChild("LeviathanCore"))
    local target=levi and (levi:FindFirstChild("HumanoidRootPart") or levi.PrimaryPart)
    if target then AutoHaki(); TweenPlayer(target.CFrame,Vector3.new(0,50,0),"Leviathan"); FastAttackTarget(levi) end
end

local function integratedFrozenStep()
    local gate=workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("LeviathanGate")
    if gate then
        local part=gate:IsA("BasePart") and gate or gate:FindFirstChildWhichIsA("BasePart",true)
        if part then TweenPlayer(part.CFrame,nil,"Frozen") end
        pcall(function() CommF_:InvokeServer("OpenLeviathanGate") end)
    end
end

local function integratedHydraStep()
    local boat=GetMyBoatIntegrated and GetMyBoatIntegrated() or nil
    if not boat then ensureBoat(); return end
    local seat=getBoatSeat(boat)
    local _,hrp,hum=GetCharacter()
    if seat and hum and not hum.Sit then pcall(function() hrp.CFrame=seat.CFrame*CFrame.new(0,2.5,0) end); return end
    if seat then moveBoatOverSea(boat,CFrame.new(5433,35,290),true) end
end

-- Independent controllers; each stops as soon as its own flag becomes false.
task.spawn(function() while task.wait(0.25) do if _G.Settings.Cake["Auto Kill Cake Prince"] then pcall(integratedCakeStep) end end end)
task.spawn(function() while task.wait(1.5) do if _G.Settings.Cake["Auto Spawn Cake Prince"] then pcall(integratedSummonCake) end end end)
task.spawn(function() while task.wait(0.25) do if _G.Settings.Cake["Auto Kill Dough King"] then pcall(integratedDoughStep) end end end)
task.spawn(function() while task.wait(0.15) do if _G.Settings.Main["Auto Farm Material"] then pcall(integratedMaterialStep) else MaterialState.Target=nil end end end)
task.spawn(function() while task.wait(0.25) do if _G.Settings.SubFarm["Auto Farm Leviathan"] then pcall(integratedLeviathanStep) end end end)

--------------------------------------------------------------------------------
-- 10B. RAID ENGINE v2 - persistent scanner / delayed-spawn safe
--------------------------------------------------------------------------------
local RaidController={Index=1,LastJob=tostring(game.JobId),Target=nil,SeenEnemy={},EmptySince=0}
local function resetRaidController()
    RaidController={Index=1,LastJob=tostring(game.JobId),Target=nil,SeenEnemy={},EmptySince=0}
    StopTween("Raid")
end
local function raidIslandCF(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj.CFrame end
    if obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart.CFrame end
        local ok,cf=pcall(function() return obj:GetPivot() end); if ok then return cf end
    end
end
local function getRaidIslandsSorted()
    local found={}
    local roots={workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Locations"),workspace:FindFirstChild("Locations"),workspace:FindFirstChild("Map")}
    local patterns={"[Ii]sland%s*<?%s*(%d+)%s*>?","[Rr]aid%s*[Ii]sland%s*<?%s*(%d+)%s*>?","<%s*[Ii]sland%s*(%d+)%s*>"}
    for _,folder in ipairs(roots) do if folder then for _,obj in ipairs(folder:GetChildren()) do
        local n; for _,pat in ipairs(patterns) do n=tonumber(string.match(obj.Name,pat)); if n then break end end
        if n and n>=1 and n<=5 and not found[n] then found[n]=raidIslandCF(obj) end
    end end end
    return found
end
local function getRaidTargets(center,radius)
    local enemies=workspace:FindFirstChild("Enemies"); if not enemies or not center then return {} end
    local list={}; local _,hrp=GetCharacter()
    for _,mob in ipairs(enemies:GetChildren()) do
        if mob:IsA("Model") then
            local h=mob:FindFirstChildOfClass("Humanoid"); local r=mob:FindFirstChild("HumanoidRootPart")
            if h and h.Health>0 and r and (r.Position-center).Magnitude<=radius then table.insert(list,mob) end
        end
    end
    if hrp then table.sort(list,function(a,b) local ar=a:FindFirstChild("HumanoidRootPart"); local br=b:FindFirstChild("HumanoidRootPart"); return ar and br and (ar.Position-hrp.Position).Magnitude<(br.Position-hrp.Position).Magnitude end) end
    return list
end
local function raidStableAttack(target)
    local _,hrp,hum=GetCharacter(); local tr=target and target:FindFirstChild("HumanoidRootPart"); local th=target and target:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health<=0 or not tr or not th or th.Health<=0 then RaidController.Target=nil; return false end
    local hover=math.max(22,tonumber(_G.Settings.Main["Farm Distance"]) or 28); local desired=tr.Position+Vector3.new(0,hover,0)
    RaidController.Target=target; RaidController.EmptySince=0; RaidController.SeenEnemy[RaidController.Index]=true
    if (hrp.Position-desired).Magnitude>12 then TweenPlayer(CFrame.new(desired),nil,"Raid") else
        if currentTween and currentTweenOwner=="Raid" then pcall(function() currentTween:Cancel() end); currentTween=nil end
        currentTweenOwner="Raid"; pcall(function() hrp.CFrame=CFrame.new(desired); hrp.AssemblyLinearVelocity=Vector3.zero; hrp.AssemblyAngularVelocity=Vector3.zero end)
    end
    AutoHaki(); SmartAttackMob(target); return true
end
local function raidStep(allowAdvance)
    if RaidController.LastJob~=tostring(game.JobId) then resetRaidController() end
    local islands=getRaidIslandsSorted(); local current=islands[RaidController.Index]
    if not current then return end
    local targets=getRaidTargets(current.Position,1000)
    if #targets>0 then raidStableAttack(targets[1]); return end
    RaidController.Target=nil
    local _,hrp=GetCharacter(); if not hrp then return end
    local desired=current*CFrame.new(0,35,0)
    if (hrp.Position-desired.Position).Magnitude>40 then TweenPlayer(desired,nil,"Raid") end
    -- Do not advance until an enemy was actually observed on this island.
    if not allowAdvance or not RaidController.SeenEnemy[RaidController.Index] then RaidController.EmptySince=0; return end
    if RaidController.EmptySince==0 then RaidController.EmptySince=os.clock(); return end
    if os.clock()-RaidController.EmptySince<1.25 then return end
    if RaidController.Index<5 then RaidController.Index+=1; RaidController.EmptySince=0; RaidController.Target=nil end
end
RunService.Heartbeat:Connect(function()
    local R=_G.Settings.Raid; if not (R["Auto Clear Dungeon Waves"] or R["Auto Next Island"]) then return end
    local t=RaidController.Target; local _,hrp,hum=GetCharacter(); local tr=t and t:FindFirstChild("HumanoidRootPart"); local th=t and t:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or not tr or not th or th.Health<=0 then return end
    local desired=tr.Position+Vector3.new(0,math.max(22,tonumber(_G.Settings.Main["Farm Distance"]) or 28),0)
    if (hrp.Position-desired).Magnitude<35 then pcall(function() hrp.CFrame=CFrame.new(desired); hrp.AssemblyLinearVelocity=Vector3.zero; hrp.AssemblyAngularVelocity=Vector3.zero end) end
end)
--------------------------------------------------------------------------------
-- 7. AetherUI Framework Integration (100% Full English Interface)
--------------------------------------------------------------------------------
local AetherUI = nil
local success_ui, err_ui = pcall(function()
    AetherUI = loadstring(game:HttpGet("https://pastebin.com/raw/yeULgMe0"))()
end)

if not success_ui or not AetherUI then
    warn("Haroon Hub: Failed to load AetherUI library. Error:", err_ui)
    return
end

AetherUI:InitLoadingScreen("Haroon Hub V12 Master Edition", "Initializing Modules & Auto Engines...", function()
    AetherUI:InitKeySystem({"HAROON-2025-VIP", "HAROON-KEY-100"}, function()
        AetherUI:Notify({Title = "Haroon Hub V12 Active", Content = "Successfully loaded all modules in 100% English!", Duration = 4})

        local Window = AetherUI:CreateWindow({
            Title = "Haroon Hub | Blox Fruits Master",
            Subtitle = "by: 3amek4222",
            ToggleKey = Enum.KeyCode.RightControl
        })

        local MainTab = Window:CreateTab("Main Farm", "rbxassetid://6034287594")
        local QuestsTab = Window:CreateTab("All Quests", "rbxassetid://6034453535")
        local ShopTab = Window:CreateTab("Shop & Upgrades", "rbxassetid://6031280882")
        local SubFarmTab = Window:CreateTab("Subs Farm", "rbxassetid://6034834832")
        local RaidTab = Window:CreateTab("Dungeons & Raids", "rbxassetid://6034834832")
        local SeaTab = Window:CreateTab("Sea Events & Prehistoric", "rbxassetid://6034453535")
        local RaceTab = Window:CreateTab("Race V4 & Mirage", "rbxassetid://6034453535")
        local ItemsTab = Window:CreateTab("Items & Swords", "rbxassetid://6034834832")
        local FruitsTab = Window:CreateTab("Fruits & Sniper", "rbxassetid://6034453535")
        local DragonDojoTab = Window:CreateTab("Dragon Dojo", "rbxassetid://6034453535")
        local CombatTab = Window:CreateTab("Combat & PVP", "rbxassetid://6034834832")
        local CraftingTab = Window:CreateTab("Crafting", "rbxassetid://6034834832")
        local TeleportsTab = Window:CreateTab("Teleports", "rbxassetid://6034453535")
        local VisualTab = Window:CreateTab("Visuals & ESP", "rbxassetid://6034453535")
        local MiscTab = Window:CreateTab("Misc & Server Status", "rbxassetid://6031280882")
        local SettingsTab = Window:CreateTab("Settings", "rbxassetid://6031280882")

        ---------------------------------------------------------
        -- 📌 1. TAB: MAIN FARM
        ---------------------------------------------------------
        MainTab:CreateSection("Level Farm Configuration")

        MainTab:CreateToggle("Auto Farm Level", "AutoFarmFlag", false, function(state)
            _G.Settings.Main["Auto Farm Level"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateToggle("Include Boss Quests", "IncludeBossQuestFlag", false, function(state)
            _G.Settings.Main["Include Boss Quests"] = state
        end)

        MainTab:CreateDropdown("Select Farm Weapon", "WeaponFlag", {"Melee", "Sword", "Blox Fruit", "Gun"}, "Melee", function(selected)
            _G.Settings.Main["Select Weapon"] = selected
        end)

        MainTab:CreateSlider("Farm Distance Above Target", "FarmDistFlag", 10, 50, 28, function(val)
            _G.Settings.Main["Farm Distance"] = val
        end)

        MainTab:CreateSlider("Player Tween Speed", "TweenSpeedFlag", 100, 300, 180, function(val)
            _G.Settings.Main["Player Tween Speed"] = val
        end)

        MainTab:CreateToggle("Fast Attack Speed", "FastAttackFlag", false, function(state)
            _G.Settings.Main["Fast Attack"] = state
        end)

        MainTab:CreateSection("Cake Prince & Dough King")
        MainTab:CreateToggle("Auto Kill Cake Prince", "AutoKillCakePrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Cake Prince"] = state
            if not state then StopTween("CakePrince") end
        end)
        MainTab:CreateToggle("Auto Spawn Cake Prince", "AutoSpawnCakePrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Spawn Cake Prince"] = state
        end)
        MainTab:CreateToggle("Auto Kill Dough King", "AutoKillDoughKingFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Dough King"] = state
            if not state then StopTween("DoughKing") end
        end)

        MainTab:CreateSection("Materials Farming")

        MainTab:CreateDropdown("Select Material", "MatDropdownFlag", MaterialList, MaterialList[1], function(selected)
            _G.Settings.Main["Selected Material"] = selected
        end)

        MainTab:CreateToggle("Auto Farm Material", "FarmMatFlag", false, function(state)
            _G.Settings.Main["Auto Farm Material"] = state
            if not state then MaterialState.Target=nil; StopTween("Material") end
        end)

        MainTab:CreateSection("Boss Farming")

        MainTab:CreateDropdown("Select Target Boss", "BossDropdownFlag", BossList, BossList[1], function(selected)
            _G.Settings.Main["Selected Boss"] = selected
        end)

        MainTab:CreateToggle("Auto Farm Selected Boss", "FarmBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm Boss"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateToggle("Auto Farm All Available Bosses", "FarmAllBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm All Boss"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 2. TAB: ALL QUESTS (Including Citizen Quests)
        ---------------------------------------------------------
        QuestsTab:CreateSection("Quest Controller")

        QuestsTab:CreateButton("Accept Current Level Quest", function()
            CheckQuest()
            if CommF_ then CommF_:InvokeServer("StartQuest", CurrentQuest.NameQuest, CurrentQuest.LevelQuest) end
            AetherUI:Notify({Title = "Quests", Content = "Accepted quest: " .. CurrentQuest.NameMon, Duration = 2})
        end)

        QuestsTab:CreateButton("Abandon Current Quest", function()
            if CommF_ then CommF_:InvokeServer("AbandonQuest") end
            AetherUI:Notify({Title = "Quests", Content = "Current quest abandoned!", Duration = 2})
        end)

        QuestsTab:CreateSection("Citizen Quests Module")

        QuestsTab:CreateToggle("Auto Citizen Quest Complete", "CitizenQuestFlag", false, function(state)
            _G.Settings.Quests["Auto Citizen Quest"] = state
            if not state then StopTween() end
        end)

        QuestsTab:CreateButton("Start Citizen Quest Immediately", function()
            if CommF_ then
                CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
                AetherUI:Notify({Title = "Citizen Quest", Content = "Citizen Quest Started!", Duration = 2})
            end
        end)

        QuestsTab:CreateSection("Puzzles & Special Challenges")
        QuestsTab:CreateToggle("Auto Yama Puzzle", "YamaPuzzleFlag", false, function(s) _G.Settings.Quests["Auto Yama Puzzle"] = s; if not s then StopTween("Puzzle") end end)
        QuestsTab:CreateToggle("Auto Tushita Puzzle", "TushitaPuzzleFlag", false, function(s) _G.Settings.Quests["Auto Tushita Puzzle"] = s; if not s then StopTween("Puzzle") end end)
        QuestsTab:CreateToggle("Auto Colosseum Puzzle", "ColosseumPuzzleFlag", false, function(s) _G.Settings.Quests["Auto Colosseum Puzzle"] = s; if not s then StopTween("Puzzle") end end)
        QuestsTab:CreateToggle("Auto Dough / Cake Challenges", "DoughChallengeFlag", false, function(s) _G.Settings.Quests["Auto Dough Challenges"] = s; if not s then StopTween("Puzzle") end end)
        QuestsTab:CreateToggle("Auto Soul Guitar Puzzle", "SoulGuitarPuzzleFlag", false, function(s) _G.Settings.Quests["Auto Soul Guitar Puzzle"] = s; if not s then StopTween("Puzzle") end end)

        ---------------------------------------------------------
        -- 📌 3. TAB: SHOP & UPGRADES (Full Extracted Shop)
        ---------------------------------------------------------
        ShopTab:CreateSection("Sea Travel & Teleports")
        ShopTab:CreateButton("Travel to First Sea", function() if CommF_ then CommF_:InvokeServer("TravelMain") end end)
        ShopTab:CreateButton("Travel to Second Sea", function() if CommF_ then CommF_:InvokeServer("TravelDressrosa") end end)
        ShopTab:CreateButton("Travel to Third Sea", function() if CommF_ then CommF_:InvokeServer("TravelZou") end end)

        ShopTab:CreateSection("General Shop Items")
        ShopTab:CreateButton("Buy Dual Flintlock", function() if CommF_ then CommF_:InvokeServer("BuyItem", "Dual Flintlock") end end)
        ShopTab:CreateButton("Reroll Race (Beli/Fragments)", function()
            if CommF_ then
                CommF_:InvokeServer("BlackbeardReward", "Reroll", "1")
                CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
            end
        end)
        ShopTab:CreateButton("Reset Stats Refund", function()
            if CommF_ then
                CommF_:InvokeServer("BlackbeardReward", "Refund", "1")
                CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
            end
        end)
        ShopTab:CreateButton("Buy Ghoul Race", function()
            if CommF_ then
                CommF_:InvokeServer("Ectoplasm", "BuyCheck", 4)
                CommF_:InvokeServer("Ectoplasm", "Change", 4)
            end
        end)
        ShopTab:CreateButton("Buy Cyborg Race", function() if CommF_ then CommF_:InvokeServer("CyborgTrainer", "Buy") end end)

        ShopTab:CreateSection("Fighting Styles Shop")
        ShopTab:CreateButton("Buy Black Leg ($150,000)", function() if CommF_ then CommF_:InvokeServer("BuyBlackLeg") end end)
        ShopTab:CreateButton("Buy Fishman Karate ($750,000)", function() if CommF_ then CommF_:InvokeServer("BuyFishmanKarate") end end)
        ShopTab:CreateButton("Buy Electro ($500,000)", function() if CommF_ then CommF_:InvokeServer("BuyElectro") end end)
        ShopTab:CreateButton("Buy Dragon Breath (1,500 Frags)", function() if CommF_ then CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2") end end)
        ShopTab:CreateButton("Buy Superhuman ($3,000,000)", function() if CommF_ then CommF_:InvokeServer("BuySuperhuman") end end)
        ShopTab:CreateButton("Buy Death Step ($2,500,000 + 5k Frags)", function() if CommF_ then CommF_:InvokeServer("BuyDeathStep") end end)
        ShopTab:CreateButton("Buy Sharkman Karate ($2,500,000 + 5k Frags)", function() if CommF_ then CommF_:InvokeServer("BuySharkmanKarate") end end)
        ShopTab:CreateButton("Buy Electric Claw ($3,000,000 + 3k Frags)", function() if CommF_ then CommF_:InvokeServer("BuyElectricClaw") end end)
        ShopTab:CreateButton("Buy Dragon Talon ($3,000,000 + 5k Frags)", function() if CommF_ then CommF_:InvokeServer("BuyDragonTalon") end end)
        ShopTab:CreateButton("Buy Godhuman ($5,000,000 + 5k Frags)", function() if CommF_ then CommF_:InvokeServer("BuyGodhuman") end end)
        ShopTab:CreateButton("Buy Sanguine Art ($5,000,000 + 5k Frags)", function() if CommF_ then CommF_:InvokeServer("BuySanguineArt") end end)

        ShopTab:CreateSection("Ability & Haki Shop")
        ShopTab:CreateButton("Buy Skyjump / Geppo ($10,000)", function() if CommF_ then CommF_:InvokeServer("BuyHaki", "Geppo") end end)
        ShopTab:CreateButton("Buy Buso Haki ($25,000)", function() if CommF_ then CommF_:InvokeServer("BuyHaki", "Buso") end end)
        ShopTab:CreateButton("Buy Observation Haki ($750,000)", function() if CommF_ then CommF_:InvokeServer("KenTalk", "Buy") end end)
        ShopTab:CreateButton("Buy Soru ($100,000)", function() if CommF_ then CommF_:InvokeServer("BuyHaki", "Soru") end end)

        ShopTab:CreateSection("Auto Buy Upgrades")
        ShopTab:CreateToggle("Auto Buy Legendary Swords", "AutoBuyLegSwordsFlag", false, function(s) _G.Settings.ItemsQuests["Auto Buy Legendary Swords"] = s end)

        ---------------------------------------------------------
        -- 📌 4. TAB: SUBS FARM
        ---------------------------------------------------------
        SubFarmTab:CreateSection("Smart Mastery Engine")

        SubFarmTab:CreateToggle("Melee Mastery (Tiki Outpost)", "AutoMasteryMeleeFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Melee (Tiki)"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("Swords Mastery", "AutoMasterySwordsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Swords"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("Blox Fruits Mastery", "AutoMasteryBloxFruitsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Blox Fruits"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("Guns Mastery", "AutoMasteryGunsFlag", false, function(state)
            _G.Settings.SubFarm["Auto Mastery Guns"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateSlider("Target HP % to Switch Weapon Skills", "MasteryHPSlider", 10, 50, 25, function(val)
            _G.Settings.SubFarm["Mastery Target HP %"] = val
        end)

        SubFarmTab:CreateSection("Elite Hunter & Bone Farming")

        SubFarmTab:CreateToggle("Auto Farm Bones", "AutoFarmBoneFlag", false, function(state)
            _G.Settings.SubFarm["Auto Farm Bone"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("Auto Accept Bone Quest", "AutoAcceptBoneQuestFlag", false, function(state)
            _G.Settings.SubFarm["Auto Accept Bone Quest"] = state
        end)

        SubFarmTab:CreateToggle("Auto Random Surprise (Death King)", "AutoRandomSurpriseFlag", false, function(state)
            _G.Settings.SubFarm["Auto Random Surprise"] = state
        end)

        SubFarmTab:CreateToggle("Auto Elite Hunter", "EliteFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("Auto Elite Hunter Hop", "EliteHopFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter Hop"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateSection("Chests Farming")

        SubFarmTab:CreateToggle("Auto Chest (Tween)", "ChestTweenFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Tween"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("Auto Chest (Instant)", "ChestInstantFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Instant"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 5. TAB: DUNGEONS & RAIDS (Enhanced Auto Next Island - 5 Islands Check)
        ---------------------------------------------------------
        RaidTab:CreateSection("Dungeon & Fruits Raid Controller")

        RaidTab:CreateDropdown("Select Raid Chip", "DungeonChipDropdown", DungeonChips, DungeonChips[1], function(selected)
            _G.Settings.Raid["Selected Chip"] = selected
        end)

        RaidTab:CreateToggle("Auto Dungeon / Fruits Raid", "AutoDungeonFlag", false, function(state)
            _G.Settings.Raid["Auto Dungeon / Raid"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("Auto Buy Chip & Start Raid", "AutoBuyStartRaidFlag", false, function(state)
            _G.Settings.Raid["Auto Buy Chip & Start"] = state
        end)

        RaidTab:CreateToggle("Auto Clear Dungeon Waves", "AutoClearDungeonFlag", false, function(state)
            _G.Settings.Raid["Auto Clear Dungeon Waves"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("Auto Next Island (5 Islands Full Scanner)", "AutoNextIslandFlag", false, function(state)
            _G.Settings.Raid["Auto Next Island"] = state
            if not state then StopTween() end
        end)

        RaidTab:CreateToggle("Auto Awaken Skills", "AutoAwakenSkillsFlag", false, function(state)
            _G.Settings.Raid["Auto Awaken"] = state
        end)

        RaidTab:CreateToggle("Auto Law Raid", "LawRaidFlag", false, function(state)
            _G.Settings.Raid["Law Raid"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 6. TAB: SEA EVENTS & PREHISTORIC
        ---------------------------------------------------------
        SeaTab:CreateSection("Prehistoric Island Engine")

        SeaTab:CreateButton("Teleport to Prehistoric Island", function()
            TweenPlayer(MobSpecificTeleports["Prehistoric Island"])
            AetherUI:Notify({Title = "Teleport", Content = "Teleporting to Prehistoric Island...", Duration = 2})
        end)

        SeaTab:CreateToggle("Auto Prehistoric Island", "AutoPrehistoricFlag", false, function(state)
            _G.Settings.Sea["Auto Prehistoric Island"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("Auto Complete Prehistoric Torches", "AutoCompletePrehistoricFlag", false, function(state)
            _G.Settings.Sea["Auto Complete Prehistoric Island"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("Auto Draco Trail", "AutoDracoTrailFlag", false, function(state)
            _G.Settings.Sea["Auto Draco Trail"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateSection("Advanced Sea Engines")

        SeaTab:CreateToggle("Auto Attack Leviathan", "AutoLeviathanFlag", false, function(state)
            _G.Settings.SubFarm["Auto Farm Leviathan"] = state
            if not state then StopTween("Leviathan") end
        end)

        SeaTab:CreateToggle("Auto Frozen Dimension", "AutoFrozenDimensionFlag", false, function(state)
            _G.Settings.Sea["Auto Frozen Dimension"] = state
            if not state then StopTween("Frozen") end
        end)

        SeaTab:CreateToggle("Auto Drive Hydra", "AutoDriveHydraFlag", false, function(state)
            _G.Settings.Sea["Auto Drive Hydra"] = state
            if not state then StopTween("Hydra") end
        end)

        SeaTab:CreateSection("Sailing & Boat Controls")

        SeaTab:CreateDropdown("Select Boat", "BoatDropdownFlag", {"Guardian", "Beast Hunter", "PirateGrandBrigade", "MarineGrandBrigade"}, "Guardian", function(selected)
            _G.Settings.Sea["Selected Boat"] = selected
        end)

        SeaTab:CreateDropdown("Select Sailing Zone", "ZoneDropdownFlag", {"Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5", "Zone 6", "Infinite"}, "Zone 5", function(selected)
            _G.Settings.Sea["Selected Zone"] = selected
        end)

        SeaTab:CreateToggle("Auto Set Sail", "SailBoatFlag", false, function(state)
            _G.Settings.Sea["Sail Boat"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("Ship Noclip", "ShipNoclipFlag", false, function(state)
            _G.Settings.Sea["Ship Noclip"] = state
        end)

        SeaTab:CreateSection("Sea Mobs Combat")

        SeaTab:CreateToggle("Auto Attack Sea Events", "AutoAttackSeaFlag", false, function(state)
            _G.Settings.Sea["Auto Attack Sea Events"] = state
        end)

        SeaTab:CreateToggle("Auto Farm Shark", "SharkFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Shark"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("Auto Farm Piranha", "PiranhaFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Piranha"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("Auto Farm Fish Crew Member", "CrewFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Fish Crew Member"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("Auto Farm Ghost Ship", "GhostShipFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Ghost Ship"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("Auto Farm Terrorshark", "TerrorFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Terrorshark"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("Auto Farm Seabeasts", "SeabeastFlag", false, function(state)
            _G.Settings.Sea["Auto Farm Seabeasts"] = state
            if not state then StopTween() end
        end)

        SeaTab:CreateToggle("Auto Find Kitsune Island", "AutoFindKitsuneIslandFlag", false, function(state)
            _G.Settings.Sea["Auto Find Kitsune Island"] = state
            if not state then StopTween("Kitsune") end
        end)

        SeaTab:CreateButton("Teleport To Kitsune Island", function()
            if World3 then
                local island = GetKitsuneIsland()
                if island then
                    local cf = GetModelCFrame(island)
                    if cf then TweenPlayer(cf, Vector3.new(0, 80, 0), "KitsuneTP") end
                    AetherUI:Notify({Title = "Kitsune Island", Content = "Teleporting to Kitsune Island...", Duration = 2})
                else
                    AetherUI:Notify({Title = "Kitsune Island", Content = "Kitsune Island is not spawned.", Duration = 3})
                end
            end
        end)

        SeaTab:CreateToggle("Teleport To Kitsune (Auto)", "TeleportToKitsuneFlag", false, function(state)
            _G.Settings.Sea["Teleport To Kitsune Island"] = state
            if not state then StopTween("KitsuneTP") end
        end)

        ---------------------------------------------------------
        -- 📌 7. TAB: RACE V4 & MIRAGE
        ---------------------------------------------------------
        RaceTab:CreateSection("Race Upgrades (V1-V4)")

        RaceTab:CreateToggle("Auto Collect Flowers", "AutoCollectFlowersFlag", false, function(state)
            _G.Settings.Race["Auto Collect Flowers"] = state
        end)

        RaceTab:CreateToggle("Auto Race V2 Quest", "AutoRaceV2QuestFlag", false, function(state)
            _G.Settings.Race["Auto Race V2 Quest"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateDropdown("Select Race V3 Quest", "RaceV3QuestDropdown", {"Human", "Fishman", "Skypian", "Mink", "Ghoul", "Cyborg"}, "Human", function(selected)
            _G.Settings.Race["Selected Race V3"] = selected
        end)

        RaceTab:CreateToggle("Auto Race V3 Quest", "AutoRaceV3QuestFlag", false, function(state)
            _G.Settings.Race["Auto Race V3 Quest"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("Auto Activate Race V3 Ability", "AutoV3AbilityFlag", false, function(state)
            _G.Settings.Race["Auto Race V3 Ability"] = state
            task.spawn(function()
                while _G.Settings.Race["Auto Race V3 Ability"] do
                    task.wait(1)
                    if CommE then pcall(function() CommE:FireServer("ActivateAbility") end) end
                end
            end)
        end)

        RaceTab:CreateSection("Mirage Island & Gear Suite")

        RaceTab:CreateToggle("Auto Find Mirage Island", "AutoFindMirageFlag", false, function(state)
            _G.Settings.Race["Auto Find Mirage"] = state
            if not state then StopTween("Mirage") end
        end)

        RaceTab:CreateButton("Teleport To Mirage Island", function()
            if World3 then
                local island = GetMirageIsland()
                if island then
                    local cf = GetModelCFrame(island)
                    if cf then TweenPlayer(cf, Vector3.new(0, 80, 0), "MirageTP") end
                    AetherUI:Notify({Title = "Mirage Island", Content = "Teleporting to Mirage Island...", Duration = 2})
                else
                    AetherUI:Notify({Title = "Mirage Island", Content = "Mirage Island is not spawned.", Duration = 3})
                end
            end
        end)

        RaceTab:CreateToggle("Teleport To Mirage (Auto)", "TeleportToMirageFlag", false, function(state)
            _G.Settings.Race["Teleport To Mirage"] = state
            if not state then StopTween("MirageTP") end
        end)

        RaceTab:CreateToggle("Tween To Highest Mirage Point", "TweenMirageFlag", false, function(state)
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

        RaceTab:CreateToggle("Teleport To Blue Gear", "TeleportToGearFlag", false, function(state)
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

        RaceTab:CreateToggle("Auto Look Moon Ability", "LookMoonFlag", false, function(state)
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

        RaceTab:CreateToggle("Teleport To Race Door", "TPDoorFlag", false, function(state)
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

        RaceTab:CreateToggle("Auto V4 Training", "AutoTrainFlag", false, function(state)
            _G.Settings.Race["Auto Train"] = state
            if not state then StopTween() end
        end)

        RaceTab:CreateToggle("Auto Complete Trial", "AutoTrialFlag", false, function(state)
            _G.Settings.Race["Auto Trial"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 8. TAB: ITEMS & SWORDS
        ---------------------------------------------------------
        ItemsTab:CreateSection("Legendary Items & Weapons")

        ItemsTab:CreateDropdown("Select CDK Method", "CDKMethodDropdown", {"Quest Yama", "Quest Tushita", "Last Quest"}, "Quest Yama", function(selected)
            _G.Settings.ItemsQuests["CDK Trial Type"] = selected
        end)

        ItemsTab:CreateToggle("Auto Cursed Dual Katana (CDK)", "AutoFarmCDKFlag", false, function(state)
            _G.Settings.ItemsQuests["Auto Farm CDK"] = state
            if not state then StopTween() end
        end)

        ItemsTab:CreateToggle("Auto True Triple Katana (TTK)", "AutoFarmTTKFlag", false, function(state)
            _G.Settings.ItemsQuests["Auto Farm TTK"] = state
            if not state then StopTween() end
        end)

        ItemsTab:CreateToggle("Auto Soul Guitar", "AutoSoulGuitarFlag", false, function(state)
            _G.Settings.ItemsQuests["Auto Soul Guitar"] = state
            if not state then StopTween() end
        end)

        ItemsTab:CreateToggle("Auto Godhuman Fighting Style", "AutoGodhumanFlag", false, function(state)
            _G.Settings.ItemsQuests["Auto Godhuman"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 9. TAB: FRUITS & SNIPER (Extracted from script_1)
        ---------------------------------------------------------
        FruitsTab:CreateSection("Blox Fruits Rolling & Management")

        FruitsTab:CreateButton("Roll Fruit Once (Blox Fruit Cousin)", function()
            if CommF_ then
                local res = CommF_:InvokeServer("Cousin", "Buy")
                AetherUI:Notify({Title = "Fruit Dealer", Content = tostring(res), Duration = 4})
            end
        end)

        FruitsTab:CreateToggle("Auto Roll Fruit (Loop)", "AutoRollFruitFlag", false, function(state)
            _G.Settings.Fruits["Auto Roll Fruit"] = state
            task.spawn(function()
                while _G.Settings.Fruits["Auto Roll Fruit"] do
                    if CommF_ then pcall(function() CommF_:InvokeServer("Cousin", "Buy") end) end
                    task.wait(3)
                end
            end)
        end)

        FruitsTab:CreateToggle("Fruit Notifier (ESP)", "FruitESPFlag", false, function(state)
            _G.Settings.Fruits["Fruit ESP"] = state
            _G.Settings.Visuals["ESP Fruits"] = state
        end)

        FruitsTab:CreateToggle("Fruit Sniper (Tween to Fruit)", "FruitSniperFlag", false, function(state)
            _G.Settings.Fruits["Fruit Sniper"] = state
            if not state then StopTween() end
        end)

        FruitsTab:CreateToggle("Auto Store Fruit", "AutoStoreFruitFlag", false, function(state)
            _G.Settings.Fruits["Auto Store Fruit"] = state
            task.spawn(function()
                while _G.Settings.Fruits["Auto Store Fruit"] do
                    task.wait(0.5)
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        for _, tool in pairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and string.find(tool.Name:lower(), "fruit") then
                                pcall(function() CommF_:InvokeServer("StoreFruit", tool.Name) end)
                            end
                        end
                    end
                end
            end)
        end)

        FruitsTab:CreateToggle("Auto Drop Fruit", "AutoDropFruitFlag", false, function(state)
            _G.Settings.Fruits["Auto Drop Fruit"] = state
            task.spawn(function()
                while _G.Settings.Fruits["Auto Drop Fruit"] do
                    task.wait(0.5)
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        for _, tool in pairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and string.find(tool.Name:lower(), "fruit") then
                                tool.Parent = workspace
                            end
                        end
                    end
                end
            end)
        end)

        FruitsTab:CreateButton("Open Blox Fruits Shop Remotely", function()
            if CommF_ then
                pcall(function() CommF_:InvokeServer("Shop", "Open") end)
                pcall(function() CommF_:InvokeServer("OpenShop") end)
            end
        end)

        ---------------------------------------------------------
        -- 📌 10. TAB: DRAGON DOJO
        ---------------------------------------------------------
        DragonDojoTab:CreateSection("Blaze Ember & Dojo Collector")

        DragonDojoTab:CreateToggle("Auto Farm Blaze Ember", "FarmBlazeEmberFlag", false, function(state)
            _G.Settings.DragonDojo["Auto Farm Blaze Ember"] = state
            if not state then StopTween() end
        end)

        DragonDojoTab:CreateToggle("Auto Collect Spawned Blaze Ember", "CollectBlazeEmberFlag", false, function(state)
            _G.Settings.DragonDojo["Auto Collect Blaze Ember"] = state
            if not state then StopTween() end
        end)

        ---------------------------------------------------------
        -- 📌 11. TAB: COMBAT & PVP
        ---------------------------------------------------------
        CombatTab:CreateSection("Target Player Selector")

        local playerList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(playerList, p.Name) end
        end

        CombatTab:CreateDropdown("Select Player Target", "PVPPlayerDropdown", playerList, playerList[1] or "None", function(selected)
            _G.Settings.Combat["Selected Player"] = selected
        end)

        CombatTab:CreateToggle("Spectate Selected Player", "SpectateFlag", false, function(state)
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

        CombatTab:CreateToggle("Teleport To Player", "TPPlayerFlag", false, function(state)
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

        CombatTab:CreateSection("Combat Assist Toggles")

        CombatTab:CreateToggle("Kill Aura (Attack Nearby Enemies)", "KillAuraFlag", false, function(state)
            _G.Settings.Combat["Kill Aura"] = state
        end)

        CombatTab:CreateSlider("Kill Aura Range", "KillAuraRangeSlider", 5, 50, 25, function(val)
            _G.Settings.Combat["Kill Aura Range"] = val
        end)

        CombatTab:CreateSlider("Attack Speed Multiplier", "AttackSpeedSlider", 1, 5, 1, function(val)
            _G.Settings.Combat["Attack Speed"] = val
        end)

        CombatTab:CreateToggle("Auto Enable Buso Haki (Once Per Life)", "AutoHakiOnceFlag", false, function(state)
            _G.Settings.Combat["Auto Enable Haki"] = state
        end)

        CombatTab:CreateToggle("Auto PvP Escape & Safety Return", "AutoPvPEscapeFlag", false, function(state)
            _G.Settings.Combat["Auto PvP Escape"] = state
            if not state then StopTween() end
        end)

        CombatTab:CreateSlider("Escape HP %", "EscapeHPSlider", 10, 90, 30, function(val)
            _G.Settings.Combat["Escape HP %"] = val
        end)

        CombatTab:CreateSlider("Return HP %", "ReturnHPSlider", 20, 100, 70, function(val)
            _G.Settings.Combat["Return HP %"] = val
        end)

        ---------------------------------------------------------
        -- 📌 12. TAB: CRAFTING (Extracted from script_1)
        ---------------------------------------------------------
        CraftingTab:CreateSection("Item Crafting Automation")

        CraftingTab:CreateToggle("Auto-Craft Shark Tooth Necklace", "CraftSharkNecklaceFlag", false, function(v) _G.Settings.Crafting.SharkToothNecklace = v end)
        CraftingTab:CreateToggle("Auto-Craft Terror Jaw", "CraftTerrorJawFlag", false, function(v) _G.Settings.Crafting.TerrorJaw = v end)
        CraftingTab:CreateToggle("Auto-Craft Monster Magnet", "CraftMonsterMagnetFlag", false, function(v) _G.Settings.Crafting.MonsterMagnet = v end)
        CraftingTab:CreateToggle("Auto-Craft Shark Anchor", "CraftSharkAnchorFlag", false, function(v) _G.Settings.Crafting.SharkAnchor = v end)
        CraftingTab:CreateToggle("Auto-Craft Leviathan Shield", "CraftLeviShieldFlag", false, function(v) _G.Settings.Crafting.LeviathanShield = v end)
        CraftingTab:CreateToggle("Auto-Craft Leviathan Boat", "CraftLeviBoatFlag", false, function(v) _G.Settings.Crafting.LeviathanBoat = v end)
        CraftingTab:CreateToggle("Auto-Craft Leviathan Crown", "CraftLeviCrownFlag", false, function(v) _G.Settings.Crafting.LeviathanCrown = v end)
        CraftingTab:CreateToggle("Auto-Craft Legendary Scroll", "CraftLegScrollFlag", false, function(v) _G.Settings.Crafting.LegendaryScroll = v end)
        CraftingTab:CreateToggle("Auto-Craft Mythical Scroll", "CraftMythScrollFlag", false, function(v) _G.Settings.Crafting.MythicalScroll = v end)

        ---------------------------------------------------------
        -- 📌 13. TAB: TELEPORTS
        ---------------------------------------------------------
        TeleportsTab:CreateSection("First Sea Islands Teleport")
        for islandName, cf in pairs(FullIslandLocations.Sea1) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("Teleport to " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf, Vector3.new(0, 30, 0))
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        TeleportsTab:CreateSection("Second Sea Islands Teleport")
        for islandName, cf in pairs(FullIslandLocations.Sea2) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("Teleport to " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf, Vector3.new(0, 30, 0))
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        TeleportsTab:CreateSection("Third Sea Islands Teleport")
        for islandName, cf in pairs(FullIslandLocations.Sea3) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("Teleport to " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    TweenPlayer(cf, Vector3.new(0, 30, 0))
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        ---------------------------------------------------------
        -- 📌 14. TAB: VISUALS & ESP
        ---------------------------------------------------------
        VisualTab:CreateSection("Visual Object Detectors")

        VisualTab:CreateToggle("ESP Players", "ESPPlayersFlag", false, function(state) _G.Settings.Visuals["ESP Players"] = state end)
        VisualTab:CreateToggle("ESP Bosses", "ESPBossesFlag", false, function(state) _G.Settings.Visuals["ESP Bosses"] = state end)
        VisualTab:CreateToggle("ESP Fruits", "ESPFruitsFlag", false, function(state) _G.Settings.Visuals["ESP Fruits"] = state end)
        VisualTab:CreateToggle("ESP Chests", "ESPChestsFlag", false, function(state) _G.Settings.Visuals["ESP Chests"] = state end)
        VisualTab:CreateToggle("ESP Enemies", "ESPEnemiesFlag", false, function(state) _G.Settings.Visuals["ESP Enemies"] = state end)
        VisualTab:CreateToggle("ESP Mirage Island", "ESPMirageFlag", false, function(state) _G.Settings.Visuals["ESP Mirage Island"] = state end)
        VisualTab:CreateToggle("ESP Kitsune Island", "ESPKitsuneFlag", false, function(state) _G.Settings.Visuals["ESP Kitsune Island"] = state end)

        ---------------------------------------------------------
        -- 📌 15. TAB: MISC & LIVE SERVER STATUS (Completely Fixed Display)
        ---------------------------------------------------------
        MiscTab:CreateSection("Game Promo Codes Master")

        MiscTab:CreateButton("Redeem All Active Promo Codes", function()
            RedeemAllCodes()
            AetherUI:Notify({Title = "Codes", Content = "Redeeming all working codes automatically...", Duration = 4})
        end)

        MiscTab:CreateSection("Live Server & World Status")

        local SessionTimePara = MiscTab:CreateParagraph({Title="Session Time", Desc="00:00:00", Image="rbxassetid://6034287594", ImageSize=20})
        local ServerTimePara = MiscTab:CreateParagraph({Title="Server Uptime", Desc="00:00:00", Image="rbxassetid://6034287594", ImageSize=20})
        local AFKTimePara = MiscTab:CreateParagraph({Title="AFK / Idle Time", Desc="00:00:00", Image="rbxassetid://6034287594", ImageSize=20})
        local TimezonePara = MiscTab:CreateParagraph({Title="Time", Desc="Local: --:--:-- | UTC: --:--:--", Image="rbxassetid://6034287594", ImageSize=20})
        local SeaIslandPara = MiscTab:CreateParagraph({Title="Location & Sea", Desc="Sea: Detecting... | Island: Detecting...", Image="rbxassetid://6034453535", ImageSize=20})
        local StatsPara = MiscTab:CreateParagraph({Title="Player Stats & Currency", Desc="Level: -- | Beli: -- | Fragments: --", Image="rbxassetid://6031280882", ImageSize=20})
        local ServerInfoPara = MiscTab:CreateParagraph({Title="Server", Desc="Players: 0/0 | Server Time: 00:00:00", Image="rbxassetid://6034287594", ImageSize=20})
        local CakePrincePara = MiscTab:CreateParagraph({Title="Cake Prince", Desc="🔴 Not Spawned | Progress: 0/500 | Remaining: 500", Image="rbxassetid://6034834832", ImageSize=20})
        local DoughKingPara = MiscTab:CreateParagraph({Title="Dough King", Desc="🔴 Not Spawned | Progress: 0/500 | Remaining: 500 | Sweet Chalice: ❌", Image="rbxassetid://6034834832", ImageSize=20})
        local MiragePara = MiscTab:CreateParagraph({Title="Mirage Status", Desc="🔴 Not Spawned", Image="rbxassetid://6034453535", ImageSize=20})
        local KitsunePara = MiscTab:CreateParagraph({Title="Kitsune Status", Desc="🔴 Not Spawned", Image="rbxassetid://6034453535", ImageSize=20})
        local SeaEventPara = MiscTab:CreateParagraph({Title="Sea Events", Desc="No active sea events detected.", Image="rbxassetid://6034453535", ImageSize=20})
        local ElitePara = MiscTab:CreateParagraph({Title="Elite Hunters Killed", Desc="N/A", Image="rbxassetid://6034834832", ImageSize=20})
        local SwordPara = MiscTab:CreateParagraph({Title="Legendary Swords Owned", Desc="0 / 3", Image="rbxassetid://6034834832", ImageSize=20})
        local NetworkPara = MiscTab:CreateParagraph({Title="Network", Desc="FPS: -- | Ping: -- ms", Image="rbxassetid://6031280882", ImageSize=20})

        local uiStartClock = os.clock()
        local lastInputClock = os.clock()
        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed then lastInputClock = os.clock() end
        end)
        UserInputService.InputChanged:Connect(function(input, processed)
            if not processed then lastInputClock = os.clock() end
        end)

        local function fmtHMS(sec)
            sec = math.max(0, math.floor(sec or 0))
            return string.format("%02d:%02d:%02d", math.floor(sec/3600), math.floor((sec%3600)/60), sec%60)
        end

        local function liveServerElapsed()
            local v = workspace.DistributedGameTime
            if type(v) == "number" and v > 0 then return v end
            return os.clock()
        end

        do
            local frames=0
            local last=os.clock()
            RunService.RenderStepped:Connect(function()
                frames+=1
                local now=os.clock()
                if now-last>=1 then
                    getgenv().HaroonFPS=frames/(now-last)
                    frames=0
                    last=now
                end
            end)
        end

        task.spawn(function()
            while task.wait(0.5) do
                pcall(function()
                    local stats = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("leaderstats")
                    local sessionElapsed = os.clock() - uiStartClock
                    local serverElapsed = liveServerElapsed()
                    local afkElapsed = os.clock() - lastInputClock
                    SessionTimePara:SetDesc(fmtHMS(sessionElapsed))
                    ServerTimePara:SetDesc("Uptime: " .. fmtHMS(serverElapsed))
                    AFKTimePara:SetDesc("Idle: " .. fmtHMS(afkElapsed) .. (afkElapsed >= 60 and " | AFK" or ""))
                    TimezonePara:SetDesc("Local: " .. os.date("%H:%M:%S") .. " | UTC: " .. os.date("!%H:%M:%S"))

                    local currentSeaName = World1 and "First Sea" or (World2 and "Second Sea" or (World3 and "Third Sea" or "Unknown"))
                    local islandText = "Unknown"
                    local locations = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Locations")
                    if World3 then
                        local mi = GetMirageIsland(); local ki = GetKitsuneIsland()
                        if mi then islandText = "Mirage Island" elseif ki then islandText = "Kitsune Island" end
                    end
                    SeaIslandPara:SetDesc("Sea: " .. currentSeaName .. " | Island/Event: " .. islandText)

                    local level = stats and stats:FindFirstChild("Level") and stats.Level.Value or "N/A"
                    local beli = stats and stats:FindFirstChild("Beli") and stats.Beli.Value or "N/A"
                    local frags = stats and stats:FindFirstChild("Fragments") and stats.Fragments.Value or "N/A"
                    StatsPara:SetDesc("Level: " .. tostring(level) .. " | Beli: " .. tostring(beli) .. " | Fragments: " .. tostring(frags))

                    local pCount = #Players:GetPlayers()
                    ServerInfoPara:SetDesc("Players: " .. pCount .. "/" .. tostring(Players.MaxPlayers) .. " | Server: " .. fmtHMS(serverElapsed))

                    local princeResult = "🔴 Not Spawned | Progress: 0/500 | Remaining: 500"
                    pcall(function() princeResult=getCakePrinceProgressIntegrated() end)
                    pcall(function() CakePrincePara:SetDesc(princeResult) end)
                    local doughText="🔴 Not Spawned | Progress: 0/500 | Remaining: 500 | Sweet Chalice: ❌"
                    pcall(function() doughText=getDoughKingStatusText() end)
                    pcall(function() DoughKingPara:SetDesc(doughText) end)

                    local mirage=GetMirageIsland()
                    local kitsune=GetKitsuneIsland()
                    pcall(function() MiragePara:SetDesc(mirage and "🟢 Spawned" or "🔴 Not Spawned") end)
                    pcall(function() KitsunePara:SetDesc(kitsune and "🟢 Spawned" or "🔴 Not Spawned") end)

                    local counts = {}
                    pcall(function() counts=getSeaEventCounts() or {} end)
                    local active = {}
                    for name, count in pairs(counts) do table.insert(active, name .. " x" .. count) end
                    table.sort(active)
                    SeaEventPara:SetDesc(#active > 0 and table.concat(active, " | ") or "🔴 No active Sea Events")

                    local ek = "N/A"
                    if stats then
                        for _, v in ipairs(stats:GetChildren()) do
                            if v.Name:lower():find("elite") then ek = tostring(v.Value) break end
                        end
                    end
                    ElitePara:SetDesc(ek)
                    local swords = 0
                    local bp = LocalPlayer:FindFirstChildOfClass("Backpack"); local c = LocalPlayer.Character
                    for _, name in ipairs({"Shisui", "Saddi", "Wando"}) do
                        if (bp and bp:FindFirstChild(name)) or (c and c:FindFirstChild(name)) then swords += 1 end
                    end
                    SwordPara:SetDesc(swords .. " / 3")
                    local fps = math.floor(getgenv().HaroonFPS or 0)
                    local ping = 0
                    pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
                    NetworkPara:SetDesc("FPS: " .. tostring(fps) .. " | Ping: " .. tostring(ping) .. " ms")
                end)
            end
        end)

        MiscTab:CreateSection("Auto Stat Point Allocator")

        MiscTab:CreateDropdown("Select Stat Target", "SelectStatDropdown", {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}, "Melee", function(selected)
            _G.Settings.Stats["Selected Stat"] = selected
        end)

        MiscTab:CreateSlider("Points Per Tick", "StatPointsSlider", 1, 100, 1, function(val)
            _G.Settings.Stats["Points Per Tick"] = val
        end)

        MiscTab:CreateToggle("Auto Stat Points", "AutoStatsToggleFlag", false, function(state)
            _G.Settings.Stats["Auto Stats"] = state
        end)

        MiscTab:CreateSection("Server Utilities & Anti-AFK")

        MiscTab:CreateToggle("Anti-AFK (Prevent Kick)", "AntiAFKFlag", false, function(state)
            _G.Settings.Misc["Anti AFK"] = state
        end)

        MiscTab:CreateToggle("Hover Over Water (Walk On Water)", "WalkOnWaterFlag", false, function(state)
            _G.Settings.Misc["Walk On Water"] = state
        end)

        MiscTab:CreateToggle("Auto Server Hop on Admin/VIP Join", "AutoHopVIPFlag", false, function(state)
            _G.Settings.Misc["Auto Server Hop VIP"] = state
        end)

        MiscTab:CreateToggle("Bypass Anticheat (30-Min Server Hop)", "BypassAnticheatFlag", false, function(state)
            _G.Settings.Misc["Bypass Anticheat"] = state
        end)

        MiscTab:CreateButton("Manual Server Hop", function()
            local success, targetServer = pcall(function()
                local placeId = game.PlaceId
                local servers = {}
                local result = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"))
                if result and result.data then
                    for _, server in ipairs(result.data) do
                        if server.playing < server.maxPlayers and server.id ~= tostring(game.JobId) then
                            table.insert(servers, server.id)
                        end
                    end
                end
                if #servers > 0 then return servers[math.random(#servers)] end
            end)

            if success and targetServer then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer, LocalPlayer)
            end
        end)

        ---------------------------------------------------------
        -- 📌 16. TAB: SETTINGS
        ---------------------------------------------------------
        SettingsTab:CreateSection("Hub Controls")

        SettingsTab:CreateButton("Rejoin Current Server", function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)

        SettingsTab:CreateButton("Destroy Hub Interface", function()
            local master = game:GetService("CoreGui"):FindFirstChild("HaroonHub_Master") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("HaroonHub_Master")
            if master then master:Destroy() end
        end)
    end)
end)

--------------------------------------------------------------------------------
-- 8. Main Farming Loop
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
-- 9. Sub-Farms Engine (Bones, Elite Hunter, Citizen Quests)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.2) do
        -- 1. Auto Farm Bones
        if _G.Settings.SubFarm["Auto Farm Bone"] and World3 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                if _G.Settings.SubFarm["Auto Accept Bone Quest"] and questGui and not questGui.Visible then
                    local qPos = CFrame.new(-9516.99, 172.01, 6078.46)
                    TweenPlayer(qPos)
                    if (hrp.Position - qPos.Position).Magnitude <= 15 then
                        CommF_:InvokeServer("StartQuest", "HauntedQuest2", 1)
                    end
                end

                for _, mobName in pairs({"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}) do
                    local mob = workspace.Enemies:FindFirstChild(mobName)
                    if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                        AutoHaki()
                        TweenPlayer(mob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(mob)
                        break
                    end
                end
            end)
        end

        -- 2. Auto Elite Hunter Engine
        if _G.Settings.SubFarm["Auto Elite Hunter"] and World3 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                local hasEliteQuest = false

                if questGui and questGui.Visible then
                    local title = questGui.Container.QuestTitle.Title.Text
                    hasEliteQuest = string.find(title, "Diablo") or string.find(title, "Urban") or string.find(title, "Deandre")
                end

                if not hasEliteQuest then
                    if CommF_ then CommF_:InvokeServer("EliteHunter") end
                else
                    local targetElite = nil
                    for _, eName in pairs({"Diablo", "Urban", "Deandre"}) do
                        local mob = workspace.Enemies:FindFirstChild(eName) or ReplicatedStorage:FindFirstChild(eName)
                        if mob and mob:FindFirstChild("HumanoidRootPart") then
                            targetElite = mob
                            break
                        end
                    end

                    if targetElite and targetElite:FindFirstChild("HumanoidRootPart") then
                        AutoHaki()
                        TweenPlayer(targetElite.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(targetElite)
                    elseif _G.Settings.SubFarm["Auto Elite Hunter Hop"] then
                        pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
                    end
                end
            end)
        end

        -- 3. Citizen Quest Engine
        if _G.Settings.Quests["Auto Citizen Quest"] and World3 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local progress = CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                if progress == 0 then
                    local mob = workspace.Enemies:FindFirstChild("Forest Pirate")
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        TweenPlayer(mob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(mob)
                    else
                        TweenPlayer(CFrame.new(-13274.47, 332.37, -7769.58))
                    end
                elseif progress == 1 then
                    local boss = workspace.Enemies:FindFirstChild("Captain Elephant")
                    if boss and boss:FindFirstChild("HumanoidRootPart") then
                        TweenPlayer(boss.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(boss)
                    else
                        TweenPlayer(CFrame.new(-13376.75, 433.28, -8071.39))
                    end
                elseif progress == 2 then
                    TweenPlayer(CFrame.new(-12513.51, 340.11, -9873.04))
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 9C. PUZZLE / CHALLENGE ENGINE - interaction + combat assist
--------------------------------------------------------------------------------
local function puzzleOwned(name)
    local bp=LocalPlayer:FindFirstChildOfClass("Backpack"); local c=LocalPlayer.Character
    return (bp and bp:FindFirstChild(name)) or (c and c:FindFirstChild(name))
end
local function puzzlePart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true) end
    if obj.Parent and obj.Parent:IsA("BasePart") then return obj.Parent end
    return obj.Parent and obj.Parent:FindFirstChildWhichIsA("BasePart",true)
end
local function findPuzzleNamed(names,center,radius)
    local best,bestD=nil,math.huge
    for _,pool in ipairs({workspace:FindFirstChild("Map"),workspace:FindFirstChild("_WorldOrigin")}) do
        if pool then
            for _,obj in ipairs(pool:GetDescendants()) do
                local lower=obj.Name:lower(); local hit=false
                for _,n in ipairs(names) do if lower:find(n:lower(),1,true) then hit=true break end end
                if hit then
                    local part=puzzlePart(obj)
                    if part then local d=(part.Position-center).Magnitude; if d<=radius and d<bestD then best,bestD=obj,d end end
                end
            end
        end
    end
    return best
end
local function interactPuzzle(obj)
    if not obj then return false end
    local prompt=obj:IsA("ProximityPrompt") and obj or obj:FindFirstChildWhichIsA("ProximityPrompt",true)
    if prompt and fireproximityprompt then pcall(function() fireproximityprompt(prompt,1) end); return true end
    local click=obj:IsA("ClickDetector") and obj or obj:FindFirstChildWhichIsA("ClickDetector",true)
    if click and fireclickdetector then pcall(function() fireclickdetector(click) end); return true end
    local part=puzzlePart(obj); if part then TweenPlayer(part.CFrame*CFrame.new(0,2,0),nil,"Puzzle"); return true end
    return false
end
local function autoYamaPuzzle()
    if not World3 or not puzzleOwned("Yama") then return end
    local mob=integratedFindEnemy({"Forest Pirate","Ghost"})
    if mob then raidStableAttack(mob); return end
    local obj=findPuzzleNamed({"purple","marked","ghost","yama"},GetCharacter().Position,5000); if obj then interactPuzzle(obj) end
end
local function autoTushitaPuzzle()
    if not World3 then return end
    local boss=integratedFindEnemy("Longma"); if boss then raidStableAttack(boss); return end
    local obj=findPuzzleNamed({"torch","holy torch"},GetCharacter().Position,7000); if obj then interactPuzzle(obj) end
end
local function autoColosseumPuzzle()
    if not World2 then return end
    local mob=integratedFindEnemy({"Swan Pirate","Jeremy","Gladiator"}); if mob then raidStableAttack(mob); return end
    local obj=findPuzzleNamed({"infinity","symbol","button","gladiator"},GetCharacter().Position,5000); if obj then interactPuzzle(obj) end
end
local function autoDoughChallenges()
    if not World3 then return end
    local boss=integratedFindEnemy({"Dough King","Cake Prince","Cake Queen"}); if boss then raidStableAttack(boss); return end
    local mob=integratedFindEnemy({"Cocoa Warrior","Chocolate Bar Battler"}); if mob then raidStableAttack(mob) end
end
local function autoSoulGuitarPuzzle()
    if not World3 then return end
    local obj=findPuzzleNamed({"grave","gravestone","tomb","skull","weird machine","soul guitar"},GetCharacter().Position,5000); if obj then interactPuzzle(obj) end
end
task.spawn(function()
    while task.wait(0.35) do
        if _G.Settings.Quests["Auto Yama Puzzle"] then pcall(autoYamaPuzzle) end
        if _G.Settings.Quests["Auto Tushita Puzzle"] then pcall(autoTushitaPuzzle) end
        if _G.Settings.Quests["Auto Colosseum Puzzle"] then pcall(autoColosseumPuzzle) end
        if _G.Settings.Quests["Auto Dough Challenges"] then pcall(autoDoughChallenges) end
        if _G.Settings.Quests["Auto Soul Guitar Puzzle"] then pcall(autoSoulGuitarPuzzle) end
    end
end)

--------------------------------------------------------------------------------
-- 10. ADVANCED RAID ENGINE
--------------------------------------------------------------------------------
task.spawn(function()
    local wasActive=false
    while task.wait(0.12) do
        local R=_G.Settings.Raid
        local active=R["Auto Dungeon / Raid"] or R["Auto Buy Chip & Start"] or R["Auto Clear Dungeon Waves"] or R["Auto Next Island"] or R["Auto Awaken"]
        if active then
            if not wasActive then resetRaidController() end
            wasActive=true
            pcall(function()
                if R["Auto Buy Chip & Start"] and CommF_ then
                    CommF_:InvokeServer("RaidsNpc","Select",R["Selected Chip"]); task.wait(0.45); CommF_:InvokeServer("RaidsNpc","Start")
                end
                if R["Auto Next Island"] then raidStep(true) elseif R["Auto Clear Dungeon Waves"] then raidStep(false) end
                if R["Auto Awaken"] and CommF_ then pcall(function() CommF_:InvokeServer("AwakeningExpert","Awaken") end) end
            end)
        elseif wasActive then
            wasActive=false; resetRaidController()
        end
    end
end)

--------------------------------------------------------------------------------
-- 11. CDK & TTK & Items Quest Loop
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.3) do
        -- Auto Farm CDK
        if _G.Settings.ItemsQuests["Auto Farm CDK"] and World3 then
            pcall(function()
                local char, hrp = GetCharacter()
                if not char or not hrp then return end

                local cdkType = _G.Settings.ItemsQuests["CDK Trial Type"]
                if cdkType == "Quest Yama" then
                    if CommF_ then
                        CommF_:InvokeServer("CDKQuest", "OpenDoor")
                        CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
                    end
                    local mob = workspace.Enemies:FindFirstChild("Forest Pirate")
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        TweenPlayer(mob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(mob)
                    end
                elseif cdkType == "Quest Tushita" then
                    if CommF_ then
                        CommF_:InvokeServer("CDKQuest", "OpenDoor")
                        CommF_:InvokeServer("CDKQuest", "StartTrial", "Good")
                    end
                    local boss = workspace.Enemies:FindFirstChild("Cake Queen")
                    if boss and boss:FindFirstChild("HumanoidRootPart") then
                        TweenPlayer(boss.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(boss)
                    end
                elseif cdkType == "Last Quest" then
                    if CommF_ then CommF_:InvokeServer("CDKQuest", "StartTrial", "Boss") end
                    local boss = workspace.Enemies:FindFirstChild("Cursed Skeleton Boss")
                    if boss and boss:FindFirstChild("HumanoidRootPart") then
                        TweenPlayer(boss.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                        SmartAttackMob(boss)
                    else
                        TweenPlayer(CFrame.new(-12318.19, 601.95, -6538.66))
                    end
                end
            end)
        end

        -- Auto Farm TTK
        if _G.Settings.ItemsQuests["Auto Farm TTK"] and World2 then
            pcall(function()
                if CommF_ then
                    CommF_:InvokeServer("MysteriousMan", "1")
                    CommF_:InvokeServer("MysteriousMan", "2")
                end
            end)
        end

        -- Auto Buy Legendary Swords
        if _G.Settings.ItemsQuests["Auto Buy Legendary Swords"] then
            for _, sName in ipairs({"Shisui", "Saddi", "Wando"}) do
                pcall(function() CommF_:InvokeServer("BuyItem", sName, 1) end)
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- 12. Mastery Engine & Tiki Outpost Melee Farm
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        -- 1. Auto Melee Mastery (Tiki Outpost)
        if _G.Settings.SubFarm["Auto Mastery Melee (Tiki)"] and World3 then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum or hum.Health <= 0 then return end

                local targetTikiMob = nil
                for _, mName in pairs({"Isle Outlaw", "Island Boy", "Sun-kissed Warrior", "Skull Slayer"}) do
                    local mob = workspace.Enemies:FindFirstChild(mName)
                    if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                        targetTikiMob = mob
                        break
                    end
                end

                if targetTikiMob then
                    AutoHaki()
                    TweenPlayer(targetTikiMob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                    SmartAttackMob(targetTikiMob, "Melee")
                else
                    TweenPlayer(MobSpecificTeleports["Tiki Mastery Farm"], Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                end
            end)
        end

        -- 2. Fruit / Gun / Sword Mastery
        if (_G.Settings.SubFarm["Auto Mastery Blox Fruits"] or _G.Settings.SubFarm["Auto Mastery Guns"] or _G.Settings.SubFarm["Auto Mastery Swords"]) then
            pcall(function()
                local char, hrp, hum = GetCharacter()
                if not char or not hrp or not hum or hum.Health <= 0 then return end

                local chosenWep = _G.Settings.SubFarm["Auto Mastery Blox Fruits"] and "Blox Fruit" or (_G.Settings.SubFarm["Auto Mastery Guns"] and "Gun" or "Sword")
                local targetMob = nil
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                        targetMob = mob
                        break
                    end
                end

                if targetMob then
                    AutoHaki()
                    TweenPlayer(targetMob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0))
                    SmartAttackMob(targetMob, chosenWep)
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 13. Sea Events, Sailing & Prehistoric Engine (Integrated)
--------------------------------------------------------------------------------
local SeaEventNames = {
    "Shark", "Piranha", "Fish Crew Member", "Ghost Ship", "FishBoat",
    "PirateBrigade", "PirateGrandBrigade", "MarineBrigade", "MarineGrandBrigade",
    "Terrorshark", "Sea Beast", "SeaBeast1", "Sea Beast 1", "Leviathan",
    "LeviathanGate", "Prehistoric Island", "Frozen Dimension"
}

local function getLocationsFolder()
    local origin = workspace:FindFirstChild("_WorldOrigin")
    return origin and origin:FindFirstChild("Locations")
end

local function recursiveFindByNames(rootObj, names)
    if not rootObj then return nil end
    for _, name in ipairs(names) do
        local exact = rootObj:FindFirstChild(name, true)
        if exact then return exact end
    end
    return nil
end

function GetMirageIsland()
    if not World3 then return nil end
    local map = workspace:FindFirstChild("Map")
    local locations = getLocationsFolder()
    return (map and (map:FindFirstChild("MysticIsland") or map:FindFirstChild("Mirage Island", true)))
        or (locations and (locations:FindFirstChild("Mirage Island") or locations:FindFirstChild("MysticIsland")))
        or workspace:FindFirstChild("MysticIsland")
end

function GetKitsuneIsland()
    if not World3 then return nil end
    local map = workspace:FindFirstChild("Map")
    local locations = getLocationsFolder()
    return (map and (map:FindFirstChild("KitsuneIsland") or map:FindFirstChild("Kitsune Island", true)))
        or (locations and (locations:FindFirstChild("Kitsune Island") or locations:FindFirstChild("KitsuneIsland")))
        or workspace:FindFirstChild("KitsuneIsland")
end

function GetModelCFrame(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj.CFrame end
    if obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart.CFrame end
        local p = obj:FindFirstChildWhichIsA("BasePart", true)
        if p then return p.CFrame end
    end
    return nil
end

local function getBoatOwnerName(boat)
    local attr = boat:GetAttribute("Owner") or boat:GetAttribute("OwnerName") or boat:GetAttribute("Player")
    if attr ~= nil then return tostring(attr) end
    local owner = boat:FindFirstChild("Owner") or boat:FindFirstChild("OwnerValue")
    if owner and owner:IsA("ValueBase") then return tostring(owner.Value) end
    return nil
end

local function GetMyBoatIntegrated()
    local boats = workspace:FindFirstChild("Boats")
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not boats then return nil end
    for _, boat in ipairs(boats:GetChildren()) do
        if boat:IsA("Model") and boat:FindFirstChild("VehicleSeat", true) then
            local owner = getBoatOwnerName(boat)
            if owner and (owner == LocalPlayer.Name or owner == tostring(LocalPlayer.UserId)) then
                return boat
            end
        end
    end
    -- Fallback: if the local humanoid is sitting in a boat seat, use that boat.
    if hum and hum.SeatPart then
        local seat = hum.SeatPart
        local boat = seat:FindFirstAncestorOfClass("Model")
        if boat and boat.Parent == boats then return boat end
    end
    return nil
end

local function getBoatSeat(boat)
    return boat and (boat:FindFirstChild("VehicleSeat", true) or boat:FindFirstChildWhichIsA("VehicleSeat", true))
end

local function boatPivot(boat, position, lookAt)
    if not boat then return end
    local y = math.max(20, position.Y)
    local pos = Vector3.new(position.X, y, position.Z)
    local look = Vector3.new(lookAt.X, y, lookAt.Z)
    local cf = CFrame.lookAt(pos, look)
    pcall(function()
        boat:PivotTo(cf)
    end)
end

local function ensureBoat()
    local boat = GetMyBoatIntegrated()
    if boat then return boat end
    local _, hrp = GetCharacter()
    if CommF_ and World3 then
        -- Buy from the current dock/dealer when close, otherwise move to a stable Third Sea dealer area.
        local buyCF = CFrame.new(-16927.451, 14, 433.864)
        if hrp and (hrp.Position - buyCF.Position).Magnitude > 80 then
            TweenPlayer(buyCF, nil, "BoatBuy")
        else
            pcall(function() CommF_:InvokeServer("BuyBoat", _G.Settings.Sea["Selected Boat"] or "Guardian") end)
        end
    end
    return GetMyBoatIntegrated()
end

local MirageSearchRoute = {
    CFrame.new(-34054, 31, -2560),
    CFrame.new(-38888, 31, -2163),
    CFrame.new(-31172, 31, -2257),
    CFrame.new(-26780, 31, -823),
}

local KitsuneHoldingPoint = CFrame.new(-42700, 31, 37000)
local MirageRouteIndex = 1
local KitsuneRouteIndex = 1

local function moveBoatOverSea(boat, targetCF, aggressive)
    local seat = getBoatSeat(boat)
    if not seat then return false end
    local char, hrp, hum = GetCharacter()
    if hum and not hum.Sit then
        pcall(function() hrp.CFrame = seat.CFrame * CFrame.new(0, 2.5, 0) end)
        return false
    end
    local target = targetCF.Position
    local current = seat.Position
    if (current - target).Magnitude < 80 then return true end
    local dt = math.max(0.1, (current - target).Magnitude / math.max(100, _G.Settings.Sea["Boat Tween Speed"] or 200))
    local boatCF = CFrame.lookAt(Vector3.new(target.X, math.max(25, target.Y), target.Z), Vector3.new(target.X + 50, math.max(25, target.Y), target.Z))
    local ok = pcall(function()
        if boat.PrimaryPart then
            local t = TweenService:Create(boat.PrimaryPart, TweenInfo.new(dt, Enum.EasingStyle.Linear), {CFrame = boatCF})
            t:Play()
        else
            boatPivot(boat, target, target + Vector3.new(50, 0, 0))
        end
    end)
    if not ok or aggressive then
        boatPivot(boat, target, target + Vector3.new(50, 0, 0))
    end
    return false
end

local function teleportToDetectedIsland(island, owner)
    local cf = GetModelCFrame(island)
    if cf then
        TweenPlayer(cf, Vector3.new(0, 85, 0), owner)
        return true
    end
    return false
end

local function mirageStep()
    if not World3 then return end
    local island = GetMirageIsland()
    if island then
        if _G.Settings.Race["Teleport To Mirage"] then teleportToDetectedIsland(island, "MirageTP") end
        return
    end
    if not _G.Settings.Race["Auto Find Mirage"] then return end
    local boat = ensureBoat()
    if not boat then return end
    local route = MirageSearchRoute[MirageRouteIndex]
    if route then
        local reached = moveBoatOverSea(boat, route, false)
        if reached then MirageRouteIndex = MirageRouteIndex % #MirageSearchRoute + 1 end
    end
end

local function kitsuneStep()
    if not World3 then return end
    local island = GetKitsuneIsland()
    if island then
        if _G.Settings.Sea["Teleport To Kitsune Island"] then teleportToDetectedIsland(island, "KitsuneTP") end
        return
    end
    if not _G.Settings.Sea["Auto Find Kitsune Island"] then return end
    local boat = ensureBoat()
    if not boat then return end
    -- Stay over water around Danger 5/6; do not move under the sea.
    local reached = moveBoatOverSea(boat, KitsuneHoldingPoint, false)
    if reached then
        local seat = getBoatSeat(boat)
        if seat then
            local p = seat.Position
            boatPivot(boat, Vector3.new(p.X + 450, 30, p.Z + 350), Vector3.new(p.X + 500, 30, p.Z + 350))
        end
    end
end

local function getSeaEventCounts()
    local counts = {}
    local roots = {workspace:FindFirstChild("Enemies"), workspace:FindFirstChild("SeaBeasts")}
    for _, rootFolder in ipairs(roots) do
        if rootFolder then
            for _, obj in ipairs(rootFolder:GetChildren()) do
                if table.find(SeaEventNames, obj.Name) then
                    counts[obj.Name] = (counts[obj.Name] or 0) + 1
                end
            end
        end
    end
    local locations = getLocationsFolder()
    if locations then
        for _, name in ipairs({"Mirage Island", "Kitsune Island", "Prehistoric Island", "Frozen Dimension", "Treasure Island", "Rough Sea"}) do
            if locations:FindFirstChild(name) then counts[name] = (counts[name] or 0) + 1 end
        end
    end
    return counts
end

local function findSeaCombatTarget()
    local allowed = {}
    local S = _G.Settings.Sea
    if S["Auto Farm Shark"] then allowed["Shark"] = true end
    if S["Auto Farm Piranha"] then allowed["Piranha"] = true end
    if S["Auto Farm Fish Crew Member"] then allowed["Fish Crew Member"] = true end
    if S["Auto Farm Ghost Ship"] then allowed["Ghost Ship"] = true; allowed["FishBoat"] = true end
    if S["Auto Farm Terrorshark"] then allowed["Terrorshark"] = true end
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local _, hrp = GetCharacter()
    local best, bestD = nil, math.huge
    for _, enemy in ipairs(enemies:GetChildren()) do
        if allowed[enemy.Name] then
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local r = enemy:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and r then
                local d = hrp and (hrp.Position - r.Position).Magnitude or 0
                if d < bestD then best, bestD = enemy, d end
            end
        end
    end
    return best
end

local function integratedSeaStep()
    if not World3 then return end
    local char, hrp, hum = GetCharacter()
    if not char or not hrp or not hum then return end

    -- Prehistoric automation stays separate from sea-event navigation.
    if _G.Settings.Sea["Auto Prehistoric Island"] or _G.Settings.Sea["Auto Complete Prehistoric Island"] or _G.Settings.Sea["Auto Draco Trail"] then
        local pre = recursiveFindByNames(getLocationsFolder(), {"Prehistoric Island"})
        if pre then
            teleportToDetectedIsland(pre, "Prehistoric")
        else
            local mob = nil
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, name in ipairs({"Isle Outlaw", "Island Boy", "Sun-kissed Warrior", "Terrorshark"}) do
                    local m = enemies:FindFirstChild(name)
                    local h = m and m:FindFirstChildOfClass("Humanoid")
                    local r = m and m:FindFirstChild("HumanoidRootPart")
                    if h and h.Health > 0 and r then mob = m break end
                end
            end
            if mob then
                AutoHaki(); TweenPlayer(mob.HumanoidRootPart.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0), "Prehistoric")
                SmartAttackMob(mob)
            else
                TweenPlayer(MobSpecificTeleports["Prehistoric Island"], Vector3.new(0, _G.Settings.Main["Farm Distance"], 0), "Prehistoric")
            end
        end
        return
    end

    local target = findSeaCombatTarget()
    if target and _G.Settings.Sea["Auto Attack Sea Events"] then
        if hum.Sit then hum.Sit = false end
        AutoHaki()
        TweenPlayer(target.HumanoidRootPart.CFrame, Vector3.new(0, 25, 0), "SeaCombat")
        SmartAttackMob(target)
        return
    end

    if _G.Settings.Sea["Auto Farm Seabeasts"] then
        local beasts = workspace:FindFirstChild("SeaBeasts")
        if beasts then
            for _, sb in ipairs(beasts:GetChildren()) do
                local sh = sb:FindFirstChildOfClass("Humanoid")
                local sr = sb:FindFirstChild("HumanoidRootPart") or sb.PrimaryPart
                if sh and sh.Health > 0 and sr then
                    if hum.Sit then hum.Sit = false end
                    AutoHaki()
                    TweenPlayer(sr.CFrame, Vector3.new(0, 55, 0), "SeaBeast")
                    FastAttackTarget(sb)
                    return
                end
            end
        end
    end

    if _G.Settings.Race["Auto Find Mirage"] then mirageStep() end
    if _G.Settings.Sea["Auto Find Kitsune Island"] then kitsuneStep() end

    if _G.Settings.Sea["Sail Boat"] then
        local boat = ensureBoat()
        local seat = getBoatSeat(boat)
        local targetZone = ZoneCFrames[_G.Settings.Sea["Selected Zone"]] or ZoneCFrames["Zone 5"]
        if boat and seat then
            if not hum.Sit then
                pcall(function() hrp.CFrame = seat.CFrame * CFrame.new(0, 2.5, 0) end)
            else
                moveBoatOverSea(boat, targetZone, false)
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.25) do
        pcall(integratedSeaStep)
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if _G.Settings.Sea["Auto Frozen Dimension"] then pcall(integratedFrozenStep) end
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if _G.Settings.Sea["Auto Drive Hydra"] then pcall(integratedHydraStep) end
    end
end)

--------------------------------------------------------------------------------
-- 14. Crafting, Stats & Anti-AFK Engine
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        -- Auto Stats Allocation
        if _G.Settings.Stats["Auto Stats"] then
            pcall(function()
                local points = LocalPlayer.Data.Points.Value
                if points and points > 0 then
                    local targetStat = _G.Settings.Stats["Selected Stat"]
                    local addCount = math.min(points, _G.Settings.Stats["Points Per Tick"] or 1)
                    if CommF_ then CommF_:InvokeServer("AddPoint", targetStat, addCount) end
                end
            end)
        end

        -- Anti-AFK
        if _G.Settings.Misc["Anti AFK"] then
            pcall(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end

        -- Auto Crafting (Extracted from script_1)
        if CommF_ then
            pcall(function()
                if _G.Settings.Crafting.SharkToothNecklace then CommF_:InvokeServer("Craft", "Shark Tooth Necklace") end
                if _G.Settings.Crafting.TerrorJaw then CommF_:InvokeServer("Craft", "Terror Jaw") end
                if _G.Settings.Crafting.MonsterMagnet then CommF_:InvokeServer("Craft", "Monster Magnet") end
                if _G.Settings.Crafting.SharkAnchor then CommF_:InvokeServer("Craft", "Shark Anchor") end
                if _G.Settings.Crafting.LeviathanShield then CommF_:InvokeServer("Craft", "Leviathan Shield") end
                if _G.Settings.Crafting.LeviathanBoat then CommF_:InvokeServer("Craft", "Leviathan Boat") end
                if _G.Settings.Crafting.LeviathanCrown then CommF_:InvokeServer("Craft", "Leviathan Crown") end
                if _G.Settings.Crafting.LegendaryScroll then CommF_:InvokeServer("Craft", "Legendary Scroll") end
                if _G.Settings.Crafting.MythicalScroll then CommF_:InvokeServer("Craft", "Mythical Scroll") end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 15. Advanced Dynamic ESP Engine (All Categories)
--------------------------------------------------------------------------------
local ESPCache = {}

local function RemoveESP(key)
    local obj = ESPCache[key]
    if obj and obj.Gui then pcall(function() obj.Gui:Destroy() end) end
    ESPCache[key] = nil
end

local function RemoveAllESP()
    for key in pairs(ESPCache) do RemoveESP(key) end
end

local function getEspPart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
    end
    if obj:IsA("Tool") then return obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart", true) end
end

local function EnsureESP(key, part, title, color, showHP, maxHP, hp)
    if not part or not part.Parent then return end
    local entry = ESPCache[key]
    if not entry or not entry.Gui or not entry.Gui.Parent or entry.Part ~= part then
        if entry and entry.Gui then pcall(function() entry.Gui:Destroy() end) end
        local bill = Instance.new("BillboardGui")
        bill.Name = "HaroonESP"
        bill.Adornee = part
        bill.Size = UDim2.new(0, 180, 0, showHP and 52 or 30)
        bill.StudsOffset = Vector3.new(0, 2.8, 0)
        bill.AlwaysOnTop = true
        bill.MaxDistance = 10000

        local frame = Instance.new("Frame")
        frame.Size = UDim2.fromScale(1, 1)
        frame.BackgroundColor3 = Color3.fromRGB(12,12,16)
        frame.BackgroundTransparency = 0.22
        frame.Parent = bill
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -8, 0, 16)
        titleLabel.Position = UDim2.new(0,4,0,1)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 11
        titleLabel.TextXAlignment = Enum.TextXAlignment.Center
        titleLabel.Parent = frame

        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "Distance"
        distLabel.Size = UDim2.new(1, -8, 0, 14)
        distLabel.Position = UDim2.new(0,4,0,17)
        distLabel.BackgroundTransparency = 1
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 9
        distLabel.TextColor3 = Color3.fromRGB(220,220,220)
        distLabel.Parent = frame

        local hpBg, hpFill
        if showHP then
            hpBg = Instance.new("Frame")
            hpBg.Name = "HP"
            hpBg.Size = UDim2.new(1, -12, 0, 5)
            hpBg.Position = UDim2.new(0,6,0,33)
            hpBg.BackgroundColor3 = Color3.fromRGB(45,45,48)
            hpBg.Parent = frame
            hpFill = Instance.new("Frame")
            hpFill.Name = "Fill"
            hpFill.Size = UDim2.new(1,0,1,0)
            hpFill.BackgroundColor3 = Color3.fromRGB(50,220,120)
            hpFill.Parent = hpBg
        end
        bill.Parent = part
        entry = {Gui=bill, Part=part, Title=titleLabel, Distance=distLabel, HPFill=hpFill}
        ESPCache[key] = entry
    end
    local _, hrp = GetCharacter()
    local dist = hrp and math.floor((hrp.Position - part.Position).Magnitude) or 0
    entry.Title.Text = title
    entry.Title.TextColor3 = color
    entry.Distance.Text = "" .. dist .. " studs"
    if entry.HPFill and showHP and maxHP and maxHP > 0 then
        entry.HPFill.Size = UDim2.new(math.clamp((hp or 0)/maxHP, 0, 1), 0, 1, 0)
    end
end

local function isBossModel(obj)
    if not obj:IsA("Model") then return false end
    local name = obj.Name:lower()
    return name:find("king") or name:find("prince") or name:find("boss") or name:find("reaper") or name:find("leviathan") or name:find("terror") or name:find("god")
end

local function espTick()
    local _, hrp = GetCharacter()
    if not hrp then return end
    local seen = {}
    local S = _G.Settings.Visuals
    if _G.Settings.Fruits["Fruit ESP"] then S["ESP Fruits"] = true end
    if _G.Settings.Fruits["Player ESP"] then S["ESP Players"] = true end
    if _G.Settings.Fruits["Chest ESP"] then S["ESP Chests"] = true end

    if S["ESP Players"] then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local part = getEspPart(p.Character)
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                if part then
                    local key = "P:" .. p.UserId
                    seen[key] = true
                    EnsureESP(key, part, "👤 " .. p.Name, Color3.fromRGB(255,90,90), true, h and h.MaxHealth or 100, h and h.Health or 0)
                end
            end
        end
    end

    if S["ESP Enemies"] or S["ESP Bosses"] then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, mob in ipairs(enemies:GetChildren()) do
                if mob:IsA("Model") then
                    local boss = isBossModel(mob)
                    if (S["ESP Bosses"] and boss) or (S["ESP Enemies"] and not boss) then
                        local part = getEspPart(mob)
                        local h = mob:FindFirstChildOfClass("Humanoid")
                        if part and h then
                            local key = "E:" .. mob:GetDebugId()
                            seen[key] = true
                            EnsureESP(key, part, (boss and "👑 " or "⚔️ ") .. mob.Name, boss and Color3.fromRGB(255,170,40) or Color3.fromRGB(255,210,90), true, h.MaxHealth, h.Health)
                        end
                    end
                end
            end
        end
    end

    if S["ESP Fruits"] then
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Tool") then
                local n = obj.Name:lower()
                if n:find("fruit") or n:find("blox") then
                    local part = getEspPart(obj)
                    if part then
                        local key = "F:" .. obj:GetDebugId()
                        seen[key] = true
                        EnsureESP(key, part, "🍎 " .. obj.Name, Color3.fromRGB(255,180,40), false)
                    end
                end
            end
        end
    end

    if S["ESP Chests"] then
        local chests = workspace:FindFirstChild("ChestModels")
        if chests then
            for _, chest in ipairs(chests:GetChildren()) do
                local part = getEspPart(chest)
                if part then
                    local key = "C:" .. chest:GetDebugId()
                    seen[key] = true
                    EnsureESP(key, part, "📦 " .. chest.Name, Color3.fromRGB(255,255,80), false)
                end
            end
        end
    end

    if S["ESP Mirage Island"] then
        local island = GetMirageIsland()
        local part = getEspPart(island)
        if part then
            local key = "I:Mirage"
            seen[key] = true
            EnsureESP(key, part, "🌙 Mirage Island", Color3.fromRGB(150,220,255), false)
        end
    end

    if S["ESP Kitsune Island"] then
        local island = GetKitsuneIsland()
        local part = getEspPart(island)
        if part then
            local key = "I:Kitsune"
            seen[key] = true
            EnsureESP(key, part, "🦊 Kitsune Island", Color3.fromRGB(255,150,255), false)
        end
    end

    for key in pairs(ESPCache) do
        if not seen[key] then RemoveESP(key) end
    end

    if not (S["ESP Players"] or S["ESP Enemies"] or S["ESP Bosses"] or S["ESP Fruits"] or S["ESP Chests"] or S["ESP Mirage Island"] or S["ESP Kitsune Island"]) then
        RemoveAllESP()
    end
end

task.spawn(function()
    while task.wait(0.25) do pcall(espTick) end
end)

--------------------------------------------------------------------------------
-- 16. Chest & Boss Farm Standalone Loops
--------------------------------------------------------------------------------
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
                        TweenPlayer(closestChest.RootPart.CFrame, Vector3.new(0, 3, 0))
                    end
                end
            end)
        end
    end
end)

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
end)
