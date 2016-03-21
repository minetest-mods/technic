--[[
 The enriched uranium rod driven EU generator.
A very large and advanced machine providing vast amounts of power.
Very efficient but also expensive to run as it needs uranium.
Provides 10000 HV EUs for one week (only counted when loaded).

The nuclear reactor core requires a casing of water and a protective
shield to work.  This is checked now and then and if the casing is not
intact the reactor will melt down!
--]]

local burn_ticks = 7 * 24 * 60 * 60  -- Seconds
local power_supply = 100000  -- EUs
local fuel_type = "technic:uranium_fuel"  -- The reactor burns this

local S = technic.getter

local reactor_desc = S("@1 Nuclear Reactor Core", S("HV")),


-- FIXME: Recipe should make more sense like a rod recepticle, steam chamber, HV generator?
minetest.register_craft({
	output = 'technic:hv_nuclear_reactor_core',
	recipe = {
		{'technic:carbon_plate',          'default:obsidian_glass', 'technic:carbon_plate'},
		{'technic:composite_plate',       'technic:machine_casing', 'technic:composite_plate'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable',       'technic:stainless_steel_ingot'},
	}
})

local reactor_formspec =
	"invsize[8,9;]"..
	"label[0,0;"..S("Nuclear Reactor Rod Compartment").."]"..
	"list[current_name;src;2,1;3,2;]"..
	"list[current_player;main;0,5;8,4;]"..
	"listring[]"

-- "Boxy sphere"
local node_box = {
	{-0.353, -0.353, -0.353, 0.353, 0.353, 0.353}, -- Box
	{-0.495, -0.064, -0.064, 0.495, 0.064, 0.064}, -- Circle +-x
	{-0.483, -0.128, -0.128, 0.483, 0.128, 0.128},
	{-0.462, -0.191, -0.191, 0.462, 0.191, 0.191},
	{-0.433, -0.249, -0.249, 0.433, 0.249, 0.249},
	{-0.397, -0.303, -0.303, 0.397, 0.303, 0.303},
	{-0.305, -0.396, -0.305, 0.305, 0.396, 0.305}, -- Circle +-y
	{-0.250, -0.432, -0.250, 0.250, 0.432, 0.250},
	{-0.191, -0.461, -0.191, 0.191, 0.461, 0.191},
	{-0.130, -0.482, -0.130, 0.130, 0.482, 0.130},
	{-0.066, -0.495, -0.066, 0.066, 0.495, 0.066},
	{-0.064, -0.064, -0.495, 0.064, 0.064, 0.495}, -- Circle +-z
	{-0.128, -0.128, -0.483, 0.128, 0.128, 0.483},
	{-0.191, -0.191, -0.462, 0.191, 0.191, 0.462},
	{-0.249, -0.249, -0.433, 0.249, 0.249, 0.433},
	{-0.303, -0.303, -0.397, 0.303, 0.303, 0.397},
}

local SS_OFF = 0
local SS_DANGER = 1
local SS_CLEAR = 2

local reactor_siren = {}
local function siren_set_state(pos, state)
	local hpos = minetest.hash_node_position(pos)
	local siren = reactor_siren[hpos]
	if not siren then
		if state == SS_OFF then return end
		siren = {state=SS_OFF}
		reactor_siren[hpos] = siren
	end
	if state == SS_DANGER and siren.state ~= SS_DANGER then
		if siren.handle then minetest.sound_stop(siren.handle) end
		siren.handle = minetest.sound_play("technic_hv_nuclear_reactor_siren_danger_loop",
				{pos=pos, gain=1.5, loop=true, max_hear_distance=48})
		siren.state = SS_DANGER
	elseif state == SS_CLEAR then
		if siren.handle then minetest.sound_stop(siren.handle) end
		local clear_handle = minetest.sound_play("technic_hv_nuclear_reactor_siren_clear",
				{pos=pos, gain=1.5, loop=false, max_hear_distance=48})
		siren.handle = clear_handle
		siren.state = SS_CLEAR
		minetest.after(10, function()
			if siren.handle ~= clear_handle then return end
			minetest.sound_stop(clear_handle)
			if reactor_siren[hpos] == siren then
				reactor_siren[hpos] = nil
			end
		end)
	elseif state == SS_OFF and siren.state ~= SS_OFF then
		if siren.handle then minetest.sound_stop(siren.handle) end
		reactor_siren[hpos] = nil
	end
end

local function siren_danger(pos, meta)
	meta:set_int("siren", 1)
	siren_set_state(pos, SS_DANGER)
end

local function siren_clear(pos, meta)
	if meta:get_int("siren") ~= 0 then
		siren_set_state(pos, SS_CLEAR)
		meta:set_int("siren", 0)
	end
end

--[[
The standard reactor structure consists of a 9x9x9 cube.  A cross
section through the middle:

	CCCC CCCC
	CBBB BBBC
	CBSS SSBC
	CBSWWWSBC
	CBSW#WSBC
	CBSW|WSBC
	CBSS|SSBC
	CBBB|BBBC
	CCCC|CCCC
	C = Concrete, B = Blast-resistant concrete, S = Stainless Steel,
	W = water node, # = reactor core, | = HV cable

The man-hole and the HV cable are only in the middle, and the man-hole
is optional.

For the reactor to operate and not melt down, it insists on the inner
7x7x7 portion (from the core out to the blast-resistant concrete)
being intact.  Intactness only depends on the number of nodes of the
right type in each layer.  The water layer must have water in all but
at most one node; the steel and blast-resistant concrete layers must
have the right material in all but at most two nodes.  The permitted
gaps are meant for the cable and man-hole, but can actually be anywhere
and contain anything.  For the reactor to be useful, a cable must
connect to the core, but it can go in any direction.

The outer concrete layer of the standard structure is not required
for the reactor to operate.  It is noted here because it used to
be mandatory, and for historical reasons (that it predates the
implementation of radiation) it needs to continue being adequate
shielding of legacy reactors.  If it ever ceases to be adequate
shielding for new reactors, legacy ones should be grandfathered.
--]]
local function reactor_structure_badness(pos)
	local vm = VoxelManip()
	local pos1 = vector.subtract(pos, 3)
	local pos2 = vector.add(pos, 3)
	local MinEdge, MaxEdge = vm:read_from_map(pos1, pos2)
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=MinEdge, MaxEdge=MaxEdge})

	local c_blast_concrete = minetest.get_content_id("technic:blast_resistant_concrete")
	local c_stainless_steel = minetest.get_content_id("technic:stainless_steel_block")
	local c_water_source = minetest.get_content_id("default:water_source")
	local c_water_flowing = minetest.get_content_id("default:water_flowing")

	local blastlayer, steellayer, waterlayer = 0, 0, 0

	for z = pos1.z, pos2.z do
	for y = pos1.y, pos2.y do
	for x = pos1.x, pos2.x do
		local cid = data[area:index(x, y, z)]
		if x == pos1.x or x == pos2.x or
		   y == pos1.y or y == pos2.y or
		   z == pos1.z or z == pos2.z then
			if cid == c_blast_concrete then
				blastlayer = blastlayer + 1
			end
		elseif x == pos1.x+1 or x == pos2.x-1 or
		   y == pos1.y+1 or y == pos2.y-1 or
		   z == pos1.z+1 or z == pos2.z-1 then
			if cid == c_stainless_steel then
				steellayer = steellayer + 1
			end
		elseif x == pos1.x+2 or x == pos2.x-2 or
		   y == pos1.y+2 or y == pos2.y-2 or
		   z == pos1.z+2 or z == pos2.z-2 then
			if cid == c_water_source or cid == c_water_flowing then
				waterlayer = waterlayer + 1
			end
		end
	end
	end
	end
	if waterlayer > 25 then waterlayer = 25 end
	if steellayer > 96 then steellayer = 96 end
	if blastlayer > 216 then blastlayer = 216 end
	return (25 - waterlayer) + (96 - steellayer) + (216 - blastlayer)
