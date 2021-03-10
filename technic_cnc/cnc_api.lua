-- API for the technic CNC machine
-- Again code is adapted from the NonCubic Blocks MOD v1.4 by yves_de_beck

local S = minetest.get_translator("technic_cnc")

-- REGISTER NONCUBIC FORMS, CREATE MODELS AND RECIPES:
------------------------------------------------------

-- Define slope boxes for the various nodes
-------------------------------------------
technic_cnc.programs = {
	{ suffix  = "technic_cnc_stick",
		model = {-0.15, -0.5, -0.15, 0.15, 0.5, 0.15},
		desc  = function(p1) return S("@1 Stick", p1) end,
	},

	{ suffix  = "technic_cnc_element_end_double",
		model = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.5},
		desc  = function(p1) return S("@1 Element End Double", p1) end,
	},

	{ suffix  = "technic_cnc_element_cross_double",
		model = {
			{0.3, -0.5, -0.3, 0.5, 0.5, 0.3},
			{-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
			{-0.5, -0.5, -0.3, -0.3, 0.5, 0.3}},
		desc  = function(p1) return S("@1 Element Cross Double", p1) end,
	},

	{ suffix  = "technic_cnc_element_t_double",
		model = {
			{-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
			{-0.5, -0.5, -0.3, -0.3, 0.5, 0.3},
			{0.3, -0.5, -0.3, 0.5, 0.5, 0.3}},
		desc  = function(p1) return S("@1 Element T Double", p1) end,
	},

	{ suffix  = "technic_cnc_element_edge_double",
		model = {
			{-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
			{-0.5, -0.5, -0.3, -0.3, 0.5, 0.3}},
		desc  = function(p1) return S("@1 Element Edge Double", p1) end,
	},

	{ suffix  = "technic_cnc_element_straight_double",
		model = {-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
		desc  = function(p1) return S("@1 Element Straight Double", p1) end,
	},

	{ suffix  = "technic_cnc_element_end",
		model = {-0.3, -0.5, -0.3, 0.3, 0, 0.5},
		desc  = function(p1) return S("@1 Element End", p1) end,
	},

	{ suffix  = "technic_cnc_element_cross",
		model = {
			{0.3, -0.5, -0.3, 0.5, 0, 0.3},
			{-0.3, -0.5, -0.5, 0.3, 0, 0.5},
			{-0.5, -0.5, -0.3, -0.3, 0, 0.3}},
		desc  = function(p1) return S("@1 Element Cross", p1) end,
	},

	{ suffix  = "technic_cnc_element_t",
		model = {
			{-0.3, -0.5, -0.5, 0.3, 0, 0.3},
			{-0.5, -0.5, -0.3, -0.3, 0, 0.3},
			{0.3, -0.5, -0.3, 0.5, 0, 0.3}},
		desc  = function(p1) return S("@1 Element T", p1) end,
	},

	{ suffix  = "technic_cnc_element_edge",
		model = {
			{-0.3, -0.5, -0.5, 0.3, 0, 0.3},
			{-0.5, -0.5, -0.3, -0.3, 0, 0.3}},
		desc  = function(p1) return S("@1 Element Edge", p1) end,
	},

	{ suffix  = "technic_cnc_element_straight",
		model = {-0.3, -0.5, -0.5, 0.3, 0, 0.5},
		desc  = function(p1) return S("@1 Element Straight", p1) end,
	},

	{ suffix  = "technic_cnc_oblate_spheroid",
		model = "technic_cnc_oblate_spheroid.obj",
		desc  = function(p1) return S("@1 Oblate spheroid", p1) end,
		cbox  = {
			type = "fixed",
			fixed = {
				{ -6/16,  4/16, -6/16, 6/16,  8/16, 6/16 },
				{ -8/16, -4/16, -8/16, 8/16,  4/16, 8/16 },
				{ -6/16, -8/16, -6/16, 6/16, -4/16, 6/16 }
			}
		}
	},

	{ suffix  = "technic_cnc_sphere",
		model = "technic_cnc_sphere.obj",
		desc  = function(p1) return S("@1 Sphere", p1) end,
	},

	{ suffix  = "technic_cnc_cylinder_horizontal",
		model = "technic_cnc_cylinder_horizontal.obj",
		desc  = function(p1) return S("@1 Horizontal Cylinder", p1) end,
	},

	{ suffix  = "technic_cnc_cylinder",
		model = "technic_cnc_cylinder.obj",
		desc  = function(p1) return S("@1 Cylinder", p1) end,
	},

	{ suffix  = "technic_cnc_twocurvededge",
		model = "technic_cnc_two_curved_edge.obj",
		desc  = function(p1) return S("@1 Two Curved Edge/Corner Block", p1) end,
	},

	{ suffix  = "technic_cnc_onecurvededge",
		model = "technic_cnc_one_curved_edge.obj",
		desc  = function(p1) return S("@1 One Curved Edge Block", p1) end,
	},

	{ suffix  = "technic_cnc_spike",
		model = "technic_cnc_pyramid_spike.obj",
		desc  = function(p1) return S("@1 Spike", p1) end,
		cbox    = {
			type = "fixed",
			fixed = {
				{ -2/16,  4/16, -2/16, 2/16,  8/16, 2/16 },
				{ -4/16,     0, -4/16, 4/16,  4/16, 4/16 },
				{ -6/16, -4/16, -6/16, 6/16,     0, 6/16 },
				{ -8/16, -8/16, -8/16, 8/16, -4/16, 8/16 }
			}
		}
	},

	{ suffix  = "technic_cnc_pyramid",
		model = "technic_cnc_pyramid.obj",
		desc  = function(p1) return S("@1 Pyramid", p1) end,
		cbox  = {
			type = "fixed",
			fixed = {
				{ -2/16, -2/16, -2/16, 2/16,     0, 2/16 },
				{ -4/16, -4/16, -4/16, 4/16, -2/16, 4/16 },
				{ -6/16, -6/16, -6/16, 6/16, -4/16, 6/16 },
				{ -8/16, -8/16, -8/16, 8/16, -6/16, 8/16 }
			}
		}
	},

	{ suffix  = "technic_cnc_slope_inner_edge_upsdown",
		model = "technic_cnc_innercorner_upsdown.obj",
		desc  = function(p1) return S("@1 Slope Upside Down Inner Edge/Corner", p1) end,
		sbox  = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 }
		},
		cbox  = {
			type = "fixed",
			fixed = {
				{  0.25, -0.25, -0.5,  0.5, -0.5,   0.5  },
				{ -0.5,  -0.25,  0.25, 0.5, -0.5,   0.5  },
				{  0,     0,    -0.5,  0.5, -0.25,  0.5  },
				{ -0.5,   0,     0,    0.5, -0.25,  0.5  },
				{ -0.25,  0.25, -0.5,  0.5,  0,    -0.25 },
				{ -0.5,   0.25, -0.25, 0.5,  0,     0.5  },
				{ -0.5,   0.5,  -0.5,  0.5,  0.25,  0.5  }
			}
		}
	},

	{ suffix  = "technic_cnc_slope_edge_upsdown",
		model = "technic_cnc_outercorner_upsdown.obj",
		desc  = function(p1) return S("@1 Slope Upside Down Outer Edge/Corner", p1) end,
		cbox  = {
			type = "fixed",
			fixed = {
				{ -8/16,  8/16, -8/16, 8/16,  4/16, 8/16 },
				{ -4/16,  4/16, -4/16, 8/16,     0, 8/16 },
				{     0,     0,     0, 8/16, -4/16, 8/16 },
				{  4/16, -4/16,  4/16, 8/16, -8/16, 8/16 }
			}
		}
	},

	{ suffix  = "technic_cnc_slope_inner_edge",
		model = "technic_cnc_innercorner.obj",
		desc  = function(p1) return S("@1 Slope Inner Edge/Corner", p1) end,
		sbox  = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 }
		},
		cbox  = {
			type = "fixed",
			fixed = {
				{ -0.5,  -0.5,  -0.5,  0.5, -0.25,  0.5  },
				{ -0.5,  -0.25, -0.25, 0.5,  0,     0.5  },
				{ -0.25, -0.25, -0.5,  0.5,  0,    -0.25 },
				{ -0.5,   0,     0,    0.5,  0.25,  0.5  },
				{  0,     0,    -0.5,  0.5,  0.25,  0.5  },
				{ -0.5,   0.25,  0.25, 0.5,  0.5,   0.5  },
				{  0.25,  0.25, -0.5,  0.5,  0.5,   0.5  }
			}
		}
	},

	{ suffix  = "technic_cnc_slope_edge",
		model = "technic_cnc_outercorner.obj",
		desc  = function(p1) return S("@1 Slope Outer Edge/Corner", p1) end,
		cbox  = {
			type = "fixed",
			fixed = {
				{  4/16,  4/16,  4/16, 8/16,  8/16, 8/16 },
				{     0,     0,     0, 8/16,  4/16, 8/16 },
				{ -4/16, -4/16, -4/16, 8/16,     0, 8/16 },
				{ -8/16, -8/16, -8/16, 8/16, -4/16, 8/16 }
			}
		}
	},

	{ suffix  = "technic_cnc_slope_upsdown",
		model = "technic_cnc_slope_upsdown.obj",
		desc  = function(p1) return S("@1 Slope Upside Down", p1) end,
		cbox  = {
			type = "fixed",
			fixed = {
				{ -8/16,  8/16, -8/16, 8/16,  4/16, 8/16 },
				{ -8/16,  4/16, -4/16, 8/16,     0, 8/16 },
				{ -8/16,     0,     0, 8/16, -4/16, 8/16 },
				{ -8/16, -4/16,  4/16, 8/16, -8/16, 8/16 }
			}
		}
	},

	{ suffix  = "technic_cnc_slope_lying",
		model = "technic_cnc_slope_horizontal.obj",
		desc  = function(p1) return S("@1 Slope Lying", p1) end,
		cbox  = {
			type = "fixed",
			fixed = {
				{  4/16, -8/16,  4/16,  8/16, 8/16, 8/16 },
				{     0, -8/16,     0,  4/16, 8/16, 8/16 },
				{ -4/16, -8/16, -4/16,     0, 8/16, 8/16 },
				{ -8/16, -8/16, -8/16, -4/16, 8/16, 8/16 }
			}
		}
	},

	{ suffix  = "technic_cnc_slope",
		model = "technic_cnc_slope.obj",
		desc  = function(p1) return S("@1 Slope", p1) end,
		cbox  = {
			type = "fixed",
			fixed = {
				{ -8/16,  4/16,  4/16, 8/16,  8/16, 8/16 },
				{ -8/16,     0,     0, 8/16,  4/16, 8/16 },
				{ -8/16, -4/16, -4/16, 8/16,     0, 8/16 },
				{ -8/16, -8/16, -8/16, 8/16, -4/16, 8/16 }
			}
		}
	},

}

