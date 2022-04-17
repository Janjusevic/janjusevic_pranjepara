Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

end)

-- CRTANJE TEXTA

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(coords, Config.Pranje, true)

        local letSleep = true
        if distance < 8.0 then
            DrawText3Ds(Config.Pranje.x, Config.Pranje.y, Config.Pranje.z, _U('text_masina_za_pranje'))      
            letSleep = false
			if distance < 1.0 then
            	if IsControlJustPressed(0, 38) and IsPedOnFoot(playerPed) then
					ESX.TriggerServerCallback('janjusevic:imalizeton', function(imazeton)
						if imazeton then
            				PranjePara()
						else 
							ESX.ShowNotification(_U('notifikacija_nema_zeton'))
						end
					end)
            	end
			end

        end
        if letSleep then
            Citizen.Wait(1000)
        end
    end
end)

-- CRTANJE TEXTA

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(coords, Config.Susenje, true)

        local letSleep = true
        if distance < 8.0 then
            DrawText3Ds(Config.Susenje.x, Config.Susenje.y, Config.Susenje.z, _U('text_masina_za_susenje'))    
            letSleep = false
			if distance < 1.0 then
            	if IsControlJustPressed(0, 38) and IsPedOnFoot(playerPed) then
					ESX.TriggerServerCallback('janjusevic:imalizeton', function(imazeton)
						if imazeton then
            				SusenjaPara()
						else 
							ESX.ShowNotification(_U('notifikacija_nema_zeton'))
						end
					end)
            	 end
			end
        end

        if letSleep then
            Citizen.Wait(1000)
        end
    end
end)

-- CRTANJE TEXTA

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(coords, Config.Zetoni, true)

        local letSleep = true
        if distance < 8.0 then
            DrawText3Ds(Config.Zetoni.x, Config.Zetoni.y, Config.Zetoni.z, _U('text_kupovina_zetona'))      
            letSleep = false
			if distance < 1.0 then
            	if IsControlJustPressed(0, 38) and IsPedOnFoot(playerPed) then
					ProdajaZetona()
            	end
			end

        end
        if letSleep then
            Citizen.Wait(1000)
        end
    end
end)

-- PRANJE PARA MENU

function PranjePara(zone)
	local elements = {
		{label = _U('menu_pranja_dole'), 	value = 'wash_money'},
		}
		
		ESX.UI.Menu.CloseAll()
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wash', {
			title		= _U('menu_pranja'),
			align		= 'top-left',
			elements	= elements
		}, function(data, menu)
			if data.current.value == 'wash_money' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_', {
					title = _U('pranje_kolicina')
				}, function(data, menu)
				
					local amount = tonumber(data.value)
					
					if amount == nil then
						ESX.ShowNotification(_U('netacan_iznos'))
					else
						menu.close()
							ESX.TriggerServerCallback('janjusevic:imalipare', function(imapare)
								if imapare then
									TriggerEvent('janjusevic:animacija', Config.DuzinaPranja)
									exports['progressBars']:startUI(Config.DuzinaPranja, _U("progres_peres_pare"))
									Wait(Config.DuzinaPranja)
									DisableAllControlActions(0)
									Wait(100)
									TriggerServerEvent('janjusevic:operi_pare', amount)
									ESX.UI.Menu.CloseAll()
								else
									ESX.ShowNotification(_U('notifikacija_nema_para'))
								end
							end)
					end

				end, function(data, menu)
			
					menu.close()
				end)
			end
			end, function(data, menu)
				menu.close()
				CurrentAction	 = 'wash_menu'
				CurrentActionMsg = _U('press_menu')
				CurrentActionData = {zone = zone}
		end)
end

-- SUSENJE PARA MENU

function SusenjaPara()
    local elements = {}

    table.insert(elements, {label = _U('menu_susenja'), value = 'susenje_para'}) 

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
        title    = _U('menu_susenja_dole'),
        align    = 'bottom-right',
        elements = elements,
    },
    
    
    function(data, menu)

    if data.current.value == 'susenje_para' then

				ESX.TriggerServerCallback('janjusevic:imalimokrepare', function(imamokrepare)
					local vreme = 5000
					if imamokrepare then
						TriggerEvent('janjusevic:animacija', Config.DuzinaSusenja)
						exports['progressBars']:startUI(Config.DuzinaSusenja, _U('progres_susis_pare'))
						Wait(Config.DuzinaSusenja)
        				TriggerServerEvent('janjusevic:osusi_pare')
						ESX.UI.Menu.CloseAll()
					else
						ESX.ShowNotification(_U('notifikacija_nema_mokre'))
					end
			    end)
    end
    ESX.UI.Menu.CloseAll()
    DoScreenFadeOut(1000)
    Citizen.Wait(0)
    DoScreenFadeIn(3000)
    end,
    function(data, menu)
        menu.close()
        end
    )
end

-- PRODAJA ZETONA MENU

function ProdajaZetona()
    local elements = {}

    table.insert(elements, {label = _U('menu_zetoni_dole'), value = 'prodaja_zetona'}) 

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
        title    = _U('menu_zetoni'),
        align    = 'bottom-right',
        elements = elements,
    },
    
    
    function(data, menu)

    if data.current.value == 'prodaja_zetona' then
		TriggerServerEvent('janjusevic:prodaja_zetona')
    end
    ESX.UI.Menu.CloseAll()
    DoScreenFadeOut(1000)
    Citizen.Wait(0)
    DoScreenFadeIn(3000)
    end,
    function(data, menu)
        menu.close()
        end
    )
end

-- ZA SVE (UPDATE 17/04/2022)

RegisterNetEvent('janjusevic:animacija')
AddEventHandler('janjusevic:animacija', function(duzina)
	if not uanimaciji then
		uanimaciji = true
		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			ESX.Streaming.RequestAnimDict('amb@prop_human_bum_bin@base', function()
				FreezeEntityPosition(PlayerPedId(), true)
				TaskPlayAnim(playerPed, 'amb@prop_human_bum_bin@base', 'base', 8.0, -8, -1, 49, 0, 0, 0, 0)
				Citizen.Wait(duzina)
				uanimaciji = false
				FreezeEntityPosition(PlayerPedId(), false)
				ClearPedSecondaryTask(playerPed)
			end)
		end)
	end
end)

-- FUNKCIJA ZA CRTANJE TEXTA

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

-- BLIP

Citizen.CreateThread(function()
	if Config.UpaliBlip then
	blip = AddBlipForCoord(Config.Zetoni)
	SetBlipSprite(blip, 52)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipColour(blip, 81)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Prodaja Zetona")
	EndTextCommandSetBlipName(blip)
	end
end)
