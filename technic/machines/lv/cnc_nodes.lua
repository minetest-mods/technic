-- REGISTER MATERIALS AND PROPERTIES FOR NONCUBIC ELEMENTS:
-----------------------------------------------------------
-- DIRT
-------
technic_cnc_api.register_all("default:dirt",
                {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
                {"default_grass.png", "default_dirt.png", "default_grass.png"},
                "Dirt")
technic_cnc_api.cnc_programs_disable["default:dirt"] = {"technic_cnc_sphere", "technic_cnc_slope_upsdown",
							"technic_cnc_edge",   "technic_cnc_inner_edge",
							"technic_cnc_slope_edge_upsdown", "technic_cnc_slope_inner_edge_upsdown",
							"technic_cnc_stick", "technic_cnc_cylinder_horizontal"}

-- TREE
-------
technic_cnc_api.register_all("default:tree",
                {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
                {"default_tree.png"},
                "Wooden")

-- WOOD
-------
technic_cnc_api.register_all("default:wood",
                {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
                {"default_wood.png"},
                "Wooden")
-- STONE
--------
technic_cnc_api.register_all("default:stone",
                {cracky=3,not_in_creative_inventory=1},
                {"default_stone.png"},
                "Stone")
-- COBBLE
---------
technic_cnc_api.register_all("default:cobble",
                {cracky=3,not_in_creative_inventory=1},
                {"default_cobble.png"},
                "Cobble")
-- BRICK
--------
technic_cnc_api.register_all("default:brick",
                {cracky=3,not_in_creative_inventory=1},
                {"default_brick.png"},
                "Brick")

-- SANDSTONE
------------
technic_cnc_api.register_all("default:sandstone",
                {crumbly=2,cracky=2,not_in_creative_inventory=1},
                {"default_sandstone.png"},
                "Sandstone")

-- LEAVES
---------
technic_cnc_api.register_all("default:leaves",
                {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
                {"default_leaves.png"},
                "Leaves")
-- TREE
-------
technic_cnc_api.register_all("default:tree",
                {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1,not_in_creative_inventory=1},
                {"default_tree.png"},
                "Tree")
-- STEEL
--------
technic_cnc_api.register_all("default:steel",
                {snappy=1,bendy=2,cracky=1,melty=2,level=2,not_in_creative_inventory=1},
                {"default_steel_block.png"},
                "Steel")
