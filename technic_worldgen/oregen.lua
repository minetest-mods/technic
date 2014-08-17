local uranium_params = {offset = 0, scale = 1, spread = {x = 100, y = 100, z = 100}, seed = 420, octaves = 3, persist = 0.7}
local uranium_threshhold = 0.55

local chromium_params = {offset = 0, scale = 1, spread = {x = 100, y = 100, z = 100}, seed = 421, octaves = 3, persist = 0.7}
local chromium_threshhold = 0.55

local zinc_params = {offset = 0, scale = 1, spread = {x = 100, y = 100, z = 100}, seed = 422, octaves = 3, persist = 0.7}
local zinc_threshhold = 0.5

minetest.register_ore({
	ore_type         = "scatter",
	ore              = "technic:mineral_uranium",
	wherein          = "default:stone",
	clust_scarcity   = 8*8*8,
	clust_num_ores   = 4,
	clust_size       = 3,
	height_min       = -300,
	height_max       = -80,
	noise_params     = uranium_params,
	noise_threshhold = uranium_threshhold,
})

minetest.register_ore({
	ore_type         = "scatter",
	ore              = "technic:mineral_chromium",
	wherein          = "default:stone",
	clust_scarcity   = 8*8*8,
	clust_num_ores   = 2,
	clust_size       = 3,
	height_min       = -200,
	height_max       = -100,
	noise_params     = chromium_params,
	noise_threshhold = chromium_threshhold,
})

minetest.register_ore({
	ore_type         = "scatter",
	ore              = "technic:mineral_chromium",
	wherein          = "default:stone",
	clust_scarcity   = 6*6*6,
	clust_num_ores   = 2,
	clust_size       = 3,
	height_min       = -31000,
	height_max       = -200,
	flags            = "absheight",
	noise_params     = chromium_params,
	noise_threshhold = chromium_threshhold,
})

minetest.register_ore({
	ore_type         = "scatter",
	ore              = "technic:mineral_zinc",
	wherein          = "default:stone",
	clust_scarcity   = 8*8*8,
	clust_num_ores   = 4,
	clust_size       = 3,
	height_min       = -32,
	height_max       = 2,
	noise_params     = zinc_params,
	noise_threshhold = zinc_threshhold,
})

minetest.register_ore({
	ore_type         = "scatter",
	ore              = "technic:mineral_zinc",
	wherein          = "default:stone",
	clust_scarcity   = 6*6*6,
	clust_num_ores   = 4,
	clust_size       = 3,
	height_min       = -31000,
	height_max       = -32,
	flags            = "absheight",
	noise_params     = zinc_params,
	noise_threshhold = zinc_threshhold,
})

if technic.config:get_bool("enable_marble_generation") then
minetest.register_ore({
	ore_type       = "sheet",
	ore            = "technic:marble",
	wherein        = "default:stone",
	clust_scarcity = 1,
	clust_num_ores = 1,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -50,
	noise_threshhold = 0.4,
	noise_params = {offset=0, scale=15, spread={x=150, y=150, z=150}, seed=23, octaves=3, persist=0.70}
})
end

if technic.config:get_bool("enable_granite_generation") then
minetest.register_ore({
	ore_type       = "sheet",
	ore            = "technic:granite",
	wherein        = "default:stone",
	clust_scarcity = 1,
	clust_num_ores = 1,
	clust_size     = 4,
	height_min     = -31000,
	height_max     = -150,
	noise_threshhold = 0.4,
	noise_params = {offset=0, scale=15, spread={x=130, y=130, z=130}, seed=24, octaves=3, persist=0.70}
})
end

