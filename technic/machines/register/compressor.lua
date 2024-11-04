
local S = minetest.get_translator("technic")

function technic.register_compressor(data)
	local tier = data.tier
	data.typename = "compressing"
	data.machine_name = "compressor"
	data.machine_desc = S("@1 Compressor", tier)
	technic.register_base_machine(data)
end
