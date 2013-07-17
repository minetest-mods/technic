
technic.register_tier("MV", "Medium Voltage")

local path = technic.modpath.."/machines/MV"

dofile(path.."/alloy_furnace.lua")
dofile(path.."/battery_box.lua")
dofile(path.."/cables.lua")
dofile(path.."/electric_furnace.lua")
dofile(path.."/grinder.lua")
dofile(path.."/solar_array.lua")
dofile(path.."/tool_workshop.lua")
dofile(path.."/wind_mill.lua")

-- The power radiator supplies appliances with inductive coupled power:
-- Lighting and associated textures is taken directly from VanessaE's homedecor and made electric.
dofile(path.."/power_radiator.lua")
dofile(path.."/lighting.lua")

