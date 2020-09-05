

minetest.register_abm({
  nodenames = {"technic:hv_nuclear_reactor_core_active"},
  interval = 10,
  chance = 1,
  action = function(pos, node)
    minetest.add_particlespawner({
      amount = 50,
      time = 10,
      minpos = {x=pos.x-0.5, y=pos.y-0.5, z=pos.z-0.5},
      maxpos = {x=pos.x+0.5, y=pos.y+0.5, z=pos.z+0.5},
      minvel = {x=-0.8, y=-0.8, z=-0.8},
      maxvel = {x=0.8, y=0.8, z=0.8},
      minacc = {x=0,y=0,z=0},
      maxacc = {x=0,y=0,z=0},
      minexptime = 0.5,
      maxexptime = 2,
      minsize = 1,
      maxsize = 2,
      texture = "blueparticle.png",
      glow = 5
    })
  end
})
