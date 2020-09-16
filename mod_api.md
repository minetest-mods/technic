# technic API

This is an initial version of the API that can be used by mods.


 * `technic.register_tier(tier, description)`
    * Registers a network type (tier)
    * `tier`: string, short name (ex. `LV`)
    * `description`: string, long name (ex. `Low Voltage`)
 * `technic.register_machine(tier, nodename, machine_type)`
    * Registers a machine bound to the network tier
    * `tier`: see `register_tier`
    * `nodename`: string, node name
    * `machine_type`: string, following options are possible:
        * `"RE"`: Receiver
        * `"PR"`: Producer
        * `"BA"`: Battery, energy storage

