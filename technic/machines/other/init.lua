local path = technic.modpath.."/machines/other"

-- mesecons and tubes related
dofile(path.."/injector.lua")
dofile(path.."/constructor.lua")
if minetest.get_modpath("mesecons_mvps") ~= nil then
	dofile(path.."/frames.lua")
end
dofile(path.."/anchor.lua")
