-- This file supplies pneumatic tubes and a 'test' device

minetest.register_node("pipeworks:testobject", {
	description = "Pneumatic tube test ojbect",
	tiles = {
		"pipeworks_testobject.png",
	},
	paramtype = "light",
	groups = {snappy=3, tubedevice=1},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
	after_place_node = function(pos)
			tube_scanforobjects(pos)
	end,
	after_dig_node = function(pos)
			tube_scanforobjects(pos)
	end,
})

-- tables

minetest.register_alias("pipeworks:tube", "pipeworks:tube_000000")

tube_leftstub = {
	{ -32/64, -9/64, -9/64, 9/64, 9/64, 9/64 },	-- tube segment against -X face
}

tube_rightstub = {
	{ -9/64, -9/64, -9/64,  32/64, 9/64, 9/64 },	-- tube segment against +X face
}

tube_bottomstub = {
	{ -9/64, -32/64, -9/64,   9/64, 9/64, 9/64 },	-- tube segment against -Y face
}


tube_topstub = {
	{ -9/64, -9/64, -9/64,   9/64, 32/64, 9/64 },	-- tube segment against +Y face
}

tube_frontstub = {
	{ -9/64, -9/64, -32/64,   9/64, 9/64, 9/64 },	-- tube segment against -Z face
}

tube_backstub = {
	{ -9/64, -9/64, -9/64,   9/64, 9/64, 32/64 },	-- tube segment against -Z face
} 

tube_selectboxes = {
	{ -32/64,  -10/64,  -10/64,  10/64,  10/64,  10/64 },
	{ -10/64 ,  -10/64,  -10/64, 32/64,  10/64,  10/64 },
	{ -10/64 , -32/64,  -10/64,  10/64,  10/64,  10/64 },
	{ -10/64 ,  -10/64,  -10/64,  10/64, 32/64,  10/64 },
	{ -10/64 ,  -10/64, -32/64,  10/64,  10/64,  10/64 },
	{ -10/64 ,  -10/64,  -10/64,  10/64,  10/64, 32/64 }
}

--  Functions

function tube_addbox(t, b)
	for i in ipairs(b)
		do table.insert(t, b[i])
	end
end

-- now define the nodes!

for xm = 0, 1 do
for xp = 0, 1 do
for ym = 0, 1 do
for yp = 0, 1 do
for zm = 0, 1 do
for zp = 0, 1 do
	local outboxes = {}
	local outsel = {}
	local outimgs = {}

	if yp==1 then
		tube_addbox(outboxes, tube_topstub)
		table.insert(outsel, tube_selectboxes[4])
		table.insert(outimgs, "pipeworks_tube_noctr.png")
	else
		table.insert(outimgs, "pipeworks_tube_plain.png")
	end
	if ym==1 then
		tube_addbox(outboxes, tube_bottomstub)
		table.insert(outsel, tube_selectboxes[3])
		table.insert(outimgs, "pipeworks_tube_noctr.png")
	else
		table.insert(outimgs, "pipeworks_tube_plain.png")
	end
	if xp==1 then
		tube_addbox(outboxes, tube_rightstub)
		table.insert(outsel, tube_selectboxes[2])
		table.insert(outimgs, "pipeworks_tube_noctr.png")
	else
		table.insert(outimgs, "pipeworks_tube_plain.png")
	end
	if xm==1 then
		tube_addbox(outboxes, tube_leftstub)
		table.insert(outsel, tube_selectboxes[1])
		table.insert(outimgs, "pipeworks_tube_noctr.png")
	else
		table.insert(outimgs, "pipeworks_tube_plain.png")
	end
	if zp==1 then
		tube_addbox(outboxes, tube_backstub)
		table.insert(outsel, tube_selectboxes[6])
		table.insert(outimgs, "pipeworks_tube_noctr.png")
	else
		table.insert(outimgs, "pipeworks_tube_plain.png")
	end
	if zm==1 then
		tube_addbox(outboxes, tube_frontstub)
		table.insert(outsel, tube_selectboxes[5])
		table.insert(outimgs, "pipeworks_tube_noctr.png")
	else
		table.insert(outimgs, "pipeworks_tube_plain.png")
	end

	local jx = xp+xm
	local jy = yp+ym
	local jz = zp+zm

	if (jx+jy+jz) == 1 then
		if xm == 1 then 
			table.remove(outimgs, 3)
			table.insert(outimgs, 3, "pipeworks_tube_end.png")
		end
		if xp == 1 then 
			table.remove(outimgs, 4)
			table.insert(outimgs, 4, "pipeworks_tube_end.png")
		end
		if ym == 1 then 
			table.remove(outimgs, 1)
			table.insert(outimgs, 1, "pipeworks_tube_end.png")
		end
		if xp == 1 then 
			table.remove(outimgs, 2)
			table.insert(outimgs, 2, "pipeworks_tube_end.png")
		end
		if zm == 1 then 
			table.remove(outimgs, 5)
			table.insert(outimgs, 5, "pipeworks_tube_end.png")
		end
		if zp == 1 then 
			table.remove(outimgs, 6)
			table.insert(outimgs, 6, "pipeworks_tube_end.png")
		end
	end

	local tname = xm..xp..ym..yp..zm..zp
	local tgroups = ""

	if tname ~= "000000" then
		tgroups = {snappy=3, tube=1, not_in_creative_inventory=1}
		tubedesc = "Pneumatic tube segment ("..tname..")... You hacker, you."
		iimg=nil
		wscale = {x=1,y=1,z=1}
	else
		tgroups = {snappy=3, tube=1}
		tubedesc = "Pneumatic tube segment"
		iimg="pipeworks_tube_inv.png"
		outimgs = {
			"pipeworks_tube_short.png",
			"pipeworks_tube_short.png",
			"pipeworks_tube_end.png",
			"pipeworks_tube_end.png",
			"pipeworks_tube_short.png",
			"pipeworks_tube_short.png"
		}
		outboxes = { -24/64, -9/64, -9/64, 24/64, 9/64, 9/64 }
		outsel = { -24/64, -10/64, -10/64, 24/64, 10/64, 10/64 }
		wscale = {x=1,y=1,z=0.01}
	end
	
	minetest.register_node("pipeworks:tube_"..tname, {
		description = tubedesc,
		drawtype = "nodebox",
		tiles = outimgs,
		inventory_image=iimg,
		wield_image=iimg,
		wield_scale=wscale,
		paramtype = "light",
		selection_box = {
	             	type = "fixed",
			fixed = outsel
		},
		node_box = {
			type = "fixed",
			fixed = outboxes
		},
		groups = tgroups,
		sounds = default.node_sound_wood_defaults(),
		walkable = true,
		stack_max = 99,
		drop = "pipeworks:tube_000000",
		tubelike=1,
		on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("tubelike",1)
		end,
		after_place_node = function(pos)
			tube_scanforobjects(pos)
		end,
		after_dig_node = function(pos)
			tube_scanforobjects(pos)
		end
	})

end
end
end
end
end
end

