local HighRank
local Player = require(script.Parent.Player)

--Required Inputs: Name, Id[int], canPromoteDemoteFromDatabase [bool]
--This is a generic HighRank which inherits from Player | data should be used for main necessities and field should be used for loose items

--[[
	
Methods:

print_player_changes -> VOID
get_rank_bool -> boolean
set_Rank (groupiD) -> VOID


--]]

do
local canRankFromDB;
  local parentClass = Player
  local baseClass = {
    set_Rank = function(self, iD)
      self.data["currentRank"] = game.Players:GetPlayerRankInGroup(iD)
    end,
    get_rank_bool = function(self)
      return self.data[canRankFromDB]
    end,
    print_player_changes = function(self)
      for plr, change in pairs(self.data) do
        print(plr .. " was " .. change[1] .. "d to " .. change[2])
      end
	--change table should look like: {"Promote" or "Demote", "rankName"}
    end
  }
  baseClass.__index = baseClass
  setmetatable(baseClass, parentClass.__base)
  local bClassObj = setmetatable({
    __init = function(self, Name, Id, canRankFromDB)
      self.data = {
        Name = Name,
        Id = Id,
        register_Date = os.time(),
        canRankFromDB = canRankFromDB
      }
      self.data["changes"] = { }
    end,
    __base = baseClass,
    __name = "HighRank",
    __parent = parentClass
  }, {
    __index = function(cls, name)
      local val = rawget(baseClass, name)
      if val == nil then
        return parentClass[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local sClassObj = setmetatable({}, baseClass)
      cls.__init(sClassObj, ...)
      return sClassObj
    end
  })
  baseClass.__class = bClassObj
  if parentClass.__inherited then
    parentClass.__inherited(parentClass, bClassObj)
  end
  HighRank = bClassObj
  return bClassObj
end
return HighRank;
