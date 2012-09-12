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
		    if node.param2==nil  then return end
                    item=itemstack:to_table()
			local charge=tonumber((item["wear"])) 
			if charge ==0 then charge =65535 end
			charge=get_RE_item_load(charge,sonic_screwdriver_max_charge)
			if charge-100>0 then
			  	minetest.sound_play("technic_sonic_screwdriver", {pos = pos, gain = 0.5, max_hear_distance = 10,})
			   local n = node.param2
			   n = n+1
	                   if n == 4 then n = 0 end
	                    -- hacky_swap_node, unforunatly.
		            local meta = minetest.env:get_meta(pos)
			    local meta0 = meta:to_table()
	                    node.param2 = n
			    minetest.env:set_node(pos,node)
	                    meta = minetest.env:get_meta(pos)
		            meta:from_table(meta0)
		  
			  charge =charge-100;	
			  charge=set_RE_item_load(charge,sonic_screwdriver_max_charge)
			  item["wear"]=tostring(charge)
			  itemstack:replace(item)
			  end
			return itemstack
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
