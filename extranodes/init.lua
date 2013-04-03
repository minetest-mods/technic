-- Minetest 0.4.6 mod: extranodes
-- namespace: technic

--register stairslike nodes 
register_stair_slab_panel_micro("technic", "marble", "technic:marble",
	{cracky=2, not_in_creative_inventory=1},
	{"technic_marble.png"},
	"Marble",
	"marble",
	"facedir",
	0)

register_stair_slab_panel_micro("technic", "marble_bricks", "technic:marble_bricks",
	{cracky=2, not_in_creative_inventory=1},
	{"technic_marble_bricks.png"},
	"Marble Bricks",
	"marble_bricks",
	"facedir",
	0)

register_stair_slab_panel_micro("technic", "granite", "technic:granite",
	{cracky=3, not_in_creative_inventory=1},
	{"technic_granite.png"},
	"Granite",
	"granite",
	"facedir",
	0)

register_stair_slab_panel_micro("technic", "concrete", "technic:concrete",
	{cracky=3, not_in_creative_inventory=1},
	{"technic_concrete_block.png"},
	"Concrete",
	"concrete",
	"facedir",
	0)

--register nodes in circular saw if aviable
if circular_saw then 
	for i,v in ipairs({"concrete",  "marble",  "marble_bricks",  "granite",  "default:obsidian"}) do
		table.insert(circular_saw.known_stairs, "technic:" ..v);
	end
end
