fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'pcr_robbery'
author 'tdoc'
description 'Petty crime vehicle robbery — tiered packages, server-rolled loot'
version '1.0.0'

dependencies {
    'ox_core',
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'bl_ui',
    'scully_emotemenu',
}

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

files {
    'shared/config.lua',
    'shared/utils/*.lua',
    'shared/classes/*.lua',
    'modules/*.lua',
    'client/target.lua',
    'client/interaction.lua',
    'client/keybind.lua',
    'client/emote.lua',
    'server/state.lua',
    'server/callbacks.lua',
    'server/exports.lua',
    'data/items.lua',
}
