local S = technic.getter

if minetest.get_modpath("mcl_core") then
	minetest.registered_nodes["mcl_furnaces:furnace"].description = S("Fuel-Fired Furnace")
	minetest.override_item("mcl_furnaces:furnace", { description = S("Fuel-Fired Furnace") })
else
if minetest.registered_nodes["default:furnace"].description == "Furnace" then
	minetest.override_item("default:furnace", { description = S("Fuel-Fired Furnace") })
end
end
