local function safeHttpGet(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)

    return ok and result or nil
end

local env = (getgenv and getgenv()) or _G

local AetherUI = rawget(env, "Aether.lua")

local AETHERUI_SOURCE_URL =
    env.HAROON_AETHERUI_URL
    or "https://pastebin.com/raw/y3wUhBTN"

if not AetherUI then
    local source = safeHttpGet(AETHERUI_SOURCE_URL)

    assert(
        type(source) == "string"
        and #source > 100,
        "Failed to load AetherUI Library"
    )

    source = source:gsub("\nI%s*$", "\n")

    local chunk, err = loadstring(source)

    assert(chunk, err)

    AetherUI = chunk()

    assert(
        type(AetherUI) == "table",
        "Invalid AetherUI Library"
    )

    env.AetherUI = AetherUI
end

--==================================================
-- LOADING
--==================================================

AetherUI:InitLoadingScreen(
    "Aether Hub",
    "Loading interface...",
    function()

        --==================================================
        -- WINDOW
        --==================================================

        local Window = AetherUI:CreateWindow({
            Title = "Aether Hub",
            Subtitle = "Professional Hub",
            ToggleKey = Enum.KeyCode.RightControl
        })

        --==================================================
        -- CATEGORY
        --==================================================

        local MainCategory =
            Window:CreateCategory("MAIN")

        --==================================================
        -- HOME
        --==================================================

        local Home =
            MainCategory:CreateTab(
                "Home",
                "6031280882"
            )

        Home:CreateSection("Dashboard")

        Home:CreateParagraph({
            Title = "Welcome",
            Content = "Welcome to Aether Hub. The library is loaded successfully."
        })

        Home:CreateButton(
            "Test Notification",
            "TestNotification",
            function()

                AetherUI:Notify({
                    Title = "Aether Hub",
                    Content = "Everything is working correctly!",
                    Duration = 4,
                    Type = "Success"
                })

            end
        )

        --==================================================
        -- COMBAT
        --==================================================

        local Combat =
            MainCategory:CreateTab(
                "Combat",
                "6031280882"
            )

        Combat:CreateSection("Main")

        Combat:CreateToggle(
            "Example Toggle",
            "ExampleToggle",
            false,
            function(value)

                AetherUI:Notify({
                    Title = "Toggle",
                    Content = "Value: " .. tostring(value),
                    Duration = 2
                })

            end
        )

        Combat:CreateSlider(
            "Smoothness",
            "Smoothness",
            0,
            100,
            50,
            function(value)

                print("Smoothness:", value)

            end,
            1
        )

        --==================================================
        -- SETTINGS
        --==================================================

        local SettingsCategory =
            Window:CreateCategory("SETTINGS")

        local Settings =
            SettingsCategory:CreateTab(
                "Settings",
                "6031280882"
            )

        Settings:CreateSection("Mode")

        Settings:CreateDropdown(
            "Mode",
            "Mode",
            {
                "Legit",
                "Rage",
                "Silent"
            },
            "Legit",
            function(value)

                AetherUI:Notify({
                    Title = "Mode",
                    Content = "Selected: " .. tostring(value),
                    Duration = 2
                })

            end
        )

        --==================================================
        -- MULTI DROPDOWN
        --==================================================

        Settings:CreateSection("Targets")

        Settings:CreateMultiDropdown(
            "Targets",
            "Targets",
            {
                "Players",
                "NPCs",
                "Friends",
                "Enemies"
            },
            {
                "Players",
                "Enemies"
            },
            function(values)

                print(
                    "Selected:",
                    table.concat(values, ", ")
                )

            end
        )

        --==================================================
        -- NOTES
        --==================================================

        Settings:CreateSection("Information")

        local paragraph =
            Settings:CreateParagraph({
                Title = "Library",
                Content = "AetherUI is loaded externally and is completely separated from this Hub script."
            })

        -- Dynamic paragraph example
        task.delay(3, function()

            paragraph:SetContent(
                "AetherUI Version: "
                .. tostring(AetherUI.Version)
                .. "\nExecutor: "
                .. tostring(AetherUI:GetExecutor())
            )

        end)
    end
)
