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
local water_level = tonumber(minetest.get_mapgen_setting("water_level"))
------------------------------------------------------------------------
-- ================================================================== --
-- seajellies & kelp already incidentally kill sponges & coral
-- urchins eat kelp and reproduce
-- 
-- ================================================================== --
local function urchins(id)
	minetest.register_abm({
		label = id.. "Urchin Eating Kelp",
		interval = 4,
		chance = 4,
		nodenames = {"group:kelp"},
		neighbors = {modname.. ":urchin_" ..id},
		neighbors_invert = true,
		action = function(pos)
		  if not nodecore.find_nodes_around(pos, "group:kelp") then return end
			if math.random(1,10) == 10 then
				minetest.set_node(pos, {name = modname.. ":urchin_id"})
				minetest.check_for_falling(pos)
				else minetest.set_node(pos, {name = water})
			end
		end
	})
end
urchins("purple")
urchins("red")
urchins("black")
urchins("white")
------------------------------------------------------------------------
