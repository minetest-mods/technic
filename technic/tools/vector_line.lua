local twolines = {}
function vector.twoline(x, y)
	local pstr = x.." "..y
	local line = twolines[pstr]
	if line then
		return line
	end
	line = {}
	local n = 1
	local dirx = 1
	if x < 0 then
		dirx = -dirx
	end
	local ymin, ymax = 0, y
	if y < 0 then
		ymin, ymax = ymax, ymin
	end
	local m = y/x --y/0 works too
	local dir = 1
	if m < 0 then
		dir = -dir
	end
	for i = 0,x,dirx do
		local p1 = math.max(math.min(math.floor((i-0.5)*m+0.5), ymax), ymin)
		local p2 = math.max(math.min(math.floor((i+0.5)*m+0.5), ymax), ymin)
		for j = p1,p2,dir do
			line[n] = {i, j}
			n = n+1
		end
	end
	twolines[pstr] = line
	return line
end

local threelines = {}
function vector.threeline(x, y, z)
	local pstr = x.." "..y.." "..z
	local line = threelines[pstr]
	if line then
		return line
	end
	if x ~= math.floor(x) then
		print("[technic] INFO: The position used for vector.threeline isn't round.")
	end
	local two_line = vector.twoline(x, y)
	line = {}
	local n = 1
	local zmin, zmax = 0, z
	if z < 0 then
		zmin, zmax = zmax, zmin
	end
	local m = z/math.hypot(x, y)
	local dir = 1
	if m < 0 then
		dir = -dir
	end
	for _,i in ipairs(two_line) do
		local px, py = unpack(i)
		local ph = math.hypot(px, py)
		local z1 = math.max(math.min(math.floor((ph-0.5)*m+0.5), zmax), zmin)
		local z2 = math.max(math.min(math.floor((ph+0.5)*m+0.5), zmax), zmin)
		for pz = z1,z2,dir do
			line[n] = {px, py, pz}
			n = n+1
		end
	end
	threelines[pstr] = line
	return line
end

function vector.line(pos, dir, range)
	if range then --dir = pos2
		dir = vector.round(vector.multiply(dir, range))
	else
		dir = vector.subtract(dir, pos)
	end
	local line,n = {},1
	for _,i in ipairs(vector.threeline(dir.x, dir.y, dir.z)) do
		line[n] = {x=pos.x+i[1], y=pos.y+i[2], z=pos.z+i[3]}
		n = n+1
	end
	return line
end
