local path = technic.modpath.."/machines"

dofile(path.."/register/init.lua")

-- Tiers
dofile(path.."/LV/init.lua")
dofile(path.."/MV/init.lua")
dofile(path.."/HV/init.lua")

dofile(path.."/switching_station.lua")
dofile(path.."/power_monitor.lua")
dofile(path.."/supply_converter.lua")

dofile(path.."/other/init.lua")

