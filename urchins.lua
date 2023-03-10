-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
local box = {
	type="fixed",
	fixed = { {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}, },
}
-- ================================================================== --
local function urchin_type(id, str, color, size, ymax, ymin)
local spikey = modname.. "_urchin.png^[colorize:" ..color
------------------------------------------------------------------------
	minetest.register_node(modname.. ":urchin_" ..id, {
		description = "Urchin",
		drawtype = "plantlike_rooted",
		tiles = {"nc_terrain_sand.png"},
		falling_visual = "nc_terrain_sand.png",
		special_tiles = {spikey},
		visual_scale = size,
		sunlight_propagates = true,
		paramtype = 'light',
		paramtype2 = "meshoptions",
		place_param2 = 10,
		groups = {
			urchin = str,
			sealife = 1,
			stack_as_node = 1,
			damage_touch = str,
			sessile = 1,
			peat_grindable_node = 1
		},
		walkable = false,
		damage_per_second = str,
		move_resistance = str*10,
		sounds = nodecore.sounds("nc_terrain_stoney"),
		selection_box = box,
		collision_box = box,
	})
------------------------------------------------------------------------
	minetest.register_decoration({
		label = modname .. ":urchin_" ..id,
		deco_type = "simple",
		place_on = "group:sand",
		sidelen = 16,
		fill_ratio = 0.001,
		biomes = "seabed",
		y_max = ymax,
		y_min = ymin,
		decoration = modname .. ":urchin_" ..id,
		param2 = 10,
		flags = "force_placement",
		place_offset_y = -1,
	})
------------------------------------------------------------------------
local spike = "nc_terrain_stone_hard.png^[colorize:" ..color
--local spike = modname.. "_urchin_spike.png"
local quill = spike.. "^[mask:" ..modname.. "_urchin_quill.png"
------------------------------------------------------------------------
minetest.register_node(modname.. ":urchin_" ..id.. "_spike", {
	description = "Urchin Quill",
	drawtype = "nodebox",
	node_box = nodecore.fixedbox(-1/16, -0.5, -1/16, 1/16, 0, 1/16),
	selection_box = nodecore.fixedbox(-1/8, -0.5, -1/8, 1/8, 0, 1/8),
	tiles = {spike},
	inventory_image = quill,
	wield_image = quill,
	sunlight_propagates = true,
	paramtype = 'light',
	paramtype2 = 'wallmounted',
	walkable = false,
	damage_per_second = str,
	move_resistance = 2*str,
	groups = {
		snappy = 1,
		quill = 1,
--		damage_touch = 1,
		flammable = 100,
		attached_node = 1,
	},
	sounds = nodecore.sounds("nc_terrain_stoney"),
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "crush urchin " ..id,
	action = "pummel",
	toolgroups = {thumpy = 3},
	indexkeys = {modname.. ":urchin_" ..id},
	nodes = {{match = modname .. ":urchin_" ..id, replace = "nc_terrain:sand"}},
--	items = {{name = modname.. ":urchin_" ..id.. "_spike", count = 1}},
	after=function(pos)
		local yield = math.random(0,3)
		nodecore.item_eject(pos, {name = modname.. ":urchin_" ..id.. "_spike"}, 1, yield)
	end
})
------------------------------------------------------------------------
end
------------------------------------------------------------------------
urchin_type("purple",	1,	"PURPLE:140",	0.5,		-1,	-64)
urchin_type("red",		2,	"RED:140",	0.75,	-64,	-256)
urchin_type("black",	3,	"BLACK:140",	1.25,	-16,	-128)
urchin_type("white",	4,	"WHITE:140",	1.75,	-128,-5000)
------------------------------------------------------------------------
-- ================================================================== --


