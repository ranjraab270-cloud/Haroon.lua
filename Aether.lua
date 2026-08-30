-- [StarterPlayerScripts > LocalScript: HaroonHub_V30_TARGETED_FIXES]
repeat task.wait() until game:IsLoaded()
task.wait(1)

--------------------------------------------------------------------------------
-- 1. Core Services & Network Remotes
--------------------------------------------------------------------------------
--============================================================
-- Executor Compatibility Layer (Delta / Xeno / Arceus / KRNL / generic)
--============================================================
local GEN = (type(getgenv) == "function" and getgenv()) or _G
local HUB_SCRIPT_URL_GLOBAL = type(GEN.HAROON_HUB_URL) == "string" and GEN.HAROON_HUB_URL or ""
local function resolveGlobal(name)
    local ok, value = pcall(function() return GEN[name] end)
    if ok and value ~= nil then return value end
    return _G[name]
end

local function safeHttpGet(url)
    local getter = resolveGlobal("httpget") or resolveGlobal("HttpGet")
    if type(getter) == "function" then
        local ok, result = pcall(getter, url)
        if ok and type(result) == "string" then return result end
    end
    local ok, result = pcall(function() return game:HttpGet(url) end)
    if ok and type(result) == "string" then return result end
    return nil
end

local function safeRequest(options)
    local req = resolveGlobal("request") or resolveGlobal("http_request") or resolveGlobal("http")
    if type(req) == "function" then
        local ok, result = pcall(req, options)
        if ok then return result end
    end
    return nil
end

local function safeQueueOnTeleport(code)
    local q = resolveGlobal("queue_on_teleport") or resolveGlobal("queueonteleport") or resolveGlobal("queue_on_tp")
    if type(q) == "function" and type(code) == "string" and #code > 0 then
        return pcall(q, code)
    end
    return false
end

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
local autoFindLeviathanStep
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
local MAX_PLAYER_LEVEL = 2800
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
        ["Teleport Height"] = 100,
        ["Fast Attack"] = false,
        ["Selected Material"] = "Leather + Scrap Metal",
        ["Auto Farm Material"] = false,
        ["Selected Boss"] = "The Gorilla King",
        ["Auto Farm Boss"] = false,
        ["Auto Farm All Boss"] = false,
        ["Auto Farm Factory"] = false
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
        ["Auto Attack Selected Player"] = false,
        ["PvP Hover Height"] = 8,
        ["PvP Attack Height"] = 8,
        ["PvP Attack Range"] = 35,
        ["PvP Reacquire Delay"] = 0.15,
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
    Shop = {
        ["Stock Auto Refresh"] = false,
        ["Stock Refresh Interval"] = 30,
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
        ["Boat Height"] = 30,
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
        ["Auto Collect Azure Embers"] = false,
        ["Auto Prehistoric Island"] = false,
        ["Auto Complete Prehistoric Island"] = false,
        ["Auto Draco Trail"] = false,
        ["Auto Frozen Dimension"] = false,
        ["Auto Drive Hydra"] = false,
        ["Auto Find Leviathan"] = false,
        ["Leviathan Sea Zone"] = "Zone 6",
        ["Auto Bribe Spy"] = true,
        ["Leviathan Boat"] = "Beast Hunter",
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
        ["Server Join Mode"] = nil,
        ["Custom Speed"] = false,
        ["Walk Speed"] = 16,
        ["Custom Jump"] = false,
        ["Jump Power"] = 50,
        ["Infinity Jump"] = false,
    }
}

--------------------------------------------------------------------------------
-- 2B. Settings persistence removed as requested.
--------------------------------------------------------------------------------

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

local DEFAULT_TELEPORT_HEIGHT = 100
local MIN_TELEPORT_HEIGHT = 10
local MAX_TELEPORT_HEIGHT = 300
local TELEPORT_CLOSE_DISTANCE = 4
local activeTeleportGuardId = 0
local activeRoute = {
    owner = nil,
    destination = nil,
    targetKey = nil,
    startedAt = 0,
    stages = nil,
    stageIndex = 0,
}

local function GetTeleportHeight()
    return math.clamp(tonumber(_G.Settings.Main["Teleport Height"]) or DEFAULT_TELEPORT_HEIGHT, MIN_TELEPORT_HEIGHT, MAX_TELEPORT_HEIGHT)
end

local function CancelPlayerTween(owner: string?)
    if owner and activeRoute.owner and activeRoute.owner ~= owner then
        return false
    end
    activeTeleportGuardId += 1
    if currentTween then
        pcall(function() currentTween:Cancel() end)
    end
    currentTween = nil
    currentTweenOwner = nil
    activeRoute.owner = nil
    activeRoute.destination = nil
    activeRoute.targetKey = nil
    activeRoute.startedAt = 0
    activeRoute.stages = nil
    activeRoute.stageIndex = 0
    return true
end

-- Smooth, persistent multi-stage movement.
-- IMPORTANT: repeated calls with the same owner/nearby destination do NOT restart
-- the active Tween. This is what lets high-frequency farming loops actually finish
-- their movement instead of cancelling/restarting every frame.
local function TweenPlayer(pos: CFrame | Vector3 | BasePart, offset: Vector3?, owner: string?): Tween?
    local char, hrp, hum = GetCharacter()
    if not char or not hrp or not hum or hum.Health <= 0 then return nil end
    if hum.Sit then pcall(function() hum.Sit = false end) end

    local targetCFrame: CFrame
    if typeof(pos) == "CFrame" then
        targetCFrame = pos
    elseif typeof(pos) == "Vector3" then
        targetCFrame = CFrame.new(pos)
    elseif typeof(pos) == "Instance" and pos:IsA("BasePart") then
        targetCFrame = pos.CFrame
    else
        return nil
    end
    if offset then targetCFrame = targetCFrame * CFrame.new(offset) end

    local flatLook = Vector3.new(targetCFrame.LookVector.X, 0, targetCFrame.LookVector.Z)
    if flatLook.Magnitude < 0.01 then flatLook = Vector3.new(0, 0, -1) end
    local destination = CFrame.lookAt(targetCFrame.Position, targetCFrame.Position + flatLook)

    local routeOwner = owner or "Generic"
    local destinationChanged = true
    if activeRoute.owner == routeOwner and activeRoute.destination then
        destinationChanged = (activeRoute.destination.Position - destination.Position).Magnitude > 8
    end

    -- Keep an already-running route alive. For moving farm targets, only retarget
    -- after a meaningful displacement or once the current route has ended.
    if currentTween and currentTweenOwner == routeOwner and not destinationChanged then
        return currentTween
    end

    if currentTween and currentTweenOwner == routeOwner then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    elseif currentTween then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    end

    activeTeleportGuardId += 1
    local routeId = activeTeleportGuardId
    currentTweenOwner = routeOwner
    activeRoute.owner = routeOwner
    activeRoute.destination = destination
    activeRoute.targetKey = tostring(math.floor(destination.Position.X)) .. ":" .. tostring(math.floor(destination.Position.Y)) .. ":" .. tostring(math.floor(destination.Position.Z))
    activeRoute.startedAt = os.clock()
    activeRoute.stageIndex = 0

    local speed = math.clamp(tonumber(_G.Settings.Main["Player Tween Speed"]) or 180, 1, 300)
    local travelHeight = GetTeleportHeight()
    local startPos = hrp.Position
    local targetPos = destination.Position

    -- The chosen height is the clearance ABOVE the destination, not an absolute
    -- world Y. This works consistently in all three seas and for underground maps.
    local travelY = math.max(startPos.Y, targetPos.Y + travelHeight)
    local verticalStart = Vector3.new(startPos.X, travelY, startPos.Z)
    local horizontalTarget = Vector3.new(targetPos.X, travelY, targetPos.Z)

    local function makeCF(position: Vector3)
        return CFrame.lookAt(position, position + flatLook)
    end

    local stages = {}
    local riseDistance = (startPos - verticalStart).Magnitude
    local horizontalDistance = (verticalStart - horizontalTarget).Magnitude
    local descendDistance = (horizontalTarget - targetPos).Magnitude

    -- Always Tween. There is deliberately no direct CFrame movement branch here.
    if riseDistance > 0.5 then
        table.insert(stages, {cf = makeCF(verticalStart), distance = riseDistance})
    end
    if horizontalDistance > 0.5 then
        table.insert(stages, {cf = makeCF(horizontalTarget), distance = horizontalDistance})
    end
    if descendDistance > 0.5 then
        table.insert(stages, {cf = destination, distance = descendDistance})
    end
    if #stages == 0 then
        local nudge = targetPos + Vector3.new(0, 0.15, 0)
        table.insert(stages, {cf = makeCF(nudge), distance = 0.15})
        table.insert(stages, {cf = destination, distance = 0.15})
    end
    activeRoute.stages = stages

    local function routeAlive()
        return routeId == activeTeleportGuardId
            and currentTweenOwner == routeOwner
            and hrp.Parent and hum.Parent and hum.Health > 0
    end

    local function playNext()
        if not routeAlive() then return end
        activeRoute.stageIndex += 1
        local stage = stages[activeRoute.stageIndex]
        if not stage then
            if routeId == activeTeleportGuardId then
                currentTween = nil
                currentTweenOwner = nil
                activeRoute.owner = nil
                activeRoute.destination = nil
                activeRoute.targetKey = nil
                activeRoute.stages = nil
                activeRoute.stageIndex = 0
                pcall(function()
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
            end
            return
        end

        local duration = math.max(0.10, stage.distance / speed)
        if stage.distance <= TELEPORT_CLOSE_DISTANCE then
            duration = math.max(duration, 0.16)
        end

        local tween = TweenService:Create(
            hrp,
            TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
            {CFrame = stage.cf}
        )
        currentTween = tween
        tween.Completed:Connect(function(playbackState)
            if routeId ~= activeTeleportGuardId or currentTween ~= tween then return end
            currentTween = nil
            if playbackState == Enum.PlaybackState.Completed then
                playNext()
            else
                if currentTweenOwner == routeOwner then
                    currentTweenOwner = nil
                    activeRoute.owner = nil
                    activeRoute.destination = nil
                    activeRoute.stages = nil
                    activeRoute.stageIndex = 0
                end
            end
        end)
        tween:Play()
    end

    playNext()
    return currentTween
end

-- Persistent hover controller: moves smoothly above a moving target and keeps
-- the player locked at the configured Farm Distance until the target dies.
local DirectLevelTweenState = {owner=nil, target=nil, destination=nil, tween=nil}

-- Direct tween used by Auto Farm Level.
-- One continuous Tween from the current position to a point above the target.
-- No waypoint staging, no per-frame CFrame correction, and no repeated hover
-- rewrites while the same target is alive.
local function DirectLevelTweenTo(targetCFrame: CFrame, owner: string?): Tween?
    if typeof(targetCFrame) ~= "CFrame" then return nil end
    local _, hrp, hum = GetCharacter()
    if not hrp or not hum or hum.Health <= 0 then return nil end
    if hum.Sit then pcall(function() hum.Sit = false end) end

    local routeOwner = owner or "AutoFarmLevel"
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance <= 3 then
        DirectLevelTweenState.owner = routeOwner
        DirectLevelTweenState.destination = targetCFrame
        return nil
    end

    -- Do not restart the same journey every loop tick.
    if DirectLevelTweenState.owner == routeOwner
        and DirectLevelTweenState.destination
        and (DirectLevelTweenState.destination.Position - targetCFrame.Position).Magnitude < 4
        and currentTween
        and currentTweenOwner == routeOwner then
        return currentTween
    end

    if currentTween then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    end
    activeTeleportGuardId += 1

    local speed = math.clamp(tonumber(_G.Settings.Main["Player Tween Speed"]) or 180, 1, 1000)
    local duration = math.max(0.12, distance / speed)
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        {CFrame = targetCFrame}
    )

    currentTween = tween
    currentTweenOwner = routeOwner
    DirectLevelTweenState.owner = routeOwner
    DirectLevelTweenState.destination = targetCFrame
    DirectLevelTweenState.tween = tween

    tween.Completed:Connect(function()
        if currentTween == tween then
            currentTween = nil
            currentTweenOwner = nil
        end
        if DirectLevelTweenState.tween == tween then
            DirectLevelTweenState.tween = nil
        end
    end)

    tween:Play()
    return tween
end

local SmoothHoldState = {owner=nil, target=nil, lastDestination=nil, lastAt=0}
local function SmoothHoldAt(cf: CFrame, owner: string?, refreshRate: number?)
    if typeof(cf) ~= "CFrame" then return nil end
    local routeOwner = owner or "SmoothHold"
    local now = os.clock()
    local changed = not SmoothHoldState.lastDestination
        or (SmoothHoldState.lastDestination.Position - cf.Position).Magnitude > 5
        or SmoothHoldState.owner ~= routeOwner
        or now - (SmoothHoldState.lastAt or 0) >= (refreshRate or 0.25)
    if changed then
        SmoothHoldState.owner = routeOwner
        SmoothHoldState.lastDestination = cf
        SmoothHoldState.lastAt = now
        return TweenPlayer(cf, nil, routeOwner)
    end
    return currentTween
end

local function TweenIslandAtSafeHeight(cf: CFrame, owner: string?)
    return TweenPlayer(cf, nil, owner or "IslandTeleport")
end

local function StopTween(owner: string?)
    if owner and currentTweenOwner and currentTweenOwner ~= owner and AnyMovementFeatureActive() then
        return
    end
    activeTeleportGuardId += 1
    if currentTween then pcall(function() currentTween:Cancel() end) end
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
-- Update 28 / Submerged Island level route (Max 2800)
local SUBMERGED_MAX_LEVEL = 2800
local SubmergedQuests = {
    {Min=2600, Max=2624, Mob="Reef Bandit", Quest="SubmergedQuest1", Level=1, Giver="Submerged Quest Giver 1"},
    {Min=2625, Max=2649, Mob="Coral Pirate", Quest="SubmergedQuest1", Level=2, Giver="Submerged Quest Giver 1"},
    {Min=2650, Max=2674, Mob="Sea Chanter", Quest="SubmergedQuest2", Level=1, Giver="Submerged Quest Giver 2"},
    {Min=2675, Max=2699, Mob="Ocean Prophet", Quest="SubmergedQuest2", Level=2, Giver="Submerged Quest Giver 2"},
    {Min=2700, Max=2724, Mob="High Disciple", Quest="SubmergedQuest3", Level=1, Giver="Submerged Quest Giver 3"},
    {Min=2725, Max=2800, Mob="Grand Devotee", Quest="SubmergedQuest3", Level=2, Giver="Submerged Quest Giver 3"},
}
local function BFGetLevel()
    local data = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("leaderstats")
    local lv = data and data:FindFirstChild("Level")
    return tonumber(lv and lv.Value) or 0
end
local function BFFindSubmergedEnemy(name)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local best, bestDist = nil, math.huge
    local _, hrp = GetCharacter()
    for _, v in ipairs(enemies:GetChildren()) do
        if v:IsA("Model") and v.Name == name then
            local h = v:FindFirstChildOfClass("Humanoid")
            local r = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
            if h and h.Health > 0 and r then
                local d = hrp and (hrp.Position-r.Position).Magnitude or 0
                if d < bestDist then best, bestDist = v, d end
            end
        end
    end
    return best
end
local function BFFindSubmergedQuest(desired)
    local npc = workspace:FindFirstChild(desired, true)
    if npc and npc:IsA("Model") then return npc end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower() == desired:lower() then return obj end
    end
end
local function BFSubmergedStep()
    local level = BFGetLevel()
    if not World3 or level < 2600 or level >= SUBMERGED_MAX_LEVEL then return false end
    local q
    for _, data in ipairs(SubmergedQuests) do if level >= data.Min and level <= data.Max then q=data break end end
    if not q then return false end
    local char, hrp = GetCharacter()
    if not char or not hrp then return true end
    AutoHaki()
    local mob = BFFindSubmergedEnemy(q.Mob)
    if mob then SmartAttackMob(mob); return true end
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
    local title = questGui and questGui:FindFirstChild("Container") and questGui.Container:FindFirstChild("QuestTitle") and questGui.Container.QuestTitle:FindFirstChild("Title")
    local active = title and title.Text:find(q.Mob, 1, true)
    if not active then
        local giver = BFFindSubmergedQuest(q.Giver)
        local gp = giver and (giver:FindFirstChild("HumanoidRootPart") or giver.PrimaryPart)
        if gp then
            TweenPlayer(gp.CFrame, Vector3.new(0, 5, 0))
            if (hrp.Position-gp.Position).Magnitude <= 25 and CommF_ then pcall(function() CommF_:InvokeServer("StartQuest", q.Quest, q.Level) end) end
        end
    elseif hrp.Position.Y > 0 then
        TweenPlayer(CFrame.new(hrp.Position.X, -18, hrp.Position.Z), nil, "Submerged")
    end
    return true
end

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
            CurrentQuest = {Mon = "Isle Champion", LevelQuest = 2, NameQuest = "TikiQuest3", NameMon = "Isle Champion", CFrameQuest = CFrame.new(-16661.89, 105.28, 1576.69), CFrameMon = CFrame.new(-16885.20, 114.12, 1627.94)}
        elseif MyLevel <= 2574 then
            CurrentQuest = {Mon = "Serpent Hunter", LevelQuest = 2, NameQuest = "TikiQuest3", NameMon = "Serpent Hunter", CFrameQuest = CFrame.new(-16661.89, 105.28, 1576.69), CFrameMon = CFrame.new(-16885.20, 114.12, 1627.94)}
        elseif MyLevel <= 2599 then
            CurrentQuest = {Mon = "Skull Slayer", LevelQuest = 2, NameQuest = "TikiQuest3", NameMon = "Skull Slayer", CFrameQuest = CFrame.new(-16661.89, 105.28, 1576.69), CFrameMon = CFrame.new(-16885.20, 114.12, 1627.94)}
        elseif MyLevel <= 2624 then
            CurrentQuest = {Mon = "Reef Bandit", LevelQuest = 1, NameQuest = "SubmergedQuest1", NameMon = "Reef Bandit", CFrameQuest = CFrame.new(-11034, -201, -9330), CFrameMon = CFrame.new(-10970, -174, -9316)}
        elseif MyLevel <= 2649 then
            CurrentQuest = {Mon = "Coral Pirate", LevelQuest = 2, NameQuest = "SubmergedQuest1", NameMon = "Coral Pirate", CFrameQuest = CFrame.new(-11034, -201, -9330), CFrameMon = CFrame.new(-10757, -207, -9197)}
        elseif MyLevel <= 2674 then
            CurrentQuest = {Mon = "Sea Chanter", LevelQuest = 1, NameQuest = "SubmergedQuest2", NameMon = "Sea Chanter", CFrameQuest = CFrame.new(-10439, -316, -9484), CFrameMon = CFrame.new(-10370, -300, -9498)}
        elseif MyLevel <= 2699 then
            CurrentQuest = {Mon = "Ocean Prophet", LevelQuest = 2, NameQuest = "SubmergedQuest2", NameMon = "Ocean Prophet", CFrameQuest = CFrame.new(-10439, -316, -9484), CFrameMon = CFrame.new(-10200, -300, -9560)}
        elseif MyLevel <= 2724 then
            CurrentQuest = {Mon = "High Disciple", LevelQuest = 1, NameQuest = "SubmergedQuest3", NameMon = "High Disciple", CFrameQuest = CFrame.new(-10420, -405, -10470), CFrameMon = CFrame.new(-10280, -397, -10425)}
        elseif MyLevel <= 2800 then
            CurrentQuest = {Mon = "Grand Devotee", LevelQuest = 2, NameQuest = "SubmergedQuest3", NameMon = "Grand Devotee", CFrameQuest = CFrame.new(-10420, -405, -10470), CFrameMon = CFrame.new(-10075, -390, -10140)}
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

