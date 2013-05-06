-- API for the technic CNC machine
-- Again code is adapted from the NonCubic Blocks MOD v1.4 by yves_de_beck
technic_cnc_api = {}

-- HERE YOU CAN CHANGE THE DETAIL-LEVEL:
----------------------------------------
technic_cnc_api.detail_level = 16 -- 16; 1-32

-- HERE YOU CAN DE/ACTIVATE BACKGROUND FOR CNC MENU:
--------------------------------------------------------
technic_cnc_api.allow_menu_background = false

-- REGISTER NONCUBIC FORMS, CREATE MODELS AND RECIPES:
------------------------------------------------------

-- SLOPE
--------
function technic_cnc_api.register_slope(recipeitem, groups, images, description)

local slopebox = {}
local detail = technic_cnc_api.detail_level
for i = 0, detail-1 do
        slopebox[i+1]={-0.5, (i/detail)-0.5, (i/detail)-0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
end

minetest.register_node(":" .. recipeitem .. "_technic_cnc_slope", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = slopebox,
        },
        groups = groups,
        })
end


-- SLOPE Lying
----------------
function technic_cnc_api.register_slope_lying(recipeitem, groups, images, description)

local slopeboxlying = {}
local detail = technic_cnc_api.detail_level
for i = 0, detail-1 do
        slopeboxlying[i+1]={(i/detail)-0.5, -0.5, (i/detail)-0.5, (i/detail)-0.5+(1/detail), 0.5 , 0.5}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_slope_lying", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = slopeboxlying,
        },
        groups = groups,
        })
        minetest.register_craft({
                output = recipeitem .. "_technic_cnc_slope_lying 1",
                recipe = {
                        {"", "", ""},
                        {"", recipeitem .. "_technic_cnc_slope", ""},
                        {"", "", ""},           
                },
        })

end


-- SLOPE UPSIDE DOWN
--------------------
function technic_cnc_api.register_slope_upsdown(recipeitem, groups, images, description)

if subname == "dirt" then
return
end

local slopeupdwnbox = {}
local detail = technic_cnc_api.detail_level
for i = 0, detail-1 do
        slopeupdwnbox[i+1]={-0.5, (i/detail)-0.5, (-1*(i/detail))+0.5-(1/detail), 0.5, (i/detail)-0.5+(1/detail), 0.5}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_slope_upsdown", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = slopeupdwnbox,
        },
        groups = groups,
        })
end


-- SLOPE EDGE
-------------
function technic_cnc_api.register_slope_edge(recipeitem, groups, images, description)

local slopeboxedge = {}
local detail = technic_cnc_api.detail_level
for i = 0, detail-1 do
        slopeboxedge[i+1]={(i/detail)-0.5, -0.5, (i/detail)-0.5, 0.5, (i/detail)-0.5+(1/detail), 0.5}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_slope_edge", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = slopeboxedge,
        },
        groups = groups,
        })
end


