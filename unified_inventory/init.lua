-- Unified Inventory mod 0.4.6

-- disable default creative inventory
if creative_inventory then 
	creative_inventory.set_creative_formspec = function(player, start_i, pagenum)
	return
	end
end

dofile(minetest.get_modpath("unified_inventory").."/api.lua")
dofile(minetest.get_modpath("unified_inventory").."/bags.lua")
