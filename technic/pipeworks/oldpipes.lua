-- This file is basically most of the old init.lua and only supplies the
-- old nodes created by the previous verison of Pipeworks.
--
-- License: WTFPL
--

local nodenames = {
	"vertical",
	"horizontal",
	"junction_xy",
	"junction_xz",
	"bend_xy_down",
	"bend_xy_up",
	"bend_xz",
	"crossing_xz",
	"crossing_xy",
	"crossing_xyz",
	"pipe_segment",
	"cap_neg_x",
	"cap_pos_x",
	"cap_neg_y",
	"cap_pos_y",
	"cap_neg_z",
	"cap_pos_z"
}

local descriptions = {
	"vertical",
	"horizontal",
	"junction between X and Y axes",
	"junction between X and Z axes",
	"downward bend between X and Y axes",
	"upward bend between X and Y axes",
	"bend between X/Z axes",
	"4-way crossing between X and Z axes",
	"4-way crossing between X/Z and Y axes",
	"6-way crossing",
	"basic segment",
	"capped, negative X half only",
	"capped, positive X half only",
	"capped, negative Y half only",
	"capped, positive Y half only",
	"capped, negative Z half only",
	"capped, positive Z half only"
}

local nodeimages = {
	{"pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_plain.png",
	 "pipeworks_plain.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png"},

	{"pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_plain.png",
	 "pipeworks_plain.png"},

	{"pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_plain.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png"},

	{"pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_plain.png"},

	{"pipeworks_plain.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_plain.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png"},

	{"pipeworks_pipe_end.png",
	 "pipeworks_plain.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_plain.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png"},

	{"pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_plain.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_plain.png"},

	{"pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png"},

	{"pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png"},

	{"pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png"},

-- horizontal short segment

	{"pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_plain.png",
	 "pipeworks_plain.png"},

-- capped 

	{"pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png"},

	{"pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png"},

	{"pipeworks_windowed_XXXXX.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png"},

	{"pipeworks_pipe_end.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png"},

	{"pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_pipe_end.png"},

	{"pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_windowed_XXXXX.png",
	 "pipeworks_pipe_end.png",
	 "pipeworks_windowed_XXXXX.png"},
}

local selectionboxes = {
	{ -0.15, -0.5, -0.15, 0.15,  0.5, 0.15 },
	{ -0.5, -0.15, -0.15, 0.5, 0.15, 0.15 },
	{ -0.15, -0.5, -0.15, 0.5, 0.5, 0.15 },
	{ -0.5, -0.15, -0.15, 0.5, 0.15, 0.5 },
	{ -0.15, -0.5, -0.15, 0.5, 0.15, 0.15 },
	{ -0.15, -0.15, -0.15, 0.5, 0.5, 0.15 },
	{ -0.15, -0.15, -0.15, 0.5, 0.15, 0.5 },
	{ -0.5, -0.15, -0.5, 0.5, 0.15, 0.5 },
	{ -0.5, -0.5, -0.15, 0.5, 0.5, 0.15 },
	{ -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },
	{ -0.3, -0.15, -0.15, 0.3, 0.15, 0.15 },
	{ -0.5, -0.15, -0.15, 0, 0.15, 0.15 },
	{ 0, -0.15, -0.15, 0.5, 0.15, 0.15 },
	{ -0.15, -0.5, -0.15, 0.15, 0, 0.15 },
	{ -0.15, 0, -0.15, 0.15, 0.5, 0.15 },
	{ -0.15, -0.15, -0.5, 0.15, 0.15, 0 },
	{ -0.15, -0.15, 0, 0.15, 0.15, 0.5 },
}

