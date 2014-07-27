
local S = technic.getter

minetest.register_craftitem("technic:silicon_wafer", {
	description = S("Silicon Wafer"),
	inventory_image = "technic_silicon_wafer.png",
})

minetest.register_craftitem( "technic:doped_silicon_wafer", {
	description = S("Doped Silicon Wafer"),
	inventory_image = "technic_doped_silicon_wafer.png",
})

minetest.register_craftitem("technic:uranium_fuel", {
	description = S("Uranium Fuel"),
	inventory_image = "technic_uranium_fuel.png",
})

minetest.register_craftitem( "technic:diamond_drill_head", {
	description = S("Diamond Drill Head"),
	inventory_image = "technic_diamond_drill_head.png",
})

minetest.register_tool("technic:blue_energy_crystal", {
	description = S("Blue Energy Crystal"),
	inventory_image = minetest.inventorycube(
		"technic_diamond_block_blue.png",
		"technic_diamond_block_blue.png",
		"technic_diamond_block_blue.png"),
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	tool_capabilities = {
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={}, uses=10000, maxlevel=0}
		}
	}
}) 

minetest.register_tool("technic:green_energy_crystal", {
	description = S("Green Energy Crystal"),
	inventory_image = minetest.inventorycube(
		"technic_diamond_block_green.png",
		"technic_diamond_block_green.png",
		"technic_diamond_block_green.png"),
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	tool_capabilities = {
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={}, uses=10000, maxlevel=0}
		}
	}
}) 

minetest.register_tool("technic:red_energy_crystal", {
	description = S("Red Energy Crystal"),
	inventory_image = minetest.inventorycube(
		"technic_diamond_block_red.png",
		"technic_diamond_block_red.png",
		"technic_diamond_block_red.png"),
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	tool_capabilities = {
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={}, uses=10000, maxlevel=0}
		}
	}
}) 


minetest.register_craftitem("technic:fine_copper_wire", {
	description = S("Fine Copper Wire"),
	inventory_image = "technic_fine_copper_wire.png",
})

minetest.register_craftitem("technic:fine_gold_wire", {
	description = S("Fine Gold Wire"),
	inventory_image = "technic_fine_gold_wire.png",
})

minetest.register_craftitem("technic:fine_silver_wire", {
	description = S("Fine Silver Wire"),
	inventory_image = "technic_fine_silver_wire.png",
})

minetest.register_craftitem("technic:copper_coil", {
	description = S("Copper Coil"),
	inventory_image = "technic_copper_coil.png",
})

minetest.register_craftitem("technic:motor", {
	description = S("Electric Motor"),
	inventory_image = "technic_motor.png",
})

minetest.register_craftitem("technic:lv_transformer", {
	description = S("Low Voltage Transformer"),
	inventory_image = "technic_lv_transformer.png",
})

minetest.register_craftitem("technic:lv_transformer", {
	description = S("Low Voltage Transformer"),
	inventory_image = "technic_lv_transformer.png",
})
minetest.register_craftitem("technic:mv_transformer", {
	description = S("Medium Voltage Transformer"),
	inventory_image = "technic_mv_transformer.png",
})

minetest.register_craftitem( "technic:hv_transformer", {
	description = S("High Voltage Transformer"),
	inventory_image = "technic_hv_transformer.png",
})

minetest.register_craftitem( "technic:control_logic_unit", {
	description = S("Control Logic Unit"),
	inventory_image = "technic_control_logic_unit.png",
})

minetest.register_craftitem("technic:mixed_metal_ingot", {
	description = S("Mixed Metal Ingot"),
	inventory_image = "technic_mixed_metal_ingot.png",
})

minetest.register_craftitem("technic:composite_plate", {
	description = S("Composite Plate"),
	inventory_image = "technic_composite_plate.png",
})

minetest.register_craftitem("technic:copper_plate", {
	description = S("Copper Plate"),
	inventory_image = "technic_copper_plate.png",
})

minetest.register_craftitem("technic:carbon_plate", {
	description = S("Carbon Plate"),
	inventory_image = "technic_carbon_plate.png",
})

minetest.register_craftitem("technic:graphite", {
	description = S("Graphite"),
	inventory_image = "technic_graphite.png",
})

minetest.register_craftitem("technic:carbon_cloth", {
	description = S("Carbon Cloth"),
	inventory_image = "technic_carbon_cloth.png",
})

minetest.register_node("technic:machine_casing", {
	description = S("Machine Casing"),
	groups = {cracky=2},
	sunlight_propagates = true,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"technic_machine_casing.png"},
	sounds = default.node_sound_stone_defaults(),
})

for p = 0, 35 do
	local nici = (p ~= 0 and p ~= 7 and p ~= 35) and 1 or nil
	local psuffix = p == 7 and "" or p
	local ingot = "technic:uranium"..psuffix.."_ingot"
	local block = "technic:uranium"..psuffix.."_block"
	local ov = p == 7 and minetest.override_item or nil;
	(ov or minetest.register_craftitem)(ingot, {
		description = string.format(S("%.1f%%-Fissile Uranium Ingot"), p/10),
		inventory_image = "technic_uranium_ingot.png",
		groups = {uranium_ingot=1, not_in_creative_inventory=nici},
	});
	(ov or minetest.register_node)(block, {
		description = string.format(S("%.1f%%-Fissile Uranium Block"), p/10),
		tiles = {"technic_uranium_block.png"},
		is_ground_content = true,
		groups = {uranium_block=1, not_in_creative_inventory=nici, cracky=1, level=2, radioactive=math.floor(math.sqrt(p) + 0.5)},
		sounds = default.node_sound_stone_defaults(),
	});
	if not ov then
		minetest.register_craft({
			output = block,
			recipe = {
				{ingot, ingot, ingot},
				{ingot, ingot, ingot},
				{ingot, ingot, ingot},
			},
		})
		minetest.register_craft({
			output = ingot.." 9",
			recipe = {{block}},
		})
	end
end
