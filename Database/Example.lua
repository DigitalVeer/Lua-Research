--Examples

local modules = script.Parent.Modules
local Player = require(modules.Player)
local Developer = require(modules.Developer)
local HighRank = require(modules.HighRank)

local lF =  "\n"..string.rep("~",20)

local person = Player("YShaarj", 554415)
person:print_data_items()
print(type(person:get_data_summary()),lF)
person:add_data_field("Gender", "Male")
print(person:print_data_items(),lF)
person:add_field_item("Felonies", {"Accepted Bribe", "Admin Abuse"})
person:print_field_items()
print("Gender" , person:get_gender(),lF)

local dev = Developer("DigitalVeer", 3453521)
dev:print_data_items()
dev:add_data_field("Gender", "Male")
print("Gender" , dev:get_gender(),lF)


