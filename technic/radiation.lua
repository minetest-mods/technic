--[[
Radioactivity

Radiation resistance represents the extent to which a material
attenuates radiation passing through it; i.e., how good a radiation
shield it is.  This is identified per node type.  For materials that
exist in real life, the radiation resistance value that this system
uses for a node type consisting of a solid cube of that material is the
(approximate) number of halvings of ionising radiation that is achieved
by a meter of the material in real life.  This is approximately
proportional to density, which provides a good way to estimate it.
Homogeneous mixtures of materials have radiation resistance computed
by a simple weighted mean.  Note that the amount of attenuation that
a material achieves in-game is not required to be (and is not) the
same as the attenuation achieved in real life.

Radiation resistance for a node type may be specified in the node
definition, under the key "radiation_resistance".  As an interim
measure, until node definitions widely include this, this code
knows a bunch of values for particular node types in several mods,
and values for groups of node types.  The node definition takes
precedence if it specifies a value.  Nodes for which no value at
all is known are taken to provide no radiation resistance at all;
this is appropriate for the majority of node types.  Only node types
consisting of a fairly homogeneous mass of material should report
non-zero radiation resistance; anything with non-uniform geometry
or complex internal structure should show no radiation resistance.
Fractional resistance values are permitted.
--]]

local S = technic.getter

