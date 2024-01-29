local S = technic_cnc.getter

-- Conditional variables for MineClone2 compatibility
local is_mcl = minetest.get_modpath("mcl_core")

-- Textures and names for MineClone2
local dirt_texture = is_mcl and "default_dirt.png" or "default_dirt.png"
local grass_texture = is_mcl and "mcl_core_palette_grass.png" or "default_grass.png"
local wood_texture = is_mcl and "default_wood.png" or "default_wood.png"
local stone_texture = is_mcl and "default_stone.png" or "default_stone.png"
local cobble_texture = is_mcl and "default_cobble.png" or "default_cobble.png"
local brick_texture = is_mcl and "default_brick.png" or "default_brick.png"
local sandstone_texture = is_mcl and "mcl_core_sandstone_top.png" or "default_sandstone.png"
local leaves_texture = is_mcl and "default_leaves.png" or "default_leaves.png"
local tree_texture = is_mcl and "default_tree.png" or "default_tree.png"
local bronzeblock_texture = is_mcl and "mcl_core_bronze_block.png" or "default_bronze_block.png"

-- DIRT
technic_cnc.register_all(is_mcl and "mcl_core:dirt" or "default:dirt",
            {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
            {dirt_texture},
            S("Dirt"))

-- (DIRT WITH) GRASS
technic_cnc.register_all(is_mcl and "mcl_core:dirt_with_grass" or "default:dirt_with_grass",
            {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
            {grass_texture},
            S("Grassy dirt"))

-- WOOD
technic_cnc.register_all(is_mcl and "mcl_core:wood" or "default:wood",
            {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
            {wood_texture},
            S("Wooden"))

-- STONE
technic_cnc.register_all(is_mcl and "mcl_core:stone" or "default:stone",
            {cracky=3, not_in_creative_inventory=1},
            {stone_texture},
            S("Stone"))

-- COBBLE
technic_cnc.register_all(is_mcl and "mcl_core:cobble" or "default:cobble",
            {cracky=3, not_in_creative_inventory=1},
            {cobble_texture},
            S("Cobble"))

-- BRICK
technic_cnc.register_all(is_mcl and "mcl_core:brick" or "default:brick",
            {cracky=3, not_in_creative_inventory=1},
            {brick_texture},
            S("Brick"))

-- SANDSTONE
technic_cnc.register_all(is_mcl and "mcl_core:sandstone" or "default:sandstone",
            {crumbly=2, cracky=3, not_in_creative_inventory=1},
            {sandstone_texture},
            S("Sandstone"))

-- LEAVES
technic_cnc.register_all(is_mcl and "mcl_core:leaves" or "default:leaves",
            {snappy=2, choppy=2, oddly_breakable_by_hand=3, not_in_creative_inventory=1},
            {leaves_texture},
            S("Leaves"))

-- TREE
technic_cnc.register_all(is_mcl and "mcl_core:tree" or "default:tree",
            {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=3, wood=1, not_in_creative_inventory=1},
            {tree_texture},
            S("Tree"))

-- Bronze
if not is_mcl then
	technic_cnc.register_all("default:bronzeblock",
            {cracky=1, level=2, not_in_creative_inventory=1},
            {bronzeblock_texture},
            S("Bronze"))
end

local steeltex = is_mcl and "default_steel_block.png" or "default_steel_block.png"
local steelname = is_mcl and "Iron" or "Steel"

if technic_cnc.technic_modpath then
    if not is_mcl then
        steeltex = "technic_wrought_iron_block.png"
        steelname = "Wrought Iron"

        -- Stainless Steel
        technic_cnc.register_all("technic:stainless_steel_block",
                        {cracky=1, level=2, not_in_creative_inventory=1},
                        {"technic_stainless_steel_block.png"},
                        S("Stainless Steel"))

        -- Marble
        technic_cnc.register_all("technic:marble",
                        {cracky=3, not_in_creative_inventory=1},
                        {"technic_marble.png"},
                        S("Marble"))

        -- Blast-resistant concrete
        technic_cnc.register_all("technic:blast_resistant_concrete",
                        {cracky=2, level=2, not_in_creative_inventory=1},
                        {"technic_blast_resistant_concrete_block.png"},
                        S("Blast-resistant concrete"))
    end
end

-- STEEL
technic_cnc.register_all(is_mcl and "mcl_core:iron_block" or "default:steelblock",
            {cracky=1, level=2, not_in_creative_inventory=1},
            {steeltex},
            S(steelname))

-- CONCRETE AND CEMENT
if minetest.get_modpath("basic_materials") then
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
end
