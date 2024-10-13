-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, math
    = minetest, nodecore, math
local math_random
	= math.random
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local water_level = tonumber(minetest.get_mapgen_setting("water_level"))
local water = "nc_terrain:water_source"
-- ================================================================== --
local verdant = {
	name = modname.. "_seagrass.png",
	tileable_vertical = true,
	waving = 1,
	animation = {
		type="vertical_frames",
		length = 5
	}
}
local verdantitem = modname.. "_kelp.png^[colorize:blue:64"
--local verdant = "(nc_terrain_grass_top.png^[mask:nc_concrete_pattern_verty.png)"
-- ================================================================== --
minetest.register_node(modname.. ":seagrass", {
	description = "Seagrass",
	drawtype = "plantlike_rooted",
	tiles = {"nc_terrain_sand.png"},
	falling_visual = {"nc_terrain:sand"},
	special_tiles = {verdant},
	inventory_image = verdantitem,
	wield_image = verdantitem,
	use_alpha_texture = "clip",
	sunlight_propagates = true,
	paramtype = 'light',
	paramtype2 = "leveled",
	leveled_max = 95,
--	place_param2 = math.random(8,64),
	groups = {
		sealife = 1,
		seagrass = 1,
		crumbly = 1,
		peat_grindable_item = 1,
	},
--	walkable = false,
	move_resistance = 1,
	silktouch = false,
	sounds = nodecore.sounds("nc_terrain_swishy", nil, 2),
	drop_in_place = "nc_terrain:sand_loose",
	after_dig_node = function(pos,data)
		local count = data.param2/16
		pos.y = pos.y + 1
		return nodecore.item_eject(pos, modname .. ":seagrass", 0, count, {x = 0, y = 2, z = 0})
	end,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type == "node" and placer and
				not placer:get_player_control().sneak then
			local node_ptu = minetest.get_node(pointed_thing.under)
			local def_ptu = minetest.registered_nodes[node_ptu.name]
			if def_ptu and def_ptu.on_rightclick then
				return def_ptu.on_rightclick(pointed_thing.under, node_ptu, placer,
					itemstack, pointed_thing)
			end
		end
			local pos = pointed_thing.under
		if minetest.get_node(pos).name ~= "nc_terrain:sand_loose" then
			return itemstack 
		end
			local height = math.random(1, 4)
			local pixel = math.random(1, 6)
		local pos_top = {x = pos.x, y = pos.y + height, z = pos.z}
		local node_top = minetest.get_node(pos_top)
		local def_top = minetest.registered_nodes[node_top.name]
		local player_name = placer:get_player_name()
			if def_top and def_top.liquidtype == "source" and
			minetest.get_item_group(node_top.name, "water") > 0 then
			minetest.set_node(pos, {name = modname.. ":seagrass", param2 = height * pixel})
			itemstack:take_item()
		end
		return itemstack
	end,
})
-- ================================================================== --
minetest.register_decoration({
	label = modname .. "_seagrass_wild",
	deco_type = "simple",
	place_on = "group:sand",
	spawn_by = {"group:water"},
	num_spawn_by = 1,
	sidelen = 16,
	noise_params = {
		offset = -0.04,
		scale = 0.1,
		spread = {x = 128, y = 128, z = 128},
		seed = 10201,
		octaves = 3,
		persist = 0.7
	},
	biomes = "seabed",
	y_max = -4,
	y_min = -16,
	decoration = {modname.. ":seagrass"},
	param2 = 1,
	param2_max = 64,
	flags = "force_placement",
	place_offset_y = -1,
})
minetest.register_decoration({
	label = modname .. "_seagrass_shallow",
	deco_type = "simple",
	place_on = "group:sand",
	spawn_by = {"group:water"},
	num_spawn_by = 1,
	sidelen = 16,
	noise_params = {
		offset = -0.03,
		scale = 0.2,
		spread = {x = 64, y = 64, z = 64},
		seed = 31415,
		octaves = 3,
		persist = 0.7
	},
	biomes = "seabed",
	y_max = 0,
	y_min = -6,
	decoration = {modname.. ":seagrass"},
	param2 = 1,
	param2_max = 15,
	flags = "force_placement",
	place_offset_y = -1,
})
-- ================================================================== --
nodecore.register_abm({
	label = "Seagrass Growing",
	interval = 300, --approx.5min
	chance = 20,
	nodenames = {modname.. ":seagrass"},
	action = function(pos, node, data)
	  local level= minetest.get_node_level(pos)
	  local height = (level/16)+1
	  local pos_top = {x = pos.x, y = pos.y + height, z = pos.z}
	  local node_top = minetest.get_node(pos_top)
	  local def_top = minetest.registered_nodes[node_top.name]
		if def_top and def_top.liquidtype == "source" and
			minetest.get_item_group(node_top.name, "water") > 0 then
			minetest.add_node_level(pos, 1)
		end
	end
})
-- ================================================================== --
nodecore.register_craft({
	label = "pack thatch from seagrass",
	action = "pummel",
	toolgroups = {thumpy = 1},
	nodes = {
		{
			match = {groups = {seagrass = true}, count = 8},
			replace = "nc_flora:thatch"
		}
	},
})
