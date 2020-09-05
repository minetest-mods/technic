
power generators
----------------

### fuel-fired generators ###

The fuel-fired generators are electrical power generators that generate
power by the combustion of fuel.  Versions of them are available for
all three voltages (LV, MV, and HV).  These are all capable of burning
any type of combustible fuel, such as coal.  They are relatively easy
to build, and so tend to be the first kind of generator used to power
electrical machines.  In this role they form an intermediate step between
the directly fuel-fired machines and a more mature electrical network
powered by means other than fuel combustion.  They are also, by virtue of
simplicity and controllability, a useful fallback or peak load generator
for electrical networks that normally use more sophisticated generators.

The MV and HV fuel-fired generators can accept fuel via pneumatic tube,
from any direction.

Keeping a fuel-fired generator fully fuelled is usually wasteful, because
it will burn fuel as long as it has any, even if there is no demand for
the electrical power that it generates.  This is unlike the directly
fuel-fired machines, which only burn fuel when they have work to do.
To satisfy intermittent demand without waste, a fuel-fired generator must
only be given fuel when there is either demand for the energy or at least
sufficient battery capacity on the network to soak up the excess energy.

The higher-tier fuel-fired generators get much more energy out of a
fuel item than the lower-tier ones.  The difference is much more than
is needed to overcome the inefficiency of supply converters, so it is
worth operating fuel-fired generators at a higher tier than the machines
being powered.

### solar generators ###

The solar generators are electrical power generators that generate power
from sunlight.  Versions of them are available for all three voltages
(LV, MV, and HV).  There are four types in total, two LV and one each
of MV and HV, forming a sequence of four tiers.  The higher-tier ones
are each built mainly from three solar generators of the next tier down,
and their outputs scale in rough accordance, tripling at each tier.

To operate, an arrayed solar generator must be at elevation +1 or above
and have a transparent block (typically air) immediately above it.
It will generate power only when the block above is well lit during
daylight hours.  It will generate more power at higher elevation,
reaching maximum output at elevation +36 or higher when sunlit.  The small
solar generator has similar rules with slightly different thresholds.
These rules are an attempt to ensure that the generator will only operate
from sunlight, but it is actually possible to fool them to some extent
with light sources such as meselamps.

### hydro generator ###

The hydro generator is an LV power generator that generates a respectable
amount of power from the natural motion of water.  To operate, the
generator must be horizontally adjacent to flowing water.  The power
produced is dependent on how much flow there is across any or all four
sides, the most flow of course coming from water that's flowing straight
down.

### geothermal generator ###

The geothermal generator is an LV power generator that generates a small
amount of power from the temperature difference between lava and water.
To operate, the generator must be horizontally adjacent to both lava
and water.  It doesn't matter whether the liquids consist of source
blocks or flowing blocks.

Beware that if lava and water blocks are adjacent to each other then the
lava will be solidified into stone or obsidian.  If the lava adjacent to
the generator is thus destroyed, the generator will stop producing power.
Currently, in the default Minetest game, lava is destroyed even if
it is only diagonally adjacent to water.  Under these circumstances,
the only way to operate the geothermal generator is with it adjacent
to one lava block and one water block, which are on opposite sides of
the generator.  If diagonal adjacency doesn't destroy lava, such as with
the gloopblocks mod, then it is possible to have more than one lava or
water block adjacent to the geothermal generator.  This increases the
generator's output, with the maximum output achieved with two adjacent
blocks of each liquid.

### wind generator ###

The wind generator is an MV power generator that generates a moderate
amount of energy from wind.  To operate, the generator must be placed
atop a column of at least 20 wind mill frame blocks, and must be at
an elevation of +30 or higher.  It generates more at higher elevation,
reaching maximum output at elevation +50 or higher.  Its surroundings
don't otherwise matter; it doesn't actually need to be in open air.

### nuclear generator ###

The nuclear generator (nuclear reactor) is an HV power generator that
generates a large amount of energy from the controlled fission of
uranium-235.  It must be fuelled, with uranium fuel rods, but consumes
the fuel quite slowly in relation to the rate at which it is likely to
be mined.  The operation of a nuclear reactor poses radiological hazards
to which some thought must be given.  Economically, the use of nuclear
power requires a high capital investment, and a secure infrastructure,
but rewards the investment well.

Nuclear fuel is made from uranium.  Natural uranium doesn't have a
sufficiently high proportion of U-235, so it must first be enriched
via centrifuge.  Producing one unit of 3.5%-fissile uranium requires
the input of five units of 0.7%-fissile (natural) uranium, and produces
four units of 0.0%-fissile (fully depleted) uranium as a byproduct.
It takes five ingots of 3.5%-fissile uranium to make each fuel rod, and
six rods to fuel a reactor.  It thus takes the input of the equivalent
of 150 ingots of natural uranium, which can be obtained from the mining
of 75 blocks of uranium ore, to make a full set of reactor fuel.

The nuclear reactor is a large multi-block structure.  Only one block in
the structure, the reactor core, is of a type that is truly specific to
the reactor; the rest of the structure consists of blocks that have mainly
non-nuclear uses.  The reactor core is where all the generator-specific
action happens: it is where the fuel rods are inserted, and where the
power cable must connect to draw off the generated power.

