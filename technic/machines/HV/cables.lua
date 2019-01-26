
minetest.register_craft({
	output = 'technic:hv_cable 3',
	recipe = {
		{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
		{'technic:mv_cable',           'technic:mv_cable',           'technic:mv_cable'},
		{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
	}
})

technic.register_cable("HV", 3/16)