-- SLOPE INNER EDGE
-------------------
function technic_cnc_api.register_slope_inner_edge(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_slope_inner_edge", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = {
                        -- PART 1
                        {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5},
                        {-0.45, -0.5, -0.5, 0.5, -0.4, 0.5},
                        {-0.4, -0.5, -0.5, 0.5, -0.35, 0.5},
                        {-0.35, -0.5, -0.5, 0.5, -0.3, 0.5},
                        {-0.3, -0.5, -0.5, 0.5, -0.25, 0.5},
                        {-0.25, -0.5, -0.5, 0.5, -0.2, 0.5},
                        {-0.2, -0.5, -0.5, 0.5, -0.15, 0.5},
                        {-0.15, -0.5, -0.5, 0.5, -0.1, 0.5},
                        {-0.1, -0.5, -0.5, 0.5, -0.05, 0.5},
                        {-0.05, -0.5, -0.5, 0.5, 0, 0.5},
                        {0, -0.5, -0.5, 0.5, 0.05, 0.5},
                        {0.05, -0.5, -0.5, 0.5, 0.1, 0.5},
                        {0.1, -0.5, -0.5, 0.5, 0.15, 0.5},
                        {0.15, -0.5, -0.5, 0.5, 0.2, 0.5},
                        {0.2, -0.5, -0.5, 0.5, 0.25, 0.5},
                        {0.25, -0.5, -0.5, 0.5, 0.3, 0.5},
                        {0.3, -0.5, -0.5, 0.5, 0.35, 0.5},
                        {0.35, -0.5, -0.5, 0.5, 0.4, 0.5},
                        {0.4, -0.5, -0.5, 0.5, 0.45, 0.5},
                        {0.45, -0.5, -0.5, 0.5, 0.5, 0.5},
                        -- PART 2
                        {-0.5, -0.5, -0.45, 0.5, -0.45, 0.5},
                        {-0.5, -0.5, -0.4, 0.5, -0.4, 0.5},
                        {-0.5, -0.5, -0.35, 0.5, -0.35, 0.5},
                        {-0.5, -0.5, -0.3, 0.5, -0.3, 0.5},
                        {-0.5, -0.5, -0.25, 0.5, -0.25, 0.5},
                        {-0.5, -0.5, -0.2, 0.5, -0.2, 0.5},
                        {-0.5, -0.5, -0.15, 0.5, -0.15, 0.5},
                        {-0.5, -0.5, -0.1, 0.5, -0.1, 0.5},
                        {-0.5, -0.5, -0.05, 0.5, -0.05, 0.5},
                        {-0.5, -0.5, 0, 0.5, 0, 0.5},
                        {-0.5, -0.5, 0.05, 0.5, 0.05, 0.5},
                        {-0.5, -0.5, 0.1, 0.5, 0.1, 0.5},
                        {-0.5, -0.5, 0.15, 0.5, 0.15, 0.5},
                        {-0.5, -0.5, 0.2, 0.5, 0.2, 0.5},
                        {-0.5, -0.5, .25, 0.5, 0.25, 0.5},
                        {-0.5, -0.5, 0.3, 0.5, 0.3, 0.5},
                        {-0.5, -0.5, 0.35, 0.5, 0.35, 0.5},
                        {-0.5, -0.5, 0.4, 0.5, 0.4, 0.5},
                        {-0.5, -0.5, 0.45, 0.5, 0.45, 0.5},
                        {-0.5, -0.5, 0.5, 0.5, 0.5, 0.5},
                        },
        },
        groups = groups,
        })
end


-- SLOPE EDGE UPSIDE DOWN
-------------------------
function technic_cnc_api.register_slope_upsdown_edge(recipeitem, groups, images, description)

if recipeitem == "default:dirt" then
   return
end

local slopeupdwnboxedge = {}
local detail = technic_cnc_api.detail_level
for i = 0, detail-1 do
        slopeupdwnboxedge[i+1]={(-1*(i/detail))+0.5-(1/detail), (i/detail)-0.5, (-1*(i/detail))+0.5-(1/detail), 0.5, (i/detail)-0.5+(1/detail), 0.5}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_slope_upsdown_edge", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = slopeupdwnboxedge,
        },
        groups = groups,
        })
end


-- SLOPE INNER EDGE UPSIDE DOWN
-------------------------------
function technic_cnc_api.register_slope_upsdown_inner_edge(recipeitem, groups, images, description)

if recipename == "default:dirt" then
return
end

