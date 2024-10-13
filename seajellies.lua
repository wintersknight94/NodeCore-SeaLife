-- LUALOCALS < ---------------------------------------------------------
local math, minetest, nodecore, tostring
    = math, minetest, nodecore, tostring
local math_ceil, math_cos, math_pi, math_random
    = math.ceil, math.cos, math.pi, math.random
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
-- ================================================================== --
local function register_jelly(id, color, light, postfx)
------------------------------------------------------------------------
	local base = (nodecore.tmod(modname.. "_jelly.png^[colorize:" ..color)
		:resize(16, 16))
	local liv1 = (nodecore.tmod("nc_sponge_living.png")
		:resize(16, 16)
		:mask("nc_sponge_mask1.png"))
	local liv2 = (nodecore.tmod("nc_sponge_living.png")
		:resize(16, 16)
		:mask(nodecore.tmod("nc_sponge_mask1.png")
			:invert("a")))
	local h = 32
	local txr = nodecore.tmod:combine(16, h * 16)
	for i = 0, h - 1 do
		local a1 = math_ceil(math_cos(i * math_pi * 2 / h) * 63 + 192)
		local a2 = math_ceil(-math_cos(i * math_pi * 2 / h) * 63 + 192)
		txr = txr:layer(0, 16 * i, base
			:add(liv1:opacity(a1))
			:add(liv2:opacity(a2))
		)
	end
------------------------------------------------------------------------
	minetest.register_node(modname.. ":seajelly_" ..id, {
		description = "Seajelly",
		drawtype = "glasslike",
--		drawtype = "allfaces_optional",
		use_texture_alpha = "blend",
		waving = 1,
		tiles = {
			{
				name = tostring(txr),
				animation = {
					["type"] = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2
				}
			}
		},
		groups = {
			snappy = 1,
			jelly = 1,
			jelly_living = 1,
			sealife = 1,
			drifting = 1,
			damage_touch = 1,
		},
		drowning = 2,
		post_effect_color = postfx,
		liquids_pointable = true,
		walkable = false,
		damage_per_second = 1,
		move_resistance = 4,
		drop_in_place = "nc_terrain:water_flowing",
		sounds = nodecore.sounds("nc_terrain_watery"),
		light_source = light, glow = 1,
	})
end
------------------------------------------------------------------------
register_jelly("1",		"#00bfff:140",	2,	{a=140, r=80, g=80, b=140})
register_jelly("2",		"#fba0e3:160",	4,	{a=140, r=140, g=100, b=140})
register_jelly("3",		"LIME:140",	6,	{a=140, r=80, g=140, b=80})
register_jelly("4",		"WHITE:180",	8,	{a=140, r=140, g=140, b=140})
-- ================================================================== --
minetest.register_decoration({
	name = modname.. ":seajellys_intertidal",
	deco_type = "simple",
	place_on = {"nc_terrain:sand"},
	place_offset_y = math.random(1,3),
	spawn_by = {"group:water"},
	num_spawn_by = 6,
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"seabed"},
	y_max = -4,
	y_min = -16,
	flags = "force_placement",
	decoration = {
		modname.. ":seajelly_1",
		modname.. ":seajelly_2",
	},
})
------------------------------------------------------------------------
minetest.register_decoration({
	name = modname.. ":seajellys_extratidal",
	deco_type = "simple",
	place_on = {"nc_terrain:sand"},
	place_offset_y = math.random(4,7),
	spawn_by = {"group:water"},
	num_spawn_by = 6,
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"seabed"},
	y_max = -8,
	y_min = -24,
	flags = "force_placement",
	decoration = {
		modname.. ":seajelly_1",
		modname.. ":seajelly_2",
	},
})
------------------------------------------------------------------------
minetest.register_decoration({
	name = modname.. ":seajellys_coastal",
	deco_type = "simple",
	place_on = {"nc_terrain:sand"},
	place_offset_y = math.random(8,16),
	spawn_by = {"group:water"},
	num_spawn_by = 6,
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"seabed"},
	y_max = -32,
	y_min = -64,
	flags = "force_placement",
	decoration = {
		modname.. ":seajelly_1",
		modname.. ":seajelly_2",
		modname.. ":seajelly_3",
	},
})
------------------------------------------------------------------------
minetest.register_decoration({
	name = modname.. ":seajellys_seas",
	deco_type = "simple",
	place_on = {"nc_terrain:sand"},
	place_offset_y = math.random(8,24),
	spawn_by = {"group:water"},
	num_spawn_by = 6,
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"seabed", "deep"},
	y_max = -32,
	y_min = -80,
	flags = "force_placement",
	decoration = {
		modname.. ":seajelly_2",
		modname.. ":seajelly_3",
	},
})
------------------------------------------------------------------------
minetest.register_decoration({
	name = modname.. ":seajellys_depths",
	deco_type = "simple",
	place_on = {"nc_terrain:sand", "nc_terrain:stone", "nc_concrete:sandstone"},
	place_offset_y = math.random(8,32),
	spawn_by = {"group:water"},
	num_spawn_by = 6,
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"seabed", "deep"},
	y_max = -80,
	y_min = -1024,
	flags = "force_placement",
	decoration = {
		modname.. ":seajelly_4",
	},
})
-- ================================================================== --

nodecore.register_abm({
	label = "Seajelly Asphixiation",
	interval = 4,
	chance = 2,
	nodenames = {"group:jelly_living"},
	action = function(pos, node)
		if #nodecore.find_nodes_around(pos, {"group:water"}, 1) >= 8 then
			return
		end
			nodecore.set_loud(pos, {name = "nc_terrain:water_flowing"})
			nodecore.bubblefx(pos)
	end
})
