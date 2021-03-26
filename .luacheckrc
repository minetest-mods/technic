unused_args = false
allow_defined_top = true
max_line_length = 999

globals = {
    "technic", "minetest",
    "srcstack",
}

read_globals = {
    string = {fields = {"split", "trim"}},
    table = {fields = {"copy", "getn"}},

    "intllib", "VoxelArea",
    "default", "stairsplus",

    "PseudoRandom", "ItemStack",
    "mg", "tubelib", "vector",

    "moretrees", "bucket",
    "unified_inventory", "digilines",

    "pipeworks", "screwdriver",
    "VoxelManip", "unifieddyes",

    "Settings", "mesecon",
    "digiline_remote",

    "protector", "isprotect",
    "homedecor_expect_infinite_stacks",
    
    "craftguide",
}

files["concrete/init.lua"].ignore = { "steel_ingot" }
files["technic/machines/MV/tool_workshop.lua"].ignore = { "pos" }
files["technic/machines/other/frames.lua"].ignore = { "item_texture", "item_type", "adj", "connected", "" }
files["technic/machines/register/battery_box.lua"].ignore = { "pos", "tube_upgrade" }
files["technic/machines/register/cables.lua"].ignore = { "name", "from_below", "p" }
files["technic/machines/register/common.lua"].ignore = { "result" }

files["technic/machines/register/generator.lua"].ignore = { "node" }
files["technic/machines/switching_station.lua"].ignore = { "pos1", "tier", "poshash" }
files["technic/radiation.lua"].ignore = { "LAVA_VISC" }
files["technic/tools/chainsaw.lua"].ignore = { "pos" }
files["technic/tools/mining_drill.lua"].ignore = { "mode" }
files["technic_chests/register.lua"].ignore = { "fs_helpers", "name", "locked_after_place" }

files["technic_cnc/cnc.lua"].ignore = { "multiplier" }
files["wrench/init.lua"].ignore = { "name", "stack" }
