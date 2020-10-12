
minetest.register_alias("mv_cable", "technic:mv_cable")

minetest.register_craft({
	output = 'technic:mv_cable 3',
	recipe ={
		{'technic:rubber',   'technic:rubber',   'technic:rubber'},
		{'technic:lv_cable', 'technic:lv_cable', 'technic:lv_cable'},
		{'technic:rubber',   'technic:rubber',   'technic:rubber'},
	}
})

technic.register_cable("MV", 2.5/16)

if minetest.get_modpath("digilines") then

	local S = technic.getter

	if minetest.get_modpath("digistuff") then
		minetest.register_craft({
			output = 'technic:mv_digi_cable 1',
			type = "shapeless",
			recipe = {'digistuff:digimese', 'technic:mv_cable'}
		})
	else
		minetest.register_craft({
			output = 'technic:mv_digi_cable 1',
			recipe = {
				{'digilines:wire_std_00000000', 'digilines:wire_std_00000000', 'digilines:wire_std_00000000'},
				{'digilines:wire_std_00000000', 'technic:mv_cable',            'digilines:wire_std_00000000'},
				{'digilines:wire_std_00000000', 'digilines:wire_std_00000000', 'digilines:wire_std_00000000'},
			}
		})
	end

	technic.register_cable("MV", 2.5/16, S("MV Cable (digiline)"), "_digi", {
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
end
