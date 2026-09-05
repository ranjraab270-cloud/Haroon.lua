----------------------------------------------------------------
-- AETHERUI PRO X LOADER + EXAMPLES (FIXED)
-- IMPORTANT: The library chunk must return the AetherUI table.
----------------------------------------------------------------

local LIBRARY_URL = "https://pastebin.com/raw/y3wUhBTN"

local function HttpGet(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        error("AetherUI Loader: HttpGet failed: " .. tostring(result))
    end

    if type(result) ~= "string" or #result < 100 then
        error("AetherUI Loader: Invalid/empty library source.")
    end

    return result
end

local Source = HttpGet(LIBRARY_URL)

-- loadstring compiles the source and returns a function.
-- The old loader stopped here, so it received a function instead of AetherUI.
local Compiler = loadstring or load
if type(Compiler) ~= "function" then
    error("AetherUI Loader: loadstring/load is unavailable.")
end

local compileOk, Chunk = pcall(Compiler, Source)
if not compileOk or type(Chunk) ~= "function" then
    error("AetherUI Loader: Library compile failed: " .. tostring(Chunk))
end

-- Execute the compiled library chunk to obtain its return value.
local runOk, AetherUI = pcall(Chunk)
if not runOk then
    error("AetherUI Loader: Library runtime failed: " .. tostring(AetherUI))
end

if type(AetherUI) ~= "table" then
    error("AetherUI Loader: Library did not return the AetherUI table. Got: " .. type(AetherUI))
end

----------------------------------------------------------------
-- EXAMPLE WINDOW
----------------------------------------------------------------

local Window = AetherUI:CreateWindow({
    Title = "AetherUI Pro X",
    Subtitle = "Yin Yang Edition",
    ToggleKey = Enum.KeyCode.RightControl
})

local MainTab = Window:CreateTab(
    "Examples",
    "rbxassetid://6034287594"
)

MainTab:CreateSection("Basic Components")

MainTab:CreateParagraph({
    Title = "AetherUI Pro X",
    Content = "Clean Yin-Yang UI example."
})

MainTab:CreateButton("Test Notification", function()
    AetherUI:Notify({
        Title = "AetherUI",
        Content = "Button callback executed successfully.",
        Duration = 3
    })
end)

-- Signature: Text, Flag, Default, Callback
MainTab:CreateToggle(
    "Example Toggle",
    "ExampleToggle",
    false,
    function(state)
        print("ExampleToggle:", state)
    end
)

MainTab:CreateDropdown(
    "Example Dropdown",
    "ExampleDropdown",
    {"Option 1", "Option 2", "Option 3"},
    "Option 1",
    function(value)
        print("Dropdown:", value)
    end
)

MainTab:CreateMultiDropdown(
    "Example Multi Dropdown",
    "ExampleMultiDropdown",
    {"Melee", "Sword", "Gun", "Fruit"},
    {"Melee", "Sword"},
    function(values)
        print("Selected:", table.concat(values, ", "))
    end
)

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

AetherUI:Notify({
    Title = "AetherUI Pro X",
    Content = "Library loaded successfully.",
    Duration = 4
})

----------------------------------------------------------------
-- OPTIONAL KEY SYSTEM EXAMPLE
-- Uncomment if you want to gate the window behind a key.
----------------------------------------------------------------
-- AetherUI:InitKeySystem({"YOUR-KEY-HERE"}, function()
--     -- Put your CreateWindow code here.
-- end)

return AetherUI