The reactor structure consists of concentric layers, each a cubical
shell, around the core.  Immediately around the core is a layer of water,
representing the reactor coolant; water blocks may be either source blocks
or flowing blocks.  Around that is a layer of stainless steel blocks,
representing the reactor pressure vessel, and around that a layer of
blast-resistant concrete blocks, representing a containment structure.
It is customary, though no longer mandatory, to surround this with a
layer of ordinary concrete blocks.  The mandatory reactor structure
makes a 7&times;7&times;7 cube, and the full customary structure a
9&times;9&times;9 cube.

The layers surrounding the core don't have to be absolutely complete.
Indeed, if they were complete, it would be impossible to cable the core to
a power network.  The cable makes it necessary to have at least one block
missing from each surrounding layer.  The water layer is only permitted
to have one water block missing of the 26 possible.  The steel layer may
have up to two blocks missing of the 98 possible, and the blast-resistant
concrete layer may have up to two blocks missing of the 218 possible.
Thus it is possible to have not only a cable duct, but also a separate
inspection hole through the solid layers.  The separate inspection hole
is of limited use: the cable duct can serve double duty.

Once running, the reactor core is significantly radioactive.  The layers
of reactor structure provide quite a lot of shielding, but not enough
to make the reactor safe to be around, in two respects.  Firstly, the
shortest possible path from the core to a player outside the reactor
is sufficiently short, and has sufficiently little shielding material,
that it will damage the player.  This only affects a player who is
extremely close to the reactor, and close to a face rather than a vertex.
The customary additional layer of ordinary concrete around the reactor
adds sufficient distance and shielding to negate this risk, but it can
also be addressed by just keeping extra distance (a little over two
meters of air).

The second radiological hazard of a running reactor arises from shine
paths; that is, specific paths from the core that lack sufficient
shielding.  The necessary cable duct, if straight, forms a perfect
shine path, because the cable itself has no radiation shielding effect.
Any secondary inspection hole also makes a shine path, along which the
only shielding material is the water of the reactor coolant.  The shine
path aspect of the cable duct can be ameliorated by adding a kink in the
cable, but this still yields paths with reduced shielding.  Ultimately,
shine paths must be managed either with specific shielding outside the
mandatory structure, or with additional no-go areas.

The radioactivity of an operating reactor core makes starting up a reactor
hazardous, and can come as a surprise because the non-operating core
isn't radioactive at all.  The radioactive damage is survivable, but it is
normally preferable to avoid it by some care around the startup sequence.
To start up, the reactor must have a full set of fuel inserted, have all
the mandatory structure around it, and be cabled to a switching station.
Only the fuel insertion requires direct access to the core, so irradiation
of the player can be avoided by making one of the other two criteria be
the last one satisfied.  Completing the cabling to a switching station
is the easiest to do from a safe distance.

Once running, the reactor will generate 100 kEU/s for a week (168 hours,
604800 seconds), a total of 6.048 GEU from one set of fuel.  After the
week is up, it will stop generating and no longer be radioactive.  It can
then be refuelled to run for another week.  It is not really intended
to be possible to pause a running reactor, but actually disconnecting
it from a switching station will have the effect of pausing the week.
This will probably change in the future.  A paused reactor is still
radioactive, just not generating electrical power.

A running reactor can't be safely dismantled, and not only because
dismantling the reactor implies removing the shielding that makes
it safe to be close to the core.  The mandatory parts of the reactor
structure are not just mandatory in order to start the reactor; they're
mandatory in order to keep it intact.  If the structure around the core
gets damaged, and remains damaged, the core will eventually melt down.
How long there is before meltdown depends on the extent of the damage;
if only one mandatory block is missing, meltdown will follow in 100
seconds.  While the structure of a running reactor is in a damaged state,
heading towards meltdown, a siren built into the reactor core will sound.
If the structure is rectified, the siren will signal all-clear.  If the
siren stops sounding without signalling all-clear, then it was stopped
by meltdown.

If meltdown is imminent because of damaged reactor structure, digging the
reactor core is not a way to avert it.  Digging the core of a running
reactor causes instant meltdown.  The only way to dismantle a reactor
without causing meltdown is to start by waiting for it to finish the
week-long burning of its current set of fuel.  Once a reactor is no longer
operating, it can be dismantled by ordinary means, with no special risks.

Meltdown, if it occurs, destroys the reactor and poses a major
environmental hazard.  The reactor core melts, becoming a hot, highly
radioactive liquid known as "corium".  A single meltdown yields a single
corium source block, where the core used to be.  Corium flows, and the
flowing corium is very destructive to whatever it comes into contact with.
Flowing corium also randomly solidifies into a radioactive solid called
"Chernobylite".  The random solidification and random destruction of
solid blocks means that the flow of corium is constantly changing.
This combined with the severe radioactivity makes corium much more
challenging to deal with than lava.  If a meltdown is left to its own
devices, it gets worse over time, as the corium works its way through
the reactor structure and starts to flow over a variety of paths.
It is best to tackle a meltdown quickly; the priority is to extinguish
the corium source block, normally by dropping gravel into it.  Only the
most motivated should attempt to pick up the corium in a bucket.
