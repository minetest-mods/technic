# Technic

[![Build status](https://github.com/minetest-mods/technic/workflows/Check%20&%20Release/badge.svg)](https://github.com/minetest-mods/technic/actions)
[![License](https://img.shields.io/badge/license-LGPLv2.0%2B-purple.svg)](https://www.gnu.org/licenses/old-licenses/lgpl-2.0.en.html)

This Minetest modpack adds machinery and automation procedure content to your
world. A few notable features:

  * Electric circuits
  * Automated material processing (ores, wood, ...)
  * Extended chest functionalities

## Dependencies

  * Minetest 5.0.0 or newer
  * [Minetest Game](https://github.com/minetest/minetest_game/)
  * [mesecons](https://github.com/minetest-mods/mesecons) -> signalling events
  * [pipeworks](https://gitlab.com/VanessaE/pipeworks/) -> automation of item transport
  * [moreores](https://github.com/minetest-mods/moreores/) -> additional ores
  * [basic_materials](https://gitlab.com/VanessaE/basic_materials) -> basic craft items
  * Supports [moretrees](https://gitlab.com/VanessaE/moretrees) -> rubber trees
  * Consult `depends.txt` or `mod.conf` of each mod for further dependency information.


## FAQ

The modpack is explained in the **[Manual](manual.md)** included in this repository.
Machine and tool descriptions can be found on the **[GitHub Wiki](https://github.com/minetest-mods/technic/wiki)**.

1. My technic circuit doesn't work. No power is distributed.
    * Make sure you have a switching station connected.
2. My wires do not connect to the machines.
    * Each machine type requires its own cable type. If you do not have a
      matching circuit, consider using a "Supply Converter" for simplicity.

For modders: **[Technic Lua API](technic/doc/api.md)**


## License

Unless otherwise stated, all components of this modpack are licensed under the
[LGPLv2 or later](LICENSE.txt). See also the individual mod folders for their
secondary/alternate licenses, if any.


### Credits

Contributors in alphabetical order:

  * kpoppel
  * Nekogloop
  * Nore/Ekdohibs
  * ShadowNinja
  * VanessaE
  * And many others...
