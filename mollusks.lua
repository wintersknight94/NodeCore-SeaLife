-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, math
    = minetest, nodecore, math
local math_random, math_sqrt
    = math.random, math.sqrt
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local function findwater(pos)
	return nodecore.find_nodes_around(pos, "group:water")
end
local breedcost = 12000
------------------------------------------------------------------------
local water = "nc_terrain:water_source"
local trideadna = "nc_concrete:wc_sealife_seament_vermy"
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
			stack_as_node = 1,
			falling_node = 1,
		},
		stack_max = 1,
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
nodecore.register_abm({
	label = "Tridacna Starvation",
	interval = 20,
	chance = 4,
	nodenames = {"group:clam_living"},
	action = function(pos, node)
		if #nodecore.find_nodes_around(pos, {"group:water"}, 1) >= 8 then
			return
		end
			nodecore.set_loud(pos, {name = trideadna})
			nodecore.bubblefx(pos)
	end
})
------------------------------------------------------------------------
nodecore.register_aism({
	label = "Tridacna Stack Starvation",
	interval = 20,
	chance = 4,
	itemnames = {modname .. ":mollusk"},
	action = function(stack, data)
		if data.toteslot then return end
		if data.player and data.list then
			local inv = data.player:get_inventory()
			for i = 1, inv:get_size(data.list) do
				local item = inv:get_stack(data.list, i):get_name()
				if minetest.get_item_group(item, "moist") > 0 then return end
			end
		end
		if #nodecore.find_nodes_around(data.pos, "group:moist", 2) > 0 then return end
		nodecore.bubblefx(data.pos)
		local taken = stack:take_item(1)
		taken:set_name(trideadna)
		if data.inv then taken = data.inv:add_item("main", taken) end
		if not taken:is_empty() then nodecore.item_eject(data.pos, taken) end
		return stack
	end
})
-- ================================================================== --
nodecore.register_soaking_abm({
		label = "mollusk reproduction",
		fieldname = "molluschizm",
		nodenames = {modname .. ":mollusk"},
		interval = 60,
		arealoaded = 2,
		soakrate = function() return 2 end,
		soakcheck = function(data, pos)
			if #nodecore.find_nodes_around(pos, {"group:water"}, 1) <= 8 then
				return --minetest.chat_send_all("not enough water")
			end
			if data.total >= breedcost then
--				minetest.chat_send_all("multiplying")
				nodecore.item_eject(pos, modname .. ":mollusk", 8, 1, {x = math.random(-0.5,0.5), y = 2, z = math.random(-0.5,0.5)})
				nodecore.bubblefx(pos)
				return data.total - breedcost
			end
		end
	})
-- ================================================================== --