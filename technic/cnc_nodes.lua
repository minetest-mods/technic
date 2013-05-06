-- REGISTER MATERIALS AND PROPERTIES FOR NONCUBIC ELEMENTS:
-----------------------------------------------------------

-- WOOD
-------
technic_cnc_api.register_slope_edge_etc("default:wood",
                {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
                {"default_wood.png"},
                "Wooden Slope",
                "Wooden Slope Lying",
                "Wooden Slope Upside Down",
                "Wooden Slope Edge",
                "Wooden Slope Inner Edge",
                "Wooden Slope Upside Down Edge",
                "Wooden Slope Upside Down Inner Edge",
                "Wooden Pyramid",
                "Wooden Spike",
                "Wooden One Curved Edge Block",
                "Wooden Two Curved Edge Block",
                "Wooden Cylinder",
                "Wooden Cylinder Horizontal",
                "Wooden Sphere",
                "Wooden Element Straight",
                "Wooden Element Edge",
                "Wooden Element T",
                "Wooden Element Cross",
                "Wooden Element End")
-- STONE
--------
technic_cnc_api.register_slope_edge_etc("default:stone",
                {cracky=3,not_in_creative_inventory=1},
                {"default_stone.png"},
                "Stone Slope",
                "Stone Slope Lying",
                "Stone Slope Upside Down",
                "Stone Slope Edge",
                "Stone Slope Inner Edge",
                "Stone Slope Upside Down Edge",
                "Stone Slope Upside Down Inner Edge",
                "Stone Pyramid",
                "Stone Spike",
                "Stone One Curved Edge Block",
                "Stone Two Curved Edge Block",
                "Stone Cylinder",
                "Stote Cylinder Horizontal",
                "Stone Sphere",
                "Stone Element Straight",
                "Stone Element Edge",
                "Stone Element T",
                "Stone Element Cross",
                "Stone Element End")
-- COBBLE
---------
technic_cnc_api.register_slope_edge_etc("default:cobble",
                {cracky=3,not_in_creative_inventory=1},
                {"default_cobble.png"},
                "Cobble Slope",
                "Cobble Slope Lying",
                "Cobble Slope Upside Down",
                "Cobble Slope Edge",
                "Cobble Slope Inner Edge",
                "Cobble Slope Upside Down Edge",
                "Cobble Slope Upside Down Inner Edge",
                "Cobble Pyramid",
                "Cobble Spike",
                "Cobble One Curved Edge Block",
                "Cobble Two Curved Edge Block",
                "Cobble Cylinder",
                "Cobble Cylinder Horizontal",
                "Cobble Sphere",
                "Cobble Element Straight",
                "Cobble Element Edge",
                "Cobble Element T",
                "Cobble Element Cross",
                "Cobble Element End")
-- BRICK
--------
technic_cnc_api.register_slope_edge_etc("default:brick",
                {cracky=3,not_in_creative_inventory=1},
                {"default_brick.png"},
                "Brick Slope",
                "Brick Slope Upside Down",
                "Brick Slope Edge",
                "Brick Slope Inner Edge",
                "Brick Slope Upside Down Edge",
                "Brick Slope Upside Down Inner Edge",
                "Brick Pyramid",
                "Brick Spike",
                "Brick One Curved Edge Block",
                "Brick Two Curved Edge Block",
                "Brick Cylinder",
                "Brick Cylinder Horizontal",
                "Brick Sphere",
                "Brick Element Straight",
                "Brick Element Edge",
                "Brick Element T",
                "Brick Element Cross",
                "Brick Element End")
-- SANDSTONE
------------
technic_cnc_api.register_slope_edge_etc("default:sandstone",
                {crumbly=2,cracky=2,not_in_creative_inventory=1},
                {"default_sandstone.png"},
                "Sandstone Slope",
                "Sandstone Slope Lying",
                "Sandstone Slope Upside Down",
                "Sandstone Slope Edge",
                "Sandstone Slope Inner Edge",
                "Sandstone Slope Upside Down Edge",
                "Sandstone Slope Upside Down Inner Edge",
                "Sandstone Pyramid",
                "Sandstone Spike",
                "Sandstone One Curved Edge Block",
                "Sandstone Two Curved Edge Block",
                "Sandstone Cylinder",
                "Sandstone Cylinder Horizontal",
                "Sandstone Sphere",
                "Sandstone Element Straight",
                "Sandstone Element Edge",
                "Sandstone Element T",
                "Sandstone Element Cross",
                "Sandstone Element End")
-- LEAVES
---------
technic_cnc_api.register_slope_edge_etc("default:leaves",
                {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
                {"bucharest_tree.png"},
                "Leaves Slope",
                "Leaves Slope Lying",
                "Leaves Slope Upside Down",
                "Leaves Slope Edge",
                "Leaves Slope Inner Edge",
                "Leaves Slope Upside Down Edge",
                "Leaves Slope Upside Down Inner Edge",
                "Leaves Pyramid",
                "Leaves Spike",
                "Leaves One Curved Edge Block",
                "Leaves Two Curved Edge Block",
                "Leaves Cylinder",
                "Leaves Cylinder Horizontal",
                "Leaves Sphere",
                "Leaves Element Straight",
                "Leaves Element Edge",
                "Leaves Element T",
                "Leaves Element Cross",
                "Leaves Element End")
-- DIRT
-------
technic_cnc_api.register_slope_edge_etc("default:dirt",
                {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
                {"default_grass.png", "default_dirt.png", "default_grass.png"},
                "Dirt Slope",
                "Dirt Slope Lying",
                "Dirt Slope Upside Down",
                "Dirt Slope Edge",
                "Dirt Slope Inner Edge",
                "Dirt Slope Upside Down Edge",
                "Dirt Slope Upside Down Inner Edge",
                "Dirt Pyramid",
                "Dirt Spike",
                "Dirt One Curved Edge Block",
                "Dirt Two Curved Edge Block",
                "Dirt Cylinder",
                "Dirt Cylinder Horizontal",
                "Dirt Sphere",
                "Dirt Element Straight",
                "Dirt Element Edge",
                "Dirt Element T",
                "Dirt Element Cross",
                "Dirt Element End")
-- TREE
-------
technic_cnc_api.register_slope_edge_etc("default:tree",
                {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,not_in_creative_inventory=1},
                {"default_tree.png"},
                "Tree Slope",
                "Tree Slope Lying",
                "Tree Slope Upside Down",
                "Tree Slope Edge",
                "Tree Slope Inner Edge",
                "Tree Slope Upside Down Edge",
                "Tree Slope Upside Down Inner Edge",
                "Tree Pyramid",
                "Tree Spike",
                "Tree One Curved Edge Block",
                "Tree Two Curved Edge Block",
                "Tree Cylinder",
                "Tree Cylinder Horizontal",
                "Tree Sphere",
                "Tree Element Straight",
                "Tree Element Edge",
                "Tree Element T",
                "Tree Element Cross",
                "Tree Element End")
-- STEEL
--------
technic_cnc_api.register_slope_edge_etc("default:steelblock",
                {snappy=1,bendy=2,cracky=1,melty=2,level=2,not_in_creative_inventory=1},
                {"default_steel_block.png"},
                "Steel Slope",
                "Steel Slope Lying",
                "Steel Slope Upside Down",
                "Steel Slope Edge",
                "Steel Slope Inner Edge",
                "Steel Slope Upside Down Edge",
                "Steel Slope Upside Down Inner Edge",
                "Steel Pyramid",
                "Steel Spike",
                "Steel One Curved Edge Block",
                "Steel Two Curved Edge Block",
                "Steel Cylinder",
                "Steel Cylinder Horizontal",
                "Steel Sphere",
                "Steel Element Straight",
                "Steel Element Edge",
                "Steel Element T",
                "Steel Element Cross",
                "Steel Element End")

-- REGISTER MATERIALS AND PROPERTIES FOR STICKS:
------------------------------------------------

-- WOOD
-------
technic_cnc_api.register_stick_etc("default:wood",
                {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
                {"default_wood.png"},
                "Wooden Stick")
-- STONE
--------
technic_cnc_api.register_stick_etc("default:stone",
                {cracky=3,not_in_creative_inventory=1},
                {"default_stone.png"},
                "Stone Stick")
-- COBBLE
---------
technic_cnc_api.register_stick_etc("default:cobble",
                {cracky=3,not_in_creative_inventory=1},
                {"default_cobble.png"},
                "Cobble Stick")
-- BRICK
--------
technic_cnc_api.register_stick_etc("default:brick",
                {cracky=3,not_in_creative_inventory=1},
                {"default_brick.png"},
                "Brick Stick")
-- SANDSTONE
------------
technic_cnc_api.register_stick_etc("default:sandstone",
                {crumbly=2,cracky=2,not_in_creative_inventory=1},
                {"default_sandstone.png"},
                "Sandstone Stick")
-- LEAVES
---------
technic_cnc_api.register_stick_etc("default:leaves",
                {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
                {"bucharest_tree.png"},
                "Leaves Stick")
-- TREE
-------
technic_cnc_api.register_stick_etc("default:tree",
                {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1,not_in_creative_inventory=1},
                {"default_tree.png"},
                "Tree Stick")
-- STEEL
--------
technic_cnc_api.register_stick_etc("default:steelblock",
                {snappy=1,bendy=2,cracky=1,melty=2,level=2,not_in_creative_inventory=1},
                {"default_steel_block.png"},
                "Steel Stick")

-- REGISTER MATERIALS AND PROPERTIES FOR HALF AND NORMAL HEIGHT ELEMENTS:
-------------------------------------------------------------------------

-- WOOD
-------
technic_cnc_api.register_elements("default:wood",
                {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
                {"default_wood.png"},
                "Wooden Element Straight Double",
                "Wooden Element Edge Double",
                "Wooden Element T Double",
                "Wooden Element Cross Double",
                "Wooden Element End Double")
-- STONE
--------
technic_cnc_api.register_elements("default:stone",
                {cracky=3,not_in_creative_inventory=1},
                {"default_stone.png"},
                "Stone Element Straight Double",
                "Stone Element Edge Double",
                "Stone Element T Double",
                "Stone Element Cross Double",
                "Stone Element End Double")
-- COBBLE
---------
technic_cnc_api.register_elements("default:cobble",
                {cracky=3,not_in_creative_inventory=1},
                {"default_cobble.png"},
                "Cobble Element Straight Double",
                "Cobble Element Edge Double",
                "Cobble Element T Double",
                "Cobble Element Cross Double",
                "Cobble Element End Double")
-- BRICK
--------
technic_cnc_api.register_elements("default:brick",
                {cracky=3,not_in_creative_inventory=1},
                {"default_brick.png"},
                "Brick Element Straight Double",
                "Brick Element Edge Double",
                "Brick Element T Double",
                "Brick Element Cross Double",
                "Brick Element End Double")
-- SANDSTONE
------------
technic_cnc_api.register_elements("default:sandstone",
                {crumbly=2,cracky=2,not_in_creative_inventory=1},
                {"default_sandstone.png"},
                "Sandstone Element Straight Double",
                "Sandstone Element Edge Double",
                "Sandstone Element T Double",
                "Sandstone Element Cross Double",
                "Sandstone Element End Double")
-- LEAVES
---------
technic_cnc_api.register_elements("default:leaves",
                {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
                {"bucharest_tree.png"},
                "Leaves Element Straight Double",
                "Leaves Element Edge Double",
                "Leaves Element T Double",
                "Leaves Element Cross Double",
                "Leaves Element End Double")
-- TREE
-------
technic_cnc_api.register_elements("default:tree",
                {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1,not_in_creative_inventory=1},
                {"default_tree.png"},
                "Tree Element Straight Double",
                "Tree Element Edge Double",
                "Tree Element T Double",
                "Tree Element Cross Double",
                "Tree Element End Double")
-- STEEL
--------
technic_cnc_api.register_elements("default:steel",
                {snappy=1,bendy=2,cracky=1,melty=2,level=2,not_in_creative_inventory=1},
                {"default_steel_block.png"},
                "Steel Element Straight Double",
                "Steel Element Edge Double",
                "Steel Element T Double",
                "Steel Element Cross Double",
                "Steel Element End Double")
