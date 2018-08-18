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

if technic.config:get_bool("creative_mode") then
	--The switching station does not handle running machines
	--in this mode, so alternative means are used to do so.
	dofile(path.."/creative.lua")
end
