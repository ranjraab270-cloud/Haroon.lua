----------------------------------------------------------------
-- AETHERUI PRO X LOADER + EXAMPLES
----------------------------------------------------------------

local LIBRARY_URL = "https://pastebin.com/raw/y3wUhBTN"

local function HttpGet(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then
        error("AetherUI Loader: HttpGet failed.")
    end
    if type(result) ~= "string" or #result < 100 then
        error("AetherUI Loader: Invalid library source.")
    end
    return result
end

local Source = HttpGet(LIBRARY_URL)
local Loader = loadstring or load
if not Loader then
    error("AetherUI Loader: loadstring/load is unavailable.")
end

local ok, Factory = pcall(Loader, Source)
if not ok then
    error("AetherUI Loader: Library compile failed: " .. tostring(Factory))
end

local AetherUI = Factory
if type(AetherUI) ~= "table" then
    error("AetherUI Loader: Library did not return AetherUI.")
end

----------------------------------------------------------------
-- KEY SYSTEM EXAMPLE
-- Remove this block if your project does not use a key system.
----------------------------------------------------------------

local function StartAether()
    local Window = AetherUI:CreateWindow({
        Title = "AetherUI Pro X",
        Subtitle = "Yin Yang Edition",
        ToggleKey = Enum.KeyCode.RightControl
    })

    ----------------------------------------------------------------
    -- TAB
    ----------------------------------------------------------------

    local MainTab = Window:CreateTab(
        "Examples",
        "rbxassetid://6034287594"
    )

    ----------------------------------------------------------------
    -- SECTION / PARAGRAPH
    ----------------------------------------------------------------

    MainTab:CreateSection("Basic Components")

    MainTab:CreateParagraph({
        Title = "AetherUI Pro X",
        Content = "Clean Yin-Yang UI example."
    })

    ----------------------------------------------------------------
    -- BUTTON
    ----------------------------------------------------------------

    MainTab:CreateButton("Test Notification", function()
        AetherUI:Notify({
            Title = "AetherUI",
            Content = "Button callback executed successfully.",
            Duration = 3
        })
    end)

    ----------------------------------------------------------------
    -- TOGGLE
    ----------------------------------------------------------------

    MainTab:CreateToggle(
        "Example Toggle",
        "ExampleToggle",
        function(state)
            print("ExampleToggle:", state)
        end
    )

    ----------------------------------------------------------------
    -- DROPDOWN
    ----------------------------------------------------------------

    MainTab:CreateDropdown(
        "Example Dropdown",
        "ExampleDropdown",
        {"Option 1", "Option 2", "Option 3"},
        "Option 1",
        function(value)
            print("Dropdown:", value)
        end
    )

    ----------------------------------------------------------------
    -- MULTI DROPDOWN
    ----------------------------------------------------------------

    MainTab:CreateMultiDropdown(
        "Example Multi Dropdown",
        "ExampleMultiDropdown",
        {"Melee", "Sword", "Gun", "Fruit"},
        {"Melee", "Sword"},
        function(values)
            print("Selected:", table.concat(values, ", "))
        end
    )

    ----------------------------------------------------------------
    -- SLIDER
    ----------------------------------------------------------------

    MainTab:CreateSlider(
        "Example Slider",
        "ExampleSlider",
        0,
        100,
        50,
        function(value)
            print("Slider:", value)
        end
    )

    ----------------------------------------------------------------
    -- SECOND SECTION
    ----------------------------------------------------------------

    MainTab:CreateSection("API Usage")

    MainTab:CreateButton("Read Slider Flag", function()
        print("Current slider:", AetherUI.Flags.ExampleSlider)
    end)

    MainTab:CreateButton("Show Notification", function()
        AetherUI:Notify({
            Title = "AetherUI",
            Content = "This notification uses the library notification system.",
            Duration = 5
        })
    end)
end

-- If you want a key system, uncomment/use this instead of StartAether().
-- AetherUI:InitKeySystem({
-- "YOUR-KEY-HERE"
-- }, StartAether)

StartAether()

return AetherUI
