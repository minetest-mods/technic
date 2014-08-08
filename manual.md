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
guidance, use the unified_inventory mod, with which technic registers
its specialised recipe types.

ore
---

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

rock
----

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

subjects missing from this manual
---------------------------------

This manual needs to be extended with sections on:

*   alloying
*   electrical networks
*   the powered machine types
*   how machines interact with tubes
*   the mining tools
*   radioactivity
*   frames
*   templates
*   chests
