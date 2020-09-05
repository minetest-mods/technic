

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
