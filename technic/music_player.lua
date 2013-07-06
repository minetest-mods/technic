minetest.register_alias("music_player", "technic:music_player")
minetest.register_craft({
	output = 'technic:music_player',
	recipe = {
		{'default:wood', 'default:wood', 'default:wood'},
		{'default:diamond', 'default:diamond', 'default:diamond'},
		{'default:stone', 'default:copper_ingot', 'default:stone'},
	}
})

minetest.register_craftitem("technic:music_player", {
	description = "Music Player",
	stack_max = 99,
}) 

music_player_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"label[0,0;Music Player]"..
	"label[1,3;Power level]"..
	"button[5,2;1,1;track1;1]"..
	"button[6,2;1,1;track2;2]"
	

minetest.register_node("technic:music_player", {
	description = "Music Player",
	tiles = {"technic_music_player_top.png", "technic_machine_bottom.png", "technic_music_player_side.png",
		"technic_music_player_side.png", "technic_music_player_side.png", "technic_music_player_side.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	technic_power_machine=1,
	internal_EU_buffer=0,
	internal_EU_buffer_size=5000,
	music_player_on=0,
	music_playing =0,
	music_handle = 0,
	music_player_current_track =1,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Music Player")
		meta:set_float("technic_power_machine", 1)
		meta:set_float("internal_EU_buffer", 1)
		meta:set_float("internal_EU_buffer_size", 5000)
		meta:set_string("formspec", music_player_formspec)
		meta:set_float("music_player_on", 0)
		meta:set_float("music_player_current_track", 1)
		end,	

	on_receive_fields = function(pos, formanme, fields, sender)
	
	local meta = minetest.env:get_meta(pos)
	player_on=meta:get_float("music_player_on")
	music_handle=meta:get_float("music_handle")
	music_player_current_track=meta:get_float("music_player_current_track")
	if fields.track1 then music_player_current_track=1 end
	if fields.track2 then music_player_current_track=2 end
	if fields.track3 then music_player_current_track=3 end
	if fields.track4 then music_player_current_track=4 end
	if fields.track5 then music_player_current_track=5 end
	if fields.track6 then music_player_current_track=6 end
	if fields.track7 then music_player_current_track=7 end
	if fields.track8 then music_player_current_track=8 end
	if fields.track9 then music_player_current_track=9 end
	meta:set_float("music_player_current_track",music_player_current_track)
	if fields.play and player_on==1 then  
	if music_handle then minetest.sound_stop(music_handle) end
	music_handle=minetest.sound_play("technic_track"..music_player_current_track, {pos = pos, gain = 1.0,loop = true, max_hear_distance = 72,}) 	
	meta:set_float("music_playing",1)
	end
	if fields.stop then  
	meta:set_float("music_playing",0)
	if music_handle then minetest.sound_stop(music_handle) end
	end
	meta:set_float("music_handle",music_handle)
	end,
})

minetest.register_abm({
	nodenames = {"technic:music_player"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
	local meta = minetest.env:get_meta(pos)
	local charge= meta:get_float("internal_EU_buffer")
	local max_charge= meta:get_float("internal_EU_buffer_size")
	player_on=meta:get_float("music_player_on")
	music_player_current_track=meta:get_float("music_player_current_track")
	local play_cost=80
	
	if charge>play_cost then 
		if meta:get_float("music_playing")==1 then charge=charge-play_cost end
			meta:set_float("internal_EU_buffer",charge)
		meta:set_float("music_player_on",1)
	else 
		meta:set_float("music_playing",0)
		meta:set_float("music_player_on",0)
		if music_handle then minetest.sound_stop(music_handle) end
	end
	local load = math.floor((charge/max_charge)*100)
	meta:set_string("formspec",
				"invsize[8,9;]"..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
						(load)..":technic_power_meter_fg.png]"..
				"label[0,0;Music Player]"..
				"label[1,3;Power level]"..
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
				"label[4,0;Current track "..tostring(music_player_current_track).."]"
				)
	end
}) 

register_LV_machine ("technic:music_player","RE")
