--Minetest 0.4.7 mod: concrete 
--(c) 2013 by RealBadAngel <mk@realbadangel.pl>

local technic = rawget(_G, "technic") or {}
technic.concrete_posts = {}

-- Boilerplate to support localized strings if intllib mod is installed.
local S = rawget(_G, "intllib") and intllib.Getter() or function(s) return s end

minetest.register_alias("technic:concrete_post",   "technic:concrete_post0")
minetest.register_alias("technic:concrete_post32", "technic:concrete_post12")
minetest.register_alias("technic:concrete_post33", "technic:concrete_post3")
minetest.register_alias("technic:concrete_post34", "technic:concrete_post28")
minetest.register_alias("technic:concrete_post35", "technic:concrete_post19")

local steel_ingot
if minetest.get_modpath("technic_worldgen") then
	steel_ingot = "technic:carbon_steel_ingot"
else
	steel_ingot = "default:steel_ingot"
end

minetest.register_craft({
	output = 'technic:rebar 6',
	recipe = {
		{'','', steel_ingot},
		{'',steel_ingot,''},
		{steel_ingot, '', ''},
	}
})

minetest.register_craft({
	output = 'technic:concrete 5',
	recipe = {
		{'default:stone','technic:rebar','default:stone'},
		{'technic:rebar','default:stone','technic:rebar'},
		{'default:stone','technic:rebar','default:stone'},
	}
})

minetest.register_craft({
	output = 'technic:concrete_post_platform 6',
	recipe = {
		{'technic:concrete','technic:concrete_post0','technic:concrete'},
	}
})

minetest.register_craft({
	output = 'technic:concrete_post0 12',
	recipe = {
		{'default:stone','technic:rebar','default:stone'},
		{'default:stone','technic:rebar','default:stone'},
		{'default:stone','technic:rebar','default:stone'},
}
})

minetest.register_craft({
	output = 'technic:blast_resistant_concrete 5',
	recipe = {
		{'technic:concrete','technic:composite_plate','technic:concrete'},
		{'technic:composite_plate','technic:concrete','technic:composite_plate'},
		{'technic:concrete','technic:composite_plate','technic:concrete'},
	}
})

local box_platform = {-0.5,  0.3,  -0.5,  0.5,  0.5, 0.5}
local box_center   = {-0.15, -0.5, -0.15, 0.15, 0.5, 0.15}
local box_x1       = {0,     -0.3, -0.1,  0.5,  0.3, 0.1}
local box_z1       = {-0.1,  -0.3, 0,     0.1,  0.3, 0.5}
local box_x2       = {0,     -0.3, -0.1,  -0.5, 0.3, 0.1}
local box_z2       = {-0.1,  -0.3, 0,     0.1,  0.3, -0.5}

minetest.register_craftitem(":technic:rebar", {
	description = S("Rebar"),
	inventory_image = "technic_rebar.png",
})

minetest.register_node(":technic:concrete", {
	description = S("Concrete Block"),
	tile_images = {"technic_concrete_block.png",},
	groups = {cracky=1, level=2, concrete=1},
	sounds = default.node_sound_stone_defaults(),
	after_place_node = function(pos, placer, itemstack)
		technic.update_posts(pos, false)
	end,
	after_dig_node = function (pos, oldnode, oldmetadata, digger)
		technic.update_posts(pos, false)
	end,
})

minetest.register_node(":technic:blast_resistant_concrete", {
	description = S("Blast-resistant Concrete Block"),
	tile_images = {"technic_blast_resistant_concrete_block.png",},
	groups={cracky=1, level=3, concrete=1},
	sounds = default.node_sound_stone_defaults(),
	after_place_node = function(pos, player, itemstack)
		technic.update_posts(pos, false)
	end,
	after_dig_node = function (pos, oldnode, oldmetadata, digger)
		technic.update_posts(pos, false)
	end,
})

minetest.register_node(":technic:concrete_post_platform", {
	description = S("Concrete Post Platform"),
	tile_images = {"technic_concrete_block.png",},
	groups={cracky=1, level=2},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	drawtype = "nodebox", 
	node_box = {
		type = "fixed",
		fixed = {box_platform}
	},
	on_place = function (itemstack, placer, pointed_thing)
		local node = minetest.get_node(pointed_thing.under)
		if not technic.concrete_posts[node.name] then 
			return minetest.item_place_node(itemstack, placer, pointed_thing) 
		end
		local links = technic.concrete_posts[node.name]
		if links[6] ~= 0 then -- The post already has a platform
			return minetest.item_place_node(itemstack, placer, pointed_thing) 
		end
		local id = technic.get_post_id({links[1], links[2], links[3], links[4], links[5], 1})
		minetest.set_node(pointed_thing.under, {name="technic:concrete_post"..id})
		itemstack:take_item()
		placer:set_wielded_item(itemstack)
		return itemstack
	end,
})

