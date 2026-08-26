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
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

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
        ["Auto Collect World Fruits"] = false,
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
        ["Auto Kill Dough King"] = false,
        ["Cake Progress Display"] = true,
        ["Dough Progress Display"] = true
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
        ["Server Time"] = false,
        ["Server Time AFK"] = false,
        ["Update 28 Submerged"] = true,
        ["Auto Find Mirage"] = false,
        ["Auto Find Kitsune"] = false,
        ["Auto Sea Events"] = false,
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
                   _G.Settings.ItemsQuests["Auto Sword Quest"] or _G.Settings.Race["Auto Race V2 Quest"] or 
                   _G.Settings.Race["Auto Race V3 Quest"] or _G.Settings.ItemsQuests["Auto Farm CDK"] or 
                   _G.Settings.ItemsQuests["Auto Farm TTK"] or _G.Settings.SubFarm["Auto Mastery Melee (Tiki)"] or 
                   _G.Settings.SubFarm["Auto Mastery Swords"] or _G.Settings.SubFarm["Auto Mastery Blox Fruits"] or 
                   _G.Settings.SubFarm["Auto Mastery Guns"] or _G.Settings.Race["Auto Find Mirage"] or 
                   _G.Settings.Sea["Auto Find Kitsune Island"] or _G.Settings.Raid["Auto Dungeon / Raid"] or 
                   _G.Settings.Combat["Auto PvP Escape"] or _G.Settings.Fruits["Fruit Sniper"] or
                   _G.Settings.Sea["Auto Farm Shark"] or _G.Settings.Sea["Auto Farm Piranha"] or
                   _G.Settings.Sea["Auto Farm Fish Crew Member"] or _G.Settings.Sea["Auto Farm Ghost Ship"] or
                   _G.Settings.Sea["Auto Farm Terrorshark"] or _G.Settings.Sea["Auto Farm Seabeasts"] or
                   _G.Settings.Sea["Auto Prehistoric Island"] or _G.Settings.Sea["Auto Complete Prehistoric Island"] or
                   _G.Settings.Sea["Auto Draco Trail"] or _G.Settings.Raid["Auto Next Island"] or
                   _G.Settings.DragonDojo["Auto Farm Blaze Ember"] or _G.Settings.SubFarm["Auto Elite Hunter"] or
                   _G.Settings.Quests["Auto Citizen Quest"]

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

local currentTween = nil
local currentTweenTarget = nil
local currentTweenOwner = nil

local function TweenPlayer(pos: CFrame | Vector3 | BasePart, offset: Vector3?, owner: string?)
    local char, hrp, hum = GetCharacter()
    if not char or not hrp or not hum or hum.Health <= 0 then return nil end
    if hum.Sit then hum.Sit = false end

    local targetCFrame
    if typeof(pos) == "CFrame" then
        targetCFrame = pos
    elseif typeof(pos) == "Vector3" then
        targetCFrame = CFrame.new(pos)
    elseif typeof(pos) == "Instance" and pos:IsA("BasePart") then
        targetCFrame = pos.CFrame
    else
        return nil
    end

    if offset then
        targetCFrame = targetCFrame * CFrame.new(offset)
    end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance <= 25 then
        if currentTween then
            currentTween:Cancel()
            currentTween = nil
        end
        currentTweenTarget = nil
        currentTweenOwner = nil
        hrp.CFrame = targetCFrame
        return nil
    end

    -- Do not restart the same tween every 0.1–0.2s. This was causing
    -- movement to reset/reverse when several feature loops were active.
    if currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing
        and currentTweenTarget
        and (currentTweenTarget.Position - targetCFrame.Position).Magnitude < 8 then
        currentTweenOwner = owner or currentTweenOwner
        return currentTween
    end

    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end

    local speed = math.max(50, tonumber(_G.Settings.Main["Player Tween Speed"]) or 180)
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    currentTweenTarget = targetCFrame
    currentTweenOwner = owner

    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    currentTween.Completed:Connect(function()
        if currentTweenTarget == targetCFrame then
            currentTween = nil
            currentTweenTarget = nil
            currentTweenOwner = nil
        end
    end)
    currentTween:Play()
    return currentTween
end

local function AnyMovementFeatureActive()
    local S = _G.Settings
    return S.Main["Auto Farm Level"] or S.Main["Auto Farm Material"]
        or S.Main["Auto Farm Boss"] or S.Main["Auto Farm All Boss"]
        or S.SubFarm["Auto Farm Bone"] or S.SubFarm["Auto Elite Hunter"]
        or S.SubFarm["Auto Chest Tween"] or S.SubFarm["Auto Chest Instant"]
        or S.SubFarm["Auto Farm Leviathan"]
        or S.SubFarm["Auto Mastery Melee (Tiki)"] or S.SubFarm["Auto Mastery Swords"]
        or S.SubFarm["Auto Mastery Blox Fruits"] or S.SubFarm["Auto Mastery Guns"]
        or S.Raid["Auto Dungeon / Raid"] or S.Raid["Auto Clear Dungeon Waves"]
        or S.Raid["Auto Next Island"] or S.Raid["Law Raid"]
        or S.ItemsQuests["Auto Sword Quest"] or S.ItemsQuests["Auto Farm CDK"]
        or S.ItemsQuests["Auto Farm TTK"] or S.Race["Auto Find Mirage"]
        or S.Race["Auto Race V2 Quest"] or S.Race["Auto Race V3 Quest"]
        or S.Sea["Auto Find Kitsune Island"] or S.Sea["Auto Prehistoric Island"]
        or S.Sea["Auto Complete Prehistoric Island"] or S.Sea["Auto Draco Trail"]
        or S.Combat["Auto PvP Escape"] or S.Fruits["Fruit Sniper"]
end

local function StopTween(owner: string?)
    -- If another movement feature is still active, never kill its movement.
    if owner and currentTweenOwner and currentTweenOwner ~= owner and AnyMovementFeatureActive() then
        return
    end

    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    currentTweenTarget = nil
    currentTweenOwner = nil

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

-- ============================================================
-- HAROON HUB UPDATE 28 PROFESSIONAL WORLD / SEA / STATUS ENGINE
-- ============================================================
local BFState = rawget(getgenv(), "HaroonBFState") or {
    ServerTime = false, ServerTimeAFK = false, AutoCakePrince = false,
    AutoDoughKing = false, AutoSummonCakePrince = false,
    AutoFindMirage = false, AutoFindKitsune = false, AutoSeaEvents = false,
    AutoSubmerged = false
}
getgenv().HaroonBFState = BFState

local function BFAlive(model)
    local h = model and model:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function BFFindEnemy(names)
    names = type(names) == "table" and names or {names}
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    for _, v in ipairs(folder:GetChildren()) do
        if v:IsA("Model") and table.find(names, v.Name) and BFAlive(v) then return v end
    end
end

local function BFHasItem(name)
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local c = LocalPlayer.Character
    return (bp and bp:FindFirstChild(name)) or (c and c:FindFirstChild(name))
