minetest.register_craftitem( "technic:silicon_wafer", {
	description = "Silicon Wafer",
	inventory_image = "technic_silicon_wafer.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craftitem( "technic:doped_silicon_wafer", {
	description = "Doped Silicon Wafer",
	inventory_image = "technic_doped_silicon_wafer.png",
	on_place_on_ground = minetest.craftitem_place_item,
})