-- Smart cross-island teleport: stage instantly at a nearby island, then tween at the single hub speed.
local TELEPORT_TWEEN_SPEED = 180
local function getCurrentSeaTable()
    if World1 then return FullIslandLocations.Sea1 end
    if World2 then return FullIslandLocations.Sea2 end
    if World3 then return FullIslandLocations.Sea3 end
    return {}
end
local function nearestIslandCF(position, excludeName)
    local bestName, bestCF, bestDist
    for name, cf in pairs(getCurrentSeaTable()) do
        if name ~= excludeName then
            local d=(position-cf.Position).Magnitude
            if not bestDist or d<bestDist then bestName,bestCF,bestDist=name,cf,d end
        end
    end
    return bestName,bestCF,bestDist
end
local PreferredTeleportStages={
    ["Haunted Castle"]="Castle on the Sea",
    ["Cake Land"]="Castle on the Sea",
    ["Tiki Outpost"]="Castle on the Sea",
}
local function SmartTeleportIsland(name, cf, owner)
    if typeof(cf) ~= "CFrame" then return false end
    local _,hrp=GetCharacter(); if not hrp then return false end
    -- Do not stage by placing the character at another island. The global
    -- movement engine now handles the whole cross-island route as one smooth path.
    TweenPlayer(cf, nil, owner or "IslandTeleport")
    return true
end

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
            SmoothHoldAt(CFrame.new(desired), "Material", 10)
            AutoHaki(); SmartAttackMob(target); return
        end
    end
    MaterialState.Target=nil
    if cfg.Entrance and (hrp.Position-cfg.Entrance).Magnitude>1000 then
        TweenPlayer(CFrame.new(cfg.Entrance), nil, "MaterialEntrance")
        return
    end
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
    local boat=GetMyBoatIntegrated()
    if not boat then return end
    local seat=getBoatSeat(boat)
    local _,hrp,hum=GetCharacter()
    if seat and hum and not hum.Sit then
        pcall(function() hrp.CFrame=seat.CFrame*CFrame.new(0,2.5,0); seat:Sit(hum) end)
        return
    end
    if seat then
        local target=CFrame.new(5433,getBoatHeight(),290)
        moveBoatOverSea(boat,target,true)
    end
end

-- Independent controllers; each stops as soon as its own flag becomes false.
task.spawn(function() while task.wait(0.15) do if _G.Settings.Main["Auto Farm Material"] then pcall(integratedMaterialStep) else MaterialState.Target=nil end end end)
task.spawn(function() while task.wait(0.25) do if _G.Settings.SubFarm["Auto Farm Leviathan"] then pcall(integratedLeviathanStep) end end end)
task.spawn(function() while task.wait(0.35) do if _G.Settings.Sea["Auto Find Leviathan"] then pcall(autoFindLeviathanStep) end end end)

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
    SmoothHoldAt(CFrame.new(desired), "Raid", 10)
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
    if (hrp.Position-desired).Magnitude<35 then SmoothHoldAt(CFrame.new(desired), "Raid", 12) end
end)
--------------------------------------------------------------------------------
-- 7. AetherUI Framework Integration (100% Full English Interface)
--------------------------------------------------------------------------------
-- Robust AetherUI bootstrap: tolerate executors that expose different HTTP/load APIs
-- and retry the known working library URL before aborting.
local GENV = (type(getgenv) == "function" and getgenv()) or _G
local AetherUI = rawget(GENV, "AetherUI")
local success_ui, err_ui = true, nil

local function getGlobalFunction(name)
    local ok, fn = pcall(function() return GENV[name] end)
    if ok and type(fn) == "function" then return fn end
    local ok2, fn2 = pcall(function() return _G[name] end)
    if ok2 and type(fn2) == "function" then return fn2 end
    return nil
end

local function compileLuaSource(source)
    if type(source) ~= "string" or #source < 100 then
        return nil, "empty/invalid source"
    end

    -- Repair a couple of malformed endings seen in older AetherUI revisions.
    source = source:gsub("\nI%s*$", "\n")
    source = source:gsub(
        "return%s+AetherUAetherUI%.Executor%s*=%s*detectExecutorName%(%)",
        "AetherUI.Executor = detectExecutorName()"
    )

    local compiler = getGlobalFunction("loadstring")
    if compiler then
        local ok, fnOrErr = pcall(compiler, source)
        if ok and type(fnOrErr) == "function" then
            return fnOrErr
        end
        return nil, tostring(fnOrErr)
    end

    -- Luau environments may expose load instead of loadstring.
    local loader = getGlobalFunction("load")
    if loader then
        local ok, fnOrErr = pcall(loader, source, "AetherUI")
        if ok and type(fnOrErr) == "function" then
            return fnOrErr
        end
        return nil, tostring(fnOrErr)
    end

    return nil, "no supported Lua compiler (loadstring/load) was found"
end

local function isUsableAetherUI(lib)
    return type(lib) == "table"
       and type(lib.CreateWindow) == "function"
       and type(lib.InitLoadingScreen) == "function"
       and type(lib.InitKeySystem) == "function"
end

local function tryLoadAetherUI(url)
    local source = safeHttpGet(url)
    if type(source) ~= "string" or #source < 100 then
        return nil, "HTTP returned empty/invalid source"
    end

    local compiled, compileErr = compileLuaSource(source)
    if not compiled then
        return nil, "compile failed: " .. tostring(compileErr)
    end

    local ok, libOrErr = pcall(compiled)
    if not ok then
        return nil, "library runtime failed: " .. tostring(libOrErr)
    end
    if not isUsableAetherUI(libOrErr) then
        return nil, "library loaded but required API functions are missing"
    end
    return libOrErr
end

if not isUsableAetherUI(AetherUI) then
    success_ui = false
    local configuredUrl = type(GENV.HAROON_AETHERUI_URL) == "string" and GENV.HAROON_AETHERUI_URL or ""
    local candidates = {}

    if configuredUrl ~= "" then
        table.insert(candidates, configuredUrl)
    end

    -- Primary URL used by the hub, followed by the previous AetherUI URL.
    if configuredUrl ~= "https://pastebin.com/raw/EvPTXUiY" then
        table.insert(candidates, "https://pastebin.com/raw/EvPTXUiY")
    end
    if configuredUrl ~= "https://pastebin.com/raw/yeULgMe0" then
        table.insert(candidates, "https://pastebin.com/raw/yeULgMe0")
    end

    local errors = {}
    for _, url in ipairs(candidates) do
        local lib, loadErr = tryLoadAetherUI(url)
        if lib then
            AetherUI = lib
            success_ui = true
            err_ui = nil
            break
        end
        table.insert(errors, url .. " -> " .. tostring(loadErr))
    end

    if not success_ui then
        err_ui = table.concat(errors, " | ")
    end
end

if not success_ui or not isUsableAetherUI(AetherUI) then
    warn("Haroon Hub: AetherUI failed to initialize. " .. tostring(err_ui))
    return
end

pcall(function()
    GENV.AetherUI = AetherUI
    if type(getgenv) == "function" then
        getgenv().AetherUI = AetherUI
    end
end)


-- AetherUI Paragraph Compatibility Patch: V7 uses SetContent, older hubs may expect SetDesc.
local function PatchParagraphObject(paragraph)
    if type(paragraph) ~= "table" then return paragraph end
    if type(paragraph.SetContent) == "function" then
        local setter = paragraph.SetContent
        paragraph.SetDesc = paragraph.SetDesc or setter
        paragraph.SetDescription = paragraph.SetDescription or setter
        paragraph.Update = paragraph.Update or setter
        paragraph.Set = paragraph.Set or setter
        paragraph.SetText = paragraph.SetText or setter
        paragraph.SetStatus = paragraph.SetStatus or function(self, text)
            return self:SetContent(tostring(text or ""))
        end
    end
    return paragraph
end

-- AetherUI compatibility: the published library's Paragraph API uses Content,
-- while Haroon Hub historically passed Desc. Convert Desc/Text to Content
-- before the original paragraph is created.
do
    local originalCreateWindow = AetherUI.CreateWindow
    if type(originalCreateWindow) == "function" and not AetherUI.__HaroonParagraphPatched then
        AetherUI.__HaroonParagraphPatched = true
        function AetherUI:CreateWindow(config)
            local window = originalCreateWindow(self, config)
            if not window or type(window.CreateTab) ~= "function" then return window end
            local originalCreateTab = window.CreateTab
            function window:CreateTab(tabName, iconAssetId)
                local tab = originalCreateTab(self, tabName, iconAssetId)
                if not tab or type(tab.CreateParagraph) ~= "function" then return tab end
                local originalCreateParagraph = tab.CreateParagraph
                function tab:CreateParagraph(config)
                    config = config or {}
                    if config.Content == nil then
                        config.Content = config.Desc or config.Description or config.Text or config.text or "No information available."
                    end
                    local paragraph = originalCreateParagraph(self, config)
                    return PatchParagraphObject(paragraph)
                end
                return tab
            end
            return window
        end
    end
