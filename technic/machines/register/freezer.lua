local S = minetest.get_translator("technic")
function technic.register_freezer(data)
	data.typename = "freezing"
	data.machine_name = "freezer"
	data.machine_desc = S("@1 Freezer", data.tier_localized)
	technic.register_base_machine(data)
end
