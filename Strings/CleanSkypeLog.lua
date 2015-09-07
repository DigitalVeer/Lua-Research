--[[
Takes a skype chatlog and makes it look "cleaner!"
]]

local dates = [[.%d+:%d+:%d+ PM. ]]
local nameCap = "(.+):"
local msgCap = [[:(.*)]]
local lineFeed = string.char(10)
local singleLineComplement = "[^"..lineFeed.."]+"

function readLineAndFormat(txt)
local str = txt
local subbedMessage = txt:gsub(dates,"")
local finalStr = "";
for line in subbedMessage:gmatch(singleLine) do
	local name = line:match(nameCap)
	local message = line:match(msgCap)
	finalStr = finalStr .. (name~=nil and name .. " | " or "") ..  (message~=nil and tostring(message) .. string.char(10) or "") 
end
return finalStr;
end
