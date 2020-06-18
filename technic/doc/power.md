
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
