local uranium_params = {
    offset = 0,
    scale = 1,
    spread = {x = 100, y = 100, z = 100},
    seed = 420,
    octaves = 3,
    persist = 0.7
}
local uranium_threshold = 0.55

local chromium_params = {
    offset = 0,
    scale = 1,
    spread = {x = 100, y = 100, z = 100},
    seed = 421,
    octaves = 3,
    persist = 0.7
}
local chromium_threshold = 0.55

local zinc_params = {
    offset = 0,
    scale = 1,
    spread = {x = 100, y = 100, z = 100},
    seed = 422,
    octaves = 3,
    persist = 0.7
}
local zinc_threshold = 0.5

local lead_params = {
    offset = 0,
    scale = 1,
    spread = {x = 100, y = 100, z = 100},
    seed = 423,
    octaves = 3,
    persist = 0.7
}
local lead_threshold = 0.3
local mcl_core_modpath = minetest.get_modpath("mcl_core")
local stone_id = mcl_core_modpath and "mcl_core:stone" or "default:stone"
local lava_source_id = mcl_core_modpath and "mcl_core:lava_source" or "default:lava_source"
local lava_flowing_id = mcl_core_modpath and "mcl_core:lava_flowing" or "default:lava_flowing"

-- Define default values for y_min and y_max
local uranium_y_min = -300
local uranium_y_max = -80
local chromium_y_min = -200
local chromium_y_max = -100
local zinc_y_min = -32
local zinc_y_max = 2
local lead_y_min = -16
local lead_y_max = 16

-- Update values if MineClone2 is detected
if mcl_core_modpath then
    uranium_y_min = -57
    uranium_y_max = 100
    chromium_y_min = -57
    chromium_y_max = 100
    zinc_y_min = -57
    zinc_y_max = 100
    lead_y_min = -57
    lead_y_max = 100
end

-- Uranium
minetest.register_ore({
    ore_type = "scatter",
    ore = "technic:mineral_uranium",
    wherein = stone_id,
    clust_scarcity = 8*8*8,
    clust_num_ores = 4,
    clust_size = 3,
    y_min = uranium_y_min,
    y_max = uranium_y_max,
    noise_params = uranium_params,
    noise_threshold = uranium_threshold,
})

-- Chromium
minetest.register_ore({
    ore_type = "scatter",
    ore = "technic:mineral_chromium",
    wherein = stone_id,
    clust_scarcity = 8*8*8,
    clust_num_ores = 2,
    clust_size = 3,
    y_min = chromium_y_min,
    y_max = chromium_y_max,
    noise_params = chromium_params,
    noise_threshold = chromium_threshold,
})

-- Zinc
minetest.register_ore({
    ore_type = "scatter",
    ore = "technic:mineral_zinc",
    wherein = stone_id,
    clust_scarcity = 8*8*8,
    clust_num_ores = 5,
    clust_size = 7,
    y_min = zinc_y_min,
    y_max = zinc_y_max,
    noise_params = zinc_params,
    noise_threshold = zinc_threshold,
})

-- Lead
minetest.register_ore({
    ore_type = "scatter",
    ore = "technic:mineral_lead",
    wherein = stone_id,
    clust_scarcity = 9*9*9,
    clust_num_ores = 5,
    clust_size = 3,
    y_min = lead_y_min,
    y_max = lead_y_max,
    noise_params = lead_params,
    noise_threshold = lead_threshold,
})

-- Sulfur
local sulfur_buf = {}
local sulfur_noise

minetest.register_on_generated(function(minp, maxp)
    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    local a = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
    local data = vm:get_data(sulfur_buf)
    local pr = PseudoRandom(17 * minp.x + 42 * minp.y + 101 * minp.z)
    sulfur_noise = sulfur_noise or minetest.get_perlin(9876, 3, 0.5, 100)

    local c_lava = minetest.get_content_id(lava_source_id)
    local c_lava_flowing = minetest.get_content_id(lava_flowing_id)
    local c_stone = minetest.get_content_id(stone_id)
    local c_sulfur = minetest.get_content_id("technic:mineral_sulfur")

    local grid_size = 5
    for x = minp.x + math.floor(grid_size / 2), maxp.x, grid_size do
    for y = minp.y + math.floor(grid_size / 2), maxp.y, grid_size do
    for z = minp.z + math.floor(grid_size / 2), maxp.z, grid_size do
        local c = data[a:index(x, y, z)]
        if (c == c_lava or c == c_lava_flowing)
        and sulfur_noise:get3d({x = x, y = z, z = z}) >= 0.4 then
            for i in a:iter(
                math.max(minp.x, x - grid_size),
                math.max(minp.y, y - grid_size),
                math.max(minp.z, z - grid_size),
                math.min(maxp.x, x + grid_size),
                math.min(maxp.y, y + grid_size),
                math.min(maxp.z, z + grid_size)
            ) do
                if data[i] == c_stone and pr:next(1, 10) <= 7 then
                    data[i] = c_sulfur
                end
            end
        end
    end
    end
    end

    vm:set_data(data)
    vm:write_to_map(data)
end)

-- Marble and Granite (if enabled)
if technic.config:get_bool("enable_marble_generation") then
    minetest.register_ore({
        ore_type = "sheet",
        ore = "technic:marble",
        wherein = stone_id,
        clust_scarcity = 1,
        clust_num_ores = 1,
        clust_size = 3,
        y_min = -31000,
        y_max = -50,
        noise_threshold = 0.4,
        noise_params = {
            offset = 0, scale = 15, spread = {x = 150, y = 150, z = 150},
            seed = 23, octaves = 3, persist = 0.70
        }
    })
end
if not minetest.get_modpath("mcl_core") then
if technic.config:get_bool("enable_granite_generation") then
    minetest.register_ore({
        ore_type = "sheet",
        ore = "technic:granite",
        wherein = stone_id,
        clust_scarcity = 1,
        clust_num_ores = 1,
        clust_size = 4,
        y_min = -31000,
        y_max = -150,
        noise_threshold = 0.4,
        noise_params = {
            offset = 0, scale = 15, spread = {x = 130, y = 130, z = 130},
            seed = 24, octaves = 3, persist = 0.70
        }
    })
end
end