local rad_resistance_node = {
	["default:brick"] = 13,
	["default:bronzeblock"] = 45,
	["default:clay"] = 15,
	["default:coalblock"] = 9.6,
	["default:cobble"] = 15,
	["default:copperblock"] = 46,
	["default:desert_cobble"] = 15,
	["default:desert_sand"] = 10,
	["default:desert_stone"] = 17,
	["default:desert_stonebrick"] = 17,
	["default:diamondblock"] = 24,
	["default:dirt"] = 8.2,
	["default:dirt_with_grass"] = 8.2,
	["default:dirt_with_grass_footsteps"] = 8.2,
	["default:dirt_with_snow"] = 8.2,
	["default:glass"] = 17,
	["default:goldblock"] = 170,
	["default:gravel"] = 10,
	["default:ice"] = 5.6,
	["default:lava_flowing"] = 8.5,
	["default:lava_source"] = 17,
	["default:mese"] = 21,
	["default:mossycobble"] = 15,
	["default:tinblock"] = 37,
	["pbj_pup:pbj_pup"] = 10000,
	["pbj_pup:pbj_pup_candies"] = 10000,
	["gloopblocks:rainbow_block_diagonal"] = 5000,
	["gloopblocks:rainbow_block_horizontal"] = 10000,
	["default:nyancat"] = 10000,
	["default:nyancat_rainbow"] = 10000,
	["nyancat:nyancat"] = 10000,
	["nyancat:nyancat_rainbow"] = 10000,
	["default:obsidian"] = 18,
	["default:obsidian_glass"] = 18,
	["default:sand"] = 10,
	["default:sandstone"] = 15,
	["default:sandstonebrick"] = 15,
	["default:snowblock"] = 1.7,
	["default:steelblock"] = 40,
	["default:stone"] = 17,
	["default:stone_with_coal"] = 16,
	["default:stone_with_copper"] = 20,
	["default:stone_with_diamond"] = 18,
	["default:stone_with_gold"] = 34,
	["default:stone_with_iron"] = 20,
	["default:stone_with_mese"] = 17,
	["default:stone_with_tin"] = 19,
	["default:stonebrick"] = 17,
	["default:water_flowing"] = 2.8,
	["default:water_source"] = 5.6,
	["farming:desert_sand_soil"] = 10,
	["farming:desert_sand_soil_wet"] = 10,
	["farming:soil"] = 8.2,
	["farming:soil_wet"] = 8.2,
	["glooptest:akalin_crystal_glass"] = 21,
	["glooptest:akalinblock"] = 40,
	["glooptest:alatro_crystal_glass"] = 21,
	["glooptest:alatroblock"] = 40,
	["glooptest:amethystblock"] = 18,
	["glooptest:arol_crystal_glass"] = 21,
	["glooptest:crystal_glass"] = 21,
	["glooptest:emeraldblock"] = 19,
	["glooptest:heavy_crystal_glass"] = 21,
	["glooptest:mineral_akalin"] = 20,
	["glooptest:mineral_alatro"] = 20,
	["glooptest:mineral_amethyst"] = 17,
	["glooptest:mineral_arol"] = 20,
	["glooptest:mineral_desert_coal"] = 16,
	["glooptest:mineral_desert_iron"] = 20,
	["glooptest:mineral_emerald"] = 17,
	["glooptest:mineral_kalite"] = 20,
	["glooptest:mineral_ruby"] = 18,
	["glooptest:mineral_sapphire"] = 18,
	["glooptest:mineral_talinite"] = 20,
	["glooptest:mineral_topaz"] = 18,
	["glooptest:reinforced_crystal_glass"] = 21,
	["glooptest:rubyblock"] = 27,
	["glooptest:sapphireblock"] = 27,
	["glooptest:talinite_crystal_glass"] = 21,
	["glooptest:taliniteblock"] = 40,
	["glooptest:topazblock"] = 24,
	["mesecons_extrawires:mese_powered"] = 21,
	["moreblocks:cactus_brick"] = 13,
	["moreblocks:cactus_checker"] = 8.5,
	["moreblocks:circle_stone_bricks"] = 17,
	["moreblocks:clean_glass"] = 17,
	["moreblocks:coal_checker"] = 9.0,
	["moreblocks:coal_glass"] = 17,
	["moreblocks:coal_stone"] = 17,
	["moreblocks:coal_stone_bricks"] = 17,
	["moreblocks:glow_glass"] = 17,
	["moreblocks:grey_bricks"] = 15,
	["moreblocks:iron_checker"] = 11,
	["moreblocks:iron_glass"] = 17,
	["moreblocks:iron_stone"] = 17,
	["moreblocks:iron_stone_bricks"] = 17,
	["moreblocks:plankstone"] = 9.3,
	["moreblocks:split_stone_tile"] = 15,
	["moreblocks:split_stone_tile_alt"] = 15,
	["moreblocks:stone_tile"] = 15,
	["moreblocks:super_glow_glass"] = 17,
	["moreblocks:tar"] = 7.0,
	["moreblocks:wood_tile"] = 1.7,
	["moreblocks:wood_tile_center"] = 1.7,
	["moreblocks:wood_tile_down"] = 1.7,
	["moreblocks:wood_tile_flipped"] = 1.7,
	["moreblocks:wood_tile_full"] = 1.7,
	["moreblocks:wood_tile_left"] = 1.7,
	["moreblocks:wood_tile_right"] = 1.7,
	["moreblocks:wood_tile_up"] = 1.7,
	["moreores:mineral_mithril"] = 18,
	["moreores:mineral_silver"] = 21,
	["moreores:mithril_block"] = 26,
	["moreores:silver_block"] = 53,
	["snow:snow_brick"] = 2.8,
	["basic_materials:brass_block"] = 43,
	["technic:carbon_steel_block"] = 40,
	["technic:cast_iron_block"] = 40,
	["technic:chernobylite_block"] = 40,
	["technic:chromium_block"] = 37,
	["technic:corium_flowing"] = 40,
	["technic:corium_source"] = 80,
	["technic:granite"] = 18,
	["technic:lead_block"] = 80,
	["technic:marble"] = 18,
	["technic:marble_bricks"] = 18,
	["technic:mineral_chromium"] = 19,
	["technic:mineral_uranium"] = 71,
	["technic:mineral_zinc"] = 19,
	["technic:stainless_steel_block"] = 40,
	["technic:zinc_block"] = 36,
	["tnt:tnt"] = 11,
	["tnt:tnt_burning"] = 11,
}
local rad_resistance_group = {
	concrete = 16,
	tree = 3.4,
	uranium_block = 500,
	wood = 1.7,
}
local cache_radiation_resistance = {}
local function node_radiation_resistance(node_name)
	local resistance = cache_radiation_resistance[node_name]
	if resistance then
		return resistance
	end
	local def = minetest.registered_nodes[node_name]
	if not def then
		cache_radiation_resistance[node_name] = 0
		return 0
	end
	resistance = def.radiation_resistance or
			rad_resistance_node[node_name]
	if not resistance then
		resistance = 0
		for g, v in pairs(def.groups) do
			if v > 0 and rad_resistance_group[g] then
				resistance = resistance + rad_resistance_group[g]
			end
		end
	end
	resistance = math.sqrt(resistance)
	cache_radiation_resistance[node_name] = resistance
	return resistance
end


