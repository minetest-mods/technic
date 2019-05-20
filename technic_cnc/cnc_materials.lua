-- REGISTER MATERIALS AND PROPERTIES FOR NONCUBIC ELEMENTS:
-----------------------------------------------------------

local S = technic_cnc.getter

-- DIRT
-------
technic_cnc.register_all("default:dirt",
                {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
                {"default_dirt.png"},
                S("Dirt"))
-- (DIRT WITH) GRASS
--------------------
technic_cnc.register_all("default:dirt_with_grass",
                {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
                {"default_grass.png"},
                S("Grassy dirt"))
-- WOOD
-------
technic_cnc.register_all("default:wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"default_wood.png"},
                S("Wooden"))

technic_cnc.register_all("default:junglewood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"default_junglewood.png"},
                S("Junglewood"))

technic_cnc.register_all("default:pine_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"default_pine_wood.png"},
                S("Pine"))

technic_cnc.register_all("default:acacia_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"default_acacia_wood.png"},
                S("Acacia"))

technic_cnc.register_all("default:aspen_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"default_aspen_wood.png"},
                S("Aspen"))

-- STONE
--------
technic_cnc.register_all("default:stone",
                {cracky=3, stone=1, not_in_creative_inventory=1},
                {"default_stone.png"},
                S("Stone"))

technic_cnc.register_all("default:stonebrick",
                {crumbly=2, cracky=3, stone=1, not_in_creative_inventory=1},
                {"default_stone_brick.png"},
                S("Stone Brick"))

technic_cnc.register_all("default:stone_block",
                {crumbly=2, cracky=3, stone=1, not_in_creative_inventory=1},
                {"default_stone_block.png"},
                S("Stone Block"))


technic_cnc.register_all("default:desert_stone",
                {cracky=3, stone=1, not_in_creative_inventory=1},
                {"default_desert_stone.png"},
                S("Desert Stone"))

technic_cnc.register_all("default:desert_stonebrick",
                {crumbly=2, cracky=3, stone=1, not_in_creative_inventory=1},
                {"default_desert_stone_brick.png"},
                S("Desert Stone Brick"))

technic_cnc.register_all("default:desert_stone_block",
                {crumbly=2, cracky=3, stone=1, not_in_creative_inventory=1},
                {"default_desert_stone_block.png"},
                S("Desert Stone Block"))

-- COBBLE
---------
technic_cnc.register_all("default:cobble",
                {cracky=3, stone=1, not_in_creative_inventory=1},
                {"default_cobble.png"},
                S("Cobble"))

technic_cnc.register_all("default:mossycobble",
                {cracky=3, stone=1, not_in_creative_inventory=1},
                {"default_mossycobble.png"},
                S("Mossy Cobblestone"))

technic_cnc.register_all("default:desert_cobble",
                {cracky=3, stone=1, not_in_creative_inventory=1},
                {"default_desert_cobble.png"},
                S("Desert Cobble"))

-- BRICK
--------
technic_cnc.register_all("default:brick",
                {cracky=3, not_in_creative_inventory=1},
                {"default_brick.png"},
                S("Brick"))

-- SANDSTONE
------------
technic_cnc.register_all("default:sandstone",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_sandstone.png"},
                S("Sandstone"))

technic_cnc.register_all("default:sandstonebrick",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_sandstone_brick.png"},
                S("Sandstone Brick"))

technic_cnc.register_all("default:sandstone_block",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_sandstone_block.png"},
                S("Sandstone Block"))


technic_cnc.register_all("default:desert_sandstone",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_desert_sandstone.png"},
                S("Desert Sandstone"))

technic_cnc.register_all("default:desert_sandstone_brick",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_desert_sandstone_brick.png"},
                S("Desert Sandstone Brick"))

technic_cnc.register_all("default:desert_sandstone_block",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_desert_sandstone_block.png"},
                S("Desert Sandstone Block"))


technic_cnc.register_all("default:silver_sandstone",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_silver_sandstone.png"},
                S("Silver Sandstone"))

technic_cnc.register_all("default:silver_sandstone_brick",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_silver_sandstone_brick.png"},
                S("Silver Sandstone Brick"))

technic_cnc.register_all("default:silver_sandstone_block",
                {crumbly=2, cracky=3, not_in_creative_inventory=1},
                {"default_silver_sandstone_block.png"},
                S("Silver Sandstone Block"))




-- LEAVES
---------
technic_cnc.register_all("default:leaves",
                {snappy=2, choppy=2, oddly_breakable_by_hand=3, not_in_creative_inventory=1},
                {"default_leaves.png"},
                S("Leaves"))

-- TREE
-------
technic_cnc.register_all("default:tree",
                {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=3, wood=1, not_in_creative_inventory=1},
                {"default_tree.png"},
                S("Tree"))

-- ICE
-------
technic_cnc.register_all("default:ice",
                {cracky=3, puts_out_fire=1, cools_lava=1, not_in_creative_inventory=1},
                {"default_ice.png"},
                S("Ice"))


-- OBSIDIAN
-----------
technic_cnc.register_all("default:obsidian_block",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"default_obsidian_block.png"},
                S("Obsidian"))


-- WROUGHT IRON
---------------
technic_cnc.register_all("default:steelblock",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"technic_wrought_iron_block.png"},
                S("Wrought Iron"))

