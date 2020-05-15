ESX = nil
isRegistered = nil
LockOutPlayer = false
isPlayerLockedOut = false
hudDisabled = false
stopThread = false

local positionSet = false
local playerPosition
local cloudOp = 0.02
local mute = true

Citizen.CreateThread(function()
    Citizen.Wait(0)
    
    while isRegistered == nil or isRegistered == false do
        DisableAllControlActions(0)
	Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
			
Citizen.CreateThread(function()
    Citizen.Wait(0)
    
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    if LockOutPlayer == false then
        DisablePlayer()
        LockOutSetup()
        ClearScr()
        LockOutPlayer = true
        hudDisabled = true
    end

    if hudDisabled == true then
        HideHud()
    end
    
    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScr()
    end
    
    if isRegistered == true and stopThread == false then
            TriggerLoadIn()
            stopThread = true
            hudDisabled = false
    end
end)

RegisterNetEvent('esx_identity:ShowFirstNameRegistration')
AddEventHandler('esx_identity:ShowFirstNameRegistration', function()
    isRegistered = false

    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScr()
    end

    ShowFirstNameRegistration()
end)

RegisterNetEvent('esx_identity:ShowLastNameRegistration')
AddEventHandler('esx_identity:ShowLastNameRegistration', function()
    isRegistered = false

    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScr()
    end

    ShowLastNameRegistration()
end)

RegisterNetEvent('esx_identity:ShowDOBRegistration')
AddEventHandler('esx_identity:ShowDOBRegistration', function()
    isRegistered = false

    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScr()
    end

    ShowDOBRegistration()
end)

RegisterNetEvent('esx_identity:ShowSexRegistration')
AddEventHandler('esx_identity:ShowSexRegistration', function()
    isRegistered = false

    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScr()
    end

    ShowSexRegistration()
end)

RegisterNetEvent('esx_identity:ShowHeightRegistration')
AddEventHandler('esx_identity:ShowHeightRegistration', function()
    isRegistered = false
    
    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScr()
    end

    ShowHeightRegistration()
end)

RegisterNetEvent('esx_identity:RegistrationSuccessful')
AddEventHandler('esx_identity:RegistrationSuccessful', function()
    isRegistered = true
end)

function ShowFirstNameRegistration()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'name_registration', {
        title = _U('field_first_name')
    }, function(data, menu)
        local firstName = tostring(data.value)
        if firstName == nil then
            ESX.ShowNotification(_U('first_name_invalid'))
        else
            menu.close()
            TriggerServerEvent('esx_identity:SetFirstName', GetPlayerServerId(PlayerId()), firstName)
            TriggerEvent('esx_identity:ShowLastNameRegistration')
        end
    end, function(data, menu)
        menu.close()
    end)
end

function ShowLastNameRegistration()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'name_registration', {
        title = _U('field_last_name')
    }, function(data, menu)
        local lastName = tostring(data.value)
        if lastName == nil then
            ESX.ShowNotification(_U('last_name_invalid'))
        else
            menu.close()
            TriggerServerEvent('esx_identity:SetLastName', GetPlayerServerId(PlayerId()), lastName)
            TriggerEvent('esx_identity:ShowDOBRegistration')
        end
    end, function(data, menu)
        menu.close()
    end)
end

function ShowDOBRegistration()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dob_registration', {
        title = _U('field_dob')
    }, function(data, menu)
        local dob = tostring(data.value)
        if dob == nil then
            ESX.ShowNotification(_U('dob_invalid'))
        else
            menu.close()
            TriggerServerEvent('esx_identity:SetDOB', GetPlayerServerId(PlayerId()), dob)
            TriggerEvent('esx_identity:ShowSexRegistration')
        end
    end, function(data, menu)
        menu.close()
    end)
end

function ShowSexRegistration()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sex_registration', {
        title = _U('field_sex')
    }, function(data, menu)
        local sexValue = tostring(data.value)

        if sex == 'm' or sex == 'M' or sex == 'Male' or sex == 'male' then
            sexValue = 'm'
        else
            sexValue = 'f'
        end

        if sexValue == nil then
            ESX.ShowNotification(_U('sex_invalid'))
        else
            menu.close()
            TriggerServerEvent('esx_identity:SetSex', GetPlayerServerId(PlayerId()), sexValue)
            TriggerEvent('esx_identity:ShowHeightRegistration')
        end
    end, function(data, menu)
        menu.close()
    end)
end

function ShowHeightRegistration()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'height_registration', {
        title = _U('field_height')
    }, function(data, menu)
        local height = tostring(data.value)
        if height == nil then
            ESX.ShowNotification(_U('height_invalid'))
        else
            menu.close()
            TriggerLoadIn()
            isRegistered = true
            stopThread = true
            hudDisabled = false
            TriggerServerEvent('esx_identity:SetHeight', GetPlayerServerId(PlayerId()), height)

        end
    end, function(data, menu)
        menu.close()
    end)
end

function HideHud()
    DisplayRadar(false)
    ESX.UI.HUD.SetDisplay(0.0)
    TriggerEvent('es:setMoneyDisplay', 0.0)
    TriggerEvent('esx_status:setDisplay', 0.0)
    TriggerEvent('chat:hideChat')
end

function RestoreHud()
    DisplayRadar(true)
	ESX.UI.HUD.SetDisplay(1.0)
	TriggerEvent('es:setMoneyDisplay', 1.0)
	TriggerEvent('esx_status:setDisplay', 1.0)
    TriggerEvent('esx_voice:IsLoaded')
    TriggerEvent('chat:showChat')
end

function DisablePlayer()
    DisableAllControlActions(0)
    local plyPed = GetPlayerPed(-1)
    FreezeEntityPosition(plyPed, true)
end

function RestorePlayer()
    local plyPed = GetPlayerPed(-1)
    FreezeEntityPosition(plyPed, false)
end

function LockOutSetup()
    -- Disable sound (if configured)
    ToggleSound(mute)
    -- Switch out the player if it isn't already in a switch state.
    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(PlayerPedId(), 0, 1)
    end
end

function ClearScr()
    SetCloudHatOpacity(cloudOp)
end

function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");        
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end

function TriggerLoadIn()
    ClearScr()
    Citizen.Wait(0)
   
    local timer = GetGameTimer()
    
    ToggleSound(false)
    TriggerEvent('esx_skin:playerRegistered')

    while positionSet == false do
        if playerPosition ~= nil then
            SetEntityCoords(PlayerPedId(), playerPosition.x, playerPosition.y, playerPosition.z)
            positionSet = true
        else
            ESX.TriggerServerCallback('esx_identity:getPosition', function(position)
                playerPosition = position
            end)
            Citizen.Wait(1000)
        end
    end


    while true do
        ClearScr()
        Citizen.Wait(0)
        
        if GetGameTimer() - timer > 5000 then  
            SwitchInPlayer(PlayerPedId())   
            ClearScr()
            
            while GetPlayerSwitchState() ~= 12 do
                Citizen.Wait(0)
                ClearScr()
            end

            break
        end
    end 
    
    ClearDrawOrigin()
    RestorePlayer()
    RestoreHud()  
end
