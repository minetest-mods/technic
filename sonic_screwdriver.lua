sonic_screwdriver_max_charge=15000
      
       minetest.register_tool("technic:sonic_screwdriver", {
            description = "Sonic Screwdriver",
            inventory_image = "technic_sonic_screwdriver.png",
            on_use = function(itemstack, user, pointed_thing)
                    -- Must be pointing to facedir applicable node
                    if pointed_thing.type~="node" then return end
                    local pos=minetest.get_pointed_thing_position(pointed_thing,above)
                    local node=minetest.env:get_node(pos)
                    local node_name=node.name
                        if minetest.registered_nodes[node_name].paramtype2 == "facedir" or minetest.registered_nodes[node_name].paramtype2 == "wallmounted" then
                    if node.param2==nil  then return end
                    item=itemstack:to_table()
                        if item["metadata"]=="" or item["metadata"]=="0" then  return end 
			local charge=tonumber((item["metadata"])) 
                        if charge-100>0 then
                                minetest.sound_play("technic_sonic_screwdriver", {pos = pos, gain = 0.3, max_hear_distance = 10,})
                           local n = node.param2
                           if minetest.registered_nodes[node_name].paramtype2 == "facedir" then
                           n = n+1
                   if n == 4 then n = 0 end
                           else
                           n = n+1
                           if n == 6 then n = 0 end
                           end
                            -- hacky_swap_node, unforunatly.
                            local meta = minetest.env:get_meta(pos)
                            local meta0 = meta:to_table()
                            node.param2 = n
                            minetest.env:set_node(pos,node)
                            meta = minetest.env:get_meta(pos)
                            meta:from_table(meta0)
                 
                          charge =charge-100;  
                          item["metadata"]=tostring(charge)
			  set_RE_wear(item,charge,sonic_screwdriver_max_charge)
                          itemstack:replace(item)
                          end
                        return itemstack
                        else
                        return itemstack
                        end
                        end,
         
    })
     
    minetest.register_craft({
            output = "technic:sonic_screwdriver",
            recipe = {
		    {"technic:diamond"},
                    {"technic:battery"},
                    {"technic:stainless_steel_ingot"}
            }
    })
