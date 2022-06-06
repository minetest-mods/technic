unused_args = false
allow_defined_top = true
max_line_length = 150
-- Allow shadowed variables (callbacks in callbacks)
redefined = false

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
    
    "craftguide", "i3"
}

-- Loop warning
files["technic/machines/other/frames.lua"].ignore = { "" }
-- Long lines
files["technic_cnc/cnc_api.lua"].ignore = { "" }