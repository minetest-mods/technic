local S = technic.getter

minetest.register_craft({
	output = 'technic:hv_cable 3',
	recipe = {
		{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
		{'technic:mv_cable',           'technic:mv_cable',           'technic:mv_cable'},
		{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
	}
})

technic.register_cable("HV", 3/16)

minetest.register_craft({
	output = 'technic:hv_digi_cable 1',
	recipe = {
		{'digilines:wire_std_00000000', 'digilines:wire_std_00000000', 'digilines:wire_std_00000000'},
		{'digilines:wire_std_00000000', 'technic:hv_cable',            'digilines:wire_std_00000000'},
		{'digilines:wire_std_00000000', 'digilines:wire_std_00000000', 'digilines:wire_std_00000000'},
	}
})

technic.register_cable("HV", 3/16, S("HV Cable (digiline)"), "_digi", {
	digiline = {
		wire = {
			rules = {
				{x = 1, y = 0, z = 0},
				{x =-1, y = 0, z = 0},
				{x = 0, y = 1, z = 0},
				{x = 0, y =-1, z = 0},
				{x = 0, y = 0, z = 1},
				{x = 0, y = 0, z =-1}
			}
		}
	}
})
