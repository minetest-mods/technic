
# Technic digilines compatibility

This document describes the interaction of
technic machines with the `digilines` mod (https://github.com/minetest-mods/digilines)

## Switching station

**NOTE**: make sure the channel is set accordingly, "switch" in this case

There are two ways getting information from the switching station:
1. Give it a mesecon signal (eg. with a lever) and it will send always when the supply or demand changes.

2. Send to the switching station `"get"` or `"GET"` and it will send back.

The sent message is always a table containing the supply, demand and lag.

Example luacontroller code:
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

## Power monitor
The commands:
- `"get"`: The power monitor sends back information about the attached network
  - `"supply"`, `"demand"` and `"lag"`: Same as switching station
  - `"battery_count"`, `"battery_charge"` and `"battery_charge_max"`: Totaled information about the attached batteries.


## Supply Converter
You can send the following to it:
- `"get"`: It will send back a table containing the fields `"enabled"`, `"power"` and `"mesecon_mode"` which are all integers.
- `"off"`: Deactivate the supply converter.
- `"on"`: Activate the supply converter.
- `"toggle"`: Activate or deactivate the supply converter depending on its current state.
- `"power "..power`: Set the amount of the power, it shall convert.
- `"mesecon_mode "..<int>`: Set the mesecon mode.

## Battery Boxes
Send to it `"get"` or `"GET"` and it will send a table back containing:
- `demand`: A number.
- `supply`: A number.
- `input`: A number.
- `charge`: A number.
- `max_charge`: A number.
- `src`: Itemstack made to table.
- `dst`: Itemstack made to table.
- `upgrade1`: Itemstack made to table.
- `upgrade2`: Itemstack made to table.


## Forcefield Emitter
You should send a table to it containing the `command` and for some commands the `value` field.
Some strings will automatically be made to tables:
- `"get"` :arrow_right: `{command = "get"}`
- `"off"` :arrow_right: `{command = "off"}`
- `"on"` :arrow_right: `{command = "on"}`
- `"toggle"` :arrow_right: `{command = "toggle"}`
- `"range "..range` :arrow_right: `{command = "range", value = range}`
- `"shape "..shape` :arrow_right: `{command = "shape", value = shape}`

The commands:
- `"get"`: The forcefield emitter sends back a table containing:
  - `"enabled"`: `0` is off, `1` is on.
  - `"range"`
  - `"shape"`: `0` is spheric, `1` is cubic.
- `"off"`: Deactivate the forcefield emitter.
- `"on"`: Activate the forcefield emitter.
- `"toggle"`: Activate or deactivate the forcefield emitter depending on its current state.
- `"range"`: Set the range to `value`.
- `"shape"`: `value` can be a number (`0` or `1`) or a string (`"sphere"` or `"cube"`).


## Nuclear Reactor
Since the nuclear reactor core can't be accessed by digiline wire because the water layer which mustn't have a hole, you need the HV Digicables to interact with it.

You should send a table to it containing at least the `command` field and for some commands other fields.

The commands:
- `"get"`: The nuclear reactor sends back a table containing:
  - `"burn_time"`: The time in seconds how long the reactor already runs. One week after start, when it reaches 7 * 24 * 60 * 60 (=604800), the fuel is completely used.
  - `"enabled"`: A bool.
  - `"siren"`: A bool.
  - `"structure_accumulated_badness"`
  - `"rods"`: A table with 6 numbers in it, one for each fuel slot.
    -  A positive value is the count of fuel rods in the slot.
    - `0` means the slot is empty.
    -  A negative value means some other items are in the slot. The absolute value is the count of these items.
- `"self_destruct"`: A setting has to be enabled to use this. The reactor will melt down after `timer` seconds or instantly.
- `"start"`: Tries to start the reactor, `"Start successful"` is sent back on success, `"Error"` if something is wrong.

If the automatic start is enabled, it will always send `"fuel used"` when it uses fuel.


## Quarry
You should send a table to it containing the `command` and for some commands the `value` field.
Some strings will automatically be converted to tables:
- `"get"` :arrow_right: `{command = "get"}`
- `"on"` :arrow_right: `{command = "on"}`
- `"off"` :arrow_right: `{command = "off"}`
- `"restart` :arrow_right: `{command = "restart"}`
- `"radius "..value` :arrow_right: `{command = "radius", value = value}`

The commands:
- `"get"`: The forcefield emitter sends back a table containing:
  - `"enabled"`: `0` is off, `1` is on.
  - `"radius"`
  - `"finished"`
  - `"dug_nodes"`
  - `"dig_level"`: A negative value means above the quarry, a positive value means below.
- `"on"`: Activate the quarry.
- `"off"`: Deactivate the quarry.
- `"restart"`: Restart the quarry.
- `"radius"`: Set the radius to `value` and restart the quarry if the radius changed.
