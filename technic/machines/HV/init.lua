
technic.register_tier("HV", "High Voltage")

local path = technic.modpath.."/machines/HV"

dofile(path.."/cables.lua")
dofile(path.."/quarry.lua")
dofile(path.."/forcefield.lua")
dofile(path.."/battery_box.lua")
dofile(path.."/solar_array.lua")
dofile(path.."/nuclear_reactor.lua")
dofile(path.."/generator.lua")
dofile(path.."/electric_furnace.lua")
dofile(path.."/grinder.lua")
