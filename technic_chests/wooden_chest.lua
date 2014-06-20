local S
if intllib then
	S = intllib.Getter()
else
	S = function(s) return s end
end

if minetest.registered_nodes["default:chest"].description == "Chest" then
	minetest.override_item("default:chest", { description = S("%s Chest"):format(S("Wooden")) })
end

if minetest.registered_nodes["default:chest_locked"].description == "Locked Chest" then
	minetest.override_item("default:chest_locked", { description = S("%s Locked Chest"):format(S("Wooden")) })
end
