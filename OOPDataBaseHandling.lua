local insert
do
  local tableObj = table
  insert = tableObj.insert
end

--Required Inputs: Name, Id
--This is a generic player | data should be used for main necessities and field should be used for loose items

--[[
	
Methods:

add_field_item (name)
edit_field_item (field,itemName,value) -> VOID;
remove_field_item (field,itemName,value) -> VOID;
add_data_field (key,value) -> VOID;
get_data_summary -> VOID;
get_data_field -> DataType/Generic;
get_data -> Array;
get_gender [Incase 'Gender' is put as a valid field] -> String;
get_id -> Int;
get_name -> String;
get_timezone [Incase 'Timezone' is put as a valid field] -> String;
get_skype [Incase 'Skype' is put as a valid field] -> String;
get_registration -> Timestamp [Int]
add_data_item (dataName, value) -> VOID;
set_skype (skypeUser) -> String;
edit_data_field (key,value) -> value;
print_data_items -> VOID;
get_field_item (fieldName) -> (DataType/Generic)
get_field -> Array


--]]
local Player
do
  local baseObj = {
    fields = { },
    data = { },
    add_field_item = function(self, key, value )
      if self.fields[key] then
        return error("Exists")
      else
        self.fields[key] = value
        return self.fields[key]
      end
    end,
    edit_field_item = function(self, field, itemName, value)
      if self.fields[field] and self.fields[field][itemName] then
        self.fields[field][itemName] = value
        return self.fields[field][itemName]
      else
        return error("Something went wrong! Oops!")
      end
    end,
    remove_field_item = function(self, field, itemName, value)
      if self.fields[field] and self.fields[field][itemName] then
        self.fields[field][itemName] = nil
        return self.fields[field]
      else
        return error("Data field does not exist!")
      end
    end,
    add_data_field = function(self, key, value)
      if self.data[key] then
        return error("Data field already exists!")
      else
        self.data[key] = value
        return self.data[key]
      end
    end,
    get_data_summary = function(self)
      local dataStrings
      do
        local _tbl_0 = { }
        for k, v in pairs(self.data) do
          _tbl_0[tostring(k) .. " : " .. tostring(v)] = ""
        end
        dataStrings = _tbl_0
      end
      return dataStrings
    end,
    get_data_field = function(self, fieldName)
      return self.data[fieldName]
    end,
    get_data = function(self)
      return self.data
    end,
    get_gender = function(self)
      return self.data["Gender"]
    end,
    get_id = function(self)
      return self.data["Id"]
    end,
    get_name = function(self)
      return self.data["Name"]
    end,
    get_timezone = function(self)
      return self.data["Timezone"]
    end,
    get_skype = function(self)
      return self.data["Skype"]
    end,
    get_registration = function(self)
      return self.data["register_Date"]
    end,
    add_data_item = function(self, dataName, value)
      if self.data[dataName] then
        return error("Data field already exists!")
      else
        self.data[dataName] = value
      end
    end,
    set_skype = function(self, skypeUser)
      if self.data["Skype"] then
        local prior = self.data["Skype"]
        self.data["Skype"] = skypeUser
        return prior, self.data["Skype"]
      else
        self.data["Skype"] = skypeUser
        return self.data["Skype"]
      end
    end,
    edit_data_field = function(self, key, value)
      if self.data[key] then
        self.data[key] = value
        return self.data[key]
      else
        return error("Field does not exist!")
      end
    end,
    print_data_items = function(self)
      for str in pairs(self:get_data_summary()) do
        print(str)
      end
    end,
    get_class_name = function(self)
      return self.__class["__name"]
    end,
    get_field_item = function(self, fieldName)
      return self.fields[fieldName]
    end,
    get_field = function(self)
      return self.fields
    end,
	get_field_summary = function(self)
      local fieldStrings
      do
        local _tbl_0 = { }
        for k, v in pairs(self.fields) do
          _tbl_0[tostring(k) .. " : " .. tostring(v)] = ""
        end
        fieldStrings = _tbl_0
      end
      return fieldStrings
	    end,
	print_field_items = function(self)
      for str in pairs(self:get_field_summary()) do
        print(str)
      end
    end,
  }
  baseObj.__index = baseObj
  local bClass = setmetatable({
    __init = function(self, Name, Id)
      self.data = {
        Name = Name,
        Id = Id,
        register_Date = os.time()
      }
    end,
    __base = baseObj,
    __name = "Player"
  }, {
    __index = baseObj,
    __call = function(cls, ...)
      local selfClass = setmetatable({}, baseObj)
      cls.__init(selfClass, ...)
      return selfClass
    end
  })
  baseObj.__class = bClass
  Player = bClass
end
return Player
