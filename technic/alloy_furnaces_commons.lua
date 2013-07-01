-- Register alloy recipes
technic.alloy_recipes = {}

-- Register recipe in a table
technic.register_alloy_recipe = function(metal1, count1, metal2, count2, result, count3)
				   technic.alloy_recipes[metal1..metal2] = { src1_count = count1, src2_count = count2, dst_name = result, dst_count = count3 }
				   if unified_inventory then
				      unified_inventory.register_craft(
					 {
					    type = "alloy",
					    output = result.." "..count3,
					    items = {metal1.." "..count1,metal2.." "..count2},
					    width = 2,
					 })
				   end
				end

-- Retrieve a recipe given the input metals.
-- Input parameters are a table from a StackItem
technic.get_alloy_recipe = function(metal1, metal2)
			      -- Check for both combinations of metals and for the right amount in both
			      if technic.alloy_recipes[metal1.name..metal2.name]
				 and metal1.count >= technic.alloy_recipes[metal1.name..metal2.name].src1_count
				 and metal2.count >= technic.alloy_recipes[metal1.name..metal2.name].src2_count then
				 return technic.alloy_recipes[metal1.name..metal2.name]
			      elseif technic.alloy_recipes[metal2.name..metal1.name]
				 and metal2.count >= technic.alloy_recipes[metal2.name..metal1.name].src1_count
				 and metal1.count >= technic.alloy_recipes[metal2.name..metal1.name].src2_count then
				 return technic.alloy_recipes[metal2.name..metal1.name]
			      else
				 return nil
			      end
			   end

technic.register_alloy_recipe("technic:copper_dust",  3, "technic:tin_dust",      1, "technic:bronze_dust",          4)
technic.register_alloy_recipe("moreores:copper_ingot",3, "moreores:tin_ingot",    1, "moreores:bronze_ingot",        4)
technic.register_alloy_recipe("technic:iron_dust",    3, "technic:chromium_dust", 1, "technic:stainless_steel_dust", 4)
technic.register_alloy_recipe("default:steel_ingot",  3, "technic:chromium_ingot",1, "technic:stainless_steel_ingot",4)
technic.register_alloy_recipe("technic:copper_dust",  2, "technic:zinc_dust",     1, "technic:brass_dust",           3)
technic.register_alloy_recipe("moreores:copper_ingot",2, "technic:zinc_ingot",    1, "technic:brass_ingot",          3)
technic.register_alloy_recipe("default:sand",         2, "technic:coal_dust",     2, "technic:silicon_wafer",        1)
technic.register_alloy_recipe("technic:silicon_wafer",1, "technic:gold_dust",     1, "technic:doped_silicon_wafer",  1)

--------------------------------------
-- LEGACY CODE - some other mods might depend on this - Register the same recipes as above...
--------------------------------------
alloy_recipes = {}
registered_recipes_count = 1

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
