ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- PRANJE PARA

RegisterServerEvent('janjusevic:operi_pare')
AddEventHandler('janjusevic:operi_pare', function(amount, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
    local playerPos = GetEntityCoords(GetPlayerPed(source))
    local distance = #(playerPos - Config.Pranje)
    if distance <= 10  then
	    amount = ESX.Math.Round(tonumber(amount))
        lupireket = amount / Config.Reket
	
		if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
            if xPlayer.getInventoryItem('zeton').count > 0 then
                print('proverio')
			    xPlayer.removeAccountMoney('black_money', amount)
			    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('pranje_oprao_si') .. ESX.Math.GroupDigits(amount) .. _U('pranje_prljavih_para') .. _U('pranje_dobio_si') .. ESX.Math.GroupDigits(lupireket) .. _U('pranje_mokrih_para'))

            xPlayer.addInventoryItem("mokrepare", lupireket)
            xPlayer.removeInventoryItem('zeton', 1)
			janjusevic_logovi("Pranje Para  💸", " Igrač  **" ..GetPlayerName(source).. '** je oprao **'  .. ESX.Math.GroupDigits(amount)..'$** prljavih para i dobio **' ..lupireket .. '$** mokrih para │ Posao: **'.. xPlayer.job.label .."** - **" .. xPlayer.job.grade_label .. "**")
            else
                xPlayer.showNotification(_U('notifikacija_protekcija'))
            end
        else
			xPlayer.showNotification(_U('netacan_iznos'))
		end
    else
        if Config.UpaliKick then
            DropPlayer(source, _U('poruka_za_cheatera'))
        end
        print('[ ^1janjusevic_pranjepara^0 ] : Neko je pokusao da koristi skriptu kako bi cheatovao!')
        janjusevic_logovi("Upozorenje ❌", "Neko je pokusao da koristi skriptu kako bi **cheatovao**!")
    end
	
end)

-- SUSENJE PARA

RegisterServerEvent('janjusevic:osusi_pare')
AddEventHandler('janjusevic:osusi_pare', function()
local xPlayer = ESX.GetPlayerFromId(source)
local mokrepare = xPlayer.getInventoryItem('mokrepare').count
local playerPos = GetEntityCoords(GetPlayerPed(source))
local distance = #(playerPos - Config.Susenje)
if distance <= 10  then
    if xPlayer.getInventoryItem('zeton').count > 0 then
	    xPlayer.removeInventoryItem('mokrepare', mokrepare)
	    xPlayer.addMoney(mokrepare)
        xPlayer.removeInventoryItem('zeton', 1)
        xPlayer.showNotification(_U('susenje_osusio_si').. mokrepare .. _U('susenje_dobio_si').. mokrepare .. _U('susenje_suvih_para'))
        janjusevic_logovi("Susenje Para  💸", " Igrač  **" ..GetPlayerName(source).. '** je osusio **' .. mokrepare .. '$** mokrih para │ Posao: **'.. xPlayer.job.label .."** - **" .. xPlayer.job.grade_label .. "**")
    else
        xPlayer.showNotification(_U('notifikacija_protekcija'))
    end
else
    if Config.UpaliKick then
        DropPlayer(source, _U('poruka_za_cheatera'))
    end
    print('[ ^1janjusevic_pranjepara^0 ] : Neko je pokusao da koristi skriptu kako bi cheatovao!')
    janjusevic_logovi("Upozorenje ❌", "Neko je pokusao da koristi skriptu kako bi **cheatovao**!")
end

end)

-- PRODAJA ZETONA

RegisterServerEvent('janjusevic:prodaja_zetona')
AddEventHandler('janjusevic:prodaja_zetona', function()
local xPlayer = ESX.GetPlayerFromId(source)
local playerPos = GetEntityCoords(GetPlayerPed(source))
local distance = #(playerPos - Config.Zetoni)
if distance <= 10  then
    if (xPlayer.getMoney() >= Config.CenaZetona) then
        xPlayer.addInventoryItem('zeton', 1)    
        xPlayer.removeMoney(Config.CenaZetona)
        xPlayer.showNotification(_U('notifikacija_kupio_zeton') ..Config.CenaZetona .. '~s~$.')
        janjusevic_logovi('Kupovina Zetona 💳', 'Igrač **' .. GetPlayerName(source) .. '** je kupio Zeton za **' ..Config.CenaZetona .. '$** | Posao: **'.. xPlayer.job.label .."** - **" .. xPlayer.job.grade_label .. "**")
    else
        xPlayer.showNotification(_U('nema_para_zeton'))
    end
else
    
    if Config.UpaliKick then
        DropPlayer(source, _U('poruka_za_cheatera'))
    end
    print('[ ^1janjusevic_pranjepara^0 ] : Neko je pokusao da koristi skriptu kako bi cheatovao!')
    janjusevic_logovi("Upozorenje ❌", "Neko je pokusao da koristi skriptu kako bi **cheatovao**!")
end
end)

-- CALL BACKOVI ZA PROVERE

ESX.RegisterServerCallback("janjusevic:imalipare",function(source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('black_money').money  > 0 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("janjusevic:imalimokrepare",function(source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem('mokrepare').count > 0 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("janjusevic:imalizeton",function(source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem('zeton').count > 0 then
        cb(true)
    else
        cb(false)
    end
end)

-- DISCORD LOGOVI

function janjusevic_logovi(name, message)
    local vrijeme = os.date('*t')
    local poruka = {
        {
            ["color"] = color,
            ["title"] = "".. name .."",
            ["description"] = message,
            ["footer"]=  {
            ["text"]= "Logovi za pranje/susenje novca na lokaciji.\nVreme: " .. vrijeme.hour .. ":" .. vrijeme.min .. ":" .. vrijeme.sec,
            },
        }
      }
      if message == nil or message == '' then return FALSE end
    PerformHttpRequest(Config.WebHuk, function(err, text, headers) end, 'POST', json.encode({username = Config.ImeBota, embeds = poruka, avatar_url = Config.Ikonica }), { ['Content-Type'] = 'application/json' })
end