local time = 7000

RegisterCommand('me', function(source, args)                                                       -- Set the command that you want to use /me / example: RegisterCommand('NEWCOMMAND', function(source, args)   
    local text = '*'
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' * '
    TriggerServerEvent('3dme:shareDisplay', text)
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source, duration)
    Display(GetPlayerFromServerId(source), text, duration or 7000)
end)

function Display(mePlayer, text, duration)
    local displaying = true
    if chatMessage then
        local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
        local coords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist2(coordsMe, coords)
        if dist < 2500 then
            TriggerEvent('chat:addMessage', {
                color = { color.r, color.g, color.b },
                multiline = true,
                args = { text }
            })
        end
    end
    Citizen.CreateThread(function()
        Wait(duration or 7000) 
        displaying = false
    end)
    Citizen.CreateThread(function()
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 25 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+1.0, text)
            end
        end
    end)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())  
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if onScreen then
    	SetTextScale(0.30, 0.30)                                                                         -- Set the text size
  		SetTextFontForCurrentCommand(1)
          SetTextColor(255, 255, 255, 100) -- Blanc (R: 255, G: 255, B: 255, A: 100)
    	SetTextCentre(1)
    	DisplayText(str,_x,_y)
    	local factor = (string.len(text)) / 225
        DrawSprite("feeds", "toast_bg", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 20, 20, 20, 200, 0)      -- Set the text background theme here
    end
end
