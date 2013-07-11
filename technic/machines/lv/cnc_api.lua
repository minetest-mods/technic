-- API for the technic CNC machine
-- Again code is adapted from the NonCubic Blocks MOD v1.4 by yves_de_beck
technic_cnc_api = {}

-- HERE YOU CAN CHANGE THE DETAIL-LEVEL:
----------------------------------------
technic_cnc_api.detail_level = 16 -- 16; 1-32

-- REGISTER NONCUBIC FORMS, CREATE MODELS AND RECIPES:
------------------------------------------------------
local cnc_sphere =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      local sehne
      for i = 1, detail-1 do
	 sehne = math.sqrt(0.25 - (((i/detail)-0.5)^2))
	 nodebox[i]={-sehne, (i/detail)-0.5, -sehne, sehne, (i/detail)+(1/detail)-0.5, sehne}
      end
      return nodebox
   end

local cnc_cylinder_horizontal =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      local sehne
      for i = 1, detail-1 do
	 sehne = math.sqrt(0.25 - (((i/detail)-0.5)^2))
	 nodebox[i]={-0.5, (i/detail)-0.5, -sehne, 0.5, (i/detail)+(1/detail)-0.5, sehne}
      end
      return nodebox
   end

local cnc_cylinder =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      local sehne
      for i = 1, detail-1 do
	 sehne = math.sqrt(0.25 - (((i/detail)-0.5)^2))
	 nodebox[i]={(i/detail)-0.5, -0.5, -sehne, (i/detail)+(1/detail)-0.5, 0.5, sehne}
      end
      return nodebox
   end

local cnc_twocurvededge =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level*2
      local sehne
      for i = (detail/2)-1, detail-1 do
	 sehne = math.sqrt(0.25 - (((i/detail)-0.5)^2))
	 nodebox[i]={-sehne, -0.5, -sehne, 0.5, (i/detail)+(1/detail)-0.5, 0.5}
      end
      return nodebox
   end

local cnc_onecurvededge =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level*2
      local sehne
      for i = (detail/2)-1, detail-1 do
	 sehne = math.sqrt(0.25 - (((i/detail)-0.5)^2))
	 nodebox[i]={-0.5, -0.5, -sehne, 0.5, (i/detail)+(1/detail)-0.5, 0.5}
      end 
     return nodebox
   end

local cnc_spike =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      for i = 0, detail-1 do
	 nodebox[i+1]={(i/detail/2)-0.5, (i/detail/2)-0.5, (i/detail/2)-0.5, 0.5-(i/detail/2), (i/detail)-0.5+(1/detail), 0.5-(i/detail/2)}
end
      return nodebox
   end

local cnc_pyramid =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level/2
      for i = 0, detail-1 do
	 nodebox[i+1]={(i/detail/2)-0.5, (i/detail/2)-0.5, (i/detail/2)-0.5, 0.5-(i/detail/2), (i/detail/2)-0.5+(1/detail), 0.5-(i/detail/2)}
      end
      return nodebox
   end

