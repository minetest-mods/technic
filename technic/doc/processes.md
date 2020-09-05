
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
