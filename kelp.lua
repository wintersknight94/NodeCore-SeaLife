-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local water = "nc_terrain:water_source"
local watertxr = "(nc_terrain_water.png^[verticalframe:32:8)^[opacity:160"
local kelp = modname.. "_kelp.png"
local function findwater(pos)
	return nodecore.find_nodes_around(pos, "group:water")
end

--[[
local function kelp_water(pos)
	local node = minetest.get_node(pos)
	local def = minetest.registered_nodes[node.name]
	return def and def.water
end
local function kelp_soil(pos)
	local node = minetest.get_node(pos)
	local soil = minetest.get_item_group(node.name, "sand")
	return soil and soil > 0
end
]]

-- ================================================================== --
minetest.register_node(modname .. ":kelp_living", {
	description = "Kelp",
	tiles = {watertxr.. "^nc_tree_leaves.png"},--^[colorize:#2e8b57:120"},
	inventory_image = kelp,
	wield_image = kelp,
	color = "#2e8b57", --SeaGreen
	drawtype = "allfaces_optional",
	paramtype = "light",
	groups = {
		snappy = 1,
		flammable = 20,
		fire_fuel = 5,
		kelp = 1,
		kelp_living = 1,
--		flora = 1,
		falling_node = 1
	},
	walkable = false,
	climbable = true,
	waving = 1,
	sounds = nodecore.sounds("nc_terrain_swishy")
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":kelp_dead", {
	description = "Dead Kelp",
	tiles = {"nc_flora_thatch.png"},--^[colorize:#2e8b57:120"},
	inventory_image = kelp.. "^[colorize:#867e36:200",
	wield_image = kelp.. "^[colorize:#867e36:200",
--	color = "#228b22", --ForestGreen
	color = "#78866b", --Camo Green
--	color = "#8f9779", --Artichoke
	groups = {
		snappy = 1,
		flammable = 3,
		fire_fuel = 5,
		kelp = 1,
		flora = 1,
		falling_repose = 1
	},
	sounds = nodecore.sounds("nc_terrain_swishy")
})
-- ================================================================== --
minetest.register_abm({
		label = "kelp star dry",
		interval = 1,
		chance = 100,
		nodenames = {modname .. ":kelp_living"},
		arealoaded = 1,
		action = function(pos)
			local above = {x = pos.x, y = pos.y + 1, z = pos.z}
			if nodecore.is_full_sun(above) and #findwater(pos) < 1 then
				nodecore.sound_play("nc_api_craft_hiss", {gain = 0.02, pos = pos})
				return minetest.set_node(pos, {name = modname .. ":kelp_dead"})
			end
		end
	})

nodecore.register_aism({
		label = "kelp stack star dry",
		interval = 1,
		chance = 100,
		arealoaded = 1,
		itemnames = {modname .. ":kelp_living"},
		action = function(stack, data)
			if data.player and (data.list ~= "main"
				or data.slot ~= data.player:get_wield_index()) then return end
			if data.pos and nodecore.is_full_sun(data.pos)
			and #findwater(data.pos) < 1 then
				nodecore.sound_play("nc_api_craft_hiss", {gain = 0.02, pos = data.pos})
				local taken = stack:take_item(1)
				taken:set_name(modname .. ":kelp_dead")
				if data.inv then taken = data.inv:add_item("main", taken) end
				if not taken:is_empty() then nodecore.item_eject(data.pos, taken) end
				return stack
			end
		end
	})

minetest.register_abm({
		label = "kelp fire dry",
		interval = 1,
		chance = 20,
		nodenames = {modname .. ":kelp_living"},
		neighbors = {"group:igniter"},
		action = function(pos)
			nodecore.sound_play("nc_api_craft_hiss", {gain = 0.02, pos = pos})
			return minetest.set_node(pos, {name = modname .. ":kelp_dead"})
		end
	})
-- ================================================================== --
-- need to eventually make it so that they can reach the surface and spread horizontally under overgrow conditions
minetest.register_abm({
	label = "kelp growing",
	nodenames = {modname .. ":kelp_living"},
	interval = 300, --300,
	chance = 20, --20,
	action = function(pos)
	  local above = {x = pos.x, y = pos.y + 1, z = pos.z}
	  local above2 = {x = pos.x, y = pos.y + 2, z = pos.z}
	  local anode = minetest.get_node(above).name
	  local a2node = minetest.get_node(above2).name
--		if a2node == "air" then return end
		if anode ~= "nc_terrain:water_source" then return end
		if a2node ~= "nc_terrain:water_source" then return end
		if a2node == "nc_terrain:water_source" then
			nodecore.set_loud(above, {name = modname .. ":kelp_living"})
		end
	end,
})
--[[
minetest.register_abm({
	label = "kelp growing",
	nodenames = {modname .. ":kelp_living"},
	interval = 60, --60,
	chance = 10, --10,
	action = function(pos)
		local up = {x = pos.x, y = pos.y + 1, z = pos.z}
		if not findwater(up) then return end
			local down = {x = pos.x, y = pos.y - 1; z = pos.z}
			local dname = minetest.get_node(down).name
--				if dname ~= modname .. ":kelp_living" then
			if minetest.get_item_group(dname, "kelp_living") <=0 then
				return kelp_soil(down) and minetest.set_node(up,
					{name = modname .. ":kelp_living"})
			end
	end,
})
]]
-- ================================================================== --
minetest.register_decoration({
	name = modname.. ":kelp",
	deco_type = "simple",
	place_on = {"group:sand"},
	place_offset_y = -1,
	sidelen = 16,
	noise_params = {
		offset = -0.04,
		scale = 0.1,
		spread = {x = 128, y = 128, z = 128},
		seed = 87112,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"seabed"},
	y_max = -8,
	y_min = -32,
	flags = "force_placement",
	decoration = modname.. ":kelp_living",
	height = 4,
	height_max = 8,
})
