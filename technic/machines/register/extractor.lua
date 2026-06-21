
local NS = function(s) return s end

function technic.register_extractor(data)
	data.typename = "extracting"
	data.machine_name = "extractor"
	data.machine_desc = NS("@1 Extractor")
	technic.register_base_machine(data)
end
