----------------------------------------------------------------
-- AETHERUI PRO X LOADER
----------------------------------------------------------------

local LIBRARY_URL =
    "https://pastebin.com/raw/y3wUhBTN"

----------------------------------------------------------------
-- DOWNLOAD
----------------------------------------------------------------

local function HttpGet(url)

    local ok, result =
        pcall(function()

            return game:HttpGet(url)

        end)

    if not ok then

        error(
            "AetherUI Loader: HttpGet failed."
        )
    end

    if type(result) ~= "string"
        or #result < 100
    then

        error(
            "AetherUI Loader: Invalid library source."
        )
    end

    return result
end

----------------------------------------------------------------
-- LOAD
----------------------------------------------------------------

local Source =
    HttpGet(
        LIBRARY_URL
    )

local Chunk, Error =
    loadstring(
        Source
    )

if not Chunk then

    error(
        "AetherUI Loader: "
        .. tostring(Error)
    )
end

local AetherUI =
    Chunk()

if type(AetherUI) ~= "table" then

    error(
        "AetherUI Loader: Library did not return a table."
    )
end

----------------------------------------------------------------
-- GLOBAL
----------------------------------------------------------------

local ENV =
    (type(getgenv) == "function" and getgenv())
    or _G

ENV.AetherUI =
    AetherUI

----------------------------------------------------------------
-- START EXAMPLE
----------------------------------------------------------------

AetherUI:InitLoadingScreen(
    "AetherUI Pro X",
    "Loading...",
    function()

        local Window =
            AetherUI:CreateWindow({

                Title =
                    "AetherUI Pro X",

                Subtitle =
                    "Standalone Library",

                ToggleKey =
                    Enum.KeyCode.RightControl,

                Width =
                    760,

                Height =
                    500
            })

        --------------------------------------------------------
        -- MAIN
        --------------------------------------------------------

        local Main =
            Window:CreateTab(
                "Main",
                "Main"
            )

        Main:CreateSection(
            "Basic Components"
        )

        Main:CreateParagraph({

            Title =
                "Welcome",

            Desc =
                "This window is running from a completely standalone " ..
                "AetherUI library. The library itself contains no URL " ..
                "and does not download any dependency."
        })

        Main:CreateButton(
            "Test Notification",
            "TestNotification",
            function()

                AetherUI:Notify({

                    Title =
                        "AetherUI",

                    Content =
                        "Button is working successfully!",

                    Duration =
                        5
                })
            end
        )

        --------------------------------------------------------
        -- TOGGLE
        --------------------------------------------------------

        Main:CreateSection(
            "Toggle"
        )

        Main:CreateToggle(
            "Example Toggle",
            "ExampleToggle",
            false,
            function(value)

                AetherUI:Notify({

                    Title =
                        "Toggle",

                    Content =
                        "Value: "
                        .. tostring(value),

                    Duration =
                        2
                })
            end
        )

        --------------------------------------------------------
        -- SLIDER
        --------------------------------------------------------

        Main:CreateSection(
            "Slider"
        )

        Main:CreateSlider(
            "Player Speed",
            "PlayerSpeed",
            16,
            200,
            30,
            function(value)

                print(
                    "Player Speed:",
                    value
                )
            end
        )

        --------------------------------------------------------
        -- DROPDOWN
        --------------------------------------------------------

        Main:CreateSection(
            "Dropdown"
        )

        Main:CreateDropdown(
            "Weapon",
            "Weapon",
            {
                "Melee",
                "Sword",
                "Gun",
                "Blox Fruit"
            },
            "Melee",
            function(value)

                print(
                    "Weapon:",
                    value
                )
            end
        )

        --------------------------------------------------------
        -- MULTI DROPDOWN
        --------------------------------------------------------

        Main:CreateMultiDropdown(
            "Features",
            "Features",
            {
                "Auto Farm",
                "Auto Boss",
                "Auto Chest",
                "ESP",
                "Auto Raid"
            },
            {
                "ESP"
            },
            function(values)

                print(
                    "Selected Features:"
                )

                for _, value
                    in ipairs(values)
                do

                    print(
                        " -",
                        value
                    )
                end
            end
        )

        --------------------------------------------------------
        -- COMPONENT
        --------------------------------------------------------

        Main:CreateSection(
            "Tabbed Component"
        )

        Main:CreateComponent({

            Title =
                "Advanced Components",

            Height =
                230,

            Tabs = {

                {
                    Name =
                        "Combat",

                    Build =
                        function(UI)

                            UI:Label(
                                "Combat Settings"
                            )

                            UI:Button(
                                "Test Attack",
                                function()

                                    AetherUI:Notify({

                                        Title =
                                            "Combat",

                                        Content =
                                            "Attack pressed!",

                                        Duration =
                                            2
                                    })
                                end
                            )
                        end
                },

                {
                    Name =
                        "Farm",

                    Build =
                        function(UI)

                            UI:Label(
                                "Farm Settings"
                            )

                            UI:Button(
                                "Start Farm",
                                function()

                                    print(
                                        "Farm Started"
                                    )
                                end
                            )

                            UI:Button(
                                "Stop Farm",
                                function()

                                    print(
                                        "Farm Stopped"
                                    )
                                end
                            )
                        end
                },

                {
                    Name =
                        "Visual",

                    Build =
                        function(UI)

                            UI:Label(
                                "Visual Settings"
                            )

                            UI:Button(
                                "Enable ESP",
                                function()

                                    print(
                                        "ESP Enabled"
                                    )
                                end
                            )
                        end
                }
            }
        })

        --------------------------------------------------------
        -- SECOND TAB
        --------------------------------------------------------

        local Settings =
            Window:CreateTab(
                "Settings",
                "Settings"
            )

        Settings:CreateSection(
            "Settings"
        )

        Settings:CreateParagraph({

            Title =
                "Library",

            Desc =
                "AetherUI Pro X is loaded directly from the Loader URL. " ..
                "The actual library source contains no HttpGet code."
        })

        Settings:CreateToggle(
            "UI Animations",
            "Animations",
            true,
            function(value)

                print(
                    "Animations:",
                    value
                )
            end
        )

        --------------------------------------------------------
        -- READY
        --------------------------------------------------------

        AetherUI:Notify({

            Title =
                "AetherUI Pro X",

            Content =
                "Library loaded successfully!",

            Duration =
                5
        })
    end
)