local nodeboxes = {
	{{ -0.15, -0.5 , -0.15, 0.15, -0.45, 0.15 },	-- vertical
	 { -0.1 , -0.45, -0.1 , 0.1 ,  0.45, 0.1  },
	 { -0.15,  0.45, -0.15, 0.15,  0.5 , 0.15 }},

	{{ -0.5 , -0.15, -0.15, -0.45, 0.15, 0.15 },	-- horizontal
	 { -0.45, -0.1 , -0.1 ,  0.45, 0.1 , 0.1  },
	 {  0.45, -0.15, -0.15,  0.5 , 0.15, 0.15 }},

	{{ -0.15, -0.5 , -0.15,  0.15, -0.45, 0.15 },	-- vertical with X/Z junction
	 { -0.1 , -0.45, -0.1 ,  0.1 ,  0.45, 0.1  },
	 { -0.15,  0.45, -0.15,  0.15,  0.5 , 0.15 },	
	 {  0.1 , -0.1 , -0.1 ,  0.45,  0.1 , 0.1  },
	 {  0.45, -0.15, -0.15,  0.5 ,  0.15, 0.15 }},

	{{ -0.15, -0.15,  0.45,  0.15, 0.15, 0.5  },	-- horizontal with X/Z junction
	 { -0.1 , -0.1 ,  0.1 ,  0.1 , 0.1 , 0.45 },
	 { -0.5 , -0.15, -0.15, -0.45, 0.15, 0.15 },
	 { -0.45, -0.1 , -0.1 ,  0.45, 0.1 , 0.1  },
	 {  0.45, -0.15, -0.15,  0.5 , 0.15, 0.15 }},

	{{ -0.15, -0.5 , -0.15,  0.15, -0.45, 0.15 },	-- bend down from X/Z to Y axis
	 { -0.1 , -0.45, -0.1 ,  0.1 ,  0.1 , 0.1  },
	 { -0.1 , -0.1 , -0.1 ,  0.45,  0.1 , 0.1  },
	 {  0.45, -0.15, -0.15,  0.5 ,  0.15, 0.15 }},

	{{ -0.15, 0.45 , -0.15, 0.15,  0.5, 0.15 },	-- bend up from X/Z to Y axis
	 { -0.1 , -0.1 , -0.1 , 0.1 , 0.45, 0.1  },
	 { -0.1 , -0.1 , -0.1 , 0.45, 0.1 , 0.1  },
	 {  0.45, -0.15, -0.15, 0.5 , 0.15, 0.15 }},

	{{ -0.15, -0.15,  0.45,  0.15, 0.15, 0.5  },	-- bend between X and Z axes
	 { -0.1 , -0.1 ,  0.1 ,  0.1 , 0.1 , 0.45 },
	 { -0.1 , -0.1 , -0.1 ,  0.45, 0.1 , 0.1  },
	 {  0.45, -0.15, -0.15,  0.5 , 0.15, 0.15 }},

	{{ -0.5 , -0.15, -0.15, -0.45, 0.15, 0.15 },	-- 4-way crossing between X and Z axes
	 { -0.45, -0.1 , -0.1 ,  0.45, 0.1 , 0.1  },
	 {  0.45, -0.15, -0.15,  0.5 , 0.15, 0.15 },
	 { -0.15, -0.15, -0.5 ,  0.15, 0.15, -0.45 },
	 { -0.1 , -0.1 , -0.45,  0.1 , 0.1 ,  0.45 },
	 { -0.15, -0.15,  0.45,  0.15, 0.15,  0.5  }},

	{{ -0.15, -0.5 , -0.15, 0.15, -0.45, 0.15 },	-- 4-way crossing between X/Z and Y axes
	 { -0.1 , -0.45, -0.1 , 0.1 ,  0.45, 0.1  },
	 { -0.15,  0.45, -0.15, 0.15,  0.5 , 0.15 },
	 { -0.5 , -0.15, -0.15, -0.45, 0.15, 0.15 },
	 { -0.45, -0.1 , -0.1 ,  0.45, 0.1 , 0.1  },
	 {  0.45, -0.15, -0.15,  0.5 , 0.15, 0.15 }},

	{{ -0.5 , -0.15, -0.15, -0.45, 0.15, 0.15 },	-- 6-way crossing (all 3 axes)
	 { -0.45, -0.1 , -0.1 ,  0.45, 0.1 , 0.1  },
	 {  0.45, -0.15, -0.15,  0.5 , 0.15, 0.15 },
	 { -0.15, -0.15, -0.5 ,  0.15, 0.15, -0.45 },
	 { -0.1 , -0.1 , -0.45,  0.1 , 0.1 ,  0.45 },
	 { -0.15, -0.15,  0.45,  0.15, 0.15,  0.5  },
	 { -0.15, -0.5 , -0.15, 0.15, -0.45, 0.15 },
	 { -0.1 , -0.45, -0.1 , 0.1 ,  0.45, 0.1  },
	 { -0.15,  0.45, -0.15, 0.15,  0.5 , 0.15 }},

	{{ -0.3 , -0.15, -0.15, -0.25, 0.15, 0.15 },	-- main center segment
	 { -0.25, -0.1 , -0.1 ,  0.25, 0.1 , 0.1  },
	 {  0.25, -0.15, -0.15,  0.3 , 0.15, 0.15 }},

	{{ -0.5,  -0.15, -0.15, -0.45, 0.15, 0.15 },	-- anchored at -X
	 { -0.45, -0.1,  -0.1,  -0.2,  0.1,  0.1  },
	 { -0.2,  -0.15, -0.15, -0.15, 0.15, 0.15 },
	 { -0.15, -0.12, -0.12, -0.1,  0.12, 0.12 },
	 { -0.1,  -0.08, -0.08, -0.05, 0.08, 0.08 },
	 { -0.05, -0.04, -0.04,  0,    0.04, 0.04 }},

	{{  0.45, -0.15, -0.15, 0.5,  0.15, 0.15 },	-- anchored at +X
	 {  0.2,  -0.1,  -0.1,  0.45, 0.1,  0.1  },
	 {  0.15, -0.15, -0.15, 0.2,  0.15, 0.15 },
	 {  0.1,  -0.12, -0.12, 0.15, 0.12, 0.12 },
	 {  0.05, -0.08, -0.08, 0.1,  0.08, 0.08 },
	 {  0,    -0.04, -0.04, 0.05, 0.04, 0.04 }},

	{{ -0.15,  -0.5, -0.15,  0.15, -0.45, 0.15 },	-- anchored at -Y
	 { -0.1,  -0.45, -0.1,   0.1,  -0.2,  0.1  },
	 { -0.15,  -0.2, -0.15,  0.15, -0.15, 0.15 },
	 { -0.12, -0.15, -0.12,  0.12, -0.1,  0.12 },
	 { -0.08, -0.1,  -0.08,  0.08, -0.05, 0.08 },
	 { -0.04, -0.05, -0.04,  0.04,  0,    0.04 }},

	{{ -0.15,  0.45, -0.15, 0.15, 0.5,  0.15 },	-- anchored at +Y
	 { -0.1,   0.2,  -0.1,  0.1,  0.45, 0.1  },
	 { -0.15,  0.15, -0.15, 0.15, 0.2,  0.15 },
	 { -0.12,  0.1,  -0.12, 0.12, 0.15, 0.12 },
	 { -0.08,  0.05, -0.08, 0.08, 0.1,  0.08 } ,
	 { -0.04,  0,    -0.04, 0.04, 0.05, 0.04 }},

	{{ -0.15, -0.15, -0.5,  0.15, 0.15, -0.45 },	-- anchored at -Z
	 { -0.1,  -0.1,  -0.45, 0.1,  0.1,  -0.2  },
	 { -0.15, -0.15, -0.2,  0.15, 0.15, -0.15 },
	 { -0.12, -0.12, -0.15, 0.12, 0.12, -0.1  },
	 { -0.08, -0.08, -0.1,  0.08, 0.08, -0.05 },
	 { -0.04, -0.04, -0.05, 0.04, 0.04,  0    }},

	{{ -0.15, -0.15,  0.45, 0.15, 0.15, 0.5  },	-- anchored at +Z
	 { -0.1,  -0.1,   0.2,  0.1,  0.1,  0.45 },
	 { -0.15, -0.15,  0.15, 0.15, 0.15, 0.2  },
	 { -0.12, -0.12,  0.1,  0.12, 0.12, 0.15 },
	 { -0.08, -0.08,  0.05, 0.08, 0.08, 0.1  },
	 { -0.04, -0.04,  0,    0.04, 0.04, 0.05 }},
}

