-- LUALOCALS < ---------------------------------------------------------
local include, minetest, nodecore, pairs, vector
    = include, minetest, nodecore, pairs, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local localpref = "nc_concrete:" .. modname:gsub("^nc_", "") .. "_"
------------------------------------------------------------------------
local seament	= modname.. "_seament.png"
local deadcoral	= modname.. "_coral.png^[colorize:WHITE:140"
local seamix	= deadcoral.. "^(nc_fire_ash.png^[mask:nc_concrete_mask.png)"
-- ================================================================== --
minetest.register_node(modname .. ":seament", {
	description = "Seament",
	tiles = {seament},
	groups = {
		cracky = 2,
		seament = 1,
		coral_dead = 1,
	},
	drop_in_place = modname.. ":coral_dead_loose",
	crush_damage = 2,
	sounds = nodecore.sounds("nc_terrain_stony"),
	mapcolor = {r = 200, g = 220, b = 220},
})
-- ================================================================== --
nodecore.register_concrete_etchable({
		basename = modname .. ":seament",
		pattern_opacity = 32,
		pattern_invert = true,
		pliant = {
			sounds = nodecore.sounds("nc_terrain_crunchy"),
			drop_in_place = modname .. ":seamix_wet_source",
			silktouch = false
		}
	})
------------------------------------------------------------------------
nodecore.register_concrete({
	description = "Seamix",
	tile_powder = seamix,
	tile_wet = deadcoral.. "^(nc_fire_ash.png^("
	.. "nc_terrain_gravel.png^[opacity:128)^[mask:nc_concrete_mask.png)",
	sound = "nc_terrain_chompy",
	groups_powder = {crumbly = 1},
	swim_color = {r = 150, g = 90, b = 100},
	craft_from_keys = {"group:coral_dead"},
	craft_from = {groups = {coral_dead = true}},
	to_crude = modname.. ":coral_dead",
	to_washed = modname.. ":coral_dead",
	to_molded = localpref .. "seament_blank_ply"
})
------------------------------------------------------------------------
nodecore.register_stone_bricks("seament", "Seament",
	seament,
	180, 100,
	modname .. ":seament",
	{cracky = 1},
	{
		cracky = 2,
		nc_door_scuff_opacity = 45,
		door_operate_sound_volume = 80
	}
)