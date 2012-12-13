-- autorouting for pipes

function pipe_scanforobjects(pos)
	pipe_autoroute({ x=pos.x-1, y=pos.y  , z=pos.z   }, "_loaded")
	pipe_autoroute({ x=pos.x+1, y=pos.y  , z=pos.z   }, "_loaded")
	pipe_autoroute({ x=pos.x  , y=pos.y-1, z=pos.z   }, "_loaded")
	pipe_autoroute({ x=pos.x  , y=pos.y+1, z=pos.z   }, "_loaded")
	pipe_autoroute({ x=pos.x  , y=pos.y  , z=pos.z-1 }, "_loaded")
	pipe_autoroute({ x=pos.x  , y=pos.y  , z=pos.z+1 }, "_loaded")
	pipe_autoroute(pos, "_loaded")

	pipe_autoroute({ x=pos.x-1, y=pos.y  , z=pos.z   }, "_empty")
	pipe_autoroute({ x=pos.x+1, y=pos.y  , z=pos.z   }, "_empty")
	pipe_autoroute({ x=pos.x  , y=pos.y-1, z=pos.z   }, "_empty")
	pipe_autoroute({ x=pos.x  , y=pos.y+1, z=pos.z   }, "_empty")
	pipe_autoroute({ x=pos.x  , y=pos.y  , z=pos.z-1 }, "_empty")
	pipe_autoroute({ x=pos.x  , y=pos.y  , z=pos.z+1 }, "_empty")
	pipe_autoroute(pos, "_empty")
end

function pipe_autoroute(pos, state)
	nctr = minetest.env:get_node(pos)
	if (string.find(nctr.name, "pipeworks:pipe_") == nil) then return end

	pipes_scansurroundings(pos)

	nsurround = pxm..pxp..pym..pyp..pzm..pzp
	if nsurround == "000000" then nsurround = "110000" end
	minetest.env:add_node(pos, { name = "pipeworks:pipe_"..nsurround..state })
end

-- autorouting for pneumatic tubes

function tube_scanforobjects(pos)
	tube_autoroute({ x=pos.x-1, y=pos.y  , z=pos.z   })
	tube_autoroute({ x=pos.x+1, y=pos.y  , z=pos.z   })
	tube_autoroute({ x=pos.x  , y=pos.y-1, z=pos.z   })
	tube_autoroute({ x=pos.x  , y=pos.y+1, z=pos.z   })
	tube_autoroute({ x=pos.x  , y=pos.y  , z=pos.z-1 })
	tube_autoroute({ x=pos.x  , y=pos.y  , z=pos.z+1 })
	tube_autoroute(pos)
end

function tube_autoroute(pos)
	nctr = minetest.env:get_node(pos)
	print ("minetest.get_item_group("..nctr.name..',"tubedevice") == '..minetest.get_item_group(nctr.name, "tubedevice"))
	if (string.find(nctr.name, "pipeworks:tube_") == nil)
		and minetest.get_item_group(nctr.name, "tubedevice") ~= 1 then return end

	pxm=0
	pxp=0
	pym=0
	pyp=0
	pzm=0
	pzp=0

	nxm = minetest.env:get_node({ x=pos.x-1, y=pos.y  , z=pos.z   })
	nxp = minetest.env:get_node({ x=pos.x+1, y=pos.y  , z=pos.z   })
	nym = minetest.env:get_node({ x=pos.x  , y=pos.y-1, z=pos.z   })
	nyp = minetest.env:get_node({ x=pos.x  , y=pos.y+1, z=pos.z   })
	nzm = minetest.env:get_node({ x=pos.x  , y=pos.y  , z=pos.z-1 })
	nzp = minetest.env:get_node({ x=pos.x  , y=pos.y  , z=pos.z+1 })

	if (string.find(nxm.name, "pipeworks:tube_") ~= nil) 
		or minetest.get_item_group(nxm.name, "tubedevice") == 1 then pxm=1 end
	if (string.find(nxp.name, "pipeworks:tube_") ~= nil) 
		or minetest.get_item_group(nxp.name, "tubedevice") == 1 then pxp=1 end
	if (string.find(nym.name, "pipeworks:tube_") ~= nil) 
		or minetest.get_item_group(nym.name, "tubedevice") == 1 then pym=1 end
	if (string.find(nyp.name, "pipeworks:tube_") ~= nil) 
		or minetest.get_item_group(nyp.name, "tubedevice") == 1 then pyp=1 end
	if (string.find(nzm.name, "pipeworks:tube_") ~= nil) 
		or minetest.get_item_group(nzm.name, "tubedevice") == 1 then pzm=1 end
	if (string.find(nzp.name, "pipeworks:tube_") ~= nil) 
		or minetest.get_item_group(nzp.name, "tubedevice") == 1 then pzp=1 end

	nsurround = pxm..pxp..pym..pyp..pzm..pzp
	if minetest.get_item_group(nctr.name, "tubedevice") ~= 1 then
		minetest.env:add_node(pos, { name = "pipeworks:tube_"..nsurround })
	end

