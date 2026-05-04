local CONFIG = {}

-- Item names used by ox_inventory for each package tier.
CONFIG.packageItems = {
    common  = 'package_common',
    mid     = 'package_mid',
    rare    = 'package_rare',
    illegal = 'package_illegal',
}

-- Interaction tuning.
CONFIG.fenceDistance        = 2.5
CONFIG.searchKeyDefault     = 'M'
CONFIG.searchKeyDescription = 'Search the vehicle you are sitting in'

-- scully_emotemenu command name played while opening a package.
CONFIG.openPackageEmote = 'box'

-- bl_ui skillcheck tuning. See https://docs.byte-labs.net/bl_ui/games
CONFIG.skillCheck = {
    iterations = 3,
    difficulty = 50,
}

-- Probability of a package being empty when opened (per tier).
-- Set to 0 across the board so a successful search guarantees loot.
CONFIG.emptyPackageChance = {
    common  = 0.0,
    mid     = 0.0,
    rare    = 0.0,
    illegal = 0.0,
}

-- Number of rewards rolled per package (inclusive).
CONFIG.rewardsPerPackage = {
    common  = { min = 1, max = 2 },
    mid     = { min = 1, max = 2 },
    rare    = { min = 1, max = 3 },
    illegal = { min = 2, max = 3 },
}

-- Optional cash range per package tier.
CONFIG.cashRange = {
    common  = { min = 5,   max = 30  },
    mid     = { min = 25,  max = 100 },
    rare    = { min = 100, max = 350 },
    illegal = { min = 250, max = 800 },
}

-- Police alert chance per tier (0.0 - 1.0). Illegal always alerts.
CONFIG.alertChance = {
    common  = 0.05,
    mid     = 0.20,
    rare    = 0.50,
    illegal = 1.00,
}

-- Vehicle class -> package tier weights.
-- Class IDs follow GTA's vehicle class enum (0..22).
CONFIG.classWeights = {
    [0]  = { common = 70, mid = 25, rare = 4,  illegal = 1  }, -- Compacts
    [1]  = { common = 60, mid = 30, rare = 8,  illegal = 2  }, -- Sedans
    [2]  = { common = 55, mid = 30, rare = 12, illegal = 3  }, -- SUVs
    [3]  = { common = 50, mid = 35, rare = 12, illegal = 3  }, -- Coupes
    [4]  = { common = 40, mid = 35, rare = 20, illegal = 5  }, -- Muscle
    [5]  = { common = 30, mid = 35, rare = 25, illegal = 10 }, -- Sports Classics
    [6]  = { common = 25, mid = 35, rare = 30, illegal = 10 }, -- Sports
    [7]  = { common = 15, mid = 25, rare = 45, illegal = 15 }, -- Super
    [9]  = { common = 50, mid = 30, rare = 15, illegal = 5  }, -- Off-road
    [10] = { common = 20, mid = 35, rare = 25, illegal = 20 }, -- Industrial
    [11] = { common = 15, mid = 30, rare = 25, illegal = 30 }, -- Utility
    [12] = { common = 25, mid = 40, rare = 20, illegal = 15 }, -- Vans
    [17] = { common = 10, mid = 25, rare = 30, illegal = 35 }, -- Service
    [18] = { common = 5,  mid = 15, rare = 30, illegal = 50 }, -- Emergency
}

CONFIG.defaultClassWeights = { common = 70, mid = 25, rare = 4, illegal = 1 }

-- Loot tables. `chance` is a relative weight for the per-roll pick.
-- `jackpot = true` flags ultra-rare items for special UX.
CONFIG.lootTables = {
    common = {
        { item = 'water',     qty = { min = 1, max = 2 }, chance = 40 },
        { item = 'sandwich',  qty = { min = 1, max = 2 }, chance = 35 },
        { item = 'lighter',   qty = { min = 1, max = 1 }, chance = 25 },
        { item = 'rolling_paper', qty = { min = 1, max = 5 }, chance = 30 },
        { item = 'phone',         qty = { min = 1, max = 1 }, chance = 5  },
    },
    mid = {
        { item = 'phone',         qty = { min = 1, max = 1 }, chance = 25 },
        { item = 'gold_coin',     qty = { min = 1, max = 2 }, chance = 30 },
        { item = 'racing_tablet', qty = { min = 1, max = 1 }, chance = 10 },
        { item = 'gun_parts',     qty = { min = 1, max = 3 }, chance = 35 },
        { item = 'rolex',         qty = { min = 1, max = 1 }, chance = 3, jackpot = true },
    },
    rare = {
        { item = 'goldchain', qty = { min = 1, max = 1 }, chance = 20 },
        { item = 'laptop',    qty = { min = 1, max = 1 }, chance = 25 },
        { item = 'rolex',     qty = { min = 1, max = 1 }, chance = 10 },
        { item = 'gun_parts', qty = { min = 2, max = 4 }, chance = 30 },
        { item = 'diamond',   qty = { min = 1, max = 1 }, chance = 5,  jackpot = true },
    },
    illegal = {
        { item = 'weed_brick',    qty = { min = 1, max = 3  }, chance = 25 },
        { item = 'cokebaggy',     qty = { min = 1, max = 2  }, chance = 20 },
        { item = 'WEAPON_PISTOL', qty = { min = 1, max = 1  }, chance = 10 },
        { item = 'ammo-9',        qty = { min = 5, max = 30 }, chance = 30 },
        { item = 'goldbar',       qty = { min = 1, max = 1  }, chance = 5, jackpot = true },
    },
}

-- Sell prices for unopened packages.
CONFIG.sellPrice = {
    common  = { min = 30,  max = 60  },
    mid     = { min = 80,  max = 160 },
    rare    = { min = 200, max = 400 },
    illegal = { min = 350, max = 700 },
}

-- Fence location where players can sell unopened packages.
CONFIG.fence = {
    coords  = vector3(708.39, -966.31, 30.39),
    heading = 0.0,
    size    = vector3(1.5, 1.5, 2.0),
}

-- Notification payloads per tier (lib.notify-compatible).
CONFIG.notifications = {
    common  = { type = 'inform',  title = 'Loose Change', description = 'You found a stash of cheap goods.' },
    mid     = { type = 'inform',  title = 'Decent Find',  description = 'Some valuables in here.'           },
    rare    = { type = 'success', title = 'Score!',       description = 'This is worth real money.'         },
    illegal = { type = 'warning', title = 'Hot Goods',    description = 'Get rid of this before someone notices.' },
    empty   = { type = 'error',   title = 'Empty',        description = 'Nothing of value inside.'          },
    jackpot = { type = 'success', title = 'JACKPOT',      description = 'You found something extraordinary.' },
    alerted = { type = 'warning', title = 'Spotted',      description = 'Someone called the police.'        },
    fence   = { type = 'success', title = 'Fence',        description = 'Cash exchanged for goods.'         },
}

-- Police alert payload. Bind the `pcr_robbery:server:dispatchedAlert`
-- event in your dispatch resource to consume this.
CONFIG.alert = {
    title        = 'Vehicle Break-In',
    blipSprite   = 161,
    blipColor    = 1,
    blipDuration = 60,
}

-- Logger verbosity: 'DEBUG' | 'INFO' | 'WARN' | 'ERROR'
CONFIG.logLevel = 'INFO'

return CONFIG
