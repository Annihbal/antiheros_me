local VORPcore = exports.vorp_core:GetCore()
local logEnabled = true


local webhookURL = "webhook"
local webhookTitle = "Logs /me Command"
local webhookColor = 3447003 
local webhookName = "Me Command Log"


function GetPlayerFullName(source)
    local User = VORPcore.getUser(source)
    local Character = User.getUsedCharacter
    local firstname = Character.firstname
    local lastname = Character.lastname
    return firstname .. " " .. lastname
end

function GetDiscordName(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "discord:") then
            local discordId = string.gsub(identifier, "discord:", "")
            return "<@!" .. discordId .. ">" 
        end
    end
    return "Discord inconnu"
end

function DiscordLog(message, source)
    if logEnabled then
        local playerName = GetPlayerFullName(source) 
        local discordName = GetDiscordName(source) 
        VORPcore.AddWebhook(
            webhookTitle,
            webhookURL,
            "**Nom :** " .. playerName .. "\n**Discord :** " .. discordName .. "\n**Action :** " .. message,
            webhookColor,
            webhookName,
            "", 
            "", 
            ""  
        )
    end
end

RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, duration)
    local _source = source
    TriggerClientEvent('3dme:triggerDisplay', -1, text, _source, duration)
    local logMessage = os.date("%d/%m/%Y %X") .. " - " .. GetPlayerFullName(_source) .. " : " .. text
    DiscordLog(logMessage, _source)  
end)