end

-- auto-rotation code for various devices the tubes attach to

function pipe_device_autorotate(pos, state, bname)

	if state == nil then
		nname = bname
	else
		nname = bname.."_"..state
	end

	local nctr = minetest.env:get_node(pos)

	pipes_scansurroundings(pos)

	if (pxm+pxp) ~= 0 then
		minetest.env:add_node(pos, { name = nname.."_x" })
		return
	end

	if (pzm+pzp) ~= 0 then
		minetest.env:add_node(pos, { name = nname.."_z" })
	end
	
end

function pipes_scansurroundings(pos)
	pxm=0
	pxp=0
	pym=0
	pyp=0
	pzm=0
	pzp=0

	nxm = minetest.env:get_node({ x=pos.x-1, y=pos.y  , z=pos.z   })
	nxp = minetest.env:get_node({ x=pos.x+1, y=pos.y  , z=pos.z   })
	nym = minetest.env:get_node({ x=pos.x  , y=pos.y-1, z=pos.z   })
	nyp = minetest.env:get_node({ x=pos.x  , y=pos.y+1, z=pos.z   })
	nzm = minetest.env:get_node({ x=pos.x  , y=pos.y  , z=pos.z-1 })
	nzp = minetest.env:get_node({ x=pos.x  , y=pos.y  , z=pos.z+1 })

	if (string.find(nxm.name, "pipeworks:pipe_") ~= nil) then pxm=1 end
	if (string.find(nxp.name, "pipeworks:pipe_") ~= nil) then pxp=1 end
	if (string.find(nym.name, "pipeworks:pipe_") ~= nil) then pym=1 end
	if (string.find(nyp.name, "pipeworks:pipe_") ~= nil) then pyp=1 end
	if (string.find(nzm.name, "pipeworks:pipe_") ~= nil) then pzm=1 end
	if (string.find(nzp.name, "pipeworks:pipe_") ~= nil) then pzp=1 end

	for p in ipairs(pipes_devicelist) do
		pdev = pipes_devicelist[p]
		if (string.find(nxm.name, "pipeworks:"..pdev.."_off_x") ~= nil) or
		   (string.find(nxm.name, "pipeworks:"..pdev.."_on_x") ~= nil) or
		   (string.find(nxm.name, "pipeworks:"..pdev.."_x") ~= nil) then
			pxm=1
		end

		if (string.find(nxp.name, "pipeworks:"..pdev.."_off_x") ~= nil) or
		   (string.find(nxp.name, "pipeworks:"..pdev.."_on_x") ~= nil) or
		   (string.find(nxp.name, "pipeworks:"..pdev.."_x") ~= nil)  then
			pxp=1
		end

		if (string.find(nzm.name, "pipeworks:"..pdev.."_off_z") ~= nil) or
		   (string.find(nzm.name, "pipeworks:"..pdev.."_on_z") ~= nil) or
		   (string.find(nzm.name, "pipeworks:"..pdev.."_z") ~= nil)  then
			pzm=1
		end

		if (string.find(nzp.name, "pipeworks:"..pdev.."_off_z") ~= nil) or
		   (string.find(nzp.name, "pipeworks:"..pdev.."_on_z") ~= nil) or
		   (string.find(nzp.name, "pipeworks:"..pdev.."_z") ~= nil)  then
			pzp=1
		end
	end

	-- storage tanks and intake grates have vertical connections
	-- also, so they require a special case

	if (string.find(nym.name, "pipeworks:storage_tank_") ~= nil) or
	   (string.find(nym.name, "pipeworks:intake") ~= nil) or
	   (string.find(nym.name, "pipeworks:outlet") ~= nil) then
		pym=1
	end
end

function pipe_look_for_stackable_tanks(pos)
	tym = minetest.env:get_node({ x=pos.x  , y=pos.y-1, z=pos.z   })

	if string.find(tym.name, "pipeworks:storage_tank_") ~= nil or
	    string.find(tym.name, "pipeworks:expansion_tank_") ~= nil then
		minetest.env:add_node(pos, { name =  "pipeworks:expansion_tank_0"})
	end
end

