
local NS = function(s) return s end

function technic.register_freezer(data)
	data.typename = "freezing"
	data.machine_name = "freezer"
	data.machine_desc = NS("@1 Freezer")
	technic.register_base_machine(data)
end
