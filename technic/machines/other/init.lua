local path = technic.modpath.."/machines/other"

-- mesecons and tubes related
dofile(path.."/injector.lua")
dofile(path.."/constructor.lua")

if technic.config:get_bool("enable_frames")
and rawget(_G, "mesecon")
and mesecon.register_mvps_unmov
and vector.set_data_to_pos then
	dofile(path.."/frames.lua")
end

-- Coal-powered machines
dofile(path.."/coal_alloy_furnace.lua")
dofile(path.."/coal_furnace.lua")

dofile(path.."/anchor.lua")