minetest.register_node(":" .. recipeitem .. "_technic_cnc_slope_upsdown_inner_edge", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = {
                        {0.45, -0.5, -0.5, 0.5, -0.45, 0.5},
                        {0.4, -0.45, -0.5, 0.5, -0.4, 0.5},
                        {0.35, -0.4, -0.5, 0.5, -0.35, 0.5},
                        {0.3, -0.35, -0.5, 0.5, -0.3, 0.5},
                        {0.25, -0.3, -0.5, 0.5, -0.25, 0.5},
                        {0.2, -0.25, -0.5, 0.5, -0.2, 0.5},
                        {0.15, -0.2, -0.5, 0.5, -0.15, 0.5},
                        {0.1, -0.15, -0.5, 0.5, -0.1, 0.5},
                        {0.05, -0.1, -0.5, 0.5, -0.05, 0.5},
                        {0, -0.05, -0.5, 0.5, 0, 0.5},
                        {-0.05, 0, -0.5, 0.5, 0.05, 0.5},
                        {-0.1, 0.05, -0.5, 0.5, 0.1, 0.5},
                        {-0.15, 0.1, -0.5, 0.5, 0.15, 0.5},
                        {-0.2, 0.15, -0.5, 0.5, 0.2, 0.5},
                        {-0.25, 0.2, -0.5, 0.5, 0.25, 0.5},
                        {-0.3, 0.25, -0.5, 0.5, 0.3, 0.5},
                        {-0.35, 0.3, -0.5, 0.5, 0.35, 0.5},
                        {-0.4, 0.35, -0.5, 0.5, 0.4, 0.5},
                        {-0.45, 0.4, -0.5, 0.5, 0.45, 0.5},
                        {-0.5, 0.45, -0.5, 0.5, 0.5, 0.5},

                        {-0.5, -0.5, 0.45, 0.5, -0.45, 0.5},
                        {-0.5, -0.45, 0.4, 0.5, -0.4, 0.5},
                        {-0.5, -0.4, 0.35, 0.5, -0.35, 0.5},
                        {-0.5, -0.35, 0.3, 0.5, -0.3, 0.5},
                        {-0.5, -0.3, 0.25, 0.5, -0.25, 0.5},
                        {-0.5, -0.25, 0.2, 0.5, -0.2, 0.5},
                        {-0.5, -0.2, 0.15, 0.5, -0.15, 0.5},
                        {-0.5, -0.15, 0.1, 0.5, -0.1, 0.5},
                        {-0.5, -0.1, 0.05, 0.5, -0.05, 0.5},
                        {-0.5, -0.05, 0, 0.5, 0, 0.5},
                        {-0.5, 0, -0.05, 0.5, 0.05, 0.5},
                        {-0.5, 0.05, -0.1, 0.5, 0.1, 0.5},
                        {-0.5, 0.1, -0.15, 0.5, 0.15, 0.5},
                        {-0.5, 0.15, -0.2, 0.5, 0.2, 0.5},
                        {-0.5, 0.2, -0.25, 0.5, 0.25, 0.5},
                        {-0.5, 0.25, -0.3, 0.5, 0.3, 0.5},
                        {-0.5, 0.3, -0.35, 0.5, 0.35, 0.5},
                        {-0.5, 0.35, -0.4, 0.5, 0.4, 0.5},
                        {-0.5, 0.4, -0.45, 0.5, 0.45, 0.5},
                        {-0.5, 0.45, -0.5, 0.5, 0.5, 0.5},

                        },
        },
        groups = groups,
        })
end


-- PYRAMID
----------
function technic_cnc_api.register_pyramid(recipeitem, groups, images, description)

local pyrabox = {}
local detail = technic_cnc_api.detail_level/2
for i = 0, detail-1 do
        pyrabox[i+1]={(i/detail/2)-0.5, (i/detail/2)-0.5, (i/detail/2)-0.5, 0.5-(i/detail/2), (i/detail/2)-0.5+(1/detail), 0.5-(i/detail/2)}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_pyramid", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = pyrabox,
        },
        groups = groups,
        })
end


-- SPIKE
--------
function technic_cnc_api.register_spike(recipeitem, groups, images, description)

if recipename == "default:dirt" then
       return
end

local spikebox = {}
local detail = technic_cnc_api.detail_level
for i = 0, detail-1 do
        spikebox[i+1]={(i/detail/2)-0.5, (i/detail/2)-0.5, (i/detail/2)-0.5, 0.5-(i/detail/2), (i/detail)-0.5+(1/detail), 0.5-(i/detail/2)}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_spike", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = spikebox,
        },
        groups = groups,
        })
end


-- Block one curved edge 
------------------------
function technic_cnc_api.register_onecurvededge(recipeitem, groups, images, description)

local quartercyclebox = {}
local detail = technic_cnc_api.detail_level*2
local sehne
for i = (detail/2)-1, detail-1 do
        sehne = math.sqrt(0.25 - (((i/detail)-0.5)^2))
        quartercyclebox[i]={-0.5, -0.5, -sehne, 0.5, (i/detail)+(1/detail)-0.5, 0.5}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_onecurvededge", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = quartercyclebox,
        },
        groups = groups,
        })
end


-- Block two curved edges 
-------------------------
function technic_cnc_api.register_twocurvededge(recipeitem, groups, images, description)

local quartercyclebox2 = {}
local detail = technic_cnc_api.detail_level*2
local sehne
for i = (detail/2)-1, detail-1 do
        sehne = math.sqrt(0.25 - (((i/detail)-0.5)^2))
        quartercyclebox2[i]={-sehne, -0.5, -sehne, 0.5, (i/detail)+(1/detail)-0.5, 0.5}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_twocurvededge", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = quartercyclebox2,
        },
        groups = groups,
        })
        minetest.register_craft({
                output = recipeitem .. "_technic_cnc_twocurvededge 3",
                recipe = {
                        {"", "", ""},
                        {recipeitem .. "_technic_cnc_onecurvededge", "", ""},
                        {recipeitem .. "_technic_cnc_onecurvededge", recipeitem .. "_technic_cnc_onecurvededge", ""},         
                },
        })

