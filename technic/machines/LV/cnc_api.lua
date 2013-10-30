-- API for the technic CNC machine
-- Again code is adapted from the NonCubic Blocks MOD v1.4 by yves_de_beck

local S = technic.getter

technic.cnc = {}

technic.cnc.detail_level = 16

-- REGISTER NONCUBIC FORMS, CREATE MODELS AND RECIPES:
------------------------------------------------------
local function cnc_sphere()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	local sehne
	for i = 1, detail - 1 do
		sehne = math.sqrt(0.25 - (((i / detail) - 0.5) ^ 2))
		nodebox[i]={-sehne, (i/detail) - 0.5, -sehne, sehne, (i/detail)+(1/detail)-0.5, sehne}
	end
	return nodebox
end

local function cnc_cylinder_horizontal()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	local sehne
	for i = 1, detail - 1 do
		sehne = math.sqrt(0.25 - (((i / detail) - 0.5) ^ 2))
		nodebox[i]={-0.5, (i/detail)-0.5, -sehne, 0.5, (i/detail)+(1/detail)-0.5, sehne}
	end
	return nodebox
end

local function cnc_cylinder()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	local sehne
	for i = 1, detail - 1 do
		sehne = math.sqrt(0.25 - (((i / detail) - 0.5) ^ 2))
		nodebox[i]={(i/detail) - 0.5, -0.5, -sehne, (i/detail)+(1/detail)-0.5, 0.5, sehne}
	end
	return nodebox
end

local function cnc_twocurvededge()
	local nodebox = {}
	local detail = technic.cnc.detail_level * 2
	local sehne
	for i = (detail / 2) - 1, detail - 1 do
		sehne = math.sqrt(0.25 - (((i / detail) - 0.5) ^ 2))
		nodebox[i]={-sehne, -0.5, -sehne, 0.5, (i/detail)+(1/detail)-0.5, 0.5}
	end
	return nodebox
end

local function cnc_onecurvededge()
	local nodebox = {}
	local detail = technic.cnc.detail_level * 2
	local sehne
	for i = (detail / 2) - 1, detail - 1 do
		sehne = math.sqrt(0.25 - (((i / detail) - 0.5) ^ 2))
		nodebox[i]={-0.5, -0.5, -sehne, 0.5, (i/detail)+(1/detail)-0.5, 0.5}
	end 
	return nodebox
end

local function cnc_spike()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	for i = 0, detail - 1 do
		nodebox[i+1] = {(i/detail/2)-0.5, (i/detail/2)-0.5, (i/detail/2)-0.5,
				0.5-(i/detail/2), (i/detail)-0.5+(1/detail), 0.5-(i/detail/2)}
	end
	return nodebox
end

local function cnc_pyramid()
	local nodebox = {}
	local detail = technic.cnc.detail_level / 2
	for i = 0, detail - 1 do
		nodebox[i+1] = {(i/detail/2)-0.5, (i/detail/2)-0.5, (i/detail/2)-0.5, 0.5-(i/detail/2), (i/detail/2)-0.5+(1/detail), 0.5-(i/detail/2)}
	end
	return nodebox
end

