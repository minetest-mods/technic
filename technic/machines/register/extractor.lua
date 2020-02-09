local S = minetest.get_translator("technic")
function technic.register_extractor(data)
	data.typename = "extracting"
	data.machine_name = "extractor"
	data.machine_desc = S("@1 Extractor", data.tier_localized)
	technic.register_base_machine(data)
end
