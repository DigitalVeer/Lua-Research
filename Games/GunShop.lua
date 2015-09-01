-- Black = Primary
-- White = Secondary


repeat wait() until _G.TweenObject
local SelectedParts = { }
local TableOfGunParts = game.ReplicatedStorage.GunShop.GunParts:GetChildren()
local GunShop_Model = game.ReplicatedStorage.GunShop.GunShop:Clone()
GunShop_Model.Parent = workspace.CurrentCamera


local Color_Codes = {BrickColor.new("Really black"), BrickColor.new("Institutional white")}
local Color_Defaults = {BrickColor.new("Really black"), BrickColor.new("Institutional white")}
local function ModelPoints(objects, center, new, recurse, New_CFrames)
	local New_CFrames = New_CFrames or { }
	for _,object in pairs(objects) do
		if object:IsA("BasePart") then
			New_CFrames[object] = {object.CFrame, new:toWorldSpace(center:toObjectSpace(object.CFrame))}
		end
		if recurse then
			ModelPoints(object:GetChildren(), center, new, recurse, New_CFrames)
		end
	end
	return New_CFrames
end

local function TransformModel(objects, center, new, recurse)
	for _,object in pairs(objects) do
		if object:IsA("BasePart") then
			object.CFrame = new:toWorldSpace(center:toObjectSpace(object.CFrame))
		end
		if recurse then
			TransformModel(object:GetChildren(), center, new, true)
		end
	end
end

local function TweenModel(model, center, a, b, length)
	local frames = ModelPoints(model:GetChildren(), a, b, true)
	for _, v in pairs(frames) do
		_G.TweenObject(_, v[1], v[2], length, "CFrame", true)
	end
	wait(length)
	TransformModel(model:GetChildren(), center.CFrame, b, true)
end

local function Camera_Handler()
	local Handler = { }
	local Camera = workspace.CurrentCamera
	local Stored_CameraType = Camera.CameraType
	local Stored_CamCoords = Camera.CoordinateFrame
	local Stored_CamFocus = Camera.Focus
	local Stored_CamSubject = Camera.CameraSubject
	local center_part = GunShop_Model.Mid_Part
	local cam_part = GunShop_Model.Camera_Part
	local distance = center_part.CFrame:toObjectSpace(cam_part.CFrame).p
	local center = center_part.CFrame
	local Rotate = nil
	Camera.CameraType = "Scriptable"
	Camera.CameraSubject = nil
	function Handler.StartCamera(this)
		Camera.CoordinateFrame = CFrame.new(GunShop_Model.Camera_Part.Position, (GunShop_Model.Camera_Part.CFrame * CFrame.new(0, 0, -5)).p)
		Camera.Focus = CFrame.new((GunShop_Model.Camera_Part.CFrame * CFrame.new(0, 0, -5)).p)
		_G.TweenObject(Camera, Camera.CoordinateFrame, CFrame.new(GunShop_Model.Camera_Part.Position, GunShop_Model.Mid_Part.Position), 2, "CoordinateFrame", true)
		_G.TweenObject(Camera, Camera.Focus, CFrame.new(GunShop_Model.Mid_Part.Position), 2, "Focus", true)
		wait(2)
	end
	
	function Handler.EndCamera(this)
		_G.TweenObject(Camera, Camera.CoordinateFrame, Stored_CamCoords, 2, "CoordinateFrame", true)
		_G.TweenObject(Camera, Camera.Focus, Stored_CamFocus, 2, "Focus", true)
		Camera.CameraSubject = Stored_CamSubject
		Camera.CameraType = Stored_CameraType
	end
	
	
	function Handler.RotateCamera(this, bool)
		--print("Rotate called",bool)
		if bool and not Rotate then
			Rotate = coroutine.wrap(function()
				--print("Moving camera")
				while Rotate and wait() do
					center = center * CFrame.Angles(0, math.rad(.8), 0)
					Camera.CoordinateFrame = CFrame.new((center * CFrame.new(distance)).p, center_part.Position)
					Camera.Focus = CFrame.new(center_part.Position)
				end

			end)
			Rotate()
		elseif not bool then
	--		print("Camera halted")
			Rotate = nil
		end
	end
	
	return Handler
end


