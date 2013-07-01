-- LV Music player.
-- The playe can play music. But it is high ampage!
minetest.register_alias("music_player", "technic:music_player")
minetest.register_craft({
	output = 'technic:music_player',
	recipe = {
		{'default:wood', 'default:wood', 'default:wood'},
		{'default:diamond', 'default:diamond', 'default:diamond'},
		{'default:stone', 'moreores:copper_ingot', 'default:stone'},
	}
})

minetest.register_craftitem("technic:music_player", {
	description = "Music Player",
	stack_max = 99,
})

local music_player_formspec =
   "invsize[8,9;]"..
   "label[0,0;Music Player]"..
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

minetest.register_node(
   "technic:music_player",
   {
      description = "Music Player",
      tiles = {"technic_music_player_top.png", "technic_machine_bottom.png", "technic_music_player_side.png",
	       "technic_music_player_side.png", "technic_music_player_side.png", "technic_music_player_side.png"},
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
      sounds = default.node_sound_wood_defaults(),
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("infotext", "Music Player")
			meta:set_float("technic_power_machine", 1)
			meta:set_int("active",     0) -- Is the device on?
			meta:set_int("music_player_current_track", 1)
			meta:set_string("formspec", music_player_formspec)
		     end,
      on_receive_fields = function(pos, formanme, fields, sender)
			     local meta                 = minetest.env:get_meta(pos)
			     music_handle               = meta:get_int("music_handle")
			     music_player_current_track = meta:get_int("music_player_current_track")
			     if fields.track1 then music_player_current_track = 1 end
			     if fields.track2 then music_player_current_track = 2 end
			     if fields.track3 then music_player_current_track = 3 end
			     if fields.track4 then music_player_current_track = 4 end
			     if fields.track5 then music_player_current_track = 5 end
			     if fields.track6 then music_player_current_track = 6 end
			     if fields.track7 then music_player_current_track = 7 end
			     if fields.track8 then music_player_current_track = 8 end
			     if fields.track9 then music_player_current_track = 9 end
			     meta:set_int("music_player_current_track",music_player_current_track)
			     if fields.play and meta:get_int("active") == 0 then
				if music_handle then minetest.sound_stop(music_handle) end
				music_handle = minetest.sound_play("technic_track"..music_player_current_track, {pos = pos, gain = 1.0,loop = true, max_hear_distance = 72,})
				meta:set_int("active",1)
			     end
			     if fields.stop then
				meta:set_int("active",0)
				if music_handle then minetest.sound_stop(music_handle) end
			     end
			     meta:set_int("music_handle",music_handle)
			  end,
   })

minetest.register_abm(
   { nodenames = {"technic:music_player"},
     interval = 1,
     chance   = 1,
     action = function(pos, node, active_object_count, active_object_count_wider)
		 local meta         = minetest.env:get_meta(pos)
		 local eu_input     = meta:get_int("LV_EU_input")
		 local state        = meta:get_int("state")
		 local next_state   = state

		 -- Machine information
		 local machine_name         = "Music Player"
		 local machine_node         = "technic:music_player"
		 local machine_state_demand = { 10, 150 }
			 
		 local music_handle         = meta:get_int("music_handle")

		 -- Setup meta data if it does not exist. state is used as an indicator of this
		 if state == 0 then
		    meta:set_int("state", 1)
		    meta:set_int("LV_EU_demand", machine_state_demand[1])
		    meta:set_int("LV_EU_input", 0)
		    return
		 end
			 
		 -- Power off automatically if no longer connected to a switching station
		 technic.switching_station_timeout_count(pos, "LV")
			 
		 -- State machine
		 if eu_input == 0 then
		    -- unpowered - go idle
		    -- hacky_swap_node(pos, machine_node) -- if someday two nodes for this
		    meta:set_string("infotext", machine_name.." Unpowered")
		    next_state = 1
		 elseif eu_input == machine_state_demand[state] then
		    -- Powered - do the state specific actions
		    if state == 1 then
		       -- hacky_swap_node(pos, machine_node) -- if someday two nodes for this
		       meta:set_string("infotext", machine_name.." Idle")

		       if meta:get_int("active") == 1 then
			  next_state = 2
		       end

		    elseif state == 2 then
		       -- hacky_swap_node(pos, machine_node.."_active") -- if someday two nodes for this
		       meta:set_string("infotext", machine_name.." Active")

		       music_player_current_track=meta:get_int("music_player_current_track")
		       meta:set_string("formspec",
				       "invsize[8,9;]"..
					  "label[0,0;Music Player]"..
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
		       if meta:get_int("active") == 0 then
			  if music_handle then minetest.sound_stop(music_handle) end
			  next_state = 1
		       end
		    end
		 end
		 -- Change state?
		 if next_state ~= state then
		    meta:set_int("LV_EU_demand", machine_state_demand[next_state])
		    meta:set_int("state", next_state)
		 end
	      end
   })

technic.register_LV_machine ("technic:music_player","RE")
