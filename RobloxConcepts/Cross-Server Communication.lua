local DataStore = game:GetService("DataStoreService")
local DataStore_codes = DataStore:GetDataStore("codes") 
local codes = DataStore_codes:GetAsync("_index") or {}
local msgKey = "xlASdkslVMESSAGE";
local waitTime = 5

local takers = {}
local delays = {}
local debounces = {}

local gui = script.msgGui
local msg = gui.Frame:WaitForChild("msg")

function waitFor()
	local Bool = Instance.new("BoolValue")
	Bool.Value = false
	return { ["Set"] = function() Bool.Value = true end, ["Wait"] = function() if Bool.Value then return end Bool.Changed:wait() end}
end

function cloneToAllPlayers(str)
	msg.Text = str;
	for i,plr in pairs(game.Players:GetPlayers()) do
		if plr.PlayerGui:FindFirstChild("msgGui") then
			plr.PlayerGui:FindFirstChild("msgGui").Frame["msg"].Text = str
		else
			local steve = gui:Clone()
			steve.Parent = plr.PlayerGui
			steve.Frame["msg"].Text = str --2nd time to be sure
			steve.Frame["LocalScript"].Disabled = false
		end
	end
end


local connection = DataStore_codes:OnUpdate("xlASdkslVMESSAGE", function(value)
	cloneToAllPlayers(value)
end)


function CodesUpdated(old,new)
	local NewCodes = {}
	for k,v in pairs(new) do
		if not old[k] then
			table.insert(NewCodes,k)
		end
	end
	if #NewCodes > 0 then
		-- Send message to players?
		-- (also send message to new players that are joining the game)
	end
end

local connection = DataStore_codes:OnUpdate("_index", function(value)
	local old = codes
	codes = value
	CodesUpdated(old,value)
end)

CodesUpdated({},codes)

function reasonableTime(seconds)
	local diff = os.difftime(seconds,os.time())
	if (diff <= 60) then
		return diff .. " seconds"
	elseif (diff/60) <= 60 then
		return math.floor(diff/60) .. " minutes";
	elseif (diff/3600) <= 24 then
		return math.floor(diff/3600) .. " hours";
	else
		return math.floor(diff/3600/24) .. " days";
	end
end

function postCode(msg,code,num,timeExpiration,gearName) -- Take
	DataStore_codes:SetAsync("xlASdkslVMESSAGE",msg)
	DataStore_codes:UpdateAsync(code, function(old)
		old = old or {}
		old["message"] = msg
		old["numAllowed"] = num
		old["timeExpires"] = timeExpiration
		old["gearName"] = gearName
		return old
	end)
	DataStore_codes:UpdateAsync("_index", function(old)
		old = old or {}
		old[code] = true
		return old
	end)
end

--postCode("Hey!","notsure2",3,os.time() + 30,"ToolBob")

function checkTypes(msg,code,num,timeexpire,gear)
	return type(msg) == "string" and type(code) == "string" and type(num) == "number" and type(timeexpire) == "number" and type(gear) == "string"
end

function game.ReplicatedStorage.MakeCode.OnServerInvoke(player,msg,code,num,timeExpiration,gearName)
if checkTypes(msg,code,num,timeExpiration,gearName) then
	postCode(msg,code,num,timeExpiration,gearName)
	cloneToAllPlayers(msg)
	return "Gift registered!"
	end
end




function CodeRejected(player,why)
	debounces[player] = false
	return why
end

function CodeAccepted(player,gift_name)
	delays[player] = nil	
	
	-- Add gear	
	-- GiveGear(player,gift_name)
	game.ReplicatedStorage.Item_Library[gift_name]:Clone().Parent = player.Backpack
	--AddGear:FireClient(player,game.ReplicatedStorage.Item_Library[gift_name])
	
	debounces[player] = false
	return "Congratulations! You've got a " .. gift_name,true
end

function game.ReplicatedStorage.SendCode.OnServerInvoke(player,code)
	if debounces[player] then return end
	debounces[player] = true
	
	if takers[code] and takers[code][player] then
		return CodeRejected(player,"You already got this gift!")
	end	
	
	if delays[player] and delays[player] > os.time() then
		return CodeRejected(player,"Wait " .. (delays[player] - os.time()) .. " seconds to try again")
	end	
	
	delays[player] = os.time() + 5
	
	if not codes[code] then
		return CodeRejected(player,"This code does not exist!")
	end	
	
	local code_test = DataStore_codes:GetAsync(code)	
	
	if code_test == nil then
		return CodeRejected(player,"This code does not exsist!")
	elseif code_test["timeExpires"] < os.time() then
		return CodeRejected(player,"This code expired " .. reasonableTime(os.difftime(os.time(),code_test["timeExpires"]) .. " ago!"))
	elseif code_test["numAllowed"] <= 0 then
		return CodeRejected(player,"All gifts from this code is taken")
	else
		local Event = waitFor()
		local ok = false
		
		DataStore_codes:UpdateAsync(code, function(old)
			if old["numAllowed"] <= 0 then
				Event:Set()
				return nil
			else
				old["numAllowed"] = old["numAllowed"] - 1
				ok = true
				Event:Set()
				return old
			end
		end)
		
		Event:Wait()
		
		if ok then
			takers[code] = takers[code] or {}
			takers[code][player] = true
			return CodeAccepted(player,code_test["gearName"])
		else
			return CodeRejected(player,"All gifts from this code is taken")
		end
	end
end