end

-- Cylinder
-----------
function technic_cnc_api.register_cylinder(recipeitem, groups, images, description)

if recipename == "default:dirt" then
return
end

local cylbox = {}
local detail = technic_cnc_api.detail_level
local sehne
for i = 1, detail-1 do
        sehne = math.sqrt(0.25 - (((i/detail)-0.5)^2))
        cylbox[i]={(i/detail)-0.5, -0.5, -sehne, (i/detail)+(1/detail)-0.5, 0.5, sehne}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_cylinder", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = cylbox,
        },
        groups = groups,
        })
        minetest.register_craft({
                output = recipeitem .. "_technic_cnc_cylinder 1",
                recipe = {
                        {"", "", ""},
                        {"", recipeitem .. "_technic_cnc_cylinder_horizontal", ""},
                        {"", "", ""},           
                },
        })

end


-- Cylinder Horizontal
----------------------
function technic_cnc_api.register_cylinder_horizontal(recipeitem, groups, images, description)

if recipename == "default:dirt" then
       return
end

local cylbox_horizontal = {}
local detail = technic_cnc_api.detail_level
local sehne
for i = 1, detail-1 do
        sehne = math.sqrt(0.25 - (((i/detail)-0.5)^2))
        cylbox_horizontal[i]={-0.5, (i/detail)-0.5, -sehne, 0.5, (i/detail)+(1/detail)-0.5, sehne}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_cylinder_horizontal", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = cylbox_horizontal,
        },
        groups = groups,
        })
        minetest.register_craft({
                output = recipeitem .. "_technic_cnc_cylinder_horizontal 1",
                recipe = {
                        {"", "", ""},
                        {"", recipeitem .. "_technic_cnc_cylinder", ""},
                        {"", "", ""},           
                },
        })
end


-- Sphere
---------
function technic_cnc_api.register_sphere(recipeitem, groups, images, description)

if recipename == "default:dirt" then
       return
end

local spherebox = {}
local detail = technic_cnc_api.detail_level
local sehne
for i = 1, detail-1 do
        sehne = math.sqrt(0.25 - (((i/detail)-0.5)^2))
        spherebox[i]={-sehne, (i/detail)-0.5, -sehne, sehne, (i/detail)+(1/detail)-0.5, sehne}
end
minetest.register_node(":" .. recipeitem .. "_technic_cnc_cylinder_sphere", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = spherebox,
        },
        groups = groups,
        })
end


-- Element straight
-------------------
function technic_cnc_api.register_element_straight(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_element_straight", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.3, -0.5, -0.5, 0.3, 0, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.3, -0.5, -0.5, 0.3, 0, 0.5},
                        },
        },
        groups = groups,
        })
end


-- Element Edge
---------------
function technic_cnc_api.register_element_edge(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_element_edge", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {
                        {-0.3, -0.5, -0.5, 0.3, 0, 0.3},
                        {-0.5, -0.5, -0.3, -0.3, 0, 0.3},
                        },
        },
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.3, -0.5, -0.5, 0.3, 0, 0.3},
                        {-0.5, -0.5, -0.3, -0.3, 0, 0.3},
                        },
        },
        groups = groups,
        })
end


-- Element T
------------
function technic_cnc_api.register_element_t(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_element_t", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {
                        {-0.3, -0.5, -0.5, 0.3, 0, 0.3},
                        {-0.5, -0.5, -0.3, -0.3, 0, 0.3},
                        {0.3, -0.5, -0.3, 0.5, 0, 0.3},
                        },
        },
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.3, -0.5, -0.5, 0.3, 0, 0.3},
                        {-0.5, -0.5, -0.3, -0.3, 0, 0.3},
                        {0.3, -0.5, -0.3, 0.5, 0, 0.3},
                        },
        },
        groups = groups,
        })
end


