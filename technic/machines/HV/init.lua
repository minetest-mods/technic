
technic.register_tier("HV", "High Voltage")

local path = technic.modpath.."/machines/HV"

-- Wiring stuff
dofile(path.."/cables.lua")
dofile(path.."/battery_box.lua")

-- Generators
dofile(path.."/solar_array.lua")
dofile(path.."/nuclear_reactor.lua")
dofile(path.."/generator.lua")

-- Machines
dofile(path.."/quarry.lua")
dofile(path.."/forcefield.lua")