end

local function BFParseProgress(result)
    if type(result) ~= "string" then return nil end
    local n = tonumber(string.match(result, "%d+"))
    if not n then return nil end
    return math.clamp(n, 0, 500)
end

function BFGetCakeStatus()
    local boss = BFFindEnemy("Cake Prince")
    if boss then return true, 500, 0 end
    local result = nil
    pcall(function() result = CommF_:InvokeServer("CakePrinceSpawner") end)
    local lower = type(result) == "string" and result:lower() or ""
    if lower:find("spawned") or lower:find("ready") then return true, 500, 0 end
    local remaining = BFParseProgress(result)
    if remaining ~= nil then return false, 500 - remaining, remaining end
    return false, 0, 500
end

function BFGetDoughStatus()
    local boss = BFFindEnemy("Dough King")
    if boss then return true, 500, 0, true end
    local hasSweet = BFHasItem("Sweet Chalice")
    local hasGod = BFHasItem("God's Chalice")
    local cakeSpawned, killed, remaining = BFGetCakeStatus()
    local ready = hasSweet
    return false, killed or 0, remaining or 500, ready or hasGod
end

local function BFFormatTime(seconds)
    seconds = math.max(0, math.floor(seconds or 0))
    return string.format("%02d:%02d:%02d", math.floor(seconds/3600), math.floor(seconds/60)%60, seconds%60)
end

local function BFMap()
    return workspace:FindFirstChild("Map")
end

local function BFFindIsland(kind)
    local map = BFMap()
    if not map then return nil end
    local exact = kind == "Mirage" and {"MysticIsland","Mirage Island","MirageIsland"} or {"KitsuneIsland","Kitsune Island","KitsuneIslandEvent"}
    for _, n in ipairs(exact) do
        local obj = map:FindFirstChild(n, true)
        if obj then return obj end
    end
    local needle = kind:lower():gsub("%s+", "")
    for _, obj in ipairs(map:GetDescendants()) do
        local n = obj.Name:lower():gsub("%s+", "")
        if obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart") then
            if n:find(needle) then return obj end
        end
    end
end

local function BFIslandPivot(obj)
    if not obj then return nil end
    if obj:IsA("Model") then return obj:GetPivot() end
    if obj:IsA("BasePart") then return obj.CFrame end
    local p = obj:FindFirstChildWhichIsA("BasePart", true)
    return p and p.CFrame or nil
end

local function BFTeleportToIsland(kind)
    local cf = BFIslandPivot(BFFindIsland(kind))
    local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if cf and r then
        r.CFrame = cf * CFrame.new(0, 35, 0)
        return true
    end
    return false
end

local function BFGetOwnedBoat()
    local boats = workspace:FindFirstChild("Boats")
    if not boats then return nil end
    for _, boat in ipairs(boats:GetChildren()) do
        local owner = boat:FindFirstChild("Owner")
        if owner and tostring(owner.Value) == tostring(LocalPlayer.Name) then return boat end
        if boat:GetAttribute("Owner") == LocalPlayer.Name then return boat end
    end
end

local function BFBoatPivot(boat)
    if not boat then return nil end
    return boat:IsA("Model") and boat:GetPivot() or (boat:IsA("BasePart") and boat.CFrame)
end

local function BFMoveBoatOnSurface(boat, pos)
    if not boat then return false end
    local cf = BFBoatPivot(boat)
    if not cf then return false end
    local target = CFrame.new(pos.X, 8, pos.Z) * CFrame.Angles(0, math.rad((os.clock()*18)%360), 0)
    pcall(function()
        if boat:IsA("Model") then boat:PivotTo(target) else boat.CFrame = target end
    end)
    return true
end

local MirageSearchStarted = os.clock()
local KitsuneSearchStarted = os.clock()
local SeaSearchStarted = os.clock()

local function BFSearchBoat(kind)
    local boat = BFGetOwnedBoat()
    if not boat then
        pcall(function() CommF_:InvokeServer("BuyBoat", _G.Settings.Sea["Selected Boat"] or "Guardian") end)
        return
    end
    local origin = BFBoatPivot(boat)
    if not origin then return end
    local elapsed = kind == "Mirage" and (os.clock()-MirageSearchStarted) or (os.clock()-KitsuneSearchStarted)
    local radius = 900 + math.min(elapsed * 35, 6000)
    local angle = elapsed * 0.35
    local target = origin.Position + Vector3.new(math.cos(angle)*radius, 0, math.sin(angle)*radius)
    BFMoveBoatOnSurface(boat, target)
    local seat = boat:FindFirstChildWhichIsA("VehicleSeat", true)
    local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if seat and r and (r.Position-seat.Position).Magnitude > 60 then r.CFrame = seat.CFrame * CFrame.new(0, 4, 0) end
end

local SeaEventNames = {
    ["Terrorshark"] = true, ["Shark"] = true, ["Piranha"] = true,
    ["Fish Crew Member"] = true, ["Ghost Ship"] = true, ["Sea Beast"] = true,
    ["Leviathan"] = true
}

local function BFFindSeaEvent()
    local sea = workspace:FindFirstChild("SeaBeasts")
    if sea then
        for _, v in ipairs(sea:GetChildren()) do
            if SeaEventNames[v.Name] or v.Name:lower():find("sea") or v.Name:lower():find("leviathan") then return v end
        end
    end
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, v in ipairs(enemies:GetChildren()) do
            if SeaEventNames[v.Name] then return v end
        end
    end
end

local function BFFindSubmergedQuest(level)
    local map = BFMap()
    if not map then return nil end
    local desired = level < 2650 and "Submerged Quest Giver 1" or (level < 2675 and "Submerged Quest Giver 2" or "Submerged Quest Giver 3")
    local npc = workspace:FindFirstChild(desired, true) or map:FindFirstChild(desired, true)
    if npc and npc:IsA("Model") then return npc end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower() == desired:lower() then return obj end
    end
end

local SubmergedQuests = {
    {Min=2600, Max=2624, Mob="Reef Bandit", Quest="SubmergedQuest1", Level=1, Giver="Submerged Quest Giver 1"},
    {Min=2625, Max=2649, Mob="Coral Pirate", Quest="SubmergedQuest1", Level=2, Giver="Submerged Quest Giver 1"},
    {Min=2650, Max=2674, Mob="Sea Chanter", Quest="SubmergedQuest2", Level=1, Giver="Submerged Quest Giver 2"},
    {Min=2675, Max=2699, Mob="Ocean Prophet", Quest="SubmergedQuest2", Level=2, Giver="Submerged Quest Giver 2"},
    {Min=2700, Max=2800, Mob="Grand Devotee", Quest="SubmergedQuest3", Level=2, Giver="Submerged Quest Giver 3"},
}

local function BFGetLevel()
    local stats = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("leaderstats")
    local lv = stats and stats:FindFirstChild("Level")
    return tonumber(lv and lv.Value) or 0
end

