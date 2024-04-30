
minetest.register_alias("grinder", "technic:lv_grinder")
minetest.register_craft({
	output = 'technic:lv_grinder',
	recipe = {
		{'default:desert_stone', 'default:diamond',        'default:desert_stone'},
		{'default:desert_stone', 'technic:machine_casing', 'default:desert_stone'},
		{'technic:granite',      'technic:lv_cable',       'technic:granite'},
	}
})

if (minetest.get_modpath('everness')) then
	minetest.register_craft({
		output = 'technic:lv_grinder',
		recipe = {
			{'everness:coral_desert_stone', 'default:diamond',        'everness:coral_desert_stone'},
			{'everness:coral_desert_stone', 'technic:machine_casing', 'everness:coral_desert_stone'},
			{'technic:granite',             'technic:lv_cable',       'technic:granite'},
		}
	})

	minetest.register_craft({
		output = 'technic:lv_grinder',
		recipe = {
			{'everness:forsaken_desert_stone', 'default:diamond',        'everness:forsaken_desert_stone'},
			{'everness:forsaken_desert_stone', 'technic:machine_casing', 'everness:forsaken_desert_stone'},
			{'technic:granite',                'technic:lv_cable',       'technic:granite'},
		}
	})
end

technic.register_grinder({tier="LV", demand={200}, speed=1})