-- Allow disabling certain programs for some node. Default is allowing all types for all nodes
technic_cnc.programs_disable = {
	-- ["default:brick"] = {"technic_cnc_stick"}, -- Example: Disallow the stick for brick
	-- ...
	["default:dirt"] = {"technic_cnc_oblate_spheroid", "technic_cnc_slope_upsdown", "technic_cnc_edge",
	                    "technic_cnc_inner_edge", "technic_cnc_slope_edge_upsdown",
	                    "technic_cnc_slope_inner_edge_upsdown", "technic_cnc_stick",
	                    "technic_cnc_cylinder_horizontal"}
}

-- Generic function for registering all the different node types
function technic_cnc.register_program(recipeitem, suffix, model, groups, images, description, cbox, sbox)

	local dtype
	local nodeboxdef
	local meshdef

	if type(model) ~= "string" then -- assume a nodebox if it's a table or function call
		dtype = "nodebox"
		nodeboxdef = {
			type  = "fixed",
			fixed = model
		}
	else
		dtype = "mesh"
		meshdef = model
	end

	if cbox and not sbox then sbox = cbox end

	minetest.register_node(":"..recipeitem.."_"..suffix, {
		description   = description,
		drawtype      = dtype,
		node_box      = nodeboxdef,
		mesh          = meshdef,
		tiles         = images,
		paramtype     = "light",
		paramtype2    = "facedir",
		walkable      = true,
		groups        = groups,
		selection_box = sbox,
		collision_box = cbox
	})
