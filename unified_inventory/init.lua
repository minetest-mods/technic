-- Unified Inventory for Minetest 0.4.8+

local modpath = minetest.get_modpath(minetest.get_current_modname())
local worldpath = minetest.get_worldpath()

-- Data tables definitions
unified_inventory = {}
unified_inventory.activefilter = {}
unified_inventory.alternate = {}
unified_inventory.current_page = {}
unified_inventory.current_index = {}
unified_inventory.current_item = {}
unified_inventory.crafts_table = {}
unified_inventory.crafts_table_count = 0
unified_inventory.players = {}
unified_inventory.items_list_size = 0
unified_inventory.items_list = {}
unified_inventory.filtered_items_list_size = {}
unified_inventory.filtered_items_list = {}
unified_inventory.pages = {}
unified_inventory.buttons = {}

-- Homepos stuff
unified_inventory.home_pos = {}
unified_inventory.home_filename =
		worldpath.."/unified_inventory_home.home"
		
-- Default inventory page
unified_inventory.default = "craft"

-- Disable default creative inventory
if creative_inventory then 
	function creative_inventory.set_creative_formspec(player, start_i, pagenum)
		return
	end
end

dofile(modpath.."/api.lua")
dofile(modpath.."/internal.lua")
dofile(modpath.."/callbacks.lua")
dofile(modpath.."/register.lua")
dofile(modpath.."/bags.lua")
