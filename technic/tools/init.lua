local path = technic.modpath.."/tools"

if technic.config:getBool("enable_mining_drill") then
	dofile(path.."/mining_drill.lua")
end
if technic.config:getBool("enable_mining_laser") then
	dofile(path.."/mining_laser_mk1.lua")
end
if technic.config:getBool("enable_flashlight") then
	dofile(path.."/flashlight.lua")
end
dofile(path.."/cans.lua")
dofile(path.."/chainsaw.lua")
dofile(path.."/tree_tap.lua")
dofile(path.."/sonic_screwdriver.lua")

