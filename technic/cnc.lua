-- Technic CNC v1.0 by kpo
-- Based on the NonCubic Blocks MOD v1.4 by yves_de_beck

-- Idea:
--   Somehw have a tabbed/paged panel if the number of shapes should expand
--   beyond what is available in the panel today.
--   I could imagine some form of API allowing modders to come with their own node
--   box definitions and easily stuff it in the this machine for production.
local shape = {}
local onesize_products = {
   slope                    = 2,
   slope_edge               = 1,
   slope_inner_edge         = 1,
   pyramid                  = 2,
   spike                    = 1,
   cylinder                 = 2,
   sphere                   = 1,
   stick                    = 8,
   slope_upsdown            = 2,
   slope_edge_upsdown       = 1,
   slope_inner_edge_upsdown = 1,
   cylinder_horizontal      = 2,
   slope_lying              = 2,
   onecurvededge            = 1,
   twocurvededge            = 1,
}
local twosize_products = {
   element_straight         = 4,
   element_end              = 2,
   element_cross            = 1,
   element_t                = 1,
   element_edge             = 2,
}

--cnc_recipes ={}
--registered_cnc_recipes_count=1
--
--function register_cnc_recipe (string1,string2)
--   cnc_recipes[registered_cnc_recipes_count]={}
--   cnc_recipes[registered_cnc_recipes_count].src_name=string1
--   cnc_recipes[registered_cnc_recipes_count].dst_name=string2
--   registered_cnc_recipes_count=registered_cnc_recipes_count+1
--   if unified_inventory then
--      unified_inventory.register_craft({
--					  type = "cnc milling",
--					  output = string2,
--					  items = {string1},
--					  width = 0,
--				       })
--   end
--end

local cnc_formspec =
   "invsize[9,11;]"..
   "label[1,0;Choose Milling Program:]"..
   "image_button[1,0.5;1,1;technic_cnc_slope.png;slope; ]"..
   "image_button[2,0.5;1,1;technic_cnc_slope_edge.png;slope_edge; ]"..
   "image_button[3,0.5;1,1;technic_cnc_slope_inner_edge.png;slope_inner_edge; ]"..
   "image_button[4,0.5;1,1;technic_cnc_pyramid.png;pyramid; ]"..
   "image_button[5,0.5;1,1;technic_cnc_spike.png;spike; ]"..
   "image_button[6,0.5;1,1;technic_cnc_cylinder.png;cylinder; ]"..
   "image_button[7,0.5;1,1;technic_cnc_sphere.png;sphere; ]"..
   "image_button[8,0.5;1,1;technic_cnc_stick.png;stick; ]"..
   
   "image_button[1,1.5;1,1;technic_cnc_slope_upsdwn.png;slope_upsdown; ]"..
   "image_button[2,1.5;1,1;technic_cnc_slope_edge_upsdwn.png;slope_edge_upsdown; ]"..
   "image_button[3,1.5;1,1;technic_cnc_slope_inner_edge_upsdwn.png;slope_inner_edge_upsdown; ]"..
   "image_button[4,1.5;1,1;technic_cnc_cylinder_horizontal.png;cylinder_horizontal; ]"..
   
   "image_button[1,2.5;1,1;technic_cnc_slope_lying.png;slope_lying; ]"..
   "image_button[2,2.5;1,1;technic_cnc_onecurvededge.png;onecurvededge; ]"..
   "image_button[3,2.5;1,1;technic_cnc_twocurvededge.png;twocurvededge; ]"..
   
   "label[1,3.5;Slim Elements half / normal height:]"..
   
   "image_button[1,4;1,0.5;technic_cnc_full.png;full; ]"..
   "image_button[1,4.5;1,0.5;technic_cnc_half.png;half; ]"..
   "image_button[2,4;1,1;technic_cnc_element_straight.png;element_straight; ]"..
   "image_button[3,4;1,1;technic_cnc_element_end.png;element_end; ]"..
   "image_button[4,4;1,1;technic_cnc_element_cross.png;element_cross; ]"..
   "image_button[5,4;1,1;technic_cnc_element_t.png;element_t; ]"..
   "image_button[6,4;1,1;technic_cnc_element_edge.png;element_edge; ]"..
   
   "label[0, 5.5;In:]"..
   "list[current_name;src;0.5,5.5;1,1;]"..
   "label[4, 5.5;Out:]"..
   "list[current_name;dst;5,5.5;4,1;]"..
   
   "list[current_player;main;0,7;8,4;]"


