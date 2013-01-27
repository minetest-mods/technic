 minetest.register_tool("technic:screwdriver", {
            description = "Screwdriver",
            inventory_image = "technic_screwdriver.png",
            on_use = function(itemstack, user, pointed_thing)
                    -- Must be pointing to facedir applicable node
                    if pointed_thing.type~="node" then return end
                    local pos=minetest.get_pointed_thing_position(pointed_thing,above)
                    local node=minetest.env:get_node(pos)
                    local node_name=node.name
                        if minetest.registered_nodes[node_name].paramtype2 == "facedir" or minetest.registered_nodes[node_name].paramtype2 == "wallmounted" then
                    if node.param2==nil  then return end
                    -- Get ready to set the param2
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
            end,
    })
    
    minetest.register_craft({
            output = "technic:screwdriver",
            recipe = {
                    {"technic:stainless_steel_ingot"},
                    {"default:stick"}
            }
    })
