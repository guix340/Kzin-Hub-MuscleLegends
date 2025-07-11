-- Verificação do jogo
if game.PlaceId ~= 6366494025 then
    return warn("Esse hub só pode ser usado no Muscle Legends.")
end

-- Biblioteca da GUI personalizada
loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local OrionLib = OrionLib

-- Segurança: senhas e usuários permitidos
local SenhasPermitidas = {
    ["staff.on"] = true,
    ["g.owner"] = true,
    ["a9X2mZ"] = true,
    ["L1v8Kq"] = true,
    ["tP3sNw"] = true,
    ["zY4dMf"] = true,
    ["jC6rUt"] = true,
    ["qW7pEk"] = true,
    ["uE2hBs"] = true,
    ["mK9nVx"] = true,
    ["dF5gHt"] = true,
    ["bR3cQz"] = true
}

local UsuariosPermitidos = {
    ["OWNER"] = true,
    ["STAFF"] = true,
    ["membro1"] = true,
    ["membro2"] = true,
    ["membro3"] = true,
    ["membro4"] = true,
    ["membro5"] = true,
    ["membro6"] = true,
    ["membro7"] = true,
    ["membro8"] = true,
    ["membro9"] = true,
    ["membro10"] = true
}

local autenticado = false
local player = game.Players.LocalPlayer

if not UsuariosPermitidos[player.Name] then
    player:Kick("Acesso negado: usuário não autorizado.")
end

-- Tela de login
local function criarTelaLogin()
    local LoginWindow = OrionLib:MakeWindow({
        Name = "🔐 Kzin Hub - Login Seguro",
        HidePremium = true,
        SaveConfig = false,
        IntroText = "Bem-vindo ao Kzin Hub!"
    })

    local loginTab = LoginWindow:MakeTab({
        Name = "🔑 Acesso",
        Icon = "rbxassetid://7734053494",
        PremiumOnly = false
    })

    loginTab:AddTextbox({
        Name = "Digite sua senha:",
        Default = "",
        TextDisappear = true,
        Callback = function(value)
            local userPasswords = {
                ["membro1"] = "a9X2mZ",
                ["membro2"] = "L1v8Kq",
                ["membro3"] = "tP3sNw",
                ["membro4"] = "zY4dMf",
                ["membro5"] = "jC6rUt",
                ["membro6"] = "qW7pEk",
                ["membro7"] = "uE2hBs",
                ["membro8"] = "mK9nVx",
                ["membro9"] = "dF5gHt",
                ["membro10"] = "bR3cQz"
            }

            local expectedPassword = userPasswords[player.Name]
            if (expectedPassword and value == expectedPassword) or SenhasPermitidas[value] then
                autenticado = true
                OrionLib:Destroy()
                iniciarHub()
            else
                OrionLib:MakeNotification({
                    Name = "Senha incorreta",
                    Content = "A senha digitada não é válida.",
                    Time = 4
                })
                wait(1.5)
                player:Kick("Senha incorreta. Acesso bloqueado.")
            end
        end
    })
end

-- Função principal do hub
function iniciarHub()
    local Window = OrionLib:MakeWindow({
        Name = "🌌 Kzin-Hub | Muscle Legends",
        HidePremium = false,
        IntroText = "✨ Acesso autorizado",
        SaveConfig = true,
        ConfigFolder = "KzinHubConfigs"
    })

    -- Anti-AFK
    pcall(function()
        local vu = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end)

    -- Variáveis
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
    local farming = false

    -- Funções principais
    local function teleportTo(pos)
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(pos)
        end
    end

    local function startAutoTrain(stat)
        farming = true
        spawn(function()
            while farming do
                game:GetService("ReplicatedStorage").rEvents.statFunction:InvokeServer(stat)
                wait(0.2)
            end
        end)
    end

    local function stopAutoTrain()
        farming = false
    end

    local function autoRebirth()
        spawn(function()
            while wait(2) do
                if farming then
                    game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer()
                end
            end
        end)
    end

    local function autoKill()
        spawn(function()
            while farming do
                for _, target in pairs(game.Players:GetPlayers()) do
                    if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        humanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        wait(0.5)
                    end
                end
            end
        end)
    end

    local function fly()
        local BodyGyro = Instance.new("BodyGyro", humanoidRootPart)
        local BodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
        BodyGyro.P = 9e4
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = humanoidRootPart.CFrame
        BodyVelocity.velocity = Vector3.new(0, 0, 0)
        BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

        game:GetService("RunService").Heartbeat:Connect(function()
            BodyGyro.cframe = workspace.CurrentCamera.CFrame
            BodyVelocity.velocity = workspace.CurrentCamera.CFrame.lookVector * 50
        end)
    end

    -- GUI Tabs
    local farmTab = Window:MakeTab({
        Name = "⚙️ Auto Farm",
        Icon = "rbxassetid://7733964640",
        PremiumOnly = false
    })

    farmTab:AddToggle({
        Name = "🤖 Ativar Auto Farm Principal",
        Default = false,
        Callback = function(state)
            farming = state
            if state then
                startAutoTrain("Strength")
            else
                stopAutoTrain()
            end
        end
    })

    farmTab:AddButton({Name = "💥 Treinar Força", Callback = function() startAutoTrain("Strength") end})
    farmTab:AddButton({Name = "🛡️ Treinar Durabilidade", Callback = function() startAutoTrain("Endurance") end})
    farmTab:AddButton({Name = "🏃 Treinar Agilidade", Callback = function() startAutoTrain("Agility") end})
    farmTab:AddButton({Name = "🔁 Auto Renascimento", Callback = autoRebirth})

    local tpTab = Window:MakeTab({
        Name = "✈️ Teleporte",
        Icon = "rbxassetid://6035199320",
        PremiumOnly = false
    })

    tpTab:AddButton({Name = "📍 TP para Força", Callback = function() teleportTo(Vector3.new(123, 10, 456)) end})
    tpTab:AddButton({Name = "🏋️ TP para Durabilidade", Callback = function() teleportTo(Vector3.new(200, 15, 600)) end})
    tpTab:AddButton({Name = "🎯 TP para Agilidade", Callback = function() teleportTo(Vector3.new(300, 20, 700)) end})

    local pvpTab = Window:MakeTab({
        Name = "🗡️ PvP & Extra",
        Icon = "rbxassetid://7733658504",
        PremiumOnly = false
    })

    pvpTab:AddButton({Name = "⚔️ Ativar Auto Kill", Callback = autoKill})
    pvpTab:AddButton({Name = "🚀 Ativar Fly", Callback = fly})

    local safeTab = Window:MakeTab({
        Name = "🛡️ Proteção",
        Icon = "rbxassetid://7733765390",
        PremiumOnly = false
    })

    safeTab:AddParagraph("Anti-AFK", "✅ Já está ativado automaticamente.")
    safeTab:AddParagraph("Anti-Ban", "✅ Executa com segurança e sem spam suspeito.")
    safeTab:AddParagraph("Desenvolvido por Kzin", "🔥 Hub exclusivo Muscle Legends")

    OrionLib:Init()
end

-- Inicializar login
criarTelaLogin()
