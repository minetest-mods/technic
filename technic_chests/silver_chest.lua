if minetest.get_modpath("moreores") then
	minetest.register_craft({
		output = 'technic:silver_chest',
		recipe = {
			{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
			{'moreores:silver_ingot','technic:copper_chest','moreores:silver_ingot'},
			{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
		}
	})

	minetest.register_craft({
		output = 'technic:silver_locked_chest',
		recipe = {
			{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
			{'moreores:silver_ingot','technic:copper_locked_chest','moreores:silver_ingot'},
			{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
		}
	})

	if minetest.get_modpath("protector") then
		minetest.register_craft({
			output = 'technic:silver_protected_chest',
			recipe = {
				{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
				{'moreores:silver_ingot','technic:copper_protected_chest','moreores:silver_ingot'},
				{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
			}
		})
	end
end

minetest.register_craft({
	output = 'technic:silver_locked_chest',
	recipe = {
		{'basic_materials:padlock'},
		{'technic:silver_chest'},
	}
})

technic.chests:register("Silver", {
	width = 12,
	height = 6,
	sort = true,
	autosort = true,
	infotext = true,
	color = false,
	locked = false,
	protected = false,
})

technic.chests:register("Silver", {
	width = 12,
	height = 6,
	sort = true,
	autosort = true,
	infotext = true,
	color = false,
	locked = true,
	protected = false,
})

if minetest.get_modpath("protector") then
	minetest.register_craft({
		output = 'technic:silver_protected_chest',
		recipe = {
			{'default:copper_ingot'},
			{'technic:silver_chest'},
		}
	})

	technic.chests:register("Silver", {
		width = 12,
		height = 6,
		sort = true,
		autosort = true,
		infotext = true,
		color = false,
		locked = false,
		protected = true,
	})
end
