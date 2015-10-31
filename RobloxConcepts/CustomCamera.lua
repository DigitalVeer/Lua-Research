repeat wait() until game.Players.LocalPlayer;
local player = game.Players.LocalPlayer;
repeat wait() until player.Character;
repeat wait() until player.Character:FindFirstChild("Humanoid");
local character = player.Character;


local currentArm = character:FindFirstChild("Right Arm");
workspace.CurrentCamera:Destroy()
wait()
local camera = workspace.CurrentCamera;
camera.CameraType = "Scriptable"
camera.FieldOfView = 80;
local mouse = player:GetMouse();

local camPart = Instance.new("Part", camera);
camPart.FormFactor = "Custom"
camPart.Size = Vector3.new(.2,.2,.2)
camPart.Anchored = true;
camPart.CanCollide = false;
camPart.Name = "CameraPart";
--camPart.Shape = "Ball";
camPart.TopSurface = "Smooth";
camPart.BottomSurface = "Smooth";
camPart.BrickColor = BrickColor.new("White");
camPart.Transparency = .8;

local centerPart = character.HumanoidRootPart;

local motivator = Instance.new("BodyPosition", camPart);
motivator.D = motivator.D / 2;
local angle = 0;
local anglex = math.deg(({centerPart.CFrame:toEulerAnglesXYZ()})[1]);

local lastpos = Vector2.new(mouse.ViewSizeX/2, mouse.ViewSizeY/2);

local position = CFrame.new(centerPart.Position, centerPart.Position + centerPart.CFrame.lookVector) * CFrame.new((centerPart.Size.X/2) + currentArm.Size.X, centerPart.Size.Y/2, 0)
local pos = CFrame.new();

position = centerPart.CFrame:toObjectSpace(position);
print(position);

character.Humanoid.AutoRotate = false;
local characterMover = Instance.new("BodyGyro", character.HumanoidRootPart);
characterMover.maxTorque = Vector3.new(0, 400000, 0);

function updatePart()
	local anglexPadder = anglex;
	motivator.position = ((centerPart.CFrame * position) + (
		(centerPart.CFrame * position * CFrame.Angles(math.rad(angle),0, 0)).lookVector * 10)).p
	characterMover.cframe = CFrame.new(centerPart.Position) * CFrame.Angles(0, math.rad(-anglexPadder), 0);
end
camPart.Anchored = false;
camPart:BreakJoints();

local deltax = 0;
local deltay = 0;

function mouseMoveDeltaHandler(deltax, deltay)
	if deltax~=0 then
		local deltaxSign = deltax / math.abs(deltax);
		local deltaxMove = (math.abs(deltax)>=5 and 5 or 1);
		anglex = ((anglex + ((deltaxMove * deltaxSign)))) % 360;
	else
	end
	
	if deltay~=0 then
		local deltaySign = deltay / math.abs(deltay);
		local deltayMove = (math.abs(deltay)>=5 and -5 or -1);
		angle = math.min(math.max(angle + (deltayMove * deltaySign), -20), 30);
	else
	end;
	
	updatePart();
end


game:GetService("UserInputService").MouseIconEnabled = false
game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter;
game:GetService("UserInputService").InputChanged:connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
		mouseMoveDeltaHandler(inputObject.Delta.x, inputObject.Delta.y);
		print("delta is (" .. tostring(inputObject.Delta.x) .. ", " ..  tostring(inputObject.Delta.y) .. ")")
	end
end)

game:GetService("RunService").RenderStepped:connect(function()
	updatePart();
	pos = centerPart.CFrame * position;
	local lookCFrame = CFrame.new(motivator.position, pos.p)
--	pos = pos + (lookCFrame.lookVector * 7);
--	pos = pos + Vector3.new(3, 4, 4);
	camera.CoordinateFrame = CFrame.new(pos.p, camPart.Position);
end)

local b2Down = false;

mouse.Button2Down:connect(function()
	b2Down = true;
	for i = camera.FieldOfView, 50, -10 do
		if not b2Down then break end;
		camera.FieldOfView = i
		wait()
	end 
end)

mouse.Button2Up:connect(function()
	b2Down = false;
	for i = camera.FieldOfView, 80, 10 do
		if b2Down then break end;
		camera.FieldOfView = i;
		wait();
	end
end)

