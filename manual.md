Minetest technic modpack user manual
====================================

The technic modpack extends the Minetest game with many new elements,
mainly constructable machines and tools.  It is a large modpack, and
tends to dominate gameplay when it is used.  This manual describes how
to use the technic modpack, mainly from a player's perspective.

The technic modpack depends on some other modpacks:

*   the basic Minetest game
*   mesecons, which supports the construction of logic systems based on
    signalling elements
*   pipeworks, which supports the automation of item transport
*   moreores, which provides some additional ore types

This manual doesn't explain how to use these other modpacks, which ought
to (but actually don't) have their own manuals.

Recipes for constructable items in technic are generally not guessable,
and are also not specifically documented here.  You should use a
craft guide mod to look up the recipes in-game.  For the best possible
guidance, use the unified\_inventory mod, with which technic registers
its specialised recipe types.

substances
----------

### ore ###

The technic mod makes extensive use of not just the default ores but also
some that are added by mods.  You will need to mine for all the ore types
in the course of the game.  Each ore type is found at a specific range of
elevations, and while the ranges mostly overlap, some have non-overlapping
ranges, so you will ultimately need to mine at more than one elevation
to find all the ores.  Also, because one of the best elevations to mine
at is very deep, you will be unable to mine there early in the game.

Elevation is measured in meters, relative to a reference plane that
is not quite sea level.  (The standard sea level is at an elevation
of about +1.4.)  Positive elevations are above the reference plane and
negative elevations below.  Because elevations are always described this
way round, greater numbers when higher, we avoid the word "depth".

The ores that matter in technic are coal, iron, copper, tin, zinc,
chromium, uranium, silver, gold, mithril, mese, and diamond.

Coal is part of the basic Minetest game.  It is found from elevation
+64 downwards, so is available right on the surface at the start of
the game, but it is far less abundant above elevation 0 than below.
It is initially used as a fuel, driving important machines in the early
part of the game.  It becomes less important as a fuel once most of your
machines are electrically powered, but burning fuel remains a way to
generate electrical power.  Coal is also used, usually in dust form, as
an ingredient in alloying recipes, wherever elemental carbon is required.

Iron is part of the basic Minetest game.  It is found from elevation
+2 downwards, and its abundance increases in stages as one descends,
reaching its maximum from elevation -64 downwards.  It is a common metal,
used frequently as a structural component.  In technic, unlike the basic
game, iron is used in multiple forms, mainly alloys based on iron and
including carbon (coal).

Copper is part of the basic Minetest game (having migrated there from
moreores).  It is found from elevation -16 downwards, but is more abundant
from elevation -64 downwards.  It is a common metal, used either on its
own for its electrical conductivity, or as the base component of alloys.
Although common, it is very heavily used, and most of the time it will
be the material that most limits your activity.

Tin is supplied by the moreores mod.  It is found from elevation +8
downwards, with no elevation-dependent variations in abundance beyond
that point.  It is a common metal.  Its main use in pure form is as a
component of electrical batteries.  Apart from that its main purpose is
as the secondary ingredient in bronze (the base being copper), but bronze
is itself little used.  Its abundance is well in excess of its usage,
so you will usually have a surplus of it.

Zinc is supplied by technic.  It is found from elevation +2 downwards,
with no elevation-dependent variations in abundance beyond that point.
It is a common metal.  Its main use is as the secondary ingredient
in brass (the base being copper), but brass is itself little used.
Its abundance is well in excess of its usage, so you will usually have
a surplus of it.

Chromium is supplied by technic.  It is found from elevation -100
downwards, with no elevation-dependent variations in abundance beyond
that point.  It is a moderately common metal.  Its main use is as the
secondary ingredient in stainless steel (the base being iron).

Uranium is supplied by technic.  It is found only from elevation -80 down
to -300; using it therefore requires one to mine above elevation -300 even
though deeper mining is otherwise more productive.  It is a moderately
common metal, useful only for reasons related to radioactivity: it forms
the fuel for nuclear reactors, and is also one of the best radiation
shielding materials available.  It is not difficult to find enough uranium
ore to satisfy these uses.  Beware that the ore is slightly radioactive:
it will slightly harm you if you stand as close as possible to it.
It is safe when more than a meter away or when mined.

Silver is supplied by the moreores mod.  It is found from elevation -2
downwards, with no elevation-dependent variations in abundance beyond
that point.  It is a semi-precious metal.  It is little used, being most
notably used in electrical items due to its conductivity, being the best
conductor of all the pure elements.

Gold is part of the basic Minetest game (having migrated there from
moreores).  It is found from elevation -64 downwards, but is more
abundant from elevation -256 downwards.  It is a precious metal.  It is
little used, being most notably used in electrical items due to its
combination of good conductivity (third best of all the pure elements)
and corrosion resistance.

Mithril is supplied by the moreores mod.  It is found from elevation
-512 downwards, the deepest ceiling of any minable substance, with
no elevation-dependent variations in abundance beyond that point.
It is a rare precious metal, and unlike all the other metals described
here it is entirely fictional, being derived from J. R. R. Tolkien's
Middle-Earth setting.  It is little used.

Mese is part of the basic Minetest game.  It is found from elevation
-64 downwards.  The ore is more abundant from elevation -256 downwards,
and from elevation -1024 downwards there are also occasional blocks of
solid mese (each yielding as much mese as nine blocks of ore).  It is a
precious gemstone, and unlike diamond it is entirely fictional.  It is
used in many recipes, though mainly not in large quantities, wherever
some magical quality needs to be imparted.

Diamond is part of the basic Minetest game (having migrated there from
technic).  It is found from elevation -128 downwards, but is more abundant
from elevation -256 downwards.  It is a precious gemstone.  It is used
moderately, mainly for reasons connected to its extreme hardness.

### rock ###

In addition to the ores, there are multiple kinds of rock that need to be
mined in their own right, rather than for minerals.  The rock types that
matter in technic are standard stone, desert stone, marble, and granite.

Standard stone is part of the basic Minetest game.  It is extremely
common.  As in the basic game, when dug it yields cobblestone, which can
be cooked to turn it back into standard stone.  Cobblestone is used in
recipes only for some relatively primitive machines.  Standard stone is
used in a couple of machine recipes.  These rock types gain additional
significance with technic because the grinder can be used to turn them
into dirt and sand.  This, especially when combined with an automated
cobblestone generator, can be an easier way to acquire sand than
collecting it where it occurs naturally.

Desert stone is part of the basic Minetest game.  It is found specifically
in desert biomes, and only from elevation +2 upwards.  Although it is
easily accessible, therefore, its quantity is ultimately quite limited.
It is used in a few recipes.

Marble is supplied by technic.  It is found in dense clusters from
elevation -50 downwards.  It has mainly decorative use, but also appears
in one machine recipe.

Granite is supplied by technic.  It is found in dense clusters from
elevation -150 downwards.  It is much harder to dig than standard stone,
so impedes mining when it is encountered.  It has mainly decorative use,
but also appears in a couple of machine recipes.

### rubber ###

Rubber is a biologically-derived material that has industrial uses due
to its electrical resistivity and its impermeability.  In technic, it
is used in a few recipes, and it must be acquired by tapping rubber trees.

If you have the moretrees mod installed, the rubber trees you need
are those defined by that mod.  If not, technic supplies a copy of the
moretrees rubber tree.

Extracting rubber requires a specific tool, a tree tap.  Using the tree
tap (by left-clicking) on a rubber tree trunk block extracts a lump of
raw latex from the trunk.  Each trunk block can be repeatedly tapped for
latex, at intervals of several minutes; its appearance changes to show
whether it is currently ripe for tapping.  Each tree has several trunk
blocks, so several latex lumps can be extracted from a tree in one visit.

Raw latex isn't used directly.  It must be vulcanized to produce finished
rubber.  This can be performed by simply cooking the latex, with each
latex lump producing one lump of rubber.  If you have an extractor,
however, the latex is better processed there: each latex lump will
produce three lumps of rubber.

### metal ###

Many of the substances important in technic are metals, and there is
a common pattern in how metals are handled.  Generally, each metal can
exist in five forms: ore, lump, dust, ingot, and block.  With a couple of
tricky exceptions in mods outside technic, metals are only *used* in dust,
ingot, and block forms.  Metals can be readily converted between these
three forms, but can't be converted from them back to ore or lump forms.

As in the basic Minetest game, a "lump" of metal is acquired directly by
digging ore, and will then be processed into some other form for use.
A lump is thus more akin to ore than to refined metal.  (In real life,
metal ore rarely yields lumps ("nuggets") of pure metal directly.
More often the desired metal is chemically bound into the rock as an
oxide or some other compound, and the ore must be chemically processed
to yield pure metal.)

Not all metals occur directly as ore.  Generally, elemental metals (those
consisting of a single chemical element) occur as ore, and alloys (those
consisting of a mixture of multiple elements) do not.  In fact, if the
fictional mithril is taken to be elemental, this pattern is currently
followed perfectly.  (It is not clear in the Middle-Earth setting whether
mithril is elemental or an alloy.)  This might change in the future:
in real life some alloys do occur as ore, and some elemental metals
rarely occur naturally outside such alloys.  Metals that do not occur
as ore also lack the "lump" form.

The basic Minetest game offers a single way to refine metals: cook a lump
in a furnace to produce an ingot.  With technic this refinement method
still exists, but is rarely used outside the early part of the game,
because technic offers a more efficient method once some machines have
been built.  The grinder, available only in electrically-powered forms,
can grind a metal lump into two piles of metal dust.  Each dust pile
can then be cooked into an ingot, yielding two ingots from one lump.
This doubling of material value means that you should only cook a lump
directly when you have no choice, mainly early in the game when you
haven't yet built a grinder.

An ingot can also be ground back to (one pile of) dust.  Thus it is always
possible to convert metal between ingot and dust forms, at the expense
of some energy consumption.  Nine ingots of a metal can be crafted into
a block, which can be used for building.  The block can also be crafted
back to nine ingots.  Thus it is possible to freely convert metal between
ingot and block forms, which is convenient to store the metal compactly.
Every metal has dust, ingot, and block forms.

Alloying recipes in which a metal is the base ingredient, to produce a
metal alloy, always come in two forms, using the metal either as dust
or as an ingot.  If the secondary ingredient is also a metal, it must
be supplied in the same form as the base ingredient.  The output alloy
is also returned in the same form.  For example, brass can be produced
by alloying two copper ingots with one zinc ingot to make three brass
ingots, or by alloying two piles of copper dust with one pile of zinc
dust to make three piles of brass dust.  The two ways of alloying produce
equivalent results.

### iron and its alloys ###

Iron forms several important alloys.  In real-life history, iron was the
second metal to be used as the base component of deliberately-constructed
alloys (the first was copper), and it was the first metal whose working
required processes of any metallurgical sophistication.  The game
mechanics around iron broadly imitate the historical progression of
processes around it, rather than the less-varied modern processes.

The two-component alloying system of iron with carbon is of huge
importance, both in the game and in real life.  The basic Minetest game
doesn't distinguish between these pure iron and these alloys at all,
but technic introduces a distinction based on the carbon content, and
renames some items of the basic game accordingly.

The iron/carbon spectrum is represented in the game by three metal
substances: wrought iron, carbon steel, and cast iron.  Wrought iron
has low carbon content (less than 0.25%), resists shattering, and
is easily welded, but is relatively soft and susceptible to rusting.
In real-life history it was used for rails, gates, chains, wire, pipes,
fasteners, and other purposes.  Cast iron has high carbon content
(2.1% to 4%), is especially hard, and resists corrosion, but is
relatively brittle, and difficult to work.  Historically it was used
to build large structures such as bridges, and for cannons, cookware,
and engine cylinders.  Carbon steel has medium carbon content (0.25%
to 2.1%), and intermediate properties: moderately hard and also tough,
somewhat resistant to corrosion.  In real life it is now used for most
of the purposes previously satisfied by wrought iron and many of those
of cast iron, but has historically been especially important for its
use in swords, armor, skyscrapers, large bridges, and machines.

In real-life history, the first form of iron to be refined was
wrought iron, which is nearly pure iron, having low carbon content.
It was produced from ore by a low-temperature furnace process (the
"bloomery") in which the ore/iron remains solid and impurities (slag)
are progressively removed by hammering ("working", hence "wrought").
This began in the middle East, around 1800 BCE.

Historically, the next forms of iron to be refined were those of high
carbon content.  This was the result of the development of a more
sophisticated kind of furnace, the blast furnace, capable of reaching
higher temperatures.  The real advantage of the blast furnace is that it
melts the metal, allowing it to be cast straight into a shape supplied by
a mould, rather than having to be gradually beaten into the desired shape.
A side effect of the blast furnace is that carbon from the furnace's fuel
is unavoidably incorporated into the metal.  Normally iron is processed
twice through the blast furnace: once producing "pig iron", which has
very high carbon content and lots of impurities but lower melting point,
casting it into rough ingots, then remelting the pig iron and casting it
into the final moulds.  The result is called "cast iron".  Pig iron was
first produced in China around 1200 BCE, and cast iron later in the 5th
century BCE.  Incidentally, the Chinese did not have the bloomery process,
so this was their first iron refining process, and, unlike the rest of
the world, their first wrought iron was made from pig iron rather than
directly from ore.

Carbon steel, with intermediate carbon content, was developed much later,
in Europe in the 17th century CE.  It required a more sophisticated
process, because the blast furnace made it extremely difficult to achieve
a controlled carbon content.  Tweaks of the blast furnace would sometimes
produce an intermediate carbon content by luck, but the first processes to
reliably produce steel were based on removing almost all the carbon from
pig iron and then explicitly mixing a controlled amount of carbon back in.

In the game, the bloomery process is represented by ordinary cooking
or grinding of an iron lump.  The lump represents unprocessed ore,
and is identified only as "iron", not specifically as wrought iron.
This standard refining process produces dust or an ingot which is
specifically identified as wrought iron.  Thus the standard refining
process produces the (nearly) pure metal.

Cast iron is trickier.  You might expect from the real-life notes above
that cooking an iron lump (representing ore) would produce pig iron that
can then be cooked again to produce cast iron.  This is kind of the case,
but not exactly, because as already noted cooking an iron lump produces
wrought iron.  The game doesn't distinguish between low-temperature
and high-temperature cooking processes: the same furnace is used not
just to cast all kinds of metal but also to cook food.  So there is no
distinction between cooking processes to produce distinct wrought iron
and pig iron.  But repeated cooking *is* available as a game mechanic,
and is indeed used to produce cast iron: re-cooking a wrought iron ingot
produces a cast iron ingot.  So pig iron isn't represented in the game as
a distinct item; instead wrought iron stands in for pig iron in addition
to its realistic uses as wrought iron.

Carbon steel is produced by a more regular in-game process: alloying
wrought iron with coal dust (which is essentially carbon).  This bears
a fair resemblance to the historical development of carbon steel.
This alloying recipe is relatively time-consuming for the amount of
material processed, when compared against other alloying recipes, and
carbon steel is heavily used, so it is wise to alloy it in advance,
when you're not waiting for it.

There are additional recipes that permit all three of these types of iron
to be converted into each other.  Alloying carbon steel again with coal
dust produces cast iron, with its higher carbon content.  Cooking carbon
steel or cast iron produces wrought iron, in an abbreviated form of the
bloomery process.

There's one more iron alloy in the game: stainless steel.  It is managed
in a completely regular manner, created by alloying carbon steel with
chromium.

### uranium enrichment ###

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

### alloying ###

In technic, alloying is a way of combining items to create other items,
distinct from standard crafting.  Alloying always uses inputs of exactly
two distinct types, and produces a single output.  Like cooking, which
takes a single input, it is performed using a powered machine, known
generically as an "alloy furnace".  An alloy furnace always has two
input slots, and it doesn't matter which way round the two ingredients
are placed in the slots.  Many alloying recipes require one or both
slots to contain a stack of more than one of the ingredient item: the
quantity required of each ingredient is part of the recipe.

As with the furnaces used for cooking, there are multiple kinds of alloy
furnace, powered in different ways.  The most-used alloy furnaces are
electrically powered.  There is also an alloy furnace that is powered
by directly burning fuel, just like the basic cooking furnace.  Building
almost any electrical machine, including the electrically-powered alloy
furnaces, requires a machine casing component, one ingredient of which
is brass, an alloy.  It is therefore necessary to use the fuel-fired
alloy furnace in the early part of the game, on the way to building
electrical machinery.

Alloying recipes are mainly concerned with metals.  These recipes
combine a base metal with some other element, most often another metal,
to produce a new metal.  This is discussed in the section on metal.
There are also a few alloying recipes in which the base ingredient is
non-metallic, such as the recipe for the silicon wafer.

### grinding, extracting, and compressing ###

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

chests
------

The technic mod replaces the basic Minetest game's single type of
chest with a range of chests that have different sizes and features.
The chest types are identified by the materials from which they are made;
the better chests are made from more exotic materials.  The chest types
form a linear sequence, each being (with one exception noted below)
strictly more powerful than the preceding one.  The sequence begins with
the wooden chest from the basic game, and each later chest type is built
by upgrading a chest of the preceding type.  The chest types are:

1.  wooden chest: 8&times;4 (32) slots
2.  iron chest: 9&times;5 (45) slots
3.  copper chest: 12&times;5 (60) slots
4.  silver chest: 12&times;6 (72) slots
5.  gold chest: 15&times;6 (90) slots
6.  mithril chest: 15&times;6 (90) slots

The iron and later chests have the ability to sort their contents,
when commanded by a button in their interaction forms.  Item types are
sorted in the same order used in the unified\_inventory craft guide.
The copper and later chests also have an auto-sorting facility that can
be enabled from the interaction form.  An auto-sorting chest automatically
sorts its contents whenever a player closes the chest.  The contents will
then usually be in a sorted state when the chest is opened, but may not
be if pneumatic tubes have operated on the chest while it was closed,
or if two players have the chest open simultaneously.

The silver and gold chests, but not the mithril chest, have a built-in
sign-like capability.  They can be given a textual label, which will
be visible when hovering over the chest.  The gold chest, but again not
the mithril chest, can be further labelled with a colored patch that is
visible from a moderate distance.

The mithril chest is currently an exception to the upgrading system.
It has only as many inventory slots as the preceding (gold) type, and has
fewer of the features.  It has no feature that other chests don't have:
it is strictly weaker than the gold chest.  It is planned that in the
future it will acquire some unique features, but for now the only reason
to use it is aesthetic.

The size of the largest chests is dictated by the maximum size
of interaction form that the game engine can successfully display.
If in the future the engine becomes capable of handling larger forms,
by scaling them to fit the screen, the sequence of chest sizes will
likely be revised.

As with the chest of the basic Minetest game, each chest type comes
in both locked and unlocked flavors.  All of the chests work with the
pneumatic tubes of the pipeworks mod.

electrical power
----------------

Most machines in technic are electrically powered.  To operate them it is
necessary to construct an electrical power network.  The network links
together power generators and power-consuming machines, connecting them
using power cables.

There are three tiers of electrical networking: low voltage (LV),
medium voltage (MV), and high voltage (HV).  Each network must operate
at a single voltage, and most electrical items are specific to a single
voltage.  Generally, the machines of higher tiers are more powerful,
but consume more energy and are more expensive to build, than machines
of lower tiers.  It is normal to build networks of all three tiers,
in ascending order as one progresses through the game, but it is not
strictly necessary to do this.  Building HV equipment requires some parts
that can only be manufactured using electrical machines, either LV or MV,
so it is not possible to build an HV network first, but it is possible
to skip either LV or MV on the way to HV.

Each voltage has its own cable type, with distinctive insulation.  Cable
segments connect to each other and to compatible machines automatically.
Incompatible electrical items don't connect.  All non-cable electrical
items must be connected via cable: they don't connect directly to each
other.  Most electrical items can connect to cables in any direction,
but there are a couple of important exceptions noted below.

To be useful, an electrical network must connect at least one power
generator to at least one power-consuming machine.  In addition to these
items, the network must have a "switching station" in order to operate:
no energy will flow without one.  Unlike most electrical items, the
switching station is not voltage-specific: the same item will manage
a network of any tier.  However, also unlike most electrical items,
it is picky about the direction in which it is connected to the cable:
the cable must be directly below the switching station.

Hovering over a network's switching station will show the aggregate energy
supply and demand, which is useful for troubleshooting.  Electrical energy
is measured in "EU", and power (energy flow) in EU per second (EU/s).
Energy is shifted around a network instantaneously once per second.

In a simple network with only generators and consumers, if total
demand exceeds total supply then no energy will flow, the machines
will do nothing, and the generators' output will be lost.  To handle
this situation, it is recommended to add a battery box to the network.
A battery box will store generated energy, and when enough has been
stored to run the consumers for one second it will deliver it to the
consumers, letting them run part-time.  It also stores spare energy
when supply exceeds demand, to let consumers run full-time when their
demand occasionally peaks above the supply.  More battery boxes can
be added to cope with larger periods of mismatched supply and demand,
such as those resulting from using solar generators (which only produce
energy in the daytime).

When there are electrical networks of multiple tiers, it can be appealing
to generate energy on one tier and transfer it to another.  The most
direct way to do this is with the "supply converter", which can be
directly wired into two networks.  It is another tier-independent item,
and also particular about the direction of cable connections: it must
have the cable of one network directly above, and the cable of another
network directly below.  The supply converter demands 10000 EU/s from
the network above, and when this network gives it power it supplies 9000
EU/s to the network below.  Thus it is only 90% efficient, unlike most of
the electrical system which is 100% efficient in moving energy around.
To transfer more than 10000 EU/s between networks, connect multiple
supply converters in parallel.

powered machines
----------------

### powered machine tiers ###

Each powered machine takes its power in some specific form, being
either fuel-fired (burning fuel directly) or electrically powered at
some specific voltage.  There is a general progression through the
game from using fuel-fired machines to electrical machines, and to
higher electrical voltages.  The most important kinds of machine come
in multiple variants that are powered in different ways, so the earlier
ones can be superseded.  However, some machines are only available for
a specific power tier, so the tier can't be entirely superseded.

### powered machine upgrades ###

Some machines have inventory slots that are used to upgrade them in
some way.  Generally, machines of MV and HV tiers have two upgrade slots,
and machines of lower tiers (fuel-fired and LV) do not.  Any item can
be placed in an upgrade slot, but only specific items will have any
upgrading effect.  It is possible to have multiple upgrades of the same
type, but this can't be achieved by stacking more than one upgrade item
in one slot: it is necessary to put the same kind of item in more than one
upgrade slot.  The ability to upgrade machines is therefore very limited.
Two kinds of upgrade are currently possible: an energy upgrade and a
tube upgrade.

An energy upgrade consists of a battery item, the same kind of battery
that serves as a mobile energy store.  The effect of an energy upgrade
is to improve in some way the machine's use of electrical energy, most
often by making it use less energy.  The upgrade effect has no relation
to energy stored in the battery: the battery's charge level is irrelevant
and will not be affected.

A tube upgrade consists of a control logic unit item.  The effect of a
tube upgrade is to make the machine able, or more able, to eject items
it has finished with into pneumatic tubes.  The machines that can take
this kind of upgrade are in any case capable of accepting inputs from
pneumatic tubes.  These upgrades are essential in using powered machines
as components in larger automated systems.

### tubes with powered machines ###

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
powered machine, and generator.

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
to the charging slot through the bottom of the battery box, or to the
discharging slot through the top.  Items are not accepted through the
front, back, or sides.  With a tube upgrade, fully charged/discharged
tools (as appropriate for their slot) will be ejected through a side.

### processing machines ###

The furnace, alloy furnace, grinder, extractor, compressor, and centrifuge
have much in common.  Each implements some industrial process that
transforms items into other items, and they manner in which they present
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
there's no direct control ovar that, but there is a risk that supplying
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
forcefield remeniscent of those seen in many science-fiction stories.

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

Electrical energy can be generated at any voltage (LV, MV, or HV)
by fuel-fired generators.  These are all capable of burning any type
of combustible fuel, such as coal.  They are relatively easy to build,
and so tend to be the first kind of generator used to power electrical
machines.  In this role they form an intermediate step between the
directly fuel-fired machines and a more mature electrical network
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

### hydro generator ###

The hydro generator is an LV power generator that generates a small amount
of power from the natural motion of water.  To operate, the generator must
be horizontally adjacent to water.  It doesn't matter whether the water
consists of source blocks or flowing blocks.  Having water adjacent on
more than one side, up to the full four, increases the generator's output.
The water itself is unaffected by the generator.

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

*   power generators
    *   wind
    *   solar
    *   nuclear
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
*   radioactivity
*   frames
*   templates