local function Model_Viewer(Camera_Object)
	local Gun_Model = Instance.new("Model", Workspace.CurrentCamera)
	local center = GunShop_Model.Mid_Part.CFrame
	local center_Part = GunShop_Model.Mid_Part
	center_Part.Parent = Gun_Model
	local Handler = { }
	local Colors = { }
	local Updater_Nodes = { }
	--local Rotate = true
	
	function Handler.RemovePart(this, Type)
		if type(SelectedParts[Type])=="userdata" then
			Rotate = false
			wait()
			TweenModel(SelectedParts[Type], center_Part, center, center * CFrame.new(0, 0, 11), .5)
			wait(.5)
			SelectedParts[Type]:Destroy()
			SelectedParts[Type] = nil
		end
	end
	
	function Handler.CreateUpdaterNode(this, func)
		Updater_Nodes[#Updater_Nodes + 1] = func
	end
	
	function Handler.UpdateColor(this)
		
		for i, v in pairs(Colors) do -- Clearing
			if i.Parent==nil then
				Colors[i] = nil
			end
		end
		
		for i, v in pairs(Gun_Model:GetChildren()) do -- Adding
			if v:IsA("Model") and Colors[v]==nil then
				Colors[v] = { }
				for __, vv in pairs(v:GetChildren()) do
					if vv:IsA("BasePart") then
						for index, col in pairs(Color_Defaults) do
							if vv.BrickColor==col then
								Colors[v][vv] = index
							end
						end
					end
				end
			end
		end
		
		for i, v in pairs(Colors) do -- Updating
			for _, vv in pairs(v) do
				_.BrickColor = Color_Codes[vv]
			end
		end
		
	end

	function Handler.Update(this)
		for _, v in pairs(Updater_Nodes) do
			v(SelectedParts)
		end
	end
		
	function Handler.LoadPart(this, Type, Model)
		if SelectedParts[Type]~=nil then
			this:RemovePart(Type)
		end
		local model = Model:Clone()
		model.Parent = Gun_Model
		local Namer = Instance.new("StringValue", model)
		Namer.Name = "PartName"
		Namer.Value = model.Name
		model.Name = Type
		SelectedParts[Type] = model
		TransformModel(model:GetChildren(), CFrame.new(model:GetModelCFrame().p), center * CFrame.new(0, 0, -11))
	--	Rotate = false
		this:UpdateColor()
	--	this:ModelRotate(false)
	--	Camera_Object:RotateCamera(false)
		wait()
		if Type=="Handles" then
			TweenModel(model, model.Handle, model.Handle.CFrame, center_Part.CFrame, .5)
			for _, v in pairs(SelectedParts) do
				if _~="Handles" then
					TransformModel(v:GetChildren(), v[_:sub(1, #_ - 1)..":Handle"].CFrame, SelectedParts["Handles"]["Handle:".._:sub(1, #_ - 1)].CFrame, true)
				end
			end
		else			
			TweenModel(model, model[Type:sub(1, #Type - 1)..":Handle"],  model[Type:sub(1, #Type - 1)..":Handle"].CFrame, SelectedParts["Handles"]["Handle:"..Type:sub(1, #Type - 1)].CFrame, .5)
		end
	--	this:ModelRotate(true)
	--	Camera_Object:RotateCamera(true)
		this:Update()
	end
	
	
	function Handler.Destroy(this) -- Doomsday function
		Rotate = nil
		Updater_Nodes = nil
		Colors = nil
		Gun_Model:Destroy()
		GunShop_Model:Destroy()
		Handler = nil
	end
	--[[
	function Handler.ModelRotate(this, bool)
		if bool and Rotate==nil then
			Rotate = coroutine.wrap(function()
				while Rotate and wait() do
					local c2 = center
					TransformModel(Gun_Model:GetChildren(), c2, c2 * CFrame.Angles(0, math.rad(2), 0), true)
					c2 = c2 * CFrame.Angles(0, math.rad(2), 0)
				end
			end)
			Rotate()
		elseif not bool then
			Rotate = nil
		end
	end
	]]--
	
	return Handler
end

local Camera = Camera_Handler()
Camera:StartCamera()
local Viewer = Model_Viewer(Camera)
Viewer:LoadPart("Handles", game.ReplicatedStorage.GunShop.GunParts.Handles["PV1"])
for _, v in pairs(TableOfGunParts) do
	if v.Name~="Handles" then
		Viewer:LoadPart(v.Name, v:GetChildren()[1])
	end
end
Camera:RotateCamera(true)


	
	
local function Shop_Gui(Viewer)
	local Gui_Handler = { }
	local Gui = game.ReplicatedStorage.GunShop.GunShopGui:Clone()
	Gui.Parent = game.Players.LocalPlayer.PlayerGui
	local GunFrame = Gui.Frame.GunFrame
	local SettingsFrame = Gui.Frame.SettingsFrame
	
	-- Create tabs
	
	-- method SetPageLoaderFunction (table page_object)  (needs LoadPage method in object)
	-- method SelectTab (string TabName) -- needs to be in the Gun_Tabs table
	local function CreateTabs()
		local Gun_Tabs = { }
		local function PageLoadFunc(Name) print'empty' end
		local Tab_Handler = { }
		function Tab_Handler.SelectTab(this, Name)
			for _, v in pairs(Gun_Tabs) do
				if _~=Name then
					v.BackgroundColor3 = Color3.new(163/255, 162/255, 165/255)
				else
					v.BackgroundColor3 = Color3.new(1, 1, 1)
				end
			end
			PageLoadFunc(Name)
		end
		
		for i, v in pairs(TableOfGunParts) do
			local gui = GunFrame.TabFrame.TabTemplate:Clone()
			gui.Parent = GunFrame.TabFrame
			gui.Size = UDim2.new((1/#TableOfGunParts), 0, 1, 0)
			gui.Position = UDim2.new((i - 1) * (1 / #TableOfGunParts), 0, 0, 0)
			gui.Text = v.Name
			Gun_Tabs[v.Name] = gui
			gui.Visible = true
			gui.MouseButton1Down:connect(function() Tab_Handler.SelectTab(Tab_Handler, v.Name) end)
		end
		GunFrame.TabFrame.TabTemplate:Destroy()
		
				
		function Tab_Handler.SetPageLoaderFunc(this, page_object)
			PageLoadFunc = (function(Type) page_object:LoadPage(Type) end)
		end
		
		
		return Tab_Handler
	end
	
	local function ColorHandler()
		local color_handler = { }
		local color_gui_table = { }
		local color_gui = SettingsFrame.ContentFrame.ColorPickerFrame
		local template = color_gui.Template
		local current_color_selection = nil
		local Selecting = false
		template.Parent = nil
		
		local function ColorPicked(Color, base_name)
			if Color and current_color_selection then
				Color_Codes[current_color_selection[1]] = Color[1]
				SettingsFrame.ContentFrame[current_color_selection[1] .. "Label"].Text = current_color_selection[2] .. tostring(Color[1])
			end
			
			Selecting = false
			current_color_selection = nil
			color_gui.Visible = false
			Viewer:UpdateColor()
		end
	
		local xc = 0
		local yc = 0
		local xinc = 1/10
		local yinc = 1/12
		
		for i=1, 50 do
			if BrickColor.new(i)==BrickColor.new("Medium stone grey") then
				
			else
				local g2 = template:Clone()
				local COL = BrickColor.new(i)
				g2.Name = tostring(COL)
				g2.BackgroundColor3 = Color3.new(COL.r, COL.g, COL.b)
				g2.Size = UDim2.new(xinc, 0, yinc, 0)
				g2.Position = UDim2.new(xc, 0, yc, 0)
				g2.Parent = color_gui
				g2.Visible = true
				color_gui_table[g2] = {COL, i}
				g2.MouseButton1Down:connect(function() ColorPicked(color_gui_table[g2]) end)
				xc = xc + xinc
				if xc>=1 - xinc then
					xc = 0
					yc = yc + yinc
				end
			end
		end
		
		for i=100, 226 do
			if BrickColor.new(i)==BrickColor.new("Medium stone grey") then
				
			else
				local g2 = template:Clone()
				local COL = BrickColor.new(i)
				g2.Name = tostring(COL)
				g2.BackgroundColor3 = Color3.new(COL.r, COL.g, COL.b)
				g2.Size = UDim2.new(xinc, 0, yinc, 0)
				g2.Position = UDim2.new(xc, 0, yc, 0)
				g2.Parent = color_gui
				g2.Visible = true
				color_gui_table[g2] = {COL, i}
				g2.MouseButton1Down:connect(function() ColorPicked(color_gui_table[g2]) end)
				xc = xc + xinc
				if xc>=1 - xinc then
					xc = 0
					yc = yc + yinc
				end
			end
		end
		
		
		function color_handler.SelectAColor(this, Color_Code_Indexer, base_name)
			if not Selecting then
				current_color_selection = {Color_Code_Indexer, base_name}
				Selecting = true
				color_gui.Visible = true
			else
				ColorPicked()
			end
		end
		
		for _, v in pairs(Color_Codes) do
			local base_name = SettingsFrame.ContentFrame[_.."Label"].Text
				
			SettingsFrame.ContentFrame[_.."Button"].MouseButton1Down:connect(function()
				color_handler:SelectAColor(_, base_name)
			end)
		end
		
			
		--[[
		for _, v in pairs(Color_Codes) do
			local base_name = SettingsFrame.ContentFrame[_ .. "Label"].Text
			SettingsFrame.ContentFrame[_ .. "Button"].MouseButton1Down:connect(function()
				if BrickColor.new(SettingsFrame.ContentFrame[_ .. "Box"].Text)==BrickColor.new("Medium stone grey") and SettingsFrame.ContentFrame[_ .. "Box"].Text~="Medium stone grey" then
					SettingsFrame.ContentFrame[_ .. "Label"].Text = base_name .. "Invalid color"
				else
					SettingsFrame.ContentFrame[_ .. "Label"].Text = base_name .. tostring(BrickColor.new(SettingsFrame.ContentFrame[_ .. "Box"].Text))
					Color_Codes[_] = BrickColor.new(SettingsFrame.ContentFrame[_ .. "Box"].Text)
					Viewer:UpdateColor()
				end
			end)
		end]]
		
		return color_handler
		
	end
	
	-- Create pages
	local function CreatePages()
		
		local Pages_Handler = {["Pages"] = { }}
		local Current_Page_Type = "Handles"
		local Current_Page_Num = 1
		
		function Pages_Handler.SelectPart(this, PartType, PartModel, Gui, Guis)
			Viewer:LoadPart(PartType, PartModel)  -- SelectedParts[PartType] = PartModel -- TODO: LOAD PARTS // DONE
			for _, v in pairs(Guis) do
				if v[1]==Gui then
					v[1].BorderColor3 = Color3.new(1, 1, 127/255)
				else
					v[1].BorderColor3 = Color3.new(27/255, 42/255, 53/255)
				end
			end
		end
		
		function Pages_Handler.PageUpdate(new)
			
			if Current_Page_Num - new==#tab then
				Current_Page_Num = 1
			elseif Current_Page_Num + new==1 then
				Current_Page_Num = #tab
			end
			
			GunFrame.PageFrame.PageLabel.Text = Current_Page_Num .. "/" .. #tab
		end
		
		function Pages_Handler.LoadPage(this, Type, num, new)
			local Num;
			local Type = Type or Current_Page_Type
			if Current_Page_Type==Type and new then
				if Current_Page_Num+new>#this.Pages[Type] then
					Num = 1
				elseif Current_Page_Num+new<1 then
					Num = #this.Pages[Type]
				else
					Num = Current_Page_Num + new
				end
			else
				Num = Num or 1
			end
			Current_Page_Num = Num
			Current_Page_Type = Type
			for i, v in pairs(this.Pages) do
				for ii, page in pairs(v) do
					if ii==Num and i==Type then
						for _, gui in pairs(page) do
							gui[1].Visible = true
						end
					else
						for _, gui in pairs(page) do
							gui[1].Visible = false
						end
					end
				end
			end
			GunFrame.PageFrame.PageLabel.Text = Current_Page_Num .. "/" .. #this.Pages[Type]
		--	this:PageUpdate(new)
		end
		

		
		function Pages_Handler.PageFlip(this, Num, Type, new)
			this:LoadPage(Type, Num, new)
		end
		
		function Pages_Handler.Initialize(this)
			for _, v in pairs(TableOfGunParts) do
				local xcount = 1
				local ycount = 1
				local page_num = 1
				local Book = { }
				for __, vv in pairs(v:GetChildren()) do
					if Book[page_num]==nil then Book[page_num] = { } end
					local gui = GunFrame.PartFrame.PartPieceTemplate:Clone()
					gui.Parent = GunFrame.PartFrame
					gui.Position = UDim2.new(.3 * (xcount - 1), 0, .31 * (ycount - 1), 0)
					gui.Size = UDim2.new(.25, 0, .3, 0)
					gui.NameButton.Text = vv.Name
					gui.Visible = false
					local event = gui.NameButton.MouseButton1Click:connect(function()
						this:SelectPart(v.Name, vv, gui, Book[page_num])
					end)
					Book[page_num][#Book[page_num]+1] = {gui, event}
					xcount = xcount + 1
					if xcount>3 then
						ycount = ycount + 1
						xcount = 1
					end
					if ycount>3 then
						ycount = 1
						xcount = 1
						page_num = page_num + 1
					end
				end
				this.Pages[v.Name] = Book
			end
			GunFrame.PageFrame.Next.MouseButton1Down:connect(function()
				this:PageFlip(Current_Page_Num + 1, nil, 1)
			end)
			GunFrame.PageFrame.Previous.MouseButton1Down:connect(function()
				this:PageFlip(Current_Page_Num - 1, nil, -1)
			end)
			this:LoadPage(Current_Page_Type)
		end
			
		return Pages_Handler
	end
	

	local Tabs = CreateTabs()
	local Pager = CreatePages()
	ColorHandler()
	Pager:Initialize()
	Tabs:SetPageLoaderFunc(Pager)

	Viewer:CreateUpdaterNode(function(s)
		Gui.Frame.GunNameLabel.Text = s["Barrels"].PartName.Value .. s["Handles"].PartName.Value
	end)
	
	Gui.Frame.GunNameLabel.Text = SelectedParts["Barrels"].PartName.Value .. SelectedParts["Handles"].PartName.Value
	
	function Gui_Handler.Destroy(this)
		Gui:Destroy()
		Tabs = nil
		Pager = nil
	end
	
	return Gui_Handler
end

local Gui = Shop_Gui(Viewer)

--[[
Camera:StopCamera()
Viewer:Destroy()
Gui:Destroy()
]]

	
		
		
			
		
