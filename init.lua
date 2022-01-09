-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local pumbob = {name = modname .. ":carved"}
local tarbob = {name = modname .. ":sealed"}

minetest.register_node(modname .. ":carved", {
		description = "Carved Pumice Bobber",
		tiles = {"nc_igneous_pumice.png^(nc_concrete_pattern_iceboxy.png^[opacity:48)^(nc_concrete_pattern_bindy.png^[opacity:100)"},
		silktouch = true,
		groups = {floaty = 1, cracky = 2},
		crush_damage = 1,
		sounds = nodecore.sounds("nc_terrain_stony")
	})

minetest.register_node(modname .. ":sealed", {
		description = "Sealed Pumice Bobber",
		tiles = {"nc_igneous_pumice.png^(nc_concrete_pattern_iceboxy.png^[opacity:48)^(nc_concrete_pattern_bindy.png^[opacity:100)"},
		color = "gray",
		silktouch = true,
		groups = {floaty = 1, cracky = 2},
		crush_damage = 1,
		sounds = nodecore.sounds("nc_terrain_stony")
	})
	
nodecore.register_craft({
		label = "chisel pumbob",
		action = "pummel",
		toolgroups = {thumpy = 3},
		normal = {y = 1},
		indexkeys = {"group:chisel"},
		nodes = {
			{
				match = {
					lode_temper_cool = true,
					groups = {chisel = true}
				},
				dig = true
			},
			{
				y = -1,
				match = "nc_igneous:pumice",
				replace = modname .. ":carved"
			}
		}
	})

nodecore.register_limited_abm({
		label = "seal pumbob",
		interval = 1,
		chance = 2,
		limited_max = 100,
		nodenames = {modname .. ":carved"},
		neighbors = {"nc_concrete:coalaggregate_wet_source"},
		action = function(pos, node)
			nodecore.set_loud(pos, {name = modname .. ":sealed"})
		end
	})
	
nodecore.register_abm({
     label = "pumbob floating",
     nodenames = {modname .. ":carved"},
     interval = 3,
     chance = 3,
     action = function(pos, node)
          local next_pos = {x=pos.x, y=pos.y+1, z=pos.z}
		local next_node = minetest.get_node(next_pos)
			if next_node.name == "nc_terrain:water_source" then
				minetest.swap_node(next_pos, pumbob)
				minetest.swap_node(pos, next_node)
			else return
          end
     end,
})

nodecore.register_abm({
     label = "tarbob floating",
     nodenames = {modname .. ":sealed"},
     interval = 2,
     chance = 2,
     action = function(pos, node)
          local next_pos = {x=pos.x, y=pos.y+1, z=pos.z}
		local next_node = minetest.get_node(next_pos)
			if next_node.name == "nc_terrain:water_source" then
				minetest.swap_node(next_pos, tarbob)
				minetest.swap_node(pos, next_node)
			else return
          end
     end,
})
