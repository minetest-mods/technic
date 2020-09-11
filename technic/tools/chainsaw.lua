-- Configuration

local chainsaw_max_charge      = 30000 -- Maximum charge of the saw
-- Gives 2500 nodes on a single charge (about 50 complete normal trees)
local chainsaw_charge_per_node = 12
-- Cut down tree leaves.  Leaf decay may cause slowness on large trees
-- if this is disabled.
local chainsaw_leaves = true

-- First value is node name; second is whether the node is considered even if chainsaw_leaves is false.
local nodes = {
	-- The default trees
	{"default:acacia_tree", true},
	{"default:aspen_tree", true},
	{"default:jungletree", true},
	{"default:papyrus", true},
	{"default:cactus", true},
	{"default:tree", true},
	{"default:apple", true},
	{"default:pine_tree", true},
	{"default:acacia_leaves", false},
	{"default:aspen_leaves", false},
	{"default:leaves", false},
	{"default:jungleleaves", false},
	{"default:pine_needles", false},

	-- The default bushes
	{"default:acacia_bush_stem", true},
	{"default:bush_stem", true},
	{"default:pine_bush_stem", true},
	{"default:acacia_bush_leaves", false},
	{"default:blueberry_bush_leaves", false},
	{"default:blueberry_bush_leaves_with_berries", false},
	{"default:bush_leaves", false},
	{"default:pine_bush_needles", false},

	-- Rubber trees from moretrees or technic_worldgen if moretrees isn't installed
	{"moretrees:rubber_tree_trunk_empty", true},
	{"moretrees:rubber_tree_trunk", true},
	{"moretrees:rubber_tree_leaves", false},

	-- Support moretrees (trunk)
	{"moretrees:acacia_trunk", true},
	{"moretrees:apple_tree_trunk", true},
	{"moretrees:beech_trunk", true},
	{"moretrees:birch_trunk", true},
	{"moretrees:cedar_trunk", true},
	{"moretrees:date_palm_ffruit_trunk", true},
	{"moretrees:date_palm_fruit_trunk", true},
	{"moretrees:date_palm_mfruit_trunk", true},
	{"moretrees:date_palm_trunk", true},
	{"moretrees:fir_trunk", true},
	{"moretrees:jungletree_trunk", true},
	{"moretrees:oak_trunk", true},
	{"moretrees:palm_trunk", true},
	{"moretrees:palm_fruit_trunk", true},
	{"moretrees:palm_fruit_trunk_gen", true},
	{"moretrees:pine_trunk", true},
	{"moretrees:poplar_trunk", true},
	{"moretrees:sequoia_trunk", true},
	{"moretrees:spruce_trunk", true},
	{"moretrees:willow_trunk", true},
	-- Support moretrees (leaves)
	{"moretrees:acacia_leaves", false},
	{"moretrees:apple_tree_leaves", false},
	{"moretrees:beech_leaves", false},
	{"moretrees:birch_leaves", false},
	{"moretrees:cedar_leaves", false},
	{"moretrees:date_palm_leaves", false},
	{"moretrees:fir_leaves", false},
	{"moretrees:fir_leaves_bright", false},
	{"moretrees:jungletree_leaves_green", false},
	{"moretrees:jungletree_leaves_yellow", false},
	{"moretrees:jungletree_leaves_red", false},
	{"moretrees:oak_leaves", false},
	{"moretrees:palm_leaves", false},
	{"moretrees:poplar_leaves", false},
	{"moretrees:pine_leaves", false},
	{"moretrees:sequoia_leaves", false},
	{"moretrees:spruce_leaves", false},
	{"moretrees:willow_leaves", false},
	-- Support moretrees (fruit)
	{"moretrees:acorn", false},
	{"moretrees:apple_blossoms", false},
	{"moretrees:cedar_cone", false},
	{"moretrees:coconut", false},
	{"moretrees:coconut_0", false},
	{"moretrees:coconut_1", false},
	{"moretrees:coconut_2", false},
	{"moretrees:coconut_3", false},
	{"moretrees:dates_f0", false},
	{"moretrees:dates_f1", false},
	{"moretrees:dates_f2", false},
	{"moretrees:dates_f3", false},
	{"moretrees:dates_f4", false},
	{"moretrees:dates_fn", false},
	{"moretrees:dates_m0", false},
	{"moretrees:dates_n", false},
	{"moretrees:fir_cone", false},
	{"moretrees:pine_cone", false},
	{"moretrees:spruce_cone", false},

	-- Support growing_trees
	{"growing_trees:trunk", true},
	{"growing_trees:medium_trunk", true},
	{"growing_trees:big_trunk", true},
	{"growing_trees:trunk_top", true},
	{"growing_trees:trunk_sprout", true},
	{"growing_trees:branch_sprout", true},
	{"growing_trees:branch", true},
	{"growing_trees:branch_xmzm", true},
	{"growing_trees:branch_xpzm", true},
	{"growing_trees:branch_xmzp", true},
	{"growing_trees:branch_xpzp", true},
	{"growing_trees:branch_zz", true},
	{"growing_trees:branch_xx", true},
	{"growing_trees:leaves", false},

	-- Support cool_trees
	{"bamboo:trunk", true},
	{"bamboo:leaves", false},
	{"birch:trunk", true},
	{"birch:leaves", false},
	{"cherrytree:trunk", true},
	{"cherrytree:blossom_leaves", false},
	{"cherrytree:leaves", false},
	{"chestnuttree:trunk", true},
	{"chestnuttree:leaves", false},
	{"clementinetree:trunk", true},
	{"clementinetree:leaves", false},
	{"ebony:trunk", true},
	{"ebony:creeper", false},
	{"ebony:creeper_leaves", false},
	{"ebony:leaves", false},
	{"jacaranda:trunk", true},
	{"jacaranda:blossom_leaves", false},
	{"larch:trunk", true},
	{"larch:leaves", false},
	{"lemontree:trunk", true},
	{"lemontree:leaves", false},
	{"mahogany:trunk", true},
	{"mahogany:leaves", false},
	{"palm:trunk", true},
	{"palm:leaves", false},

	-- Support growing_cactus
	{"growing_cactus:sprout", true},
	{"growing_cactus:branch_sprout_vertical", true},
	{"growing_cactus:branch_sprout_vertical_fixed", true},
	{"growing_cactus:branch_sprout_xp", true},
	{"growing_cactus:branch_sprout_xm", true},
	{"growing_cactus:branch_sprout_zp", true},
	{"growing_cactus:branch_sprout_zm", true},
	{"growing_cactus:trunk", true},
	{"growing_cactus:branch_trunk", true},
	{"growing_cactus:branch", true},
	{"growing_cactus:branch_xp", true},
	{"growing_cactus:branch_xm", true},
	{"growing_cactus:branch_zp", true},
	{"growing_cactus:branch_zm", true},
	{"growing_cactus:branch_zz", true},
	{"growing_cactus:branch_xx", true},

	-- Support farming_plus
	{"farming_plus:banana_leaves", false},
	{"farming_plus:banana", false},
	{"farming_plus:cocoa_leaves", false},
	{"farming_plus:cocoa", false},

	-- Support nature
	{"nature:blossom", false},

	-- Support snow
	{"snow:needles", false},
	{"snow:needles_decorated", false},
	{"snow:star", false},

	-- Support vines (also generated by moretrees if available)
	{"vines:vines", false},

	{"trunks:moss", false},
	{"trunks:moss_fungus", false},
	{"trunks:treeroot", false},

	-- Support ethereal
	{"ethereal:bamboo", true},
	{"ethereal:bamboo_leaves", false},
	{"ethereal:banana_trunk", true},
	{"ethereal:bananaleaves", false},
	{"ethereal:banana", false},
	{"ethereal:birch_trunk", true},
	{"ethereal:birch_leaves", false},
	{"ethereal:frost_tree", true},
	{"ethereal:frost_leaves", false},
	{"ethereal:mushroom_trunk", true},
	{"ethereal:mushroom", false},
	{"ethereal:mushroom_pore", true},
	{"ethereal:orangeleaves", false},
	{"ethereal:orange", false},
	{"ethereal:palm_trunk", true},
	{"ethereal:palmleaves", false},
	{"ethereal:coconut", false},
	{"ethereal:redwood_trunk", true},
	{"ethereal:redwood_leaves", false},
	{"ethereal:sakura_trunk", true},
	{"ethereal:sakura_leaves", false},
	{"ethereal:sakura_leaves2", false},
	{"ethereal:scorched_tree", true},
	{"ethereal:willow_trunk", true},
	{"ethereal:willow_twig", false},
	{"ethereal:yellow_trunk", true},
	{"ethereal:yellowleaves", false},
	{"ethereal:golden_apple", false},
}

