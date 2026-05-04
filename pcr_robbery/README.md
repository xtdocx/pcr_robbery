# pcr_robbery

Petty-crime vehicle robbery for FiveM. While seated in any stationary vehicle, press a key to run a skillcheck minigame and receive a tiered "package" item. Open the package later to roll random loot, with higher-tier packages dropping more valuable contents and a higher chance of pinging police.

## Features

- In-vehicle search triggered by a rebindable keybind (default `M`).
- bl_ui `CircleProgress` skillcheck during the search; package drop is guaranteed regardless of result.
- Four package tiers (`common`, `mid`, `rare`, `illegal`) selected by weighted random keyed on vehicle class.
- Server-side loot tables per tier with weighted item rolls, optional cash, jackpot flags, and per-tier police alert chance.
- scully_emotemenu emote played for the duration of the open progress bar.
- Vehicles can only be searched once (tracked via statebag and a server-side set; cleared on entity removal).
- ox_target fence zone for selling unopened packages.
- Strict OOP / module separation, `lib.callback` for RPC, fully config-driven.

## Dependencies

| Resource | Purpose |
| --- | --- |
| [ox_core](https://github.com/communityox/ox_core) | Player framework. |
| [ox_lib](https://github.com/communityox/ox_lib) | `lib.class`, `lib.callback`, `lib.notify`, `lib.addKeybind`, `lib.registerContext`. |
| [ox_target](https://github.com/communityox/ox_target) | Fence zone target option. |
| [ox_inventory](https://github.com/communityox/ox_inventory) | Item registration, use animation/usetime, `server.export` hook. |
| [bl_ui](https://docs.byte-labs.net/bl_ui) | Skillcheck minigames. |
| [scully_emotemenu](https://github.com/Scullyy/scully_emotemenu) | Emote played during package opening. |

All loot items referenced in `shared/config.lua` must exist in your ox_inventory items list. The default config uses standard ox_inventory item names (`water`, `sandwich`, `phone`, `lighter`, `rolling_paper`, `gold_coin`, `racing_tablet`, `gun_parts`, `rolex`, `goldchain`, `laptop`, `diamond`, `weed_brick`, `cokebaggy`, `WEAPON_PISTOL`, `ammo-9`, `goldbar`, `money`).

## Installation

### 1. Drop the resource

Clone or extract this folder into your `resources/` tree. Bracketed parent folders work too:

```
resources/[illusion]/pcr_robbery/
```

### 2. Add the four package items to ox_inventory

Open `ox_inventory/data/items.lua` and append the entries from `pcr_robbery/data/items.lua` before the closing `}` of the returned table. The shape is:

```lua
['package_common'] = {
    label = 'Common Package',
    weight = 500,
    stack = true,
    close = true,
    useable = true,
    description = 'Loose change and odds and ends.',
    client = {
        usetime = 4000,
        cancel = true,
        notification = 'Opening package…',
    },
    server = { export = 'pcr_robbery.usePackage' },
},
```

Repeat for `package_mid`, `package_rare`, `package_illegal`. The `server.export` line is what wires the loot roll back into this resource — leave the value `'pcr_robbery.usePackage'`.

### 3. Add to server.cfg

`pcr_robbery` depends on `ox_core`, `ox_lib`, `ox_target`, `ox_inventory`, `bl_ui`, and `scully_emotemenu`. Make sure all are started **before** `pcr_robbery`. If any of those live in a bracket folder ensured later (common with `[standalone]`), add an explicit `ensure` for them earlier:

```
ensure ox_core
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure bl_ui
ensure scully_emotemenu
ensure pcr_robbery
```

### 4. (Optional) Hook up your dispatch resource

Higher-tier packages roll a chance to alert police when opened. The alert is broadcast as:

```
TriggerEvent('pcr_robbery:server:dispatchedAlert', {
    coords       = vector3,
    tier         = 'common' | 'mid' | 'rare' | 'illegal',
    title        = string,
    blipSprite   = integer,
    blipColor    = integer,
    blipDuration = integer,
})
```

Bind that event in your dispatch resource (ps-dispatch, cd_dispatch, ox_dispatch, etc.) to forward it to police. If you skip this step, alerts fire harmlessly into the void.

### 5. Restart

```
refresh
restart ox_inventory
ensure pcr_robbery
```

## Configuration

Everything tunable lives in [shared/config.lua](shared/config.lua):

- `packageItems` — tier → ox_inventory item name mapping.
- `searchKeyDefault` — default keybind (player can rebind in FiveM keybinds menu).
- `skillCheck` — bl_ui CircleProgress iterations and difficulty.
- `emptyPackageChance` — chance of an opened package being empty (defaults to 0).
- `rewardsPerPackage` — min/max items rolled per open.
- `cashRange` — min/max cash per open.
- `alertChance` — police alert probability per tier.
- `classWeights` / `defaultClassWeights` — per–vehicle-class tier distribution.
- `lootTables` — per-tier item pools with weighted chances and `jackpot` flags.
- `sellPrice` — fence payout range per tier.
- `fence` — coords / heading / box size for the sell zone.
- `notifications` — `lib.notify` payloads per outcome.
- `openPackageEmote` — scully_emotemenu command name (default `box`).
- `logLevel` — `DEBUG | INFO | WARN | ERROR`.

## Usage (player guide)

1. Get into any vehicle (driver or passenger seat).
2. Bring it to a complete stop.
3. Press `M`.
4. Complete the bl_ui skillcheck (or fail / cancel it — the package drops either way).
5. A `package_<tier>` item appears in your inventory.
6. Right-click the package → Use. The emote plays for the duration of the progress bar; on completion, loot rolls into your inventory.
7. Sell unopened packages at the fence (default `vector3(708.39, -966.31, 30.39)`).

A vehicle can only be searched once — its statebag is flipped and the option disappears for everyone.

## Architecture notes

```
shared/
  classes/    OOP classes (Package, LootTable) using lib.class
  utils/      Pure helpers (weighted_random, vehicle_state, logger)
  config.lua  Single source of truth for tuning
modules/      Server-side business logic (package_assignment, package_registry,
              robbery_service, inventory_bridge, cash_service, alert_system,
              player_service, notification_service)
client/       UI / interaction (target, keybind, interaction, emote)
server/       Bootstrap, state, lib.callback registrations, ox_inventory exports
data/         Reference items.lua to copy into ox_inventory
```

All RPC goes through `lib.callback`. All loot generation runs server-side. Vehicle state is tracked both via entity statebag (so clients can hide UI for already-robbed cars) and a server-side set (the source of truth for validation).

## License

MIT. Use it, fork it, ship it.