local function cnc_slope_inner_edge_upsdown()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	for i = 0, detail-1 do
		nodebox[i+1] = {0.5-(i/detail)-(1/detail), (i/detail)-0.5, -0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
		nodebox[i+detail+1] = {-0.5, (i/detail)-0.5, 0.5-(i/detail)-(1/detail), 0.5, (i/detail)-0.5+(1/detail), 0.5}
	end
	return nodebox
end

local function cnc_slope_edge_upsdown()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	for i = 0, detail-1 do
		nodebox[i+1] = {(-1*(i/detail))+0.5-(1/detail), (i/detail)-0.5, (-1*(i/detail))+0.5-(1/detail), 0.5, (i/detail)-0.5+(1/detail), 0.5}
	end
	return nodebox
end

local function cnc_slope_inner_edge()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	for i = 0, detail-1 do
		nodebox[i+1] = {(i/detail)-0.5, -0.5, -0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
		nodebox[i+detail+1] = {-0.5, -0.5, (i/detail)-0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
	end
	return nodebox
end

local function cnc_slope_edge()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	for i = 0, detail-1 do
		nodebox[i+1] = {(i/detail)-0.5, -0.5, (i/detail)-0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
	end
	return nodebox
end

local function cnc_slope_upsdown()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	for i = 0, detail-1 do
		nodebox[i+1] = {-0.5, (i/detail)-0.5, (-1*(i/detail))+0.5-(1/detail), 0.5, (i/detail)-0.5+(1/detail), 0.5}
	end
	return nodebox
end

local function cnc_slope_lying()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	for i = 0, detail-1 do
		nodebox[i+1] = {(i/detail)-0.5, -0.5, (i/detail)-0.5, (i/detail)-0.5+(1/detail), 0.5 , 0.5}
	end
	return nodebox
end

local function cnc_slope()
	local nodebox = {}
	local detail = technic.cnc.detail_level
	for i = 0, detail-1 do
		nodebox[i+1] = {-0.5, (i/detail)-0.5, (i/detail)-0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
	end
	return nodebox
end

-- Define slope boxes for the various nodes
-------------------------------------------
technic.cnc.programs = {
	{suffix  = "technic_cnc_stick",
	nodebox = {-0.15, -0.5, -0.15, 0.15, 0.5, 0.15},
	desc    = S("Stick")},

	{suffix  = "technic_cnc_element_end_double",
	nodebox = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.5},
	desc    = S("Element End Double")},

	{suffix  = "technic_cnc_element_cross_double",
	nodebox = {
		{0.3, -0.5, -0.3, 0.5, 0.5, 0.3},
		{-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
		{-0.5, -0.5, -0.3, -0.3, 0.5, 0.3}},
	desc    = S("Element Cross Double")},

	{suffix  = "technic_cnc_element_t_double",
	nodebox = {
		{-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
		{-0.5, -0.5, -0.3, -0.3, 0.5, 0.3},
		{0.3, -0.5, -0.3, 0.5, 0.5, 0.3}},
	desc    = S("Element T Double")},

	{suffix  = "technic_cnc_element_edge_double",
	nodebox = {
		{-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
		{-0.5, -0.5, -0.3, -0.3, 0.5, 0.3}},
	desc    = S("Element Edge Double")},

	{suffix  = "technic_cnc_element_straight_double",
	nodebox = {-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
	desc    = S("Element Straight Double")},

	{suffix  = "technic_cnc_element_end",
	nodebox = {-0.3, -0.5, -0.3, 0.3, 0, 0.5},
	desc    = S("Element End")},

	{suffix  = "technic_cnc_element_cross",
	nodebox = {
		{0.3, -0.5, -0.3, 0.5, 0, 0.3},
		{-0.3, -0.5, -0.5, 0.3, 0, 0.5},
		{-0.5, -0.5, -0.3, -0.3, 0, 0.3}},
	desc    = S("Element Cross")},

	{suffix  = "technic_cnc_element_t",
	nodebox = {
		{-0.3, -0.5, -0.5, 0.3, 0, 0.3},
		{-0.5, -0.5, -0.3, -0.3, 0, 0.3},
		{0.3, -0.5, -0.3, 0.5, 0, 0.3}},
	desc    = S("Element T")},

	{suffix  = "technic_cnc_element_edge",
	nodebox = {
		{-0.3, -0.5, -0.5, 0.3, 0, 0.3},
		{-0.5, -0.5, -0.3, -0.3, 0, 0.3}},
	desc    = S("Element Edge")},

	{suffix  = "technic_cnc_element_straight",
	nodebox = {-0.3, -0.5, -0.5, 0.3, 0, 0.5},
	desc    = S("Element Straight")},

	{suffix  = "technic_cnc_sphere",
	nodebox = cnc_sphere(),
	desc    = S("Sphere")},

	{suffix  = "technic_cnc_cylinder_horizontal",
	nodebox = cnc_cylinder_horizontal(),
	desc    = S("Horizontal Cylinder")},

	{suffix  = "technic_cnc_cylinder",
	nodebox = cnc_cylinder(),
	desc    = S("Cylinder")},

	{suffix  = "technic_cnc_twocurvededge",
	nodebox = cnc_twocurvededge(),
	desc    = S("Two Curved Edge Block")},

	{suffix  = "technic_cnc_onecurvededge",
	nodebox = cnc_onecurvededge(),
	desc    = S("One Curved Edge Block")},

	{suffix  = "technic_cnc_spike",
	nodebox = cnc_spike(),
	desc    = S("Spike")},

	{suffix  = "technic_cnc_pyramid",
	nodebox = cnc_pyramid(),
	desc    = S("Pyramid")},

	{suffix  = "technic_cnc_slope_inner_edge_upsdown",
	nodebox = cnc_slope_inner_edge_upsdown(),
	desc    = S("Slope Upside Down Inner Edge")},

	{suffix  = "technic_cnc_slope_edge_upsdown",
	nodebox = cnc_slope_edge_upsdown(),
	desc    = S("Slope Upside Down Edge")},

	{suffix  = "technic_cnc_slope_inner_edge",
	nodebox = cnc_slope_inner_edge(),
	desc    = S("Slope Inner Edge")},

	{suffix  = "technic_cnc_slope_edge",
	nodebox = cnc_slope_edge(),
	desc    = S("Slope Edge")},

	{suffix  = "technic_cnc_slope_upsdown",
	nodebox = cnc_slope_upsdown(),
	desc    = S("Slope Upside Down")},

	{suffix  = "technic_cnc_slope_lying",
	nodebox = cnc_slope_lying(),
	desc    = S("Slope Lying")},

	{suffix  = "technic_cnc_slope",
	nodebox = cnc_slope(),
	desc    = S("Slope")},
}

-- Allow disabling certain programs for some node. Default is allowing all types for all nodes
technic.cnc.programs_disable = {
	-- ["default:brick"] = {"technic_cnc_stick"}, -- Example: Disallow the stick for brick
	-- ...
	["default:dirt"] = {"technic_cnc_sphere", "technic_cnc_slope_upsdown", "technic_cnc_edge",
	                    "technic_cnc_inner_edge", "technic_cnc_slope_edge_upsdown",
	                    "technic_cnc_slope_inner_edge_upsdown", "technic_cnc_stick",
	                    "technic_cnc_cylinder_horizontal"}
}

-- Generic function for registering all the different node types
function technic.cnc.register_program(recipeitem, suffix, nodebox, groups, images, description)
	minetest.register_node(":"..recipeitem.."_"..suffix, {
		description   = description,
		drawtype      = "nodebox",
		tiles         = images,
		paramtype     = "light",
		paramtype2    = "facedir",
		walkable      = true,
		node_box = {
			type  = "fixed",
			fixed = nodebox
		},
		groups        = groups,
	})
end

-- function to iterate over all the programs the CNC machine knows
function technic.cnc.register_all(recipeitem, groups, images, description)
	for _, data in ipairs(technic.cnc.programs) do
		-- Disable node creation for disabled node types for some material
		local do_register = true
		if technic.cnc.programs_disable[recipeitem] ~= nil then
			for __, disable in ipairs(technic.cnc.programs_disable[recipeitem]) do
				if disable == data.suffix then
					do_register = false
				end
			end
		end
		-- Create the node if it passes the test
		if do_register then
			technic.cnc.register_program(recipeitem, data.suffix, data.nodebox, groups, images, description.." "..data.desc)
		end
	end
end


-- REGISTER NEW TECHNIC_CNC_API's PART 2: technic.cnc..register_element_end(subname, recipeitem, groups, images, desc_element_xyz)
-----------------------------------------------------------------------------------------------------------------------
function technic.cnc.register_slope_edge_etc(recipeitem, groups, images, desc_slope, desc_slope_lying, desc_slope_upsdown, desc_slope_edge, desc_slope_inner_edge, desc_slope_upsdwn_edge, desc_slope_upsdwn_inner_edge, desc_pyramid, desc_spike, desc_onecurvededge, desc_twocurvededge, desc_cylinder, desc_cylinder_horizontal, desc_sphere, desc_element_straight, desc_element_edge, desc_element_t, desc_element_cross, desc_element_end)

         technic.cnc.register_slope(recipeitem, groups, images, desc_slope)
         technic.cnc.register_slope_lying(recipeitem, groups, images, desc_slope_lying)
         technic.cnc.register_slope_upsdown(recipeitem, groups, images, desc_slope_upsdown)
         technic.cnc.register_slope_edge(recipeitem, groups, images, desc_slope_edge)
         technic.cnc.register_slope_inner_edge(recipeitem, groups, images, desc_slope_inner_edge)
         technic.cnc.register_slope_edge_upsdown(recipeitem, groups, images, desc_slope_upsdwn_edge)
         technic.cnc.register_slope_inner_edge_upsdown(recipeitem, groups, images, desc_slope_upsdwn_inner_edge)
         technic.cnc.register_pyramid(recipeitem, groups, images, desc_pyramid)
         technic.cnc.register_spike(recipeitem, groups, images, desc_spike)
         technic.cnc.register_onecurvededge(recipeitem, groups, images, desc_onecurvededge)
         technic.cnc.register_twocurvededge(recipeitem, groups, images, desc_twocurvededge)
         technic.cnc.register_cylinder(recipeitem, groups, images, desc_cylinder)
         technic.cnc.register_cylinder_horizontal(recipeitem, groups, images, desc_cylinder_horizontal)
         technic.cnc.register_sphere(recipeitem, groups, images, desc_sphere)
         technic.cnc.register_element_straight(recipeitem, groups, images, desc_element_straight)
         technic.cnc.register_element_edge(recipeitem, groups, images, desc_element_edge)
         technic.cnc.register_element_t(recipeitem, groups, images, desc_element_t)
         technic.cnc.register_element_cross(recipeitem, groups, images, desc_element_cross)
         technic.cnc.register_element_end(recipeitem, groups, images, desc_element_end)
end

-- REGISTER STICKS: noncubic.register_xyz(recipeitem, groups, images, desc_element_xyz)
------------------------------------------------------------------------------------------------------------
function technic.cnc.register_stick_etc(recipeitem, groups, images, desc_stick)
         technic.cnc.register_stick(recipeitem, groups, images, desc_stick)
end

function technic.cnc.register_elements(recipeitem, groups, images, desc_element_straight_double, desc_element_edge_double, desc_element_t_double, desc_element_cross_double, desc_element_end_double)
         technic.cnc.register_element_straight_double(recipeitem, groups, images, desc_element_straight_double)
         technic.cnc.register_element_edge_double(recipeitem, groups, images, desc_element_edge_double)
         technic.cnc.register_element_t_double(recipeitem, groups, images, desc_element_t_double)
         technic.cnc.register_element_cross_double(recipeitem, groups, images, desc_element_cross_double)
         technic.cnc.register_element_end_double(recipeitem, groups, images, desc_element_end_double)
end

