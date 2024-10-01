-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
local ymin = -64
local ymax = -1
------------------------------------------------------------------------
local box = {
	type="fixed",
	fixed = { {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}, },
}
-- ================================================================== --
local function anemone(id, grip)
------------------------------------------------------------------------
local anemone = {
	name = modname.. "_anemone.png",
	tileable_vertical = true,
	waving = 1,
	animation = {
		type="vertical_frames",
		length = 3
	}
}
------------------------------------------------------------------------
	minetest.register_node(modname.. ":anemone_" ..id, {
		description = "Anemone",
		drawtype = "plantlike_rooted",
		tiles = {grip},
		falling_visual = {anemone},
		special_tiles = {anemone},
		visual_scale = 1,
		sunlight_propagates = true,
		paramtype = 'light',
		paramtype2 = "meshoptions",
		place_param2 = 10,
		groups = {
			anemone = 1,
--			sessile = 1,
			sealife = 1,
			stack_as_node = 1,
			damage_touch = 1,
			damage_pickup = 1,
			tongs_pickup = 1,
			peat_grindable_node = 1,
			falling_node = 1,
		},
		walkable = false,
		waving = 1,
		damage_per_second = 2,
		move_resistance = 4,
		sounds = nodecore.sounds("nc_terrain_watery"),
		selection_box = box,
		collision_box = box,
	})
------------------------------------------------------------------------
minetest.register_abm({
	label = "anemone death",
	interval = 4,
	chance = 4,
	nodenames = {modname.. ":anemone_" ..id},
	neighbors = {"air"},
	action = function(pos, node)
		  local yield = math.random(0,3)
		  local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		  local anode = minetest.get_node(above).name
			if anode == "air" then
				nodecore.set_node(pos, {name = modname.. ":coral_dead"})
			end
	end
})

end
------------------------------------------------------------------------	
anemone("sand",	"nc_terrain_sand.png")
anemone("coral",	modname.. "_coral.png^[colorize:#3cb371:140")
anemone("dying",	modname.. "_coral.png^[colorize:WHITE:140")
------------------------------------------------------------------------
-- ================================================================== --
------------------------------------------------------------------------
minetest.register_decoration({
	label = modname .. ":anemones_living",
	deco_type = "simple",
	place_on = "group:sand",
	spawn_by = {"group:coral_living"},
	num_spawn_by = 1,
	sidelen = 8,
	fill_ratio = 0.05,
	biomes = "seabed",
	y_max = ymax,
	y_min = ymin,
	decoration = {
		modname.. ":anemone_sand",
		modname.. ":anemone_coral",
	},
	param2 = 10,
	flags = "force_placement",
	place_offset_y = -1,
})
------------------------------------------------------------------------
minetest.register_decoration({
	label = modname .. ":anemones_dying",
	deco_type = "simple",
	place_on = {"group:sand"},
	spawn_by = {"group:coral_dead"},
	num_spawn_by = 1,
	sidelen = 8,
	fill_ratio = 0.05,
	biomes = "seabed",
	y_max = ymax,
	y_min = ymin,
	decoration = {
		modname.. ":anemone_sand",
		modname.. ":anemone_dying",
	},
	param2 = 10,
	flags = "force_placement",
	place_offset_y = -1,
})
-- ================================================================== --


