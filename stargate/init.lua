-- Minetest 0.4.5 : stargate

--data tables definitions
stargate={}
stargate_network = {}

modpath=minetest.get_modpath("stargate")
dofile(modpath.."/stargate_gui.lua")
dofile(modpath.."/gate_defs.lua")
