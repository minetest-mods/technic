local modpath = minetest.get_modpath("technic_cnc")

technic_cnc = {}

technic_cnc.technic_modpath = minetest.get_modpath("technic")

technic_cnc.use_technic = technic_cnc.technic_modpath
                          and minetest.settings:get_bool("technic_cnc_use_technic") ~= false

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

dofile(modpath.."/cnc.lua")
dofile(modpath.."/cnc_api.lua")
dofile(modpath.."/cnc_materials.lua")
