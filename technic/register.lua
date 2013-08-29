-- This file includes the functions and data structures for registering machines and tools for LV, MV, HV types.
-- We use the technic namespace for these functions and data to avoid eventual conflict.

technic.receiver = "RE"
technic.producer = "PR"
technic.battery  = "BA"

technic.machines    = {}
technic.power_tools = {}
technic.networks = {}


function technic.register_tier(tier, description)
	technic.machines[tier]    = {}
	technic.cables[tier]      = {}
end

function technic.register_machine(tier, nodename, machine_type)
	if not technic.machines[tier] then
		return
	end
	technic.machines[tier][nodename] = machine_type
end

function technic.register_power_tool(craftitem, max_charge)
	technic.power_tools[craftitem] = max_charge
end


-- Utility functions. Not sure exactly what they do.. water.lua uses the two first.
function technic.get_RE_item_load(load1, max_load)
	if load1 == 0 then load1 = 65535 end
	local temp = 65536 - load1
	temp = temp / 65535 * max_load
	return math.floor(temp + 0.5)
end

function technic.set_RE_item_load(load1, max_load)
	if load1 == 0 then return 65535 end
	local temp = load1 / max_load * 65535
	temp = 65536 - temp
	return math.floor(temp)
end

-- Wear down a tool depending on the remaining charge.
function technic.set_RE_wear(item_stack, item_load, max_load)
	local temp = 65536 - math.floor(item_load / max_load * 65535)
	item_stack.wear = tostring(temp)
	return item_stack
end
