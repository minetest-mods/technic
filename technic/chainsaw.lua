-- Configuration
local chainsaw_max_charge      = 30000 -- 30000 - Maximum charge of the saw
local chainsaw_charge_per_node = 12    -- 12    - Gives 2500 nodes on a single charge (about 50 complete normal trees)
local chainsaw_leaves          = true  -- true  - Cut down entire trees, leaves and all

register_power_tool ("technic:chainsaw",chainsaw_max_charge)

minetest.register_tool("technic:chainsaw", {
        description = "Chainsaw",
        inventory_image = "technic_chainsaw.png",
        stack_max = 1,
        on_use = function(itemstack, user, pointed_thing)
                if pointed_thing.type=="node" then
                        item=itemstack:to_table()
                        local meta=get_item_meta(item["metadata"])
                        if meta==nil then return end --tool not charged
                        if meta["charge"]==nil then return end
                        -- Send current charge to digging function so that the chainsaw will stop after digging a number of nodes.
                        local charge=meta["charge"]
                        if charge < chainsaw_charge_per_node then return end -- only cut if charged

                        charge=chainsaw_dig_it(minetest.get_pointed_thing_position(pointed_thing, above),user,charge)
                        set_RE_wear(item,charge,chainsaw_max_charge)
                        meta["charge"]=charge
                        item["metadata"]=set_item_meta(meta)
                        itemstack:replace(item)
                        return itemstack
                end
        end,
})

minetest.register_craft({
        output = 'technic:chainsaw',
        recipe = {
                {'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:battery'},
                {'technic:stainless_steel_ingot', 'technic:motor', 'technic:battery'},
                {'','','default:copper_ingot'},
        }
})

-- The default stuff
local timber_nodenames={["default:jungletree"] = true,
                        ["default:papyrus"]    = true,
                        ["default:cactus"]     = true,
                        ["default:tree"]       = true,
                        ["default:apple"]      = true
}

if chainsaw_leaves == true then
        timber_nodenames["default:leaves"] = true
end

-- Support moretrees if it is there
if( minetest.get_modpath("moretrees") ~= nil ) then
        timber_nodenames["moretrees:apple_tree_trunk"]                 = true
        timber_nodenames["moretrees:apple_tree_trunk_sideways"]        = true
        timber_nodenames["moretrees:beech_trunk"]                      = true
        timber_nodenames["moretrees:beech_trunk_sideways"]             = true
        timber_nodenames["moretrees:birch_trunk"]                      = true
        timber_nodenames["moretrees:birch_trunk_sideways"]             = true
        timber_nodenames["moretrees:fir_trunk"]                        = true
        timber_nodenames["moretrees:fir_trunk_sideways"]               = true
        timber_nodenames["moretrees:oak_trunk"]                        = true
        timber_nodenames["moretrees:oak_trunk_sideways"]               = true
        timber_nodenames["moretrees:palm_trunk"]                       = true
        timber_nodenames["moretrees:palm_trunk_sideways"]              = true
        timber_nodenames["moretrees:pine_trunk"]                       = true
        timber_nodenames["moretrees:pine_trunk_sideways"]              = true
        timber_nodenames["moretrees:rubber_tree_trunk"]                = true
        timber_nodenames["moretrees:rubber_tree_trunk_sideways"]       = true
        timber_nodenames["moretrees:rubber_tree_trunk_empty"]          = true
        timber_nodenames["moretrees:rubber_tree_trunk_sideways_empty"] = true
        timber_nodenames["moretrees:sequoia_trunk"]                    = true
        timber_nodenames["moretrees:sequoia_trunk_sideways"]           = true
        timber_nodenames["moretrees:spruce_trunk"]                     = true
        timber_nodenames["moretrees:spruce_trunk_sideways"]            = true
        timber_nodenames["moretrees:willow_trunk"]                     = true
        timber_nodenames["moretrees:willow_trunk_sideways"]            = true
        timber_nodenames["moretrees:jungletree_trunk"]                 = true
        timber_nodenames["moretrees:jungletree_trunk_sideways"]        = true

        if chainsaw_leaves == true then
                timber_nodenames["moretrees:apple_tree_leaves"]        = true
                timber_nodenames["moretrees:oak_leaves"]               = true
                timber_nodenames["moretrees:sequoia_leaves"]           = true
                timber_nodenames["moretrees:birch_leaves"]             = true
                timber_nodenames["moretrees:birch_leaves"]             = true
                timber_nodenames["moretrees:palm_leaves"]              = true
                timber_nodenames["moretrees:spruce_leaves"]            = true
                timber_nodenames["moretrees:spruce_leaves"]            = true
                timber_nodenames["moretrees:pine_leaves"]              = true
                timber_nodenames["moretrees:willow_leaves"]            = true
                timber_nodenames["moretrees:rubber_tree_leaves"]       = true
                timber_nodenames["moretrees:jungletree_leaves_green"]  = true
                timber_nodenames["moretrees:jungletree_leaves_yellow"] = true
                timber_nodenames["moretrees:jungletree_leaves_red"]    = true
        end
