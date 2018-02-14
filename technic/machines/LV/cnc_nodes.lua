-- REGISTER MATERIALS AND PROPERTIES FOR NONCUBIC ELEMENTS:
-----------------------------------------------------------

local S = technic.getter

-- DIRT
-------
technic.cnc.register_all("default:dirt",
                {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
                {"default_grass.png", "default_dirt.png", "default_grass.png"},
                S("Dirt"))
-- WOOD
-------
technic.cnc.register_all("default:wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"default_wood.png"},
                S("Wooden"))

technic.cnc.register_all("default:junglewood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"default_junglewood.png"},
                S("Junglewood"))

technic.cnc.register_all("default:pine_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"default_pine_wood.png"},
                S("Pine"))

technic.cnc.register_all("default:acacia_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"default_acacia_wood.png"},
                S("Acacia"))

technic.cnc.register_all("default:aspen_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"default_aspen_wood.png"},
                S("Aspen"))

-- STONE
--------
technic.cnc.register_all("default:stone",
                {cracky=3, stone = 1, not_in_creative_inventory=1},
                {"default_stone.png"},
                S("Stone"))

technic.cnc.register_all("default:stonebrick",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_stone_brick.png"},
                S("Stone Brick"))

technic.cnc.register_all("default:stone_block",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_stone_block.png"},
                S("Stone Block"))


technic.cnc.register_all("default:desert_stone",
                {cracky=3, stone = 1, not_in_creative_inventory=1},
                {"default_desert_stone.png"},
                S("Desert Stone"))

technic.cnc.register_all("default:desert_stonebrick",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_desert_stone_brick.png"},
                S("Desert Stone Brick"))

technic.cnc.register_all("default:desert_stone_block",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_desert_stone_block.png"},
                S("Desert Stone Block"))

-- COBBLE
---------
technic.cnc.register_all("default:cobble",
                {cracky=3, stone = 1, not_in_creative_inventory=1},
                {"default_cobble.png"},
                S("Cobble"))

technic.cnc.register_all("default:mossycobble",
                {cracky=3, stone = 1, not_in_creative_inventory=1},
                {"default_mossycobble.png"},
                S("Mossy Cobblestone"))

technic.cnc.register_all("default:desert_cobble",
                {cracky=3, stone = 1, not_in_creative_inventory=1},
                {"default_desert_cobble.png"},
                S("Desert Cobble"))

-- BRICK
--------
technic.cnc.register_all("default:brick",
                {cracky=3, not_in_creative_inventory=1},
                {"default_brick.png"},
                S("Brick"))


-- SANDSTONE
------------
technic.cnc.register_all("default:sandstone",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_sandstone.png"},
                S("Sandstone"))

technic.cnc.register_all("default:sandstonebrick",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_sandstone_brick.png"},
                S("Sandstone Brick"))

technic.cnc.register_all("default:sandstone_block",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_sandstone_block.png"},
                S("Sandstone Block"))


technic.cnc.register_all("default:desert_sandstone",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_desert_sandstone.png"},
                S("Desert Sandstone"))

technic.cnc.register_all("default:desert_sandstone_brick",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_desert_sandstone_brick.png"},
                S("Desert Sandstone Brick"))

technic.cnc.register_all("default:desert_sandstone_block",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_desert_sandstone_block.png"},
                S("Desert Sandstone Block"))


technic.cnc.register_all("default:silver_sandstone",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_silver_sandstone.png"},
                S("Silver Sandstone"))

technic.cnc.register_all("default:silver_sandstone_brick",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_silver_sandstone_brick.png"},
                S("Silver Sandstone Brick"))

technic.cnc.register_all("default:silver_sandstone_block",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_silver_sandstone_block.png"},
                S("Silver Sandstone Block"))




-- LEAVES
---------
technic.cnc.register_all("default:leaves",
                {snappy=2, choppy=2, oddly_breakable_by_hand=3, not_in_creative_inventory=1},
                {"default_leaves.png"},
                S("Leaves"))

-- TREE
-------
technic.cnc.register_all("default:tree",
                {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=3, wood=1, not_in_creative_inventory=1},
                {"default_tree.png"},
                S("Tree"))

-- ICE
-------
technic.cnc.register_all("default:ice",
                {cracky = 3, puts_out_fire = 1, cools_lava = 1, not_in_creative_inventory=1},
                {"default_ice.png"},
                S("Ice"))


-- OBSIDIAN
-----------
technic.cnc.register_all("default:obsidian_block",
                {cracky = 1, level = 2, not_in_creative_inventory=1},
                {"default_obsidian_block.png"},
                S("Obsidian"))


-- WROUGHT IRON
---------------
technic.cnc.register_all("default:steelblock",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"technic_wrought_iron_block.png"},
                S("Wrought Iron"))

-- Bronze
--------
technic.cnc.register_all("default:bronzeblock",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"default_bronze_block.png"},
                S("Bronze"))

-- Zinc
--------
technic.cnc.register_all("technic:zinc_block",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"technic_zinc_block.png"},
                S("Zinc"))

-- Cast Iron
------------
technic.cnc.register_all("technic:cast_iron_block",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"technic_cast_iron_block.png"},
                S("Cast Iron"))

-- Stainless Steel
------------------
technic.cnc.register_all("technic:stainless_steel_block",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"technic_stainless_steel_block.png"},
                S("Stainless Steel"))

-- Carbon steel
---------------
technic.cnc.register_all("technic:carbon_steel_block",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"technic_carbon_steel_block.png"},
                S("Carbon Steel"))

-- Brass
--------
technic.cnc.register_all("technic:brass_block",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"technic_brass_block.png"},
                S("Brass"))

-- Copper
---------
technic.cnc.register_all("default:copperblock",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"default_copper_block.png"},
                S("Copper"))

-- Tin
------
technic.cnc.register_all("default:tinblock",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"default_tin_block.png"},
                S("Tin"))

-- Gold
-------
technic.cnc.register_all("default:goldblock",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"default_gold_block.png"},
                S("Gold"))


-- Marble
------------
technic.cnc.register_all("technic:marble",
                {cracky=3, not_in_creative_inventory=1},
                {"technic_marble.png"},
                S("Marble"))

-- Granite
------------
technic.cnc.register_all("technic:granite",
                {cracky=1, not_in_creative_inventory=1},
                {"technic_granite.png"},
                S("Granite"))

