torchlight_max_charge=30000
      
       minetest.register_tool("technic:torchlight", {
            description = "Torchlight",
            inventory_image = "technic_torchlight.png",
            on_use = function(itemstack, user, pointed_thing)
	end,	        
    })
     
    minetest.register_craft({
            output = "technic:torchlight",
            recipe = {
		    {"glass","glass","glass"},
                    {"technic:stainless_steel_ingot","technic:battery","technic:stainless_steel_ingot"},
                    {"","technic:battery",""}
            }
    })
