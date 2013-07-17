
minetest.register_craft({
	output = 'technic:hv_cable0 3',
	recipe = {
		{'technic:rubber',    'technic:rubber',    'technic:rubber'},
		{'technic:mv_cable0', 'technic:mv_cable0', 'technic:mv_cable0'},
		{'technic:rubber',    'technic:rubber',    'technic:rubber'},
	}
}) 

technic.register_cable("HV", 3/16)

