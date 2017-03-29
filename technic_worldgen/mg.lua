mg.register_ore({
	name = "technic:mineral_uranium",
	wherein = "default:stone",
	seeddiff = 11,
	maxvdistance = 10.5,
	maxheight = -80,
	minheight = -300,
	sizen = 20,
	sizedev = 10,
	seglenghtn = 3,
	seglenghtdev = 1,
	segincln = 0.4,
	segincldev = 0.6,
	turnangle = 57,
	numperblock = 1,
	fork_chance = 0
})

mg.register_ore({
	name = "technic:mineral_chromium",
	wherein = "default:stone",
	seeddiff = 12,
	maxvdistance = 10.5,
	maxheight = -100,
	sizen = 50,
	sizedev = 20,
	seglenghtn = 8,
	seglenghtdev = 3,
	segincln = 0,
	segincldev = 0.6,
	turnangle = 57,
	forkturnangle = 57,
	numperblock = 2
})

mg.register_ore({
	name = "technic:mineral_zinc",
	wherein = "default:stone",
	seeddiff = 13,
	maxvdistance = 10.5,
	maxheight = 2,
	seglenghtn = 15,
	seglenghtdev = 6,
	segincln = 0,
	segincldev = 0.6,
	turnangle = 57,
	forkturnangle = 57,
	numperblock = 2
})

mg.register_ore({
	name = "technic:mineral_lead",
	wherein = "default:stone",
	seeddiff = 14,
	maxvdistance = 10.5,
	maxheight = 16,
	seglenghtn = 15,
	seglenghtdev = 6,
	segincln = 0,
	segincldev = 0.6,
	turnangle = 57,
	forkturnangle = 57,
	numperblock = 3
})

if technic.config:get_bool("enable_granite_generation") then
	mg.register_ore_sheet({
		name = "technic:granite",
		wherein = "default:stone",
		height_min = -31000,
		height_max = -150,
		tmin = 3,
		tmax = 6,
		threshhold = 0.4,
		noise_params = {offset=0, scale=15, spread={x=130, y=130, z=130}, seed=24, octaves=3, persist=0.70}
	})
end

if technic.config:get_bool("enable_marble_generation") then
	mg.register_ore_sheet({
		name = "technic:marble",
		wherein = "default:stone",
		height_min = -31000,
		height_max = -50,
		tmin = 3,
		tmax = 6,
		threshhold = 0.4,
		noise_params = {offset=0, scale=15, spread={x=130, y=130, z=130}, seed=23, octaves=3, persist=0.70}
	})
end
