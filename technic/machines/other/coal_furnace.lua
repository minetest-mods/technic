local S = technic.getter

if minetest.registered_nodes["default:furnace"].description == "Furnace" then
	minetest.override_item("default:furnace", { description = S("Fuel-Fired Furnace") })
end