local function BFSubmergedStep()
    local level = BFGetLevel()
    if level < 2600 or level > 2800 then return false end
    local q
    for _, data in ipairs(SubmergedQuests) do if level >= data.Min and level <= data.Max then q=data break end end
    if not q then return false end
    local mob = BFFindEnemy(q.Mob)
    local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local giver = BFFindSubmergedQuest(level)
    if mob then
        attackTarget(mob)
        return true
    end
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
    local title = questGui and questGui:FindFirstChild("Container") and questGui.Container:FindFirstChild("QuestTitle") and questGui.Container.QuestTitle:FindFirstChild("Title")
    local active = title and title.Text:find(q.Mob)
    if not active then
        if giver then
            local gp = giver:FindFirstChild("HumanoidRootPart") or giver.PrimaryPart
            if gp and r and (r.Position-gp.Position).Magnitude > 25 then r.CFrame = gp.CFrame * CFrame.new(0,5,0) end
            pcall(function() CommF_:InvokeServer("StartQuest", q.Quest, q.Level) end)
        end
    else
        -- Keep the player safely inside the underwater island; high Y values can resurface the player.
        if r and r.Position.Y > 0 then r.CFrame = CFrame.new(r.Position.X, -18, r.Position.Z) end
    end
    return true
end

-- Dedicated Update 28 level route. Submerged Island covers 2600-2800.
task.spawn(function()
    while task.wait(0.12) do
        if BFState.AutoSubmerged and _G.Settings.Main["Auto Farm Level"] then
            pcall(BFSubmergedStep)
        end
    end
end)

-- Fruit / AFK / Cake / Dough controllers (independent and stoppable).
local FruitLoopToken = 0
local function BFIsFruitTool(obj)
    if not obj or not obj:IsA("Tool") then return false end
    local n = obj.Name:lower()
    local tip = (obj.ToolTip or ""):lower()
    return tip == "blox fruit" or n:find("fruit") or n:find("falcon") or n:find("leopard") or n:find("dough") or n:find("dragon") or n:find("kitsune")
end
local function BFFruitTools()
    local out = {}
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local c = LocalPlayer.Character
    for _, parent in ipairs({bp,c}) do
        if parent then for _, v in ipairs(parent:GetChildren()) do if BFIsFruitTool(v) then table.insert(out,v) end end end
    end
    return out
end
local function BFStartFruitLoop()
    FruitLoopToken += 1
    local token = FruitLoopToken
    task.spawn(function()
        while token == FruitLoopToken and (_G.Settings.Fruits["Auto Store Fruit"] or _G.Settings.Fruits["Auto Drop Fruit"] or _G.Settings.Fruits["Auto Collect World Fruits"]) do
            pcall(function()
                local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if _G.Settings.Fruits["Auto Collect World Fruits"] and r then
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v:IsA("Tool") and BFIsFruitTool(v) then
                            local part = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                            if part and (part.Position-r.Position).Magnitude < 250 then r.CFrame = part.CFrame end
                        end
                    end
                end
                for _, fruit in ipairs(BFFruitTools()) do
                    if _G.Settings.Fruits["Auto Store Fruit"] then
                        pcall(function() CommF_:InvokeServer("StoreFruit", fruit.Name, fruit) end)
                    elseif _G.Settings.Fruits["Auto Drop Fruit"] then
                        pcall(function() fruit.Parent = workspace end)
                    end
                end
            end)
            task.wait(0.7)
        end
    end)
end

local AFKToken = 0
local function BFStartAFK()
    AFKToken += 1
    local token = AFKToken
    task.spawn(function()
        while token == AFKToken and BFState.ServerTimeAFK do
            pcall(function()
                local vu = VirtualUser
                local camera = workspace.CurrentCamera
                if vu and LocalPlayer.Character and camera then
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2))
                end
            end)
            task.wait(45)
        end
    end)
end

local function BFStartCakeDoughLoops()
    task.spawn(function()
        while BFState.AutoCakePrince do
            pcall(function()
                local boss = BFFindEnemy("Cake Prince")
                if boss then attackTarget(boss) else
                    local mob = BFFindEnemy({"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"})
                    if mob then attackTarget(mob) else moveTo(CFrame.new(-2077, 252, -12373)) end
                end
            end)
            task.wait(0.15)
        end
    end)
    task.spawn(function()
        while BFState.AutoDoughKing do
            pcall(function()
                local boss = BFFindEnemy("Dough King")
                if boss then attackTarget(boss) else
                    if BFHasItem("Sweet Chalice") then pcall(function() CommF_:InvokeServer("CakePrinceSpawner", true) end)
                    elseif BFHasItem("God's Chalice") then pcall(function() CommF_:InvokeServer("SweetChaliceNpc") end)
                    else
                        local mob = BFFindEnemy({"Cocoa Warrior","Chocolate Bar Battler"})
                        if mob then attackTarget(mob) else moveTo(CFrame.new(402.719,81.061,-12259.543)) end
                    end
                end
            end)
            task.wait(0.2)
        end
    end)
end

-- Mirage / Kitsune search: keep the boat at surface height instead of lifting the player into the air.
task.spawn(function()
    while task.wait(0.35) do
        if BFState.AutoFindMirage and not BFFindIsland("Mirage") then pcall(BFSearchBoat, "Mirage") else MirageSearchStarted = os.clock() end
        if BFState.AutoFindKitsune and not BFFindIsland("Kitsune") then pcall(BFSearchBoat, "Kitsune") else KitsuneSearchStarted = os.clock() end
    end
end)

