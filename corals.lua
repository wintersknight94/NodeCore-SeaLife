-- LUALOCALS < ---------------------------------------------------------
local math, minetest, nodecore, tostring
    = math, minetest, nodecore, tostring
local math_ceil, math_cos, math_pi
    = math.ceil, math.cos, math.pi
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
-- ================================================================== --
local function register_coral(id, color)
------------------------------------------------------------------------
	local base = (nodecore.tmod(modname.. "_coral.png^[colorize:" ..color)
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
	minetest.register_node(modname.. ":coral_living_" ..id, {
		description = "Living Coral",
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
			cracky = 2,
			coral = 1,
			coral_living = 1,
			sealife = 1,
		},
--		drop_in_place = modname.. ":coral_dead",
		sounds = nodecore.sounds("nc_terrain_stony", nil, 1.3),
	})
end
------------------------------------------------------------------------
register_coral("1",		"#960018:90")	--Carmine (Red)
register_coral("2",		"#e48400:90")	--Fulvous (Orange)
register_coral("3",		"#fcf75e:90")	--Icterine (Yellow)
register_coral("4",		"#3cb371:140")	--Sea Green
--register_coral("4",		"#007f66:90")	--Viridian (Green)
register_coral("5",		"BLUE:60")	--
register_coral("6",		"VIOLET:90")	--
register_coral("7",		"#fba0e3:180")	--Lavender Rose
register_coral("8",		"#00bfff:120")	--Deep Sky Blue
------------------------------------------------------------------------
minetest.register_node(modname.. ":coral_dead", {
	description = "Dead Coral",
	tiles = {modname.. "_coral.png^[colorize:WHITE:140"},
	groups = {
		cracky = 2,
		coral = 1,
		coral_dead = 1,
	},
	alternate_loose = {
		tiles = {"(" ..modname.. "_coral.png^[colorize:WHITE:140)^nc_api_loose.png"},
		groups = {
			crumbly = 2,
			coral = 1,
			coral_dead = 1,
			coral_loose = 1,
			falling_repose = 2,
		},
		sounds = nodecore.sounds("nc_terrain_chompy"),
	},
	sounds = nodecore.sounds("nc_terrain_stony"),
})
-- ================================================================== --
minetest.register_decoration({
	name = modname.. ":corals",
	deco_type = "simple",
	place_on = {"nc_terrain:sand", modname.. ":coral_dead"},
--	place_offset_y = -1,
	sidelen = 4,
	noise_params = {
		offset = -4,
		scale = 4,
		spread = {x = 64, y = 64, z = 64},
		seed = 7013,
		octaves = 3,
		persist = 0.7,
	},
	biomes = {"seabed"},
	y_max = -3,
	y_min = -16,
	flags = "force_placement",
	decoration = {
		modname.. ":coral_living_1",
		modname.. ":coral_living_2",
		modname.. ":coral_living_3",
		modname.. ":coral_living_4",
		modname.. ":coral_living_5",
		modname.. ":coral_living_6",
		modname.. ":coral_living_7",
		modname.. ":coral_living_8",
	},
})
------------------------------------------------------------------------
minetest.register_decoration({
	name = modname.. ":corals_dying",
	deco_type = "simple",
	place_on = {"nc_terrain:sand"},
--	place_offset_y = -1,
	sidelen = 4,
	noise_params = {
		offset = -4,
		scale = 4,
		spread = {x = 64, y = 64, z = 64},
		seed = 3030,
		octaves = 3,
		persist = 0.7,
	},
	biomes = {"seabed"},
	y_max = -8,
	y_min = -32,
	flags = "force_placement",
	decoration = {
		modname.. ":coral_living_1",
		modname.. ":coral_living_2",
		modname.. ":coral_dead",
		modname.. ":coral_living_4",
		modname.. ":coral_dead",
		modname.. ":coral_dead",
		modname.. ":coral_dead",
		modname.. ":coral_dead",
	},
})
------------------------------------------------------------------------
minetest.register_decoration({
	name = modname.. ":corals_skeletal",
	deco_type = "simple",
	place_on = {"nc_terrain:sand", "nc_concrete:sandstone"},
--	place_offset_y = -1,
	sidelen = 4,
	noise_params = {
		offset = -3,
		scale = 3,
		spread = {x = 64, y = 64, z = 64},
		seed = 3237,
		octaves = 3,
		persist = 0.5,
	},
	biomes = {"seabed", "deep"},
	y_max = -12,
	y_min = -64,
	flags = "force_placement",
	decoration = {
		modname.. ":coral_dead",

	},
})
-- ================================================================== --
nodecore.register_craft({
	label = "crush dead coral to sand",
	action = "pummel",
	toolgroups = {thumpy = 4},
	indexkeys = {modname .. ":coral_dead"},
	nodes = {
		{match = modname .. ":coral_dead", replace = "nc_terrain:sand"}
	}
})
