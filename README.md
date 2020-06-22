
Technic
-----------------

A mod for [minetest](http://www.minetest.net)

![](https://github.com/mt-mods/technic/workflows/integration-test/badge.svg)
![](https://github.com/mt-mods/technic/workflows/luacheck/badge.svg)
[![License](https://img.shields.io/badge/license-LGPLv2.0%2B-purple.svg)](https://www.gnu.org/licenses/old-licenses/lgpl-2.0.en.html)

# Overview

<img src="./technic/doc/images/Technic Screenshot.png"/>


The technic modpack extends the Minetest game with many new elements,
mainly constructable machines and tools.  It is a large modpack, and
tends to dominate gameplay when it is used.  This manual describes how
to use the technic modpack, mainly from a player's perspective.

The technic modpack depends on some other modpacks:

*   the basic Minetest game
*   mesecons, which supports the construction of logic systems based on
    signalling elements
*   pipeworks, which supports the automation of item transport
*   moreores, which provides some additional ore types
*   basic_materials, which provides some basic craft items

This manual doesn't explain how to use these other modpacks, which have
their own manuals:

*   [Minetest Game Documentation](https://wiki.minetest.net/Main_Page)
*   [Mesecons Documentation](http://mesecons.net/items.html)
*   [Pipeworks Documentation](https://gitlab.com/VanessaE/pipeworks/-/wikis/home)
*   [Moreores Forum Post](https://forum.minetest.net/viewtopic.php?t=549)
*   [Basic materials Repository](https://gitlab.com/VanessaE/basic_materials)

Recipes for constructable items in technic are generally not guessable,
and are also not specifically documented here.  You should use a
craft guide mod to look up the recipes in-game.  For the best possible
guidance, use the unified\_inventory mod, with which technic registers
its specialised recipe types.

# Documentation

Ingame:
* [Resources](./technic/doc/resources.md)
* [Substances](./technic/doc/substances.md)
* [Processes](./technic/doc/processes.md)
* [Chests](./technic/doc/chests.md)
* [Radioactivity](./technic/doc/radioactivity.md)
* [Electrical power](./technic/doc/power.md)
* [Powered machines](./technic/doc/machines.md)
* [Generators](./technic/doc/generators.md)
* [Forceload anchor](./technic/doc/anchor.md)
* [Digilines](./technic/doc/digilines.md)
* [Mesecons](./technic/doc/mesecons.md)
* [Tools](./technic/doc/tools.md)

Mod development:
* [Api](./technic/doc/api.md)

subjects missing from this manual:
* frames
* templates


## FAQ

1. My technic circuit doesn't work.  No power is distributed.
  * A: Make sure you have a switching station connected.

# Notes

This is a maintained fork of https://github.com/minetest-mods/technic with various enhancements.
Suitable for multiplayer environments.

* chainsaw re-implementation (@OgelGames)
* Switching station lag/polyfuse and globalstep execution (@BuckarooBanzay)
* No forceload hacks
* Additional HV machines (furnace, grinder, thx to @h-v-smacker)
* HV-digiline cables (@S-S-X)
* various others...

## Compatibility

This mod is meant as a **drop-in replacement** for the upstream `technic` mod.
It also provides some additional machines and items, notably:

* HV Grinder
* HV Furnace
* LV Lamp
* HV Digiline cables

# Recommended mods

Dependencies:

* https://github.com/minetest-mods/mesecons
* https://github.com/minetest-mods/moreores
* https://gitlab.com/VanessaE/pipeworks
* https://gitlab.com/VanessaE/basic_materials

Recommended optional Dependencies:

* https://github.com/minetest-mods/digilines

Recommended mods that build on the `technic mod`:

* https://github.com/mt-mods/jumpdrive
* https://github.com/OgelGames/powerbanks

# Settings

* **technic.quarry.maxdepth** max depth of the quarry (default: 100)
* **technic.switch_max_range** max cable length (default: 256)
* **technic.switch.off_delay_seconds** switching station off delay (default: 1800 seconds)
* **technic.radiation.enable_throttling** enable lag- and per-second-trottling of radiation damage

# Chat commands

* **/technic_flush_switch_cache** clears the switching station cache (stops all unloaded switches)
* **/powerctrl [on|off]** enable/disable technic power distribution globally

# Contributors

* kpoppel
* Nekogloop
* Nore/Ekdohibs
* ShadowNinja
* VanessaE
* BuckarooBanzay
* OgelGames
* int-ua
* S-S-X
* H-V-Smacker
* And many others...

# License

Unless otherwise stated, all components of this modpack are licensed under the
LGPL, V2 or later.  See also the individual mod folders for their
secondary/alternate licenses, if any.