-- Sea-event tracker / auto-positioning.
task.spawn(function()
    while task.wait(0.25) do
        if BFState.AutoSeaEvents then
            pcall(function()
                local event = BFFindSeaEvent()
                local part = event and (event:FindFirstChild("HumanoidRootPart") or event.PrimaryPart or event:FindFirstChildWhichIsA("BasePart", true))
                local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if part and r then r.CFrame = part.CFrame * CFrame.new(0, 35, 0) end
            end)
        end
    end
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
            if not state then StopTween("AutoFarmLevel") end
        end)

        MainTab:CreateSection("Update 28 • Submerged Island • Max Level 2800")
        MainTab:CreateParagraph({Title="Submerged Route", Desc="Lv. 2600 → 2800 | Third Sea | Underwater", Image="rbxassetid://6034453535", ImageSize=20})
        MainTab:CreateToggle("Auto Farm Submerged Island (2600-2800)", "AutoSubmergedFlag", false, function(state)
            _G.Settings.Misc["Update 28 Submerged"] = state
            BFState.AutoSubmerged = state
            if not state then StopTween("AutoSubmerged") end
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

        MainTab:CreateSection("Materials Farming")

        MainTab:CreateDropdown("Select Material", "MatDropdownFlag", MaterialList, MaterialList[1], function(selected)
            _G.Settings.Main["Selected Material"] = selected
        end)

        MainTab:CreateToggle("Auto Farm Material", "FarmMatFlag", false, function(state)
            _G.Settings.Main["Auto Farm Material"] = state
            if not state then StopTween("AutoFarmMaterial") end
        end)

        MainTab:CreateSection("Boss Farming")

        MainTab:CreateDropdown("Select Target Boss", "BossDropdownFlag", BossList, BossList[1], function(selected)
            _G.Settings.Main["Selected Boss"] = selected
        end)

        MainTab:CreateToggle("Auto Farm Selected Boss", "FarmBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm Boss"] = state
            if not state then StopTween("AutoFarmBoss") end
        end)

        MainTab:CreateToggle("Auto Farm All Available Bosses", "FarmAllBossFlag", false, function(state)
            _G.Settings.Main["Auto Farm All Boss"] = state
            if not state then StopTween("AutoFarmAllBoss") end
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
            if not state then StopTween("Citizen") end
        end)

        QuestsTab:CreateButton("Start Citizen Quest Immediately", function()
            if CommF_ then
                CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
                AetherUI:Notify({Title = "Citizen Quest", Content = "Citizen Quest Started!", Duration = 2})
            end
        end)

        QuestsTab:CreateSection("Puzzles & Special Challenges")
        QuestsTab:CreateToggle("Auto Yama Puzzle", "YamaPuzzleFlag", false, function(s) _G.Settings.Quests["Auto Yama Puzzle"] = s end)
        QuestsTab:CreateToggle("Auto Tushita Puzzle", "TushitaPuzzleFlag", false, function(s) _G.Settings.Quests["Auto Tushita Puzzle"] = s end)
        QuestsTab:CreateToggle("Auto Colosseum Puzzle", "ColosseumPuzzleFlag", false, function(s) _G.Settings.Quests["Auto Colosseum Puzzle"] = s end)
        QuestsTab:CreateToggle("Auto Dough / Cake Challenges", "DoughChallengeFlag", false, function(s) _G.Settings.Quests["Auto Dough Challenges"] = s end)
        QuestsTab:CreateToggle("Auto Cake Prince", "AutoCakePrinceFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Cake Prince"] = state
            BFState.AutoCakePrince = state
            if state then BFStartCakeDoughLoops() else StopTween("CakePrince") end
        end)

        QuestsTab:CreateToggle("Auto Dough King", "AutoDoughKingFlag", false, function(state)
            _G.Settings.Cake["Auto Kill Dough King"] = state
            BFState.AutoDoughKing = state
            if state then BFStartCakeDoughLoops() else StopTween("DoughKing") end
        end)

        QuestsTab:CreateToggle("Cake Prince Progress Display", "CakeProgressDisplayFlag", true, function(state)
            _G.Settings.Cake["Cake Progress Display"] = state
        end)

        QuestsTab:CreateToggle("Dough King Progress Display", "DoughProgressDisplayFlag", true, function(state)
            _G.Settings.Cake["Dough Progress Display"] = state
        end)
        QuestsTab:CreateToggle("Auto Soul Guitar Puzzle", "SoulGuitarPuzzleFlag", false, function(s) _G.Settings.Quests["Auto Soul Guitar Puzzle"] = s end)

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
            if not state then StopTween("AutoBone") end
        end)

        SubFarmTab:CreateToggle("Auto Accept Bone Quest", "AutoAcceptBoneQuestFlag", false, function(state)
            _G.Settings.SubFarm["Auto Accept Bone Quest"] = state
        end)

        SubFarmTab:CreateToggle("Auto Random Surprise (Death King)", "AutoRandomSurpriseFlag", false, function(state)
            _G.Settings.SubFarm["Auto Random Surprise"] = state
        end)

        SubFarmTab:CreateToggle("Auto Elite Hunter", "EliteFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter"] = state
            if not state then StopTween("AutoElite") end
        end)

        SubFarmTab:CreateToggle("Auto Elite Hunter Hop", "EliteHopFlag", false, function(state)
            _G.Settings.SubFarm["Auto Elite Hunter Hop"] = state
            if not state then StopTween("AutoEliteHop") end
        end)

        SubFarmTab:CreateSection("Chests Farming")

        SubFarmTab:CreateToggle("Auto Chest (Tween)", "ChestTweenFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Tween"] = state
            if not state then StopTween("AutoChestTween") end
        end)

        SubFarmTab:CreateToggle("Auto Chest (Instant)", "ChestInstantFlag", false, function(state)
            _G.Settings.SubFarm["Auto Chest Instant"] = state
            if not state then StopTween("AutoChestInstant") end
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
            if not state then StopTween("AutoRaid") end
        end)

        RaidTab:CreateToggle("Auto Buy Chip & Start Raid", "AutoBuyStartRaidFlag", false, function(state)
            _G.Settings.Raid["Auto Buy Chip & Start"] = state
        end)

        RaidTab:CreateToggle("Auto Clear Dungeon Waves", "AutoClearDungeonFlag", false, function(state)
            _G.Settings.Raid["Auto Clear Dungeon Waves"] = state
            if not state then StopTween("RaidClear") end
        end)

        RaidTab:CreateToggle("Auto Next Island (5 Islands Full Scanner)", "AutoNextIslandFlag", false, function(state)
            _G.Settings.Raid["Auto Next Island"] = state
            if not state then StopTween("RaidNextIsland") end
        end)

        RaidTab:CreateToggle("Auto Awaken Skills", "AutoAwakenSkillsFlag", false, function(state)
            _G.Settings.Raid["Auto Awaken"] = state
        end)

        RaidTab:CreateToggle("Auto Law Raid", "LawRaidFlag", false, function(state)
            _G.Settings.Raid["Law Raid"] = state
            if not state then StopTween("LawRaid") end
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
            if not state then StopTween("Prehistoric") end
        end)

        SeaTab:CreateToggle("Auto Complete Prehistoric Torches", "AutoCompletePrehistoricFlag", false, function(state)
            _G.Settings.Sea["Auto Complete Prehistoric Island"] = state
            if not state then StopTween("PrehistoricTorches") end
        end)

        SeaTab:CreateToggle("Auto Draco Trail", "AutoDracoTrailFlag", false, function(state)
            _G.Settings.Sea["Auto Draco Trail"] = state
            if not state then StopTween("Draco") end
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

        local SeaEventStatusPara = SeaTab:CreateParagraph({Title="Sea Event Status", Desc="🔴 No Sea Event", Image="rbxassetid://6034453535", ImageSize=20})
        SeaTab:CreateToggle("Auto Sea Event Scanner / Position", "AutoSeaEventsFlag", false, function(state)
            _G.Settings.Misc["Auto Sea Events"] = state
            BFState.AutoSeaEvents = state
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
            if not state then StopTween() end
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

        RaceTab:CreateSection("Mirage / Kitsune Professional Scanner")

        local MirageStatusPara = RaceTab:CreateParagraph({Title = "Mirage Island Status", Desc = "🔴 Not Spawned", Image = "rbxassetid://6034453535", ImageSize = 20})
        local KitsuneStatusPara = RaceTab:CreateParagraph({Title = "Kitsune Island Status", Desc = "🔴 Not Spawned", Image = "rbxassetid://6034453535", ImageSize = 20})

        RaceTab:CreateToggle("Auto Find Mirage Island • Surface Boat", "AutoFindMirageFlag", false, function(state)
            _G.Settings.Race["Auto Find Mirage"] = state
            BFState.AutoFindMirage = state
            if state then MirageSearchStarted = os.clock() end
        end)

        RaceTab:CreateButton("Teleport To Mirage Island", function()
            if not BFTeleportToIsland("Mirage") then
                AetherUI:Notify({Title="Mirage", Content="Mirage Island is not spawned in this server.", Duration=3})
            end
        end)

        RaceTab:CreateToggle("Auto Find Kitsune Island • Surface Boat", "AutoFindKitsuneFlag", false, function(state)
            _G.Settings.Race["Auto Find Kitsune Island"] = state
            BFState.AutoFindKitsune = state
            if state then KitsuneSearchStarted = os.clock() end
        end)

        RaceTab:CreateButton("Teleport To Kitsune Island", function()
            if not BFTeleportToIsland("Kitsune") then
                AetherUI:Notify({Title="Kitsune", Content="Kitsune Island is not spawned in this server.", Duration=3})
            end
        end)

        RaceTab:CreateToggle("Tween To Highest Mirage Point", "TweenMirageFlag", false, function(state)
            _G.Settings.Race["Tween To Highest Mirage"] = state
            if not state then StopTween("MirageHighest") end
        end)

        RaceTab:CreateToggle("Teleport To Blue Gear", "TeleportToGearFlag", false, function(state)
            _G.Settings.Race["Teleport To Blue Gear"] = state
            if not state then StopTween("BlueGear") end
        end)

        RaceTab:CreateToggle("Auto Look Moon Ability", "LookMoonFlag", false, function(state)
            _G.Settings.Race["Look Moon Ability"] = state
        end)

        RaceTab:CreateToggle("Teleport To Race Door", "TPDoorFlag", false, function(state)
            _G.Settings.Race["Teleport To Race Door"] = state
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
            BFState.AutoStoreFruit = state
            BFStartFruitLoop()
        end)

        FruitsTab:CreateToggle("Auto Drop Fruit", "AutoDropFruitFlag", false, function(state)
            _G.Settings.Fruits["Auto Drop Fruit"] = state
            BFState.AutoDropFruit = state
            BFStartFruitLoop()
        end)

        FruitsTab:CreateToggle("Auto Collect World Fruits", "AutoCollectWorldFruitsFlag", false, function(state)
            _G.Settings.Fruits["Auto Collect World Fruits"] = state
            BFState.CollectWorldFruits = state
            BFStartFruitLoop()
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

        MiscTab:CreateSection("Live Server & Player Information")

        local SessionTimePara = MiscTab:CreateParagraph({
            Title = "Session Time",
            Desc = "00:00:00",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local TimezonePara = MiscTab:CreateParagraph({
            Title = "Timezones",
            Desc = "Local: --:--:-- | UTC: --:--:--",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local ElitePara = MiscTab:CreateParagraph({
            Title = "Elite Hunters Killed",
            Desc = "Checking...",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local SwordPara = MiscTab:CreateParagraph({
            Title = "Legendary Swords Owned",
            Desc = "0 / 3 Owned",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local SeaIslandPara = MiscTab:CreateParagraph({
            Title = "Location & Sea",
            Desc = "Sea: Detecting... | Island: Detecting...",
            Image = "rbxassetid://6034453535",
            ImageSize = 20
        })

        local StatsPara = MiscTab:CreateParagraph({
            Title = "Player Stats & Currency",
            Desc = "Level: -- | Beli: -- | Fragments: --",
            Image = "rbxassetid://6031280882",
            ImageSize = 20
        })

        local ServerInfoPara = MiscTab:CreateParagraph({
            Title = "Server Uptime & Players",
            Desc = "Players: 0/0 | Uptime: 00:00:00",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local CakePrinceStatusPara = MiscTab:CreateParagraph({
            Title = "Cake Prince Status",
            Desc = "🔴 Not Spawned",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local CakePrinceProgressPara = MiscTab:CreateParagraph({
            Title = "Cake Prince Progress",
            Desc = "0/500",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local DoughKingStatusPara = MiscTab:CreateParagraph({
            Title = "Dough King Status",
            Desc = "🔴 Not Ready",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local DoughKingProgressPara = MiscTab:CreateParagraph({
            Title = "Dough King Progress",
            Desc = "0/500",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local DoughItemsPara = MiscTab:CreateParagraph({
            Title = "Sweet Chalice",
            Desc = "🔴 Not Owned",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })

        local AFKStatusPara = MiscTab:CreateParagraph({
            Title = "Server Time / Anti-AFK",
            Desc = "Server: --:--:-- | Anti-AFK: 🔴 Off",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        MiscTab:CreateToggle("Server Time", "ServerTimeFlag", false, function(state)
            _G.Settings.Misc["Server Time"] = state
            BFState.ServerTime = state
        end)

        MiscTab:CreateToggle("Server Time AFK / Anti-AFK", "ServerTimeAFKFlag", false, function(state)
            _G.Settings.Misc["Server Time AFK"] = state
            BFState.ServerTimeAFK = state
            if state then BFStartAFK() end
        end)

        local NetworkPara = MiscTab:CreateParagraph({
            Title = "Network FPS & Ping",
            Desc = "FPS: -- | Ping: -- ms",
            Image = "rbxassetid://6031280882",
            ImageSize = 20
        })

        -- Live Updater Coroutine
        local scriptStartTime = os.clock()
        local serverStartTime = os.clock()

        task.spawn(function()
            while task.wait(1) do
                pcall(function()
                    -- 1. Session Time
                    local elapsed = math.floor(os.clock() - scriptStartTime)
                    local sH = math.floor(elapsed / 3600)
                    local sM = math.floor((elapsed % 3600) / 60)
                    local sS = elapsed % 60
                    SessionTimePara:SetDesc(string.format("%02d:%02d:%02d", sH, sM, sS))

                    -- 2. Timezones
                    local localTime = os.date("%H:%M:%S")
                    local utcTime = os.date("!%H:%M:%S")
                    TimezonePara:SetDesc("Local: " .. localTime .. " | UTC: " .. utcTime)

                    -- 3. Elite Kills
                    local stats = LocalPlayer:FindFirstChild("leaderstats")
                    local ekVal = "N/A"
                    if stats then
                        for _, v in pairs(stats:GetChildren()) do
                            if v.Name:lower():find("elite") then ekVal = tostring(v.Value) break end
                        end
                    end
                    ElitePara:SetDesc(ekVal)

                    -- 4. Legendary Swords
                    local ownedCount = 0
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    local c = LocalPlayer.Character
                    for _, sName in ipairs({"Shisui", "Saddi", "Wando"}) do
                        if (bp and bp:FindFirstChild(sName)) or (c and c:FindFirstChild(sName)) then
                            ownedCount = ownedCount + 1
                        end
                    end
                    SwordPara:SetDesc(ownedCount .. " / 3 Owned")

                    -- 5. Sea & Island
                    local currentSeaName = World1 and "First Sea" or (World2 and "Second Sea" or (World3 and "Third Sea" or "Unknown"))
                    SeaIslandPara:SetDesc("Sea: " .. currentSeaName)

                    -- 6. Player Stats & Currency
                    local level = stats and stats:FindFirstChild("Level") and stats.Level.Value or "N/A"
                    local beli = stats and stats:FindFirstChild("Beli") and stats.Beli.Value or "N/A"
                    local frags = stats and stats:FindFirstChild("Fragments") and stats.Fragments.Value or "N/A"
                    StatsPara:SetDesc("Level: " .. level .. " | Beli: " .. beli .. " | Fragments: " .. frags)

                    -- 7. Server Uptime & Players
                    local pCount = #Players:GetPlayers()
                    local maxP = Players.MaxPlayers
                    local upSec = math.floor(os.clock() - serverStartTime)
                    local uH = math.floor(upSec / 3600)
                    local uM = math.floor((upSec % 3600) / 60)
                    local uS = upSec % 60
                    ServerInfoPara:SetDesc("Players: " .. pCount .. "/" .. maxP .. " | Uptime: " .. string.format("%02d:%02d:%02d", uH, uM, uS))

                    -- 8. Cake Prince / Dough King live progress
                    if World3 and CommF_ then
                        local cakeSpawned, cakeKilled, cakeRemaining = BFGetCakeStatus()
                        local doughSpawned, doughKilled, doughRemaining, hasSweet = BFGetDoughStatus()

                        CakePrinceStatusPara:SetDesc(cakeSpawned and "🟢 Spawned" or "🔴 Not Spawned")
                        CakePrinceProgressPara:SetDesc(cakeKilled and (tostring(cakeKilled) .. "/500 | " .. tostring(cakeRemaining) .. " remaining") or "Checking...")

                        local doughReady = doughSpawned or (hasSweet and doughRemaining == 0)
                        DoughKingStatusPara:SetDesc(doughSpawned and "🟢 Spawned" or (doughReady and "🟢 Ready" or "🔴 Not Ready"))
                        DoughKingProgressPara:SetDesc(doughKilled and (tostring(doughKilled) .. "/500 | " .. tostring(doughRemaining) .. " remaining") or "Checking...")
                        DoughItemsPara:SetDesc(hasSweet and "🟢 Owned" or "🔴 Not Owned")
                    else
                        CakePrinceStatusPara:SetDesc("🔴 Third Sea Only")
                        CakePrinceProgressPara:SetDesc("0/500")
                        DoughKingStatusPara:SetDesc("🔴 Third Sea Only")
                        DoughKingProgressPara:SetDesc("0/500")
                        DoughItemsPara:SetDesc("🔴 Not Available")
                    end

                    local serverClock = workspace:GetServerTimeNow()
                    local antiAFK = BFState.ServerTimeAFK and "🟢 Active" or "🔴 Off"
                    AFKStatusPara:SetDesc("Server Clock: " .. os.date("%H:%M:%S", math.floor(serverClock)) .. " | Anti-AFK: " .. antiAFK .. " | Session: " .. string.format("%02d:%02d:%02d", math.floor(elapsed/3600), math.floor((elapsed%3600)/60), elapsed%60))

                    -- 9. FPS & Ping
                    local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                    NetworkPara:SetDesc("Ping: " .. ping .. " ms")
                end)
            end
        end)

        -- Professional live status updater: Paragraph:SetDesc is used consistently.
        task.spawn(function()
            while task.wait(1) do
                pcall(function()
                    local mirage = BFFindIsland("Mirage")
                    local kitsune = BFFindIsland("Kitsune")
                    local seaEvent = BFFindSeaEvent()
                    local map = BFMap()
                    local function setIslandParagraph(title, desc)
                        -- Paragraph references are intentionally kept in the existing UI updater.
                    end
                    -- Update visible status paragraphs when the library exposes them through the parent UI.
                    for _, container in ipairs({RaceTab, SeaTab}) do
                        -- no-op; actual paragraph references are managed by the library.
                    end
                    if mirage then
                        getgenv().Haroon_MirageStatus = "🟢 Spawned"
                    else
                        getgenv().Haroon_MirageStatus = "🔴 Not Spawned"
                    end
                    if kitsune then
                        getgenv().Haroon_KitsuneStatus = "🟢 Spawned"
                    else
                        getgenv().Haroon_KitsuneStatus = "🔴 Not Spawned"
                    end
                    getgenv().Haroon_SeaEventStatus = seaEvent and ("🟢 "..seaEvent.Name) or "🔴 No Sea Event"
                    MirageStatusPara:SetDesc(getgenv().Haroon_MirageStatus)
                    KitsuneStatusPara:SetDesc(getgenv().Haroon_KitsuneStatus)
                    SeaEventStatusPara:SetDesc(getgenv().Haroon_SeaEventStatus)
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

                if BFSubmergedStep() then
                    AutoHaki()
                    return
                end
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
-- 10. ADVANCED RAID ENGINE: Auto Next Island (Checks 5 Islands & Enemy Clearance)
--------------------------------------------------------------------------------
local RaidNextIslandIndex = 1
local RaidLastTargetPosition = nil
local RaidLastTargetTime = 0
local RAID_ISLAND_RADIUS = 260

local function GetRaidIslands()
    local islands = {}
    local folders = {
        workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Locations"),
        workspace:FindFirstChild("Locations"),
        workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Locations"),
        workspace:FindFirstChild("Map"),
        workspace:FindFirstChild("_WorldOrigin")
    }

    local function getCF(obj)
        if obj:IsA("BasePart") then return obj.CFrame end
        if obj:IsA("Model") then
            local ok, cf = pcall(function() return obj:GetPivot() end)
            if ok then return cf end
        end
        return nil
    end

    for _, folder in ipairs(folders) do
        if folder then
            for _, child in ipairs(folder:GetChildren()) do
                local name = child.Name
                local num = string.match(name, "[Ii]sland%s*<?%s*(%d+)")
                    or string.match(name, "<%s*[Ii]sland%s*(%d+)%s*>")
                    or string.match(name, "[Rr]aid%s*[Ii]sland%s*(%d+)")
                local index = tonumber(num)
                if index and index >= 1 and index <= 5 and not islands[index] then
                    local cf = getCF(child)
                    if cf then islands[index] = cf end
                end
            end
        end
    end
    return islands
end

local function GetAliveRaidEnemiesNear(position, radius)
    local result = {}
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return result end

    for _, enemy in ipairs(enemies:GetChildren()) do
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.Health > 0 and (root.Position - position).Magnitude <= radius then
            table.insert(result, enemy)
        end
    end
    return result
end

local function GetClosestAliveRaidEnemy(position, radius)
    local closest, closestDistance
    for _, enemy in ipairs(GetAliveRaidEnemiesNear(position, radius)) do
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if root then
            local d = (position - root.Position).Magnitude
            if not closestDistance or d < closestDistance then
                closest, closestDistance = enemy, d
            end
        end
    end
    return closest
end

local function ResetRaidNavigation()
    RaidNextIslandIndex = 1
    RaidLastTargetPosition = nil
    RaidLastTargetTime = 0
end

local function GetAutoNextRaidTarget()
    local _, hrp = GetCharacter()
    if not hrp then return nil, nil end

    local islands = GetRaidIslands()
    local available = {}
    for i = 1, 5 do
        if islands[i] then table.insert(available, i) end
    end
    if #available == 0 then
        return nil, nil
    end

    -- Re-sync to the island nearest to the player, then only move forward.
    local nearestIndex, nearestDistance
    for _, i in ipairs(available) do
        local d = (hrp.Position - islands[i].Position).Magnitude
        if not nearestDistance or d < nearestDistance then
            nearestIndex, nearestDistance = i, d
        end
    end
    if nearestIndex and nearestDistance <= RAID_ISLAND_RADIUS then
        if nearestIndex >= RaidNextIslandIndex then
            RaidNextIslandIndex = math.min(nearestIndex + 1, 5)
        end

        local currentEnemy = GetClosestAliveRaidEnemy(islands[nearestIndex].Position, RAID_ISLAND_RADIUS)
        if currentEnemy then
            return currentEnemy.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.Main["Farm Distance"] or 28, 0), "enemy"
        end
    end

    -- Only advance when the current island's area is actually clear.
    local targetIndex = RaidNextIslandIndex
    while targetIndex <= 5 and not islands[targetIndex] do
        targetIndex += 1
    end

    if targetIndex > 5 then
        return nil, "done"
    end

    local target = islands[targetIndex]
    local targetDistance = (hrp.Position - target.Position).Magnitude

    -- Already there: mark it complete and continue on the next loop.
    if targetDistance <= RAID_ISLAND_RADIUS then
        local enemy = GetClosestAliveRaidEnemy(target.Position, RAID_ISLAND_RADIUS)
        if enemy then
            return enemy.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.Main["Farm Distance"] or 28, 0), "enemy"
        end
        RaidNextIslandIndex = targetIndex + 1
        return nil, "advance"
    end

    return target * CFrame.new(0, 35, 0), "island"
end

task.spawn(function()
    while task.wait(0.15) do
        local S = _G.Settings.Raid
        if S["Auto Dungeon / Raid"] or S["Auto Buy Chip & Start"] or S["Auto Clear Dungeon Waves"] or S["Auto Next Island"] then
            pcall(function()
                local _, hrp, hum = GetCharacter()
                if not hrp or not hum or hum.Health <= 0 then return end

                if not S["Auto Next Island"] then
                    ResetRaidNavigation()
                end

                if S["Auto Buy Chip & Start"] and CommF_ then
                    -- Prevent repeated Start calls every 0.15s.
                    if not _G.__HaroonRaidStartCooldown or os.clock() >= _G.__HaroonRaidStartCooldown then
                        _G.__HaroonRaidStartCooldown = os.clock() + 2
                        CommF_:InvokeServer("RaidsNpc", "Select", S["Selected Chip"])
                        task.wait(0.35)
                        CommF_:InvokeServer("RaidsNpc", "Start")
                    end
                end

                local hasMonsters = false
                if S["Auto Clear Dungeon Waves"] then
                    local enemies = workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, mob in ipairs(enemies:GetChildren()) do
                            local mobHum = mob:FindFirstChildOfClass("Humanoid")
                            local root = mob:FindFirstChild("HumanoidRootPart")
                            if mobHum and root and mobHum.Health > 0 then
                                hasMonsters = true
                                AutoHaki()
                                TweenPlayer(root.CFrame, Vector3.new(0, _G.Settings.Main["Farm Distance"], 0), "RaidClear")
                                SmartAttackMob(mob)
                                break
                            end
                        end
                    end
                end

                if S["Auto Next Island"] and not hasMonsters then
                    local targetCF, kind = GetAutoNextRaidTarget()
                    if targetCF then
                        AutoHaki()
                        local targetPos = targetCF.Position
                        if not RaidLastTargetPosition
                            or (RaidLastTargetPosition - targetPos).Magnitude > 8
                            or os.clock() - RaidLastTargetTime > 3 then
                            RaidLastTargetPosition = targetPos
                            RaidLastTargetTime = os.clock()
                            TweenPlayer(targetCF, nil, "RaidNextIsland")
                        end
                    elseif kind == "done" then
                        ResetRaidNavigation()
                    end
                end

                if S["Auto Awaken"] and CommF_ then
                    CommF_:InvokeServer("AwakeningExpert", "Awaken")
                end
            end)
        else
            ResetRaidNavigation()
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
-- 13. Sea Events, Sailing & Prehistoric Engine
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

                -- Prehistoric Island Automation
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

                -- Sea Mobs Combat
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

                -- Seabeast Combat
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

                -- Boat Sailing
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
-- 15. Advanced Dynamic ESP Engine
--------------------------------------------------------------------------------
local ESPCache = {}
local ESPFolderName = "HaroonHub_ESP"

local function GetESPContainer()
    local gui = CoreGui:FindFirstChild(ESPFolderName)
    if not gui then
        gui = Instance.new("Folder")
        gui.Name = ESPFolderName
        gui.Parent = CoreGui
    end
    return gui
end

local function RemoveESP(obj)
    local entry = ESPCache[obj]
    if entry then
        if entry.bill then entry.bill:Destroy() end
        ESPCache[obj] = nil
    end
end

local function ClearESPCategory(category)
    for obj, entry in pairs(ESPCache) do
        if entry.category == category then
            RemoveESP(obj)
        end
    end
end

local function GetESPPart(obj)
    if not obj or not obj.Parent then return nil end
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj:FindFirstChild("HumanoidRootPart")
            or obj:FindFirstChild("RootPart")
            or obj.PrimaryPart
            or obj:FindFirstChildWhichIsA("BasePart", true)
    end
    if obj:IsA("Tool") then
        return obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart", true)
    end
    return nil
end

local function CreateOrUpdateESP(obj, part, title, color, category, hum)
    if not obj or not part then return end

    local entry = ESPCache[obj]
    if not entry or not entry.bill or not entry.bill.Parent or entry.bill.Adornee ~= part then
        RemoveESP(obj)

        local bill = Instance.new("BillboardGui")
        bill.Name = "HaroonESP"
        bill.Adornee = part
        bill.Size = UDim2.fromOffset(175, hum and 52 or 34)
        bill.StudsOffset = Vector3.new(0, 2.5, 0)
        bill.AlwaysOnTop = true
        bill.MaxDistance = 10000
        bill.ResetOnSpawn = false
        bill.Parent = part

        local frame = Instance.new("Frame")
        frame.Name = "Frame"
        frame.Size = UDim2.fromScale(1, 1)
        frame.BackgroundTransparency = 1
        frame.Parent = bill

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Transparency = 0.15
        stroke.Color = color
        stroke.Parent = frame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "ESPTitle"
        titleLabel.Size = UDim2.new(1, 0, 0, 18)
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextStrokeTransparency = 0.35
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 12
        titleLabel.Parent = frame

        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "ESPDist"
        distLabel.Size = UDim2.new(1, 0, 0, 15)
        distLabel.Position = UDim2.new(0, 0, 0, 18)
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3 = Color3.fromRGB(235,235,235)
        distLabel.TextStrokeTransparency = 0.4
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 10
        distLabel.Parent = frame

        local hpFill
        if hum then
            local hpBg = Instance.new("Frame")
            hpBg.Name = "HPBackground"
            hpBg.Size = UDim2.new(1, -10, 0, 5)
            hpBg.Position = UDim2.new(0, 5, 0, 38)
            hpBg.BackgroundColor3 = Color3.fromRGB(45,45,45)
            hpBg.BorderSizePixel = 0
            hpBg.Parent = frame

            hpFill = Instance.new("Frame")
            hpFill.Name = "HPFill"
            hpFill.Size = UDim2.new(1,0,1,0)
            hpFill.BorderSizePixel = 0
            hpFill.Parent = hpBg
        end

        entry = {bill = bill, category = category, title = titleLabel, dist = distLabel, hp = hpFill}
        ESPCache[obj] = entry
    end

    entry.category = category
    entry.title.Text = title
    entry.title.TextColor3 = color
    local _, hrp = GetCharacter()
    if hrp then
        entry.dist.Text = "Dist: " .. math.floor((hrp.Position - part.Position).Magnitude) .. " Studs"
    end

    if hum and entry.hp then
        local maxHP = math.max(hum.MaxHealth, 1)
        entry.hp.Size = UDim2.new(math.clamp(hum.Health / maxHP, 0, 1), 0, 1, 0)
    end
end

local function CollectESPModels()
    local out = {}
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, v in ipairs(enemies:GetChildren()) do
            if v:IsA("Model") then table.insert(out, v) end
        end
    end
    return out
end

local function FindIslandESP(namePatterns)
    local found = {}
    local roots = {
        workspace:FindFirstChild("_WorldOrigin"),
        workspace:FindFirstChild("Map"),
        workspace:FindFirstChild("Locations")
    }
    for _, root in ipairs(roots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if (obj:IsA("Model") or obj:IsA("BasePart")) then
                    local lower = obj.Name:lower()
                    for _, pattern in ipairs(namePatterns) do
                        if lower:find(pattern) then
                            table.insert(found, obj)
                            break
                        end
                    end
                end
            end
        end
    end
    return found
end

task.spawn(function()
    while task.wait(0.25) do
        pcall(function()
            local _, hrp = GetCharacter()
            if not hrp then return end

            local V = _G.Settings.Visuals
            local F = _G.Settings.Fruits

            if V["ESP Players"] or F["Player ESP"] then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local root = p.Character:FindFirstChild("HumanoidRootPart")
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if root and hum and hum.Health > 0 then
                            CreateOrUpdateESP(p, root, "PLAYER • " .. p.Name, Color3.fromRGB(255,85,85), "Players", hum)
                        end
                    end
                end
            else
                ClearESPCategory("Players")
            end

            if V["ESP Enemies"] then
                for _, mob in ipairs(CollectESPModels()) do
                    local hum = mob:FindFirstChildOfClass("Humanoid")
                    local root = mob:FindFirstChild("HumanoidRootPart")
                    if hum and root and hum.Health > 0 then
                        CreateOrUpdateESP(mob, root, "ENEMY • " .. mob.Name, Color3.fromRGB(255,120,80), "Enemies", hum)
                    end
                end
            else
                ClearESPCategory("Enemies")
            end

            if V["ESP Bosses"] then
                for _, mob in ipairs(CollectESPModels()) do
                    local hum = mob:FindFirstChildOfClass("Humanoid")
                    local root = mob:FindFirstChild("HumanoidRootPart")
                    local lower = mob.Name:lower()
                    local isBoss = lower:find("boss") or lower:find("king") or lower:find("lord")
                        or lower:find("rip_") or lower:find("beautiful") or lower:find("don swan")
                    if isBoss and hum and root and hum.Health > 0 then
                        CreateOrUpdateESP(mob, root, "BOSS • " .. mob.Name, Color3.fromRGB(190,85,255), "Bosses", hum)
                    end
                end
            else
                ClearESPCategory("Bosses")
            end

            if V["ESP Fruits"] or F["Fruit ESP"] then
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("Tool") then
                        local n = v.Name:lower()
                        if n:find("fruit") or n:find("blox") then
                            local part = GetESPPart(v)
                            if part then
                                CreateOrUpdateESP(v, part, "FRUIT • " .. v.Name, Color3.fromRGB(255,170,0), "Fruits")
                            end
                        end
                    end
                end
            else
                ClearESPCategory("Fruits")
            end

            if V["ESP Chests"] or F["Chest ESP"] then
                local folder = workspace:FindFirstChild("ChestModels")
                if folder then
                    for _, chest in ipairs(folder:GetChildren()) do
                        local part = GetESPPart(chest)
                        if part then
                            CreateOrUpdateESP(chest, part, "CHEST • " .. chest.Name, Color3.fromRGB(255,235,70), "Chests")
                        end
                    end
                end
            else
                ClearESPCategory("Chests")
            end

            if V["ESP Mirage Island"] then
                for _, obj in ipairs(FindIslandESP({"mirage"})) do
                    local part = GetESPPart(obj)
                    if part then
                        CreateOrUpdateESP(obj, part, "ISLAND • MIRAGE", Color3.fromRGB(120,180,255), "Mirage")
                    end
                end
            else
                ClearESPCategory("Mirage")
            end

            if V["ESP Kitsune Island"] then
                for _, obj in ipairs(FindIslandESP({"kitsune"})) do
                    local part = GetESPPart(obj)
                    if part then
                        CreateOrUpdateESP(obj, part, "ISLAND • KITSUNE", Color3.fromRGB(255,120,210), "Kitsune")
                    end
                end
            else
                ClearESPCategory("Kitsune")
            end

            -- Remove stale objects (destroyed enemies/chests/players).
            for obj in pairs(ESPCache) do
                if not obj or not obj.Parent then
                    RemoveESP(obj)
                end
            end
        end)
    end
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
                        StopTween("AutoChestInstant")
                        hrp.CFrame = closestChest.RootPart.CFrame
                    elseif _G.Settings.SubFarm["Auto Chest Tween"] then
                        TweenPlayer(closestChest.RootPart.CFrame, Vector3.new(0, 3, 0), "AutoChestTween")
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
