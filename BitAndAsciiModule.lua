local misc={}
function misc.getAlphabet(c,s,e)
	local str = "";
	for i = (c and"A"or"a"):byte(),(c and"Z"or"z"):byte() do
		str=str..str.char(i);
	end
	return str:sub(s or 1, e or#str)
end

function misc.invBitString(s)
	return (tonumber(_VERSION:match("5%.(%d+)"))>=3 and({(s:gsub(".",function(a)return(a+1)%2 end)):gsub("%..","")})[1] or ({s:gsub("1","2"):gsub("0","1"):gsub("2","0")})[1])
end

function misc.bitToDec(n)
	local bit,dec=tostring(n),0;
	for i=#bit,1,-1 do dec=dec+tonumber(bit:sub(i,i))* 2^(#bit-i)end
	--tonumber(n,2)) is also a palpable solution
	return dec;
end

function misc.decToBin(n)
local placeValues = select(2,math.frexp(n))
local str = "";
for bitPlace=placeValues,1,-1 do
     str=str..tostring(math.fmod(n,2)):match("^%d+")
     n=(n-math.fmod(n,2))/2
    end
    return str
end


return misc
