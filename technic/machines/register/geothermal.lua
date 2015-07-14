local S = technic.getter

function technic.register_geothermal(data)
        local tier = data.tier
        local ltier = string.lower(tier)
		
		local off_name = "technic:geothermal_"..ltier
		local on_name = "technic:geothermal_active_"..ltier
		
		local texture_name = "technic_"..ltier .. "_geothermal"
		
		local groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2, technic_machine=1}
		local description = S("Geothermal %s Generator"):format(tier)
		
		if data.old then
		
			off_name = "technic:geothermal"
			on_name = "technic:geothermal_active"
			groups.not_in_creative_inventory=1
			description = "Old "..description
			texture_name = "technic_geothermal"
		end
		

		local check_node_around = function(pos)
				local node = minetest.get_node(pos)
				if node.name == "default:water_source" or node.name == "default:water_flowing" then return 1 end
				if node.name == "default:lava_source"  or node.name == "default:lava_flowing"  then return 2 end
				return 0
		end
		
		
		local run = function(pos, node)
				local meta             = minetest.get_meta(pos)
				local water_nodes      = 0
				local lava_nodes       = 0
				local production_level = 0
				local eu_supply        = 0

				
				
				
				
				-- Correct positioning is water on one side and lava on the other.
				-- The two cannot be adjacent because the lava the turns into obsidian or rock.
				-- To get to 100% production stack the water and lava one extra block down as well:
				--    WGL (W=Water, L=Lava, G=the generator, |=an LV cable)
				--    W|L

				local positions = {
						{x=pos.x+1, y=pos.y,   z=pos.z},
						{x=pos.x+1, y=pos.y-1, z=pos.z},
						{x=pos.x-1, y=pos.y,   z=pos.z},
						{x=pos.x-1, y=pos.y-1, z=pos.z},
						{x=pos.x,   y=pos.y,   z=pos.z+1},
						{x=pos.x,   y=pos.y-1, z=pos.z+1},
						{x=pos.x,   y=pos.y,   z=pos.z-1},
						{x=pos.x,   y=pos.y-1, z=pos.z-1},
				}
				for _, p in pairs(positions) do
						local check = check_node_around(p)
						if check == 1 then water_nodes = water_nodes + 1 end
						if check == 2 then lava_nodes  = lava_nodes  + 1 end
				end

				if water_nodes == 1 and lava_nodes == 1 then production_level =  25; eu_supply = 5 * data.power end
				if water_nodes == 2 and lava_nodes == 1 then production_level =  50; eu_supply = 10 * data.power end
				if water_nodes == 1 and lava_nodes == 2 then production_level =  75; eu_supply = 20 * data.power end
				if water_nodes == 2 and lava_nodes == 2 then production_level = 100; eu_supply = 30 * data.power end

				if production_level > 0 then
						meta:set_int(tier.."_EU_supply", eu_supply)
				end
				
				

				 meta:set_string("infotext", description.." ("..production_level.."%) "..technic.prettynum(eu_supply) .." EU")


						
				
				
			
				
						
				if production_level > 0 and minetest.get_node(pos).name == off_name then
						technic.swap_node (pos, on_name)
						return
				end
				if production_level == 0 then
						technic.swap_node(pos, off_name)
						meta:set_int(tier.."_EU_supply", 0)
				end
		end
		
		
		if data.old then
		
		
		else
		
		
		
		end
		
		minetest.register_node(off_name, {
			description = description,
			tiles = {texture_name.."_top.png", "technic_machine_bottom.png", texture_name.."_side.png",
					 texture_name.."_side.png", texture_name.."_side.png", texture_name.."_side.png"},
			paramtype2 = "facedir",
			groups = groups,
			legacy_facedir_simple = true,
			sounds = default.node_sound_wood_defaults(),
			on_construct = function(pos)
					local meta = minetest.get_meta(pos)
					meta:set_string("infotext", S("Geothermal %s Generator"):format(tier))
					meta:set_int(tier.."_EU_supply", 0)
			end,
			technic_run = run,
		})

		minetest.register_node(on_name, {
			description = description,
			tiles = {texture_name.."_top_active.png", "technic_machine_bottom.png", texture_name.."_side.png",
					 texture_name.."_side.png", texture_name.."_side.png", texture_name.."_side.png"},
			paramtype2 = "facedir",
			groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
			legacy_facedir_simple = true,
			sounds = default.node_sound_wood_defaults(),
			drop = off_name,
			technic_run = run,
		})
       

        technic.register_machine(tier, off_name, technic.producer)
		technic.register_machine(tier, on_name, technic.producer)

        
end
