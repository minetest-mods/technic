local udef = technic.chests:definition("Wooden", {
	width = 8,
	height = 4,
	sort = false,
	autosort = false,
	infotext = false,
	color = false,
	locked = false,
})
local uudef = {
	groups = udef.groups,
	tube = udef.tube,
	on_construct = udef.on_construct,
	can_dig = udef.can_dig,
	on_receive_fields = udef.on_receive_fields,
	on_metadata_inventory_move = udef.on_metadata_inventory_move,
	on_metadata_inventory_put = udef.on_metadata_inventory_put,
	on_metadata_inventory_take = udef.on_metadata_inventory_take,
}
if minetest.registered_nodes["default:chest"].description == "Chest" then
	uudef.description = udef.description
end
minetest.override_item("default:chest", uudef)

local ldef = technic.chests:definition("Wooden", {
	width = 8,
	height = 4,
	sort = false,
	autosort = false,
	infotext = false,
	color = false,
	locked = true,
})
local lldef = {
	groups = ldef.groups,
	tube = ldef.tube,
	after_place_node = ldef.after_place_node,
	on_construct = ldef.on_construct,
	can_dig = ldef.can_dig,
	on_receive_fields = ldef.on_receive_fields,
	allow_metadata_inventory_move = ldef.allow_metadata_inventory_move,
	allow_metadata_inventory_put = ldef.allow_metadata_inventory_put,
	allow_metadata_inventory_take = ldef.allow_metadata_inventory_take,
	on_metadata_inventory_move = ldef.on_metadata_inventory_move,
	on_metadata_inventory_put = ldef.on_metadata_inventory_put,
	on_metadata_inventory_take = ldef.on_metadata_inventory_take,
}
if minetest.registered_nodes["default:chest_locked"].description == "Locked Chest" then
	lldef.description = ldef.description
end
minetest.override_item("default:chest_locked", lldef)
