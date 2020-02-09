local S = minetest.get_translator("technic")
function technic.register_grinder(data)
	data.typename = "grinding"
	data.machine_name = "grinder"
	data.machine_desc = S("@1 Grinder", data.tier_localized)
	technic.register_base_machine(data)
end
