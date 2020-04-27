-- LV Music player.
-- The player can play music. But it is high ampage!

local S = technic.getter

minetest.register_alias("music_player", "technic:music_player")
minetest.register_craft({
	output = 'technic:music_player',
	recipe = {
		{'technic:chromium_ingot', 'default:diamond',        'technic:chromium_ingot'},
		{'default:diamond',        'technic:machine_casing', 'default:diamond'},
		{'default:mossycobble',    'technic:lv_cable',       'default:mossycobble'},
	}
})

local music_handles = {}

local function play_track(pos, track)
	return minetest.sound_play("technic_track"..tostring(track),
			{pos = pos, gain = 1.0, loop = true, max_hear_distance = 72,})
end

local run = function(pos, node)
	local meta         = minetest.get_meta(pos)
	local eu_input     = meta:get_int("LV_EU_input")
	local machine_name = S("%s Music Player"):format("LV")
	local demand       = 150

	local current_track = meta:get_int("current_track")
	local pos_hash      = minetest.hash_node_position(pos)
	local music_handle  = music_handles[pos_hash]

	-- Setup meta data if it does not exist.
	if not eu_input then
		meta:set_int("LV_EU_demand", demand)
		meta:set_int("LV_EU_input", 0)
		return
	end

	if meta:get_int("active") == 0 then
		meta:set_string("infotext", S("%s Idle"):format(machine_name))
		meta:set_int("LV_EU_demand", 0)
		return
	end

	if eu_input < demand then
		meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
		if music_handle then
			minetest.sound_stop(music_handle)
			music_handle = nil
		end
	elseif eu_input >= demand then
		meta:set_string("infotext", S("%s Active"):format(machine_name))
		if not music_handle then
			music_handle = play_track(pos, current_track)
		end
	end
	music_handles[pos_hash] = music_handle
	meta:set_int("LV_EU_demand", demand)
end

local function stop_player(pos, node)
	local pos_hash = minetest.hash_node_position(pos)
	local music_handle = music_handles[pos_hash]
	if music_handle then
		minetest.sound_stop(music_handle)
		music_handles[pos_hash] = nil
	end
end

local function set_display(meta)
	meta:set_string("formspec",
			"size[4,4.5]"..
			"item_image[0,0;1,1;technic:music_player]"..
			"label[1,0;"..S("%s Music Player"):format("LV").."]"..
			"button[0,1;1,1;track1;1]"..
			"button[1,1;1,1;track2;2]"..
			"button[2,1;1,1;track3;3]"..
			"button[0,2;1,1;track4;4]"..
			"button[1,2;1,1;track5;5]"..
			"button[2,2;1,1;track6;6]"..
			"button[0,3;1,1;track7;7]"..
			"button[1,3;1,1;track8;8]"..
			"button[2,3;1,1;track9;9]"..
			"button[3,1;1,1;stop;Stop]"..
			"label[0,4;"..minetest.formspec_escape(
				meta:get_int("active") == 0 and
					S("Stopped") or
					S("Current track %s"):format(meta:get_int("current_track"))).."]")
end

minetest.register_node("technic:music_player", {
	description = S("%s Music Player"):format("LV"),
	tiles = {"technic_music_player_top.png", "technic_machine_bottom.png", "technic_music_player_side.png",
	         "technic_music_player_side.png", "technic_music_player_side.png", "technic_music_player_side.png"},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,
		technic_machine=1, technic_lv=1},
	connect_sides = {"bottom"},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("%s Music Player"):format("LV"))
		set_display(meta)
	end,
	on_receive_fields = function(pos, formanme, fields, sender)
		local new_track = nil
		if fields.stop then new_track = 0 end
		if fields.track1 then new_track = 1 end
		if fields.track2 then new_track = 2 end
		if fields.track3 then new_track = 3 end
		if fields.track4 then new_track = 4 end
		if fields.track5 then new_track = 5 end
		if fields.track6 then new_track = 6 end
		if fields.track7 then new_track = 7 end
		if fields.track8 then new_track = 8 end
		if fields.track9 then new_track = 9 end
		if new_track then
			stop_player(pos)
			local meta = minetest.get_meta(pos)
			meta:set_int("active", new_track == 0 and 0 or 1)
			meta:set_int("current_track", new_track)
			set_display(meta)
		end
	end,
	on_destruct = stop_player,
	technic_run = run,
	technic_on_disable = stop_player,
})

technic.register_machine("LV", "technic:music_player", technic.receiver)

