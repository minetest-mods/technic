
local NS = function(s) return s end

function technic.register_electric_furnace(data)
	data.typename = "cooking"
	data.machine_name = "electric_furnace"
	data.machine_desc = NS("@1 Furnace")
	technic.register_base_machine(data)
end
