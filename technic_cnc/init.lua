local modpath = minetest.get_modpath("technic_cnc")

technic_cnc = {}

technic_cnc.technic_modpath = minetest.get_modpath("technic")

technic_cnc.use_technic = technic_cnc.technic_modpath
                          and minetest.settings:get_bool("technic_cnc_use_technic") ~= false

local mcl = minetest.get_modpath("mcl_core")

-- Compatibility table
technic_cnc.compat = {}
technic_cnc.compat.glass_ingredient = mcl and "mcl_core:glass" or 'default:glass'
technic_cnc.compat.mese_block_ingredient = mcl and "mesecons_torch:redstoneblock" or "default:mese"
technic_cnc.compat.diamond_ingredient = mcl and "mcl_core:diamond" or "default:diamond"

if rawget(_G, "intllib") then
	technic_cnc.getter = intllib.Getter()
else
	-- Intllib copypasta: TODO replace with the client-side translation API
	technic_cnc.getter = function(s,a,...)
		if a==nil then return s end
		a={a,...}
		return s:gsub("(@?)@(%(?)(%d+)(%)?)", function(e,o,n,c)
			if e==""then
				return a[tonumber(n)]..(o==""and c or"")
			end
			return "@"..o..n..c
		end)
	end
end

local S = technic_cnc.getter

-- Check if mcl_core or default is installed
if not minetest.get_modpath("mcl_core") and not minetest.get_modpath("default") then
	error(S(minetest.get_current_modname()).." "..S("requires mcl_core or default to be installed (please install MTG or MCL2, or compatible games)"))
end


dofile(modpath.."/cnc.lua")
dofile(modpath.."/cnc_api.lua")
dofile(modpath.."/cnc_materials.lua")
