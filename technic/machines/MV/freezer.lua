-- MV freezer

minetest.register_craft({
    output = 'technic:mv_freezer',
    recipe = {
        {'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot',  'technic:stainless_steel_ingot'},
        {'pipeworks:tube_1',              'technic:mv_transformer', 'pipeworks:tube_1'},
        {'technic:stainless_steel_ingot', 'technic:mv_cable',       'technic:stainless_steel_ingot'},
    }
})

technic.register_freezer({tier = "MV", demand = {800, 600, 400}, speed = 2, upgrade = 1, tube = 1})
