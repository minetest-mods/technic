
Technic
-----------------

A mod for [minetest](http://www.minetest.net)

![](https://github.com/pandorabox-io/technic/workflows/integration-test/badge.svg)


# Overview

This is a maintained fork of https://github.com/minetest-mods/technic with various enhancements.
Suitable for multiplayer environments.

* chainsaw re-implementation (@OgelGames)
* Switching station lag/polyfuse and globalstep execution (@BuckarooBanzay)
* No forceload hacks
* Additional HV machines (furnace, grinder, thx to @h-v-smacker)
* various others...

# Recommended mods

Recommended mods that build on the `technic mod`:

* https://github.com/mt-mods/jumpdrive
* https://github.com/OgelGames/powerbanks

# Settings

* **technic.quarry.quota** per-player and second quarry dig limit (default: 10)
* **technic.switch_max_range** max cable length (default: 256)
* **technic.switch.off_delay_seconds** switching station off delay (default: 300 seconds)

# Open issues

* Documentation (markdown)
* Luacheck / testing
* More settings, remove hardcoded values

# Contributors

* kpoppel
* Nekogloop
* Nore/Ekdohibs
* ShadowNinja
* VanessaE
* @BuckarooBanzay
* @OgelGames
* @int-ua
* And many others...

# FAQ

* [Manual](./manual.md)

1. My technic circuit doesn't work.  No power is distributed.
  * A: Make sure you have a switching station connected.

# License

Unless otherwise stated, all components of this modpack are licensed under the
LGPL, V2 or later.  See also the individual mod folders for their
secondary/alternate licenses, if any.
