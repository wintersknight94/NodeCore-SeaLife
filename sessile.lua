-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, math, vector
    = minetest, nodecore, math, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local get_node = minetest.get_node
local set_node = minetest.swap_node
------------------------------------------------------------------------
local all_direction_permutations = {              -- table of all possible permutations of horizontal direction to avoid lots of redundant calculations.
	{{x=0,z=1},{x=0,z=-1},{x=1,z=0},{x=-1,z=0}},
	{{x=0,z=1},{x=0,z=-1},{x=-1,z=0},{x=1,z=0}},
	{{x=0,z=1},{x=1,z=0},{x=0,z=-1},{x=-1,z=0}},
	{{x=0,z=1},{x=1,z=0},{x=-1,z=0},{x=0,z=-1}},
	{{x=0,z=1},{x=-1,z=0},{x=0,z=-1},{x=1,z=0}},
	{{x=0,z=1},{x=-1,z=0},{x=1,z=0},{x=0,z=-1}},
	{{x=0,z=-1},{x=0,z=1},{x=-1,z=0},{x=1,z=0}},
	{{x=0,z=-1},{x=0,z=1},{x=1,z=0},{x=-1,z=0}},
	{{x=0,z=-1},{x=1,z=0},{x=-1,z=0},{x=0,z=1}},
	{{x=0,z=-1},{x=1,z=0},{x=0,z=1},{x=-1,z=0}},
	{{x=0,z=-1},{x=-1,z=0},{x=1,z=0},{x=0,z=1}},
	{{x=0,z=-1},{x=-1,z=0},{x=0,z=1},{x=1,z=0}},
	{{x=1,z=0},{x=0,z=1},{x=0,z=-1},{x=-1,z=0}},
	{{x=1,z=0},{x=0,z=1},{x=-1,z=0},{x=0,z=-1}},
	{{x=1,z=0},{x=0,z=-1},{x=0,z=1},{x=-1,z=0}},
	{{x=1,z=0},{x=0,z=-1},{x=-1,z=0},{x=0,z=1}},
	{{x=1,z=0},{x=-1,z=0},{x=0,z=1},{x=0,z=-1}},
	{{x=1,z=0},{x=-1,z=0},{x=0,z=-1},{x=0,z=1}},
	{{x=-1,z=0},{x=0,z=1},{x=1,z=0},{x=0,z=-1}},
	{{x=-1,z=0},{x=0,z=1},{x=0,z=-1},{x=1,z=0}},
	{{x=-1,z=0},{x=0,z=-1},{x=1,z=0},{x=0,z=1}},
	{{x=-1,z=0},{x=0,z=-1},{x=0,z=1},{x=1,z=0}},
	{{x=-1,z=0},{x=1,z=0},{x=0,z=-1},{x=0,z=1}},
	{{x=-1,z=0},{x=1,z=0},{x=0,z=1},{x=0,z=-1}},
}

-- ================================================================== --
nodecore.register_abm({
		label = "movement:sessile",
		nodenames = {"group:sessile"},
		neighbors = {"nc_terrain:water_source"},
		interval = 10, 
		chance = 10,
		action = function(pos,node) -- Do everything possible to optimize this method
				local check_pos = {x=pos.x, y=pos.y-1, z=pos.z}
				local check_node = get_node(check_pos)
				local check_node_name = check_node.name
				if check_node_name == "nc_terrain:sand" or check_node_name == "nc_terrain:sand_loose" then
					set_node(pos, check_node)
					set_node(check_pos, node)
					return
				end
				local perm = all_direction_permutations[math.random(24)]
				local dirs -- declare outside of loop so it won't keep entering/exiting scope
				for i=1,4 do
					dirs = perm[i]
					-- reuse check_pos to avoid allocating a new table
					check_pos.x = pos.x + dirs.x 
					check_pos.y = pos.y
					check_pos.z = pos.z + dirs.z
					check_node = get_node(check_pos)
					check_node_name = check_node.name
					if check_node_name == "nc_terrain:sand" or check_node_name == "nc_terrain:sand_loose" then
						set_node(pos, check_node)
						set_node(check_pos, node)
						return
					end
				end
			end
		})
-- ================================================================== --