end


local function melt_down_reactor(pos)
	minetest.log("action", "A reactor melted down at "..minetest.pos_to_string(pos))
	minetest.set_node(pos, {name="technic:corium_source"})
end


minetest.register_abm({
	nodenames = {"technic:hv_nuclear_reactor_core_active"},
	interval = 4,
	chance = 1,
	action = function (pos, node)
		local meta = minetest.get_meta(pos)
		local badness = reactor_structure_badness(pos)
		local accum_badness = meta:get_int("structure_accumulated_badness")
		if badness == 0 then
			if accum_badness ~= 0 then
				meta:set_int("structure_accumulated_badness", accum_badness - 4)
				siren_clear(pos, meta)
			end
		else
			siren_danger(pos, meta)
			accum_badness = accum_badness + badness
			if accum_badness >= 25 then
				melt_down_reactor(pos)
			else
				meta:set_int("structure_accumulated_badness", accum_badness)
			end
		end
	end,
})

local function run(pos, node)
	local meta = minetest.get_meta(pos)
	local burn_time = meta:get_int("burn_time") or 0

	if burn_time >= burn_ticks or burn_time == 0 then
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then 
			local src_list = inv:get_list("src")
			local correct_fuel_count = 0
			for _, src_stack in pairs(src_list) do
				if src_stack and src_stack:get_name() == fuel_type then
					correct_fuel_count = correct_fuel_count + 1
				end
			end
			-- Check that the reactor is complete and has the correct fuel
			if correct_fuel_count == 6 and
					reactor_structure_badness(pos) == 0 then
				meta:set_int("burn_time", 1)
				technic.swap_node(pos, "technic:hv_nuclear_reactor_core_active") 
				meta:set_int("HV_EU_supply", power_supply)
				for idx, src_stack in pairs(src_list) do
					src_stack:take_item()
					inv:set_stack("src", idx, src_stack)
				end
				return
			end
		end
		meta:set_int("HV_EU_supply", 0)
		meta:set_int("burn_time", 0)
		meta:set_string("infotext", S("%s Idle"):format(reactor_desc))
		technic.swap_node(pos, "technic:hv_nuclear_reactor_core")
		meta:set_int("structure_accumulated_badness", 0)
		siren_clear(pos, meta)
	elseif burn_time > 0 then
		burn_time = burn_time + 1
		meta:set_int("burn_time", burn_time)
		local percent = math.floor(burn_time / burn_ticks * 100)
		meta:set_string("infotext", reactor_desc.." ("..percent.."%)")
		meta:set_int("HV_EU_supply", power_supply)
	end
