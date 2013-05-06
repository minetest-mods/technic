technic.config = {}

technic.config.loaded = {}

technic.config.default = {
	enable_mining_drill = "true",
	enable_mining_laser = "true",
	enable_flashlight = "true",
	enable_item_drop = "true",
	enable_item_pickup = "true",
	enable_rubber_tree_generation = "true",
	enable_marble_generation = "true",
	enable_granite_generation = "true"
}

function technic.config:load(filename)
	file, error = io.open(filename, "r")
	if error then return end
	local line = file:read("*l")
	while line do
		local found, _, setting, value = line:find("^([^#%s=]+)%s?=%s?([^%s#]+)")
		if found then
			self.loaded[setting] = value
		end
		line = file:read("*l")
	end
	file:close()
end

technic.config:load(minetest.get_worldpath().."/technic.conf")

function technic.config:get(setting)
	if self.loaded[setting] then
		return self.loaded[setting]
	else
		return self.default[setting]
	end
end

function technic.config:getBool(setting)
	return string.lower(self:get(setting)) == "true"
end
