--[[
Gives a way for transposing a matrix and printing it to a readable form for humans
]]--

local Matrix = { }

function Matrix.new(m, n, contents)
	assert(m*n == #contents)
	local ourMatrix = { }
	function ourMatrix:transpose()
		local twoDTransform = {}
		for row = 1,m do
			local temp = {}
			for col = 1,n do
				local currentIndex = n*(row-1) + col;
				table.insert(temp,contents[currentIndex])
			end
			table.insert(twoDTransform,temp)
			temp = {}
		end
			local function transpose(inputMatrix)
			    local newMatrix = {}			 
			    for i = 1, #inputMatrix[1] do
			        newMatrix[i] = {}
			        for v = 1, #inputMatrix do
			            newMatrix[i][v] = inputMatrix[v][i]
			        end
			    end			 
			    return newMatrix
			end
		local transposed = transpose(twoDTransform)
		local final = {}
		for _,v in pairs(transposed) do
			for i,k in pairs(v) do
				table.insert(final,k)
			end
		end
		contents = final;
		local temp = m;
		m = n;
		n = temp;
	end

	function ourMatrix:print()
		local str = "";
		for row = 1,m do
			str = str.."["
			for col = 1, n do
				local currentIndex = n*(row-1) + col
				str = str .. (col ~= n and contents[currentIndex] .. " " or contents[currentIndex].."")
			end
			str = str.."]"
			str=str.."\n"
		end
		print(str)
	end
	return ourMatrix
end