--[[
Radioactive nodes cause damage to nearby players.  The damage
effect depends on the intrinsic strength of the radiation source,
the distance between the source and the player, and the shielding
effect of the intervening material.  These determine a rate of damage;
total damage caused is the integral of this over time.

In the absence of effective shielding, for a specific source the
damage rate varies realistically in inverse proportion to the square
of the distance.  (Distance is measured to the player's abdomen,
not to the nominal player position which corresponds to the foot.)
However, if the player is inside a non-walkable (liquid or gaseous)
radioactive node, the nominal distance could go to zero, yielding
infinite damage.  In that case, the player's body is displacing the
radioactive material, so the effective distance should remain non-zero.
We therefore apply a lower distance bound of sqrt(0.75), which is
the maximum distance one can get from the node center within the node.

A radioactive node is identified by being in the "radioactive" group,
and the group value signifies the strength of the radiation source.
The group value is the distance from a node at which an unshielded
player will be damaged by 1 HP/s.  Or, equivalently, it is the square
root of the damage rate in HP/s that an unshielded player one node
away will take.

Shielding is assessed by adding the shielding values of all nodes
between the source node and the player, ignoring the source node itself.
As in reality, shielding causes exponential attenuation of radiation.
However, the effect is scaled down relative to real life.  A node with
radiation resistance value R yields attenuation of sqrt(R) * 0.1 nepers.
(In real life it would be about R * 0.69 nepers, by the definition
of the radiation resistance values.)  The sqrt part of this formula
scales down the differences between shielding types, reflecting the
game's simplification of making expensive materials such as gold
readily available in cubes.  The multiplicative factor in the
formula scales down the difference between shielded and unshielded
safe distances, avoiding the latter becoming impractically large.

Damage is processed at rates down to 0.2 HP/s, which in the absence of
shielding is attained at the distance specified by the "radioactive"
group value.  Computed damage rates below 0.2 HP/s result in no
damage at all to the player.  This gives the player an opportunity
to be safe, and limits the range at which source/player interactions
need to be considered.
--]]
local abdomen_offset = 1
local rad_dmg_cutoff = 0.2
local radiated_players = {}

local armor_enabled = technic.config:get_bool("enable_radiation_protection")
local entity_damage = technic.config:get_bool("enable_entity_radiation_damage")
local longterm_damage = technic.config:get_bool("enable_longterm_radiation_damage")

local function apply_fractional_damage(o, dmg)
	local dmg_int = math.floor(dmg)
	-- The closer you are to getting one more damage point,
	-- the more likely it will be added.
	if math.random() < dmg - dmg_int then
		dmg_int = dmg_int + 1
	end
	if dmg_int > 0 then
		local new_hp = math.max(o:get_hp() - dmg_int, 0)
		o:set_hp(new_hp)
		return new_hp == 0
	end
	return false
end

local function calculate_base_damage(node_pos, object_pos, strength)
	local shielding = 0
	local dist = vector.distance(node_pos, object_pos)

	for ray_pos in technic.trace_node_ray(node_pos,
			vector.direction(node_pos, object_pos), dist) do
		local shield_name = minetest.get_node(ray_pos).name
		shielding = shielding + node_radiation_resistance(shield_name) * 0.025
	end

	local dmg = (strength * strength) /
		(math.max(0.75, dist * dist) * math.exp(shielding))

	if dmg < rad_dmg_cutoff then return end
	return dmg
end

local function calculate_damage_multiplier(object)
	local ag = object.get_armor_groups and object:get_armor_groups()
	if not ag then
		return 0
	end
	if ag.immortal then
		return 0
	end
	if ag.radiation then
		return 0.01 * ag.radiation
	elseif armor_enabled then
		return 0
	end
	if ag.fleshy then
		return math.sqrt(0.01 * ag.fleshy)
	end
	return 0
end

local function calculate_object_center(object)
	if object:is_player() then
		return {x=0, y=abdomen_offset, z=0}
	end
	return {x=0, y=0, z=0}
end

local function dmg_object(pos, object, strength)
	local obj_pos = vector.add(object:get_pos(), calculate_object_center(object))
	local mul
	if armor_enabled or entity_damage then
		-- we need to check may the object be damaged even if armor is disabled
		mul = calculate_damage_multiplier(object)
		if mul == 0 then
			return
		end
	end
	local dmg = calculate_base_damage(pos, obj_pos, strength)
	if not dmg then
		return
	end
	if armor_enabled then
		dmg = dmg * mul
	end
	apply_fractional_damage(object, dmg)
	if longterm_damage and object:is_player() then
		local pn = object:get_player_name()
		radiated_players[pn] = (radiated_players[pn] or 0) + dmg
	end
end

