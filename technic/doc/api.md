# technic API

This file documents the functions within the technic modpack for use in mods.

[Switch to plaintext format](https://raw.githubusercontent.com/minetest-mods/technic/master/technic/doc/api.md)

**Undocumented API may change at any time.**


## Tiers
Tier are network types. List of pre-registered tiers:

* `"LV"`, Low Voltage
* `"MV"`, Medium Voltage
* `"HV"`, High Voltage

Available functions:

* `technic.register_tier(tier, description)`
	* Registers a network type (tier)
	* `tier`: string, short name (ex. `LV`)
	* `description`: string, long name (ex. `Low Voltage`)
	* See also `tiers`


## Cables
* `technic.register_cable(tier, size)`
	* Registers an existing node as cable
	* `tier`: string
	* `size`: number, visual size of the wire
* `technic.get_cable_tier(nodename)`
	* Retrieves the tier assigned to the provided node name
	* `nodename`: string, name of the node
	* Returns the tier (string) or `nil`
* `technic.is_tier_cable(nodename, tier)`
	* Tells whether the node `nodename` is the cable of the tier `tier`.
	* Short version of `technic.get_cable_tier(nodename) == tier`


## Machines
The machine type indicates the direction of power flow.
List of pre-registered machine types:

* `technic.receiver = "RE"`: consumes energy. e.g. grinder
* `technic.producer = "PR"`: provides energy. e.g. solar panel
* `technic.producer_receiver = "PR_RE"` supply converter
* `technic.battery  = "BA"`: stores energy. e.g. LV battery box

Available functions:

* `technic.register_base_machine(data)`
	* Registers a new node and defines the underlying machine behaviour. `data` fields:
	* `tier`: string, see #Tiers
	* `typename`: string, equivalent to the processing type registered
	  by `technic.register_recipe`. Examples: `"cooking"` `"alloy"`
	* `machine_name`: string, node name
	* `machine_desc`: string, node description
	* `demand`: table, EU consumption values for each upgrade level.
	  Up to three indices. Index 1 == no upgrade. Example: `{3000, 2000, 1000}`.
	* `upgrade`: (boolean), whether to add upgrade slots
	* `modname`: (string), mod origin
	* `tube`: (boolean), whether the machine has Pipeworks connectivity
	* `can_insert`: (func), see Pipeworks documentation
		* Accepts all inputs by default, if `tube = 1`
		* See also: `technic.can_insert_unique_stack`
	* `insert_object`: (func), see Pipeworks documentation
		* Accepts all inputs by default, if `tube = 1`
		* See also: `technic.insert_object_unique_stack`
	* `connect_sides`: (table), see Lua API documentation. Defaults to all directions but front.
* `technic.register_machine(tier, nodename, machine_type)`
	* Register an existing node as machine, bound to the network tier
	* `tier`: string, see #Tiers
	* `nodename`: string, node name
	* `machine_type`: string, following options are possible:
		* `technic.receiver = "RE"`: Consumes energy
		* `technic.producer = "PR"`: Provides energy
		* `technic.battery = "BA"`: Energy storage
	* See also `Machine types`

Callbacks for pipeworks item transfer:

* `technic.can_insert_unique_stack(pos, node, stack, direction)`
* `technic.insert_object_unique_stack(pos, node, stack, direction)`
	* Functions for the parameters `can_insert` and `insert_object` to avoid
	  filling multiple inventory slots with same type of item.

### Recipes

* `technic.register_recipe_type(typename, recipedef)`
	* Registers a new recipe type used for machine processing
	* `typename`: string, name of the recipe type
	* Fields of `recipedef`:
		* `description`: string, descriptor of the recipe type
		* `input_size`: (numeric), count of input ItemStacks. default 1
		* `output_size`: (numeric), count of output ItemStacks. default 1
* `technic.register_recipe(recipe)`
	* Registers a individual input/output recipe. Fields of `recipe`:
	* `input`: table, integer-indexed list of input ItemStacks.
	* `output`: table/ItemStack, single output or list of output ItemStacks.
	* `time`: numeric, process time in seconds.
* `technic.get_recipe(typename, items)`
	* `typename`: string, see `technic.register_recipe_type`
	* `items`: table, integer-indexed list of input ItemStacks.
	* Returns: `recipe` table on success, `nil` otherwise


The following functions can be used to register recipes for
a specific machine type:

* Centrifuge
	* `technic.register_separating_recipe(recipe)`
* Compressor
	* `technic.register_compressor_recipe(recipe)`
* Furnaces (electric, normal)
	* `minetest.register_recipe(recipe)`
* Extractor
	* `technic.register_extractor_recipe(recipe)`
* Freezer
	* `technic.register_freezer_recipe(recipe)`
* Grinder
	* `technic.register_grinder_recipe(recipe)`


## Tools
* `technic.register_power_tool(itemname, max_charge)`
	* Register or configure the maximal charge held by an existing item
	* `craftitem`: string, item or node name
	* `max_charge`: number, maximal EU capacity


## Helper functions
Unsorted functions:

* `technic.EU_string(num)`
	* Converts num to a human-readable string (see `pretty_num`)
	  and adds the `EU` unit
	* Use this function when showing players energy values
* `technic.pretty_num(num)`
	* Converts the number `num` to a human-readable string with SI prefixes
* `technic.config:get(name)`
	* Some configuration function
* `technic.tube_inject_item(pos, start_pos, velocity, item)`
	* Same as `pipeworks.tube_inject_item`

### Energy modifiers
* `technic.set_RE_wear(itemstack, item_load, max_charge)`
	* Modifies the power tool wear of the given itemstack
	* `itemstack`: ItemStack to modify
	* `item_load`: number, used energy in EU
	* `max_charge`: number, maximal EU capacity of the tool
	* The itemdef field `wear_represents` must be set to `"technic_RE_charge"`,
	  otherwise this function will do nothing.
	* Returns the modified itemstack
* `technic.refill_RE_charge(itemstack)`
	* This function fully recharges an RE chargeable item.
	* If `technic.power_tools[itemstack:get_name()]` is `nil` (or `false`), this
	  function does nothing, else that value is the maximum charge.
	* The itemstack metadata is changed to contain the charge.

### Node-specific
* `technic.get_or_load_node(pos)`
	* If the mapblock is loaded, it returns the node at pos,
	  else it loads the chunk and returns `nil`.
* `technic.swap_node(pos, nodename)`
	* Same as `mintest.swap_node` but it only changes the nodename.
	* It uses `minetest.get_node` before swapping to ensure the new nodename
	  is not the same as the current one.
* `technic.trace_node_ray(pos, dir, range)`
	* Returns an iteration function (usable in the for loop) to iterate over the
	  node positions along the specified ray.
	* The returned positions will not include the starting position `pos`.
* `technic.trace_node_ray_fat(pos, dir, range)`
	* Like `technic.trace_node_ray` but includes extra positions near the ray.
	* The node ray functions are used for mining lasers.


## Item Definition fields
Groups:

* `technic_<tier> = 1`
	* Makes the node connect to the cables of the matching tier name
	* `<tier>`: name of the tier, in lowercase (ex. `lv`)
* `technic_machine = 1`
	* UNRELIABLE. Indicates whether the item or node belongs to technic
* `connect_sides = {"top", "left", ...}`
	* Extends the Minetest API. Indicates where the machine can be connected.

Additional definition fields:

* `<itemdef>.wear_represents = "string"`
	* Specifies how the tool wear level is handled. Available modes:
		* `"mechanical_wear"`: represents physical damage
		* `"technic_RE_charge"`: represents electrical charge
* `<itemdef>.technic_run = function(pos, node) ...`
	* This callback is used to update the node.
	  Modders have to manually change the information about supply etc. in the
	  node metadata.
	* Technic-registered machines use this callback by default.
* `<itemdef>.technic_disabled_machine_name = "string"`
	* Specifies the machine's node name to use when it's not connected connected to a network
* `<itemdef>.technic_on_disable = function(pos, node) ...`
	* This callback is run when the machine is no longer connected to a technic-powered network.
* `<itemdef>.technic_get_charge = function(itemstack) ...`
	* Optional callback to overwrite the default charge behaviour.
	* `itemstack`: ItemStack, the tool to analyse
	* Return values:
		* `charge`: Electrical charge of the tool
		* `max_charge`: Upper charge limit
	* Etc. `local charge, maxcharge = itemdef.technic_get_charge(itemstack)`
* `<itemdef>.technic_set_charge = function(itemstack, charge) ...`
	* Optional callback to overwrite the default charge behaviour.
	* `itemstack`: ItemStack, the tool to update
	* `charge`: numeric, value between `0` and `max_charge`


## Node Metadata fields
Nodes connected to the network will have one or more of these parameters as meta
data:

* `<tier>_EU_supply` - direction: output
	* For nodes registered as `PR` or `BA` tier
	* This is the EU value supplied by the node.
* `<tier>_EU_demand` - direction: output
	* For nodes registered as `RE` or `BA` tier
	* This is the EU value the node requires to run.
* `<tier>_EU_input` - direction: input
	* For nodes registered as `RE` or `BA` tier
	* This is the actual EU value the network can give the node.

`<tier>` corresponds to the tier name registered using
`technic.register_tier` (ex. `LV`). It is possible for the machine to depend on
multiple tiers (or networks).


## Manual: Network basics

The switching station is the center of all power distribution on an electric
network. This node is used to calculate the power supply of the network and
to distribute the power across nodes.

The switching station is the center of all electricity distribution. It collects
power from sources (PR), distributes it to sinks (RE), and uses the
excess/shortfall to charge and discharge batteries (BA).

As a thumb of rule, "EU" (energy unit) values are expressed in kW.

Network functionality:

1. All PR, BA, RE nodes are indexed and tagged with one switching station.
   The tagging is a workaround to allow more stations to be built without allowing
   a cheat with duplicating power.
2. All the RE nodes are queried for their current EU demand.
   If the total demand is less than the available power they are all updated
   with the demand number.
3. BA nodes are evenly charged from energy surplus.
4. Excess power draw will discharge batteries evenly.
5. If the total demand is more than the available power all RE nodes will be shut
   down. We have a brown-out situation.

## Deprecated functions

Following functions are either no longer used by technic, or are planned to
be removed soon. Please update mods depending on technic accordingly.

 * `technic.get_RE_item_load`
    * Scales the tool wear to a certain numeric range
 * `technic.set_RE_item_load`
    * Scales a certain numeric range to the tool wear
