fx_version 'adamant'
games { 'gta5' }

description 'Sistem pranja para napravljen za ESX Framework'
author 'Janjusevic'

client_scripts {
	'@es_extended/locale.lua',
	'prevod/rs.lua',
	'config.lua',
	'pranje-cl.lua',
}

server_scripts {
	'@es_extended/locale.lua',
	'prevod/rs.lua',
	'config.lua',
	'pranje-sv.lua'
}
