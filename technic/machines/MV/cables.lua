
minetest.register_alias("mv_cable", "technic:mv_cable0")

minetest.register_craft({
	output = 'technic:mv_cable0 3',
	recipe ={
		{'technic:rubber',    'technic:rubber',    'technic:rubber'},
		{'technic:lv_cable0', 'technic:lv_cable0', 'technic:lv_cable0'},
		{'technic:rubber',    'technic:rubber',    'technic:rubber'},
	}
}) 

technic.register_cable("MV", 2.5/16)

