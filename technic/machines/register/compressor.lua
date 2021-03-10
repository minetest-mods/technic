local S = minetest.get_translator("technic")
function technic.register_compressor(data)
	data.typename = "compressing"
	data.machine_name = "compressor"
	data.machine_desc = S("@1 Compressor", data.tier_localized)
	technic.register_base_machine(data)
end
