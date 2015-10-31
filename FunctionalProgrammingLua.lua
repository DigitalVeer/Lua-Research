local Signal = {
meta = {}		
}

insert = table.insert
local SignalLibrary = {
	
Event = function (name)
	return function(callPerWait)
		local Bool = Instance.new("BoolValue");	Bool.Value = false;
		return { ["connect"] = function() Bool.Value = true end,
		 ["Wait"] = coroutine.wrap(function()
			local orig = Bool.Value;
			while not rawequal(not orig,Bool.Value) and wait() do
				callPerWait()
			end
		return true;
		end)(), ["disconnect"] = function() Bool.Value = false end, ["EventType"] = name}
	end
end,
	
}

function SignalLibrary:get(func,...)
	--return function(...)
		if func == nil then
			local kys,vls = {},{}
			for i,v in pairs(self) do
				insert(kys,i)
				insert(vls,v)
			end
			return self,kys,vls;
		else 
			func(self)
		end
	--end
end

function Signal.new(dataType)
	return function(vals)
		return function(passIn)
		local kvAr = {}
		assert(#dataType==#vals,"Error: Need Key per Value")
		for ind,val in pairs(dataType) do
			kvAr[dataType[ind]] = vals[ind]
		end		
		return setmetatable(kvAr, {
			__index = function(s,k)
				if k=="get" then
					return passIn.get or SignalLibrary.get
				elseif k=="connect" then
					return SignalLibrary["Event"]
				elseif k == "set" then

					end
			end,
			__newindex = function() return "nop" end,
		})
		end	
	end
end


return Signal
