fx_version 'adamant'
games { 'gta5' }

description 'Developer: Janjusevic Discord: Janjusevic#0001'
version '0.1.2'

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
	'pranje-sv.lua',
	'version.lua'

}

dependencies {

    'es_extended',

}