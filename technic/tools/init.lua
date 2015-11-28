local path = technic.modpath.."/tools"

if technic.config:get_bool("enable_mining_drill") then
	dofile(path.."/mining_drill.lua")
end
if technic.config:get_bool("enable_mining_laser") then
	dofile(path.."/mining_lasers.lua")
end
if technic.config:get_bool("enable_flashlight") then
	dofile(path.."/flashlight.lua")
end
dofile(path.."/cans.lua")
dofile(path.."/chainsaw.lua")
dofile(path.."/tree_tap.lua")
dofile(path.."/sonic_screwdriver.lua")
dofile(path.."/prospector.lua")
dofile(path.."/vacuum.lua")

if minetest.get_modpath("screwdriver") then
	-- compatibility alias
	minetest.register_alias("technic:screwdriver", "screwdriver:screwdriver")
end

