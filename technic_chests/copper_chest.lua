minetest.register_craft({
	output = 'technic:copper_chest 1',
	recipe = {
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
		{'default:copper_ingot','technic:iron_chest','default:copper_ingot'},
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:copper_locked_chest 1',
	recipe = {
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
		{'default:copper_ingot','technic:iron_locked_chest','default:copper_ingot'},
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
	}
})

minetest.register_craft({
    output = 'technic:copper_locked_chest 1',
    recipe = {
        {'basic_materials:padlock'},
        {'technic:copper_chest'},
    }
})

technic.chests:register("Copper", {
	width = 12,
	height = 5,
	sort = true,
	autosort = true,
	infotext = false,
	color = false,
	locked = false,
    protected = false,
})

technic.chests:register("Copper", {
	width = 12,
	height = 5,
	sort = true,
	autosort = true,
	infotext = false,
	color = false,
	locked = true,
    protected = false,
})

if minetest.get_modpath("protector") then
    minetest.register_craft({
        output = 'technic:copper_protected_chest 1',
        recipe = {
            {'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
            {'default:copper_ingot','technic:iron_protected_chest','default:copper_ingot'},
            {'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
        }
    })

    minetest.register_craft({
        output = 'technic:copper_protected_chest 1',
        recipe = {
            {'default:copper_ingot'},
            {'technic:copper_chest'},
        }
    })

    technic.chests:register("Copper", {
        width = 12,
        height = 5,
        sort = true,
        autosort = true,
        infotext = false,
        color = false,
        locked = false,
        protected = true,
    })
end
