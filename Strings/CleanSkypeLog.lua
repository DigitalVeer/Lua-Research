local dates = [[.%d+:%d+:%d+ PM. ]]
local nameCap = "(.+):"
local msgCap = [[:(.*)]]
local lineFeed = string.char(10)
local singleLineComplement = "[^"..lineFeed.."]+"

function getString(txt)
local str = txt
local steve = txt:gsub(dates,"")
local finalStr = "";
for line in steve:gmatch(singleLineComplement) do
 local name = line:match(nameCap)
 local message = line:match(msgCap)
 finalStr = finalStr .. name ..  " | ".. tostring(message) .. string.char(10)
end
return finalStr;
end
