
minetest.register_craft({
	output = 'technic:wind_mill_frame 5',
	recipe = {
		{'default:steel_ingot', '',                    'default:steel_ingot'},
		{'',                    'default:steel_ingot', ''},
		{'default:steel_ingot', '',                    'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:wind_mill',
	recipe = {
		{'',                    'default:steel_ingot', ''},
		{'default:steel_ingot', 'technic:motor',       'default:steel_ingot'},
		{'',                    'default:steelblock',  ''},
	}
})

minetest.register_node("technic:wind_mill_frame", {
	description = "Wind Mill Frame",
	drawtype = "glasslike_framed",
	tiles = {"default_steel_block.png", "default_glass.png"},
	sunlight_propagates = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
})

minetest.register_node("technic:wind_mill", {
	description = "Wind Mill",
	tiles = {"default_steel_block.png"},
	paramtype2 = "facedir",
	groups = {cracky=1},
	sounds = default.node_sound_stone_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, -- Main box
			{-0.1, -0.1, -0.5,  0.1, 0.1, -0.6}, -- Shaft
			{-0.1, -1,   -0.6,  0.1, 1,   -0.7}, -- Vertical blades
			{-1,   -0.1, -0.6,  1,   0.1, -0.7}, -- Horizontal blades
		}
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Wind Mill")
		meta:set_int("MV_EU_supply", 0)
	end,	
})

local function check_wind_mill(pos)
	if pos.y < 30 then
		return false
	end
	for i = 1, 20 do
		local node = minetest.get_node({x=pos.x, y=pos.y-i, z=pos.z})
		if node.name ~= "technic:wind_mill_frame" then
			return false
		end
	end
	return true
end

minetest.register_abm({
	nodenames = {"technic:wind_mill"},
	interval = 1,
	chance   = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		local power = math.min(pos.y * 100, 5000)

		if not check_wind_mill(pos) then
			meta:set_int("MV_EU_supply", 0)
			meta:set_string("infotext", "Wind Mill Inproperly Placed")
			return
		else
			meta:set_int("MV_EU_supply", power)
		end

		meta:set_string("infotext", "Wind Mill ("..power.."EU)")
	end
})

technic.register_machine("MV", "technic:wind_mill", technic.producer)

