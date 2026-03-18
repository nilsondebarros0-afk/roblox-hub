-- ╔══════════════════════════════════════════════════════╗
-- ║              UNIVERSAL HUB v2.0                      ║
-- ║   Compatible : Synapse X | KRNL | Fluxus | Delta     ║
-- ║   Fonctionne sur TOUS les jeux Roblox                ║
-- ╚══════════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse     = player:GetMouse()
local camera    = Workspace.CurrentCamera

local character = player.Character or player.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")
local rootPart  = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(c)
    character = c
    humanoid  = c:WaitForChild("Humanoid")
    rootPart  = c:WaitForChild("HumanoidRootPart")
end)

-- ════════════════════════════════════
--              ÉTATS & CONNEXIONS
-- ════════════════════════════════════
local states = {}
local conns  = {}
_G.FlySpeed  = 60

-- Supprime l'ancien hub s'il existe
for _, gui in pairs({playerGui, game:GetService("CoreGui")}) do
    local old = gui:FindFirstChild("UniversalHub")
    if old then old:Destroy() end
end

-- ════════════════════════════════════
--              GUI PRINCIPALE
-- ════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "UniversalHub"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder   = 999
pcall(function() ScreenGui.Parent = playerGui end)
if not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
end

-- Cadre principal
local Main = Instance.new("Frame", ScreenGui)
Main.Name             = "Main"
Main.Size             = UDim2.new(0, 290, 0, 410)
Main.Position         = UDim2.new(0, 20, 0.5, -205)
Main.BackgroundColor3 = Color3.fromRGB(9, 7, 18)
Main.BorderSizePixel  = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color     = Color3.fromRGB(110, 70, 240)
mainStroke.Thickness = 1.5

local bg = Instance.new("UIGradient", Main)
bg.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(18, 12, 38)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 9,  25)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(7,  5,  16)),
})
bg.Rotation = 145

-- ══ TOPBAR ══
local TopBar = Instance.new("Frame", Main)
TopBar.Size             = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = Color3.fromRGB(100, 60, 220)
TopBar.BorderSizePixel  = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local tbFix = Instance.new("Frame", TopBar)
tbFix.Size             = UDim2.new(1, 0, 0.5, 0)
tbFix.Position         = UDim2.new(0, 0, 0.5, 0)
tbFix.BackgroundColor3 = Color3.fromRGB(100, 60, 220)
tbFix.BorderSizePixel  = 0

local tbGrad = Instance.new("UIGradient", TopBar)
tbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 85, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80,  45, 190)),
})
tbGrad.Rotation = 90

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "⚡  UNIVERSAL HUB"
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local Sub = Instance.new("TextLabel", TopBar)
Sub.Text = "Tous jeux • v2.0"
Sub.Size = UDim2.new(1, -50, 0, 14)
Sub.Position = UDim2.new(0, 14, 1, -16)
Sub.BackgroundTransparency = 1
Sub.TextColor3 = Color3.fromRGB(200, 180, 255)
Sub.TextSize = 10
Sub.Font = Enum.Font.Gotham
Sub.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 80)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 7)

-- Bouton réouverture (mini)
local MinBtn = Instance.new("TextButton", ScreenGui)
MinBtn.Text = "⚡ HUB"
MinBtn.Size = UDim2.new(0, 80, 0, 28)
MinBtn.Position = UDim2.new(0, 20, 0, 10)
MinBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 220)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 12
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Visible = false
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local isVisible = true
CloseBtn.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    Main.Visible = isVisible
    MinBtn.Visible = not isVisible
end)
MinBtn.MouseButton1Click:Connect(function()
    isVisible = true
    Main.Visible = true
    MinBtn.Visible = false
end)

-- ══ DRAG ══
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging  = true
        dragStart = inp.Position
        startPos  = Main.Position
    end
end)
TopBar.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- ══ SCROLL ══
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -12, 1, -52)
Scroll.Position = UDim2.new(0, 6, 0, 48)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(110, 70, 240)
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local List = Instance.new("UIListLayout", Scroll)
List.Padding   = UDim.new(0, 5)
List.SortOrder = Enum.SortOrder.LayoutOrder

local Pad = Instance.new("UIPadding", Scroll)
Pad.PaddingTop    = UDim.new(0, 4)
Pad.PaddingBottom = UDim.new(0, 8)

