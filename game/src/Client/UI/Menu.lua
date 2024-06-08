local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)

return Fusion.New "ScreenGui" {
    Name = "Menu",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    [Fusion.Children] = {
        Fusion.New "Frame" { -- Background
            Name = "Background",
            Size = UDim2.fromScale(1, 1)
        },

        Fusion.New "Frame" { -- Game name container
            Name = "Game Name Container",
            Size = UDim2.fromScale(.5, 0.176),
            Position = UDim2.fromScale(.5, 0.176),
            AnchorPoint = Vector2.new(.5, 0)
        },

        Fusion.New "Button Container" {
            Name = "Button Container"
            
        }
    }
}