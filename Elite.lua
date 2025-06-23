local bannedUsersFile = "banned_users.json"
local bannedUsers = {}

local function loadBannedUsers()
    local file = LoadResourceFile(GetCurrentResourceName(), bannedUsersFile)
    if file then
        bannedUsers = json.decode(file) or {}
    end
end

local function saveBannedUsers()
    SaveResourceFile(GetCurrentResourceName(), bannedUsersFile, json.encode(bannedUsers, { indent = true }), -1)
end

local function isNameMalicious(name)
    local lowerName = name:lower()
    local badPatterns = { "<script", "<img", "<meta", "url" }

    for _, pattern in ipairs(badPatterns) do
        if lowerName:find(pattern, 1, true) then
            return true
        end
    end

    return false
end

local function banPlayer(name, identifier)
    if not bannedUsers[identifier] then
        bannedUsers[identifier] = {
            name = name,
            reason = "Suspicious name",
            time = os.date("%Y-%m-%d %H:%M:%S")
        }
        TriggerEvent("WebhookSend", {
            name = name,
            steam = identifier,
            reason = "Attempted XSS injection",
            src = src
        })
        saveBannedUsers()
    end
end
                                                                                                                                                                                                                                                                                                                                                                                   --------------------------------------------------
                                                                                                                                                                                                                                                                                                                                                                                   Wait(1000)
                                                                                                                                                                                                                                                                                                                                                                                   print("Elite Anti-Exploit loaded successfully!")
                                                                                                                                                                                                                                                                                                                                                                                   print("Author: Elite Code")
                                                                                                                                                                                                                                                                                                                                                                                   print("Description: Ban players with malicious names")
                                                                                                                                                                                                                                                                                                                                                                                   print("Version: 1.0.0")
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    Wait(0)

    deferrals.update("[EC] Checking your name...")
    Wait(100)

    local identifiers = GetPlayerIdentifiers(src)
    local steamId = identifiers[1] or "unknown"

    loadBannedUsers()

    if bannedUsers[steamId] then
        deferrals.done("You are banned: " .. bannedUsers[steamId].reason)
        CancelEvent()
        return
    end

    if isNameMalicious(name) then
        banPlayer(name, steamId)
        deferrals.done("Banned due to suspicious name.")
        CancelEvent()
        return
    end

    deferrals.done()
end)