-- Bronze
--------
technic_cnc.register_all("default:bronzeblock",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"default_bronze_block.png"},
                S("Bronze"))

-- Zinc
--------
technic_cnc.register_all("technic:zinc_block",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"technic_zinc_block.png"},
                S("Zinc"))

local steeltex = "default_steel_block.png"
local steelname = "Steel"

-- Cast Iron
------------
technic_cnc.register_all("technic:cast_iron_block",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"technic_cast_iron_block.png"},
                S("Cast Iron"))

if technic_cnc.technic_modpath then
	steeltex = "technic_wrought_iron_block.png"
	steelname = "Wrought Iron"

	-- Stainless Steel
	--------
	technic_cnc.register_all("technic:stainless_steel_block",
					{cracky=1, level=2, not_in_creative_inventory=1},
					{"technic_stainless_steel_block.png"},
					S("Stainless Steel"))

	-- Marble
	------------
	technic_cnc.register_all("technic:marble",
					{cracky=3, not_in_creative_inventory=1},
					{"technic_marble.png"},
					S("Marble"))

	-- Granite
	------------
	technic_cnc.register_all("technic:granite",
					{cracky=1, not_in_creative_inventory=1},
					{"technic_granite.png"},
					S("Granite"))

	-- Blast-resistant concrete
	---------------------------

	technic_cnc.register_all("technic:blast_resistant_concrete",
					{cracky=2, level=2, not_in_creative_inventory=1},
					{"technic_blast_resistant_concrete_block.png"},
					S("Blast-resistant concrete"))
end

technic_cnc.register_all("default:steelblock",
				{cracky=1, level=2, not_in_creative_inventory=1},
				{steeltex},
				S(steelname))

-- CONCRETE AND CEMENT
----------------------

technic_cnc.register_all("basic_materials:concrete_block",
				{cracky=2, level=2, not_in_creative_inventory=1},
				{"basic_materials_concrete_block.png"},
				S("Concrete"))

technic_cnc.register_all("basic_materials:cement_block",
				{cracky=2, level=2, not_in_creative_inventory=1},
				{"basic_materials_cement_block.png"},
				S("Cement"))

technic_cnc.register_all("basic_materials:brass_block",
				{cracky=1, level=2, not_in_creative_inventory=1},
				{"basic_materials_brass_block.png"},
				S("Brass block"))
-- Brass
--------
technic_cnc.register_all("technic:brass_block",
                {cracky=1, level=2, not_in_creative_inventory=1},
		{"basic_materials_brass_block.png"},
                S("Brass"))

