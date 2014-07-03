
local S = technic.getter

function technic.register_alloy_furnace(data)
	data.typename = "alloy"
	data.machine_name = "alloy_furnace"
	data.machine_desc = S("%s Alloy Furnace")
	technic.register_base_machine(data)
end

