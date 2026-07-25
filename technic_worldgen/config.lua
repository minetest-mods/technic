technic_worldgen.config = technic_worldgen.config or
	Settings(core.get_worldpath().."/technic.conf")

local conf_table = technic_worldgen.config:to_table()

local defaults = {
	enable_granite_generation = true,
	enable_marble_generation = true,
	enable_rubber_tree_generation = true,
}

for k, v in pairs(defaults) do
	if conf_table[k] == nil then
		technic_worldgen.config:set(k, tostring(v))
	end
end
