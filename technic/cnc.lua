-- Technic CNC v1.0 by kpo
-- Based on the NonCubic Blocks MOD v1.4 by yves_de_beck
local shape = {}
local size = 0
local onesize_products = {
   slope                   = 2,
   slope_edge              = 1,
   slope_inner_edge        = 1,
   pyramid                 = 2,
   spike                   = 1,
   cylinder                = 2,
   sphere                  = 1,
   stick                   = 8,
   slope_upsdwn            = 2,
   slope_edge_upsdwn       = 1,
   slope_inner_edge_upsdwn = 1,
   cylinder_hor            = 2,
   slope_lying             = 2,
   onecurvededge           = 1,
   twocurvededge           = 1,
}
local twosize_products = {
   element_straight        = 4,
   element_end             = 2,
   element_cross           = 1,
   element_t               = 1,
   element_edge            = 2,
}

local showbackground = "--"
local max_cncruns  = 99
local max_products = 99

--showlabelin  = ""
--showlabelout = "label[4.5,5.5;Out:]"

-- I want the CNC machine to be a two block thing
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
        groups = {oddly_breakable_by_hand=2, cracky=3, dig_immediate=1},
	
	can_dig = function(pos,player)
		     local meta = minetest.env:get_meta(pos);
		     local inv = meta:get_inventory()
		     if not inv:is_empty("input") or not inv:is_empty("output") then
			minetest.chat_send_player(player:get_player_name(), "CNC machine cannot be removed because it is not empty");
			return false
		     end
		     return true
		  end,

	on_construct = function(pos)
			  local meta = minetest.env:get_meta(pos)
			  if technic_cnc_api.allow_menu_background == true or technic_cnc_api.allow_menu_background == 1 then
			     showbackground = "background[-0.15,-0.25;8.40,11.75;technic_cnc_background.png]"
			  end
			  
			  meta:set_string("formspec", "invsize[8,11;]"..
					  "label[0,0;Choose Milling Program:]"..
					  "image_button[0,0.5;1,1;technic_cnc_slope.png;slope; ]"..
					  "image_button[1,0.5;1,1;technic_cnc_slope_edge.png;slope_edge; ]"..
					  "image_button[2,0.5;1,1;technic_cnc_slope_inner_edge.png;slope_inner_edge; ]"..
					  "image_button[3,0.5;1,1;technic_cnc_pyramid.png;pyramid; ]"..
					  "image_button[4,0.5;1,1;technic_cnc_spike.png;spike; ]"..
					  "image_button[5,0.5;1,1;technic_cnc_cylinder.png;cylinder; ]"..
					  "image_button[6,0.5;1,1;technic_cnc_sphere.png;sphere; ]"..
					  "image_button[7,0.5;1,1;technic_cnc_stick.png;stick; ]"..

					  "image_button[0,1.5;1,1;technic_cnc_slope_upsdwn.png;slope_upsdwn; ]"..
					  "image_button[1,1.5;1,1;technic_cnc_slope_edge_upsdwn.png;slope_upsdwn_edge; ]"..
					  "image_button[2,1.5;1,1;technic_cnc_slope_inner_edge_upsdwn.png;slope_upddown_inner_edge; ]"..
					  "image_button[5,1.5;1,1;technic_cnc_cylinder_horizontal.png;cylinder_horizontal; ]"..

					  "image_button[0,2.5;1,1;technic_cnc_slope_lying.png;slope_lying; ]"..
					  "image_button[1,2.5;1,1;technic_cnc_onecurvededge.png;onecurvededge; ]"..
					  "image_button[2,2.5;1,1;technic_cnc_twocurvededge.png;twocurvededge; ]"..

					  "label[0,3.5;Slim Elements half / normal height:]"..

					  "image_button[0,4;1,0.5;technic_cnc_full.png;full; ]"..
					  "image_button[0,4.5;1,0.5;technic_cnc_half.png;half; ]"..
					  "image_button[1,4;1,1;technic_cnc_element_straight.png;element_straight; ]"..
					  "image_button[2,4;1,1;technic_cnc_element_end.png;element_end; ]"..
					  "image_button[3,4;1,1;technic_cnc_element_cross.png;element_cross; ]"..
					  "image_button[4,4;1,1;technic_cnc_element_t.png;element_t; ]"..
					  "image_button[5,4;1,1;technic_cnc_element_edge.png;element_edge; ]"..

					  "label[0, 5.5;In:]".. -- showlabelin..
					  "list[current_name;input;0.5,5.5;1,1;]"..
					  "field[3, 6;1,1;num_cncruns;Repeat program:;${num_cncruns}]".. -- Fill default with meta data num_cncruns
					  "label[4, 5.5;Out:]".. -- showlabelout..
					  "list[current_name;output;4.5,5.5;1,1;]"..

					  "list[current_player;main;0,7;8,4;]"..
					  showbackground)
			  meta:set_string("infotext", "CNC Milling Machine")
			  meta:set_string("num_cncruns", 1 );

			  local inv = meta:get_inventory()
			  inv:set_size("input", 1)
			  inv:set_size("output", 1)
		       end,
	
	on_receive_fields = function(pos, formname, fields, sender)
			       -- REGISTER MILLING PROGRAMMS AND OUTPUTS:
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
			       
			       local meta = minetest.env:get_meta(pos)
			       local inv = meta:get_inventory()

			       -- Limit the number entered
			       if( fields.num_cncruns  and tonumber( fields.num_cncruns) > 0 and tonumber(fields.num_cncruns) < 100 ) then
				  meta:set_string( "num_cncruns", fields.num_cncruns );
			       else
				  minetest.chat_send_player(sender:get_player_name(), "CNC machine runs set to a bad value. Machine resets.");
				  meta:set_string( "num_cncruns", 1 );
				  fields.num_cncruns = 1
			       end
			       
			       -- Do nothing if the machine is empty
			       if inv:is_empty("input") then
				  return
			       end

			       -- Do nothing if the output is not empty and the product used is not the same as what is already there

			       -- Resolve the node name and the number of items to make and the number of items to take
			       local product    = ""
			       local produces   = 1
			       local input_used = 1
			       local inputstack = inv:get_stack("input", 1)
			       local inputname  = inputstack:get_name()
			       local multiplier = 1
			       for k, _ in pairs(fields) do
				  -- Set a multipier for the half/full size capable blocks
				  if twosize_products[k] ~= nil then
				     multiplier = size*twosize_products[k]
				  else
				     multiplier = onesize_products[k]
				  end
				  
				  if onesize_products[k] ~= nil or twosize_products[k] ~= nil then
				     product    = inputname .. "_technic_cnc_" .. k
				     produces   = math.min( fields.num_cncruns*multiplier, max_products)  -- produce at most max_products
				     input_used = math.min( math.floor(produces/multiplier), inputstack:get_count()) -- use at most what we got
				     produces   = input_used*multiplier -- final production
				     print(size)
				     print(fields.num_cncruns)
				     print(product)
				     print(produces)
				     print(input_used)
				     print("------------------")
				     break
				  end
			       end

			       -- CNC does the transformation
			       ------------------------------
			       if minetest.registered_nodes[product] ~= nil then
				  inv:add_item("output",product .. " " .. produces)
				  inputstack:take_item(input_used)
				  inv:set_stack("input",1,inputstack)
			       else
				  minetest.chat_send_player(sender:get_player_name(), "CNC machine does not know how to mill this material. Please remove it.");
			       end
			       return;
			    end, -- callback function
     })
----------


-- Milling Machine Recipe
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