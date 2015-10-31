Player = require(script.Parent.Player)


local Developer
do
  local _parent_0 = Player
  local _base_0 = {
    fields = { },
    data = { },
    get_dev_type = function(self)
      return self.data["DevType"]
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, Name, Id, DevType)
      self.data = {
        Name = Name,
        Id = Id,
        DevType = DevType,
        register_Date = os.time()
      }
    end,
    __base = _base_0,
    __name = "Developer",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Developer = _class_0
  return _class_0
end
