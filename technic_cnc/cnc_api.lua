-- API for the technic CNC machine
-- Again code is adapted from the NonCubic Blocks MOD v1.4 by yves_de_beck

local S = technic_cnc.getter
local ALPHA_CLIP = minetest.features.use_texture_alpha_string_modes and "clip" or true

-- REGISTER NONCUBIC FORMS, CREATE MODELS AND RECIPES:
------------------------------------------------------

-- Define slope boxes for the various nodes
--[[
Additional keys after registration:
	programs[program.suffix] = program

Additional fields after registration:
	program.short_name = (trimmed suffix)
	program.full_counterpart = suffix (optional, for full/half variants)
	program.half_counterpart = suffix (optional, for full/half variants)
]]
-------------------------------------------
technic_cnc.programs = {
	{ suffix  = "technic_cnc_stick",
		model = {-0.15, -0.5, -0.15, 0.15, 0.5, 0.15},
		desc  = S("Stick"),
		output = 8
	},

	{ suffix  = "technic_cnc_element_end_double",
		model = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.5},
		desc  = S("Element End Double"),
		output = 2
	},

	{ suffix  = "technic_cnc_element_cross_double",
		model = {
			{0.3, -0.5, -0.3, 0.5, 0.5, 0.3},
			{-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
			{-0.5, -0.5, -0.3, -0.3, 0.5, 0.3}},
		desc  = S("Element Cross Double"),
		output = 1
	},

	{ suffix  = "technic_cnc_element_t_double",
		model = {
			{-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
			{-0.5, -0.5, -0.3, -0.3, 0.5, 0.3},
			{0.3, -0.5, -0.3, 0.5, 0.5, 0.3}},
		desc  = S("Element T Double"),
		output = 1
	},

	{ suffix  = "technic_cnc_element_edge_double",
		model = {
			{-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
			{-0.5, -0.5, -0.3, -0.3, 0.5, 0.3}},
		desc  = S("Element Edge Double"),
		output = 2
	},

	{ suffix  = "technic_cnc_element_straight_double",
		model = {-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
		desc  = S("Element Straight Double"),
		output = 2
	},

	{ suffix  = "technic_cnc_element_end",
		model = {-0.3, -0.5, -0.3, 0.3, 0, 0.5},
		desc  = S("Element End"),
		output = nil -- calculated
	},

	{ suffix  = "technic_cnc_element_cross",
		model = {
			{0.3, -0.5, -0.3, 0.5, 0, 0.3},
			{-0.3, -0.5, -0.5, 0.3, 0, 0.5},
			{-0.5, -0.5, -0.3, -0.3, 0, 0.3}},
		desc  = S("Element Cross"),
		output = nil -- calculated
	},

	{ suffix  = "technic_cnc_element_t",
		model = {
			{-0.3, -0.5, -0.5, 0.3, 0, 0.3},
			{-0.5, -0.5, -0.3, -0.3, 0, 0.3},
			{0.3, -0.5, -0.3, 0.5, 0, 0.3}},
		desc  = S("Element T"),
		output = nil -- calculated
	},

	{ suffix  = "technic_cnc_element_edge",
		model = {
			{-0.3, -0.5, -0.5, 0.3, 0, 0.3},
			{-0.5, -0.5, -0.3, -0.3, 0, 0.3}},
		desc  = S("Element Edge"),
		output = nil -- calculated
	},

	{ suffix  = "technic_cnc_element_straight",
		model = {-0.3, -0.5, -0.5, 0.3, 0, 0.5},
		desc  = S("Element Straight"),
		output = nil -- calculated
	},

	{ suffix  = "technic_cnc_oblate_spheroid",
		model = "technic_cnc_oblate_spheroid.obj",
		desc  = S("Oblate spheroid"),
		cbox  = {
			type = "fixed",
			fixed = {
				{ -6/16,  4/16, -6/16, 6/16,  8/16, 6/16 },
				{ -8/16, -4/16, -8/16, 8/16,  4/16, 8/16 },
				{ -6/16, -8/16, -6/16, 6/16, -4/16, 6/16 }
			}
		},
		output = 1
	},

	{ suffix  = "technic_cnc_sphere",
		model = "technic_cnc_sphere.obj",
		desc  = S("Sphere"),
		output = 1
	},

	{ suffix  = "technic_cnc_cylinder_horizontal",
		model = "technic_cnc_cylinder_horizontal.obj",
		desc  = S("Horizontal Cylinder"),
		output = 2
	},

	{ suffix  = "technic_cnc_cylinder",
		model = "technic_cnc_cylinder.obj",
		desc  = S("Cylinder"),
		output = 2
	},

	{ suffix  = "technic_cnc_twocurvededge",
		model = "technic_cnc_two_curved_edge.obj",
		desc  = S("Two Curved Edge/Corner Block"),
		output = 1
	},

	{ suffix  = "technic_cnc_onecurvededge",
		model = "technic_cnc_one_curved_edge.obj",
		desc  = S("One Curved Edge Block"),
		output = 1
	},

	{ suffix  = "technic_cnc_spike",
		model = "technic_cnc_pyramid_spike.obj",
		desc  = S("Spike"),
		cbox    = {
			type = "fixed",
			fixed = {
				{ -2/16,  4/16, -2/16, 2/16,  8/16, 2/16 },
				{ -4/16,     0, -4/16, 4/16,  4/16, 4/16 },
				{ -6/16, -4/16, -6/16, 6/16,     0, 6/16 },
				{ -8/16, -8/16, -8/16, 8/16, -4/16, 8/16 }
			}
		},
		output = 1
	},

	{ suffix  = "technic_cnc_pyramid",
		model = "technic_cnc_pyramid.obj",
		desc  = S("Pyramid"),
		cbox  = {
			type = "fixed",
			fixed = {
				{ -2/16, -2/16, -2/16, 2/16,     0, 2/16 },
				{ -4/16, -4/16, -4/16, 4/16, -2/16, 4/16 },
				{ -6/16, -6/16, -6/16, 6/16, -4/16, 6/16 },
				{ -8/16, -8/16, -8/16, 8/16, -6/16, 8/16 }
			}
		},
		output = 2
	},

	{ suffix  = "technic_cnc_slope_inner_edge_upsdown",
		model = "technic_cnc_innercorner_upsdown.obj",
		desc  = S("Slope Upside Down Inner Edge/Corner"),
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
		},
		output = 1
	},

	{ suffix  = "technic_cnc_slope_edge_upsdown",
		model = "technic_cnc_outercorner_upsdown.obj",
		desc  = S("Slope Upside Down Outer Edge/Corner"),
		cbox  = {
			type = "fixed",
			fixed = {
				{ -8/16,  8/16, -8/16, 8/16,  4/16, 8/16 },
				{ -4/16,  4/16, -4/16, 8/16,     0, 8/16 },
				{     0,     0,     0, 8/16, -4/16, 8/16 },
				{  4/16, -4/16,  4/16, 8/16, -8/16, 8/16 }
			}
		},
		output = 1
	},

	{ suffix  = "technic_cnc_slope_inner_edge",
		model = "technic_cnc_innercorner.obj",
		desc  = S("Slope Inner Edge/Corner"),
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
		},
		output = 1
	},

	{ suffix  = "technic_cnc_slope_edge",
		model = "technic_cnc_outercorner.obj",
		desc  = S("Slope Outer Edge/Corner"),
		cbox  = {
			type = "fixed",
			fixed = {
				{  4/16,  4/16,  4/16, 8/16,  8/16, 8/16 },
				{     0,     0,     0, 8/16,  4/16, 8/16 },
				{ -4/16, -4/16, -4/16, 8/16,     0, 8/16 },
				{ -8/16, -8/16, -8/16, 8/16, -4/16, 8/16 }
			}
		},
		output = 1
	},

	{ suffix  = "technic_cnc_slope_upsdown",
		model = "technic_cnc_slope_upsdown.obj",
		desc  = S("Slope Upside Down"),
		cbox  = {
			type = "fixed",
			fixed = {
				{ -8/16,  8/16, -8/16, 8/16,  4/16, 8/16 },
				{ -8/16,  4/16, -4/16, 8/16,     0, 8/16 },
				{ -8/16,     0,     0, 8/16, -4/16, 8/16 },
				{ -8/16, -4/16,  4/16, 8/16, -8/16, 8/16 }
			}
		},
		output = 1
	},

	{ suffix  = "technic_cnc_slope_lying",
		model = "technic_cnc_slope_horizontal.obj",
		desc  = S("Slope Lying"),
		cbox  = {
			type = "fixed",
			fixed = {
				{  4/16, -8/16,  4/16,  8/16, 8/16, 8/16 },
				{     0, -8/16,     0,  4/16, 8/16, 8/16 },
				{ -4/16, -8/16, -4/16,     0, 8/16, 8/16 },
				{ -8/16, -8/16, -8/16, -4/16, 8/16, 8/16 }
			}
		},
		output = 2
	},

	{ suffix  = "technic_cnc_slope",
		model = "technic_cnc_slope.obj",
		desc  = S("Slope"),
		cbox  = {
			type = "fixed",
			fixed = {
				{ -8/16,  4/16,  4/16, 8/16,  8/16, 8/16 },
				{ -8/16,     0,     0, 8/16,  4/16, 8/16 },
				{ -8/16, -4/16, -4/16, 8/16,     0, 8/16 },
				{ -8/16, -8/16, -8/16, 8/16, -4/16, 8/16 }
			}
		},
		output = 2
	},

}

technic_cnc._populate_shortcuts = function()
	-- Program quick access by string key
	for _, data in ipairs(technic_cnc.programs) do
		technic_cnc.programs[data.suffix] = data
		data.short_name = assert(data.suffix:match("technic_cnc_(%S+)"))
	end

	-- Detect half/full counterparts
	for k, data in pairs(technic_cnc.programs) do
		if type(k) == "string" then
			local full = technic_cnc.programs[k .. "_double"]
			if full then
				full.half_counterpart = k
				data.full_counterpart = k .. "_double"
				data.output = full.output * 2

				--print("populate", k)
			end
		end
	end

	-- Final checks
	for _, data in ipairs(technic_cnc.programs) do
		assert(type(data.output) == "number", data.suffix)
		assert(type(data.short_name) == "string", data.suffix)
	end
end

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
		use_texture_alpha = ALPHA_CLIP,
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
			    groups, images, description.." "..data.desc, data.cbox, data.sbox)
		end
	end
end

