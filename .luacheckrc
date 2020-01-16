unused_args = false

-- https://luacheck.readthedocs.io/en/stable/warnings.html
ignore = {
	"611", --whitespace
	"631", -- line too long
	"211", -- unused local
	"311", -- Value assigned to a local variable is unused.
	"113", -- undefined
	"121" -- read only global
}

globals = {
	"technic",
	"technic_cnc",
	"wrench"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump", "VoxelArea",
	"minetest", "default",

	-- deps
	"mesecon",
	"pipeworks",
	"monitoring",
	"intllib",
	"stairsplus",
	"unifieddyes",
	"digilines",
	"digiline_remote"
}