end

-- function to iterate over all the programs the CNC machine knows
function technic_cnc.register_all(recipeitem, groups, images, description)
	for _, data in ipairs(technic_cnc.programs) do
		-- Disable node creation for disabled node types for some material
		local do_register = true
		if technic_cnc.programs_disable[recipeitem] ~= nil then
			for __, disable in ipairs(technic_cnc.programs_disable[recipeitem]) do
				if disable == data.suffix then
					do_register = false
				end
			end
		end
		-- Create the node if it passes the test
		if do_register then
			technic_cnc.register_program(recipeitem, data.suffix, data.model,
			    groups, images, data.desc(description), data.cbox, data.sbox)
		end
	end
end


-- REGISTER NEW TECHNIC_CNC_API's PART 2: technic_cnc..register_element_end(subname, recipeitem, groups, images, desc_element_xyz)
-----------------------------------------------------------------------------------------------------------------------
function technic_cnc.register_slope_edge_etc(recipeitem, groups, images, desc_slope, desc_slope_lying, desc_slope_upsdown, desc_slope_edge, desc_slope_inner_edge, desc_slope_upsdwn_edge, desc_slope_upsdwn_inner_edge, desc_pyramid, desc_spike, desc_onecurvededge, desc_twocurvededge, desc_cylinder, desc_cylinder_horizontal, desc_spheroid, desc_element_straight, desc_element_edge, desc_element_t, desc_element_cross, desc_element_end)

         technic_cnc.register_slope(recipeitem, groups, images, desc_slope)
         technic_cnc.register_slope_lying(recipeitem, groups, images, desc_slope_lying)
         technic_cnc.register_slope_upsdown(recipeitem, groups, images, desc_slope_upsdown)
         technic_cnc.register_slope_edge(recipeitem, groups, images, desc_slope_edge)
         technic_cnc.register_slope_inner_edge(recipeitem, groups, images, desc_slope_inner_edge)
         technic_cnc.register_slope_edge_upsdown(recipeitem, groups, images, desc_slope_upsdwn_edge)
         technic_cnc.register_slope_inner_edge_upsdown(recipeitem, groups, images, desc_slope_upsdwn_inner_edge)
         technic_cnc.register_pyramid(recipeitem, groups, images, desc_pyramid)
         technic_cnc.register_spike(recipeitem, groups, images, desc_spike)
         technic_cnc.register_onecurvededge(recipeitem, groups, images, desc_onecurvededge)
         technic_cnc.register_twocurvededge(recipeitem, groups, images, desc_twocurvededge)
         technic_cnc.register_cylinder(recipeitem, groups, images, desc_cylinder)
         technic_cnc.register_cylinder_horizontal(recipeitem, groups, images, desc_cylinder_horizontal)
         technic_cnc.register_spheroid(recipeitem, groups, images, desc_spheroid)
         technic_cnc.register_element_straight(recipeitem, groups, images, desc_element_straight)
         technic_cnc.register_element_edge(recipeitem, groups, images, desc_element_edge)
         technic_cnc.register_element_t(recipeitem, groups, images, desc_element_t)
         technic_cnc.register_element_cross(recipeitem, groups, images, desc_element_cross)
         technic_cnc.register_element_end(recipeitem, groups, images, desc_element_end)
end

-- REGISTER STICKS: noncubic.register_xyz(recipeitem, groups, images, desc_element_xyz)
------------------------------------------------------------------------------------------------------------
function technic_cnc.register_stick_etc(recipeitem, groups, images, desc_stick)
         technic_cnc.register_stick(recipeitem, groups, images, desc_stick)
end

function technic_cnc.register_elements(recipeitem, groups, images, desc_element_straight_double, desc_element_edge_double, desc_element_t_double, desc_element_cross_double, desc_element_end_double)
         technic_cnc.register_element_straight_double(recipeitem, groups, images, desc_element_straight_double)
         technic_cnc.register_element_edge_double(recipeitem, groups, images, desc_element_edge_double)
         technic_cnc.register_element_t_double(recipeitem, groups, images, desc_element_t_double)
         technic_cnc.register_element_cross_double(recipeitem, groups, images, desc_element_cross_double)
         technic_cnc.register_element_end_double(recipeitem, groups, images, desc_element_end_double)
end