local cnc_power_formspec=
   "label[0,3;Power]"..
   "image[0,1;1,2;technic_power_meter_bg.png]"

local size     = 1;

-- The form handler is declared here because we need it in both the inactive and active modes
-- in order to be able to change programs wile it is running.
local form_handler = function(pos, formname, fields, sender)
			       -- REGISTER MILLING PROGRAMS AND OUTPUTS:
			       ------------------------------------------
			       -- Program for half/full size
			       if fields["full"] then
				  size = 1
				  return
			       end
			       
			       if fields["half"] then
				  size = 2
				  return
			       end
			       
			       -- Resolve the node name and the number of items to make
			       local meta       = minetest.env:get_meta(pos)
			       local inv        = meta:get_inventory()
			       local inputstack = inv:get_stack("src", 1)
			       local inputname  = inputstack:get_name()
			       local multiplier = 0
			       for k, _ in pairs(fields) do
				  -- Set a multipier for the half/full size capable blocks
				  if twosize_products[k] ~= nil then
				     multiplier = size*twosize_products[k]
				  else
				     multiplier = onesize_products[k]
				  end

				  if onesize_products[k] ~= nil or twosize_products[k] ~= nil then
				     meta:set_float( "cnc_multiplier", multiplier)
				     meta:set_string("cnc_user", sender:get_player_name())
				  end

				  if onesize_products[k] ~= nil or (twosize_products[k] ~= nil and size==2) then
				     meta:set_string("cnc_product",  inputname .. "_technic_cnc_" .. k)
				     print(inputname .. "_technic_cnc_" .. k)
				     break
				  end

				  if twosize_products[k] ~= nil and size==1 then
				     meta:set_string("cnc_product",  inputname .. "_technic_cnc_" .. k .. "_double")
				     print(inputname .. "_technic_cnc_" .. k .. "_double")
				     break
				  end
			       end
			       return
			    end -- callback function

