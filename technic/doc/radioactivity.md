
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
