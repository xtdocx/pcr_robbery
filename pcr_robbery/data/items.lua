-- Copy these entries into your ox_inventory `data/items.lua`.
-- The client block uses ox_inventory's built-in usetime/anim/prop, so the
-- progress bar and animation are handled there. On completion, ox_inventory
-- calls this resource's `usePackage` server export, which rolls server-side
-- loot and (on success) consumes the item.

return {
    ['package_common'] = {
        label       = 'Common Package',
        weight      = 500,
        stack       = true,
        close       = true,
        description = 'Loose change and odds and ends.',
        client = {
            anim         = { dict = 'mp_common', clip = 'givetake1_a' },
            prop         = { model = `prop_cs_package_01`, pos = vec3(0.12, 0.0, 0.05), rot = vec3(0.0, 0.0, 0.0) },
            usetime      = 4000,
            cancel       = true,
            notification = 'Opening package…',
        },
        server = {
            export = 'pcr_robbery.usePackage',
        },
    },

    ['package_mid'] = {
        label       = 'Mid-Tier Package',
        weight      = 750,
        stack       = true,
        close       = true,
        description = 'Looks like there might be something useful inside.',
        client = {
            anim         = { dict = 'mp_common', clip = 'givetake1_a' },
            prop         = { model = `prop_cs_package_01`, pos = vec3(0.12, 0.0, 0.05), rot = vec3(0.0, 0.0, 0.0) },
            usetime      = 4500,
            cancel       = true,
            notification = 'Opening package…',
        },
        server = {
            export = 'pcr_robbery.usePackage',
        },
    },

    ['package_rare'] = {
        label       = 'Rare Package',
        weight      = 1000,
        stack       = true,
        close       = true,
        description = 'Heavy. Whatever\'s inside is worth real money.',
        client = {
            anim         = { dict = 'mp_common', clip = 'givetake1_a' },
            prop         = { model = `prop_cs_package_01`, pos = vec3(0.12, 0.0, 0.05), rot = vec3(0.0, 0.0, 0.0) },
            usetime      = 5000,
            cancel       = true,
            notification = 'Opening package…',
        },
        server = {
            export = 'pcr_robbery.usePackage',
        },
    },

    ['package_illegal'] = {
        label       = 'Suspicious Package',
        weight      = 1200,
        stack       = true,
        close       = true,
        description = 'You probably don\'t want to be holding this in public.',
        client = {
            anim         = { dict = 'mp_common', clip = 'givetake1_a' },
            prop         = { model = `prop_cs_package_01`, pos = vec3(0.12, 0.0, 0.05), rot = vec3(0.0, 0.0, 0.0) },
            usetime      = 6000,
            cancel       = true,
            notification = 'Opening package…',
        },
        server = {
            export = 'pcr_robbery.usePackage',
        },
    },
}
