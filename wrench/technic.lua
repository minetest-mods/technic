
local INT, STRING, FLOAT  =
	wrench.META_TYPE_INT,
	wrench.META_TYPE_STRING,
	wrench.META_TYPE_FLOAT

wrench:register_node("technic:iron_chest", {
	lists = {"main"},
})
wrench:register_node("technic:iron_locked_chest", {
	lists = {"main"},
	metas = {infotext = STRING,
		owner = STRING},
	owned = true,
})
wrench:register_node("technic:copper_chest", {
	lists = {"main"},
})
wrench:register_node("technic:copper_locked_chest", {
	lists = {"main"},
	metas = {infotext = STRING,
		owner = STRING},
	owned = true,
})
wrench:register_node("technic:silver_chest", {
	lists = {"main"},
	metas = {infotext = STRING,
		formspec = STRING},
})
wrench:register_node("technic:silver_locked_chest", {
	lists = {"main"},
	metas = {infotext = STRING,
		owner = STRING,
		formspec = STRING},
	owned = true,
})
wrench:register_node("technic:gold_chest", {
	lists = {"main"},
	metas = {infotext = STRING,
		formspec = STRING},
})
wrench:register_node("technic:gold_locked_chest", {
	lists = {"main"},
	metas = {infotext = STRING,
		owner = STRING,
		formspec = STRING},
	owned = true,
})
wrench:register_node("technic:mithril_chest", {
	lists = {"main"},
	metas = {infotext = STRING,
		formspec = STRING},
})
wrench:register_node("technic:mithril_locked_chest", {
	lists = {"main"},
	metas = {infotext = STRING,
		owner = STRING,
		formspec = STRING},
	owned = true,
})
wrench:register_node("technic:lv_electric_furnace", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		src_time = INT},
})
wrench:register_node("technic:lv_electric_furnace_active", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_electric_furnace", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_electric_furnace_active", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:coal_alloy_furnace", {
	lists = {"fuel", "src", "dst"},
	metas = {infotext = STRING,
		fuel_totaltime = FLOAT,
		fuel_time = FLOAT,
		src_totaltime = FLOAT,
		src_time = FLOAT},
})
wrench:register_node("technic:coal_alloy_furnace_active", {
	lists = {"fuel", "src", "dst"},
	metas = {infotext = STRING,
		fuel_totaltime = FLOAT,
		fuel_time = FLOAT,
		src_totaltime = FLOAT,
		src_time = FLOAT},
})
wrench:register_node("technic:alloy_furnace", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:alloy_furnace_active", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_alloy_furnace", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_alloy_furnace_active", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:tool_workshop", {
	lists = {"src", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT},
})
wrench:register_node("technic:grinder", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		src_time = INT},
})
wrench:register_node("technic:grinder_active", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_grinder", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_grinder_active", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:extractor", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		src_time = INT},
})
wrench:register_node("technic:extractor_active", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_extractor", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_extractor_active", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:compressor", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		src_time = INT},
})
wrench:register_node("technic:compressor_active", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_compressor", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_compressor_active", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:cnc", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		src_time = INT,
		cnc_product = STRING},
})
wrench:register_node("technic:cnc_active", {
	lists = {"src", "dst"},
	metas = {infotext = STRING,
		formspec = STRING,
		LV_EU_demand = INT,
		LV_EU_input = INT,
		src_time = INT,
		cnc_product = STRING},
})
wrench:register_node("technic:mv_centrifuge", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})
wrench:register_node("technic:mv_centrifuge_active", {
	lists = {"src", "dst", "upgrade1", "upgrade2"},
	metas = {infotext = STRING,
		formspec = STRING,
		MV_EU_demand = INT,
		MV_EU_input = INT,
		tube_time = INT,
		src_time = INT},
})


local chest_mark_colors = {
	'_black',
	'_blue',
	'_brown',
	'_cyan',
	'_dark_green',
	'_dark_grey',
	'_green',
	'_grey',
	'_magenta',
	'_orange',
	'_pink',
	'_red',
	'_violet',
	'_white',
	'_yellow',
	'',
}

for i = 1, 15 do
	wrench:register_node("technic:gold_chest"..chest_mark_colors[i], {
		lists = {"main"},
		metas = {infotext = STRING,formspec = STRING},
	})
	wrench:register_node("technic:gold_locked_chest"..chest_mark_colors[i], {
		lists = {"main"},
		metas = {infotext = STRING,owner = STRING,formspec = STRING},
		owned = true,
	})
end

if minetest.get_modpath("technic") then
    for tier, _ in pairs(technic.machines) do
		local ltier = tier:lower()
		for i = 0, 8 do
			wrench:register_node("technic:"..ltier.."_battery_box"..i, {
				lists = {"src", "dst"},
				metas = {infotext = STRING,
					formspec = STRING,
					[tier.."_EU_demand"] = INT,
					[tier.."_EU_supply"] = INT,
					[tier.."_EU_input"] = INT,
					internal_EU_charge = INT,
					last_side_shown = INT},
			})
		end
	end
end

