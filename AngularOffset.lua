--[[
Determines if rotating clockwise has a smaller degree of chance than rotating counter-clockwise.
-1 is returned if clockwise path is shorter, else 1 is returned if counter-clockwise is shorter.
0 is returned if distancce to both is equal.
Input can be lower than 0 and higher than 2(pi)
]]--


function angularOffsetSign(startAngle, goalAngle)
local rot1 = math.abs((math.floor(math.deg(startAngle)) - (math.floor(math.floor(math.deg(startAngle))/360) * 360)) - (math.floor(math.deg(goalAngle)) - (math.floor(math.floor(math.deg(goalAngle))/360) * 360)))
local rot2 = 360 - rot1
return ((rot1 < rot2 and 1) or (rot2 < rot1 and -1) or (rot2==rot1 and 0))
end
