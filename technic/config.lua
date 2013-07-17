
local worldpath = minetest.get_worldpath()

technic.config = Settings(worldpath.."/technic.conf")

local conf_table = technic.config:to_table()

local defaults = {
	enable_mining_drill = "true",
	enable_mining_laser = "true",
	enable_flashlight = "true",
	enable_item_drop = "true",
	enable_item_pickup = "true",
	enable_rubber_tree_generation = "true",
	enable_marble_generation = "true",
	enable_granite_generation = "true",
}

for k, v in pairs(defaults) do
	if conf_table[k] == nil then
		technic.config:set(k, v)
	end
end

