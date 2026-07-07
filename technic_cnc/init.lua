local modpath = minetest.get_modpath("technic_cnc")

technic_cnc = {}

technic_cnc.technic_modpath = minetest.get_modpath("technic")
technic_cnc.getter = minetest.get_translator("technic_cnc")

technic_cnc.use_technic = technic_cnc.technic_modpath
                          and minetest.settings:get_bool("technic_cnc_use_technic") ~= false

-- From technic/helpers.lua
local S = technic_cnc.getter
function technic_cnc._get_desc_formatter(name, status)
	return function(status)
		return status and S("@1@nStatus: @2", name, status) or name
	end
end


dofile(modpath.."/cnc.lua")
dofile(modpath.."/cnc_api.lua")
dofile(modpath.."/cnc_materials.lua")
