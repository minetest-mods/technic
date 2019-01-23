
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

minetest.register_craftitem("technic:copper_coil", {
	description = S("Copper Coil"),
	inventory_image = "technic_copper_coil.png",
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
	-- Note on radioactivity of blocks:
	-- Source: <http://www.wise-uranium.org/rup.html>
	-- The baseline radioactivity of an isotope is not especially
	-- correlated with whether it's fissile (i.e., suitable as
	-- reactor fuel).  Natural uranium consists mainly of fissile
	-- U-235 and non-fissile U-238, and both U-235 and U-238 are
	-- significantly radioactive.  U-235's massic activity is
	-- about 80.0 MBq/kg, and U-238's is about 12.4 MBq/kg, which
	-- superficially suggests that 3.5%-fissile uranium should have
	-- only 1.19 times the activity of fully-depleted uranium.
	-- But a third isotope affects the result hugely: U-234 has
	-- massic activity of 231 GBq/kg.  Natural uranium has massic
	-- composition of 99.2837% U-238, 0.711% U-235, and 0.0053% U-234,
	-- so its activity comes roughly 49% each from U-234 and U-238
	-- and only 2% from U-235.  During enrichment via centrifuge,
	-- the U-234 fraction is concentrated along with the U-235, with
	-- the U-234:U-235 ratio remaining close to its original value.
	-- (Actually the U-234 gets separated from U-238 slightly more
	-- than the U-235 is, so the U-234:U-235 ratio is slightly
	-- higher in enriched uranium.)  A typical massic composition
	-- for 3.5%-fissile uranium is 96.47116% U-238, 3.5% U-235, and
	-- 0.02884% U-234.  This gives 3.5%-fissile uranium about 6.55
	-- times the activity of fully-depleted uranium.  The values we
	-- compute here for the "radioactive" group value are based on
	-- linear interpolation of activity along that scale, rooted at
	-- a natural (0.7%-fissile) uranium block having the activity of
	-- 9 uranium ore blocks (due to 9 ingots per block).  The group
	-- value is proportional to the square root of the activity, and
	-- uranium ore has radioactive=1.  This yields radioactive=1.0
	-- for a fully-depleted uranium block and radioactive=2.6 for
	-- a 3.5%-fissile uranium block.
	local radioactivity = math.floor(math.sqrt((1+5.55*p/35) * 18 / (1+5.55*7/35)) + 0.5);
	(ov or minetest.register_node)(block, {
		description = string.format(S("%.1f%%-Fissile Uranium Block"), p/10),
		tiles = {"technic_uranium_block.png"},
		is_ground_content = true,
		groups = {uranium_block=1, not_in_creative_inventory=nici,
			cracky=1, level=2, radioactive=radioactivity},
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

