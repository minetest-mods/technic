local path = technic.modpath.."/machines"

technic.digilines = {
	rules = {
		-- digilines.rules.default
		{x= 1,y= 0,z= 0},{x=-1,y= 0,z= 0}, -- along x beside
		{x= 0,y= 0,z= 1},{x= 0,y= 0,z=-1}, -- along z beside
		{x= 1,y= 1,z= 0},{x=-1,y= 1,z= 0}, -- 1 node above along x diagonal
		{x= 0,y= 1,z= 1},{x= 0,y= 1,z=-1}, -- 1 node above along z diagonal
		{x= 1,y=-1,z= 0},{x=-1,y=-1,z= 0}, -- 1 node below along x diagonal
		{x= 0,y=-1,z= 1},{x= 0,y=-1,z=-1}, -- 1 node below along z diagonal
		-- added rules for digi cable
		{x =  0, y = -1, z = 0}, -- along y below
	}
}

dofile(path.."/register/init.lua")

-- Tiers
dofile(path.."/LV/init.lua")
dofile(path.."/MV/init.lua")
dofile(path.."/HV/init.lua")

dofile(path.."/switching_station.lua")
dofile(path.."/switching_station_globalstep.lua")

dofile(path.."/power_monitor.lua")
dofile(path.."/supply_converter.lua")

dofile(path.."/other/init.lua")
