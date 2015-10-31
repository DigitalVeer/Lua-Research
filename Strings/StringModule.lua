local string = {}

function string.removeRepeats(a)
l={}return a:gsub("%S+",function(b)if l[b]then return""else l[b]=true end end)
end

return string;

