local modpath = minetest.get_modpath("technic_cnc")

technic_cnc = {}

technic_cnc.technic_modpath = minetest.get_modpath("technic")
technic_cnc.getter = minetest.get_translator("technic_cnc")

technic_cnc.use_technic = technic_cnc.technic_modpath
                          and minetest.settings:get_bool("technic_cnc_use_technic") ~= false


dofile(modpath.."/cnc.lua")
dofile(modpath.."/cnc_api.lua")
dofile(modpath.."/cnc_materials.lua")