-- Copper
---------
technic_cnc.register_all("default:copperblock",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"default_copper_block.png"},
                S("Copper"))

-- Tin
------
technic_cnc.register_all("default:tinblock",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"default_tin_block.png"},
                S("Tin"))

-- Gold
-------
technic_cnc.register_all("default:goldblock",
                {cracky=1, level=2, not_in_creative_inventory=1},
                {"default_gold_block.png"},
                S("Gold"))




if minetest.get_modpath("ethereal") then
	-- Glostone
	------------
	technic_cnc.register_all("ethereal:glostone",
			{cracky=1, not_in_creative_inventory=1, light_source=13},
			{"glostone.png"},
			S("Glo Stone"))

	-- Crystal block
	----------------
	technic_cnc.register_all("ethereal:crystal_block",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"crystal_block.png"},
                S("Crystal"))
	
	-- Misc. Wood types
	-------------------
	technic_cnc.register_all("ethereal:banana_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"banana_wood.png"},
                S("Banana Wood"))
	
	technic_cnc.register_all("ethereal:birch_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"moretrees_birch_wood.png"},
                S("Birch Wood"))
	
	technic_cnc.register_all("ethereal:frost_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"frost_wood.png"},
                S("Frost Wood"))
	
	technic_cnc.register_all("ethereal:palm_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"moretrees_palm_wood.png"},
                S("Palm Wood"))
	
	technic_cnc.register_all("ethereal:willow_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"willow_wood.png"},
                S("Willow Wood"))
	
	technic_cnc.register_all("ethereal:yellow_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"yellow_wood.png"},
                S("Healing Tree Wood"))
	
	technic_cnc.register_all("ethereal:redwood_wood",
                {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
                {"redwood_wood.png"},
                S("Redwood"))
end


if minetest.get_modpath("moreblocks") then
	-- Tiles
	------------
	technic_cnc.register_all("moreblocks:stone_tile",
			{stone=1, cracky=3, not_in_creative_inventory=1},
			{"moreblocks_stone_tile.png"},
			S("Stone Tile"))
	
	technic_cnc.register_all("moreblocks:split_stone_tile",
			{stone=1, cracky=3, not_in_creative_inventory=1},
			{"moreblocks_split_stone_tile.png"},
			S("Split Stone Tile"))
	
	technic_cnc.register_all("moreblocks:checker_stone_tile",
			{stone=1, cracky=3, not_in_creative_inventory=1},
			{"moreblocks_checker_stone_tile.png"},
			S("Checker Stone Tile"))
	
	technic_cnc.register_all("moreblocks:cactus_checker",
			{stone=1, cracky=3, not_in_creative_inventory=1},
			{"moreblocks_cactus_checker.png"},
			S("Cactus Checker"))
	
	-- Bricks
	------------
	technic_cnc.register_all("moreblocks:cactus_brick",
			{cracky=3, not_in_creative_inventory=1},
			{"moreblocks_cactus_brick.png"},
			S("Cactus Brick"))
	
	technic_cnc.register_all("moreblocks:grey_bricks",
			{cracky=3, not_in_creative_inventory=1},
			{"moreblocks_grey_bricks.png"},
			S("Grey Bricks"))
	
	-- Metals
	------------
	technic_cnc.register_all("moreblocks:copperpatina",
			{cracky=1, level=2, not_in_creative_inventory=1},
			{"moreblocks_copperpatina.png"},
			S("Copper Patina"))
	
	-- Clay
	------------
	technic_cnc.register_all("bakedclay:red",
			{cracky=3, not_in_creative_inventory=1},
			{"baked_clay_red.png"},
			S("Red Clay"))
	
	technic_cnc.register_all("bakedclay:orange",
			{cracky=3, not_in_creative_inventory=1},
			{"baked_clay_orange.png"},
			S("Orange Clay"))
	
	technic_cnc.register_all("bakedclay:grey",
			{cracky=3, not_in_creative_inventory=1},
			{"baked_clay_grey.png"},
			S("Grey Clay"))
	
end