local rad_dmg_mult_sqrt = math.sqrt(1 / rad_dmg_cutoff)
local function dmg_abm(pos, node)
	local strength = minetest.get_item_group(node.name, "radioactive")
	local max_dist = strength * rad_dmg_mult_sqrt
	for _, o in pairs(minetest.get_objects_inside_radius(pos,
			max_dist + abdomen_offset)) do
		if (entity_damage or o:is_player()) and o:get_hp() > 0 then
			dmg_object(pos, o, strength)
		end
	end
end

if minetest.settings:get_bool("enable_damage") then
	minetest.register_abm({
		label = "Radiation damage",
		nodenames = {"group:radioactive"},
		interval = 1,
		chance = 1,
		action = dmg_abm,
	})

	if longterm_damage then
		minetest.register_globalstep(function(dtime)
			for pn, dmg in pairs(radiated_players) do
				dmg = dmg - (dtime / 8)
				local player = minetest.get_player_by_name(pn)
				local killed
				if player and dmg > rad_dmg_cutoff then
					killed = apply_fractional_damage(player, (dmg * dtime) / 8)
				else
					dmg = nil
				end
				-- on_dieplayer will have already set this if the player died
				if not killed then
					radiated_players[pn] = dmg
				end
			end
		end)

		minetest.register_on_dieplayer(function(player)
			radiated_players[player:get_player_name()] = nil
		end)
	end
end

-- Radioactive materials that can result from destroying a reactor
local griefing = technic.config:get_bool("enable_corium_griefing")

for _, state in pairs({"flowing", "source"}) do
	minetest.register_node("technic:corium_"..state, {
		description = S(state == "source" and "Corium Source" or "Flowing Corium"),
		drawtype = (state == "source" and "liquid" or "flowingliquid"),
		tiles = {{
			name = "technic_corium_"..state.."_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		}},
		special_tiles = {
			{
				name = "technic_corium_"..state.."_animated.png",
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 3.0,
				},
			},
			{
				name = "technic_corium_"..state.."_animated.png",
				backface_culling = true,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 3.0,
				},
			},
		},
		paramtype = "light",
		paramtype2 = (state == "flowing" and "flowingliquid" or nil),
		light_source = (state == "source" and 8 or 5),
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		drop = "",
		drowning = 1,
		liquidtype = state,
		liquid_alternative_flowing = "technic:corium_flowing",
		liquid_alternative_source = "technic:corium_source",
		liquid_viscosity = 7, -- like lava
		liquid_renewable = false,
		damage_per_second = 6,
		post_effect_color = {a=192, r=80, g=160, b=80},
		groups = {
			liquid = 2,
			hot = 3,
			igniter = (griefing and 1 or 0),
			radioactive = (state == "source" and 12 or 6),
			not_in_creative_inventory = (state == "flowing" and 1 or nil),
		},
	})
end

if rawget(_G, "bucket") and bucket.register_liquid then
	bucket.register_liquid(
		"technic:corium_source",
		"technic:corium_flowing",
		"technic:bucket_corium",
		"technic_bucket_corium.png",
		"Corium Bucket"
	)
end

minetest.register_node("technic:chernobylite_block", {
        description = S("Chernobylite Block"),
	tiles = {"technic_chernobylite_block.png"},
	is_ground_content = true,
	groups = {cracky=1, radioactive=4, level=2},
	sounds = default.node_sound_stone_defaults(),
	light_source = 2,
})

minetest.register_abm({
	label = "Corium: boil-off water (sources)",
	nodenames = {"group:water"},
	neighbors = {"technic:corium_source"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		minetest.remove_node(pos)
	end,
})

minetest.register_abm({
	label = "Corium: boil-off water (flowing)",
	nodenames = {"technic:corium_flowing"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		minetest.set_node(pos, {name="technic:chernobylite_block"})
	end,
})

minetest.register_abm({
	label = "Corium: become chernobylite",
	nodenames = {"technic:corium_flowing"},
	interval = 5,
	chance = (griefing and 10 or 1),
	action = function(pos, node)
		minetest.set_node(pos, {name="technic:chernobylite_block"})
	end,
})

if griefing then
	minetest.register_abm({
		label = "Corium: griefing",
		nodenames = {"technic:corium_source", "technic:corium_flowing"},
		interval = 4,
		chance = 4,
		action = function(pos, node)
			for _, offset in ipairs({
				vector.new(1,0,0),
				vector.new(-1,0,0),
				vector.new(0,0,1),
				vector.new(0,0,-1),
				vector.new(0,-1,0),
			}) do
				if math.random(8) == 1 then
					minetest.dig_node(vector.add(pos, offset))
				end
			end
		end,
	})
end