end

-- Support growing_trees if it is there
if( minetest.get_modpath("growing_trees") ~= nil ) then
        timber_nodenames["growing_trees:trunk"]         = true
        timber_nodenames["growing_trees:medium_trunk"]  = true
        timber_nodenames["growing_trees:big_trunk"]     = true
        timber_nodenames["growing_trees:trunk_top"]     = true
        timber_nodenames["growing_trees:trunk_sprout"]  = true
        timber_nodenames["growing_trees:branch_sprout"] = true
        timber_nodenames["growing_trees:branch"]        = true
        timber_nodenames["growing_trees:branch_xmzm"]   = true
        timber_nodenames["growing_trees:branch_xpzm"]   = true
        timber_nodenames["growing_trees:branch_xmzp"]   = true
        timber_nodenames["growing_trees:branch_xpzp"]   = true
        timber_nodenames["growing_trees:branch_zz"]     = true
        timber_nodenames["growing_trees:branch_xx"]     = true

        if chainsaw_leaves == true then
                timber_nodenames["growing_trees:leaves"] = true
        end
end

-- Support growing_cactus if it is there
if( minetest.get_modpath("growing_cactus") ~= nil ) then
        timber_nodenames["growing_cactus:sprout"]                       = true
        timber_nodenames["growing_cactus:branch_sprout_vertical"]       = true
        timber_nodenames["growing_cactus:branch_sprout_vertical_fixed"] = true
        timber_nodenames["growing_cactus:branch_sprout_xp"]             = true
        timber_nodenames["growing_cactus:branch_sprout_xm"]             = true
        timber_nodenames["growing_cactus:branch_sprout_zp"]             = true
        timber_nodenames["growing_cactus:branch_sprout_zm"]             = true
        timber_nodenames["growing_cactus:trunk"]                        = true
        timber_nodenames["growing_cactus:branch_trunk"]                 = true
        timber_nodenames["growing_cactus:branch"]                       = true
        timber_nodenames["growing_cactus:branch_xp"]                    = true
        timber_nodenames["growing_cactus:branch_xm"]                    = true
        timber_nodenames["growing_cactus:branch_zp"]                    = true
        timber_nodenames["growing_cactus:branch_zm"]                    = true
        timber_nodenames["growing_cactus:branch_zz"]                    = true
        timber_nodenames["growing_cactus:branch_xx"]                    = true
end

-- Support farming_plus if it is there
if( minetest.get_modpath("farming_plus") ~= nil ) then
   if chainsaw_leaves == true then
      timber_nodenames["farming_plus:cocoa_leaves"] = true
   end
end

-- Table for saving what was sawed down
local produced

