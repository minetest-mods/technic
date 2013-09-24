
-- Create detached creative inventory after loading all mods
minetest.after(0.01, function()
	unified_inventory.items_list = {}
	for name, def in pairs(minetest.registered_items) do
		if (not def.groups.not_in_creative_inventory or
		   def.groups.not_in_creative_inventory == 0) and
		   def.description and def.description ~= "" then
			table.insert(unified_inventory.items_list, name)
			local recipes = minetest.get_all_craft_recipes(name)
			unified_inventory.crafts_table[name] = recipes or {}
		end
	end
	--print(dump(unified_inventory.crafts_table))
	table.sort(unified_inventory.items_list)
	unified_inventory.items_list_size = #unified_inventory.items_list
	print("Unified Inventory. inventory size: "..#unified_inventory.items_list)
end)


-- load_home
local function load_home()
	local input = io.open(unified_inventory.home_filename, "r")
	if input then
		while true do
			local x = input:read("*n")
			if x == nil then
				break
			end
			local y = input:read("*n")
			local z = input:read("*n")
			local name = input:read("*l")
			unified_inventory.home_pos[name:sub(2)] = {x = x, y = y, z = z}
		end
		io.close(input)
	else
		unified_inventory.home_pos = {}
	end
end
load_home()

function unified_inventory.set_home(player, pos)
	local player_name = player:get_player_name()
	unified_inventory.home_pos[player_name] = pos
	-- save the home data from the table to the file
	local output = io.open(unified_inventory.home_filename, "w")
	for k, v in pairs(unified_inventory.home_pos) do
		if v ~= nil then
			output:write(math.floor(v.x).." "
					..math.floor(v.y).." "
					..math.floor(v.z).." "
					..k.."\n")
		end
	end
	io.close(output)
end

function unified_inventory.go_home(player)
	local pos = unified_inventory.home_pos[player:get_player_name()]
	if pos ~= nil then
		player:setpos(pos)
	end
end

-- register_craft
function unified_inventory.register_craft(options)
	if not options.output then
		return
	end
	local itemstack = ItemStack(options.output)
	if itemstack:is_empty() then
		return
	end
	unified_inventory.crafts_table[itemstack:get_name()] =
			unified_inventory.crafts_table[itemstack:get_name()] or {}

	table.insert(unified_inventory.crafts_table[itemstack:get_name()], options)
end

function unified_inventory.register_page(name, def)
	unified_inventory.pages[name] = def
end

function unified_inventory.register_button(name, def)
	if not def.action then
		def.action = function(player)
			unified_inventory.set_inventory_formspec(player, name)
		end
	end
	
	def.name = name
	
	table.insert(unified_inventory.buttons, def)
end

function unified_inventory.is_creative(playername)
	if minetest.check_player_privs(playername, {creative=true}) or
	   minetest.setting_getbool("creative_mode") then
		return true
	end
end
