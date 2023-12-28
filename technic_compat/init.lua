local modpath = minetest.get_modpath("technic_compat")

-- Compatibility table
technic_compat = {}

technic_compat.mcl = minetest.get_modpath("mcl_core")
technic_compat.default = minetest.get_modpath("default") and default or {}

local mcl_path = modpath .. "/mcl/"

-- Load files
dofile(mcl_path .. "sounds.lua")
dofile(mcl_path .. "textures.lua")
dofile(mcl_path .. "miscellaneous.lua")
dofile(mcl_path .. "crafting.lua")
dofile(mcl_path .. "craftguide.lua")
