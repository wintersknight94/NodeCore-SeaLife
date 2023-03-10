-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, math, vector
    = minetest, nodecore, math, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local get_node = minetest.get_node
local set_node = minetest.swap_node
------------------------------------------------------------------------
local directions = {
	{x=1, y=0, z=0}, {x=-1, y=0, z=0}, {x=0, y=0, z=1}, {x=0, y=0, z=-1},
	{x=1, y=0, z=1}, {x=1, y=0, z=-1}, {x=-1, y=0, z=1}, {x=-1, y=0, z=-1},
	{x=1, y=1, z=0}, {x=-1, y=1, z=0}, {x=0, y=1, z=1}, {x=0, y=1, z=-1},
	{x=1, y=1, z=1}, {x=1, y=1, z=-1}, {x=-1, y=1, z=1}, {x=-1, y=1, z=-1},
	{x=1, y=-1, z=0}, {x=-1, y=-1, z=0}, {x=0, y=-1, z=1}, {x=0, y=-1, z=-1},
	{x=1, y=-1, z=1}, {x=1, y=-1, z=-1}, {x=-1, y=-1, z=1}, {x=-1, y=-1, z=-1},
}
-- ================================================================== --
nodecore.register_abm({
	label = "drifting:random",
	nodenames = {"group:drifting"},
	interval = 10,
	chance = 10,
	action = function(pos, node)
		local dir = directions[math.random(1,24)]
		local next_pos = vector.add(pos, dir)
		local next_node = minetest.get_node(next_pos)	
			if next_node.name == "nc_terrain:water_source" then
				minetest.swap_node(next_pos, node)
				minetest.swap_node(pos, next_node)
			end
		end
})
-- ================================================================== --
