-- NOTE: The code is takes directly from VanessaE's homedecor mod.
-- I just made it the lights into indictive appliances for this mod.

-- This file supplies electric powered glowlights

-- Boilerplate to support localized strings if intllib mod is installed.
local S
if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
else
	S = function (s) return s end
end

function technic_homedecor_node_is_owned(pos, placer)
        local ownername = false
        if type(isprotect) == "function" then -- glomie's protection mod
                if not isprotect(5, pos, placer) then
                        ownername = S("someone")
                end
        elseif type(protector) == "table" and type(protector.can_dig) == "function" then -- Zeg9's protection mod
                if not protector.can_dig(5, pos, placer) then
                        ownername = S("someone")
                end
        end

        if ownername ~= false then
                minetest.chat_send_player(placer:get_player_name(), S("Sorry, %s owns that spot."):format(ownername) )
                return true
        else
                return false
        end
end

local dirs2 = {9,  18,  7, 12}

local technic_homedecor_rotate_and_place = function(itemstack, placer, pointed_thing)
	if not technic_homedecor_node_is_owned(pointed_thing.under, placer)
	   and not technic_homedecor_node_is_owned(pointed_thing.above, placer) then
		local node = minetest.get_node(pointed_thing.under)
		if not minetest.registered_nodes[node.name] or not minetest.registered_nodes[node.name].on_rightclick then

			local above = pointed_thing.above
			local under = pointed_thing.under
			local pitch = placer:get_look_pitch()
			local pname = minetest.get_node(under).name
			local fdir = minetest.dir_to_facedir(placer:get_look_dir())
			local wield_name = itemstack:get_name()

			if not minetest.registered_nodes[pname]
			    or not minetest.registered_nodes[pname].on_rightclick then

				local iswall = (above.x ~= under.x) or (above.z ~= under.z)
				local isceiling = (above.x == under.x) and (above.z == under.z) and (pitch > 0)
				local pos1 = above

				if minetest.registered_nodes[pname]["buildable_to"] then
					pos1 = under
					iswall = false
				end

				if not minetest.registered_nodes[minetest.get_node(pos1).name]["buildable_to"] then return end

				if iswall then
					minetest.add_node(pos1, {name = wield_name, param2 = dirs2[fdir+1] }) -- place wall variant
				elseif isceiling then
					minetest.add_node(pos1, {name = wield_name, param2 = 20 }) -- place upside down variant
				else
					minetest.add_node(pos1, {name = wield_name, param2 = 0 }) -- place right side up
				end

				if not homedecor_expect_infinite_stacks then
					itemstack:take_item()
					return itemstack
				end
			end
		else
			minetest.registered_nodes[node.name].on_rightclick(pointed_thing.under, node, placer, itemstack)
		end
	end
end

