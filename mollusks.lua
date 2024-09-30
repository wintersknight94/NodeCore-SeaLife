-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, math
    = minetest, nodecore, math
local math_random
    = math.random
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local function findwater(pos)
	return nodecore.find_nodes_around(pos, "group:water")
end
local water = "nc_terrain:water_source"
------------------------------------------------------------------------
local clamshell = "(nc_terrain_stone.png^nc_tree_peat.png)^[colorize:TEAL:40"
local clammask = modname.. "_clam.png"
local clammouth = "(" ..clamshell.. ")^(" ..clammask.. "^[opacity:120)"
-- ================================================================== --
minetest.register_node(modname .. ":mollusk", {
		description = "Mollusk",
		tiles = {
			clammouth,
			clammouth,
			clamshell,
			clamshell,
			clammouth,
			clammouth
		},
		groups = {
			cracky = 2,
			sealife = 1,
			mollusk = 1,
			clam_living = 1,
		},
		sounds = nodecore.sounds("nc_terrain_stony", nil, 0.7),
		paramtype2 = "facedir",
		on_place = minetest.rotate_node,
	})
-- ================================================================== --
if minetest.get_modpath("wc_naturae") then
	nodecore.register_craft({
		label = "break mollusk apart",
		action = "pummel",
		indexkeys = {modname.. ":mollusk"},
		nodes = {
			{match = modname.. ":mollusk", replace = "air"}
		},
		items = {
			{name = "wc_naturae:shell", count = 8, scatter = 5}
		},
		toolgroups = {cracky = 3},
		itemscatter = 5
	})
end
-- ================================================================== --
minetest.register_decoration({
	name = modname.. ":tridacnaNS",
	deco_type = "simple",
	place_on = {"group:sand"},
	param2 = 8,
	sidelen = 16,
	fill_ratio = 0.0001,
	biomes = {"seabed"},
	y_max = -8,
	y_min = -64,
	flags = "force_placement",
	decoration = modname.. ":mollusk",
})
------------------------------------------------------------------------
minetest.register_decoration({
	name = modname.. ":tridacnaEW",
	deco_type = "simple",
	place_on = {"group:sand"},
	param2 = 3,
	sidelen = 16,
	fill_ratio = 0.0001,
	biomes = {"seabed"},
	y_max = -8,
	y_min = -64,
	flags = "force_placement",
	decoration = modname.. ":mollusk",
})
------------------------------------------------------------------------
minetest.register_decoration({
	name = modname.. ":tridacnaUD",
	deco_type = "simple",
	place_on = {"group:sand"},
	param2 = 5,
	sidelen = 16,
	fill_ratio = 0.0001,
	biomes = {"seabed"},
	y_max = -8,
	y_min = -64,
	flags = "force_placement",
	decoration = modname.. ":mollusk",
})
-- ================================================================== --