local timber_nodenames = {}
for _, node in pairs(nodes) do
	if chainsaw_leaves or node[2] then
		timber_nodenames[node[1]] = true
	end
end

local S = technic.getter

technic.register_power_tool("technic:chainsaw", chainsaw_max_charge)

-- This function checks if the specified node should be sawed
local function check_if_node_sawed(pos)
	local node_name = minetest.get_node(pos).name
	if timber_nodenames[node_name]
			or (chainsaw_leaves and minetest.get_item_group(node_name, "leaves") ~= 0)
			or minetest.get_item_group(node_name, "tree") ~= 0 then
		return true
	end

	return false
end

-- Table for saving what was sawed down
local produced = {}

-- Save the items sawed down so that we can drop them in a nice single stack
local function handle_drops(drops)
	for _, item in ipairs(drops) do
		local stack = ItemStack(item)
		local name = stack:get_name()
		local p = produced[name]
		if not p then
			produced[name] = stack
		else
			p:set_count(p:get_count() + stack:get_count())
		end
	end
end

--- Iterator over positions to try to saw around a sawed node.
-- This returns positions in a 3x1x3 area around the position, plus the
-- position above it.  This does not return the bottom position to prevent
-- the chainsaw from cutting down nodes below the cutting position.
-- @param pos Sawing position.
local function iterSawTries(pos)
	-- Copy position to prevent mangling it
	local pos = vector.new(pos)
	local i = 0

	return function()
		i = i + 1
		-- Given a (top view) area like so (where 5 is the starting position):
		-- X -->
		-- Z 123
		-- | 456
		-- V 789
		-- This will return positions 1, 4, 7, 2, 8 (skip 5), 3, 6, 9,
		-- and the position above 5.
		if i == 1 then
			-- Move to starting position
			pos.x = pos.x - 1
			pos.z = pos.z - 1
		elseif i == 4 or i == 7 then
			-- Move to next X and back to start of Z when we reach
			-- the end of a Z line.
			pos.x = pos.x + 1
			pos.z = pos.z - 2
		elseif i == 5 then
			-- Skip the middle position (we've already run on it)
			-- and double-increment the counter.
			pos.z = pos.z + 2
			i = i + 1
		elseif i <= 9 then
			-- Go to next Z.
			pos.z = pos.z + 1
		elseif i == 10 then
			-- Move back to center and up.
			-- The Y+ position must be last so that we don't dig
			-- straight upward and not come down (since the Y-
			-- position isn't checked).
			pos.x = pos.x - 1
			pos.z = pos.z - 1
			pos.y = pos.y + 1
		else
			return nil
		end
		return pos
	end
end

-- This function does all the hard work. Recursively we dig the node at hand
-- if it is in the table and then search the surroundings for more stuff to dig.
local function recursive_dig(pos, remaining_charge)
	if remaining_charge < chainsaw_charge_per_node then
		return remaining_charge
	end
	local node = minetest.get_node(pos)

	if not check_if_node_sawed(pos) then
		return remaining_charge
	end

	-- Wood found - cut it
	handle_drops(minetest.get_node_drops(node.name, ""))
	minetest.remove_node(pos)
	remaining_charge = remaining_charge - chainsaw_charge_per_node

	-- Check surroundings and run recursively if any charge left
	for npos in iterSawTries(pos) do
		if remaining_charge < chainsaw_charge_per_node then
			break
		end
		if check_if_node_sawed(npos) then
			remaining_charge = recursive_dig(npos, remaining_charge)
		else
			minetest.check_for_falling(npos)
		end
	end
	return remaining_charge
end

-- Function to randomize positions for new node drops
local function get_drop_pos(pos)
	local drop_pos = {}

	for i = 0, 8 do
		-- Randomize position for a new drop
		drop_pos.x = pos.x + math.random(-3, 3)
		drop_pos.y = pos.y - 1
		drop_pos.z = pos.z + math.random(-3, 3)

		-- Move the randomized position upwards until
		-- the node is air or unloaded.
		for y = drop_pos.y, drop_pos.y + 5 do
			drop_pos.y = y
			local node = minetest.get_node_or_nil(drop_pos)

			if not node then
				-- If the node is not loaded yet simply drop
				-- the item at the original digging position.
				return pos
			elseif node.name == "air" then
				-- Add variation to the entity drop position,
				-- but don't let drops get too close to the edge
				drop_pos.x = drop_pos.x + (math.random() * 0.8) - 0.5
				drop_pos.z = drop_pos.z + (math.random() * 0.8) - 0.5
				return drop_pos
			end
		end
	end

	-- Return the original position if this takes too long
	return pos
end

-- Chainsaw entry point
local function chainsaw_dig(pos, current_charge)
	-- Start sawing things down
	local remaining_charge = recursive_dig(pos, current_charge)
	minetest.sound_play("chainsaw", {pos = pos, gain = 1.0,
			max_hear_distance = 10})

	-- Now drop items for the player
	for name, stack in pairs(produced) do
		-- Drop stacks of stack max or less
		local count, max = stack:get_count(), stack:get_stack_max()
		stack:set_count(max)
		while count > max do
			minetest.add_item(get_drop_pos(pos), stack)
			count = count - max
		end
		stack:set_count(count)
		minetest.add_item(get_drop_pos(pos), stack)
	end

	-- Clean up
	produced = {}

	return remaining_charge
end


minetest.register_tool("technic:chainsaw", {
	description = S("Chainsaw"),
	inventory_image = "technic_chainsaw.png",
	stack_max = 1,
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end

		local meta = minetest.deserialize(itemstack:get_metadata())
		if not meta or not meta.charge or
				meta.charge < chainsaw_charge_per_node then
			return
		end

		local name = user:get_player_name()
		if minetest.is_protected(pointed_thing.under, name) then
			minetest.record_protection_violation(pointed_thing.under, name)
			return
		end

		-- Send current charge to digging function so that the
		-- chainsaw will stop after digging a number of nodes
		meta.charge = chainsaw_dig(pointed_thing.under, meta.charge)
		if not technic.creative_mode then
			technic.set_RE_wear(itemstack, meta.charge, chainsaw_max_charge)
			itemstack:set_metadata(minetest.serialize(meta))
		end
		return itemstack
	end,
})

local mesecons_button = minetest.get_modpath("mesecons_button")
local trigger = mesecons_button and "mesecons_button:button_off" or "default:mese_crystal_fragment"

minetest.register_craft({
	output = "technic:chainsaw",
	recipe = {
		{"technic:stainless_steel_ingot", trigger,                      "technic:battery"},
		{"basic_materials:copper_wire",      "basic_materials:motor",              "technic:battery"},
		{"",                              "",                           "technic:stainless_steel_ingot"},
	},
	replacements = { {"basic_materials:copper_wire", "basic_materials:empty_spool"}, },

})

