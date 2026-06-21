
local NS = function(s) return s end

function technic.register_centrifuge(data)
	data.typename = "separating"
	data.machine_name = "centrifuge"
	data.machine_desc = NS("@1 Centrifuge")
	technic.register_base_machine(data)
end
