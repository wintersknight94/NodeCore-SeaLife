-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, pairs, vector
    = minetest, nodecore, pairs, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local alldirs = nodecore.dirs()
local spongewet = modname .. ":sponge_slime"
local rfcall = function(pos, data)
	local ref = minetest.get_player_by_name(data.pname)
	local wield = ref:get_wielded_item()
	wield:take_item(1)
	ref:set_wielded_item(wield)
end
-- ================================================================== --
minetest.register_node(modname .. ":sponge_slime", {
		description = "Jellied Sponge",
		drawtype = "allfaces_optional",
		tiles = {"(nc_sponge.png^nc_tree_leaves_bud.png)^(nc_tree_peat.png^[opacity:128)^(nc_terrain_water.png^[opacity:96)"},
		paramtype = "light",
		groups = {
			crumbly = 3,
			coolant = 1,
			moist = 1,
			sponge = 1,
			slippery = 32,
			bouncy = 64,
			fall_damage_add_percent = -48
		},
		sounds = nodecore.sounds("nc_terrain_swishy"),
		mapcolor = {r = 142, g = 133, b = 188},
	})
-- ================================================================== --
nodecore.register_craft({
	label = "squeeze jellied sponge",
	action = "pummel",
	toolgroups = {thumpy = 1},
	indexkeys = {spongewet},
	nodes = {{match = spongewet}},
	after = function(pos, node)
	  local top = {x = pos.x, y = pos.y + 0.5, z = pos.z}
	  local found
		for _, d in pairs(alldirs) do
		  local p = vector.add(pos, d)
		  local pnode = minetest.get_node(p)
			if pnode.name == "nc_terrain:water_source" then
				nodecore.set_loud(p, {name = modname.. ":seajelly_" ..math.random(1,4)})
				nodecore.set_loud(pos, {name = "nc_sponge:sponge"})
			end
			nodecore.bubblefx(top)
			nodecore.sound_play("nc_terrain_watery", {gain = 1, pos = pos})
		end
	end
})
------------------------------------------------------------------------
minetest.register_abm({
		label = "jellied sponge drying",
		interval = 1,
		chance = 20,
		nodenames = {modname .. ":sponge_slime"},
		neighbors = {"group:igniter"},
		action = function(pos)
			nodecore.sound_play("nc_api_craft_hiss", {gain = 0.02, pos = pos})
			return minetest.set_node(pos, {name = "nc_sponge:sponge"})
		end
	})
-- ================================================================== --
for i = 1,4 do
	nodecore.register_craft({
		label = "sponge seajelly",
		action = "pummel",
		duration = -1,
		priority = 1,
		wield = {name = "nc_sponge:sponge_wet"},
		consumewield = 1,
		indexkeys = {modname.. ":seajelly_" ..i},
--		after = rfcall,
		nodes = {
			{match = {name = modname.. ":seajelly_" ..i}, replace = modname.. ":sponge_slime"},
		}
	})
end