-- Forcefield mod by ShadowNinja
-- Modified by kpoppel
--
-- Forcefields are powerful barriers but they consume huge amounts of power.
-- Forcefield Generator is a HV machine.

local forcefield_update_interval = 1

minetest.register_craft({
	output = 'technic:forcefield_emitter_off',
	recipe = {
			{'default:mese',         'technic:deployer_off', 'default:mese'        },
			{'technic:deployer_off', 'technic:motor',        'technic:deployer_off'},
			{'default:mese',         'technic:deployer_off', 'default:mese'        },
	}
})

-- Idea: Let forcefields have different colors by upgrade slot.
-- Idea: Let forcefields add up by detecting if one hits another.
--    ___   __
--   /   \/   \
--  |          |
--   \___/\___/
--
local function add_forcefield(pos, range)
	for x=-range,range do
	for y=-range,range do
	for z=-range,range do
		if ((x*x+y*y+z*z) <= (range * range + range)) then
			if ((range-1) * (range-1) + (range-1) <= x*x+y*y+z*z) then
				local np={x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local n = minetest.env:get_node(np).name
				if (n == "air") then
					minetest.env:add_node(np, {name = "technic:forcefield"})
				end
			end
		end
	end
	end
	end
	return true
end

local function remove_forcefield(p, range)
	for x=-range,range do
	for y=-range,range do
	for z=-range,range do
		if ((x*x+y*y+z*z) <= (range * range + range)) then
			if ((range-1) * (range-1) + (range-1) <= x*x+y*y+z*z) then
				local np={x=p.x+x,y=p.y+y,z=p.z+z}
				local n = minetest.env:get_node(np).name
				if (n == "technic:forcefield") then
					minetest.env:remove_node(np)
				end
			end
		end
	end
	end
	end
end

local get_forcefield_formspec = function(range)
   --	return "invsize[8,9;]"..  (if upgrades added later - colors for instance)
	return "invsize[3,4;]"..
	"label[0,0;Forcefield emitter]"..
	"label[1,1;Range]"..
	"label[1,2;"..range.."]"..
	"button[0,2;1,1;subtract;-]"..
	"button[2,2;1,1;add;+]"..
	"button[0,3;3,1;toggle;Enable/Disable]" -- ..
--	"list[current_player;main;0,5;8,4;]"
end

local forcefield_receive_fields = function(pos, formname, fields, sender)
				     local meta = minetest.env:get_meta(pos)
				     local range = meta:get_int("range")
				     if fields.add then range = range + 1 end
				     if fields.subtract then range = range - 1 end
				     if fields.toggle then
					if meta:get_int("enabled") == 1 then
					   meta:set_int("enabled", 0)
					else
					   meta:set_int("enabled", 1)
					end
				     end
				     -- Smallest field is 5. Anything less is asking for trouble.
				     -- Largest is 20. It is a matter of pratical node handling.
				     if range < 5  then range = 5 end
				     if range > 20 then range = 20 end

				     if range <= 20 and range >= 5 and meta:get_int("range") ~= range then
					remove_forcefield(pos, meta:get_int("range"))
					meta:set_int("range", range)
					meta:set_string("formspec", get_forcefield_formspec(range))
				     end
				  end

local forcefield_check = function(pos)
			    local meta = minetest.env:get_meta(pos)
			    local node = minetest.env:get_node(pos)
			    local eu_input   = meta:get_int("HV_EU_input")
			    local eu_demand  = meta:get_int("HV_EU_demand")
			    local enabled    = meta:get_int("enabled")
			    
			    -- Power off automatically if no longer connected to a switching station
			    technic.switching_station_timeout_count(pos, "HV")

			    local power_requirement
			    if enabled == 1 then
			       power_requirement = math.floor(4*math.pi*math.pow(meta:get_int("range"), 2)) * 1
			    else
			       power_requirement = eu_demand
			    end

			    if eu_input == 0 then
			       meta:set_string("infotext", "Forcefield Generator Unpowered")
			       meta:set_int("HV_EU_demand", 100)
			       if node.name == "technic:forcefield_emitter_on" then
				  remove_forcefield(pos, meta:get_int("range"))
				  hacky_swap_node(pos, "technic:forcefield_emitter_off")
				  meta:set_int("enabled", 0)
			       end
			    elseif eu_input == power_requirement then
			       if meta:get_int("enabled") == 1 then
				  if node.name == "technic:forcefield_emitter_off" then
				     hacky_swap_node(pos, "technic:forcefield_emitter_on")
				     meta:set_string("infotext", "Forcefield Generator Active")
				     add_forcefield(pos, meta:get_int("range"))
				  else
				     -- Range updated. Move the forcefield.
				     add_forcefield(pos, meta:get_int("range"))
				  end
			       else
				  if node.name == "technic:forcefield_emitter_on" then
				     remove_forcefield(pos, meta:get_int("range"))
				     hacky_swap_node(pos, "technic:forcefield_emitter_off")
				     meta:set_int("HV_EU_demand", 100)
				     meta:set_string("infotext", "Forcefield Generator Idle")
				  end
			       end
			    else
			       meta:set_int("HV_EU_demand", power_requirement)
			    end
			    return true
			 end

local mesecons = {effector = {
	action_on = function(pos, node)
		minetest.env:get_meta(pos):set_int("enabled", 0)
	end,
	action_off = function(pos, node)
		minetest.env:get_meta(pos):set_int("enabled", 1)
	end
}}

minetest.register_node("technic:forcefield_emitter_off", {
	description = "Forcefield emitter",
	inventory_image = minetest.inventorycube("technic_forcefield_emitter_off.png"),
	tiles = {"technic_forcefield_emitter_off.png"},
	is_ground_content = true,
	groups = {cracky = 1},
	on_timer = forcefield_check,
	on_receive_fields = forcefield_receive_fields,
	on_construct = function(pos)
		minetest.env:get_node_timer(pos):start(forcefield_update_interval)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_hv_power_machine", 1)
		meta:set_int("HV_EU_input", 0)
		meta:set_int("HV_EU_demand", 0)
		meta:set_int("range", 10)
		meta:set_int("enabled", 0)
		meta:set_string("formspec", get_forcefield_formspec(meta:get_int("range")))
		meta:set_string("infotext", "Forcefield emitter");
	end,
	mesecons = mesecons
})

minetest.register_node("technic:forcefield_emitter_on", {
	description = "Forcefield emitter on (you hacker you)",
	tiles = {"technic_forcefield_emitter_on.png"},
	is_ground_content = true,
	groups = {cracky = 1, not_in_creative_inventory=1},
	drop='"technic:forcefield_emitter_off" 1',
	on_timer = forcefield_check,
	on_receive_fields = forcefield_receive_fields,
	on_construct = function(pos) 
		minetest.env:get_node_timer(pos):start(forcefield_update_interval)
		local meta = minetest.env:get_meta(pos)
--		meta:set_float("technic_hv_power_machine", 1)
--		meta:set_float("HV_EU_input", 0)
--		meta:set_float("HV_EU_demand", 0)
--		meta:set_int("range", 10)
--		meta:set_int("enabled", 1)
		meta:set_string("formspec", get_forcefield_formspec(meta:get_int("range")))
--		meta:set_string("infotext", "Forcefield emitter");
	end,
	on_dig = function(pos, node, digger)	
		remove_forcefield(pos, minetest.env:get_meta(pos):get_int("range"))
		return minetest.node_dig(pos, node, digger)
	end,
	mesecons = mesecons
})

minetest.register_node("technic:forcefield", {
	description = "Forcefield (you hacker you)",
	sunlight_propagates = true,
	drop = '',
        light_source = 8,
	tiles = {{name="technic_forcefield_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0}}},
	is_ground_content = true,
	groups = {not_in_creative_inventory=1, unbreakable=1},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {  --hacky way to get the field blue and not see through the ground
		type = "fixed",
		fixed={
			{-.5,-.5,-.5,.5,.5,.5},
		},
	},
})

technic.register_HV_machine("technic:forcefield_emitter_on","RE")
technic.register_HV_machine("technic:forcefield_emitter_off","RE")