-- Element Cross
----------------
function technic_cnc_api.register_element_cross(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_element_cross", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {
                        {0.3, -0.5, -0.3, 0.5, 0, 0.3},
                        {-0.3, -0.5, -0.5, 0.3, 0, 0.5},
                        {-0.5, -0.5, -0.3, -0.3, 0, 0.3},
                        },
        },
        node_box = {
                type = "fixed",
                fixed = {
                        {0.3, -0.5, -0.3, 0.5, 0, 0.3},
                        {-0.3, -0.5, -0.5, 0.3, 0, 0.5},
                        {-0.5, -0.5, -0.3, -0.3, 0, 0.3},
                        },
        },
        groups = groups,
        })
end


-- Element End
--------------
function technic_cnc_api.register_element_end(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_element_end", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.3, -0.5, -0.3, 0.3, 0, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = {-0.3, -0.5, -0.3, 0.3, 0, 0.5},
        },
        groups = groups,
        })
end


-- Element straight DOUBLE
--------------------------
function technic_cnc_api.register_element_straight_double(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_element_straight_double", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
                        },
        },
        groups = groups,
        })
        minetest.register_craft({
                output = recipeitem .. "_technic_cnc_element_straight_double 1",
                recipe = {
                        {"", "", ""},
                        {"", recipeitem .. "_technic_cnc_element_straight", ""},
                        {"", recipeitem .. "_technic_cnc_element_straight", ""},           
                },
        })
end


-- Element Edge DOUBLE
----------------------
function technic_cnc_api.register_element_edge_double(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_element_edge_double", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {
                        {-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
                        {-0.5, -0.5, -0.3, -0.3, 0.5, 0.3},
                        },
        },
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
                        {-0.5, -0.5, -0.3, -0.3, 0.5, 0.3},
                        },
        },
        groups = groups,
        })
        minetest.register_craft({
                output = recipeitem .. "_technic_cnc_element_edge_double 1",
                recipe = {
                        {"", "", ""},
                        {"", recipeitem .. "_technic_cnc_element_edge", ""},
                        {"", recipeitem .. "_technic_cnc_element_edge", ""},               
                },
        })
end


-- Element T DOUBLE
-------------------
function technic_cnc_api.register_element_t_double(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_element_t_double", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {
                        {-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
                        {-0.5, -0.5, -0.3, -0.3, 0.5, 0.3},
                        {0.3, -0.5, -0.3, 0.5, 0.5, 0.3},
                        },
        },
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.3, -0.5, -0.5, 0.3, 0.5, 0.3},
                        {-0.5, -0.5, -0.3, -0.3, 0.5, 0.3},
                        {0.3, -0.5, -0.3, 0.5, 0.5, 0.3},
                        },
        },
        groups = groups,
        })
        minetest.register_craft({
                output = recipeitem .. "_technic_cnc_element_t_double 1",
                recipe = {
                        {"", "", ""},
                        {"", recipeitem .. "_technic_cnc_element_t", ""},
                        {"", recipeitem .. "_technic_cnc_element_t", ""},          
                },
        })
end


-- Element Cross Double
-----------------------
function technic_cnc_api.register_element_cross_double(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_element_cross_double", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {
                        {0.3, -0.5, -0.3, 0.5, 0.5, 0.3},
                        {-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
                        {-0.5, -0.5, -0.3, -0.3, 0.5, 0.3},
                        },
        },
        node_box = {
                type = "fixed",
                fixed = {
                        {0.3, -0.5, -0.3, 0.5, 0.5, 0.3},
                        {-0.3, -0.5, -0.5, 0.3, 0.5, 0.5},
                        {-0.5, -0.5, -0.3, -0.3, 0.5, 0.3},
                        },
        },
        groups = groups,
        })
        minetest.register_craft({
                output = recipeitem .. "_technic_cnc_element_cross_double 1",
                recipe = {
                        {"", "", ""},
                        {"", recipeitem .. "_technic_cnc_element_cross", ""},
                        {"", recipeitem .. "_technic_cnc_element_cross", ""},              
                        },
        })

end


-- Element End Double
---------------------
function technic_cnc_api.register_element_end_double(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_element_end_double", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.5},
        },
        node_box = {
                type = "fixed",
                fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.5},
        },
        groups = groups,
        })
        minetest.register_craft({
                output = recipeitem .. "_technic_cnc_element_end_double 1",
                recipe = {
                        {"", "", ""},
                        {"", recipeitem .. "_technic_cnc_element_end", ""},
                        {"", recipeitem .. "_technic_cnc_element_end", ""},                
                        },
        })
end