local function gen_post_nodebox(x1, x2, z1, z2, y, platform)
	local box
	local xx = x1 + x2
	local zz = z1 + z2
	if ((xx == 2 and zz == 0) or (xx == 0 and zz == 2)) and y == 0 then
		box = {}
	else 
		box = {box_center}
	end
	if x1 ~= 0 then
		table.insert(box, box_x1)
	end
	if x2 ~= 0 then
		table.insert(box, box_x2)
	end
	if z1 ~= 0 then
		table.insert(box, box_z1)
	end
	if z2 ~= 0 then
		table.insert(box, box_z2)
	end
	if platform ~= 0 then
		table.insert(box, box_platform)
	end
	return box
end

local function dig_post_with_platform(pos, oldnode, oldmetadata)
	oldnode.name = "technic:concrete_post0"
	minetest.set_node(pos, oldnode)
	technic.update_posts(pos, true)
end

function technic.posts_should_connect(pos)
	local node = minetest.get_node(pos)
	if technic.concrete_posts[node.name] then
		return "post"
	elseif minetest.get_item_group(node.name, "concrete") ~= 0 then
		return "block"
	end
end

function technic.get_post_id(links)
	return (links[1] * 1) + (links[2] * 2)
		+ (links[3] * 4) + (links[4] * 8)
		+ (links[5] * 16) + (links[6] * 32)
end

function technic.update_posts(pos, set, secondrun)
	local node = minetest.get_node(pos)
	local link_positions = {
		{x=pos.x+1, y=pos.y,   z=pos.z},
		{x=pos.x-1, y=pos.y,   z=pos.z},
		{x=pos.x,   y=pos.y,   z=pos.z+1},
		{x=pos.x,   y=pos.y,   z=pos.z-1},
		{x=pos.x,   y=pos.y-1,   z=pos.z},
		{x=pos.x,   y=pos.y+1,   z=pos.z},
	}

	local links = {0, 0, 0, 0, 0, 0}

	for i, link_pos in pairs(link_positions) do
		local connecttype = technic.posts_should_connect(link_pos)
		if connecttype then
			links[i] = 1
			-- Have posts next to us update theirselves,
			-- but only once. (We don't want to start an
			-- infinite loop of updates)
			if not secondrun and connecttype == "post" then
				technic.update_posts(link_pos, true, true)
			end
		end
	end

	if links[5] == 1 or links[6] == 1 then
		links[5] = 1
		links[6] = 0
	end

	-- We don't want to set ourselves if we have been removed or we are
	-- updating a concrete node
	if set then
		-- Preserve platform
		local oldlinks = technic.concrete_posts[node.name]
		if oldlinks then
			links[6] = oldlinks[6]
		end
		minetest.set_node(pos, {name="technic:concrete_post"
				..technic.get_post_id(links)})
	end
end

for x1 = 0, 1 do
for x2 = 0, 1 do
for z1 = 0, 1 do
for z2 = 0, 1 do
for y = 0, 1 do
for platform = 0, 1 do
	local links = {x1, x2, z1, z2, y, platform}
	local id = technic.get_post_id(links)
	technic.concrete_posts["technic:concrete_post"..id] = links

	local groups = {cracky=1, level=2, concrete_post=1}
	if id ~= 0 then
		groups.not_in_creative_inventory = 1
	end
	
	local drop = "technic:concrete_post0"
	local after_dig_node = function(pos, oldnode, oldmetadata, digger)
		technic.update_posts(pos, false)
	end
	if platform ~= 0 then
		drop = "technic:concrete_post_platform"
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_post_with_platform(pos, oldnode, oldmetadata)
		end
	end

	minetest.register_node(":technic:concrete_post"..id, {
		description = S("Concrete Post"),
		tiles = {"technic_concrete_block.png"},
		groups = groups,
		sounds = default.node_sound_stone_defaults(),
		drop = drop,
		paramtype = "light",
		sunlight_propagates = true,
		drawtype = "nodebox", 
		node_box = {
			type = "fixed",
			fixed = gen_post_nodebox(x1, x2, z1, z2, y, platform),
		},
		after_place_node = function(pos, placer, itemstack)
			technic.update_posts(pos, true)
		end,
		after_dig_node = after_dig_node,
	})
end
end
end
end
end
end

