--[[
	The Lawn Trimmer, also known as Weed Whacker, is a common gardening power tool.
	In minetest, it has several uses. While it removes all members of 'flora' group
	and can be used for literally mowing grass or trimming it around vegetable beds,
	it's not its most important application.
   
	1. The tool can be used when searching for plants that can be cultivated in the wilderness.
	Some of them are hard to see through grass; some of them are hard to tell from the grass;
	some of them are actually obtained by removing the grass (e.g. barley seeds).
   
	2. Producing organic dye pigments. While growing flowers is a matter of fertilizing the soil
	with bone meal, harvesting them by hand is a chore.
   
	In both scenarios, the tool will be very handy for the player.
	It comes with 4 modes of operation, defined by how wide its sweep is: from 0 (at one's feet)
	to 3 nodes in radius (square radius, as most things in minetest are).

	The sound is an edited fragment from https://www.cutestockfootage.com/sound-effect/9251/grass-trimmer-01
	used in accordance with its licensing terms (free use for any purpose in an altered form)
]]

-- Configuration
local lawn_trimmer_max_charge        = 10000 -- 10000 - Maximum charge of the lawn trimmer
local lawn_trimmer_charge_per_object = 25    -- 25    - Can mow 400 'group:flora' blocks

local S = technic.getter

local lawn_trimmer_mode_text = {
	{S("immediately around the user")},
	{S("sweep 1 block wide")},
	{S("sweep 2 blocks wide")},
	{S("sweep 3 blocks wide")}
}


-- Mode switcher for the tool
local function lawn_trimmer_setmode(user,itemstack)
	local player_name=user:get_player_name()
	local item=itemstack:to_table()
	local meta=minetest.deserialize(item["metadata"])
	local mode
	if meta==nil then
		meta={}
		mode=0
	end
	if meta["mode"]==nil then
		minetest.chat_send_player(player_name, S("Use while sneaking to change Lawn Trimmer modes."))
		meta["mode"]=0
		mode=0
	end
	mode=(meta["mode"])
	mode=mode+1
	
	if mode>4 then mode=1 end
	
	minetest.chat_send_player(player_name, S("Lawn Trimmer Mode %d"):format(mode)..": "..lawn_trimmer_mode_text[mode][1])
	itemstack:set_name("technic:lawn_trimmer_"..mode);
	meta["mode"]=mode
	itemstack:set_metadata(minetest.serialize(meta))
	return itemstack
end


-- Perform the trimming action
local function trim_the_lawn(itemstack, user)
	local meta = minetest.deserialize(itemstack:get_metadata())
	local keys = user:get_player_control()
	local meta = minetest.deserialize(itemstack:get_metadata())
	if not meta or not meta.mode or keys.sneak then
		return lawn_trimmer_setmode(user, itemstack)
	end
	
	if not meta or not meta.charge then
		return
	end
	if meta.charge > lawn_trimmer_charge_per_object then
		minetest.sound_play("technic_lawn_trimmer", {
			to_player = user:get_player_name(),
			gain = 0.4,
		})
	end
	
	local pos = user:getpos()
	local inv = user:get_inventory()
	-- Defining the area for the search needs two positions
	local start_pos = user:getpos()
	start_pos.x = start_pos.x - meta.mode + 1
	start_pos.z = start_pos.z - meta.mode + 1
	start_pos.y = start_pos.y - 1 -- the tool can hardly be lowered a lot while standing, but we'll allow 1 node
	local end_pos = user:getpos()
	end_pos.x = end_pos.x + meta.mode - 1
	end_pos.z = end_pos.z + meta.mode - 1
	end_pos.y = end_pos.y + 1 -- cannot be raised too high either, though mostly for safety reasons

	-- Since nodes sometimes cannot be removed, we cannot rely on repeating find_node_near() and removing found nodes
	local found_flora = minetest.find_nodes_in_area(start_pos, end_pos, {"group:flora"})
	for _,f in ipairs(found_flora) do
		if meta.charge < lawn_trimmer_charge_per_object then break end -- no charge left for this node
		if minetest.is_protected(f, user:get_player_name()) then break end -- may not dig this node
		meta.charge = meta.charge - lawn_trimmer_charge_per_object
		local node = minetest.get_node_or_nil(f)
		minetest.node_dig(f, node, user)
	end
	
	-- the charge won't expire in creative mode, but the tool still has to be charged prior to use
	if not technic.creative_mode then
		technic.set_RE_wear(itemstack, meta.charge, lawn_trimmer_max_charge)
		itemstack:set_metadata(minetest.serialize(meta))
	end
	return itemstack
end


-- Register the tool and its varieties in the game
technic.register_power_tool("technic:lawn_trimmer", lawn_trimmer_max_charge)
minetest.register_tool("technic:lawn_trimmer", {
	description = S("Lawn Trimmer"),
	inventory_image = "technic_lawn_trimmer.png",
	stack_max = 1,
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
		trim_the_lawn(itemstack, user)
		return itemstack
	end,
})

for i=1,4,1 do
	technic.register_power_tool("technic:lawn_trimmer_"..i, lawn_trimmer_max_charge)
	minetest.register_tool("technic:lawn_trimmer_"..i, {
		description = S("Lawn Trimmer Mode %d"):format(i),
		inventory_image = "technic_lawn_trimmer.png^technic_tool_mode"..i..".png",
		wield_image = "technic_lawn_trimmer.png",
		wear_represents = "technic_RE_charge",
		on_refill = technic.refill_RE_charge,
		groups = {not_in_creative_inventory=1},
		on_use = function(itemstack, user, pointed_thing)
			trim_the_lawn(itemstack, user)
			return itemstack
		end,
	})
end


-- Provide a crafting recipe
local mesecons_button = minetest.get_modpath("mesecons_button")
local trigger = mesecons_button and "mesecons_button:button_off" or "default:mese_crystal_fragment"

minetest.register_craft({
	output = 'technic:lawn_trimmer',
	recipe = {
		{'',						'default:stick',	trigger},
		{'technic:motor',				'default:stick',	'technic:battery'},
		{'technic:stainless_steel_ingot',	'',			''},
	}
})