end
AetherUI:InitLoadingScreen("Haroon Hub V22 Master Edition", "Initializing Modules & Auto Engines...", function()
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

        MainTab:CreateToggle("Auto Farm Level", "AutoFarmFlag", _G.Settings.Main["Auto Farm Level"], function(state)
            _G.Settings.Main["Auto Farm Level"] = state
            if not state then StopTween() end
        end)

        MainTab:CreateSection("Update 28 • Submerged Island")
        MainTab:CreateParagraph({Title="Max Level", Desc="2800 (MAX) | Lv. 1 → 2800 complete route | 2525+ Tiki → Submerged | Coral Pirate Lv. 2625 → Grand Devotee Lv. 2725", Image="rbxassetid://6034453535", ImageSize=20})
        MainTab:CreateButton("Smart Teleport: Submerged Island", function()
            local level = BFGetLevel()
            if not World3 or level < 2600 then
                AetherUI:Notify({Title="Submerged Island", Content="Requires Third Sea and Level 2600+.", Duration=3})
                return
            end
            local picked = SubmergedQuests[#SubmergedQuests]
            for _, route in ipairs(SubmergedQuests) do
                if level >= route.Min and level <= route.Max then picked = route break end
            end
            local giver = BFFindSubmergedQuest(picked.Giver)
            local cf = giver and GetModelCFrame(giver)
            if not cf then cf = picked.Giver == "Submerged Quest Giver 1" and CFrame.new(-11034,-201,-9330) or picked.Giver == "Submerged Quest Giver 2" and CFrame.new(-10439,-316,-9484) or CFrame.new(-10420,-405,-10470) end
            SmartTeleportIsland("Submerged Island", cf * CFrame.new(0,-100,0), "SubmergedTP")
            AetherUI:Notify({Title="Submerged Island", Content="Smart route selected for Level "..tostring(level).." → "..picked.Mob..".", Duration=3})
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

        MainTab:CreateSlider("Teleport Travel Height", "TeleportHeightFlag", 10, 300, tonumber(_G.Settings.Main["Teleport Height"]) or 100, function(val)
            _G.Settings.Main["Teleport Height"] = val
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

        MainTab:CreateToggle("Auto Farm Selected Boss", "FarmBossFlag", _G.Settings.Main["Auto Farm Boss"], function(state)
            _G.Settings.Main["Auto Farm Boss"] = state
            if not state then StopTween("BossFarm") end
        end)

        MainTab:CreateToggle("Auto Farm All Available Bosses", "FarmAllBossFlag", _G.Settings.Main["Auto Farm All Boss"], function(state)
            _G.Settings.Main["Auto Farm All Boss"] = state
            if not state then StopTween("BossFarm") end
        end)

        MainTab:CreateToggle("Auto Farm Factory Core", "AutoFarmFactoryFlag", _G.Settings.Main["Auto Farm Factory"], function(state)
            _G.Settings.Main["Auto Farm Factory"] = state
            if not state then StopTween("Factory") end
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
        -- 📌 3. TAB: SHOP & UPGRADES (LIVE STOCK + FIXED PURCHASES)
        ---------------------------------------------------------
        local ShopStockState = {
            Normal = {},
            Mirage = {},
            LastRefresh = 0,
            NormalRaw = nil,
            MirageRaw = nil,
        }

        local function stockValueName(v)
            if type(v) == "table" then
                return tostring(v.Name or v.name or v.DisplayName or v.displayName or v.Fruit or v.FruitName or "?")
            end
            return tostring(v)
        end

        local function normalizeStock(raw)
            local out = {}
            if type(raw) ~= "table" then return out end
            for _, item in pairs(raw) do
                if type(item) == "table" then
                    local name = item.Name or item.name or item.DisplayName or item.displayName or item.Fruit or item.FruitName
                    if name then
                        local price = item.Price or item.price or item.Beli or item.BeliPrice or item.Cost
                        local robux = item.Robux or item.RobuxPrice or item.PremiumPrice
                        local available = item.InStock
                        if available == nil then available = item.Stock end
                        if available == nil then available = item.Available end
                        table.insert(out, {
                            Name = tostring(name),
                            Price = price,
                            Robux = robux,
                            Available = available
                        })
                    elseif #item > 0 then
                        for _, nested in ipairs(item) do
                            local n = stockValueName(nested)
                            if n ~= "?" then table.insert(out, {Name=n}) end
                        end
                    end
                elseif type(item) == "string" then
                    table.insert(out, {Name=item})
                end
            end
            table.sort(out, function(a,b) return a.Name:lower() < b.Name:lower() end)
            return out
        end

        local function findStockBucket(raw, wanted)
            if type(raw) ~= "table" then return raw end
            local aliases = wanted == "Mirage"
                and {"Mirage","mirage","Advanced","AdvancedDealer","MirageStock","AdvancedStock"}
                or {"Normal","normal","Regular","RegularStock","NormalStock","DealerStock"}
            for _, key in ipairs(aliases) do
                if raw[key] ~= nil then return raw[key] end
            end
            return raw
        end

        local function fetchLiveStock()
            if not CommF_ then return false, "CommF_ is unavailable." end

            local ok, raw = pcall(function()
                return CommF_:InvokeServer("GetFruits")
            end)
            if not ok or type(raw) ~= "table" then
                -- Keep a second call for game builds that expose the dealer
                -- inventories separately.
                local ok2, raw2 = pcall(function()
                    return CommF_:InvokeServer("GetFruits", "Normal")
                end)
                if ok2 and type(raw2) == "table" then raw = raw2 else
                    return false, "The game did not return live stock data."
                end
            end

            ShopStockState.NormalRaw = findStockBucket(raw, "Normal")
            ShopStockState.MirageRaw = findStockBucket(raw, "Mirage")
            ShopStockState.Normal = normalizeStock(ShopStockState.NormalRaw)
            ShopStockState.Mirage = normalizeStock(ShopStockState.MirageRaw)

            -- If the server returned one flat list, try the explicit Mirage
            -- query to obtain the second dealer's real inventory.
            if #ShopStockState.Mirage == 0 and World3 then
                local mok, mraw = pcall(function()
                    return CommF_:InvokeServer("GetFruits", "Mirage")
                end)
                if mok and type(mraw) == "table" then
                    ShopStockState.MirageRaw = mraw
                    ShopStockState.Mirage = normalizeStock(findStockBucket(mraw, "Mirage"))
                end
            end

            ShopStockState.LastRefresh = os.clock()
            return true
        end

        local function stockText(list)
            if #list == 0 then return "No live stock data returned by the game." end
            local lines = {}
            for _, item in ipairs(list) do
                local line = "🍎 " .. item.Name
                if item.Price ~= nil then line = line .. " | Beli: " .. tostring(item.Price) end
                if item.Robux ~= nil then line = line .. " | Robux: " .. tostring(item.Robux) end
                if item.Available ~= nil then line = line .. " | " .. tostring(item.Available) end
                table.insert(lines, line)
            end
            return table.concat(lines, "\n")
        end

        ShopTab:CreateSection("🍎 Live Dealer Stock")
        local NormalStockPara = ShopTab:CreateParagraph({
            Title = "Normal Stock",
            Desc = "Press Refresh Stock to read the current dealer inventory from the game.",
            Image = "rbxassetid://6034834832",
            ImageSize = 20
        })
        local MirageStockPara = ShopTab:CreateParagraph({
            Title = "Mirage Stock",
            Desc = "Third Sea / Advanced Dealer stock. Press Refresh Stock.",
            Image = "rbxassetid://6034453535",
            ImageSize = 20
        })
        local StockStatusPara = ShopTab:CreateParagraph({
            Title = "Stock Status",
            Desc = "Not refreshed yet.",
            Image = "rbxassetid://6034287594",
            ImageSize = 20
        })

        local function setShopParagraph(paragraph, text)
            if not paragraph then return end
            text = tostring(text or "")
            pcall(function()
                if type(paragraph.SetContent) == "function" then
                    paragraph:SetContent(text)
                elseif type(paragraph.SetDesc) == "function" then
                    paragraph:SetDesc(text)
                elseif type(paragraph.SetText) == "function" then
                    paragraph:SetText(text)
                end
            end)
        end

        local function updateLiveStock()
            local ok, msg = fetchLiveStock()
            if ok then
                setShopParagraph(NormalStockPara, stockText(ShopStockState.Normal))
                setShopParagraph(MirageStockPara, World3 and stockText(ShopStockState.Mirage) or "Mirage Stock is only available in Third Sea.")
                setShopParagraph(StockStatusPara, "🟢 Live game data | Refreshed: " .. os.date("%H:%M:%S"))
            else
                setShopParagraph(StockStatusPara, "🔴 " .. tostring(msg))
            end
        end

        ShopTab:CreateButton("🔄 Refresh Stock", function()
            updateLiveStock()
        end)

        ShopTab:CreateToggle("Auto Refresh Stock", "AutoRefreshStockFlag", false, function(state)
            _G.Settings.Shop["Stock Auto Refresh"] = state
        end)
        ShopTab:CreateSlider("Stock Refresh Interval", "StockRefreshIntervalFlag", 10, 120, 30, function(value)
            _G.Settings.Shop["Stock Refresh Interval"] = value
        end)

        ShopTab:CreateSection("🌊 Sea Travel")
        local function shopCall(label, ...)
            if not CommF_ then
                if AetherUI then AetherUI:Notify({Title="Shop", Content="CommF_ is unavailable.", Duration=3}) end
                return nil
            end
            local args = {...}
            local ok, result = pcall(function() return CommF_:InvokeServer(unpack(args)) end)
            if not ok then
                if AetherUI then AetherUI:Notify({Title="Shop", Content=label .. " failed.", Duration=3}) end
                return nil
            end
            if AetherUI then
                local text = result == nil and "Request sent." or tostring(result)
                if #text > 100 then text = text:sub(1,100) .. "..." end
                AetherUI:Notify({Title="Shop", Content=label .. ": " .. text, Duration=3})
            end
            return result
        end

        ShopTab:CreateButton("Travel to First Sea", function()
            if not World1 then shopCall("Travel First Sea", "TravelMain") end
        end)
        ShopTab:CreateButton("Travel to Second Sea", function()
            if not World2 then shopCall("Travel Second Sea", "TravelDressrosa") end
        end)
        ShopTab:CreateButton("Travel to Third Sea", function()
            if not World3 then shopCall("Travel Third Sea", "TravelZou") end
        end)

        ShopTab:CreateSection("🛒 General Items")
        ShopTab:CreateButton("Buy Dual Flintlock", function() shopCall("Dual Flintlock", "BuyItem", "Dual Flintlock") end)
        ShopTab:CreateButton("Reroll Race", function()
            shopCall("Race Reroll", "BlackbeardReward", "Reroll", "1")
            task.wait(0.15)
            shopCall("Race Reroll", "BlackbeardReward", "Reroll", "2")
        end)
        ShopTab:CreateButton("Refund Stats", function()
            shopCall("Stats Refund", "BlackbeardReward", "Refund", "1")
            task.wait(0.15)
            shopCall("Stats Refund", "BlackbeardReward", "Refund", "2")
        end)
        ShopTab:CreateButton("Buy Ghoul Race", function()
            shopCall("Ghoul Race", "Ectoplasm", "BuyCheck", 4)
            task.wait(0.15)
            shopCall("Ghoul Race", "Ectoplasm", "Change", 4)
        end)
        ShopTab:CreateButton("Buy Cyborg Race", function() shopCall("Cyborg Race", "CyborgTrainer", "Buy") end)

        ShopTab:CreateSection("🥋 Fighting Styles")
        ShopTab:CreateButton("Buy Black Leg", function() shopCall("Black Leg", "BuyBlackLeg") end)
        ShopTab:CreateButton("Buy Fishman Karate", function() shopCall("Fishman Karate", "BuyFishmanKarate") end)
        ShopTab:CreateButton("Buy Electro", function() shopCall("Electro", "BuyElectro") end)
        ShopTab:CreateButton("Buy Dragon Claw", function()
            shopCall("Dragon Claw", "BlackbeardReward", "DragonClaw", "1")
            task.wait(0.15)
            shopCall("Dragon Claw", "BlackbeardReward", "DragonClaw", "2")
        end)
        ShopTab:CreateButton("Buy Superhuman", function() shopCall("Superhuman", "BuySuperhuman") end)
        ShopTab:CreateButton("Buy Death Step", function() shopCall("Death Step", "BuyDeathStep") end)
        ShopTab:CreateButton("Buy Sharkman Karate", function()
            shopCall("Sharkman Karate", "BuySharkmanKarate", true)
            task.wait(0.15)
            shopCall("Sharkman Karate", "BuySharkmanKarate")
        end)
        ShopTab:CreateButton("Buy Electric Claw", function() shopCall("Electric Claw", "BuyElectricClaw") end)
        ShopTab:CreateButton("Buy Dragon Talon", function() shopCall("Dragon Talon", "BuyDragonTalon") end)
        ShopTab:CreateButton("Buy Godhuman", function() shopCall("Godhuman", "BuyGodhuman", true); task.wait(0.15); shopCall("Godhuman", "BuyGodhuman") end)
        ShopTab:CreateButton("Buy Sanguine Art", function() shopCall("Sanguine Art", "BuySanguineArt", true); task.wait(0.15); shopCall("Sanguine Art", "BuySanguineArt") end)

        ShopTab:CreateSection("🛡️ Haki & Abilities")
        ShopTab:CreateButton("Buy Geppo", function() shopCall("Geppo", "BuyHaki", "Geppo") end)
        ShopTab:CreateButton("Buy Buso Haki", function() shopCall("Buso Haki", "BuyHaki", "Buso") end)
        ShopTab:CreateButton("Buy Soru", function() shopCall("Soru", "BuyHaki", "Soru") end)
        ShopTab:CreateButton("Buy Observation Haki", function() shopCall("Observation Haki", "KenTalk", "Buy") end)

        ShopTab:CreateSection("⚙️ Shop Helpers")
        ShopTab:CreateToggle("Auto Buy Legendary Swords", "AutoBuyLegSwordsFlag", false, function(state)
            _G.Settings.ItemsQuests["Auto Buy Legendary Swords"] = state
        end)

        task.spawn(function()
            task.wait(1)
            pcall(updateLiveStock)
            while task.wait(1) do
                if _G.Settings.Shop["Stock Auto Refresh"] then
                    local interval = math.max(10, tonumber(_G.Settings.Shop["Stock Refresh Interval"]) or 30)
                    if os.clock() - (ShopStockState.LastRefresh or 0) >= interval then
                        pcall(updateLiveStock)
                    end
                end
            end
        end)

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

        SubFarmTab:CreateToggle("Auto Chest (Tween)", "ChestTweenFlag", _G.Settings.SubFarm["Auto Chest Tween"], function(state)
            _G.Settings.SubFarm["Auto Chest Tween"] = state
            if not state then StopTween() end
        end)

        SubFarmTab:CreateToggle("Auto Chest (Instant)", "ChestInstantFlag", _G.Settings.SubFarm["Auto Chest Instant"], function(state)
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
            SmartTeleportIsland("Prehistoric Island", MobSpecificTeleports["Prehistoric Island"], "PrehistoricTP")
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

        SeaTab:CreateSection("Leviathan Hunter")

        SeaTab:CreateToggle("Auto Find Leviathan", "AutoFindLeviathanFlag", false, function(state)
            _G.Settings.Sea["Auto Find Leviathan"] = state
            if not state then StopTween("LeviathanSpy"); StopTween("Leviathan") end
        end)

        SeaTab:CreateToggle("Auto Bribe Spy (4 × 1500 Fragments)", "AutoBribeSpyFlag", true, function(state)
            _G.Settings.Sea["Auto Bribe Spy"] = state
        end)

        SeaTab:CreateDropdown("Leviathan Sea Danger", "LeviathanSeaZoneDropdown", {"Zone 4","Zone 5","Zone 6"}, "Zone 6", function(value)
            _G.Settings.Sea["Leviathan Sea Zone"] = value
        end)

        SeaTab:CreateDropdown("Leviathan Boat", "LeviathanBoatDropdown", {"Beast Hunter","Guardian"}, "Beast Hunter", function(value)
            _G.Settings.Sea["Leviathan Boat"] = value
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

        SeaTab:CreateSlider("Boat Speed", "BoatSpeedSlider", 50, 500, tonumber(_G.Settings.Sea["Boat Tween Speed"]) or 200, function(value)
            _G.Settings.Sea["Boat Tween Speed"] = value
        end)

        SeaTab:CreateSlider("Boat Height", "BoatHeightSlider", 15, 120, tonumber(_G.Settings.Sea["Boat Height"]) or 30, function(value)
            _G.Settings.Sea["Boat Height"] = value
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
        SeaTab:CreateToggle("Auto Collect Azure Embers", "AutoCollectAzureEmberFlag", _G.Settings.Sea["Auto Collect Azure Embers"], function(state)
            _G.Settings.Sea["Auto Collect Azure Embers"] = state
            if not state then StopTween("KitsuneEmber") end
        end)

        SeaTab:CreateButton("Teleport To Kitsune Island", function()
            if World3 then
                local island = GetKitsuneIsland()
                if island then
                    local cf = GetModelCFrame(island)
                    local _, hrp, hum = GetCharacter()
                    if cf and hrp then
                        if hum then pcall(function() hum.Sit=false end) end
                        pcall(function() SmartTeleportIsland("Kitsune Island", cf, "KitsuneTP") end)
                    end
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
                    local _, hrp, hum = GetCharacter()
                    if cf and hrp then
                        if hum then pcall(function() hum.Sit=false end) end
                        pcall(function() SmartTeleportIsland("Mirage Island", cf, "MirageTP") end)
                    end
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
                    if raceDoors[myRace] then
                        TweenPlayer(raceDoors[myRace], nil, "RaceDoor")
                    end
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
        -- Race V4 Runtime Engine V26
        ---------------------------------------------------------
        local function promptText(obj)
            if not obj then return "" end
            if obj:IsA("ProximityPrompt") then return (tostring(obj.ObjectText).." "..tostring(obj.ActionText)):lower() end
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then return tostring(obj.Text):lower() end
            return tostring(obj.Name):lower()
        end
        local function findRaceInteraction(keywords, radius)
            local _, hrp = GetCharacter()
            if not hrp then return nil end
            local best, bestD = nil, radius or 5000
            for _, obj in ipairs(workspace:GetDescendants()) do
                local text = promptText(obj)
                local match = false
                for _, k in ipairs(keywords) do if text:find(k,1,true) then match=true break end end
                if match then
                    local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true))) or (obj.Parent and obj.Parent:IsA("BasePart") and obj.Parent)
                    if part then
                        local d=(hrp.Position-part.Position).Magnitude
                        if d<bestD then best,bestD=obj,d end
                    end
                end
            end
            return best
        end
        local function interactRaceObject(obj)
            if not obj then return false end
            if obj:IsA("ProximityPrompt") and type(fireproximityprompt)=="function" then return pcall(fireproximityprompt,obj) end
            local pp=obj:FindFirstChildWhichIsA("ProximityPrompt",true)
            if pp and type(fireproximityprompt)=="function" then return pcall(fireproximityprompt,pp) end
            if type(fireclickdetector)=="function" then
                local cd=obj:IsA("ClickDetector") and obj or obj:FindFirstChildWhichIsA("ClickDetector",true)
                if cd then return pcall(fireclickdetector,cd) end
            end
            local part=obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)))
            if part then SafeTeleport100(part.CFrame*CFrame.new(0,-100,0), "RaceV4") return true end
            return false
        end
        task.spawn(function()
            while task.wait(0.35) do
                pcall(function()
                    local R=_G.Settings.Race
                    if not World3 then return end
                    if R["Auto Race V3 Ability"] then
                        if CommE then CommE:FireServer("ActivateAbility") end
                    end
                    if R["Auto Trial"] then
                        local obj=findRaceInteraction({"trial of flames","trial","race trial","start trial","trial button"}, 5000)
                        if obj then interactRaceObject(obj) end
                    end
                    if R["Auto Train"] then
                        local obj=findRaceInteraction({"train","training","ancient","gear"}, 5000)
                        if obj then interactRaceObject(obj) end
                    end
                    if R["Auto Collect Flowers"] then
                        for _,obj in ipairs(workspace:GetDescendants()) do
                            local n=tostring(obj.Name):lower()
                            if n:find("flower",1,true) then
                                local cf=GetModelCFrame(obj)
                                if cf then SafeTeleport100(cf*CFrame.new(0,-100,0), "RaceFlower"); interactRaceObject(obj); break end
                            end
                        end
                    end
                end)
            end
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

        ItemsTab:CreateSection("⚔️ TTK Quest Automation")

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

        local function findNamedNPC(names)
            local wanted={}
            for _,n in ipairs(names) do wanted[tostring(n):lower()]=true end
            local preferred={}
            for _,obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") then
                    local n=obj.Name:lower()
                    if wanted[n] then return obj end
                    for key in pairs(wanted) do
                        if n:find(key,1,true) then preferred[#preferred+1]=obj; break end
                    end
                end
            end
            return preferred[1]
        end

        local function interactNPC(obj)
            if not obj then return false end
            local prompt=obj:FindFirstChildWhichIsA("ProximityPrompt",true)
            if prompt and type(fireproximityprompt)=="function" then
                local ok=pcall(fireproximityprompt,prompt)
                if ok then return true end
            end
            local click=obj:FindFirstChildWhichIsA("ClickDetector",true)
            if click and type(fireclickdetector)=="function" then
                local ok=pcall(fireclickdetector,click)
                if ok then return true end
            end
            return false
        end

        local function findFruitGachaNPC()
            return findNamedNPC({"Zioles","Blox Fruit Gacha","Fruit Gacha","Cousin"})
        end

        -- Extracted from the supplied script: the current roll call is
        -- CommF_ -> Cousin -> Buy. We also interact with the local Gacha NPC
        -- first so the UI/interaction state is initialized where required.
        local function rollFruitOnce()
            local npc=findFruitGachaNPC()
            interactNPC(npc)
            local ok,result=false,nil
            if CommF_ then
                ok,result=pcall(function()
                    return CommF_:InvokeServer("Cousin","Buy")
                end)
                if not ok then
                    ok,result=pcall(function()
                        return CommF_:InvokeServer("Cousin","Buy",true)
                    end)
                end
            end
            if AetherUI then
                AetherUI:Notify({
                    Title="Fruit Gacha",
                    Content=ok and ("Roll request sent • "..tostring(result or "Success")) or "Unable to send roll request.",
                    Duration=3
                })
            end
            return ok
        end

        FruitsTab:CreateButton("Roll Fruit Once (Blox Fruit Gacha)", function() rollFruitOnce() end)
        FruitsTab:CreateToggle("Auto Roll Fruit (Loop)", "AutoRollFruitFlag", _G.Settings.Fruits["Auto Roll Fruit"], function(state)
            _G.Settings.Fruits["Auto Roll Fruit"]=state
            local token=os.clock()
            getgenv().HaroonFruitRollToken=token
            if state then
                task.spawn(function()
                    while _G.Settings.Fruits["Auto Roll Fruit"] and getgenv().HaroonFruitRollToken==token do
                        pcall(rollFruitOnce)
                        task.wait(3)
                    end
                end)
            end
        end)

        FruitsTab:CreateSection("🍎 Fruit Notifier / ESP")
        FruitsTab:CreateToggle("Fruit Notifier (ESP)", "FruitESPFlag", false, function(state)
            _G.Settings.Fruits["Fruit ESP"] = state
        end)

        FruitsTab:CreateToggle("Fruit Sniper (Tween to Fruit)", "FruitSniperFlag", false, function(state)
            _G.Settings.Fruits["Fruit Sniper"] = state
            if not state then StopTween() end
        end)

        FruitsTab:CreateToggle("Auto Store Fruit", "AutoStoreFruitFlag", _G.Settings.Fruits["Auto Store Fruit"], function(state)
            _G.Settings.Fruits["Auto Store Fruit"] = state
            task.spawn(function()
                while _G.Settings.Fruits["Auto Store Fruit"] do
                    task.wait(0.5)
                    local backpack=LocalPlayer:FindFirstChild("Backpack")
                    if backpack and CommF_ then
                        for _,tool in ipairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and string.find(tool.Name:lower(),"fruit") then
                                pcall(function() CommF_:InvokeServer("StoreFruit",tool.Name) end)
                            end
                        end
                    end
                end
            end)
        end)

        FruitsTab:CreateToggle("Auto Drop Fruit", "AutoDropFruitFlag", _G.Settings.Fruits["Auto Drop Fruit"], function(state)
            _G.Settings.Fruits["Auto Drop Fruit"] = state
            task.spawn(function()
                while _G.Settings.Fruits["Auto Drop Fruit"] do
                    task.wait(0.5)
                    local backpack=LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        for _,tool in ipairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and string.find(tool.Name:lower(),"fruit") then
                                pcall(function() tool.Parent=workspace end)
                            end
                        end
                    end
                end
            end)
        end)

        local function openShopByNPC(npcNames, shopTitle)
            local npc=findNamedNPC(npcNames)
            local opened=interactNPC(npc)
            if CommF_ then
                -- Common requests used by Blox Fruits shop/dealer interactions.
                for _,args in ipairs({
                    {"GetFruits"},
                    {"GetFruits",true},
                    {"Shop","Open"},
                    {"OpenShop"}
                }) do
                    local ok=pcall(function() CommF_:InvokeServer(table.unpack(args)) end)
                    opened=opened or ok
                end
            end
            if AetherUI then
                AetherUI:Notify({
                    Title=shopTitle,
                    Content=opened and "Shop interaction sent." or "Shop NPC was not found.",
                    Duration=3
                })
            end
            return opened
        end

        FruitsTab:CreateSection("🛒 Fruit Shops")
        FruitsTab:CreateButton("Open Normal Shop", function()
            openShopByNPC({"Blox Fruit Dealer","Fruit Dealer","Fruit Shop"},"Normal Fruit Shop")
        end)
        FruitsTab:CreateButton("Open Mirage Shop", function()
            openShopByNPC({"Advanced Fruit Dealer","Advanced Fruit Dealer (Mirage)","Mirage Fruit Dealer"},"Mirage Fruit Shop")
        end)

        FruitsTab:CreateSection("🥋 Melees Shop")
        local MeleeShopItems={
            "Black Leg","Electro","Fishman Karate","Dragon Claw","Superhuman",
            "Death Step","Electric Claw","Sharkman Karate","Dragon Talon","Godhuman","Sanguine Art"
        }
        for _,styleName in ipairs(MeleeShopItems) do
            FruitsTab:CreateButton("Buy "..styleName, function()
                if CommF_ then
                    local ok=pcall(function() CommF_:InvokeServer("BuyFightingStyle",styleName) end)
                    if not ok then pcall(function() CommF_:InvokeServer("BuyItem",styleName,1) end) end
                end
            end)
        end

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
        CombatTab:CreateSection("🎯 Target Player Selection")

        local playerList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(playerList, p.Name) end
        end

        local PVPPlayerDropdown = CombatTab:CreateDropdown("Select Player Target", "PVPPlayerDropdown", playerList, playerList[1] or "None", function(selected)
            _G.Settings.Combat["Selected Player"] = selected
        end)

        CombatTab:CreateSection("⚔️ Selected Player Combat")

        CombatTab:CreateToggle("Auto Attack Selected Player", "AutoAttackSelectedPlayerFlag", false, function(state)
            _G.Settings.Combat["Auto Attack Selected Player"] = state
            if not state then StopTween("CombatPVP") end
        end)

        CombatTab:CreateSlider("PvP Hover Height", "PvPHoverHeightSlider", 4, 18, 8, function(value)
            _G.Settings.Combat["PvP Hover Height"] = value
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

        CombatTab:CreateSection("🎯 Aim & Position")
        CombatTab:CreateToggle("Aimbot Gun", "AimbotGunFlag", false, function(state)
            _G.Settings.Combat["Aimbot Gun"] = state
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

        CombatTab:CreateButton("Refresh Players List", function()
            local fresh = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then table.insert(fresh, p.Name) end
            end
            table.sort(fresh)
            local defaultName = fresh[1] or "None"
            _G.Settings.Combat["Selected Player"] = defaultName
            if PVPPlayerDropdown and type(PVPPlayerDropdown.SetValues) == "function" then
                pcall(function() PVPPlayerDropdown:SetValues(fresh, defaultName) end)
            elseif PVPPlayerDropdown and type(PVPPlayerDropdown.Set) == "function" then
                pcall(function() PVPPlayerDropdown:Set(defaultName) end)
            elseif AetherUI.Elements and AetherUI.Elements.PVPPlayerDropdown then
                local elem = AetherUI.Elements.PVPPlayerDropdown
                if type(elem.SetValues) == "function" then pcall(function() elem:SetValues(fresh, defaultName) end) end
                if type(elem.Set) == "function" and defaultName ~= "None" then pcall(function() elem:Set(defaultName) end) end
            end
            if AetherUI then
                AetherUI:Notify({Title="Players", Content=(#fresh > 0 and ("Refreshed " .. tostring(#fresh) .. " players.") or "No other players in this server."), Duration=2})
            end
        end)

        -- Live player list synchronization.
        local function refreshPlayerDropdownLive()
            local fresh = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then table.insert(fresh, p.Name) end
            end
            table.sort(fresh)
            if #fresh == 0 then _G.Settings.Combat["Selected Player"] = nil end
            if PVPPlayerDropdown and type(PVPPlayerDropdown.SetValues) == "function" then
                pcall(function() PVPPlayerDropdown:SetValues(fresh, _G.Settings.Combat["Selected Player"]) end)
            end
        end
        Players.PlayerAdded:Connect(function() task.delay(0.25, refreshPlayerDropdownLive) end)
        Players.PlayerRemoving:Connect(function(player)
            if _G.Settings.Combat["Selected Player"] == player.Name then _G.Settings.Combat["Selected Player"] = nil end
            task.delay(0.05, refreshPlayerDropdownLive)
        end)

        CombatTab:CreateSection("🛡️ Combat Assistance")

        CombatTab:CreateSection("🗡️ Nearby Combat")
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
        -- Combat Runtime Engine V30 - stable target/reacquire controller
        ---------------------------------------------------------
        local CombatRuntime = {LastTarget=nil, LastAttack=0, LastReacquire=0}

        local function getSelectedPlayer()
            local name = _G.Settings.Combat["Selected Player"]
            if not name or name == "None" then return nil end
            local p = Players:FindFirstChild(tostring(name))
            if p == LocalPlayer then return nil end
            return p
        end

        local function playerModel(p)
            return p and p.Character or nil
        end

        local function getTargetRoot(model)
            if not model then return nil end
            return model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChild("Head")
        end

        local function getTargetHumanoid(model)
            return model and model:FindFirstChildOfClass("Humanoid")
        end

        local function attackPlayerTarget(model)
            local root = getTargetRoot(model)
            local hum = getTargetHumanoid(model)
            if not root or not hum or hum.Health <= 0 then return false end
            local char, hrp, myHum = GetCharacter()
            if not char or not hrp or not myHum or myHum.Health <= 0 then return false end

            myHum.Sit = false
            AutoHaki()
            local hover = math.clamp(tonumber(_G.Settings.Combat["PvP Hover Height"]) or 8, 4, 25)
            local above = root.Position + Vector3.new(0, hover, 0)
            local distance = (hrp.Position - above).Magnitude

            if distance > (tonumber(_G.Settings.Combat["PvP Attack Range"]) or 35) then
                TweenPlayer(CFrame.lookAt(above, root.Position), nil, "CombatPVP")
                return true
            end

            SmoothHoldAt(CFrame.lookAt(above, root.Position), "CombatPVP", 5)
            pcall(function() myHum.AutoRotate=false end)

            EquipWeapon(_G.Settings.Main["Select Weapon"] or "Melee")
            local tool=char:FindFirstChildOfClass("Tool")
            if tool then pcall(function() tool:Activate() end) end
            AimAtTarget(root.Position)

            local now=os.clock()
            local attackDelay=1/math.max(1, tonumber(_G.Settings.Combat["Attack Speed"]) or 1)
            if now-CombatRuntime.LastAttack >= attackDelay then
                CombatRuntime.LastAttack=now
                FastAttackTarget(model)
            end
            return true
        end

        local function reacquireSelectedPlayer()
            local p=getSelectedPlayer()
            if not p then return nil end
            local model=p.Character
            local hum=getTargetHumanoid(model)
            local root=getTargetRoot(model)
            if not model or not hum or hum.Health<=0 or not root then
                return nil
            end
            CombatRuntime.LastTarget=p
            return p
        end

        task.spawn(function()
            while task.wait(0.08) do
                pcall(function()
                    local C=_G.Settings.Combat
                    local p=getSelectedPlayer()

                    if C["Spectate Player"] and p and p.Character then
                        local ph=p.Character:FindFirstChildOfClass("Humanoid")
                        if ph then workspace.CurrentCamera.CameraSubject=ph end
                    elseif not C["Spectate Player"] then
                        local _,_,h=GetCharacter()
                        if h then workspace.CurrentCamera.CameraSubject=h end
                    end

                    -- Reacquire after respawn/name changes without requiring the user to reselect.
                    if C["Auto Attack Selected Player"] or C["Teleport To Player"] or C["Aimbot Gun"] then
                        if not p or not p.Character or not getTargetHumanoid(p.Character) or getTargetHumanoid(p.Character).Health<=0 then
                            if os.clock()-CombatRuntime.LastReacquire >= (tonumber(C["PvP Reacquire Delay"]) or 0.15) then
                                CombatRuntime.LastReacquire=os.clock()
                                p=reacquireSelectedPlayer()
                            end
                        end
                    end

                    if C["Teleport To Player"] and p and p.Character then
                        local root=getTargetRoot(p.Character)
                        local _,hrp=GetCharacter()
                        if root and hrp then
                            local safe=root.Position+Vector3.new(0,100,0)
                            if (hrp.Position-safe).Magnitude>25 then
                                TweenPlayer(CFrame.lookAt(safe,root.Position),nil,"CombatTP")
                            end
                        end
                    end

                    if p and C["Auto Attack Selected Player"] then
                        attackPlayerTarget(p.Character)
                    elseif C["Aimbot Gun"] and p then
                        local root=getTargetRoot(p.Character)
                        if root then AimAtTarget(root.Position) end
                    end

                    if C["Kill Aura"] then
                        local _,hrp=GetCharacter()
                        local enemies=workspace:FindFirstChild("Enemies")
                        local range=tonumber(C["Kill Aura Range"]) or 25
                        if hrp and enemies then
                            local nearest,bestD=nil,range
                            for _,mob in ipairs(enemies:GetChildren()) do
                                local mh=mob:IsA("Model") and getTargetHumanoid(mob)
                                local mr=mob:IsA("Model") and getTargetRoot(mob)
                                if mh and mh.Health>0 and mr then
                                    local d=(hrp.Position-mr.Position).Magnitude
                                    if d<=bestD then nearest,bestD=mob,d end
                                end
                            end
                            if nearest then SmartAttackMob(nearest) end
                        end
                    end

                    if C["Auto Enable Haki"] then AutoHaki() end

                    if C["Auto PvP Escape"] then
                        local _,myRoot,myHum=GetCharacter()
                        if myRoot and myHum then
                            local hpPercent=(myHum.Health/math.max(myHum.MaxHealth,1))*100
                            if hpPercent <= (tonumber(C["Escape HP %"]) or 30) then
                                CombatRuntime.SafeReturn=CombatRuntime.SafeReturn or myRoot.CFrame
                                pcall(function() TweenPlayer(myRoot.CFrame * CFrame.new(0,100,0), nil, "CombatSafe") end)
                            elseif CombatRuntime.SafeReturn and hpPercent >= (tonumber(C["Return HP %"]) or 70) then
                                pcall(function() myRoot.CFrame=CombatRuntime.SafeReturn end)
                                CombatRuntime.SafeReturn=nil
                            end
                        end
                    else
                        CombatRuntime.SafeReturn=nil
                    end
                end)
            end
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
                    SmartTeleportIsland(islandName, cf, "IslandTeleport")
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
                    SmartTeleportIsland(islandName, cf, "IslandTeleport")
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        TeleportsTab:CreateSection("Submerged Island • Level 2600-2800")
        TeleportsTab:CreateButton("Smart Submerged Route (Level Based)", function()
            local lv=BFGetLevel()
            if not World3 or lv<2600 then AetherUI:Notify({Title="Submerged",Content="Requires Level 2600+ in Third Sea.",Duration=3}); return end
            local chosen=SubmergedQuests[#SubmergedQuests]
            for _,r in ipairs(SubmergedQuests) do if lv>=r.Min and lv<=r.Max then chosen=r break end end
            local giver=BFFindSubmergedQuest(chosen.Giver)
            local cf=giver and GetModelCFrame(giver)
            if cf then SmartTeleportIsland("Submerged Island", cf*CFrame.new(0,-100,0), "SubmergedTP") else SmartTeleportIsland("Submerged Island", chosen.Giver=="Submerged Quest Giver 1" and CFrame.new(-11034,-201,-9330) or chosen.Giver=="Submerged Quest Giver 2" and CFrame.new(-10439,-316,-9484) or CFrame.new(-10420,-405,-10470), "SubmergedTP") end
        end)

        TeleportsTab:CreateSection("Third Sea Islands Teleport")
        for islandName, cf in pairs(FullIslandLocations.Sea3) do
            local key = "TP_" .. islandName
            TeleportsTab:CreateToggle("Teleport to " .. islandName, key, false, function(state)
                _G.Settings.Teleports[key] = state
                if state then
                    SmartTeleportIsland(islandName, cf, "IslandTeleport")
                    task.wait(1)
                    _G.Settings.Teleports[key] = false
                end
            end)
        end

        ---------------------------------------------------------
        -- 📌 14. TAB: VISUALS & ESP
        ---------------------------------------------------------
        VisualTab:CreateSection("Visual Object Detectors")

        VisualTab:CreateSection("👤 Players")
        VisualTab:CreateToggle("ESP Players", "ESPPlayersFlag", false, function(state) _G.Settings.Visuals["ESP Players"] = state end)
        VisualTab:CreateSection("⚔️ World Objects")
        VisualTab:CreateToggle("ESP Bosses", "ESPBossesFlag", false, function(state) _G.Settings.Visuals["ESP Bosses"] = state end)
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

        ----------------------------------------------------------------------
        -- Real server join helpers: join a candidate, verify locally, then hop
        -- again when the requested condition is not present. Cross-server
        -- Roblox public-server listings do not expose Blox Fruits event state.
        ----------------------------------------------------------------------
        local SERVER_PAGE_LIMIT = 100
        local HUB_SCRIPT_URL = HUB_SCRIPT_URL_GLOBAL

        local function moonStage()
            local sky = Lighting:FindFirstChildOfClass("Sky")
            local id = sky and tostring(sky.MoonTextureId or "") or ""
            local stageMap = {
                ["9709149431"] = 100,
                ["9709149052"] = 75,
                ["9709143733"] = 50,
                ["9709150401"] = 25,
                ["9709149680"] = 15,
            }
            local key = id:match("id=(%d+)") or id:match("(%d+)$")
            if key and stageMap[key] then return stageMap[key] end
            local ok, phase = pcall(function() return Lighting:GetMoonPhase() end)
            if ok and type(phase) == "number" then
                return math.floor(math.clamp(phase,0,1)*100 + 0.5)
            end
            return nil
        end

        local function localJoinCondition(mode)
            mode = tostring(mode or "")
            if mode == "Mirage" then return GetMirageIsland() ~= nil end
            if mode == "Kitsune" then return GetKitsuneIsland() ~= nil end
            if mode == "FourHour" then return (tonumber(workspace.DistributedGameTime) or 0) >= 4*60*60 end
            if mode == "FullMoon" then return moonStage() == 100 end
            if mode == "NearFullMoon" then
                local stage = moonStage()
                return stage ~= nil and stage >= 75
            end
            return false
        end

        local function queueResumeMode(mode)
            GEN.HaroonServerJoinMode = mode
            if HUB_SCRIPT_URL ~= "" then
                local code = string.format([[local g=(getgenv and getgenv()) or _G; g.HaroonServerJoinMode=%q; local s=game:HttpGet(%q); local f=loadstring(s); if f then f() end]], mode, HUB_SCRIPT_URL)
                safeQueueOnTeleport(code)
            end
        end

        local function fetchPublicServers()
            local list, seen = {}, {}
            local cursor = nil
            for _ = 1, 5 do
                local url = "https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?sortOrder=Asc&limit="..SERVER_PAGE_LIMIT
                if cursor and cursor ~= "" then url = url .. "&cursor=" .. HttpService:UrlEncode(cursor) end
                local raw = safeHttpGet(url)
                if not raw then
                    local resp = safeRequest({Url=url, Method="GET"})
                    raw = resp and (resp.Body or resp.body)
                end
                if not raw then break end
                local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
                if not ok or type(data) ~= "table" then break end
                for _, server in ipairs(data.data or {}) do
                    local id = tostring(server.id or "")
                    local playing = tonumber(server.playing or 0) or 0
                    local maxPlayers = tonumber(server.maxPlayers or 0) or 0
                    if id ~= "" and id ~= tostring(game.JobId) and playing < maxPlayers and not seen[id] then
                        seen[id] = true
                        table.insert(list, id)
                    end
                end
                cursor = data.nextPageCursor
                if not cursor or cursor == "" then break end
            end
            return list
        end

        local function hopForMode(mode)
            if localJoinCondition(mode) then
                GEN.HaroonServerJoinMode = nil
                if AetherUI then AetherUI:Notify({Title="Server Finder", Content="Condition found in this server.", Duration=3}) end
                return true
            end
            queueResumeMode(mode)
            local servers = fetchPublicServers()
            if #servers == 0 then
                if AetherUI then AetherUI:Notify({Title="Server Finder", Content="No joinable public server returned.", Duration=3}) end
                return false
            end
            local target = servers[math.random(1,#servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, target, LocalPlayer)
            return true
        end
        GEN.HaroonHopForMode = hopForMode

        MiscTab:CreateSection("Real Server Finder")
        local function addServerJoinButton(label, mode, allowed)
            if allowed then
                MiscTab:CreateButton(label, function() hopForMode(mode) end)
            end
        end
        addServerJoinButton("Join 4 Hour Server", "FourHour", World1 or World2 or World3)
        addServerJoinButton("Join Mirage Island Server", "Mirage", World3)
        addServerJoinButton("Join Kitsune Island Server", "Kitsune", World3)
        addServerJoinButton("Join Near Full Moon Server", "NearFullMoon", World3)
        addServerJoinButton("Join Full Moon Server", "FullMoon", World3)

        MiscTab:CreateSection("Live Server & World Status")

        local function UpdateParagraph(paragraph, description)
            if not paragraph then return false end
            local text = tostring(description or "")
            for _, methodName in ipairs({"SetContent","SetDesc","SetDescription","SetStatus","Update","Set","SetText"}) do
                local method = paragraph[methodName]
                if type(method) == "function" then
                    local ok = pcall(function() method(paragraph, text) end)
                    if ok then return true end
                end
            end
            return false
        end

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
        local AzureEmberPara = MiscTab:CreateParagraph({Title="Azure Embers", Desc="0 found | Auto Collect: OFF", Image="rbxassetid://6034453535", ImageSize=20})
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

        local localServerStart = os.clock()
        local function getServerClock()
            local ok, value = pcall(function() return workspace:GetServerTimeNow() end)
            if ok and type(value) == "number" and value > 0 then return value end
            return os.time()
        end

        local function liveServerElapsed()
            local v = workspace.DistributedGameTime
            if type(v) == "number" and v > 0 then return v end
            return math.max(0, os.clock() - localServerStart)
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
                    local serverNow = 0
                    pcall(function() serverNow = workspace:GetServerTimeNow() end)
                    local afkElapsed = os.clock() - lastInputClock
                    UpdateParagraph(SessionTimePara, fmtHMS(sessionElapsed))
                    local serverEpoch = getServerClock()
                    UpdateParagraph(ServerTimePara, "Uptime: " .. fmtHMS(serverElapsed) .. " | Server: " .. os.date("%H:%M:%S", serverEpoch) .. " | UTC: " .. os.date("!%H:%M:%S", serverEpoch))
                    UpdateParagraph(AFKTimePara, "Idle: " .. fmtHMS(afkElapsed) .. (afkElapsed >= 60 and " | AFK" or ""))
                    UpdateParagraph(TimezonePara, "Local: " .. os.date("%H:%M:%S") .. " | UTC: " .. os.date("!%H:%M:%S"))

                    local currentSeaName = World1 and "First Sea" or (World2 and "Second Sea" or (World3 and "Third Sea" or "Unknown"))
                    local islandText = "Unknown"
                    local locations = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Locations")
                    if World3 then
                        local mi = GetMirageIsland(); local ki = GetKitsuneIsland()
                        if mi then islandText = "Mirage Island" elseif ki then islandText = "Kitsune Island" end
                    end
                    UpdateParagraph(SeaIslandPara, "Sea: " .. currentSeaName .. " | Island/Event: " .. islandText)

                    local level = stats and stats:FindFirstChild("Level") and stats.Level.Value or "N/A"
                    local beli = stats and stats:FindFirstChild("Beli") and stats.Beli.Value or "N/A"
                    local frags = stats and stats:FindFirstChild("Fragments") and stats.Fragments.Value or "N/A"
                    UpdateParagraph(StatsPara, "Level: " .. tostring(level) .. " | Beli: " .. tostring(beli) .. " | Fragments: " .. tostring(frags))

                    local pCount = #Players:GetPlayers()
                    UpdateParagraph(ServerInfoPara, "Players: " .. pCount .. "/" .. tostring(Players.MaxPlayers) .. " | Uptime: " .. fmtHMS(serverElapsed) .. " | Job: " .. string.sub(tostring(game.JobId),1,8))

                    local princeResult = "🔴 Not Spawned | Progress: 0/500 | Remaining: 500"
                    pcall(function() princeResult=getCakePrinceProgressIntegrated() end)
                    pcall(function() UpdateParagraph(CakePrincePara, princeResult) end)
                    local doughText="🔴 Not Spawned | Progress: 0/500 | Remaining: 500 | Sweet Chalice: ❌"
                    pcall(function() doughText=getDoughKingStatusText() end)
                    pcall(function() UpdateParagraph(DoughKingPara, doughText) end)

                    local mirage=GetMirageIsland()
                    local kitsune=GetKitsuneIsland()
                    if mirage then notifyEventOnce("Mirage","🌙 Mirage Island") else resetEventNotice("Mirage") end
                    if kitsune then notifyEventOnce("Kitsune","🦊 Kitsune Island") else resetEventNotice("Kitsune") end
                    pcall(function() UpdateParagraph(MiragePara, mirage and "🟢 Spawned" or "🔴 Not Spawned") end)
                    if mirage and not EventNoticeState.Mirage then
                        EventNoticeState.Mirage=true
                        pcall(function() AetherUI:Notify({Title="🌙 Mirage Island",Content="Mirage Island spawned! Teleporting if enabled.",Duration=5}) end)
                    elseif not mirage then
                        EventNoticeState.Mirage=false
                    end
                    pcall(function() UpdateParagraph(KitsunePara, kitsune and "🟢 Spawned" or "🔴 Not Spawned") end)
                    if kitsune and not EventNoticeState.Kitsune then
                        EventNoticeState.Kitsune=true
                        pcall(function() AetherUI:Notify({Title="🦊 Kitsune Island",Content="Kitsune Island spawned! Azure Embers can now be collected.",Duration=5}) end)
                    elseif not kitsune then
                        EventNoticeState.Kitsune=false
                    end
                    local emberCount = 0
                    pcall(function() emberCount = #findAzureEmbers() end)
                    UpdateParagraph(AzureEmberPara, tostring(emberCount) .. " found | Auto Collect: " .. (_G.Settings.Sea["Auto Collect Azure Embers"] and "🟢 ON" or "🔴 OFF"))

                    local counts = {}
                    pcall(function() counts=getSeaEventCounts() or {} end)
                    local active = {}
                    for name, count in pairs(counts) do table.insert(active, name .. " x" .. count) end
                    table.sort(active)
                    UpdateParagraph(SeaEventPara, #active > 0 and table.concat(active, " | ") or "🔴 No active Sea Events")
                    for name, count in pairs(counts) do
                        if count > 0 and name ~= "Mirage Island" and name ~= "Kitsune Island" then
                            if not EventNoticeState.Sea[name] then
                                EventNoticeState.Sea[name] = true
                                pcall(function()
                                    AetherUI:Notify({Title="🌊 Sea Event", Content=tostring(name) .. " spawned (" .. tostring(count) .. ")", Duration=4})
                                end)
                            end
                        else
                            EventNoticeState.Sea[name] = nil
                        end
                    end

                    local ek = "N/A"
                    if stats then
                        for _, v in ipairs(stats:GetChildren()) do
                            if v.Name:lower():find("elite") then ek = tostring(v.Value) break end
                        end
                    end
                    UpdateParagraph(ElitePara, ek)
                    local swords = 0
                    local bp = LocalPlayer:FindFirstChildOfClass("Backpack"); local c = LocalPlayer.Character
                    for _, name in ipairs({"Shisui", "Saddi", "Wando"}) do
                        if (bp and bp:FindFirstChild(name)) or (c and c:FindFirstChild(name)) then swords += 1 end
                    end
                    UpdateParagraph(SwordPara, swords .. " / 3")
                    local fps = math.floor(getgenv().HaroonFPS or 0)
                    local ping = 0
                    pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
                    UpdateParagraph(NetworkPara, "FPS: " .. tostring(fps) .. " | Ping: " .. tostring(ping) .. " ms")
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

        local function joinRandomPublicServer(preferNearFull)
            local ok, target = pcall(function()
                local placeId = game.PlaceId
                local result = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Desc&limit=100"))
                local candidates = {}
                if result and result.data then
                    for _, server in ipairs(result.data) do
                        if server.id ~= tostring(game.JobId) and server.playing < server.maxPlayers then
                            local score = preferNearFull and (server.playing / math.max(server.maxPlayers,1)) or (1 - server.playing / math.max(server.maxPlayers,1))
                            table.insert(candidates, {id=server.id, score=score})
                        end
                    end
                end
                table.sort(candidates, function(a,b) return a.score > b.score end)
                return candidates[1] and candidates[1].id
            end)
            if ok and target then TeleportService:TeleportToPlaceInstance(game.PlaceId, target, LocalPlayer) end
        end

        MiscTab:CreateButton("Join 4 Hour Server", function()
            -- The supplied source does not contain an exact 4-hour server detector; use a public-server hop.
            joinRandomPublicServer(false)
        end)
        MiscTab:CreateButton("Join Mirage Island Server", function() joinRandomPublicServer(true) end)
        MiscTab:CreateButton("Join Kitsune Island Server", function() joinRandomPublicServer(true) end)
        MiscTab:CreateButton("Join Near Full Moon Server", function() joinRandomPublicServer(true) end)
        MiscTab:CreateButton("Join Full Moon Server", function() joinRandomPublicServer(true) end)

        MiscTab:CreateButton("Server Hub • Public Server Hop", function()
            local servers=fetchPublicServers()
            if #servers==0 then
                AetherUI:Notify({Title="Server Hub",Content="No available public servers were returned.",Duration=3})
                return
            end
            local target=servers[math.random(1,#servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId,target,LocalPlayer)
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
        SettingsTab:CreateSection("Movement & Character")

        SettingsTab:CreateSlider("Walk Speed", "SettingsWalkSpeed", 16, 300, _G.Settings.Misc["Walk Speed"], function(value)
            _G.Settings.Misc["Walk Speed"] = value
        end)

        SettingsTab:CreateToggle("Enable Custom Speed", "SettingsCustomSpeed", false, function(state)
            _G.Settings.Misc["Custom Speed"] = state
        end)

        SettingsTab:CreateSlider("Jump Power", "SettingsJumpPower", 50, 300, _G.Settings.Misc["Jump Power"], function(value)
            _G.Settings.Misc["Jump Power"] = value
        end)

        SettingsTab:CreateToggle("Enable Custom Jump", "SettingsCustomJump", false, function(state)
            _G.Settings.Misc["Custom Jump"] = state
        end)

        SettingsTab:CreateToggle("Infinity Jump", "SettingsInfinityJump", false, function(state)
            _G.Settings.Misc["Infinity Jump"] = state
        end)
        SettingsTab:CreateSection("Hub Controls")

        SettingsTab:CreateSection("Server Rejoin / Hop")
        local function rejoinCurrentWorldSameServer()
            -- PlaceId identifies the current Sea/world. JobId identifies the
            -- exact public server, so this never crosses to another Sea.
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end)
        end

        local function rejoinCurrentWorldOtherServer()
            local ok, servers = pcall(fetchPublicServers)
            if not ok or type(servers) ~= "table" or #servers == 0 then
                if AetherUI then AetherUI:Notify({Title="Rejoin", Content="No other public server was found in this world.", Duration=3}) end
                return
            end
            local target = servers[math.random(1, #servers)]
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, target, LocalPlayer)
            end)
        end

        SettingsTab:CreateButton("🔁 Rejoin Same Server (Current Sea)", function()
            rejoinCurrentWorldSameServer()
        end)

        SettingsTab:CreateButton("🌐 Rejoin Another Server (Current Sea)", function()
            rejoinCurrentWorldOtherServer()
        end)

        SettingsTab:CreateButton("Destroy Hub Interface", function()
            local master = game:GetService("CoreGui"):FindFirstChild("HaroonHub_Master") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("HaroonHub_Master")
            if master then master:Destroy() end
        end)
    end)
end)

--------------------------------------------------------------------------------
-- 7B. SETTINGS MOVEMENT ENGINE
--------------------------------------------------------------------------------
local MovementDefaults = {}
local function applyMovementSettings()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if MovementDefaults[hum] == nil then
        MovementDefaults[hum] = {WalkSpeed=hum.WalkSpeed, JumpPower=hum.JumpPower, JumpHeight=hum.JumpHeight, UseJumpPower=hum.UseJumpPower}
    end
    local misc = _G.Settings.Misc
    local defaults = MovementDefaults[hum]
    if misc["Custom Speed"] then
        hum.WalkSpeed = math.clamp(tonumber(misc["Walk Speed"]) or defaults.WalkSpeed or 16, 0, 300)
    else
        hum.WalkSpeed = defaults.WalkSpeed or 16
    end
    if misc["Custom Jump"] then
        hum.UseJumpPower = true
        hum.JumpPower = math.clamp(tonumber(misc["Jump Power"]) or defaults.JumpPower or 50, 0, 300)
    else
        hum.UseJumpPower = defaults.UseJumpPower
        hum.JumpPower = defaults.JumpPower
        hum.JumpHeight = defaults.JumpHeight
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then MovementDefaults[hum] = nil end
    applyMovementSettings()
end)

-- Respawn recovery: event/boss controllers keep their toggles and immediately resume.
LocalPlayer.CharacterAdded:Connect(function(char)
    task.spawn(function()
        local hrp = char:WaitForChild("HumanoidRootPart", 8)
        local hum = char:WaitForChild("Humanoid", 8)
        if not hrp or not hum then return end
        task.wait(0.15)
        pcall(function()
            if _G.Settings.Race["Auto Find Mirage"] or _G.Settings.Race["Teleport To Mirage"] then mirageStep() end
            if _G.Settings.Sea["Auto Find Kitsune Island"] or _G.Settings.Sea["Teleport To Kitsune Island"] then kitsuneStep() end
            if _G.Settings.Sea["Auto Find Leviathan"] then autoFindLeviathanStep() end
        end)
    end)
end)

RunService.Heartbeat:Connect(function() pcall(applyMovementSettings) end)

UserInputService.JumpRequest:Connect(function()
    if not _G.Settings.Misc["Infinity Jump"] then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

--------------------------------------------------------------------------------
-- 8. Main Farming Loop
--------------------------------------------------------------------------------
local LevelFarmState = {
    LastQuestName = nil,
    LastQuestLevel = nil,
    QuestRequestAt = 0,
    Target = nil,
    TargetLastSeen = 0,
    HoverPosition = nil,
    HoverCFrame = nil,
    LastTargetPosition = nil,
    LastRepositionAt = 0,
}


local function GetQuestGuiState()
    local main = LocalPlayer.PlayerGui:FindFirstChild("Main")
    local questGui = main and main:FindFirstChild("Quest")
    if not questGui then return false, "" end
    local container = questGui:FindFirstChild("Container")
    local titleFrame = container and container:FindFirstChild("QuestTitle")
    local title = titleFrame and titleFrame:FindFirstChild("Title")
    return questGui.Visible == true, (title and title.Text) or ""
end

local function HasCurrentLevelQuest()
    local visible, title = GetQuestGuiState()
    return visible and title ~= "" and string.find(title, CurrentQuest.NameMon, 1, true) ~= nil
end

local function StartCurrentLevelQuest(hrp)
    if not CommF_ then return false end
    local qPos = CurrentQuest.CFrameQuest.Position + Vector3.new(0, 5, 0)
    if (hrp.Position - qPos).Magnitude > 22 then
        DirectLevelTweenTo(CurrentQuest.CFrameQuest * CFrame.new(0, 5, 0), "AutoFarmLevelQuest")
        return false
    end

    local now = os.clock()
    if LevelFarmState.LastQuestName ~= CurrentQuest.NameQuest
        or LevelFarmState.LastQuestLevel ~= CurrentQuest.LevelQuest
        or now - LevelFarmState.QuestRequestAt > 2.5 then
        LevelFarmState.LastQuestName = CurrentQuest.NameQuest
        LevelFarmState.LastQuestLevel = CurrentQuest.LevelQuest
        LevelFarmState.QuestRequestAt = now
        pcall(function()
            CommF_:InvokeServer("StartQuest", CurrentQuest.NameQuest, CurrentQuest.LevelQuest)
        end)
    end
    return true
end

local function IsLiveFarmTarget(target)
    if not target or not target.Parent then return false end
    local root = target:FindFirstChild("HumanoidRootPart")
    local hum = target:FindFirstChildOfClass("Humanoid")
    return root ~= nil and hum ~= nil and hum.Health > 0
end

local function FindNextLevelMob(hrp)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local best, bestDistance = nil, math.huge
    for _, mob in ipairs(enemies:GetChildren()) do
        if mob:IsA("Model") and mob.Name == CurrentQuest.Mon then
            local root = mob:FindFirstChild("HumanoidRootPart")
            local hum = mob:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local distance = (hrp.Position - root.Position).Magnitude
                if distance < bestDistance then
                    best, bestDistance = mob, distance
                end
            end
        end
    end
    return best
end

local LEVEL_REPOSITION_THRESHOLD = 30
local LEVEL_REPOSITION_COOLDOWN = 1.25

local function FarmLevelTarget(target, hrp)
    if not IsLiveFarmTarget(target) then return false end
    local root = target:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local height = math.max(10, tonumber(_G.Settings.Main["Farm Distance"]) or 28)
    AutoHaki()

    -- Build the hover point once for this exact target. This is the important
    -- part: we do NOT keep recalculating the player's X/Y/Z every 0.1s.
    if LevelFarmState.Target ~= target or not LevelFarmState.HoverPosition then
        local hover = root.Position + Vector3.new(0, height, 0)
        LevelFarmState.Target = target
        LevelFarmState.HoverPosition = hover
        LevelFarmState.HoverCFrame = CFrame.lookAt(hover, root.Position)
        LevelFarmState.LastTargetPosition = root.Position
        LevelFarmState.LastRepositionAt = os.clock()

        DirectLevelTweenState.owner = nil
        DirectLevelTweenState.destination = nil
        DirectLevelTweenState.tween = nil
        DirectLevelTweenTo(LevelFarmState.HoverCFrame, "AutoFarmLevel")
        return true
    end

    -- While the same mob is alive, stay at the already reached hover point.
    -- Only create another Tween if the mob genuinely moved away from that point.
    -- This removes the old constant up/down/left/right jitter.
    local mobMoved = LevelFarmState.LastTargetPosition
        and (root.Position - LevelFarmState.LastTargetPosition).Magnitude
        or math.huge
    local now = os.clock()
    local tweenRunning = currentTweenOwner == "AutoFarmLevel" and currentTween ~= nil
    local playerNearHover = (hrp.Position - LevelFarmState.HoverPosition).Magnitude <= math.max(7, height * 0.25)

    if not tweenRunning and not playerNearHover and mobMoved >= LEVEL_REPOSITION_THRESHOLD
        and now - LevelFarmState.LastRepositionAt >= LEVEL_REPOSITION_COOLDOWN then
        LevelFarmState.HoverPosition = root.Position + Vector3.new(0, height, 0)
        LevelFarmState.HoverCFrame = CFrame.lookAt(LevelFarmState.HoverPosition, root.Position)
        LevelFarmState.LastTargetPosition = root.Position
        LevelFarmState.LastRepositionAt = now
        DirectLevelTweenTo(LevelFarmState.HoverCFrame, "AutoFarmLevel")
        return true
    end

    if tweenRunning then
        return true
    end

    -- No movement correction here. Just attack from the fixed hover position.
    SmartAttackMob(target)
    return true
end


task.spawn(function()
    while task.wait(0.10) do
        if not _G.Settings.Main["Auto Farm Level"] then
            LevelFarmState.Target = nil
            LevelFarmState.HoverPosition = nil
            LevelFarmState.HoverCFrame = nil
            LevelFarmState.LastTargetPosition = nil
            if currentTweenOwner == "AutoFarmLevel" or currentTweenOwner == "AutoFarmLevelQuest" then
                CancelPlayerTween()
                DirectLevelTweenState.owner = nil
                DirectLevelTweenState.target = nil
                DirectLevelTweenState.destination = nil
                DirectLevelTweenState.tween = nil
            end
            continue
        end

        pcall(function()
            local char, hrp, hum = GetCharacter()
            if not char or not hrp or not hum or hum.Health <= 0 then return end

            if BFSubmergedStep() then
                AutoHaki()
                return
            end

            CheckQuest()
            AutoHaki()

            -- Quest first. Only after the quest is actually active do we lock onto mobs.
            if not HasCurrentLevelQuest() then
                LevelFarmState.Target = nil
                LevelFarmState.HoverPosition = nil
                LevelFarmState.HoverCFrame = nil
                LevelFarmState.LastTargetPosition = nil
                StartCurrentLevelQuest(hrp)
                return
            end

            -- Keep the exact same mob until it dies. This prevents hopping between
            -- nearby enemies and guarantees a clean kill -> next target flow.
            if not IsLiveFarmTarget(LevelFarmState.Target) then
                LevelFarmState.Target = FindNextLevelMob(hrp)
                LevelFarmState.TargetLastSeen = os.clock()
                LevelFarmState.HoverPosition = nil
                LevelFarmState.HoverCFrame = nil
                LevelFarmState.LastTargetPosition = nil
            end

            if IsLiveFarmTarget(LevelFarmState.Target) then
                FarmLevelTarget(LevelFarmState.Target, hrp)
            else
                -- No target spawned yet: move smoothly to the quest mob area and wait.
                DirectLevelTweenTo(CurrentQuest.CFrameMon * CFrame.new(0, math.max(10, tonumber(_G.Settings.Main["Farm Distance"]) or 28), 0), "AutoFarmLevel")
            end
        end)
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
-- 10A. Quest Recovery Guard - Yama / Tushita / CDK / TTK
--------------------------------------------------------------------------------
local QuestRecovery={Last=0}
local function questRecoveryStep()
    if os.clock()-QuestRecovery.Last<0.5 then return end
    QuestRecovery.Last=os.clock()
    if not World3 then return end
    if _G.Settings.Quests["Auto Yama Puzzle"] then pcall(autoYamaPuzzle) end
    if _G.Settings.Quests["Auto Tushita Puzzle"] then pcall(autoTushitaPuzzle) end
    if _G.Settings.ItemsQuests["Auto Farm CDK"] then
        pcall(function()
            if CommF_ then
                local t=_G.Settings.ItemsQuests["CDK Trial Type"]
                if t=="Quest Yama" then CommF_:InvokeServer("CDKQuest","OpenDoor"); CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
                elseif t=="Quest Tushita" then CommF_:InvokeServer("CDKQuest","OpenDoor"); CommF_:InvokeServer("CDKQuest","StartTrial","Good")
                end
            end
        end)
    end
end
task.spawn(function() while task.wait(0.5) do pcall(questRecoveryStep) end end)


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

local function findWorldObjectByNames(names)
    local roots = {
        workspace:FindFirstChild("Map"),
        getLocationsFolder(),
        workspace:FindFirstChild("Locations"),
        workspace:FindFirstChild("_WorldOrigin")
    }
    local wanted = {}
    for _, n in ipairs(names) do wanted[n:lower()] = true end
    for _, root in ipairs(roots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if wanted[obj.Name:lower()] then return obj end
            end
        end
    end
    for _, n in ipairs(names) do
        local direct = workspace:FindFirstChild(n)
        if direct then return direct end
    end
    return nil
end

function GetMirageIsland()
    if not World3 then return nil end
    local locations = getLocationsFolder()
    if locations then
        local direct = locations:FindFirstChild("Mirage Island") or locations:FindFirstChild("MysticIsland") or locations:FindFirstChild("MirageIsland")
        if direct then return direct end
    end
    local map = workspace:FindFirstChild("Map")
    if map then
        local mystic = map:FindFirstChild("MysticIsland") or map:FindFirstChild("Mirage Island") or map:FindFirstChild("MirageIsland")
        if mystic then return mystic end
    end
    return findWorldObjectByNames({"MysticIsland","Mirage Island","MirageIsland"})
end

function GetKitsuneIsland()
    if not World3 then return nil end
    local locations = getLocationsFolder()
    if locations then
        local direct = locations:FindFirstChild("Kitsune Island") or locations:FindFirstChild("KitsuneIsland")
        if direct then return direct end
    end
    local map = workspace:FindFirstChild("Map")
    if map then
        local kit = map:FindFirstChild("KitsuneIsland") or map:FindFirstChild("Kitsune Island")
        if kit then return kit end
    end
    return findWorldObjectByNames({"KitsuneIsland","Kitsune Island"})
end

local function isNightTime()
    local clock = tonumber(Lighting.ClockTime) or 12
    return clock >= 18 or clock <= 6
end

local function isFullMoonLikely()
    local candidates = {Lighting:GetAttribute("MoonPhase"), Lighting:GetAttribute("FullMoon"), workspace:GetAttribute("MoonPhase"), workspace:GetAttribute("FullMoon")}
    for _, value in ipairs(candidates) do
        local text = tostring(value):lower()
        if value == true or text == "full moon" or text == "fullmoon" then return true end
    end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        for _, obj in ipairs(pg:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if tostring(obj.Text or ""):lower():find("full moon", 1, true) then return true end
            end
        end
    end
    return false
end

local function findBlueGear()
    local roots = {workspace:FindFirstChild("Map"), getLocationsFolder(), workspace:FindFirstChild("Locations")}
    for _, rootObj in ipairs(roots) do
        if rootObj then
            for _, name in ipairs({"Blue Gear", "BlueGear", "Gear"}) do
                local found = rootObj:FindFirstChild(name, true)
                if found then return found end
            end
        end
    end
end

local function findAzureEmbers()
    local found, seen = {}, {}
    local roots = {
        workspace:FindFirstChild("Map"),
        getLocationsFolder(),
        workspace:FindFirstChild("Locations"),
        workspace:FindFirstChild("_WorldOrigin"),
        workspace:FindFirstChild("Enemies"),
        workspace
    }
    local function candidate(obj)
        if not obj or seen[obj] then return end
        local name = tostring(obj.Name or ""):lower():gsub("[%s_%-%p]", "")
        local attrs = tostring(obj:GetAttribute("Type") or ""):lower():gsub("[%s_%-%p]", "")
        local isEmber = (name:find("azureember",1,true) ~= nil)
            or (name:find("azure",1,true) and name:find("ember",1,true))
            or (attrs:find("azureember",1,true) ~= nil)
        if isEmber and GetModelCFrame and GetModelCFrame(obj) then
            seen[obj] = true
            table.insert(found,obj)
        end
    end
    for _, rootObj in ipairs(roots) do
        if rootObj then
            for _, obj in ipairs(rootObj:GetDescendants()) do candidate(obj) end
        end
    end
    return found
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

local function findBoatDealer()
    local keys={"boat dealer","luxury boat dealer","dealer"}
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local n=obj.Name:lower()
            for _,k in ipairs(keys) do
                if n==k or n:find(k,1,true) then return obj end
            end
        end
    end
end
local function mountMyBoat(boat)
    local _,hrp,hum=GetCharacter()
    local seat=getBoatSeat(boat)
    if not hrp or not hum or not seat then return false end
    pcall(function() hrp.CFrame=seat.CFrame*CFrame.new(0,2.5,0) end)
    task.wait(0.08)
    pcall(function() seat:Sit(hum) end)
    return true
end
local function ensureBoat()
    local boat = GetMyBoatIntegrated()
    if boat then mountMyBoat(boat); return boat end
    local _, hrp = GetCharacter()
    if CommF_ then
        local dealer=findBoatDealer()
        local dealerCF=dealer and GetModelCFrame(dealer)
        if dealerCF and hrp and (hrp.Position-dealerCF.Position).Magnitude>90 then
            TweenPlayer(dealerCF*CFrame.new(0,4,0),nil,"BoatBuy")
            task.wait(0.15)
        elseif not dealerCF and World3 and hrp and (hrp.Position-CFrame.new(-16927.451,14,433.864).Position).Magnitude>90 then
            TweenPlayer(CFrame.new(-16927.451,14,433.864),nil,"BoatBuy")
            task.wait(0.15)
        end
        pcall(function() CommF_:InvokeServer("BuyBoat", _G.Settings.Sea["Selected Boat"] or "Guardian") end)
    end
    for _=1,25 do
        boat=GetMyBoatIntegrated()
        if boat then mountMyBoat(boat); return boat end
        task.wait(0.12)
    end
    return nil
end

local LeviathanRuntime = {Bribes=0, LastBribe=0, LastBoat=0, LastMove=0}

local function findLeviathanSpy()
    local roots = {workspace:FindFirstChild("Map"), getLocationsFolder(), workspace}
    for _, root in ipairs(roots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Model") then
                    local n=tostring(obj.Name):lower()
                    if n=="spy" or n:find("leviathan spy",1,true) then return obj end
                end
            end
        end
    end
    return nil
end

local function playerHasFragments(amount)
    local data=LocalPlayer:FindFirstChild("Data")
    local f=data and data:FindFirstChild("Fragments")
    return tonumber(f and f.Value) and tonumber(f.Value) >= amount or false
end

local function readLeviathanClue()
    local pg=LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return "" end
    local hits={}
    for _,obj in ipairs(pg:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local t=tostring(obj.Text or "")
            if #t>0 then table.insert(hits,t:lower()) end
        end
    end
    return table.concat(hits," ")
end

local function interactSpyBribe(spy)
    if not spy then return false end
    local part=GetModelCFrame(spy)
    if part then
        local _,hrp=GetCharacter()
        if hrp and (hrp.Position-part.Position).Magnitude>25 then
            TweenPlayer(part*CFrame.new(0,3,0),nil,"LeviathanSpy")
            task.wait(0.25)
        end
    end
    local prompt=spy:FindFirstChildWhichIsA("ProximityPrompt",true)
    if prompt and type(fireproximityprompt)=="function" then pcall(fireproximityprompt,prompt,1,true); task.wait(0.25) end
    if CommF_ then
        -- Try the known dialog-style variants; failed variants are ignored.
        for _,args in ipairs({{"Spy","Clues"},{"Spy","Bribe"},{"Spy","Bribe",true},{"Spy","Clues","Bribe"}}) do
            pcall(function() CommF_:InvokeServer(table.unpack(args)) end)
            task.wait(0.15)
        end
    end
    local clue=readLeviathanClue()
    return clue:find("leviathan is out there",1,true) ~= nil or clue:find("bribe",1,true) ~= nil
end

local function getLeviathanBribeStage()
    if not CommF_ then return 0 end
    local ok, value = pcall(function() return CommF_:InvokeServer("InfoLeviathan", "1") end)
    local n = tonumber(value)
    return n or 0
end

local function ensureLeviathanBribed()
    if not World3 then return false end
    if not _G.Settings.Sea["Auto Bribe Spy"] then return true end

    -- Do not start sailing until the Spy has actually confirmed Leviathan.
    local clue=readLeviathanClue()
    if clue:find("leviathan is out there",1,true) then return true end

    local stage=getLeviathanBribeStage()
    if stage>=5 then return true end
    local spy=findLeviathanSpy()
    if not spy then return false end

    for attempt=1,6 do
        clue=readLeviathanClue()
        if clue:find("leviathan is out there",1,true) then return true end
        stage=getLeviathanBribeStage()
        if stage>=5 then return true end
        if not playerHasFragments(1500) then return false end
        local spyCF=GetModelCFrame(spy)
        local _,hrp=GetCharacter()
        if spyCF and hrp and (hrp.Position-spyCF.Position).Magnitude>25 then
            TweenPlayer(spyCF*CFrame.new(0,3,0),nil,"LeviathanSpy")
            task.wait(0.25)
        end
        local prompt=spy:FindFirstChildWhichIsA("ProximityPrompt",true)
        if prompt and type(fireproximityprompt)=="function" then pcall(function() fireproximityprompt(prompt,1,true) end) end
        if CommF_ then
            pcall(function() CommF_:InvokeServer("Spy","Bribe") end)
            pcall(function() CommF_:InvokeServer("Spy","Clues") end)
        end
        LeviathanRuntime.LastBribe=os.clock()
        task.wait(0.65)
        clue=readLeviathanClue()
        if clue:find("leviathan is out there",1,true) then return true end
        -- The official flow can impose a short interaction delay; don't hammer the NPC.
        task.wait(1.0)
    end
    return readLeviathanClue():find("leviathan is out there",1,true) ~= nil or getLeviathanBribeStage()>=5
end

local function findLeviathanBoat()
    local boats=workspace:FindFirstChild("Boats")
    if not boats then return nil end
    local fallback=nil
    for _,boat in ipairs(boats:GetChildren()) do
        if boat:IsA("Model") and boat:FindFirstChildWhichIsA("VehicleSeat",true) then
            local owner=getBoatOwnerName(boat)
            if owner and (owner==LocalPlayer.Name or owner==tostring(LocalPlayer.UserId)) then
                local n=boat.Name:lower()
                if n:find("beast hunter",1,true) or n:find("beasthunter",1,true) or n:find("hydra",1,true) or n:find("leviathan",1,true) then return boat end
                fallback=fallback or boat
            end
        end
    end
    return fallback
end

local function ensureLeviathanBoat()
    local boat=findLeviathanBoat()
    if boat then mountMyBoat(boat); return boat end
    local old=_G.Settings.Sea["Selected Boat"]
    _G.Settings.Sea["Selected Boat"]=_G.Settings.Sea["Leviathan Boat"] or "Beast Hunter"
    boat=ensureBoat()
    _G.Settings.Sea["Selected Boat"]=old
    return boat
end

local function findFrozenDimensionOrLeviathan()
    local roots={workspace:FindFirstChild("Map"),getLocationsFolder(),workspace:FindFirstChild("_WorldOrigin"),workspace}
    local keys={"frozen dimension","frozendimension","leviathan gate","leviathan","frost gate"}
    for _,root in ipairs(roots) do
        if root then
            for _,obj in ipairs(root:GetDescendants()) do
                local n=tostring(obj.Name):lower():gsub("[%s_%-%p]","")
                for _,k in ipairs(keys) do
                    local kk=k:gsub("[%s_%-%p]","")
                    if n:find(kk,1,true) then
                        local cf=GetModelCFrame(obj)
                        if cf then return obj,cf end
                    end
                end
            end
        end
    end
    return nil
end

autoFindLeviathanStep = function()
    if not World3 or not _G.Settings.Sea["Auto Find Leviathan"] then return false end
    -- Requirement: bribe/confirmation first. No boat search before this succeeds.
    if not ensureLeviathanBribed() then return false end

    local boat=ensureLeviathanBoat()
    if not boat then return false end
    local _,hrp,hum=GetCharacter()
    if not hrp or not hum then return false end

    local target,cf=findFrozenDimensionOrLeviathan()
    if target and cf then
        -- Found the Frozen Dimension/gate: drive directly to it.
        moveBoatOverSea(boat,cf,true)
        local watcher=target:FindFirstChild("Frozen Watcher",true) or target:FindFirstChild("FrozenWatcher",true)
        if watcher and GetModelCFrame(watcher) and (hrp.Position-GetModelCFrame(watcher).Position).Magnitude<80 then
            local prompt=watcher:FindFirstChildWhichIsA("ProximityPrompt",true)
            if prompt and type(fireproximityprompt)=="function" then pcall(function() fireproximityprompt(prompt,1,true) end) end
        end
        return true
    end

    -- Frozen Dimension is tied to Sea Danger Level 6; sweep a deterministic set of waypoints instead of oscillating.
    local zone=ZoneCFrames[_G.Settings.Sea["Leviathan Sea Zone"] or "Zone 6"] or ZoneCFrames["Zone 6"]
    if os.clock()-LeviathanRuntime.LastMove>1.0 then
        LeviathanRuntime.LastMove=os.clock()
        moveBoatOverSea(boat,zone,true)
    end
    return true
end


local MirageSearchRoute = {
    CFrame.new(-26780, 31, -823),
    CFrame.new(-31172, 31, -2257),
    CFrame.new(-34055, 31, -2560),
    CFrame.new(-38888, 31, -2163),
    CFrame.new(-44542, 31, -1245),
}
local KitsuneHoldingPoint = ZoneCFrames["Zone 5"] or CFrame.new(-38888, 31, -2163)
local KitsuneDanger6Point = ZoneCFrames["Zone 6"] or CFrame.new(-44542, 31, -1245)
local MirageRouteIndex = 1
local MirageLastMove = 0
local KitsuneLastMove = 0

function getBoatHeight()
    return math.clamp(tonumber(_G.Settings.Sea["Boat Height"]) or 30, 15, 120)
end

function moveBoatOverSea(boat, targetCF, precise)
    if not boat or not boat.Parent or typeof(targetCF) ~= "CFrame" then return false end
    local seat = getBoatSeat(boat)
    if not seat then return false end
    local _, hrp, hum = GetCharacter()
    if not hrp or not hum then return false end
    if not hum.Sit then
        pcall(function()
            hrp.CFrame = seat.CFrame * CFrame.new(0,2.5,0)
            seat:Sit(hum)
        end)
        return false
    end
    local current = boat:GetPivot()
    local targetPos = Vector3.new(targetCF.Position.X, getBoatHeight(), targetCF.Position.Z)
    local distance = (current.Position - targetPos).Magnitude
    local threshold = precise and 45 or 80
    if distance <= threshold then return true end
    if boat:GetAttribute("HaroonBoatMoving") then return false end
    local speed = math.clamp(tonumber(_G.Settings.Sea["Boat Tween Speed"]) or 200, 50, 500)
    local stepDistance = math.min(distance, math.max(300, speed * 2.0))
    local dir = targetPos - current.Position
    if dir.Magnitude < 1 then return true end
    local waypoint = current.Position + dir.Unit * stepDistance
    waypoint = Vector3.new(waypoint.X, getBoatHeight(), waypoint.Z)
    local look = Vector3.new(targetPos.X, getBoatHeight(), targetPos.Z)
    local goal = CFrame.lookAt(waypoint, look)
    local duration = math.clamp(stepDistance / speed, 0.25, 2.2)
    boat:SetAttribute("HaroonBoatMoving", true)
    local cv = Instance.new("CFrameValue")
    cv.Value = current
    local conn = cv:GetPropertyChangedSignal("Value"):Connect(function()
        if boat and boat.Parent then pcall(function() boat:PivotTo(cv.Value) end) end
    end)
    local ok = pcall(function()
        local tween = TweenService:Create(cv, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Value = goal})
        tween.Completed:Connect(function()
            if conn then conn:Disconnect() end
            if cv then cv:Destroy() end
            if boat and boat.Parent then boat:SetAttribute("HaroonBoatMoving", nil) end
        end)
        tween:Play()
    end)
    if not ok then
        if conn then conn:Disconnect() end
        cv:Destroy()
        boat:SetAttribute("HaroonBoatMoving", nil)
    end
    return false
end

local function moveBoatSmart(boat, targetCF)
    return moveBoatOverSea(boat, targetCF, false)
end

local function teleportToDetectedIsland(island, owner)
    local cf = GetModelCFrame(island)
    if cf then TweenPlayer(cf, Vector3.new(0, 85, 0), owner); return true end
    return false
end

local function forceTeleportToIsland(island, owner)
    local cf = GetModelCFrame(island)
    if not cf then return false end
    local _, _, hum = GetCharacter()
    if hum then pcall(function() hum.Sit = false end) end
    TweenPlayer(cf, nil, owner or "IslandTP")
    return true
end

local function collectNearestAzureEmber()
    local embers = findAzureEmbers()
    local _, hrp, hum = GetCharacter()
    if not hrp or not hum or hum.Health <= 0 then return false end
    local best, bestD, bestCF
    for _, ember in ipairs(embers) do
        local cf = GetModelCFrame(ember)
        if cf then
            local d = (hrp.Position-cf.Position).Magnitude
            if not bestD or d < bestD then best,bestD,bestCF = ember,d,cf end
        end
    end
    if not bestCF then return false end
    hum.Sit = false
    TweenPlayer(bestCF * CFrame.new(0,4,0), nil, "AzureEmber")
    local part = best:IsA("BasePart") and best or best:FindFirstChildWhichIsA("BasePart", true)
    if part and type(firetouchinterest) == "function" then
        pcall(function() firetouchinterest(hrp, part, 0); firetouchinterest(hrp, part, 1) end)
    end
    return true
end

local function mirageStep()
    if not World3 then return end
    local island = GetMirageIsland()
    if island then
        MirageRouteIndex = 1
        if _G.Settings.Race["Teleport To Mirage"] then
            forceTeleportToIsland(island, "MirageTP")
        end
        if _G.Settings.Race["Tween To Highest Mirage"] or _G.Settings.Race["Auto Find Mirage"] then
            local gear = findBlueGear()
            if gear then
                local gcf = GetModelCFrame(gear)
                if gcf then
                    local _, hrp, hum = GetCharacter()
                    if hum then pcall(function() hum.Sit=false end) end
                    if hrp then TweenPlayer(gcf*CFrame.new(0,6,0), nil, "MirageGear") end
                end
            elseif isNightTime() and (_G.Settings.Race["Look Moon Ability"] or _G.Settings.Race["Auto Find Mirage"]) then
                local top = GetModelCFrame(island)
                if top then
                    local _, hrp, hum = GetCharacter()
                    if hum then pcall(function() hum.Sit=false end) end
                    if hrp then TweenPlayer(top*CFrame.new(0,110,0), nil, "MirageTop") end
                end
            end
        end
        return
    end
    if not _G.Settings.Race["Auto Find Mirage"] then return end
    local boat = ensureBoat()
    if not boat then return end
    local _, _, hum = GetCharacter()
    local seat = getBoatSeat(boat)
    if not seat or not hum then return end
    if not hum.Sit then
        mountMyBoat(boat)
        return
    end
    if os.clock()-MirageLastMove < 0.75 then return end
    MirageLastMove = os.clock()
    local route = MirageSearchRoute[MirageRouteIndex]
    if route and moveBoatSmart(boat, route) then
        MirageRouteIndex = MirageRouteIndex % #MirageSearchRoute + 1
    end
end

local function kitsuneStep()
    if not World3 then return end
    local island = GetKitsuneIsland()
    if island then
        if _G.Settings.Sea["Teleport To Kitsune Island"] then
            forceTeleportToIsland(island, "KitsuneTP")
        end
        if _G.Settings.Sea["Auto Collect Azure Embers"] then
            collectNearestAzureEmber()
        elseif _G.Settings.Sea["Auto Find Kitsune Island"] then
            collectNearestAzureEmber()
        end
        return
    end
    if not _G.Settings.Sea["Auto Find Kitsune Island"] then return end
    local boat = ensureBoat()
    if not boat then return end
    local _, _, hum = GetCharacter()
    if not hum then return end
    if not hum.Sit then mountMyBoat(boat); return end
    if os.clock()-KitsuneLastMove < 0.75 then return end
    KitsuneLastMove = os.clock()
    local target = isFullMoonLikely() and KitsuneDanger6Point or KitsuneHoldingPoint
    moveBoatSmart(boat, target)
end

local EventNoticeState={Mirage=false,Kitsune=false,Sea={}}
local function notifyEventOnce(kind, title)
    if EventNoticeState[kind] then return end
    EventNoticeState[kind]=true
    if AetherUI then AetherUI:Notify({Title=title,Content="Event spawned successfully!",Duration=5}) end
end
local function resetEventNotice(kind) EventNoticeState[kind]=false end
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

local SeaTargetAliasesV22 = {
    Shark={"Shark"},
    Piranha={"Piranha"},
    FishCrew={"Fish Crew Member","FishCrewMember"},
    GhostShip={"Ghost Ship","FishBoat"},
    Terrorshark={"Terrorshark"},
    SeaBeast={"Sea Beast","SeaBeast1","Sea Beast 1"},
}
local function findSeaCombatTargetV22()
    local S=_G.Settings.Sea
    local names={}
    local function add(enabled, key) if enabled then for _,n in ipairs(SeaTargetAliasesV22[key]) do names[n]=true end end end
    add(S["Auto Farm Shark"],"Shark"); add(S["Auto Farm Piranha"],"Piranha")
    add(S["Auto Farm Fish Crew Member"],"FishCrew"); add(S["Auto Farm Ghost Ship"],"GhostShip")
    add(S["Auto Farm Terrorshark"],"Terrorshark"); add(S["Auto Farm Seabeasts"],"SeaBeast")
    if next(names)==nil then return nil end
    local containers={workspace:FindFirstChild("Enemies"),workspace:FindFirstChild("SeaBeasts"),workspace:FindFirstChild("Map")}
    local _,hrp=GetCharacter(); local best,bestD=nil,math.huge
    for _,container in ipairs(containers) do
        if container then
            for _,obj in ipairs(container:GetDescendants()) do
                if obj:IsA("Model") and names[obj.Name] then
                    local h=obj:FindFirstChildOfClass("Humanoid"); local r=obj:FindFirstChild("HumanoidRootPart") or anyPart(obj)
                    if h and h.Health>0 and r then
                        local d=hrp and (hrp.Position-r.Position).Magnitude or 0
                        if d<bestD then best,bestD=obj,d end
                    end
                end
            end
        end
    end
    return best
end
local function attackSeaTargetV22(target)
    if not target then return false end
    local r=target:FindFirstChild("HumanoidRootPart") or anyPart(target); local h=target:FindFirstChildOfClass("Humanoid")
    if not r or not h or h.Health<=0 then return false end
    AutoHaki()
    local _,hrp,hum=GetCharacter(); if not hrp or not hum then return false end
    if hum.Sit then hum.Sit=false end
    local above=r.Position+Vector3.new(0,math.max(25,tonumber(_G.Settings.Main["Farm Distance"]) or 28),0)
    SmoothHoldAt(CFrame.lookAt(above,r.Position), "SeaCombat", 10)
    SmartAttackMob(target)
    return true
end
local function integratedSeaStepV22()
    if not World3 then return end
    local char,hrp,hum=GetCharacter()
    if not char or not hrp or not hum or hum.Health<=0 then return end

    local target=findSeaCombatTargetV22()
    if target and _G.Settings.Sea["Auto Attack Sea Events"] then
        attackSeaTargetV22(target)
        return
    end

    -- Keep searching the sea when the event has not spawned yet.
    if _G.Settings.Sea["Auto Attack Sea Events"] then
        local boat=ensureBoat()
        if boat then
            local seat=getBoatSeat(boat)
            if seat and not hum.Sit then
                pcall(function() hrp.CFrame=seat.CFrame*CFrame.new(0,2.5,0) end)
                return
            elseif seat then
                local zone=ZoneCFrames[_G.Settings.Sea["Selected Zone"]] or ZoneCFrames["Zone 5"]
                moveBoatOverSea(boat,zone,false)
            end
        end
    end

    if _G.Settings.Race["Auto Find Mirage"] or _G.Settings.Race["Teleport To Mirage"] then
        mirageStep()
    end
    if _G.Settings.Sea["Auto Find Kitsune Island"] or _G.Settings.Sea["Teleport To Kitsune Island"] then
        kitsuneStep()
    end

    if _G.Settings.Sea["Auto Farm Seabeasts"] then
        local beasts=workspace:FindFirstChild("SeaBeasts")
        if beasts then
            for _,sb in ipairs(beasts:GetChildren()) do
                local sh=sb:FindFirstChildOfClass("Humanoid")
                local sr=sb:FindFirstChild("HumanoidRootPart") or anyPart(sb)
                if sh and sh.Health>0 and sr then
                    attackSeaTargetV22(sb)
                    return
                end
            end
        end
    end

    if _G.Settings.Sea["Sail Boat"] then
        local boat=ensureBoat()
        local seat=getBoatSeat(boat)
        if boat and seat then
            if not hum.Sit then
                pcall(function() hrp.CFrame=seat.CFrame*CFrame.new(0,2.5,0) end)
            else
                local targetZone=ZoneCFrames[_G.Settings.Sea["Selected Zone"]] or ZoneCFrames["Zone 5"]
                moveBoatOverSea(boat,targetZone,false)
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.25) do
        pcall(integratedSeaStepV22)
    end
end)
task.spawn(function()
    while task.wait(0.18) do
        if _G.Settings.Sea["Auto Collect Azure Embers"] then
            pcall(function()
                if GetKitsuneIsland() then
                    collectNearestAzureEmber()
                end
            end)
        end
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

local function getPlayerLevelText(player)
    if not player then return "Lv.?" end
    local data = player:FindFirstChild("Data")
    local level = data and data:FindFirstChild("Level")
    if level and tonumber(level.Value) then
        return "Lv." .. tostring(level.Value)
    end
    local leaderstats = player:FindFirstChild("leaderstats")
    level = leaderstats and leaderstats:FindFirstChild("Level")
    if level and tonumber(level.Value) then
        return "Lv." .. tostring(level.Value)
    end
    local attrLevel = player:GetAttribute("Level")
    if tonumber(attrLevel) then return "Lv." .. tostring(attrLevel) end
    return "Lv.?"
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
    -- Do not mutate Visuals settings from the legacy Fruits toggles. Read them
    -- as aliases only, so disabling one ESP actually removes its drawings.
    local playersESP = S["ESP Players"] or _G.Settings.Fruits["Player ESP"]
    local chestsESP = S["ESP Chests"] or _G.Settings.Fruits["Chest ESP"]

    if playersESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local part = getEspPart(p.Character)
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                if part then
                    local key = "P:" .. p.UserId
                    seen[key] = true
                    EnsureESP(key, part, "👤 " .. tostring(p.DisplayName or p.Name) .. "  [" .. getPlayerLevelText(p) .. "]", Color3.fromRGB(255,90,90), true, h and h.MaxHealth or 100, h and h.Health or 0)
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

    if _G.Settings.Fruits["Fruit ESP"] then
        -- Fruit Notifier: scan known world containers first, then fallback to Workspace.
        local fruitNameHints={
            "rocket","spin","blade","bomb","smoke","flame","ice","sand","dark","light","rubber",
            "barrier","ghost","magma","quake","buddha","love","spider","sound","phoenix","portal",
            "rumble","pain","blizzard","gravity","mammoth","trex","dough","shadow","venom","control",
            "spirit","dragon","leopard","yeti","kitsune","gas","diamond","falcon","eagle","spring",
            "chop","revive","t-rex","tiger","lightning"
        }
        local roots={workspace:FindFirstChild("Fruit"),workspace:FindFirstChild("Fruits"),workspace:FindFirstChild("Map"),workspace:FindFirstChild("_WorldOrigin")}
        local seenObj={}
        local function inspectFruit(obj)
            if not obj or seenObj[obj] then return end
            seenObj[obj]=true
            if not (obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")) then return end
            local n=tostring(obj.Name):lower()
            local attr=(tostring(obj:GetAttribute("Fruit") or "").." "..tostring(obj:GetAttribute("FruitName") or "").." "..tostring(obj:GetAttribute("ItemType") or "")):lower()
            local looks= n:find("fruit",1,true) or attr:find("fruit",1,true)
            if not looks then
                for _,hint in ipairs(fruitNameHints) do
                    if n==hint or n:find(hint.." fruit",1,true) or n:find("blox fruit",1,true) then looks=true; break end
                end
            end
            if not looks then return end
            local part=getEspPart(obj)
            if not part then return end
            local key="F:"..obj:GetDebugId()
            seen[key]=true
            EnsureESP(key,part,"🍎 "..tostring(obj.Name),Color3.fromRGB(255,180,40),false)
        end
        for _,root in ipairs(roots) do
            if root then
                inspectFruit(root)
                for _,obj in ipairs(root:GetDescendants()) do inspectFruit(obj) end
            end
        end
        -- Fallback catches server implementations that place dropped fruits directly in Workspace.
        for _,obj in ipairs(workspace:GetChildren()) do inspectFruit(obj) end
    end

    if chestsESP then
        local seenChest = {}
        local roots = {
            workspace:FindFirstChild("ChestModels"),
            workspace:FindFirstChild("Map"),
            workspace:FindFirstChild("_WorldOrigin"),
            workspace
        }
        for _, root in ipairs(roots) do
            if root then
                for _, chest in ipairs(root:GetDescendants()) do
                    local isChest = chest:IsA("Model") and chest.Name:lower():find("chest",1,true)
                    if isChest and not seenChest[chest] then
                        seenChest[chest] = true
                        local part = getEspPart(chest)
                        if part then
                            local key = "C:" .. chest:GetDebugId()
                            seen[key] = true
                            EnsureESP(key, part, "📦 " .. chest.Name, Color3.fromRGB(255,255,80), false)
                        end
                    end
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

    if not (playersESP or S["ESP Enemies"] or S["ESP Bosses"] or _G.Settings.Fruits["Fruit ESP"] or chestsESP or S["ESP Mirage Island"] or S["ESP Kitsune Island"]) then
        RemoveAllESP()
    end
end

task.spawn(function()
    while task.wait(0.25) do pcall(espTick) end
end)

-- Robust Fruit Notifier / Mirage / Leviathan recovery watcher.
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.Settings.Fruits["Fruit ESP"] then espTick() end
            if _G.Settings.Race["Auto Find Mirage"] or _G.Settings.Race["Teleport To Mirage"] then mirageStep() end
            if _G.Settings.Sea["Auto Find Leviathan"] then autoFindLeviathanStep() end
        end)
    end
end)


--------------------------------------------------------------------------------
-- Factory Core Auto Farm
--------------------------------------------------------------------------------
local FactoryState = {Target=nil, LastHop=0}
local FactoryCorePosition = CFrame.new(448.46756, 199.35678, -441.38925)

local function findFactoryCore()
    local enemies = workspace:FindFirstChild("Enemies")
    local roots = {enemies, workspace:FindFirstChild("Map"), workspace:FindFirstChild("_WorldOrigin")}
    for _, root in ipairs(roots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Model") and obj.Name == "Core" then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    local part = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
                    if part and (not hum or hum.Health > 0) then return obj, part, hum end
                end
            end
        end
    end
    return nil
end

local function factoryStep()
    if not _G.Settings.Main["Auto Farm Factory"] or not World2 then return end
    local _, hrp, hum = GetCharacter()
    if not hrp or not hum or hum.Health <= 0 then return end
    local core, root, coreHum = findFactoryCore()
    if core and root then
        pcall(function() hum.Sit=false end)
        local desired = root.Position + Vector3.new(0, 28, 0)
        SmoothHoldAt(CFrame.lookAt(desired, root.Position), "Factory", 10)
        AutoHaki()
        SmartAttackMob(core, "Melee")
        FactoryState.Target = core
        return
    end
    FactoryState.Target = nil
    if os.clock() - FactoryState.LastHop > 0.75 then
        FactoryState.LastHop = os.clock()
        local target = CFrame.new(632.69, 73.10, 918.66)
        if (hrp.Position-target.Position).Magnitude > 80 then
            TweenPlayer(target, Vector3.new(0,10,0), "Factory")
        else
            -- Move into the core area and wait for the raid to open.
            TweenPlayer(FactoryCorePosition, nil, "Factory")
        end
    end
end

task.spawn(function()
    while task.wait(0.12) do
        pcall(factoryStep)
    end
end)

--------------------------------------------------------------------------------
-- 16. Advanced Boss / Chest / Cake / Dough Engine v3
--------------------------------------------------------------------------------
local BossFarmState={Target=nil,retryAt=0,lastNotice=0}
local ChestFarmState={Target=nil,visited={},emptySince=0,lastPosition=nil}
local function anyPart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then return obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("RootPart") or obj:FindFirstChildWhichIsA("BasePart",true) end
end
local function bossLocation(name)
    return MobSpecificTeleports and MobSpecificTeleports[name]
end
local function normalizeBossName(name)
    return tostring(name or ""):lower():gsub("%s*%[lv%.%s*%d+%]%s*", ""):gsub("%s*%[raid boss%]%s*", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function findBossTarget()
    local enemies=workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local wanted=normalizeBossName(_G.Settings.Main["Selected Boss"])
    local all=_G.Settings.Main["Auto Farm All Boss"]
    local _,hrp=GetCharacter()
    local best,dist=nil,math.huge
    for _,m in ipairs(enemies:GetChildren()) do
        if m:IsA("Model") then
            local match = all or normalizeBossName(m.Name) == wanted or m.Name:find(_G.Settings.Main["Selected Boss"],1,true)
            if match then
                local h=m:FindFirstChildOfClass("Humanoid"); local r=anyPart(m)
                if h and h.Health>0 and r then
                    local d=hrp and (hrp.Position-r.Position).Magnitude or 0
                    if d<dist then best,dist=m,d end
                end
            end
        end
    end
    return best
end

local BossLocationsV22 = {
    ["The Gorilla King"] = CFrame.new(-1129.88, 40.46, -525.42),
    ["Bobby"] = CFrame.new(-1140.08, 14.80, 4322.92),
    ["The Saw"] = CFrame.new(-1610.51, 27.98, 137.12),
    ["Vice Admiral"] = CFrame.new(-5079.45, 98.77, 4267.19),
    ["Magma Admiral"] = CFrame.new(-5530.13, 88.04, -1302.08),
    ["Diamond"] = CFrame.new(-1563.79, 40.58, -114.83),
    ["Jeremy"] = CFrame.new(-790, 306, 1156),
    ["Fajita"] = CFrame.new(-2172, 103, -401),
    ["Don Swan"] = CFrame.new(2288.80, 15.20, 905.65),
    ["Smoke Admiral"] = CFrame.new(-5128, 88, -5625),
    ["Awakened Ice Admiral"] = CFrame.new(6408, 378, -5279),
    ["Tide Keeper"] = CFrame.new(-3570, 123, -11555),
    ["Cursed Captain"] = CFrame.new(916, 181, 33440),
    ["Order"] = CFrame.new(-6215, 28, -506),
    ["Stone"] = CFrame.new(-1029, 103, 698),
    ["Hydra Leader"] = CFrame.new(5150, 602, 373),
    ["Kilo Admiral"] = CFrame.new(2870, 423, -720),
    ["Captain Elephant"] = CFrame.new(-13494, 569, -819),
    ["Cake Queen"] = CFrame.new(-821, 65, -10970),
    ["Longma"] = CFrame.new(-10262, 333, -8260),
    ["Soul Reaper"] = CFrame.new(-9523, 315, 6651),
    ["Dough King"] = CFrame.new(-2155, 149, -12404),
    ["Katakuri"] = CFrame.new(-2144, 150, -12405),
    ["Island Boy"] = CFrame.new(-16901, 84, -192),
    ["Isle Champion"] = CFrame.new(-16661, 105, 1576),
    ["Grand Devotee"] = CFrame.new(-10075, -390, -10140),
    ["High Disciple"] = CFrame.new(-10280, -397, -10425),
}
local function findBossSpawn(name)
    local wanted=normalizeBossName(name)
    local origin=workspace:FindFirstChild("_WorldOrigin")
    local spawns=origin and origin:FindFirstChild("EnemySpawns")
    if not spawns then return nil end
    for _,p in ipairs(spawns:GetChildren()) do
        local n=normalizeBossName(p.Name)
        if n==wanted or n:find(wanted,1,true) or wanted:find(n,1,true) then
            if p:IsA("BasePart") then return p end
        end
    end
end

local function bossFarmStepV5()
    local active=_G.Settings.Main["Auto Farm Boss"] or _G.Settings.Main["Auto Farm All Boss"]
    if not active then BossFarmState.Target=nil; return end
    local _,hrp,hum=GetCharacter()
    if not hrp or not hum or hum.Health<=0 then return end
    hum.Sit=false

    local target=BossFarmState.Target
    local th=target and target:FindFirstChildOfClass("Humanoid")
    local tr=target and anyPart(target)
    if not target or not target.Parent or not th or th.Health<=0 or not tr then
        target=findBossTarget()
        BossFarmState.Target=target
        tr=target and anyPart(target)
    end

    if target and tr then
        AutoHaki()
        local height=math.max(25,tonumber(_G.Settings.Main["Farm Distance"]) or 28)
        local above=tr.Position+Vector3.new(0,height,0)
        local distance=(hrp.Position-above).Magnitude
        if distance > 450 then
            SmoothHoldAt(CFrame.lookAt(above,tr.Position), "DoughCocoa", 8)
        else
            if distance > 10 then
                TweenPlayer(CFrame.lookAt(above,tr.Position),nil,"BossFarm")
            end
            if (hrp.Position-above).Magnitude <= 18 then
                SmoothHoldAt(CFrame.lookAt(above,tr.Position), "DoughCocoa", 8)
            end
        end
        SmartAttackMob(target)
        return
    end

    local wanted=_G.Settings.Main["Selected Boss"]
    local spawnPart=findBossSpawn(wanted)
    local cf=(spawnPart and spawnPart.CFrame) or BossLocationsV22[wanted] or bossLocation(wanted)
    if cf and os.clock()-BossFarmState.retryAt>=0.5 then
        BossFarmState.retryAt=os.clock()
        SmoothHoldAt(cf*CFrame.new(0,25,0), "Dough500", 8)
    end
end

task.spawn(function()
    while task.wait(0.12) do pcall(bossFarmStepV5) end
end)

local ChestFarmState = ChestFarmState or {Target=nil, visited={}, lastScan=0}

local function currentWorldId()
    if World1 then return 1 end
    if World2 then return 2 end
    if World3 then return 3 end
    return 0
end

local ChestScanCache = {Items = {}, At = 0}

local function chestModelsV5()
    -- Blox Fruits streams only the active world's map into Workspace. We still
    -- scan descendants so Gold/Diamond/Silver/Blue variants are not missed.
    if os.clock() - (ChestScanCache.At or 0) < 0.8 then
        return ChestScanCache.Items
    end
    local out, seen = {}, {}
    local roots = {
        workspace:FindFirstChild("ChestModels"),
        workspace:FindFirstChild("Map"),
        workspace:FindFirstChild("_WorldOrigin"),
        workspace
    }
    for _, root in ipairs(roots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Model") and not seen[obj] then
                    local n = obj.Name:lower()
                    if (n:find("chest",1,true) or n == "chest") and anyPart(obj) then
                        seen[obj] = true
                        table.insert(out, obj)
                    end
                elseif obj:IsA("BasePart") then
                    local n = obj.Name:lower()
                    if n:find("chest",1,true) and not seen[obj] then
                        seen[obj] = true
                        table.insert(out, obj)
                    end
                end
            end
        end
    end
    ChestScanCache.Items = out
    ChestScanCache.At = os.clock()
    return out
end

local function chestFarmStepV5()
    local active = _G.Settings.SubFarm["Auto Chest Tween"] or _G.Settings.SubFarm["Auto Chest Instant"]
    if not active then
        ChestFarmState.Target = nil
        return
    end

    local _, hrp = GetCharacter()
    if not hrp then return end

    local target = ChestFarmState.Target
    local function valid(c)
        return c and c.Parent and anyPart(c) and not ChestFarmState.visited[c:GetDebugId()]
    end

    if not valid(target) then
        target = nil
        local best, dist = nil, math.huge
        for _, c in ipairs(chestModelsV5()) do
            local k = c:GetDebugId()
            local part = anyPart(c)
            if part and not ChestFarmState.visited[k] then
                local d = (hrp.Position - part.Position).Magnitude
                if d < dist then
                    best, dist = c, d
                end
            end
        end
        target = best
        ChestFarmState.Target = target
    end

    if not target then
        if next(ChestFarmState.visited) then
            ChestFarmState.visited = {}
        end
        return
    end

    local part = anyPart(target)
    if not part then
        ChestFarmState.Target = nil
        return
    end

    -- Always farm from above the chest. Never Tween into the floor and never
    -- instantly snap downward after reaching it.
    local hover = part.Position + Vector3.new(0, 8, 0)
    local dist = (hrp.Position - hover).Magnitude

    -- "Instant" is intentionally no longer used: every chest move uses the
    -- same smooth Tween route and the selected Teleport Travel Height.
    if dist > 5 then
        TweenPlayer(CFrame.lookAt(hover, part.Position), nil, "ChestFarm")
        return
    end

    if dist <= 12 then
        ChestFarmState.visited[target:GetDebugId()] = true
        ChestFarmState.Target = nil
        -- Give the chest a small amount of time to disappear/respawn before
        -- selecting another target.
        task.delay(0.08, function()
            if not (_G.Settings.SubFarm["Auto Chest Tween"] or _G.Settings.SubFarm["Auto Chest Instant"]) then
                return
            end
        end)
    end
end

task.spawn(function()
    while task.wait(0.15) do
        pcall(chestFarmStepV5)
    end
end)


-- Highest priority for spawned Cake Prince / Dough King; ordered Dough King controller.
local DoughController = {Stage="NeedGodsChalice", LastAction=0, LastNotice=0}
local DoughCakeLandPosition = CFrame.new(-2077, 252, -12373)
local DoughChocolatePosition = CFrame.new(231.75, 23.90, -12200.29)
local DoughCorePosition = CFrame.new(-2155, 149, -12404)

local function findItemAnywhere(name)
    local lower = tostring(name):lower()
    local containers = {LocalPlayer:FindFirstChildOfClass("Backpack"), LocalPlayer.Character, workspace}
    for _, root in ipairs(containers) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if (obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")) and obj.Name:lower() == lower then
                    return obj
                end
            end
        end
    end
    return nil
end

local function getDoughRequirementState()
    local gods = integratedItem("God's Chalice") ~= nil or findItemAnywhere("God's Chalice") ~= nil
    local sweet = integratedItem("Sweet Chalice") ~= nil or findItemAnywhere("Sweet Chalice") ~= nil
    local cocoa = integratedMaterialCount("Conjured Cocoa")
    local _, remaining, spawned = integratedCakeProgress()
    return gods, sweet, cocoa, remaining, spawned
end

local DoughFallbackChestKey = nil
local function collectChestForDoughFallback()
    -- Reuse the world chest scanner when no Elite is available. Every move is
    -- performed through TweenPlayer; there is no instant chest teleport.
    local _, hrp = GetCharacter()
    if not hrp then return false end

    local best, bestDistance = nil, math.huge
    for _, chest in ipairs(chestModelsV5()) do
        local part = anyPart(chest)
        if part then
            local key = tostring(chest:GetDebugId())
            local d = (hrp.Position - part.Position).Magnitude
            -- Avoid repeatedly selecting a chest that has already been reached.
            if key ~= DoughFallbackChestKey and d < bestDistance then
                best, bestDistance = chest, d
            end
        end
    end
    if not best then
        DoughFallbackChestKey = nil
        return false
    end

    local part = anyPart(best)
    if not part then return false end
    local hover = part.Position + Vector3.new(0, 8, 0)
    local distance = (hrp.Position - hover).Magnitude
    SmoothHoldAt(CFrame.lookAt(hover, part.Position), "DoughChestFallback", 0.35)

    if distance <= 12 then
        DoughFallbackChestKey = tostring(best:GetDebugId())
    end
    return true
end

local function farmEliteForGodsChalice()
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
    local hasQuest = false
    if questGui and questGui.Visible then
        local title = questGui.Container.QuestTitle.Title.Text
        hasQuest = title:find("Diablo",1,true) or title:find("Urban",1,true) or title:find("Deandre",1,true)
    end
    if not hasQuest and CommF_ then
        pcall(function() CommF_:InvokeServer("EliteHunter") end)
    end
    for _, eliteName in ipairs({"Diablo","Urban","Deandre"}) do
        local enemy = workspace:FindFirstChild("Enemies") and workspace.Enemies:FindFirstChild(eliteName)
        if not enemy then enemy = ReplicatedStorage:FindFirstChild(eliteName) end
        if enemy and enemy:IsA("Model") then
            local root = enemy:FindFirstChild("HumanoidRootPart") or enemy.PrimaryPart
            local eh = enemy:FindFirstChildOfClass("Humanoid")
            if root and eh and eh.Health > 0 then
                AutoHaki()
                local height = math.max(10, tonumber(_G.Settings.Main["Farm Distance"]) or 28)
                SmoothHoldAt(CFrame.lookAt(root.Position + Vector3.new(0,height,0), root.Position), "DoughKingGods", 0.25)
                SmartAttackMob(enemy, "Melee")
                return true
            end
        end
    end
    return collectChestForDoughFallback()
end

local function doughKingOrderedStep()
    if not _G.Settings.Cake["Auto Kill Dough King"] or not World3 then return end
    local _, hrp, hum = GetCharacter()
    if not hrp or not hum or hum.Health <= 0 then return end

    local gods, sweet, cocoa, remaining, spawned = getDoughRequirementState()
    local boss = workspace:FindFirstChild("Enemies") and workspace.Enemies:FindFirstChild("Dough King")
    if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChildOfClass("Humanoid") and boss.Humanoid.Health > 0 then
        DoughController.Stage = "Kill"
        AutoHaki()
        local root = boss.HumanoidRootPart
        local desired = root.Position + Vector3.new(0, 30, 0)
        SmoothHoldAt(CFrame.lookAt(desired,root.Position), "DoughKing", 0.20)
        SmartAttackMob(boss, "Melee")
        return
    end

    -- Stage 1: God's Chalice first.
    if not gods then
        DoughController.Stage = "NeedGodsChalice"
        if findItemAnywhere("God's Chalice") then
            return
        end
        if not farmEliteForGodsChalice() then
            -- Search visible chests/drops before starting another elite cycle.
            local found = findItemAnywhere("God's Chalice")
            if found and GetModelCFrame(found) then
                TweenPlayer(GetModelCFrame(found), Vector3.new(0,4,0), "DoughGods")
            end
        end
        return
    end

    -- Stage 2: Conjured Cocoa only after God's Chalice is secured.
    if not sweet and cocoa < 10 then
        DoughController.Stage = "NeedCocoa"
        local mob = integratedFindEnemy({"Cocoa Warrior","Chocolate Bar Battler"}, hrp.Position, 1800)
        if mob then
            AutoHaki()
            local height = math.max(10, tonumber(_G.Settings.Main["Farm Distance"]) or 28)
            SmoothHoldAt(CFrame.lookAt(mob.HumanoidRootPart.Position + Vector3.new(0,height,0), mob.HumanoidRootPart.Position), "DoughCocoa", 0.20)
            SmartAttackMob(mob, "Melee")
        else
            TweenPlayer(DoughChocolatePosition, Vector3.new(0,25,0), "DoughCocoa")
        end
        return
    end

    -- Stage 3: trade both items for Sweet Chalice.
    if not sweet then
        DoughController.Stage = "CraftSweetChalice"
        local crafter = findWorldObjectByNames({"Sweet Crafter","SweetCrafter"})
        local cf = crafter and GetModelCFrame(crafter)
        if cf then TweenPlayer(cf, Vector3.new(0,4,0), "DoughCrafter") end
        if CommF_ and (not cf or (hrp.Position-cf.Position).Magnitude <= 25) then
            pcall(function() CommF_:InvokeServer("SweetChaliceNpc") end)
        end
        return
    end

    -- Stage 4: 500 Cake Land kills.
    if not spawned and (remaining or 500) > 0 then
        DoughController.Stage = "Need500CakeLand"
        local mob = integratedFindEnemy({"Cookie Crafter","Cake Guard"}, hrp.Position, 2200)
        if mob then
            AutoHaki()
            local height = math.max(10, tonumber(_G.Settings.Main["Farm Distance"]) or 28)
            SmoothHoldAt(CFrame.lookAt(mob.HumanoidRootPart.Position + Vector3.new(0,height,0), mob.HumanoidRootPart.Position), "Dough500", 0.20)
            SmartAttackMob(mob, "Melee")
        else
            TweenPlayer(DoughCakeLandPosition, nil, "Dough500")
            -- Query the progress endpoint without forcing a premature summon.
            pcall(function() CommF_:InvokeServer("CakePrinceSpawner") end)
        end
        return
    end

    -- Stage 5: summon only once the 500 requirement is actually met.
    DoughController.Stage = "Summon"
    if CommF_ and os.clock()-DoughController.LastAction > 1.0 then
        DoughController.LastAction=os.clock()
        local mama=findWorldObjectByNames({"drip_mama","Drip Mama","Jeffery"})
        local cf=mama and GetModelCFrame(mama)
        if cf then TweenPlayer(cf,Vector3.new(0,4,0),"DoughSummon") end
        if not cf or (hrp.Position-cf.Position).Magnitude <= 25 then
            -- Only the player holding Sweet Chalice should interact with drip_mama.
            pcall(function() CommF_:InvokeServer("CakePrinceSpawner",true) end)
        end
    end
end

task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            if _G.Settings.Cake["Auto Kill Cake Prince"] then
                integratedCakeStep()
                pcall(integratedSummonCake)
            end
            if _G.Settings.Cake["Auto Spawn Cake Prince"] then
                pcall(integratedSummonCake)
            end
            doughKingOrderedStep()
        end)
    end
end)


-- Resume a requested server search after queue_on_teleport/reload.
task.spawn(function()
    task.wait(2.0)
    local mode = GEN.HaroonServerJoinMode
    if mode then
        local function condition()
            if mode == "Mirage" then return GetMirageIsland() ~= nil end
            if mode == "Kitsune" then return GetKitsuneIsland() ~= nil end
            if mode == "FourHour" then return (tonumber(workspace.DistributedGameTime) or 0) >= 14400 end
            if mode == "FullMoon" or mode == "NearFullMoon" then
                local sky=Lighting:FindFirstChildOfClass("Sky"); local id=sky and tostring(sky.MoonTextureId or "") or ""
                local stage=({["9709149431"]=100,["9709149052"]=75,["9709143733"]=50,["9709150401"]=25,["9709149680"]=15})[id:match("(%d+)$") or ""]
                if mode=="FullMoon" then return stage==100 end
                return stage and stage>=75 or false
            end
            return false
        end
        if condition() then
            GEN.HaroonServerJoinMode=nil
            if AetherUI then pcall(function() AetherUI:Notify({Title="Server Finder",Content="Target server condition found.",Duration=4}) end) end
        elseif HUB_SCRIPT_URL_GLOBAL ~= "" then
            task.wait(1)
            local f=GEN.HaroonHopForMode; if type(f)=="function" then f(mode) end
        end
    end
end)

-- Sea Events fallback combat engine V26: supports sea models that do not expose a Humanoid.
local function findSeaTargetFallback()
    local S=_G.Settings.Sea
    local wanted={}
    local function add(flag,names) if S[flag] then for _,n in ipairs(names) do wanted[n:lower()]=true end end end
    add("Auto Farm Shark",{"Shark"}); add("Auto Farm Piranha",{"Piranha"}); add("Auto Farm Fish Crew Member",{"Fish Crew Member","FishCrewMember"})
    add("Auto Farm Ghost Ship",{"Ghost Ship","FishBoat"}); add("Auto Farm Terrorshark",{"Terrorshark"}); add("Auto Farm Seabeasts",{"Sea Beast","SeaBeast1","Sea Beast 1"})
    if next(wanted)==nil then return nil end
    local _,hrp=GetCharacter(); if not hrp then return nil end
    local best,bestD=nil,math.huge
    for _,root in ipairs({workspace:FindFirstChild("Enemies"),workspace:FindFirstChild("SeaBeasts"),workspace:FindFirstChild("Map")}) do
        if root then
            for _,obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Model") and wanted[obj.Name:lower()] then
                    local part=obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)
                    if part then
                        local d=(hrp.Position-part.Position).Magnitude
                        if d<bestD then best,bestD=obj,d end
                    end
                end
            end
        end
    end
    return best
end

local function attackSeaFallback(target)
    if not target then return false end
    local part=target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart",true)
    if not part then return false end
    local _,hrp,hum=GetCharacter(); if not hrp or not hum then return false end
    hum.Sit=false
    local above=part.Position+Vector3.new(0,math.max(25,tonumber(_G.Settings.Main["Farm Distance"]) or 28),0)
    if (hrp.Position-above).Magnitude>18 then
        TweenPlayer(CFrame.lookAt(above,part.Position),nil,"SeaCombatV26")
    else
        SmoothHoldAt(CFrame.lookAt(above,part.Position), "ChestFarm", 5)
        AutoHaki()
        local th=target:FindFirstChildOfClass("Humanoid")
        if th then
            FastAttackTarget(target)
        elseif ShootGunEvent then
            pcall(function() ShootGunEvent:FireServer(part.Position,{part}) end)
        end
    end
    return true
end

task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            if not _G.Settings.Sea["Auto Attack Sea Events"] then return end
            local target=findSeaTargetFallback()
            if target then attackSeaFallback(target) end
        end)
    end
end)

-- Boat safety/height stabilizer V26
task.spawn(function()
    while task.wait(0.12) do
        pcall(function()
            local S=_G.Settings.Sea
            if not (S["Sail Boat"] or S["Auto Find Kitsune Island"] or _G.Settings.Race["Auto Find Mirage"] or S["Auto Attack Sea Events"]) then return end
            local boat=GetMyBoatIntegrated()
            if not boat then return end
            local seat=getBoatSeat(boat)
            if not seat then return end
            local targetY=getBoatHeight()
            if math.abs(seat.Position.Y-targetY)>10 and not boat:GetAttribute("HaroonBoatMoving") then
                local primary=boat.PrimaryPart or seat
                if primary then
                    local p=primary.Position
                    local cf=CFrame.lookAt(Vector3.new(p.X,targetY,p.Z), Vector3.new(p.X+60,targetY,p.Z))
                    boat:PivotTo(cf)
                end
            end
        end)
    end
end)
