register_grinder_recipe("gloopores:alatro_lump","technic:alatro_dust 2")
register_grinder_recipe("gloopores:kalite_lump","technic:kalite_dust 2")
register_grinder_recipe("gloopores:arol_lump","technic:arol_dust 2")
register_grinder_recipe("gloopores:talinite_lump","technic:talinite_dust 2")
register_grinder_recipe("gloopores:akalin_lump","technic:akalin_dust 2")
 
minetest.register_craftitem("technic:alatro_dust", {
        description = "Alatro Dust",
        inventory_image = "technic_alatro_dust.png",
})
 
minetest.register_craft({
    type = "cooking",
    output = "gloopores:alatro_ingot",
    recipe = "technic:alatro_dust",
})
 
minetest.register_craftitem("technicplus:arol_dust", {
        description = "Arol Dust",
        inventory_image = "technic_arol_dust.png",
})
 
minetest.register_craft({
    type = "cooking",
    output = "gloopores:arol_ingot",
    recipe = "technic:arol_dust",
})
 
minetest.register_craftitem("technic:talinite_dust", {
        description = "Talinite Dust",
        inventory_image = "technic_talinite_dust.png",
})
 
minetest.register_craft({
    type = "cooking",
    output = "gloopores:talinite_ingot",
    recipe = "technic:talinite_dust",
})
 
minetest.register_craftitem("technic:akalin_dust", {
        description = "Akalin Dust",
        inventory_image = "technic_akalin_dust.png",
})
 
minetest.register_craft({
    type = "cooking",
    output = "gloopores:akalin_ingot",
    recipe = "technic:akalin_dust",
})
 
minetest.register_craftitem("technic:kalite_dust", {
        description = "Kalite Dust",
        inventory_image = "technic_kalite_dust.png",
        on_use = minetest.item_eat(2)
})
