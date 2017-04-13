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

local reactor_desc = S("@1 Nuclear Reactor Core", S("HV"))
local cable_entry = "^technic_cable_connection_overlay.png"

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
	CBLL LLBC
	CBLWWWLBC
	CBLW#WLBC
	CBLW|WLBC
	CBLL|LLBC
	CBBB|BBBC
	CCCC|CCCC
	C = Concrete, B = Blast-resistant concrete, L = Lead,
	W = water node, # = reactor core, | = HV cable

The man-hole is optional (but necessary for refueling).

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

For legacy reasons, if the reactor has a stainless steel layer instead
of a lead layer it will be converted to a lead layer.
--]]
local function reactor_structure_badness(pos)
	local vm = VoxelManip()
	local pos1 = vector.subtract(pos, 3)
	local pos2 = vector.add(pos, 3)
	local MinEdge, MaxEdge = vm:read_from_map(pos1, pos2)
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=MinEdge, MaxEdge=MaxEdge})

	local c_blast_concrete = minetest.get_content_id("technic:blast_resistant_concrete")
	local c_lead = minetest.get_content_id("technic:lead_block")
	local c_steel = minetest.get_content_id("technic:stainless_steel_block")
	local c_water_source = minetest.get_content_id("default:water_source")
	local c_water_flowing = minetest.get_content_id("default:water_flowing")

	local blast_layer, steel_layer, lead_layer, water_layer = 0, 0, 0, 0

	for z = pos1.z, pos2.z do
	for y = pos1.y, pos2.y do
	for x = pos1.x, pos2.x do
		local cid = data[area:index(x, y, z)]
		if x == pos1.x or x == pos2.x or
		   y == pos1.y or y == pos2.y or
		   z == pos1.z or z == pos2.z then
			if cid == c_blast_concrete then
				blast_layer = blast_layer + 1
			end
		elseif x == pos1.x+1 or x == pos2.x-1 or
		       y == pos1.y+1 or y == pos2.y-1 or
		       z == pos1.z+1 or z == pos2.z-1 then
			if cid == c_lead then
				lead_layer = lead_layer + 1
			elseif cid == c_steel then
				steel_layer = steel_layer + 1
			end
		elseif x == pos1.x+2 or x == pos2.x-2 or
		       y == pos1.y+2 or y == pos2.y-2 or
		       z == pos1.z+2 or z == pos2.z-2 then
			if cid == c_water_source or cid == c_water_flowing then
				water_layer = water_layer + 1
			end
		end
	end
	end
	end

	if steel_layer >= 96 then
		for z = pos1.z+1, pos2.z-1 do
		for y = pos1.y+1, pos2.y-1 do
		for x = pos1.x+1, pos2.x-1 do
			local vi = area:index(x, y, z)
			if x == pos1.x+1 or x == pos2.x-1 or
			   y == pos1.y+1 or y == pos2.y-1 or
			   z == pos1.z+1 or z == pos2.z-1 then
				if data[vi] == c_steel then
					data[vi] = c_lead
				end
			end
		end
		end
		end
		vm:set_data(data)
		vm:write_to_map()
		lead_layer = steel_layer
	end

	if water_layer > 25 then water_layer = 25 end
	if lead_layer > 96 then lead_layer = 96 end
	if blast_layer > 216 then blast_layer = 216 end
	return (25 - water_layer) + (96 - lead_layer) + (216 - blast_layer)
end


local function melt_down_reactor(pos)
	minetest.log("action", "A reactor melted down at "..minetest.pos_to_string(pos))
	minetest.set_node(pos, {name="technic:corium_source"})
end


minetest.register_abm({
	label = "Machines: reactor melt-down check",
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
	tiles = {
		"technic_hv_nuclear_reactor_core.png",
		"technic_hv_nuclear_reactor_core.png"..cable_entry
	},
	drawtype = "mesh",
	mesh = "technic_reactor.obj",
	groups = {cracky=1, technic_machine=1, technic_hv=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	paramtype = "light",
	paramtype2 = "facedir",
	stack_max = 1,
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
	tiles = {
		"technic_hv_nuclear_reactor_core.png",
		"technic_hv_nuclear_reactor_core.png"..cable_entry
	},
	drawtype = "mesh",
	mesh = "technic_reactor.obj",
	groups = {cracky=1, technic_machine=1, technic_hv=1,
		radioactive=4, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	drop = "technic:hv_nuclear_reactor_core",
	light_source = 14,
	paramtype = "light",
	paramtype2 = "facedir",
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