-- Yellow -- Half node
minetest.register_node('technic:homedecor_glowlight_half_yellow', {
	description = S("Yellow Glowlight (thick)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_yellow_tb.png',
		'technic_homedecor_glowlight_yellow_tb.png',
		'technic_homedecor_glowlight_thick_yellow_sides.png',
		'technic_homedecor_glowlight_thick_yellow_sides.png',
		'technic_homedecor_glowlight_thick_yellow_sides.png',
		'technic_homedecor_glowlight_thick_yellow_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, 0, 0.5 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, 0, 0.5 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3 },
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 100, "Yellow Glowlight (thick)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_off(pos, 100, "technic:homedecor_glowlight_half_yellow_active")
		   end
})

minetest.register_node('technic:homedecor_glowlight_half_yellow_active', {
	description = S("Yellow Glowlight (thick)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_yellow_tb.png',
		'technic_homedecor_glowlight_yellow_tb.png',
		'technic_homedecor_glowlight_thick_yellow_sides.png',
		'technic_homedecor_glowlight_thick_yellow_sides.png',
		'technic_homedecor_glowlight_thick_yellow_sides.png',
		'technic_homedecor_glowlight_thick_yellow_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, 0, 0.5 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, 0, 0.5 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	light_source = minetest.LIGHT_MAX,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3, not_in_creative_inventory=1},
	drop="technic:homedecor_glowlight_half_yellow",
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 100, "Yellow Glowlight (thick)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_on(pos, 0, "technic:homedecor_glowlight_half_yellow")
		   end
})

-- Yellow -- Quarter node
minetest.register_node('technic:homedecor_glowlight_quarter_yellow', {
	description = S("Yellow Glowlight (thin)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_yellow_tb.png',
		'technic_homedecor_glowlight_yellow_tb.png',
		'technic_homedecor_glowlight_thin_yellow_sides.png',
		'technic_homedecor_glowlight_thin_yellow_sides.png',
		'technic_homedecor_glowlight_thin_yellow_sides.png',
		'technic_homedecor_glowlight_thin_yellow_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3 },
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 100, "Yellow Glowlight (thin)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_off(pos, 100, "technic:homedecor_glowlight_quarter_yellow_active")
		   end
})

minetest.register_node('technic:homedecor_glowlight_quarter_yellow_active', {
	description = S("Yellow Glowlight (thin)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_yellow_tb.png',
		'technic_homedecor_glowlight_yellow_tb.png',
		'technic_homedecor_glowlight_thin_yellow_sides.png',
		'technic_homedecor_glowlight_thin_yellow_sides.png',
		'technic_homedecor_glowlight_thin_yellow_sides.png',
		'technic_homedecor_glowlight_thin_yellow_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	light_source = minetest.LIGHT_MAX-1,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3, not_in_creative_inventory=1},
	drop="technic:homedecor_glowlight_quarter_yellow",
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 100, "Yellow Glowlight (thin)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_on(pos, 0, "technic:homedecor_glowlight_quarter_yellow")
		   end
})


-- White -- half node
minetest.register_node('technic:homedecor_glowlight_half_white', {
	description = S("White Glowlight (thick)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_white_tb.png',
		'technic_homedecor_glowlight_white_tb.png',
		'technic_homedecor_glowlight_thick_white_sides.png',
		'technic_homedecor_glowlight_thick_white_sides.png',
		'technic_homedecor_glowlight_thick_white_sides.png',
		'technic_homedecor_glowlight_thick_white_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, 0, 0.5 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, 0, 0.5 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3 },
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 100, "White Glowlight (thick)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_off(pos, 100, "technic:homedecor_glowlight_half_white_active")
		   end
})

minetest.register_node('technic:homedecor_glowlight_half_white_active', {
	description = S("White Glowlight (thick)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_white_tb.png',
		'technic_homedecor_glowlight_white_tb.png',
		'technic_homedecor_glowlight_thick_white_sides.png',
		'technic_homedecor_glowlight_thick_white_sides.png',
		'technic_homedecor_glowlight_thick_white_sides.png',
		'technic_homedecor_glowlight_thick_white_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, 0, 0.5 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, 0, 0.5 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	light_source = minetest.LIGHT_MAX,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3, not_in_creative_inventory=1},
	drop="technic:homedecor_glowlight_half_white",
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 100, "White Glowlight (thick)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_on(pos, 0, "technic:homedecor_glowlight_half_white")
		   end
})

-- White -- Quarter node
minetest.register_node('technic:homedecor_glowlight_quarter_white', {
	description = S("White Glowlight (thin)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_white_tb.png',
		'technic_homedecor_glowlight_white_tb.png',
		'technic_homedecor_glowlight_thin_white_sides.png',
		'technic_homedecor_glowlight_thin_white_sides.png',
		'technic_homedecor_glowlight_thin_white_sides.png',
		'technic_homedecor_glowlight_thin_white_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3 },
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 100, "White Glowlight (thin)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_off(pos, 100, "technic:homedecor_glowlight_quarter_white_active")
		   end
})

minetest.register_node('technic:homedecor_glowlight_quarter_white_active', {
	description = S("White Glowlight (thin)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_white_tb.png',
		'technic_homedecor_glowlight_white_tb.png',
		'technic_homedecor_glowlight_thin_white_sides.png',
		'technic_homedecor_glowlight_thin_white_sides.png',
		'technic_homedecor_glowlight_thin_white_sides.png',
		'technic_homedecor_glowlight_thin_white_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	light_source = minetest.LIGHT_MAX-1,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3, not_in_creative_inventory=1},
	drop="technic:homedecor_glowlight_quarter_white",
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 100, "White Glowlight (thin)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_on(pos, 0, "technic:homedecor_glowlight_quarter_white")
		   end
})

-- Glowlight "cubes" - yellow
minetest.register_node('technic:homedecor_glowlight_small_cube_yellow', {
	description = S("Yellow Glowlight (small cube)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_cube_yellow_tb.png',
		'technic_homedecor_glowlight_cube_yellow_tb.png',
		'technic_homedecor_glowlight_cube_yellow_sides.png',
		'technic_homedecor_glowlight_cube_yellow_sides.png',
		'technic_homedecor_glowlight_cube_yellow_sides.png',
		'technic_homedecor_glowlight_cube_yellow_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3 },
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 50, "Yellow Glowlight (small cube)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_off(pos, 50, "technic:homedecor_glowlight_small_cube_yellow_active")
		   end
})

minetest.register_node('technic:homedecor_glowlight_small_cube_yellow_active', {
	description = S("Yellow Glowlight (small cube)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_cube_yellow_tb.png',
		'technic_homedecor_glowlight_cube_yellow_tb.png',
		'technic_homedecor_glowlight_cube_yellow_sides.png',
		'technic_homedecor_glowlight_cube_yellow_sides.png',
		'technic_homedecor_glowlight_cube_yellow_sides.png',
		'technic_homedecor_glowlight_cube_yellow_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	light_source = minetest.LIGHT_MAX-1,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3, not_in_creative_inventory=1},
	drop="technic:homedecor_glowlight_small_cube_yellow",
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 50, "Yellow Glowlight (small cube)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_on(pos, 0, "technic:homedecor_glowlight_small_cube_yellow")
		   end
})

-- Glowlight "cubes" - white
minetest.register_node('technic:homedecor_glowlight_small_cube_white', {
	description = S("White Glowlight (small cube)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_cube_white_tb.png',
		'technic_homedecor_glowlight_cube_white_tb.png',
		'technic_homedecor_glowlight_cube_white_sides.png',
		'technic_homedecor_glowlight_cube_white_sides.png',
		'technic_homedecor_glowlight_cube_white_sides.png',
		'technic_homedecor_glowlight_cube_white_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3 },
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 50, "White Glowlight (small cube)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_off(pos, 50, "technic:homedecor_glowlight_small_cube_white_active")
		   end
})

minetest.register_node('technic:homedecor_glowlight_small_cube_white_active', {
	description = S("White Glowlight (small cube)"),
	drawtype = "nodebox",
	tiles = {
		'technic_homedecor_glowlight_cube_white_tb.png',
		'technic_homedecor_glowlight_cube_white_tb.png',
		'technic_homedecor_glowlight_cube_white_sides.png',
		'technic_homedecor_glowlight_cube_white_sides.png',
		'technic_homedecor_glowlight_cube_white_sides.png',
		'technic_homedecor_glowlight_cube_white_sides.png'
	},
        selection_box = {
                type = "fixed",
                fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
        },

	sunlight_propagates = false,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	light_source = minetest.LIGHT_MAX-1,
	sounds = default.node_sound_wood_defaults(),

	groups = { snappy = 3, not_in_creative_inventory=1},
	drop="technic:homedecor_glowlight_small_cube_white",
	on_place = function(itemstack, placer, pointed_thing)
		technic_homedecor_rotate_and_place(itemstack, placer, pointed_thing)
		return itemstack
	     end,
	on_construct = function(pos)
			  technic.inductive_on_construct(pos, 50, "White Glowlight (small cube)")
		       end,
	on_punch = function(pos, node, puncher)
		      technic.inductive_on_punch_on(pos, 0, "technic:homedecor_glowlight_small_cube_white")
		   end
})

technic.register_inductive_machine("technic:homedecor_glowlight_half_yellow")
technic.register_inductive_machine("technic:homedecor_glowlight_half_white")
technic.register_inductive_machine("technic:homedecor_glowlight_quarter_yellow")
technic.register_inductive_machine("technic:homedecor_glowlight_quarter_white")
technic.register_inductive_machine("technic:homedecor_glowlight_small_cube_yellow")
technic.register_inductive_machine("technic:homedecor_glowlight_small_cube_white")
