
local S = minetest.get_translator("technic")

function technic.register_electric_furnace(data)
	data.typename = "cooking"
	data.machine_name = "electric_furnace"
	data.machine_desc = S("@1 Furnace", data.tier)
	technic.register_base_machine(data)
end
