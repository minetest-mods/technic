-- LV Electric Furnace
-- This is a faster version of the stone furnace which runs on EUs

-- FIXME: kpoppel I'd like to introduce an induction heating element here also
minetest.register_craft({
	output = 'technic:electric_furnace',
	recipe = {
		{'default:cobble',          'default:cobble',        'default:cobble'},
		{'default:cobble',          '',                      'default:cobble'},
		{'technic:cast_iron_ingot', 'moreores:copper_ingot', 'technic:cast_iron_ingot'},
	}
})

technic.register_electric_furnace({tier="LV", demand={300}, speed = 2})


