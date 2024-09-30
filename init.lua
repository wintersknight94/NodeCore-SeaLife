-- LUALOCALS < ---------------------------------------------------------
local include, nodecore
    = include, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()

--<>--

include("oceanfix")

--<>--

include("corals")

include("anemones")

include("mollusks")

include("urchins")

--include("seastars")

include("seajellies")

--include("bobbits")

--<>--

include("kelp")

--<>--

include("cultivate_coral")

--<>--

if minetest.settings:get_bool(modname .. ".foodweb", true) then
	include("predation")
end

--<>--

if minetest.get_modpath("ncshark") then
	include("sharks")
end

--<>--

include("bubbly")