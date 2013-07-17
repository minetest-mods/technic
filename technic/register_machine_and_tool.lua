-- This file includes the functions and data structures for registering machines and tools for LV, MV, HV types.
-- We use the technic namespace for these functions and data to avoid eventual conflict.

-- register power tools here
technic.power_tools = {}
technic.register_power_tool = function(craftitem,max_charge)
				    technic.power_tools[craftitem] = max_charge
				 end

-- register LV machines here
technic.LV_machines    = {}

technic.register_LV_machine = function(nodename,type)
				 technic.LV_machines[nodename] = type
			      end

technic.unregister_LV_machine = function(nodename,type)
				   technic.LV_machines[nodename] = nil
				end

-- register MV machines here
technic.MV_machines    = {}
technic.MV_power_tools = {}
technic.register_MV_machine = function(nodename,type)
				 technic.MV_machines[nodename] = type
			      end

technic.unregister_MV_machine = function(nodename)
				   technic.MV_machines[nodename] = nil
				end

-- register HV machines here
technic.HV_machines    = {}
technic.HV_power_tools = {}
technic.register_HV_machine = function(nodename,type)
				 technic.HV_machines[nodename] = type
			      end

technic.unregister_HV_machine = function(nodename)
				   technic.HV_machines[nodename] = nil
				end

-- Utility functions. Not sure exactly what they do.. water.lua uses the two first.
function technic.get_RE_item_load (load1,max_load)
   if load1==0 then load1=65535 end
   local temp = 65536-load1
   temp= temp/65535*max_load
   return math.floor(temp + 0.5)
end

function technic.set_RE_item_load (load1,max_load)
   if load1 == 0 then return 65535 end
   local temp=load1/max_load*65535
   temp=65536-temp
   return math.floor(temp)
end

-- Wear down a tool depending on the remaining charge.
function technic.set_RE_wear (item_stack,load,max_load)
   local temp=65536-math.floor(load/max_load*65535)
   item_stack["wear"]=tostring(temp)
   return item_stack
end
