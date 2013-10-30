-- LV Music player.
-- The player can play music. But it is high ampage!

local S = technic.getter

minetest.register_alias("music_player", "technic:music_player")
minetest.register_craft({
	output = 'technic:music_player',
	recipe = {
		{'group:wood',      'group:wood',           'group:wood'},
		{'default:diamond', 'default:diamond',      'default:diamond'},
		{'default:stone',   'default:copper_ingot', 'default:stone'},
	}
})

local music_player_formspec =
	"invsize[8,9;]"..
	"label[0,0;"..S("Music Player").."]"..
	"button[4,1;1,1;track1;1]"..
	"button[5,1;1,1;track2;2]"..
	"button[6,1;1,1;track3;3]"..
	"button[4,2;1,1;track4;4]"..
	"button[5,2;1,1;track5;5]"..
	"button[6,2;1,1;track6;6]"..
	"button[4,3;1,1;track7;7]"..
	"button[5,3;1,1;track8;8]"..
	"button[6,3;1,1;track9;9]"..
	"button[4,4;1,2;play;Play]"..
	"button[6,4;1,2;stop;Stop]"..
	"label[4,0;Current track --]"

minetest.register_node("technic:music_player", {
	description = S("Music Player"),
	tiles = {"technic_music_player_top.png", "technic_machine_bottom.png", "technic_music_player_side.png",
	         "technic_music_player_side.png", "technic_music_player_side.png", "technic_music_player_side.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Music Player"))
		meta:set_int("active", 0)
		meta:set_int("current_track", 1)
		meta:set_string("formspec", music_player_formspec)
	end,
	on_receive_fields = function(pos, formanme, fields, sender)
		local meta          = minetest.get_meta(pos)
		local music_handle  = meta:get_int("music_handle")
		local current_track = meta:get_int("current_track")
		if fields.track1 then current_track = 1 end
		if fields.track2 then current_track = 2 end
		if fields.track3 then current_track = 3 end
		if fields.track4 then current_track = 4 end
		if fields.track5 then current_track = 5 end
		if fields.track6 then current_track = 6 end
		if fields.track7 then current_track = 7 end
		if fields.track8 then current_track = 8 end
		if fields.track9 then current_track = 9 end
		meta:set_int("current_track", current_track)
		meta:set_string("formspec",
				"invsize[8,9;]"..
				"label[0,0;"..S("Music Player").."]"..
				"button[4,1;1,1;track1;1]"..
				"button[5,1;1,1;track2;2]"..
				"button[6,1;1,1;track3;3]"..
				"button[4,2;1,1;track4;4]"..
				"button[5,2;1,1;track5;5]"..
				"button[6,2;1,1;track6;6]"..
				"button[4,3;1,1;track7;7]"..
				"button[5,3;1,1;track8;8]"..
				"button[6,3;1,1;track9;9]"..
				"button[4,4;1,2;play;Play]"..
				"button[6,4;1,2;stop;Stop]"..
				"label[4,0;Current track "
				..current_track.."]")
		if fields.play then
			if music_handle then
				minetest.sound_stop(music_handle)
			end
			meta:set_int("active", 1)
		end
		if fields.stop then
			meta:set_int("active", 0)
			if music_handle then
				minetest.sound_stop(music_handle)
			end
		end
		meta:set_int("music_handle", music_handle)
	end,
})

minetest.register_abm({
	nodenames = {"technic:music_player"},
	interval = 1,
	chance   = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta         = minetest.get_meta(pos)
		local eu_input     = meta:get_int("LV_EU_input")
		local machine_name = S("Music Player")
		local machine_node = "technic:music_player"
		local demand       = 150

		local music_handle = meta:get_int("music_handle")
		local current_track = meta:get_int("current_track")

		-- Setup meta data if it does not exist.
		if not eu_input then
			meta:set_int("LV_EU_demand", demand)
			meta:set_int("LV_EU_input", 0)
			return
		end

		-- Power off automatically if no longer connected to a switching station
		technic.switching_station_timeout_count(pos, "LV")

		if meta:get_int("active") == 0 then
			meta:set_string("infotext", S("%s Idle"):format(machine_name))
			meta:set_int("LV_EU_demand", 0)
			if music_handle then
				minetest.sound_stop(music_handle)
			end
			return
		end

		if eu_input < demand then
			meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
			if music_handle then
				minetest.sound_stop(music_handle)
			end
		elseif eu_input >= demand then
			meta:set_string("infotext", S("%s Active"):format(machine_name))
			music_handle = minetest.sound_play("technic_track"..current_track,
					{pos = pos, gain = 1.0, loop = true, max_hear_distance = 72,})
			meta:set_int("music_handle", music_handle)
		end
		meta:set_int("LV_EU_demand", demand)
	end
})

technic.register_machine("LV", "technic:music_player", technic.receiver)