-- Saw down trees entry point
chainsaw_dig_it = function(pos, player,current_charge)
        local remaining_charge=current_charge

        -- Save the currently installed dropping mechanism so we can restore it.
	local original_handle_node_drops = minetest.handle_node_drops

        -- A bit of trickery here: use a different node drop callback
        -- and restore the original afterwards.
        minetest.handle_node_drops = chainsaw_handle_node_drops

        -- clear result and start sawing things down
        produced = {}
        remaining_charge = recursive_dig(pos, remaining_charge, player)
        minetest.sound_play("chainsaw", {pos = pos, gain = 1.0, max_hear_distance = 10,})

        -- Restore the original noder drop handler
        minetest.handle_node_drops = original_handle_node_drops

        -- Now drop items for the player
        local number, produced_item, p
        for produced_item,number in pairs(produced) do
                --print("ADDING ITEM: " .. produced_item .. " " .. number)
                -- Drop stacks of 99 or less
                p = {
                        x = pos.x + math.random()*4,
                        y = pos.y,
                        z = pos.z + math.random()*4
                }
                while number > 99 do
                        minetest.env:add_item(p, produced_item .. " 99")
                        p = {
                                x = pos.x + math.random()*4,
                                y = pos.y,
                                z = pos.z + math.random()*4
                        }
                        number = number - 99
                end
                minetest.env:add_item(p, produced_item .. " " .. number)
        end
        return remaining_charge
end

-- Override the default handling routine to be able to count up the
-- items sawed down so that we can drop them i an nice single stack
chainsaw_handle_node_drops = function(pos, drops, digger)
        -- Add dropped items to list of collected nodes
        local _, dropped_item
        for _, dropped_item in ipairs(drops) do
                if produced[dropped_item] == nil then
                        produced[dropped_item] = 1
                else
                        produced[dropped_item] = produced[dropped_item] + 1
                end
        end
end

-- This function does all the hard work. Recursively we dig the node at hand
-- if it is in the table and then search the surroundings for more stuff to dig.
recursive_dig = function(pos, remaining_charge, player)
        local node=minetest.env:get_node(pos)
        local i=1
        -- Lookup node name in timber table:
        if timber_nodenames[node.name] ~= nil then
                -- Return if we are out of power
                if remaining_charge < chainsaw_charge_per_node then
                        return 0
                end
                local np
                -- wood found - cut it.
                minetest.env:dig_node(pos)

                remaining_charge=remaining_charge-chainsaw_charge_per_node
                -- check surroundings and run recursively if any charge left
                np={x=pos.x+1, y=pos.y, z=pos.z}
                if timber_nodenames[minetest.env:get_node(np).name] ~= nil then
                        remaining_charge = recursive_dig(np, remaining_charge)
                end
                np={x=pos.x+1, y=pos.y, z=pos.z+1}
                if timber_nodenames[minetest.env:get_node(np).name] ~= nil then
                        remaining_charge = recursive_dig(np, remaining_charge)
                end
                np={x=pos.x+1, y=pos.y, z=pos.z-1}
                if timber_nodenames[minetest.env:get_node(np).name] ~= nil then
                        remaining_charge = recursive_dig(np, remaining_charge)
                end

                np={x=pos.x-1, y=pos.y, z=pos.z}
                if timber_nodenames[minetest.env:get_node(np).name] ~= nil then
                        remaining_charge = recursive_dig(np, remaining_charge)
                end
                np={x=pos.x-1, y=pos.y, z=pos.z+1}
                if timber_nodenames[minetest.env:get_node(np).name] ~= nil then
                        remaining_charge = recursive_dig(np, remaining_charge)
                end
                np={x=pos.x-1, y=pos.y, z=pos.z-1}
                if timber_nodenames[minetest.env:get_node(np).name] ~= nil then
                        remaining_charge = recursive_dig(np, remaining_charge)
                end

                np={x=pos.x, y=pos.y+1, z=pos.z}
                if timber_nodenames[minetest.env:get_node(np).name] ~= nil then
                        remaining_charge = recursive_dig(np, remaining_charge)
                end

                np={x=pos.x, y=pos.y, z=pos.z+1}
                if timber_nodenames[minetest.env:get_node(np).name] ~= nil then
                        remaining_charge = recursive_dig(np, remaining_charge)
                end
                np={x=pos.x, y=pos.y, z=pos.z-1}
                if timber_nodenames[minetest.env:get_node(np).name] ~= nil then
                        remaining_charge = recursive_dig(np, remaining_charge)
                end
                return remaining_charge
        end
        -- Nothing sawed down
        return remaining_charge
end
