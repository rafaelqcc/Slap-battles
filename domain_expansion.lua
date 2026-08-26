local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
local button = Instance.new("TextButton", screenGui)

button.Size = UDim2.new(0, 200, 0, 60)
button.Position = UDim2.new(0.85, -100, 0.5, -30)
button.Text = "Domain Expansion: Unlimited Void"
button.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextScaled = true
button.Font = Enum.Font.Fantasy
button.BorderSizePixel = 4
button.BorderColor3 = Color3.new(0, 0, 0)

local gradient = Instance.new("UIGradient", button)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(0.6, 0, 0.6)),
    ColorSequenceKeypoint.new(0.5, Color3.new(1, 0, 1)),
    ColorSequenceKeypoint.new(1, Color3.new(0.6, 0, 0.6))
}
gradient.Rotation = 45

local cooldown = false

local function startCooldown()
    local cooldownTime = 40
    for i = cooldownTime, 1, -1 do
        button.Text = "Cooldown: " .. i .. "s"
        task.wait(1)
    end
    button.Text = "Domain Expansion: Unlimited Void"
    button.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
    cooldown = false
end

local function playSound(id, volume, parent)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://"..id
    sound.Volume = volume
    sound.Parent = parent or workspace
    sound:Play()
    return sound
end

local function attachModelToTorso(modelId, character)
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end
    
    local model = game:GetObjects("rbxassetid://"..modelId)[1]
    model.Parent = character

    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            part.CFrame = torso.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = torso
            weld.Part1 = part
            weld.Parent = part
        end
    end
    return model
end

local function setCameraFOV(camera, targetFOV, duration)
    local initialFOV = camera.FieldOfView
    local startTime = tick()
    
    while tick() - startTime < duration do
        local elapsed = tick() - startTime
        local alpha = elapsed / duration
        camera.FieldOfView = initialFOV + (targetFOV - initialFOV) * alpha
        task.wait(0.01)
    end
    camera.FieldOfView = targetFOV
end

local function createEffects(assetId, count, delay, yOffset)
    local character = player.Character or player.CharacterAdded:Wait()
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return {} end

    local effects = {}
    for _ = 1, count do
        local effect = game:GetObjects("rbxassetid://"..assetId)[1]
        if effect then
            effect.Parent = torso
            effect.CFrame = torso.CFrame * CFrame.new(0, yOffset, -1)
            table.insert(effects, effect)
        end
        task.wait(delay)
    end
    return effects
end

local function applyScreenEffects(duration)
    local lighting = game:GetService("Lighting")
    
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.new(1, 1, 1)
    colorCorrection.Brightness = 0
    colorCorrection.Contrast = 0
    colorCorrection.Saturation = 0
    colorCorrection.Parent = lighting
    
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = lighting
    
    local increment = 0.05
    
    for i = 0, 1, increment / duration do
        colorCorrection.Brightness = i
        blur.Size = i * 24
        task.wait(increment)
    end
    
    colorCorrection:Destroy()
    blur:Destroy()
end

local function cameraShake(duration, intensity)
    local camera = workspace.CurrentCamera
    local originalCFrame = camera.CFrame
    local RunService = game:GetService("RunService")
    
    for _ = 0, intensity * 250 do
        local shakeOffset = Vector3.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1)) * intensity * 0.1
        camera.CFrame = originalCFrame * CFrame.new(shakeOffset)
        RunService.Heartbeat:Wait()
    end
    camera.CFrame = originalCFrame
end

local function playAnimation(animationId, speed)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://"..animationId
    local track = humanoid:LoadAnimation(animation)
    track:Play()
    track:AdjustSpeed(speed)
    return track
end

button.MouseButton1Click:Connect(function()
    if cooldown then return end
    cooldown = true
    button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)

    task.spawn(startCooldown)

    local character = player.Character or player.CharacterAdded:Wait()
    local originalTransparency = {}

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(character) then
            table.insert(originalTransparency, {object = obj, transparency = obj.Transparency})
            obj.Transparency = 1
        end
    end

    task.spawn(function()
        playSound("6667923288", 3)
        task.wait(5)
        playSound("6590357524", 3)
        
        local model = attachModelToTorso("17876272903", character)
        if model then
            task.wait(5)
            model:Destroy()
        end

        local camera = workspace.CurrentCamera
        setCameraFOV(camera, 130, 4)
        task.wait(0.2)
        setCameraFOV(camera, 70, 0.4)

        local effects = createEffects("15170969095", 10, 0.3, 15)
        task.wait(2)
        for _, effect in ipairs(effects) do
            effect:Destroy()
        end

        task.wait(3)
        local bigEffect = game:GetObjects("rbxassetid://17352290656")[1]
        if bigEffect then
            local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
            if torso then
                bigEffect.Parent = torso
                bigEffect.CFrame = torso.CFrame * CFrame.new(0, 32, -1)
                playSound("1841249986", 1)
                task.wait(18)
                bigEffect:Destroy()
            end
        end
    end)

    task.spawn(function()
        task.wait(10)
        applyScreenEffects(4)
    end)

    task.spawn(function()
        local character = player.Character or player.CharacterAdded:Wait()
        local camera = workspace.CurrentCamera
        local tweenService = game:GetService("TweenService")

        local targetFOV = 50
        local originalFOV = camera.FieldOfView
        local zoomTime = 2

        local fovTweenInfo = TweenInfo.new(zoomTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fovTween = tweenService:Create(camera, fovTweenInfo, {FieldOfView = targetFOV})

        local head = character:FindFirstChild("Head") or character:WaitForChild("Head")
        if head then
            camera.CameraType = Enum.CameraType.Scriptable
            local offset = character.HumanoidRootPart.CFrame.LookVector * 10
            local cameraPosition = head.Position + offset
            camera.CFrame = CFrame.new(cameraPosition, head.Position)
        end

        fovTween:Play()
        task.wait(17)
        
        local resetFOVTween = tweenService:Create(camera, fovTweenInfo, {FieldOfView = originalFOV})
        resetFOVTween:Play()

        resetFOVTween.Completed:Connect(function()
            camera.CameraType = Enum.CameraType.Custom
        end)
    end)

    task.spawn(function()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        humanoidRootPart.Anchored = true
        task.wait(17)
        humanoidRootPart.Anchored = false
    end)

    task.spawn(function()
        task.wait(11)
        cameraShake(1, 1)
    end)

    playAnimation("15561810697", 0.2)
    task.wait(33)

    for _, data in pairs(originalTransparency) do
        if data.object and data.object.Parent then
            data.object.Transparency = data.transparency
        end
    end
end)
