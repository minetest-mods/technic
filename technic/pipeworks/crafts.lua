-- Crafting recipes for pipeworks

-- If the technic mod is present, then don't bother registering these recipes
-- as that mod supplies its own.

if io.open(minetest.get_modpath("pipeworks").."/../technic/init.lua", "r") == nil then

	-- If homedecor is not installed, we need to register a few of its crafts
	-- manually so we can use them.

	if minetest.get_modpath("homedecor") == nil then

		minetest.register_craftitem(":homedecor:plastic_sheeting", {
			description = "Plastic sheet",
			inventory_image = "pipeworks_plastic_sheeting.png",
		})

		minetest.register_craft({
		        type = "cooking",
		        output = "homedecor:plastic_sheeting",
		        recipe = "default:junglegrass",
		})

		minetest.register_craft({
		        type = 'fuel',
		        recipe = 'homedecor:plastic_sheeting',
		        burntime = 30,
		})
	end

	minetest.register_craft( {
	        output = "pipeworks:pipe_110000_empty 12",
	        recipe = {
	                { "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
	                { "", "", "" },
	                { "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" }
	        },
	})

	minetest.register_craft( {
	        output = "pipeworks:pump 2",
	        recipe = {
	                { "default:stone", "default:stone", "default:stone" },
	                { "default:steel_ingot", "default:stick", "default:steel_ingot" },
	                { "default:stone", "default:stone", "default:stone" }
	        },
	})

	minetest.register_craft( {
	        output = "pipeworks:valve 2",
	        recipe = {
	                { "", "default:stick", "" },
	                { "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
	                { "", "default:steel_ingot", "" }
	        },
	})

	minetest.register_craft( {
	        output = "pipeworks:storage_tank 2",
	        recipe = {
	                { "", "default:steel_ingot", "default:steel_ingot" },
	                { "default:steel_ingot", "default:glass", "default:steel_ingot" },
	                { "default:steel_ingot", "default:steel_ingot", "" }
	        },
	})

	minetest.register_craft( {
	        output = "pipeworks:intake 2",
	        recipe = {
	                { "", "default:steel_ingot", "" },
	                { "default:steel_ingot", "", "default:steel_ingot" },
	                { "", "default:steel_ingot", "" }
	        },
	})

	minetest.register_craft( {
	        output = "pipeworks:outlet 2",
	        recipe = {
	                { "default:steel_ingot", "", "default:steel_ingot" },
	                { "", "default:steel_ingot", "" },
	                { "default:steel_ingot", "", "default:steel_ingot" }
	        },
	})

	minetest.register_craft( {
		output = "pipeworks:tube 12",
		recipe = {
		        { "homedecor:plastic_sheeting", "homedecor:plastic_sheeting", "homedecor:plastic_sheeting" },
		        { "", "", "" },
		        { "homedecor:plastic_sheeting", "homedecor:plastic_sheeting", "homedecor:plastic_sheeting" }
		},
	})

end
