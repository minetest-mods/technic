
local NS = function(s) return s end

function technic.register_compressor(data)
	data.typename = "compressing"
	data.machine_name = "compressor"
	data.machine_desc = NS("@1 Compressor")
	technic.register_base_machine(data)
end
