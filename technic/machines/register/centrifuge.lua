local S = technic.getter

function technic.register_centrifuge(data)
	data.typename = "separating"
	data.machine_name = "centrifuge"
	data.machine_desc = S("%s Centrifuge")
	technic.register_base_machine(data)
end
