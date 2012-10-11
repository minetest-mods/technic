flashlight_max_charge=30000
      
       minetest.register_tool("technic:flashlight", {
            description = "Flashlight",
            inventory_image = "technic_flashlight.png",
            on_use = function(itemstack, user, pointed_thing)
	end,	        
    })
     
    minetest.register_craft({
            output = "technic:flashlight",
            recipe = {
		    {"glass","glass","glass"},
                    {"technic:stainless_steel_ingot","technic:battery","technic:stainless_steel_ingot"},
                    {"","technic:battery",""}
            }
    })
