--[[
Iterates through a table making its content easily readable to a human.
This can easily be used with the __tostring metamethod to ensure that a call to 'tostring' on the table will lead to the same results.
]]--

function tableToString(t)
local function handleDataTypes(v)
 local datatype = type(v);
 if datatype=="table" then
  return "{" .. tableToString(v) .. "}"
 elseif datatype=="userdata" or datatype=="function" then
  return datatype;
 elseif datatype=="string" then
  return string.format("%q",v)
 else
  return tostring(v);
 end
end
local str = "{"
local sep = ", "
 for i, v in pairs(t) do 
  if not tonumber(i) then
   str = str .. sep .. tostring(i) .. " = " .. handleDataTypes(v);
  end
 end
 for i, v in ipairs(t) do 
  str = str .. sep .. handleDataTypes(v);
 end
 local final = "{"..str:sub(#sep + 2) .. "}";
 if getmetatable(t) ~= nil then
	final = final .. " <- " .. tableToString(getmetatable(t))
end
return final
end