List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 14)
end)

-- ════════════════════════════════════
--          HELPERS UI
-- ════════════════════════════════════
local order = 0
local function nextOrder() order += 1 return order end

local function Section(txt)
    local lbl = Instance.new("TextLabel", Scroll)
    lbl.Text  = "  ▸ " .. txt
    lbl.Size  = UDim2.new(1, -4, 0, 22)
    lbl.BackgroundColor3 = Color3.fromRGB(110, 70, 240)
    lbl.BackgroundTransparency = 0.72
    lbl.TextColor3 = Color3.fromRGB(200, 180, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = nextOrder()
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6)
end

local function Toggle(icon, txt, callback)
    local Row = Instance.new("Frame", Scroll)
    Row.Size = UDim2.new(1, -4, 0, 46)
    Row.BackgroundColor3 = Color3.fromRGB(18, 12, 35)
    Row.BorderSizePixel  = 0
    Row.LayoutOrder = nextOrder()
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 9)

    local rowStroke = Instance.new("UIStroke", Row)
    rowStroke.Color = Color3.fromRGB(45, 30, 75)
    rowStroke.Thickness = 1

    local IconL = Instance.new("TextLabel", Row)
    IconL.Text = icon
    IconL.Size = UDim2.new(0, 32, 1, 0)
    IconL.Position = UDim2.new(0, 8, 0, 0)
    IconL.BackgroundTransparency = 1
    IconL.TextColor3 = Color3.fromRGB(170, 140, 255)
    IconL.TextSize = 18
    IconL.Font = Enum.Font.Gotham

    local Lbl = Instance.new("TextLabel", Row)
    Lbl.Text = txt
    Lbl.Size = UDim2.new(1, -100, 1, 0)
    Lbl.Position = UDim2.new(0, 44, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.TextColor3 = Color3.fromRGB(215, 205, 255)
    Lbl.TextSize = 13
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local Pill = Instance.new("Frame", Row)
    Pill.Size = UDim2.new(0, 48, 0, 26)
    Pill.Position = UDim2.new(1, -58, 0.5, -13)
    Pill.BackgroundColor3 = Color3.fromRGB(40, 28, 65)
    Pill.BorderSizePixel = 0
    Instance.new("UICorner", Pill).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Pill)
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = UDim2.new(0, 3, 0.5, -10)
    Circle.BackgroundColor3 = Color3.fromRGB(140, 115, 200)
    Circle.BorderSizePixel = 0
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local isOn = false
    local function setOn(v)
        isOn = v
        TweenService:Create(Circle, TweenInfo.new(0.18), {
            Position         = v and UDim2.new(0, 25, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
            BackgroundColor3 = v and Color3.fromRGB(255,255,255) or Color3.fromRGB(140,115,200),
        }):Play()
        TweenService:Create(Pill, TweenInfo.new(0.18), {
            BackgroundColor3 = v and Color3.fromRGB(110,70,240) or Color3.fromRGB(40,28,65),
        }):Play()
        rowStroke.Color = v and Color3.fromRGB(110,70,240) or Color3.fromRGB(45,30,75)
        callback(v)
    end

    local Btn = Instance.new("TextButton", Row)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.MouseButton1Click:Connect(function() setOn(not isOn) end)

    return setOn
end

local function Slider(icon, txt, minV, maxV, default, callback)
    local Row = Instance.new("Frame", Scroll)
    Row.Size = UDim2.new(1, -4, 0, 62)
    Row.BackgroundColor3 = Color3.fromRGB(18, 12, 35)
    Row.BorderSizePixel  = 0
    Row.LayoutOrder = nextOrder()
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 9)
    local rs = Instance.new("UIStroke", Row)
    rs.Color = Color3.fromRGB(45, 30, 75); rs.Thickness = 1

    local IconL = Instance.new("TextLabel", Row)
    IconL.Text = icon
    IconL.Size = UDim2.new(0, 30, 0, 30)
    IconL.Position = UDim2.new(0, 8, 0, 4)
    IconL.BackgroundTransparency = 1
    IconL.TextColor3 = Color3.fromRGB(170,140,255)
    IconL.TextSize = 17; IconL.Font = Enum.Font.Gotham

    local LblS = Instance.new("TextLabel", Row)
    LblS.Text = txt
    LblS.Size = UDim2.new(1, -100, 0, 30)
    LblS.Position = UDim2.new(0, 42, 0, 4)
    LblS.BackgroundTransparency = 1
    LblS.TextColor3 = Color3.fromRGB(215,205,255)
    LblS.TextSize = 13; LblS.Font = Enum.Font.Gotham
    LblS.TextXAlignment = Enum.TextXAlignment.Left

    local ValLbl = Instance.new("TextLabel", Row)
    ValLbl.Size = UDim2.new(0, 45, 0, 30)
    ValLbl.Position = UDim2.new(1, -52, 0, 4)
    ValLbl.BackgroundTransparency = 1
    ValLbl.TextColor3 = Color3.fromRGB(170,140,255)
    ValLbl.TextSize = 12; ValLbl.Font = Enum.Font.GothamBold
    ValLbl.Text = tostring(default)

    local Track = Instance.new("Frame", Row)
    Track.Size = UDim2.new(1, -24, 0, 6)
    Track.Position = UDim2.new(0, 12, 0, 42)
    Track.BackgroundColor3 = Color3.fromRGB(40,28,65)
    Track.BorderSizePixel = 0
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((default-minV)/(maxV-minV), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(110,70,240)
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

    local Handle = Instance.new("Frame", Track)
    Handle.Size = UDim2.new(0,14,0,14)
    Handle.AnchorPoint = Vector2.new(0.5,0.5)
    Handle.Position = UDim2.new((default-minV)/(maxV-minV),0,0.5,0)
    Handle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Handle.BorderSizePixel = 0
    Instance.new("UICorner", Handle).CornerRadius = UDim.new(1,0)

    local sliding = false
    local function update(x)
        local abs = Track.AbsolutePosition.X
        local w   = Track.AbsoluteSize.X
        local pct = math.clamp((x - abs) / w, 0, 1)
        local val = math.floor(minV + pct * (maxV - minV))
        Fill.Size = UDim2.new(pct, 0, 1, 0)
        Handle.Position = UDim2.new(pct, 0, 0.5, 0)
        ValLbl.Text = tostring(val)
        callback(val)
    end
    Track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true; update(inp.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
            update(inp.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
end

-- ════════════════════════════════════
--          CONTENU DU HUB
-- ════════════════════════════════════

-- ── MOUVEMENT ──
Section("MOUVEMENT")

Toggle("🏃", "Speed Hack", function(v)
    humanoid.WalkSpeed = v and 100 or 16
end)

Slider("💨", "Vitesse de marche", 16, 250, 16, function(val)
    humanoid.WalkSpeed = val
end)

Toggle("🚫", "No-Clip (traverser murs)", function(v)
    if v then
        conns.noClip = RunService.Stepped:Connect(function()
            for _, p in pairs(character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    else
        if conns.noClip then conns.noClip:Disconnect() conns.noClip = nil end
    end
end)

Toggle("🦅", "Fly  [W/A/S/D + Space]", function(v)
    if v then
        local bg = Instance.new("BodyGyro", rootPart)
        bg.Name = "HubGyro"; bg.D = 9999
        bg.MaxTorque = Vector3.new(9e8,9e8,9e8)
        local bv = Instance.new("BodyVelocity", rootPart)
        bv.Name = "HubVel"; bv.Velocity = Vector3.zero
        bv.MaxForce = Vector3.new(9e8,9e8,9e8)
        conns.fly = RunService.RenderStepped:Connect(function()
            local spd = _G.FlySpeed or 60
            local vel = Vector3.zero
            local UIS = UserInputService
            if UIS:IsKeyDown(Enum.KeyCode.W)          then vel += camera.CFrame.LookVector  * spd  end
            if UIS:IsKeyDown(Enum.KeyCode.S)          then vel -= camera.CFrame.LookVector  * spd  end
            if UIS:IsKeyDown(Enum.KeyCode.A)          then vel -= camera.CFrame.RightVector * spd  end
            if UIS:IsKeyDown(Enum.KeyCode.D)          then vel += camera.CFrame.RightVector * spd  end
            if UIS:IsKeyDown(Enum.KeyCode.Space)      then vel += Vector3.new(0, spd*0.6, 0)       end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift)  then vel -= Vector3.new(0, spd*0.6, 0)       end
            bv.Velocity = vel; bg.CFrame = camera.CFrame
        end)
    else
        if conns.fly then conns.fly:Disconnect() conns.fly = nil end
        local bg = rootPart:FindFirstChild("HubGyro")
        local bv = rootPart:FindFirstChild("HubVel")
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end)

Slider("⚡", "Vitesse Fly", 10, 200, 60, function(val) _G.FlySpeed = val end)

Toggle("🐇", "Infinite Jump", function(v)
    if v then
        conns.infJump = UserInputService.JumpRequest:Connect(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    else
        if conns.infJump then conns.infJump:Disconnect() conns.infJump = nil end
    end
end)

Slider("🦘", "Jump Power", 0, 250, 50, function(val)
    humanoid.JumpPower = val
end)

Toggle("🛡️", "Anti-Fall (no mort)", function(v)
    if v then
        conns.antiFall = RunService.Heartbeat:Connect(function()
            if humanoid.Health > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    else
        if conns.antiFall then conns.antiFall:Disconnect() conns.antiFall = nil end
    end
end)

-- ── COMBAT / FARM ──
Section("COMBAT / FARM")

Toggle("⚔️", "Auto Farm (mob proche)", function(v)
    if v then
        conns.autoFarm = RunService.Heartbeat:Connect(function()
            local closest, minD = nil, math.huge
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj ~= character then
                    local h = obj:FindFirstChildOfClass("Humanoid")
                    local r = obj:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health > 0 then
                        local d = (rootPart.Position - r.Position).Magnitude
                        if d < minD then minD = d; closest = r end
                    end
                end
            end
            if closest then
                rootPart.CFrame = closest.CFrame * CFrame.new(0, 0, 3.5)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if conns.autoFarm then conns.autoFarm:Disconnect() conns.autoFarm = nil end
    end
end)

Toggle("🎯", "Kill Aura (range 20)", function(v)
    if v then
        conns.killAura = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj ~= character then
                    local h = obj:FindFirstChildOfClass("Humanoid")
                    local r = obj:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health > 0 then
                        if (rootPart.Position - r.Position).Magnitude < 20 then
                            h.Health = 0
                        end
                    end
                end
            end
        end)
    else
        if conns.killAura then conns.killAura:Disconnect() conns.killAura = nil end
    end
end)

-- ── VISUEL ──
Section("VISUEL")

Toggle("🌕", "Fullbright (nuit → jour)", function(v)
    if v then
        Lighting.Brightness     = 10
        Lighting.ClockTime      = 14
        Lighting.FogEnd         = 100000
        Lighting.GlobalShadows  = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness     = 1
        Lighting.ClockTime      = 14
        Lighting.FogEnd         = 100000
        Lighting.GlobalShadows  = true
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
    end
end)

Toggle("👁️", "ESP Joueurs (boîte rouge)", function(v)
    if v then
        conns.esp = RunService.RenderStepped:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    if not p.Character:FindFirstChild("HubESP") then
                        local sel = Instance.new("SelectionBox", p.Character)
                        sel.Name               = "HubESP"
                        sel.Adornee            = p.Character
                        sel.LineThickness       = 0.06
                        sel.Color3             = Color3.fromRGB(255,80,80)
                        sel.SurfaceTransparency = 0.75
                        sel.SurfaceColor3      = Color3.fromRGB(255,80,80)
                    end
                end
            end
        end)
    else
        if conns.esp then conns.esp:Disconnect() conns.esp = nil end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local e = p.Character:FindFirstChild("HubESP")
                if e then e:Destroy() end
            end
        end
    end
end)

Toggle("🔭", "Zoom caméra étendu", function(v)
    player.CameraMaxZoomDistance = v and 500 or 400
    player.CameraMinZoomDistance = v and 0   or 0.5
end)

-- ── TÉLÉPORT ──
Section("TÉLÉPORT")

Toggle("📍", "TP sur curseur  [Touche F]", function(v)
    if v then
        conns.tpCursor = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if inp.KeyCode == Enum.KeyCode.F then
                local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
                local res = Workspace:Raycast(ray.Origin, ray.Direction * 1000)
                if res then
                    rootPart.CFrame = CFrame.new(res.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
    else
        if conns.tpCursor then conns.tpCursor:Disconnect() conns.tpCursor = nil end
    end
end)

-- ════════════════════════════════════
print("✅ [Universal Hub v2.0] Chargé !")
