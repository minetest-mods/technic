    minetest.register_tool("technic:screwdriver", {
            description = "Screwdriver",
            inventory_image = "technic_screwdriver.png",
            on_use = function(itemstack, user, pointed_thing)
                    -- Must be pointing to facedir applicable node
                    if pointed_thing.type~="node" then return end
		    local pos=minetest.get_pointed_thing_position(pointed_thing,above)
		    local node=minetest.env:get_node(pos)
		    local node_name=node.name
		    if node.param2==nil  then return end
                    print (node_name)
		    -- Get ready to set the param2
                    local n = node.param2
                    n = n+1
                    if n == 4 then n = 0 end
                    -- hacky_swap_node, unforunatly.
                    local meta = minetest.env:get_meta(pos)
                    local meta0 = meta:to_table()
                    node.param2 = n
                    print(node_name)
		    minetest.env:set_node(pos,node)
                    meta = minetest.env:get_meta(pos)
                    meta:from_table(meta0)
                    -- appropriatly set the wear of the screwdriver
                   -- m = itemstack:get_wear()
                   -- if m == 0 then m = 65535 end
                   -- m = m-6554
                   -- return {wear=m}
            end,
    })
     
    minetest.register_craft({
            output = "technic:screwdriver",
            recipe = {
                    {"technic:stainless_steel_ingot"},
                    {"default:stick"}
            }
    })
