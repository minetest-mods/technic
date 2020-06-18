
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
