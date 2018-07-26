This file is fairly incomplete. Help is welcome.

Tiers
-----
The tier is a string, currently `"LV"`, `"MV"` and `"HV"` are supported.

Network
-------
The network is the cable with the connected machine nodes. Currently the
switching station handles the network activity.

Helper functions
----------------
* `technic.EU_string(num)`
	* Converts num to a human-readable string (see pretty_num)
	  and adds the `EU` unit
	* Use this function when showing players energy values
* `technic.pretty_num(num)`
	* Converts the number `num` to a human-readable string with SI prefixes
* `technic.swap_node(pos, nodename)`
	* Same as `mintest.swap_node` but it only changes the nodename.
	* It uses `minetest.get_node` before swapping to ensure the new nodename
	  is not the same as the current one.
* `technic.get_or_load_node(pos)`
	* If the mapblock is loaded, it returns the node at pos,
	  else it loads the chunk and returns `nil`.
* `technic.set_RE_wear(itemstack, item_load, max_charge)`
	* If the `wear_represents` field in the item's nodedef is
	  `"technic_RE_charge"`, this function does nothing.
* `technic.refill_RE_charge(itemstack)`
	* This function fully recharges an RE chargeable item.
	* If `technic.power_tools[itemstack:get_name()]` is `nil` (or `false`), this
	  function does nothing, else that value is the maximum charge.
	* The itemstack metadata is changed to contain the charge.
* `technic.is_tier_cable(nodename, tier)`
	* Tells whether the node `nodename` is the cable of the tier `tier`.
* `technic.get_cable_tier(nodename)`
	* Returns the tier of the cable `nodename` or `nil`.
* `technic.trace_node_ray(pos, dir, range)`
	* Returns an iteration function (usable in the for loop) to iterate over the
	  node positions along the specified ray.
	* The returned positions will not include the starting position `pos`.
* `technic.trace_node_ray_fat(pos, dir, range)`
	* Like `technic.trace_node_ray` but includes extra positions near the ray.
	* The node ray functions are used for mining lasers.
* `technic.config:get(name)`
	* Some configuration function
* `technic.tube_inject_item(pos, start_pos, velocity, item)`
	* Same as `pipeworks.tube_inject_item`

Registration functions
----------------------
* `technic.register_power_tool(itemname, max_charge)`
	* Same as `technic.power_tools[itemname] = max_charge`
	* This function makes the craftitem `itemname` chargeable.
* `technic.register_machine(tier, nodename, machine_type)`
	* Same as `technic.machines[tier][nodename] = machine_type`
	* Currently this is requisite to make technic recognize your node.
	* See also `Machine types`
* `technic.register_tier(tier)`
	* Same as `technic.machines[tier] = {}`
	* See also `tiers`

### Specific machines
* `technic.register_solar_array(data)`
	* data is a table

Used itemdef fields
-------------------
* groups:
	* `technic_<ltier> = 1` ltier is a tier in small letters; this group makes
	  the node connect to the cable(s) of the right tier.
	* `technic_machine = 1` Currently used for
* `connect_sides`
	* In addition to the default use (see lua_api.txt), this tells where the
	  machine can be connected.
#
#
* `technic_run(pos, node)`
	* This function is currently used to update the node.
	  Modders have to manually change the information about supply etc. in the
	  node metadata.

Machine types
-------------
There are currently following types:
* `technic.receiver = "RE"` e.g. grinder
* `technic.producer = "PR"` e.g. solar panel
* `technic.producer_receiver = "PR_RE"` supply converter
* `technic.battery  = "BA"` e.g. LV batbox

Switching Station
-----------------
The switching station is the center of all power distribution on an electric
network.

The station collects power from sources (PR), distributes it to sinks (RE),
and uses the excess/shortfall to charge and discharge batteries (BA).

For now, all supply and demand values are expressed in kW.

It works like this:
 All PR,BA,RE nodes are indexed and tagged with the switching station.
The tagging is a workaround to allow more stations to be built without allowing
a cheat with duplicating power.
 All the RE nodes are queried for their current EU demand. Those which are off
would require no or a small standby EU demand, while those which are on would
require more.
If the total demand is less than the available power they are all updated with
the demand number.
If any surplus exists from the PR nodes the batteries will be charged evenly
with this.
If the total demand requires draw on the batteries they will be discharged
evenly.

If the total demand is more than the available power all RE nodes will be shut
down. We have a brown-out situation.

Hence for now all the power distribution logic resides in this single node.

### Node meta usage
Nodes connected to the network will have one or more of these parameters as meta
data:
	* `<LV|MV|HV>_EU_supply` : Exists for PR and BA node types.
	This is the EU value supplied by the node. Output
	* `<LV|MV|HV>_EU_demand` : Exists for RE and BA node types.
	This is the EU value the node requires to run. Output
	* `<LV|MV|HV>_EU_input`  : Exists for RE and BA node types.
	This is the actual EU value the network can give the node. Input

The reason the LV|MV|HV type is prepended to meta data is because some machine
could require several supplies to work.
This way the supplies are separated per network.
