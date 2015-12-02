

--- A geothermal EU generator
--- Using hot lava and water this device can create energy from steam
--- The machine is only producing LV EUs and can thus not drive more advanced equipment
--- The output is a little more than the coal burning generator (max 300EUs)


minetest.register_craft({
	output = 'technic:geothermal_lv 1',
	recipe = {
                {'technic:granite', 'default:diamond', 'technic:granite'},
                {'technic:fine_copper_wire', 'technic:machine_casing', 'technic:fine_copper_wire'},
                {'technic:granite', 'technic:lv_cable0', 'technic:granite'},
        }
})

technic.register_geothermal({tier="LV", power=10})

minetest.register_alias("geothermal", "technic:geothermal_lv")
minetest.register_alias("technic:geothermal", "technic:geothermal_lv")
