alloy_recipes ={}

registered_recipes_count=1

function register_alloy_recipe (string1,count1, string2,count2, string3,count3)
alloy_recipes[registered_recipes_count]={}
alloy_recipes[registered_recipes_count].src1_name=string1
alloy_recipes[registered_recipes_count].src1_count=count1
alloy_recipes[registered_recipes_count].src2_name=string2
alloy_recipes[registered_recipes_count].src2_count=count2
alloy_recipes[registered_recipes_count].dst_name=string3
alloy_recipes[registered_recipes_count].dst_count=count3
registered_recipes_count=registered_recipes_count+1
alloy_recipes[registered_recipes_count]={}
alloy_recipes[registered_recipes_count].src1_name=string2
alloy_recipes[registered_recipes_count].src1_count=count2
alloy_recipes[registered_recipes_count].src2_name=string1
alloy_recipes[registered_recipes_count].src2_count=count1
alloy_recipes[registered_recipes_count].dst_name=string3
alloy_recipes[registered_recipes_count].dst_count=count3
registered_recipes_count=registered_recipes_count+1
if unified_inventory then
	unified_inventory.register_craft({
	type = "alloy",
	output = string3.." "..count3,
	items = {string1.." "..count1,string2.." "..count2},
	width = 2,
	})
	end
end

register_alloy_recipe ("technic:copper_dust",3, "technic:tin_dust",1, "technic:bronze_dust",4)
register_alloy_recipe ("moreores:copper_ingot",3, "moreores:tin_ingot",1, "moreores:bronze_ingot",4)
register_alloy_recipe ("technic:iron_dust",3, "technic:chromium_dust",1, "technic:stainless_steel_dust",4)
register_alloy_recipe ("default:steel_ingot",3, "technic:chromium_ingot",1, "technic:stainless_steel_ingot",4)
register_alloy_recipe ("technic:copper_dust",2, "technic:zinc_dust",1, "technic:brass_dust",3)
register_alloy_recipe ("moreores:copper_ingot",2, "technic:zinc_ingot",1, "technic:brass_ingot",3)
register_alloy_recipe ("default:sand",2, "technic:coal_dust",2, "technic:silicon_wafer",1)
register_alloy_recipe ("technic:silicon_wafer",1, "technic:gold_dust",1, "technic:doped_silicon_wafer",1)
