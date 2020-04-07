
local material_list
if minetest.get_modpath("moreores") then
	material_list = { 'silver' }
else
	-- Make the gold chest obtainable for mere mortals (the silver chest is not obtainable)
	material_list = { 'copper', 'silver' }
end

for _, material in ipairs(material_list) do
	minetest.register_craft({
		output = 'technic:gold_chest',
		recipe = {
			{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
			{'default:gold_ingot',"technic:"..material.."_chest",'default:gold_ingot'},
			{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
		}
	})

	minetest.register_craft({
		output = 'technic:gold_locked_chest',
		recipe = {
			{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
			{'default:gold_ingot',"technic:"..material.."_locked_chest",'default:gold_ingot'},
			{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
		}
	})

	if minetest.get_modpath("protector") then
		minetest.register_craft({
			output = 'technic:gold_protected_chest',
			recipe = {
				{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
				{'default:gold_ingot',"technic:"..material.."_protected_chest",'default:gold_ingot'},
				{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
			}
		})
	end
end

minetest.register_craft({
	output = 'technic:gold_locked_chest',
	recipe = {
		{'basic_materials:padlock'},
		{'technic:gold_chest'},
	}
})

technic.chests:register("Gold", {
	width = 15,
	height = 6,
	sort = true,
	autosort = true,
	infotext = true,
	color = true,
	locked = false,
	protected = false,
})

technic.chests:register("Gold", {
	width = 15,
	height = 6,
	sort = true,
	autosort = true,
	infotext = true,
	color = true,
	locked = true,
	protected = false,
})

if minetest.get_modpath("protector") then
	minetest.register_craft({
		output = 'technic:gold_protected_chest',
		recipe = {
			{'default:copper_ingot'},
			{'technic:gold_chest'},
		}
	})

	technic.chests:register("Gold", {
		width = 15,
		height = 6,
		sort = true,
		autosort = true,
		infotext = true,
		color = true,
		locked = false,
		protected = true,
	})
end