local cnc_slope_inner_edge_upsdown =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      for i = 0, detail-1 do
	 nodebox[i+1]={0.5-(i/detail)-(1/detail), (i/detail)-0.5, -0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
	 nodebox[i+detail+1]={-0.5, (i/detail)-0.5, 0.5-(i/detail)-(1/detail), 0.5, (i/detail)-0.5+(1/detail), 0.5}
      end
      return nodebox
   end

local cnc_slope_edge_upsdown =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      for i = 0, detail-1 do
	 nodebox[i+1]={(-1*(i/detail))+0.5-(1/detail), (i/detail)-0.5, (-1*(i/detail))+0.5-(1/detail), 0.5, (i/detail)-0.5+(1/detail), 0.5}
      end
      return nodebox
   end

local cnc_slope_inner_edge =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      for i = 0, detail-1 do
	 nodebox[i+1]={(i/detail)-0.5, -0.5, -0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
	 nodebox[i+detail+1]={-0.5, -0.5, (i/detail)-0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
      end
      return nodebox
   end

local cnc_slope_edge =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      for i = 0, detail-1 do
	 nodebox[i+1]={(i/detail)-0.5, -0.5, (i/detail)-0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
      end
      return nodebox
   end

local cnc_slope_upsdown =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      for i = 0, detail-1 do
	 nodebox[i+1]={-0.5, (i/detail)-0.5, (-1*(i/detail))+0.5-(1/detail), 0.5, (i/detail)-0.5+(1/detail), 0.5}
      end
      return nodebox
   end

local cnc_slope_lying =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      for i = 0, detail-1 do
	 nodebox[i+1]={(i/detail)-0.5, -0.5, (i/detail)-0.5, (i/detail)-0.5+(1/detail), 0.5 , 0.5}
      end
      return nodebox
   end

local cnc_slope =
   function()
      local nodebox = {}
      local detail = technic_cnc_api.detail_level
      for i = 0, detail-1 do
	 nodebox[i+1]={-0.5, (i/detail)-0.5, (i/detail)-0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
      end
      return nodebox
   end

-- Define slope boxes for the various nodes
-------------------------------------------
technic_cnc_api.cnc_programs = {
   {suffix  = "technic_cnc_stick",
    nodebox = {-0.15, -0.5, -0.15, 0.15, 0.5, 0.15},
    desc    = "Stick"},

   {suffix  = "technic_cnc_element_end_double",
    nodebox = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.5},
    desc    = "Element End Double"},

   {suffix  = "technic_cnc_element_cross_double",
    nodebox = {
       {0.3, -0.5, -0.3, 0.5, 0.5, 0.3},
       {-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
       {-0.5, -0.5, -0.3, -0.3, 0.5, 0.3}},
    desc    = "Element Cross Double"},

   {suffix  = "technic_cnc_element_t_double",
    nodebox = {
       {-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
       {-0.5, -0.5, -0.3, -0.3, 0.5, 0.3},
       {0.3, -0.5, -0.3, 0.5, 0.5, 0.3}},
    desc    = "Element T Double"},

   {suffix  = "technic_cnc_element_edge_double",
    nodebox = {
       {-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
       {-0.5, -0.5, -0.3, -0.3, 0.5, 0.3}},
    desc    = "Element Edge Double"},

   {suffix  = "technic_cnc_element_straight_double",
    nodebox = {-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
    desc    = "Element Straight Double"},

   {suffix  = "technic_cnc_element_end",
    nodebox = {-0.3, -0.5, -0.3, 0.3, 0, 0.5},
    desc    = "Element End"},

   {suffix  = "technic_cnc_element_cross",
    nodebox = {
       {0.3, -0.5, -0.3, 0.5, 0, 0.3},
       {-0.3, -0.5, -0.5, 0.3, 0, 0.5},
       {-0.5, -0.5, -0.3, -0.3, 0, 0.3}},
    desc    = "Element Cross"},

   {suffix  = "technic_cnc_element_t",
    nodebox = {
       {-0.3, -0.5, -0.5, 0.3, 0, 0.3},
       {-0.5, -0.5, -0.3, -0.3, 0, 0.3},
       {0.3, -0.5, -0.3, 0.5, 0, 0.3}},
    desc    = "Element T"},

   {suffix  = "technic_cnc_element_edge",
    nodebox = {
       {-0.3, -0.5, -0.5, 0.3, 0, 0.3},
       {-0.5, -0.5, -0.3, -0.3, 0, 0.3}},
    desc    = "Element Edge"},

   {suffix  = "technic_cnc_element_straight",
    nodebox = {-0.3, -0.5, -0.5, 0.3, 0, 0.5},
    desc    = "Element Straight"},

   {suffix  = "technic_cnc_sphere",
    nodebox = cnc_sphere(),
    desc    = "Sphere"},

   {suffix  = "technic_cnc_cylinder_horizontal",
    nodebox = cnc_cylinder_horizontal(),
    desc    = "Cylinder Horizontal"},

   {suffix  = "technic_cnc_cylinder",
    nodebox = cnc_cylinder(),
    desc    = ""},

   {suffix  = "technic_cnc_twocurvededge",
    nodebox = cnc_twocurvededge(),
    desc    = "One Curved Edge Block"},

   {suffix  = "technic_cnc_onecurvededge",
    nodebox = cnc_onecurvededge(),
    desc    = "Two Curved Edge Block"},

   {suffix  = "technic_cnc_spike",
    nodebox = cnc_spike(),
    desc    = "Spike"},

   {suffix  = "technic_cnc_pyramid",
    nodebox = cnc_pyramid(),
    desc    = "Pyramid"},

   {suffix  = "technic_cnc_slope_inner_edge_upsdown",
    nodebox = cnc_slope_inner_edge_upsdown(),
    desc    = "Slope Upside Down Inner Edge"},

   {suffix  = "technic_cnc_slope_edge_upsdown",
    nodebox = cnc_slope_edge_upsdown(),
    desc    = "Slope Upside Down Edge"},

   {suffix  = "technic_cnc_slope_inner_edge",
    nodebox = cnc_slope_inner_edge(),
    desc    = "Slope Inner Edge"},

   {suffix  = "technic_cnc_slope_edge",
    nodebox = cnc_slope_edge(),
    desc    = "Slope Edge"},

   {suffix  = "technic_cnc_slope_upsdown",
    nodebox = cnc_slope_upsdown(),
    desc    = "Slope Upside Down"},

   {suffix  = "technic_cnc_slope_lying",
    nodebox = cnc_slope_lying(),
    desc    = "Slope Lying"},

   {suffix  = "technic_cnc_slope",
    nodebox = cnc_slope(),
    desc    = "Slope"},
--   {suffix  = "",
--    nodebox =},
}

-- Allow disabling certain programs for some node. Default is allowing all types for all nodes
technic_cnc_api.cnc_programs_disable = {
   -- ["default:brick"] = {"technic_cnc_stick"}, -- Example: Disallow the stick for brick
   -- ...
   ["default:dirt"] = {"technic_cnc_sphere", "technic_cnc_slope_upsdown", "technic_cnc_edge",
		       "technic_cnc_inner_edge", "technic_cnc_slope_edge_upsdown", "technic_cnc_slope_inner_edge_upsdown",
		       "technic_cnc_stick", "technic_cnc_cylinder_horizontal"}
}

-- Generic function for registering all the different node types
function technic_cnc_api.register_cnc_program(recipeitem, suffix, nodebox, groups, images, description)
   minetest.register_node(":" .. recipeitem .. "_" .. suffix, {
			     description   = description,
			     drawtype      = "nodebox",
			     tiles         = images,
			     paramtype     = "light",
			     paramtype2    = "facedir",
			     walkable      = true,
			     selection_box = {
				type  = "fixed",
				fixed = nodebox
			     },
			     node_box      = {
				type  = "fixed",
				fixed = nodebox
			     },
			     groups        = groups,
			  })
end

-- function to iterate over all the programs the CNC machine knows
function technic_cnc_api.register_all(recipeitem, groups, images, description)
   for _, data in ipairs(technic_cnc_api.cnc_programs) do
      -- Disable node creation for disabled node types for some material
      local do_register = true
      if technic_cnc_api.cnc_programs_disable[recipeitem] ~= nil then
	 for __, disable in ipairs(technic_cnc_api.cnc_programs_disable[recipeitem]) do
	    if disable == data.suffix then
	       do_register = false
	    end
	 end
      end
      -- Create the node if it passes the test
      if do_register then
	 technic_cnc_api.register_cnc_program(recipeitem, data.suffix, data.nodebox, groups, images, description.." "..data.desc)
      end
   end
end


-- REGISTER NEW TECHNIC_CNC_API's PART 2: technic_cnc_api.register_element_end(subname, recipeitem, groups, images, desc_element_xyz)
-----------------------------------------------------------------------------------------------------------------------
function technic_cnc_api.register_slope_edge_etc(recipeitem, groups, images, desc_slope, desc_slope_lying, desc_slope_upsdown, desc_slope_edge, desc_slope_inner_edge, desc_slope_upsdwn_edge, desc_slope_upsdwn_inner_edge, desc_pyramid, desc_spike, desc_onecurvededge, desc_twocurvededge, desc_cylinder, desc_cylinder_horizontal, desc_sphere, desc_element_straight, desc_element_edge, desc_element_t, desc_element_cross, desc_element_end)

         technic_cnc_api.register_slope(recipeitem, groups, images, desc_slope)
         technic_cnc_api.register_slope_lying(recipeitem, groups, images, desc_slope_lying)
         technic_cnc_api.register_slope_upsdown(recipeitem, groups, images, desc_slope_upsdown)
         technic_cnc_api.register_slope_edge(recipeitem, groups, images, desc_slope_edge)
         technic_cnc_api.register_slope_inner_edge(recipeitem, groups, images, desc_slope_inner_edge)
         technic_cnc_api.register_slope_edge_upsdown(recipeitem, groups, images, desc_slope_upsdwn_edge)
         technic_cnc_api.register_slope_inner_edge_upsdown(recipeitem, groups, images, desc_slope_upsdwn_inner_edge)
         technic_cnc_api.register_pyramid(recipeitem, groups, images, desc_pyramid)
         technic_cnc_api.register_spike(recipeitem, groups, images, desc_spike)
         technic_cnc_api.register_onecurvededge(recipeitem, groups, images, desc_onecurvededge)
         technic_cnc_api.register_twocurvededge(recipeitem, groups, images, desc_twocurvededge)
         technic_cnc_api.register_cylinder(recipeitem, groups, images, desc_cylinder)
         technic_cnc_api.register_cylinder_horizontal(recipeitem, groups, images, desc_cylinder_horizontal)
         technic_cnc_api.register_sphere(recipeitem, groups, images, desc_sphere)
         technic_cnc_api.register_element_straight(recipeitem, groups, images, desc_element_straight)
         technic_cnc_api.register_element_edge(recipeitem, groups, images, desc_element_edge)
         technic_cnc_api.register_element_t(recipeitem, groups, images, desc_element_t)
         technic_cnc_api.register_element_cross(recipeitem, groups, images, desc_element_cross)
         technic_cnc_api.register_element_end(recipeitem, groups, images, desc_element_end)
end

-- REGISTER STICKS: noncubic.register_xyz(recipeitem, groups, images, desc_element_xyz)
------------------------------------------------------------------------------------------------------------
function technic_cnc_api.register_stick_etc(recipeitem, groups, images, desc_stick)
         technic_cnc_api.register_stick(recipeitem, groups, images, desc_stick)
end

function technic_cnc_api.register_elements(recipeitem, groups, images, desc_element_straight_double, desc_element_edge_double, desc_element_t_double, desc_element_cross_double, desc_element_end_double)
         technic_cnc_api.register_element_straight_double(recipeitem, groups, images, desc_element_straight_double)
         technic_cnc_api.register_element_edge_double(recipeitem, groups, images, desc_element_edge_double)
         technic_cnc_api.register_element_t_double(recipeitem, groups, images, desc_element_t_double)
         technic_cnc_api.register_element_cross_double(recipeitem, groups, images, desc_element_cross_double)
         technic_cnc_api.register_element_end_double(recipeitem, groups, images, desc_element_end_double)
end
