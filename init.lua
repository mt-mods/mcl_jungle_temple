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
	sidelen = 18,
	filenames = {
		modpath.."/schematics/mcl_jungle_temple_main_temple.mts",
	},
	after_place = function(pos,def,pr)
		local hl = def.sidelen / 2
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

		-- Grab the positions for the stairs to be replaced.
		local sbs = get_replacements(stonebrickstair,70,pr)
		local sbso = get_replacements(stonebrickstair_outer,70,pr)

		-- Set the nodes into the mossy version.
		minetest.bulk_set_node(get_replacements(stonebrick,70,pr),{name="mcl_core:stonebrickmossy"})
		minetest.bulk_set_node(get_replacements(stonebrickslab,70,pr),{name="mcl_stairs:slab_stonebrickmossy" })
		minetest.bulk_set_node(get_replacements(stonebricktopslab,70,pr),{name="mcl_stairs:slab_stonebrickmossy_top"})
		minetest.bulk_set_node(get_replacements(stonebrickwall,70,pr),{name="mcl_walls:stonebrickmossy_0"})
		minetest.bulk_set_node(get_replacements(cobble,70,pr),{name="mcl_core:mossycobble"})

		for _, stairs in pairs(sbs) do
			local stair = minetest.get_node(stairs)
			minetest.set_node(stairs, {name="mcl_stairs:stair_stonebrickmossy", param2=stair.param2})
		end
		for _, stairso in pairs(sbso) do
			local stair = minetest.get_node(stairso)
			minetest.set_node(stairso, {name="mcl_stairs:stair_stonebrickmossy_outer", param2=stair.param2})
		end
	end,
})
