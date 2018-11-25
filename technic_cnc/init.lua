local modpath = minetest.get_modpath("technic_cnc")

technic_cnc = {}

if rawget(_G, "intllib") then
	technic_cnc.getter = intllib.Getter()
else
	technic_cnc.getter = function(s,a,...)if a==nil then return s end a={a,...}return s:gsub("(@?)@(%(?)(%d+)(%)?)",function(e,o,n,c)if e==""then return a[tonumber(n)]..(o==""and c or"")else return"@"..o..n..c end end) end
end

dofile(modpath.."/cnc.lua")
dofile(modpath.."/cnc_api.lua")
dofile(modpath.."/cnc_materials.lua")
