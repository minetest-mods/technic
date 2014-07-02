
local S = technic.getter

function technic.register_extractor(data)
	data.typename = "extracting"
	data.machine_name = "extractor"
	data.machine_desc = S("%s Extractor")
	technic.register_base_machine(data)
end
