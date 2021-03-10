local S = minetest.get_translator("technic")
function technic.register_centrifuge(data)
	data.typename = "separating"
	data.machine_name = "centrifuge"
	data.machine_desc = S("@1 Centrifuge", data.tier_localized)
	technic.register_base_machine(data)
end
