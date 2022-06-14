# Technic User Manual

The technic modpack extends Minetest Game (shipped with Minetest by default)
with many new elements, mainly constructable machines and tools. This manual
describes how to use the modpack, mainly from a player's perspective.

Documentation of the mod dependencies can be found here:

*   [Minetest Game Documentation](https://wiki.minetest.net/Main_Page)
*   [Mesecons Documentation](http://mesecons.net/items.html)
*   [Pipeworks Documentation](https://github.com/mt-mods/pipeworks/wiki/)
*   [Moreores Forum Post](https://forum.minetest.net/viewtopic.php?t=549)
*   [Basic materials Repository](https://gitlab.com/VanessaE/basic_materials)

## 1.0 Recipes

Recipes for items registered by technic are not specifically documented here.
Please consult a craft guide mod to look up the recipes in-game.

**Recommended mod:** [Unified Inventory](https://github.com/minetest-mods/unified_inventory)

## 2.0 Substances

### 2.1 Ores

Technic registers a few ores which are needed to craft machines or items.
Each ore type is found at a specific range of elevations so you will
ultimately need to mine at more than one elevation to find all the ores.

Elevation (Y axis) is measured in meters. The reference is usually at sea
level. Ores can generally be found more commonly by going downwards to -1000m.

Note ¹: *These ores are provided by Minetest Game. See [Ores](https://wiki.minetest.net/Ores#Ores_overview) for a rough overview*

Note ²: *These ores are provided by moreores. TODO: Add reference link*

#### Coal ¹
Use: Fuel, alloy as carbon

Burning coal is a way to generate electrical power. Coal is also used,
usually in dust form, as an ingredient in alloying recipes, wherever
elemental carbon is required.

#### Iron ¹
Use: multiple, mainly for alloys with carbon (coal).

#### Copper ¹
Copper is a common metal, used either on its own for its electrical
conductivity, or as the base component of alloys.
Although common, it is very heavily used, and most of the time it will
be the material that most limits your activity.

#### Tin ¹
Use: batteries, bronze

Tin is a common metal but is used rarely. Its abundance is well in excess
of its usage, so you will usually have a surplus of it.

#### Zinc
Use: brass

Generated below: 2m, more commonly below -32m

Zinc only has a few uses but is a common metal.

#### Chromium
Use: stainless steel

Generated below: -100m, more commonly below -200m

#### Uranium
Use: nuclear reactor fuel

Depth: -80m until -300m, more commonly between -100m and -200m

It is a moderately common metal, useful only for reasons related to radioactivity:
it forms the fuel for nuclear reactors, and is also one of the best radiation
shielding materials available.

Keep a safety distance of a meter to avoid being harmed by radiation.

#### Silver ²
Use: conductors

Generated below: -2m, evenly common

Silver is a semi-precious metal and is the best conductor of all the pure elements.

#### Gold ¹
Use: various

Generated below: -64m, more commonly below -256m

Gold is a precious metal. It is most notably used in electrical items due to
its combination of good conductivity and corrosion resistance.

#### Mithril ²
Use: chests

Generated below: -512m, evenly common

Mithril is a fictional ore, being derived from J. R. R. Tolkien's
Middle-Earth setting.  It is little used.

#### Mese ¹
Use: various

Mese is a precious gemstone, and unlike diamond it is entirely fictional.
It is used in small quantities, wherever some magic needs to be imparted.

#### Diamond ¹
Use: mainly for cutting machines

Diamond is a precious gemstone. It is used moderately, mainly for reasons
connected to its extreme hardness.

### 2.2 Rocks

This section describes the rock types added by technic. Further rock types
are supported by technic machines. These can be processed using the grinder:

 * Stone (plain)
 * Cobblestone
 * Desert Stone

#### Marble
Depth: -50m, evenly common

Marble is found in dense clusters and has mainly decorative use, but also
appears in one machine recipe.

#### Granite
Depth: -150m, evenly common

Granite is found in dense clusters and is much harder to dig than standard
stone. It has mainly decorative use, but also appears in a couple of
machine recipes.

### 2.3 Rubber
Rubber is a biologically-derived material that has industrial uses due
to its electrical resistivity and its impermeability.  In technic, it
is used in a few recipes, and it must be acquired by tapping rubber trees.

Rubber trees are provided by technic if the moretrees mod is not present.

Extract raw latex from rubber using the "Tree Tap" tool. Punch/left-click the
tool on a rubber tree trunk to extract a lump of raw latex from the trunk.
Emptied trunks will regenerate at intervals of several minutes, which can be
observed by its appearance.

To obtain rubber from latex, alloy latex with coal dust.

## 3.0 Metal processing
Generally, each metal can exist in five forms:

 * ore -> stone containing the lump
 * lump -> draw metal obtained by digging ("nuggets")
 * dust -> grinder output
 * ingot -> melted/cooked lump or dust
 * block -> placeable node

Metals can be converted between dust, ingot and block, but can't be converted
from them back to ore or lump forms.

### Grinding
Ores can be processed as follows:

 * ore -> lump (digging) -> ingot (melting)
 * ore -> lump (digging) -> 2x dust (grinding) -> 2x ingot (melting)

At the expense of some energy consumption, the grinder can extract more material
from the lump, resulting in 2x dust which can be melted to two ingots in total.

### Alloying
Input: two ingredients of the same form - lump or dust

Output: resulting alloy, as an ingot

Example: 2x copper ingots + 1x zinc ingot -> 3x brass ingot (alloying)

Note that grinding before alloying is the preferred method to gain more output.

#### iron and its alloys

Historically iron was the first metal whose working required processes of any
metallurgical sophistication. The mod's mechanics around iron broadly imitate
the historical progression of processes around it to get more variety.

Notable alloys:

 * Wrought iron: <0.25% carbon
     * Resists shattering but is relatively soft.
     * Known since: 1800 BC (approx.)
 * Cast iron: 2.1% to 4% carbon.
     * Especially hard and rather corrosion-resistant
     * Known since: 1200 BC (approx.)
 * Carbon steel: 0.25% to 2.1% carbon.
     * Intermediate of the two above.
     * Known since: 1600 AD (approx.)

Technic introduces a distinction based on the carbon content, and renames some
items of the basic game accordingly. Iron and Steel are now distinguished.

Notable references:

 * https://en.wikipedia.org/wiki/Iron
 * https://en.wikipedia.org/wiki/Stainless_steel
 * ... plus many more.

Processes:

 * Iron -> Wrought iron (melting)
 * Wrought iron -> Cast iron (melting)
 * Wrought iron + coal dust -> Carbon steel (alloying)
 * Carbon steel + coal dust -> Cast iron (alloying)
 * Carbon steel + chromium -> Stainless steel (alloying)

Reversible processes:

 * Cast iron -> Wrought iron (melting)
 * Carbon steel -> Wrought iron (melting)

Check your preferred crafting guide for more information.


### Uranium enrichment

When uranium is to be used to fuel a nuclear reactor, it is not
sufficient to merely isolate and refine uranium metal.  It is necessary
to control its isotopic composition, because the different isotopes
behave differently in nuclear processes.

The main isotopes of interest are U-235 and U-238.  U-235 is good at
sustaining a nuclear chain reaction, because when a U-235 nucleus is
bombarded with a neutron it will usually fission (split) into fragments.
It is therefore described as "fissile".  U-238, on the other hand,
is not fissile: if bombarded with a neutron it will usually capture it,
becoming U-239, which is very unstable and quickly decays into semi-stable
(and fissile) plutonium-239.

Inconveniently, the fissile U-235 makes up only about 0.7% of natural
uranium, almost all of the other 99.3% being U-238.  Natural uranium
therefore doesn't make a great nuclear fuel.  (In real life there are
a small number of reactor types that can use it, but technic doesn't
have such a reactor.)  Better nuclear fuel needs to contain a higher
proportion of U-235.

Achieving a higher U-235 content isn't as simple as separating the U-235
from the U-238 and just using the required amount of U-235.  Because
U-235 and U-238 are both uranium, and therefore chemically identical,
they cannot be chemically separated, in the way that different elements
are separated from each other when refining metal.  They do differ
in atomic mass, so they can be separated by centrifuging, but because
their atomic masses are very close, centrifuging doesn't separate them
very well.  They cannot be separated completely, but it is possible to
produce uranium that has the isotopes mixed in different proportions.
Uranium with a significantly larger fissile U-235 fraction than natural
uranium is called "enriched", and that with a significantly lower fissile
fraction is called "depleted".

A single pass through a centrifuge produces two output streams, one with
a fractionally higher fissile proportion than the input, and one with a
fractionally lower fissile proportion.  To alter the fissile proportion
by a significant amount, these output streams must be centrifuged again,
repeatedly.  The usual arrangement is a "cascade", a linear arrangement
of many centrifuges.  Each centrifuge takes as input uranium with some
specific fissile proportion, and passes its two output streams to the
two adjacent centrifuges.  Natural uranium is input somewhere in the
middle of the cascade, and the two ends of the cascade produce properly
enriched and depleted uranium.

Fuel for technic's nuclear reactor consists of enriched uranium of which
3.5% is fissile.  (This is a typical value for a real-life light water
reactor, a common type for power generation.)  To enrich uranium in the
game, it must first be in dust form: the centrifuge will not operate
on ingots.  (In real life uranium enrichment is done with the uranium
in the form of a gas.)  It is best to grind uranium lumps directly to
dust, rather than cook them to ingots first, because this yields twice
as much metal dust.  When uranium is in refined form (dust, ingot, or
block), the name of the inventory item indicates its fissile proportion.
Uranium of any available fissile proportion can be put through all the
usual processes for metal.

A single centrifuge operation takes two uranium dust piles, and produces
as output one dust pile with a fissile proportion 0.1% higher and one with
a fissile proportion 0.1% lower.  Uranium can be enriched up to the 3.5%
required for nuclear fuel, and depleted down to 0.0%.  Thus a cascade
covering the full range of fissile fractions requires 34 cascade stages.
(In real life, enriching to 3.5% uses thousands of cascade stages.
Also, centrifuging is less effective when the input isotope ratio
is more skewed, so the steps in fissile proportion are smaller for
relatively depleted uranium.  Zero fissile content is only asymptotically
approachable, and natural uranium relatively cheap, so uranium is normally
only depleted to around 0.3%.  On the other hand, much higher enrichment
than 3.5% isn't much more difficult than enriching that far.)

Although centrifuges can be used manually, it is not feasible to perform
uranium enrichment by hand.  It is a practical necessity to set up
an automated cascade, using pneumatic tubes to transfer uranium dust
piles between centrifuges.  Because both outputs from a centrifuge are
ejected into the same tube, sorting tubes are needed to send the outputs
in different directions along the cascade.  It is possible to send items
into the centrifuges through the same tubes that take the outputs, so the
simplest version of the cascade structure has a line of 34 centrifuges
linked by a line of 34 sorting tube segments.

Assuming that the cascade depletes uranium all the way to 0.0%,
producing one unit of 3.5%-fissile uranium requires the input of five
units of 0.7%-fissile (natural) uranium, takes 490 centrifuge operations,
and produces four units of 0.0%-fissile (fully depleted) uranium as a
byproduct.  It is possible to reduce the number of required centrifuge
operations by using more natural uranium input and outputting only
partially depleted uranium, but (unlike in real life) this isn't usually
an economical approach.  The 490 operations are not spread equally over
the cascade stages: the busiest stage is the one taking 0.7%-fissile
uranium, which performs 28 of the 490 operations.  The least busy is the
one taking 3.4%-fissile uranium, which performs 1 of the 490 operations.

A centrifuge cascade will consume quite a lot of energy.  It is
worth putting a battery upgrade in each centrifuge.  (Only one can be
accommodated, because a control logic unit upgrade is also required for
tube operation.)  An MV centrifuge, the only type presently available,
draws 7 kEU/s in this state, and takes 5 s for each uranium centrifuging
operation.  It thus takes 35 kEU per operation, and the cascade requires
17.15 MEU to produce each unit of enriched uranium.  It takes five units
of enriched uranium to make each fuel rod, and six rods to fuel a reactor,
so the enrichment cascade requires 514.5 MEU to process a full set of
reactor fuel.  This is about 0.85% of the 6.048 GEU that the reactor
will generate from that fuel.

If there is enough power available, and enough natural uranium input,
to keep the cascade running continuously, and exactly one centrifuge
at each stage, then the overall speed of the cascade is determined by
the busiest stage, the 0.7% stage.  It can perform its 28 operations
towards the enrichment of a single uranium unit in 140 s, so that is
the overall cycle time of the cascade.  It thus takes 70 min to enrich
a full set of reactor fuel.  While the cascade is running at this full
speed, its average power consumption is 122.5 kEU/s.  The instantaneous
power consumption varies from second to second over the 140 s cycle,
and the maximum possible instantaneous power consumption (with all 34
centrifuges active simultaneously) is 238 kEU/s.  It is recommended to
have some battery boxes to smooth out these variations.

If the power supplied to the centrifuge cascade averages less than
122.5 kEU/s, then the cascade can't run continuously.  (Also, if the
power supply is intermittent, such as solar, then continuous operation
requires more battery boxes to smooth out the supply variations, even if
the average power is high enough.)  Because it's automated and doesn't
require continuous player attention, having the cascade run at less
than full speed shouldn't be a major problem.  The enrichment work will
consume the same energy overall regardless of how quickly it's performed,
and the speed will vary in direct proportion to the average power supply
(minus any supply lost because battery boxes filled completely).

If there is insufficient power to run both the centrifuge cascade at
full speed and whatever other machines require power, all machines on
the same power network as the centrifuge will be forced to run at the
same fractional speed.  This can be inconvenient, especially if use
of the other machines is less automated than the centrifuge cascade.
It can be avoided by putting the centrifuge cascade on a separate power
network from other machines, and limiting the proportion of the generated
power that goes to it.

If there is sufficient power and it is desired to enrich uranium faster
than a single cascade can, the process can be speeded up more economically
than by building an entire second cascade.  Because the stages of the
cascade do different proportions of the work, it is possible to add a
second and subsequent centrifuges to only the busiest stages, and have
the less busy stages still keep up with only a single centrifuge each.

Another possible approach to uranium enrichment is to have no fixed
assignment of fissile proportions to centrifuges, dynamically putting
whatever uranium is available into whichever centrifuges are available.
Theoretically all of the centrifuges can be kept almost totally busy all
the time, making more efficient use of capital resources, and the number
of centrifuges used can be as little (down to one) or as large as desired.
The difficult part is that it is not sufficient to put each uranium dust
pile individually into whatever centrifuge is available: they must be
input in matched pairs.  Any odd dust pile in a centrifuge will not be
processed and will prevent that centrifuge from accepting any other input.

### concrete ###

Concrete is a synthetic building material.  The technic modpack implements
it in the game.

Two forms of concrete are available as building blocks: ordinary
"concrete" and more advanced "blast-resistant concrete".  Despite its
name, the latter has no special resistance to explosions or to any other
means of destruction.

Concrete can also be used to make fences.  They act just like wooden
fences, but aren't flammable.  Confusingly, the item that corresponds
to a wooden "fence" is called "concrete post".  Posts placed adjacently
will implicitly create fence between them.  Fencing also appears between
a post and adjacent concrete block.

industrial processes
--------------------

### Alloying

In Technic, alloying is a way of combining items to create other items,
distinct from standard crafting. Alloying always uses inputs of exactly
two distinct types, and produces a single output.

Check your preferred crafting guide for more information.

### Grinding, extracting, and compressing

Grinding, extracting, and compressing are three distinct, but very
similar, ways of converting one item into another.  They are all quite
similar to the cooking found in the basic Minetest game.  Each uses
an input consisting of a single item type, and produces a single
output.  They are all performed using powered machines, respectively
known generically as a "grinder", "extractor", and "compressor".
Some compressing recipes require the input to be a stack of more than
one of the input item: the quantity required is part of the recipe.
Grinding and extracting recipes never require such a stacked input.

There are multiple kinds of grinder, extractor, and compressor.  Unlike
cooking furnaces and alloy furnaces, there are none that directly burn
fuel; they are all electrically powered.

Grinding recipes always produce some kind of dust, loosely speaking,
as output.  The most important grinding recipes are concerned with metals:
every metal lump or ingot can be ground into metal dust.  Coal can also
be ground into dust, and burning the dust as fuel produces much more
energy than burning the original coal lump.  There are a few other
grinding recipes that make block types from the basic Minetest game
more interconvertible: standard stone can be ground to standard sand,
desert stone to desert sand, cobblestone to gravel, and gravel to dirt.

Extracting is a miscellaneous category, used for a small group
of processes that just don't fit nicely anywhere else.  (Its name is
notably vaguer than those of the other kinds of processing.)  It is used
for recipes that produce dye, mainly from flowers.  (However, for those
recipes using flowers, the basic Minetest game provides parallel crafting
recipes that are easier to use and produce more dye, and those recipes
are not suppressed by technic.)  Its main use is to generate rubber from
raw latex, which it does three times as efficiently as merely cooking
the latex.  Extracting was also formerly used for uranium enrichment for
use as nuclear fuel, but this use has been superseded by a new enrichment
system using the centrifuge.

Compressing recipes are mainly used to produce a few relatively advanced
artificial item types, such as the copper and carbon plates used in
advanced machine recipes.  There are also a couple of compressing recipes
making natural block types more interconvertible.

### centrifuging ###

Centrifuging is another way of using a machine to convert items.
Centrifuging takes an input of a single item type, and produces outputs
of two distinct types.  The input may be required to be a stack of
more than one of the input item: the quantity required is part of
the recipe.  Centrifuging is only performed by a single machine type,
the MV (electrically-powered) centrifuge.

Currently, centrifuging recipes don't appear in the unified\_inventory
craft guide, because unified\_inventory can't yet handle recipes with
multiple outputs.

Generally, centrifuging separates the input item into constituent
substances, but it can only work when the input is reasonably fluid,
and in marginal cases it is quite destructive to item structure.
(In real life, centrifuges require their input to be mainly fluid, that
is either liquid or gas.  Few items in the game are described as liquid
or gas, so the concept of the centrifuge is stretched a bit to apply to
finely-divided solids.)

The main use of centrifuging is in uranium enrichment, where it
separates the isotopes of uranium dust that otherwise appears uniform.
Enrichment is a necessary process before uranium can be used as nuclear
fuel, and the radioactivity of uranium blocks is also affected by its
isotopic composition.

A secondary use of centrifuging is to separate the components of
metal alloys.  This can only be done using the dust form of the alloy.
It recovers both components of binary metal/metal alloys.  It can't
recover the carbon from steel or cast iron.

Chests
------

See [GitHub Wiki / Chests](https://github.com/minetest-mods/technic/wiki/Chests)

Features of extended chests:

 * Larger storage space
 * Labelling
 * Advanced item sorting


radioactivity
-------------

The technic mod adds radioactivity to the game, as a hazard that can
harm player characters.  Certain substances in the game are radioactive,
and when placed as blocks in the game world will damage nearby players.
Conversely, some substances attenuate radiation, and so can be used
for shielding.  The radioactivity system is based on reality, but is
not an attempt at serious simulation: like the rest of the game, it has
many simplifications and deliberate deviations from reality in the name
of game balance.

In real life radiological hazards can be roughly divided into three
categories based on the time scale over which they act: prompt radiation
damage (such as radiation burns) that takes effect immediately; radiation
poisoning that becomes visible in hours and lasts weeks; and cumulative
effects such as increased cancer risk that operate over decades.
The game's version of radioactivity causes only prompt damage, not
any delayed effects.  Damage comes in the abstracted form of removing
the player's hit points, and is immediately visible to the player.
As with all other kinds of damage in the game, the player can restore
the hit points by eating food items.  High-nutrition foods, such as the
pie baskets supplied by the bushes\_classic mod, are a useful tool in
dealing with radiological hazards.

Only a small range of items in the game are radioactive.  From the technic
mod, the only radioactive items are uranium ore, refined uranium blocks,
nuclear reactor cores (when operating), and the materials released when
a nuclear reactor melts down.  Other mods can plug into the technic
system to make their own block types radioactive.  Radioactive items
are harmless when held in inventories.  They only cause radiation damage
when placed as blocks in the game world.

The rate at which damage is caused by a radioactive block depends on the
distance between the source and the player.  Distance matters because the
damaging radiation is emitted equally in all directions by the source,
so with distance it spreads out, so less of it will strike a target
of any specific size.  The amount of radiation absorbed by a target
thus varies in proportion to the inverse square of the distance from
the source.  The game imitates this aspect of real-life radioactivity,
but with some simplifications.  While in real life the inverse square law
is only really valid for sources and targets that are small relative to
the distance between them, in the game it is applied even when the source
and target are large and close together.  Specifically, the distance is
measured from the center of the radioactive block to the abdomen of the
player character.  For extremely close encounters, such as where the
player swims in a radioactive liquid, there is an enforced lower limit
on the effective distance.

Different types of radioactive block emit different amounts of radiation.
The least radioactive of the radioactive block types is uranium ore,
which causes 0.25 HP/s damage to a player 1 m away.  A block of refined
but unenriched uranium, as an example, is nine times as radioactive,
and so will cause 2.25 HP/s damage to a player 1 m away.  By the inverse
square law, the damage caused by that uranium block reduces by a factor
of four at twice the distance, that is to 0.5625 HP/s at a distance of 2
m, or by a factor of nine at three times the distance, that is to 0.25
HP/s at a distance of 3 m.  Other radioactive block types are far more
radioactive than these: the most radioactive of all, the result of a
nuclear reactor melting down, is 1024 times as radioactive as uranium ore.

Uranium blocks are radioactive to varying degrees depending on their
isotopic composition.  An isotope being fissile, and thus good as
reactor fuel, is essentially uncorrelated with it being radioactive.
The fissile U-235 is about six times as radioactive than the non-fissile
U-238 that makes up the bulk of natural uranium, so one might expect that
enriching from 0.7% fissile to 3.5% fissile (or depleting to 0.0%) would
only change the radioactivity of uranium by a few percent.  But actually
the radioactivity of enriched uranium is dominated by the non-fissile
U-234, which makes up only about 50 parts per million of natural uranium
but is about 19000 times more radioactive than U-238.  The radioactivity
of natural uranium comes just about half from U-238 and half from U-234,
and the uranium gets enriched in U-234 along with the U-235.  This makes
3.5%-fissile uranium about three times as radioactive as natural uranium,
and 0.0%-fissile uranium about half as radioactive as natural uranium.

Radiation is attenuated by the shielding effect of material along the
path between the radioactive block and the player.  In general, only
blocks of homogeneous material contribute to the shielding effect: for
example, a block of solid metal has a shielding effect, but a machine
does not, even though the machine's ingredients include a metal case.
The shielding effect of each block type is based on the real-life
resistance of the material to ionising radiation, but for game balance
the effectiveness of shielding is scaled down from real life, more so
for stronger shield materials than for weaker ones.  Also, whereas in
real life materials have different shielding effects against different
types of radiation, the game only has one type of damaging radiation,
and so only one set of shielding values.

Almost any solid or liquid homogeneous material has some shielding value.
At the low end of the scale, 5 meters of wooden planks nearly halves
radiation, though in that case the planks probably contribute more
to safety by forcing the player to stay 5 m further away from the
source than by actual attenuation.  Dirt halves radiation in 2.4 m,
and stone in 1.7 m.  When a shield must be deliberately constructed,
the preferred materials are metals, the denser the better.  Iron and
steel halve radiation in 1.1 m, copper in 1.0 m, and silver in 0.95 m.
Lead would halve in 0.69 m (its in-game shielding value is 80).  Gold halves radiation
in 0.53 m (factor of 3.7 per meter), but is a bit scarce to use for
this purpose.  Uranium halves radiation in 0.31 m (factor of 9.4 per
meter), but is itself radioactive.  The very best shielding in the game
is nyancat material (nyancats and their rainbow blocks), which halves
radiation in 0.22 m (factor of 24 per meter), but is extremely scarce. See [technic/technic/radiation.lua](https://github.com/minetest-technic/technic/blob/master/technic/radiation.lua) for the in-game shielding values, which are different from real-life values.

If the theoretical radiation damage from a particular source is
sufficiently small, due to distance and shielding, then no damage at all
will actually occur.  This means that for any particular radiation source
and shielding arrangement there is a safe distance to which a player can
approach without harm.  The safe distance is where the radiation damage
would theoretically be 0.25 HP/s.  This damage threshold is applied
separately for each radiation source, so to be safe in a multi-source
situation it is only necessary to be safe from each source individually.

The best way to use uranium as shielding is in a two-layer structure,
of uranium and some non-radioactive material.  The uranium layer should
be nearer to the primary radiation source and the non-radioactive layer
nearer to the player.  The uranium provides a great deal of shielding
against the primary source, and the other material shields against
the uranium layer.  Due to the damage threshold mechanism, a meter of
dirt is sufficient to shield fully against a layer of fully-depleted
(0.0%-fissile) uranium.  Obviously this is only worthwhile when the
primary radiation source is more radioactive than a uranium block.

When constructing permanent radiation shielding, it is necessary to
pay attention to the geometry of the structure, and particularly to any
holes that have to be made in the shielding, for example to accommodate
power cables.  Any hole that is aligned with the radiation source makes a
"shine path" through which a player may be irradiated when also aligned.
Shine paths can be avoided by using bent paths for cables, passing
through unaligned holes in multiple shield layers.  If the desired
shielding effect depends on multiple layers, a hole in one layer still
produces a partial shine path, along which the shielding is reduced,
so the positioning of holes in each layer must still be considered.
Tricky shine paths can also be addressed by just keeping players out of
the dangerous area.

## Electrical power

Electrical networks in Technic are defined by a single tier (see below)
and consist of:

 * 1x Switching Station (central management unit)
     * Any further stations are disabled automatically
 * Electricity producers (PR)
 * Electricity consumers/receivers (RE)
 * Accumulators/batteries (BA)

### Tiers

 * LV: Low Voltage. Low material costs but is slower.
 * MV: Medium Voltage. Higher processing speed.
 * HV: High Voltage. High material costs but is the fastest.

Tiers can be converted from one to another using the Supply Converter node.
Its top connects to the input, the bottom to the output network. Configure
the input power by right-clicking it.

### Machine upgrade slots

Generally, machines of MV and HV tiers have two upgrade slots.
Only specific items will have any upgrading effect. The occupied slots do
count, but not the actual stack size.

**Type 1: Energy upgrade**

Consists of any battery item. Reduces the machine's power consumption
regardless the charge of the item.

**Type 2: Tube upgrade**

Consists of a control logic unit item. Ejects processed items into pneumatic
tubes for quicker processing.

### Machines + Tubes (pipeworks)

Generally, powered machines of MV and HV tiers can work with pneumatic
tubes, and those of lower tiers cannot.  (As an exception, the fuel-fired
furnace from the basic Minetest game can accept inputs through tubes,
but can't output into tubes.)

If a machine can accept inputs through tubes at all, then this
is a capability of the basic machine, not requiring any upgrade.
Most item-processing machines take only one kind of input, and in that
case they will accept that input from any direction.  This doesn't match
how tubes visually connect to the machines: generally tubes will visually
connect to any face except the front, but an item passing through a tube
in front of the machine will actually be accepted into the machine.

A minority of machines take more than one kind of input, and in that
case the input slot into which an arriving item goes is determined by the
direction from which it arrives.  In this case the machine may be picky
about the direction of arriving items, associating each input type with
a single face of the machine and not accepting inputs at all through the
remaining faces.  Again, the visual connection of tubes doesn't match:
generally tubes will still visually connect to any face except the front,
thus connecting to faces that neither accept inputs nor emit outputs.

Machines do not accept items from tubes into non-input inventory slots:
the output slots or upgrade slots.  Output slots are normally filled
only by the processing operation of the machine, and upgrade slots must
be filled manually.

Powered machines generally do not eject outputs into tubes without
an upgrade.  One tube upgrade will make them eject outputs at a slow
rate; a second tube upgrade will increase the rate.  Whether the slower
rate is adequate depends on how it compares to the rate at which the
machine produces outputs, and on how the machine is being used as part
of a larger construct.  The machine always ejects its outputs through a
particular face, usually a side.  Due to a bug, the side through which
outputs are ejected is not consistent: when the machine is rotated one
way, the direction of ejection is rotated the other way.  This will
probably be fixed some day, but because a straightforward fix would
break half the machines already in use, the fix may be tied to some
larger change such as free selection of the direction of ejection.

### battery boxes ###

The primary purpose of battery boxes is to temporarily store electrical
energy to let an electrical network cope with mismatched supply and
demand.  They have a secondary purpose of charging and discharging
powered tools.  They are thus a mixture of electrical infrastructure,
powered machine, and generator.  Battery boxes connect to cables only
from the bottom.

MV and HV battery boxes have upgrade slots.  Energy upgrades increase
the capacity of a battery box, each by 10% of the un-upgraded capacity.
This increase is far in excess of the capacity of the battery that forms
the upgrade.

For charging and discharging of power tools, rather than having input and
output slots, each battery box has a charging slot and a discharging slot.
A fully charged/discharged item stays in its slot.  The rates at which a
battery box can charge and discharge increase with voltage, so it can
be worth building a battery box of higher tier before one has other
infrastructure of that tier, just to get access to faster charging.

MV and HV battery boxes work with pneumatic tubes.  An item can be input
to the charging slot through the sides or back of the battery box, or
to the discharging slot through the top.  With a tube upgrade, fully
charged/discharged tools (as appropriate for their slot) will be ejected
through a side.

### processing machines ###

The furnace, alloy furnace, grinder, extractor, compressor, and centrifuge
have much in common.  Each implements some industrial process that
transforms items into other items, and the manner in which they present
these processes as powered machines is essentially identical.

Most of the processing machines operate on inputs of only a single type
at a time, and correspondingly have only a single input slot.  The alloy
furnace is an exception: it operates on inputs of two distinct types at
once, and correspondingly has two input slots.  It doesn't matter which
way round the alloy furnace's inputs are placed in the two slots.

The processing machines are mostly available in variants for multiple
tiers.  The furnace and alloy furnace are each available in fuel-fired,
LV, and MV forms.  The grinder, extractor, and compressor are each
available in LV and MV forms.  The centrifuge is the only single-tier
processing machine, being only available in MV form.  The higher-tier
machines process items faster than the lower-tier ones, but also have
higher power consumption, usually taking more energy overall to perform
the same amount of processing.  The MV machines have upgrade slots,
and energy upgrades reduce their energy consumption.

The MV machines can work with pneumatic tubes.  They accept inputs via
tubes from any direction.  For most of the machines, having only a single
input slot, this is perfectly simple behavior.  The alloy furnace is more
complex: it will put an arriving item in either input slot, preferring to
stack it with existing items of the same type.  It doesn't matter which
slot each of the alloy furnace's inputs is in, so it doesn't matter that
there's no direct control over that, but there is a risk that supplying
a lot of one item type through tubes will result in both slots containing
the same type of item, leaving no room for the second input.

The MV machines can be given a tube upgrade to make them automatically
eject output items into pneumatic tubes.  The items are always ejected
through a side, though which side it is depends on the machine's
orientation, due to a bug.  Output items are always ejected singly.
For some machines, such as the grinder, the ejection rate with a
single tube upgrade doesn't keep up with the rate at which items can
be processed.  A second tube upgrade increases the ejection rate.

The LV and fuel-fired machines do not work with pneumatic tubes, except
that the fuel-fired furnace (actually part of the basic Minetest game)
can accept inputs from tubes.  Items arriving through the bottom of
the furnace go into the fuel slot, and items arriving from all other
directions go into the input slot.

### music player ###

The music player is an LV powered machine that plays audio recordings.
It offers a selection of up to nine tracks.  The technic modpack doesn't
include specific music tracks for this purpose; they have to be installed
separately.

The music player gives the impression that the music is being played in
the Minetest world.  The music only plays as long as the music player
is in place and is receiving electrical power, and the choice of music
is controlled by interaction with the machine.  The sound also appears
to emanate specifically from the music player: the ability to hear it
depends on the player's distance from the music player.  However, the
game engine doesn't currently support any other positional cues for
sound, such as attenuation, panning, or HRTF.  The impression of the
sound being located in the Minetest world is also compromised by the
subjective nature of track choice: the specific music that is played to
a player depends on what media the player has installed.

### CNC machine ###

The CNC machine is an LV powered machine that cuts building blocks into a
variety of sub-block shapes that are not covered by the crafting recipes
of the stairs mod and its variants.  Most of the target shapes are not
rectilinear, involving diagonal or curved surfaces.

Only certain kinds of building material can be processed in the CNC
machine.

### tool workshop ###

The tool workshop is an MV powered machine that repairs mechanically-worn
tools, such as pickaxes and the other ordinary digging tools.  It has
a single slot for a tool to be repaired, and gradually repairs the
tool while it is powered.  For any single tool, equal amounts of tool
wear, resulting from equal amounts of tool use, take equal amounts of
repair effort.  Also, all repairable tools currently take equal effort
to repair equal percentages of wear.  The amount of tool use enabled by
equal amounts of repair therefore depends on the tool type.

The mechanical wear that the tool workshop repairs is always indicated in
inventory displays by a colored bar overlaid on the tool image.  The bar
can be seen to fill and change color as the tool workshop operates,
eventually disappearing when the repair is complete.  However, not every
item that shows such a wear bar is using it to show mechanical wear.
A wear bar can also be used to indicate charging of a power tool with
stored electrical energy, or filling of a container, or potentially for
all sorts of other uses.  The tool workshop won't affect items that use
wear bars to indicate anything other than mechanical wear.

The tool workshop has upgrade slots.  Energy upgrades reduce its power
consumption.

It can work with pneumatic tubes.  Tools to be repaired are accepted
via tubes from any direction.  With a tube upgrade, the tool workshop
will also eject fully-repaired tools via one side, the choice of side
depending on the machine's orientation, as for processing machines.  It is
safe to put into the tool workshop a tool that is already fully repaired:
assuming the presence of a tube upgrade, the tool will be quickly ejected.
Furthermore, any item of unrepairable type will also be ejected as if
fully repaired.  (Due to a historical limitation of the basic Minetest
game, it is impossible for the tool workshop to distinguish between a
fully-repaired tool and any item type that never displays a wear bar.)

### quarry ###

The quarry is an HV powered machine that automatically digs out a
large area.  The region that it digs out is a cuboid with a square
horizontal cross section, located immediately behind the quarry machine.
The quarry's action is slow and energy-intensive, but requires little
player effort.

The size of the quarry's horizontal cross section is configurable through
the machine's interaction form.  A setting referred to as "radius"
is an integer number of meters which can vary from 2 to 8 inclusive.
The horizontal cross section is a square with side length of twice the
radius plus one meter, thus varying from 5 to 17 inclusive.  Vertically,
the quarry always digs from 3 m above the machine to 100 m below it,
inclusive, a total vertical height of 104 m.

Whatever the quarry digs up is ejected through the top of the machine,
as if from a pneumatic tube.  Normally a tube should be placed there
to convey the material into a sorting system, processing machines, or
at least chests.  A chest may be placed directly above the machine to
capture the output without sorting, but is liable to overflow.

If the quarry encounters something that cannot be dug, such as a liquid,
a locked chest, or a protected area, it will skip past that and attempt
to continue digging.  However, anything remaining in the quarry area
after the machine has attempted to dig there will prevent the machine
from digging anything directly below it, all the way to the bottom
of the quarry.  An undiggable block therefore casts a shadow of undug
blocks below it.  If liquid is encountered, it is quite likely to flow
across the entire cross section of the quarry, preventing all digging.
The depth at which the quarry is currently attempting to dig is reported
in its interaction form, and can be manually reset to the top of the
quarry, which is useful to do if an undiggable obstruction has been
manually removed.

The quarry consumes 10 kEU per block dug, which is quite a lot of energy.
With most of what is dug being mere stone, it is usually not economically
favorable to power a quarry from anything other than solar power.
In particular, one cannot expect to power a quarry by burning the coal
that it digs up.

Given sufficient power, the quarry digs at a rate of one block per second.
This is rather tedious to wait for.  Unfortunately, leaving the quarry
unattended normally means that the Minetest server won't keep the machine
running: it needs a player nearby.  This can be resolved by using a world
anchor.  The digging is still quite slow, and independently of whether a
world anchor is used the digging can be speeded up by placing multiple
quarry machines with overlapping digging areas.  Four can be placed to
dig identical areas, one on each side of the square cross section.

### forcefield emitter ###

The forcefield emitter is an HV powered machine that generates a
forcefield reminiscent of those seen in many science-fiction stories.

The emitter can be configured to generate a forcefield of either
spherical or cubical shape, in either case centered on the emitter.
The size of the forcefield is configured using a radius parameter that
is an integer number of meters which can vary from 5 to 20 inclusive.
For a spherical forcefield this is simply the radius of the forcefield;
for a cubical forcefield it is the distance from the emitter to the
center of each square face.

The power drawn by the emitter is proportional to the surface area of
the forcefield being generated.  A spherical forcefield is therefore the
cheapest way to enclose a specified volume of space with a forcefield,
if the shape of the space doesn't matter.  A cubical forcefield is less
efficient at enclosing volume, but is cheaper than the larger spherical
forcefield that would be required if it is necessary to enclose a
cubical space.

The emitter is normally controlled merely through its interaction form,
which has an enable/disable toggle.  However, it can also (via the form)
be placed in a mesecon-controlled mode.  If mesecon control is enabled,
the emitter must be receiving a mesecon signal in addition to being
manually enabled, in order for it to generate the forcefield.

The forcefield itself behaves largely as if solid, despite being
immaterial: it cannot be traversed, and prevents access to blocks behind
it.  It is transparent, but not totally invisible.  It cannot be dug.
Some effects can pass through it, however, such as the beam of a mining
laser, and explosions.  In fact, explosions as currently implemented by
the tnt mod actually temporarily destroy the forcefield itself; the tnt
mod assumes too much about the regularity of node types.

The forcefield occupies space that would otherwise have been air, but does
not replace or otherwise interfere with materials that are solid, liquid,
or otherwise not just air.  If such an object blocking the forcefield is
removed, the forcefield will quickly extend into the now-available space,
but it does not do so instantly: there is a brief moment when the space
is air and can be traversed.

It is possible to have a doorway in a forcefield, by placing in advance,
in space that the forcefield would otherwise occupy, some non-air blocks
that can be walked through.  For example, a door suffices, and can be
opened and closed while the forcefield is in place.

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

administrative world anchor
---------------------------

A world anchor is an object in the Minetest world that causes the server
to keep surrounding parts of the world running even when no players
are nearby.  It is mainly used to allow machines to run unattended:
normally machines are suspended when not near a player.  The technic
mod supplies a form of world anchor, as a placable block, but it is not
straightforwardly available to players.  There is no recipe for it, so it
is only available if explicitly spawned into existence by someone with
administrative privileges.  In a single-player world, the single player
normally has administrative privileges, and can obtain a world anchor
by entering the chat command "/give singleplayer technic:admin\_anchor".

The world anchor tries to force a cubical area, centered upon the anchor,
to stay loaded.  The distance from the anchor to the most distant map
nodes that it will keep loaded is referred to as the "radius", and can be
set in the world anchor's interaction form.  The radius can be set as low
as 0, meaning that the anchor only tries to keep itself loaded, or as high
as 255, meaning that it will operate on a 511&times;511&times;511 cube.
Larger radii are forbidden, to avoid typos causing the server excessive
work; to keep a larger area loaded, use multiple anchors.  Also use
multiple anchors if the area to be kept loaded is not well approximated
by a cube.

The world is always kept loaded in units of 16&times;16&times;16 cubes,
confusingly known as "map blocks".  The anchor's configured radius takes
no account of map block boundaries, but the anchor's effect is actually to
keep loaded each map block that contains any part of the configured cube.
The anchor's interaction form includes a status note showing how many map
blocks this is, and how many of those it is successfully keeping loaded.
When the anchor is disabled, as it is upon placement, it will always
show that it is keeping no map blocks loaded; this does not indicate
any kind of failure.

The world anchor can optionally be locked.  When it is locked, only
the anchor's owner, the player who placed it, can reconfigure it or
remove it.  Only the owner can lock it.  Locking an anchor is useful
if the use of anchors is being tightly controlled by administrators:
an administrator can set up a locked anchor and be sure that it will
not be set by ordinary players to an unapproved configuration.

The server limits the ability of world anchors to keep parts of the world
loaded, to avoid overloading the server.  The total number of map blocks
that can be kept loaded in this way is set by the server configuration
item "max\_forceloaded\_blocks" (in minetest.conf), which defaults to
only 16.  For comparison, each player normally keeps 125 map blocks loaded
(a radius of 32).  If an enabled world anchor shows that it is failing to
keep all the map blocks loaded that it would like to, this can be fixed
by increasing max\_forceloaded\_blocks by the amount of the shortfall.

The tight limit on force-loading is the reason why the world anchor is
not directly available to players.  With the limit so low both by default
and in common practice, the only feasible way to determine where world
anchors should be used is for administrators to decide it directly.

subjects missing from this manual
---------------------------------

This manual needs to be extended with sections on:

*   powered tools
    *   tool charging
    *   battery and energy crystals
    *   chainsaw
    *   flashlight
    *   mining lasers
    *   mining drills
    *   prospector
    *   sonic screwdriver
*   liquid cans
*   wrench
*   frames
*   templates
