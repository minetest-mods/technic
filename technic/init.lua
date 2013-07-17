-- Minetest 0.4.7 mod: technic
-- namespace: technic
-- (c) 2012-2013 by RealBadAngel <mk@realbadangel.pl>

technic = {}

local modpath = minetest.get_modpath("technic")

technic.modpath = modpath

technic.dprint = function(string)
	if technic.DBG == 1 then
		print(string)
	end
end

--Read technic config file
dofile(modpath.."/config.lua")
--helper functions
dofile(modpath.."/helpers.lua")

--items 
dofile(modpath.."/items.lua")

-- Register functions
dofile(modpath.."/register_machine_and_tool.lua")

-- Machines
dofile(modpath.."/machines/init.lua")

-- Tools
dofile(modpath.."/tools/init.lua")

function has_locked_chest_privilege(meta, player)
   if player:get_player_name() ~= meta:get_string("owner") then
      return false
   end
   return true
end


-- Swap nodes out. Return the node name.
function hacky_swap_node(pos,name)
   local node = minetest.env:get_node(pos)
   if node.name ~= name then
      local meta = minetest.env:get_meta(pos)
      local meta0 = meta:to_table()
      node.name = name
      minetest.env:set_node(pos,node)
      meta = minetest.env:get_meta(pos)
      meta:from_table(meta0)
   end
   return node.name
end
