
local NS = function(s) return s end

function technic.register_grinder(data)
	data.typename = "grinding"
	data.machine_name = "grinder"
	data.machine_desc = NS("@1 Grinder")
	technic.register_base_machine(data)
end
