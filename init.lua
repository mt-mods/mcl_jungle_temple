--Copyright (C) 2023 PrairieWind

--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.

--You should have received a copy of the GNU General Public License
--along with this program.  If not, see <https://www.gnu.org/licenses/>.
-------------------------------------------------------------------------

local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(modname)

-- Begin See README for this code.
local function get_replacements(b,c,pr)
	local r = {}
	if not b then return r end
	for k,v in pairs(b) do
		if pr:next(1,100) < c then table.insert(r,v) end
	end
	return r
end
-- End See README for this code.

mcl_structures.register_structure("jungle_temple",{
	place_on = {"group:grass_block","group:dirt","mcl_core:dirt_with_grass"},
	fill_ratio = 0.01,
	flags = "place_center_x, place_center_z",
	solid_ground = true,
	make_foundation = true,
	y_offset = 0,
	chunk_probability = 200,
	y_max = mcl_vars.mg_overworld_max,
	y_min = 1,
	biomes = { "Jungle" },
	sidelen = 55,
	filenames = {
		modpath.."/schematics/mcl_jungle_temple_main_temple.mts",
	},
	after_place = function(pos,def,pr)
		local hl = def.sidelen
		local p1 = vector.offset(pos,-hl,-hl,-hl)
		local p2 = vector.offset(pos,hl,hl,hl)

		-- Replacable Nodes in the Structure. By turning these into the mossy version, there is a little bit of variation between each structure aesthetic wise.
		local stonebrick = minetest.find_nodes_in_area(p1,p2,{"mcl_core:stonebrick"})
		local stonebrickslab = minetest.find_nodes_in_area(p1,p2,{"mcl_stairs:slab_stonebrick"})
		local stonebrickstair = minetest.find_nodes_in_area(p1,p2,{"mcl_stairs:stair_stonebrick"})
		local stonebrickstair_outer = minetest.find_nodes_in_area(p1,p2,{"mcl_stairs:stair_stonebrick_outer"})
		local stonebricktopslab = minetest.find_nodes_in_area(p1,p2,{"mcl_stairs:slab_stonebrick_top"})
		local stonebrickwall = minetest.find_nodes_in_area(p1,p2,{"mcl_walls:stonebrick_0"})
		local cobble = minetest.find_nodes_in_area(p1,p2,{"mcl_core:cobble"})
		local cobbleslab = minetest.find_nodes_in_area(p1,p2,{"mcl_stairs:slab_cobble"})
		local torches = minetest.find_nodes_in_area(p1,p2,{"mcl_torches:torch_wall"})
		local tnt = minetest.find_nodes_in_area(p1,p2,{"mcl_tnt:tnt"})

		-- Grab the positions for the stairs to be replaced.
		local sbs = get_replacements(stonebrickstair,70,pr)
		local sbso = get_replacements(stonebrickstair_outer,70,pr)

		-- Set the nodes into the mossy version.
		minetest.bulk_set_node(get_replacements(stonebrick,70,pr),{name="mcl_core:stonebrickmossy"})
		minetest.bulk_set_node(get_replacements(stonebrick,10,pr),{name="mcl_core:stonebrickcracked"})
		minetest.bulk_set_node(get_replacements(stonebrick,2,pr),{name="mcl_monster_eggs:monster_egg_stonebrick"})
		minetest.bulk_set_node(get_replacements(stonebrickslab,70,pr),{name="mcl_stairs:slab_stonebrickmossy"})
		minetest.bulk_set_node(get_replacements(cobbleslab,70,pr),{name="mcl_stairs:slab_mossycobble"})
		minetest.bulk_set_node(get_replacements(stonebricktopslab,70,pr),{name="mcl_stairs:slab_stonebrickmossy_top"})
		minetest.bulk_set_node(get_replacements(stonebrickwall,70,pr),{name="mcl_walls:stonebrickmossy_0"})
		minetest.bulk_set_node(get_replacements(cobble,70,pr),{name="mcl_core:mossycobble"})
		minetest.bulk_set_node(get_replacements(cobble,2,pr),{name="mcl_monster_eggs:monster_egg_cobble"})
		minetest.bulk_set_node(get_replacements(torches,50,pr),{name="air"})
		minetest.bulk_set_node(get_replacements(tnt,50,pr),{name="mcl_core:cobble"})

		for _, stairs in pairs(sbs) do
			local stair = minetest.get_node(stairs)
			minetest.set_node(stairs, {name="mcl_stairs:stair_stonebrickmossy", param2=stair.param2})
		end
		for _, stairso in pairs(sbso) do
			local stair = minetest.get_node(stairso)
			minetest.set_node(stairso, {name="mcl_stairs:stair_stonebrickmossy_outer", param2=stair.param2})
		end
	end,
	daughters = {{
		files = {modpath.."/schematics/mcl_jungle_temple_middle_floor.mts"},
			pos = vector.new(0, -7, 0),
	},
	{
		files = {modpath.."/schematics/mcl_jungle_temple_bottom_four_way.mts"},
			pos = vector.new(0, -16, 0),
	},
	{
		files = {modpath.."/schematics/mcl_jungle_temple_lava_passage.mts", modpath.."/schematics/mcl_jungle_temple_sand_passage.mts"},
			pos = vector.new(-15, -16, 0),
			rot = 0,
	},
	{
		files = {modpath.."/schematics/mcl_jungle_temple_lava_passage.mts", modpath.."/schematics/mcl_jungle_temple_sand_passage.mts"},
			pos = vector.new(0, -16, 15),
			rot = 90,
	},
	{
		files = {modpath.."/schematics/mcl_jungle_temple_lava_passage.mts", modpath.."/schematics/mcl_jungle_temple_sand_passage.mts"},
			pos = vector.new(15, -16, 0),
			rot = 180,
	},
	{
		files = {modpath.."/schematics/mcl_jungle_temple_lava_passage.mts", modpath.."/schematics/mcl_jungle_temple_sand_passage.mts"},
			pos = vector.new(0, -16, -15),
			rot = 270,
	},
	{
		files = {modpath.."/schematics/mcl_jungle_temple_loot_room.mts", modpath.."/schematics/mcl_jungle_temple_loot_room_1.mts"},
			pos = vector.new(-28, -16, 0),
			rot = 180,
	},
	{
		files = {modpath.."/schematics/mcl_jungle_temple_loot_room.mts", modpath.."/schematics/mcl_jungle_temple_loot_room_1.mts"},
			pos = vector.new(0, -16, 28),
			rot = 270,
	},
	{
		files = {modpath.."/schematics/mcl_jungle_temple_loot_room.mts", modpath.."/schematics/mcl_jungle_temple_loot_room_1.mts"},
			pos = vector.new(28, -16, 0),
			rot = 0,
	},
	{
		files = {modpath.."/schematics/mcl_jungle_temple_loot_room.mts", modpath.."/schematics/mcl_jungle_temple_loot_room_1.mts"},
			pos = vector.new(0, -16, -28),
			rot = 90,
	}},
	loot = {
		["mcl_barrels:barrel_closed"] = {{
			stacks_min = 2,
			stacks_max = 4,
			items = {
				{ itemstring = "mcl_mobitems:bone", weight = 20, amount_min = 4, amount_max=6 },
				{ itemstring = "mcl_mobitems:rotten_flesh", weight = 16, amount_min = 3, amount_max=7 },
				{ itemstring = "mcl_core:gold_ingot", weight = 15, amount_min = 2, amount_max = 7 },
				{ itemstring = "mcl_core:iron_ingot", weight = 15, amount_min = 1, amount_max = 5 },
				{ itemstring = "mcl_core:diamond", weight = 3, amount_min = 1, amount_max = 3 },
				{ itemstring = "mcl_mobitems:saddle", weight = 3, },
				{ itemstring = "mcl_core:emerald", weight = 2, amount_min = 1, amount_max = 3 },
				{ itemstring = "mcl_books:book", weight = 1, func = function(stack, pr)
					mcl_enchanting.enchant_uniform_randomly(stack, {"soul_speed"}, pr)
				end },
				{ itemstring = "mcl_mobitems:iron_horse_armor", weight = 1, },
				{ itemstring = "mcl_mobitems:gold_horse_armor", weight = 1, },
				{ itemstring = "mcl_mobitems:diamond_horse_armor", weight = 1, },
				{ itemstring = "mcl_core:apple_gold_enchanted", weight = 2, },
			}
		}},
		["mcl_itemframes:item_frame"] = {{
			stacks_min = 1,
			stacks_max = 1,
			items = {
				{ itemstring = "mcl_tools:sword_diamond", weight = 100 },
			}
		}},
	},
})