-- The actual block inactive state
minetest.register_node("technic:cnc", {
	description = "CNC Milling Machine",
        tiles       = {"technic_cnc_top.png", "technic_cnc_bottom.png", "technic_cnc_side.png",
		       "technic_cnc_side.png", "technic_cnc_side.png", "technic_cnc_front.png"},
        drawtype    = "nodebox",
        paramtype   = "light",
        paramtype2  = "facedir",
        node_box    = {
	   type  = "fixed",
	   fixed = {
	      {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	      
	   },
        },
        selection_box = {
	   type = "fixed",
	   fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        groups = {cracky=2},
	legacy_facedir_simple = true,
	technic_power_machine=1,
	internal_EU_buffer=0;
	internal_EU_buffer_size=5000;
	cnc_time = 0;
	src_time = 0; -- fixme
	
	on_construct = function(pos)
			  local meta = minetest.env:get_meta(pos)
			  meta:set_string("infotext", "CNC Machine Inactive")
			  meta:set_float("technic_power_machine", 1)
			  meta:set_float("internal_EU_buffer", 0)
			  meta:set_float("internal_EU_buffer_size", 5000)
			  meta:set_string("formspec", cnc_formspec..cnc_power_formspec)
			  meta:set_float("cnc_time", 0)

			  local inv = meta:get_inventory()
			  inv:set_size("src", 1)
			  inv:set_size("dst", 4)
		       end,
	
	can_dig = function(pos,player)
		     local meta = minetest.env:get_meta(pos);
		     local inv = meta:get_inventory()
		     if not inv:is_empty("src") or not inv:is_empty("dst") then
			minetest.chat_send_player(player:get_player_name(), "CNC machine cannot be removed because it is not empty");
			return false
		     end
		     return true
		  end,

	on_receive_fields = form_handler,
     })

-- Active state block
minetest.register_node("technic:cnc_active", {
	description = "CNC Machine",
        tiles       = {"technic_cnc_top_active.png", "technic_cnc_bottom.png", "technic_cnc_side.png",
		       "technic_cnc_side.png",       "technic_cnc_side.png",   "technic_cnc_front_active.png"},
	paramtype2 = "facedir",
	groups = {cracky=2,not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	can_dig = function(pos,player)
		     local meta = minetest.env:get_meta(pos);
		     local inv = meta:get_inventory()
		     if not inv:is_empty("src") or not inv:is_empty("dst") then
			minetest.chat_send_player(player:get_player_name(), "CNC machine cannot be removed because it is not empty");
			return false
		     end
		     return true
		  end,
	on_receive_fields = form_handler,
})

-- Action code performing the transformation
minetest.register_abm(
   {
      nodenames = {"technic:cnc","technic:cnc_active"},
      interval = 1,
      chance = 1,
      action = function(pos, node, active_object_count, active_object_count_wider)
		  local meta = minetest.env:get_meta(pos)
		  local charge= meta:get_float("internal_EU_buffer")
		  local max_charge= meta:get_float("internal_EU_buffer_size")
		  local cnc_cost=350
		  
		  local load = math.floor((charge/max_charge)*100)
		  meta:set_string("formspec", cnc_formspec..
				  "image[0,1;1,2;technic_power_meter_bg.png^[lowpart:"..
				  (load)..":technic_power_meter_fg.png]"
			    )
		  
		  local inv = meta:get_inventory()
		  local srclist = inv:get_list("src")
		  if inv:is_empty("src") then
		     meta:set_float("cnc_on",0)
		     meta:set_string("cnc_product", "") -- Reset the program
		  end 
		  
		  if (meta:get_float("cnc_on") == 1) then
		     if charge>=cnc_cost then
			charge=charge-cnc_cost;
			meta:set_float("internal_EU_buffer",charge)
			meta:set_float("src_time", meta:get_float("src_time") + 1)
			if meta:get_float("src_time") >= meta:get_float("cnc_time") then
			   local product = meta:get_string("cnc_product")
			   if inv:room_for_item("dst",product) then
			      -- CNC does the transformation
			      ------------------------------
			      if minetest.registered_nodes[product] ~= nil then
				 inv:add_item("dst",product .. " " .. meta:get_float("cnc_multiplier"))
				 srcstack = inv:get_stack("src", 1)
				 srcstack:take_item()
				 inv:set_stack("src",1,srcstack)
				 if inv:is_empty("src") then
				    meta:set_float("cnc_on",0)
				    meta:set_string("cnc_product", "") -- Reset the program
--				    print("cnc product reset")
				 end 
			      else
				 minetest.chat_send_player(meta:get_string("cnc_user"), "CNC machine does not know how to handle this material. Please remove it.");
			      end
			   else
			      minetest.chat_send_player(meta:get_string("cnc_user"), "CNC inventory full!")
			   end
			   meta:set_float("src_time", 0)
			end
		     end
		  end

		  if (meta:get_float("cnc_on")==0) then
		     if not inv:is_empty("src") then
			local product = meta:get_string("cnc_product")
			if minetest.registered_nodes[product] ~= nil then 
			   meta:set_float("cnc_on",1)
			   hacky_swap_node(pos,"technic:cnc_active")
			   meta:set_string("infotext", "CNC Machine Active")
			   cnc_time=3
			   meta:set_float("cnc_time",cnc_time)
			   meta:set_float("src_time", 0)
			   return
			end
		     else 
			hacky_swap_node(pos,"technic:cnc")
			meta:set_string("infotext", "CNC Machine Inactive")
		     end
		  end
	       end
   }) 

register_LV_machine ("technic:cnc","RE")
register_LV_machine ("technic:cnc_active","RE")
-------------------------

-- CNC Machine Recipe
-------------------------
minetest.register_craft({
			   output = 'technic:cnc',
			   recipe = {
			      {'default:glass',              'technic:diamond_drill_head', 'default:glass'},
			      {'technic:control_logic_unit', 'technic:motor',              'default:steel_ingot'},
			      {'default:steel_ingot',        'default:copper_ingot',       'default:steel_ingot'},         
			   },
			})
-------------------------