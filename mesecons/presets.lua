mesecon.rules = {}
mesecon.state = {}

-- These rules are used for standard wire
mesecon.rules.default = {
	{x =  0, y =  0, z = -1},
	{x =  1, y =  0, z =  0},
	{x = -1, y =  0, z =  0},
	{x =  0, y =  0, z =  1},
	{x =  1, y =  1, z =  0},
	{x =  1, y = -1, z =  0},
	{x = -1, y =  1, z =  0},
	{x = -1, y = -1, z =  0},
	{x =  0, y =  1, z =  1},
	{x =  0, y = -1, z =  1},
	{x =  0, y =  1, z = -1},
	{x =  0, y = -1, z = -1},
}

mesecon.rules.floor = mesecon.merge_rule_sets(mesecon.rules.default, {{x = 0, y = -1, z = 0}})

-- Pressure plates conduct to the node two below them
mesecon.rules.pplate = mesecon.merge_rule_sets(mesecon.rules.floor, {{x = 0, y = -2, z = 0}})

-- Buttons conduct like below:
--[[
Layers:

000 y1
0X0 y0
000 y-1

0X0 y1
0X0 y0
XXX y-1

000 y1
0B0 y0
000 y-1

]]
mesecon.rules.buttonlike = {
	{x = 1,  y =  0, z =  0},
	{x = 1,  y =  1, z =  0},
	{x = 1,  y = -1, z =  0},
	{x = 1,  y = -1, z =  1},
	{x = 1,  y = -1, z = -1},
	{x = 2,  y =  0, z =  0},
}

mesecon.rules.flat = {
	{x =  1, y = 0, z =  0},
	{x = -1, y = 0, z =  0},
	{x =  0, y = 0, z =  1},
	{x =  0, y = 0, z = -1},
}

mesecon.rules.alldirs = {
	{x =  1, y =  0,  z =  0},
	{x = -1, y =  0,  z =  0},
	{x =  0, y =  1,  z =  0},
	{x =  0, y = -1,  z =  0},
	{x =  0, y =  0,  z =  1},
	{x =  0, y =  0,  z = -1},
}

local rules_wallmounted = {
	xp = mesecon.rotate_rules_down(mesecon.rules.floor),
	xn = mesecon.rotate_rules_up(mesecon.rules.floor),
	yp = mesecon.rotate_rules_up(mesecon.rotate_rules_up(mesecon.rules.floor)),
	yn = mesecon.rules.floor,
	zp = mesecon.rotate_rules_left(mesecon.rotate_rules_up(mesecon.rules.floor)),
	zn = mesecon.rotate_rules_right(mesecon.rotate_rules_up(mesecon.rules.floor)),
}

local rules_buttonlike = {
	xp = mesecon.rules.buttonlike,
	xn = mesecon.rotate_rules_right(mesecon.rotate_rules_right(mesecon.rules.buttonlike)),
	yp = mesecon.rotate_rules_down(mesecon.rules.buttonlike),
	yn = mesecon.rotate_rules_up(mesecon.rules.buttonlike),
	zp = mesecon.rotate_rules_right(mesecon.rules.buttonlike),
	zn = mesecon.rotate_rules_left(mesecon.rules.buttonlike),
}

local function rules_from_dir(ruleset, dir)
	if not dir then return {} end

	if dir.x ==  1 then return ruleset.xp end
	if dir.y ==  1 then return ruleset.yp end
	if dir.z ==  1 then return ruleset.zp end
	if dir.x == -1 then return ruleset.xn end
	if dir.y == -1 then return ruleset.yn end
	if dir.z == -1 then return ruleset.zn end
end

mesecon.rules.wallmounted_get = function(node)
	local dir = minetest.wallmounted_to_dir(node.param2)
	return rules_from_dir(rules_wallmounted, dir)
end

mesecon.rules.buttonlike_get = function(node)
	local dir = minetest.facedir_to_dir(node.param2)
	return rules_from_dir(rules_buttonlike, dir)
end

mesecon.state.on = "on"
mesecon.state.off = "off"