function fix_image_names(node, replacement)
	outtable={}
	for i in ipairs(nodeimages[node]) do
		outtable[i]=string.gsub(nodeimages[node][i], "_XXXXX", replacement)
	end

	return outtable
end

-- Now define the actual nodes

for node in ipairs(nodenames) do

	if node ~= 2 then
		pgroups = {snappy=3, pipe=1, not_in_creative_inventory=1}
	else
		pgroups = {snappy=3, pipe=1}
	end

	minetest.register_node("pipeworks:"..nodenames[node], {
		description = "Empty Pipe ("..descriptions[node]..")",
		drawtype = "nodebox",
		tiles = fix_image_names(node, "_empty"),
		paramtype = "light",
		paramtype2 = "facedir",
		selection_box = {
              		type = "fixed",
			fixed = selectionboxes[node],
		},
		node_box = {
			type = "fixed",
			fixed = nodeboxes[node]
		},
		groups = pgroups,
		sounds = default.node_sound_wood_defaults(),
		walkable = true,
		stack_max = 99,
		drop = "pipeworks:pipe"
	})

	minetest.register_node("pipeworks:"..nodenames[node].."_loaded", {
		description = "Loaded Pipe ("..descriptions[node]..")",
		drawtype = "nodebox",
		tiles = fix_image_names(node, "_loaded"),
		paramtype = "light",
		paramtype2 = "facedir",
		selection_box = {
              		type = "fixed",
			fixed = selectionboxes[node],
		},	
		node_box = {
			type = "fixed",
			fixed = nodeboxes[node]
		},
		groups = {snappy=3, pipe=1, not_in_creative_inventory=1},
		sounds = default.node_sound_wood_defaults(),
		walkable = true,
		stack_max = 99,
		drop = "pipeworks:pipe"
	})
end

