
minetest.register_craft({
	output = 'technic:hv_cable0 3',
	recipe = {
		{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
		{'technic:mv_cable0',          'technic:mv_cable0',          'technic:mv_cable0'},
		{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
	}
}) 

technic.register_cable("HV", 3/16)