-- STICK
--------
function technic_cnc_api.register_stick(recipeitem, groups, images, description)

minetest.register_node(":" .. recipeitem .. "_technic_cnc_stick", {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        walkable = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.15, -0.5, -0.15, 0.15, 0.5, 0.15},
        },
        node_box = {
                type = "fixed",
                fixed = {-0.15, -0.5, -0.15, 0.15, 0.5, 0.15},
        },
        groups = groups,
        })
        minetest.register_craft({
                output = recipeitem .. "_technic_cnc_stick 8",
                recipe = {
                        {'default:stick', "", ""},
                        {"", "", ""},
                        {recipeitem, "", ""},           
                },
        })
end



-- REGISTER NEW TECHNIC_CNC_API's PART 2: technic_cnc_api.register_element_end(subname, recipeitem, groups, images, desc_element_xyz)
-----------------------------------------------------------------------------------------------------------------------
function technic_cnc_api.register_slope_edge_etc(recipeitem, groups, images, desc_slope, desc_slope_lying, desc_slope_upsdown, desc_slope_edge, desc_slope_inner_edge, desc_slope_upsdwn_edge, desc_slope_upsdwn_inner_edge, desc_pyramid, desc_spike, desc_onecurvededge, desc_twocurvededge, desc_cylinder, desc_cylinder_horizontal, desc_sphere, desc_element_straight, desc_element_edge, desc_element_t, desc_element_cross, desc_element_end)

         technic_cnc_api.register_slope(recipeitem, groups, images, desc_slope)
         technic_cnc_api.register_slope_lying(recipeitem, groups, images, desc_slope_lying)
         technic_cnc_api.register_slope_upsdown(recipeitem, groups, images, desc_slope_upsdown)
         technic_cnc_api.register_slope_edge(recipeitem, groups, images, desc_slope_edge)
         technic_cnc_api.register_slope_inner_edge(recipeitem, groups, images, desc_slope_inner_edge)
         technic_cnc_api.register_slope_upsdown_edge(recipeitem, groups, images, desc_slope_upsdwn_edge)
         technic_cnc_api.register_slope_upsdown_inner_edge(recipeitem, groups, images, desc_slope_upsdwn_inner_edge)
         technic_cnc_api.register_pyramid(recipeitem, groups, images, desc_pyramid)
         technic_cnc_api.register_spike(recipeitem, groups, images, desc_spike)
         technic_cnc_api.register_onecurvededge(recipeitem, groups, images, desc_onecurvededge)
         technic_cnc_api.register_twocurvededge(recipeitem, groups, images, desc_twocurvededge)
         technic_cnc_api.register_cylinder(recipeitem, groups, images, desc_cylinder)
         technic_cnc_api.register_cylinder_horizontal(recipeitem, groups, images, desc_cylinder_horizontal)
         technic_cnc_api.register_sphere(recipeitem, groups, images, desc_sphere)
         technic_cnc_api.register_element_straight(recipeitem, groups, images, desc_element_straight)
         technic_cnc_api.register_element_edge(recipeitem, groups, images, desc_element_edge)
         technic_cnc_api.register_element_t(recipeitem, groups, images, desc_element_t)
         technic_cnc_api.register_element_cross(recipeitem, groups, images, desc_element_cross)
         technic_cnc_api.register_element_end(recipeitem, groups, images, desc_element_end)
end

-- REGISTER STICKS: noncubic.register_xyz(recipeitem, groups, images, desc_element_xyz)
------------------------------------------------------------------------------------------------------------
function technic_cnc_api.register_stick_etc(recipeitem, groups, images, desc_stick)
         technic_cnc_api.register_stick(recipeitem, groups, images, desc_stick)
end

function technic_cnc_api.register_elements(recipeitem, groups, images, desc_element_straight_double, desc_element_edge_double, desc_element_t_double, desc_element_cross_double, desc_element_end_double)
         technic_cnc_api.register_element_straight_double(recipeitem, groups, images, desc_element_straight_double)
         technic_cnc_api.register_element_edge_double(recipeitem, groups, images, desc_element_edge_double)
         technic_cnc_api.register_element_t_double(recipeitem, groups, images, desc_element_t_double)
         technic_cnc_api.register_element_cross_double(recipeitem, groups, images, desc_element_cross_double)
         technic_cnc_api.register_element_end_double(recipeitem, groups, images, desc_element_end_double)
end
