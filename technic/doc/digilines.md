
# Technic digilines compatibility

This document describes the interaction of
technic machines with the `digilines` mod (https://github.com/minetest-mods/digilines)

## Switching station

**NOTE**: make sure the channel is set accordingly, "switch" in this case

Get power and lag stats:
```lua
if event.type == "program" then
	-- start interrupt cycle
	interrupt(1)
end

if event.type == "interrupt" then
	-- request stats
	digiline_send("switch", "GET")
end

if event.type == "digiline" and event.channel == "switch" then
	--[[
	event.msg = {
		demand = 0, -- demand in EU's
		supply = 0, -- supply in EU's
		lag = 0 -- generated lag in microseconds
	}
	--]]
end
```
