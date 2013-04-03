minetest.register_ore({
	ore_type       = "scatter",
	ore            = "technic:mineral_uranium",
	wherein        = "default:stone",
	clust_scarcity = 10*10*10,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -300,
	height_max     = -80,
})
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "technic:mineral_chromium",
	wherein        = "default:stone",
	clust_scarcity = 10*10*10,
	clust_num_ores = 2,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -100,
})
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "technic:mineral_zinc",
	wherein        = "default:stone",
	clust_scarcity = 9*9*9,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = 2,
})
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

