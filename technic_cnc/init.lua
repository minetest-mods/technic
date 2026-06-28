local modpath = minetest.get_modpath("technic_cnc")

technic_cnc = {}

technic_cnc.technic_modpath = minetest.get_modpath("technic")
technic_cnc.getter = minetest.get_translator("technic_cnc")

technic_cnc.use_technic = technic_cnc.technic_modpath
                          and minetest.settings:get_bool("technic_cnc_use_technic") ~= false

local mcl = minetest.get_modpath("mcl_core")

-- Compatibility table
-- This section is required to switch item names between MTG (default) and MCL2
technic_cnc.compat = {}
technic_cnc.compat.glass_ingredient = mcl and "mcl_core:glass" or 'default:glass'
technic_cnc.compat.mese_block_ingredient = mcl and "mesecons_torch:redstoneblock" or "default:mese"
technic_cnc.compat.diamond_ingredient = mcl and "mcl_core:diamond" or "default:diamond"

local S = technic_cnc.getter

-- Check if mcl_core or default is installed
if not minetest.get_modpath("mcl_core") and not minetest.get_modpath("default") then
	error(S(minetest.get_current_modname()).." "..S("requires mcl_core or default to be installed (please install MTG or MCL2, or compatible games)"))
end

dofile(modpath.."/cnc.lua")
dofile(modpath.."/cnc_api.lua")
dofile(modpath.."/cnc_materials.lua")