end

minetest.register_node("technic:hv_nuclear_reactor_core", {
	description = reactor_desc,
	tiles = {"technic_hv_nuclear_reactor_core.png"},
	groups = {cracky=1, technic_machine=1, technic_hv=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	stack_max = 1,
	node_box = {
		type = "fixed",
		fixed = node_box
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", reactor_desc)
		meta:set_string("formspec", reactor_formspec)
		local inv = meta:get_inventory()
		inv:set_size("src", 6)
	end,
	can_dig = technic.machine_can_dig,
	on_destruct = function(pos) siren_set_state(pos, SS_OFF) end,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	allow_metadata_inventory_move = technic.machine_inventory_move,
	technic_run = run,
})

minetest.register_node("technic:hv_nuclear_reactor_core_active", {
	tiles = {"technic_hv_nuclear_reactor_core.png"},
	groups = {cracky=1, technic_machine=1, technic_hv=1,
		radioactive=11000, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	drop = "technic:hv_nuclear_reactor_core",
	drawtype = "nodebox",
	light_source = 14,
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = node_box
	},
	can_dig = technic.machine_can_dig,
	after_dig_node = melt_down_reactor,
	on_destruct = function(pos) siren_set_state(pos, SS_OFF) end,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	allow_metadata_inventory_move = technic.machine_inventory_move,
	technic_run = run,
	technic_on_disable = function(pos, node)
		local timer = minetest.get_node_timer(pos)
        	timer:start(1)
        end,
	on_timer = function(pos, node)
		local meta = minetest.get_meta(pos)

		-- Connected back?
		if meta:get_int("HV_EU_timeout") > 0 then return false end

		local burn_time = meta:get_int("burn_time") or 0

		if burn_time >= burn_ticks or burn_time == 0 then
			meta:set_int("HV_EU_supply", 0)
			meta:set_int("burn_time", 0)
			technic.swap_node(pos, "technic:hv_nuclear_reactor_core")
			meta:set_int("structure_accumulated_badness", 0)
			siren_clear(pos, meta)
			return false
		end

		meta:set_int("burn_time", burn_time + 1)
		return true
	end,
})

technic.register_machine("HV", "technic:hv_nuclear_reactor_core",        technic.producer)
technic.register_machine("HV", "technic:hv_nuclear_reactor_core_active", technic.producer)

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

local default_radiation_resistance_per_node = {
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
	["default:nyancat"] = 1000,
	["default:nyancat_rainbow"] = 1000,
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
	["moreores:mineral_tin"] = 19,
	["moreores:mithril_block"] = 26,
	["moreores:silver_block"] = 53,
	["moreores:tin_block"] = 37,
	["snow:snow_brick"] = 2.8,
	["technic:brass_block"] = 43,
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
local default_radiation_resistance_per_group = {
	concrete = 16,
	tree = 3.4,
	uranium_block = 500,
	wood = 1.7,
}
local cache_radiation_resistance = {}
local function node_radiation_resistance(node_name)
	local eff = cache_radiation_resistance[node_name]
	if eff then return eff end
	local def = minetest.registered_nodes[node_name]
	eff = def and def.radiation_resistance or
			default_radiation_resistance_per_node[node_name]
	if def and not eff then
		for g, v in pairs(def.groups) do
			if v > 0 and default_radiation_resistance_per_group[g] then
				eff = default_radiation_resistance_per_group[g]
				break
			end
		end
	end
	if not eff then eff = 0 end
	cache_radiation_resistance[node_name] = eff
	return eff
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
The group value is 1000 times the distance from a node at which
an unshielded player will be damaged by 0.25 HP/s.  Or, equivalently,
it is 2000 times the square root of the damage rate in HP/s that an
unshielded player 1 node away will take.

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

Damage is processed at rates down to 0.25 HP/s, which in the absence of
shielding is attained at the distance specified by the "radioactive"
group value.  Computed damage rates below 0.25 HP/s result in no
damage at all to the player.  This gives the player an opportunity
to be safe, and limits the range at which source/player interactions
need to be considered.
--]]
local abdomen_offset = vector.new(0, 1, 0)
local abdomen_offset_length = vector.length(abdomen_offset)
local cache_scaled_shielding = {}

local function dmg_player(pos, o, strength)
	local pl_pos = vector.add(o:getpos(), abdomen_offset)
	local shielding = 0
	local dist = vector.distance(pos, pl_pos)
	for ray_pos in technic.trace_node_ray(pos,
			vector.direction(pos, pl_pos), dist) do
		if not vector.equals(ray_pos, pos) then
			local shield_name = minetest.get_node(ray_pos).name
			local shield_val = cache_scaled_shielding[sname]
			if not shield_val then
				shield_val = math.sqrt(node_radiation_resistance(shield_name)) * 0.025
				cache_scaled_shielding[shield_name] = shield_val
			end
			shielding = shielding + shield_val
		end
	end
	local dmg = (0.25e-6 * strength * strength) /
		(math.max(0.75, dist * dist) * math.exp(shielding))
	if dmg >= 0.25 then
		local dmg_int = math.floor(dmg)
		-- The closer you are to getting one more damage point,
		-- the more likely it will be added.
		if math.random() < dmg - dmg_int then
			dmg_int = dmg_int + 1
		end
		if dmg_int > 0 then
			o:set_hp(math.max(o:get_hp() - dmg_int, 0))
		end
	end
end

local function dmg_abm(pos, node)
	local strength = minetest.get_item_group(node.name, "radioactive")
	for _, o in pairs(minetest.get_objects_inside_radius(pos,
			strength * 0.001 + abdomen_offset_length)) do
		if o:is_player() then
			dmg_player(pos, o, strength)
		end
	end
end


if minetest.setting_getbool("enable_damage") then
	minetest.register_abm({
		nodenames = {"group:radioactive"},
		interval = 1,
		chance = 1,
		action = dmg_abm,
	})
end

-- Radioactive materials that can result from destroying a reactor
local griefing = technic.config:get_bool("enable_corium_griefing")

for _, state in pairs({"flowing", "source"}) do
	minetest.register_node("technic:corium_"..state, {
		description = S(state == "source" and "Corium Source" or "Flowing Corium"),
		drawtype = (state == "source" and "liquid" or "flowingliquid"),
		[state == "source" and "tiles" or "special_tiles"] = {{
			name = "technic_corium_"..state.."_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		}},
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
		liquid_viscosity = LAVA_VISC,
		liquid_renewable = false,
		damage_per_second = 6,
		post_effect_color = {a=192, r=80, g=160, b=80},
		groups = {
			liquid = 2,
			hot = 3,
			igniter = (griefing and 1 or 0),
			radioactive = (state == "source" and 32000 or 16000),
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
	groups = {cracky=1, radioactive=5000, level=2},
	sounds = default.node_sound_stone_defaults(),
	light_source = 2,
})

minetest.register_abm({
	nodenames = {"group:water"},
	neighbors = {"technic:corium_source"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		minetest.remove_node(pos)
	end,
})

minetest.register_abm({
	nodenames = {"technic:corium_flowing"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		minetest.set_node(pos, {name="technic:chernobylite_block"})
	end,
})

minetest.register_abm({
	nodenames = {"technic:corium_flowing"},
	interval = 5,
	chance = (griefing and 10 or 1),
	action = function(pos, node)
		minetest.set_node(pos, {name="technic:chernobylite_block"})
	end,
})

if griefing then
	minetest.register_abm({
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

