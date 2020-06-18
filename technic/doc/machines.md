
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
to continue digging.

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

The quarry can be toggled on and off with a mesecons signal.

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
