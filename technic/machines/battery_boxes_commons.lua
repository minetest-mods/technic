charge_tools = function(meta, charge, step)
	--charge registered power tools
	local inv = meta:get_inventory()
	if inv:is_empty("src")==false  then
		local srcstack = inv:get_stack("src", 1)
		local src_item=srcstack:to_table()
		local src_meta=get_item_meta(src_item["metadata"])

		local toolname = src_item["name"]
		if technic.power_tools[toolname] ~= nil then
		   -- Set meta data for the tool if it didn't do it itself :-(
		   src_meta=get_item_meta(src_item["metadata"])
		if src_meta==nil then
			src_meta={}
			src_meta["technic_power_tool"]=true
			src_meta["charge"]=0
		else
			if src_meta["technic_power_tool"]==nil then
				src_meta["technic_power_tool"]=true
				src_meta["charge"]=0
			end
		end
		-- Do the charging
		local item_max_charge = technic.power_tools[toolname]
		local load            = src_meta["charge"]
		local load_step       = step -- how much to charge per tick
		if load<item_max_charge and charge>0 then
			if charge-load_step<0 then load_step=charge end
			if load+load_step>item_max_charge then load_step=item_max_charge-load end
				load=load+load_step
				charge=charge-load_step
				technic.set_RE_wear(src_item,load,item_max_charge)
				src_meta["charge"]   = load
				src_item["metadata"] = set_item_meta(src_meta)
				inv:set_stack("src", 1, src_item)
			end
		end
	end
	return charge -- return the remaining charge in the battery
end

discharge_tools = function(meta, charge, max_charge, step)
	-- discharging registered power tools
	local inv = meta:get_inventory()
	if inv:is_empty("dst") == false then
	   srcstack = inv:get_stack("dst", 1)
	   src_item=srcstack:to_table()
	   local src_meta=get_item_meta(src_item["metadata"])
	   local toolname = src_item["name"]
	   if technic.power_tools[toolname] ~= nil then
	      -- Set meta data for the tool if it didn't do it itself :-(
	      src_meta=get_item_meta(src_item["metadata"])
	      if src_meta==nil then
			 src_meta={}
			 src_meta["technic_power_tool"]=true
			 src_meta["charge"]=0
	      else
			 if src_meta["technic_power_tool"]==nil then
			    src_meta["technic_power_tool"]=true
			    src_meta["charge"]=0
			 end
	      end
		-- Do the discharging
			local item_max_charge = technic.power_tools[toolname]
			local load            = src_meta["charge"]
			local load_step       = step -- how much to discharge per tick
			if load>0 and charge<max_charge then
				if charge+load_step>max_charge then load_step=max_charge-charge end
				if load-load_step<0 then load_step=load end
				load=load-load_step
				charge=charge+load_step
				technic.set_RE_wear(src_item,load,item_max_charge)
				src_meta["charge"]=load
				src_item["metadata"]=set_item_meta(src_meta)
				inv:set_stack("dst", 1, src_item)
			end
		end
	end
	return charge -- return the remaining charge in the battery
end
