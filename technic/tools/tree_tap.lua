    minetest.register_tool("technic:treetap", {
            description = "Tree Tap",
            inventory_image = "technic_tree_tap.png",
            on_use = function(itemstack,user,pointed_thing)
                    if pointed_thing.type~="node" then return end
                    if user:get_inventory():room_for_item("main",ItemStack("technic:raw_latex")) then
                            local pos=minetest.get_pointed_thing_position(pointed_thing,above)
                            local node=minetest.env:get_node(pos)
                            local node_name=node.name
                            if node_name == "moretrees:rubber_tree_trunk" then
                                    node.name = "moretrees:rubber_tree_trunk_empty"
                                    user:get_inventory():add_item("main",ItemStack("technic:raw_latex"))
                                    minetest.env:set_node(pos,node)
                                    local item=itemstack:to_table()
                                    local item_wear=tonumber((item["wear"]))
                                    item_wear=item_wear+819
                                    if item_wear>65535 then itemstack:clear() return itemstack end
                                    item["wear"]=tostring(item_wear)
                                    itemstack:replace(item)
                                    return itemstack
                                    else
                                    return itemstack
                                    end
                           else return end
                    end,
    })
     
    minetest.register_craft({
            output = "technic:treetap",
            recipe = {
                    {"pipeworks:tube", "default:wood", "default:stick"},
                    {"", "default:stick", "default:stick"}
            },
    })
     
    minetest.register_craftitem("technic:raw_latex", {
            description = "Raw Latex",
            inventory_image = "technic_raw_latex.png",
    })
     
    minetest.register_craft({
            type = "cooking",
            output = "technic:rubber",
            recipe = "technic:raw_latex",
    })
     
    minetest.register_craftitem("technic:rubber", {
            description = "Rubber Fiber",
            inventory_image = "technic_rubber.png",
    })

minetest.register_abm({
	nodenames = {"moretrees:rubber_tree_trunk_empty"},
	interval = 60,
	chance = 15,
	action = function(pos, node)
		node.name = "moretrees:rubber_tree_trunk"
		minetest.env:set_node(pos, node)
	end
})
