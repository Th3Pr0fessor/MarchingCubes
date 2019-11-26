local Dist = 20
local Scale = .2
local seed = math.random(100,800)/1000
local s = math.random(2,8)/100
local res = 100
local terrain_data = {}
local GridData = {}
local Points = {}
local MarchingModule = require(script.Parent.MarchingCubesAlgorithm)
local TriangleTable = MarchingModule.TriTable()
local EdgeTable = MarchingModule.EdgeTable()
local first = true

function Connector(Section)
	local String = "{"
	for i, v in pairs(Section) do
		if i ~= #Section then
			String = String..v..", "
		end
		if i == #Section then
			String = String..v.."}"
		end
	end
	if String ~= "{" then
		print(String)
	end
	
end

local function Grid(Object, NumberAmountTable, Scale)
	local Number = 0
	for X = 0, NumberAmountTable.X*Scale do
		terrain_data[X] = {}
		GridData[X] = {}
		for Y = 0, NumberAmountTable.Y*Scale do
			terrain_data[X][Y] = {}
			GridData[X][Y] = {}
			for Z = 0, (NumberAmountTable.Z)*Scale do
				local Density = math.sqrt(math.noise(X /s, Y/s, Z/s, seed))
				print(math.sqrt(math.noise(X * s, Y * s, Z * s, seed)))
				--print("math.noise(X * s, Y * s, Z * s, seed) = ", Density)
				local Clone = Object:Clone()
				local Xmath = (Object.CFrame.RightVector * (NumberAmountTable.X) * X/NumberAmountTable.X)/Scale
				local Zmath = (Object.CFrame.LookVector * (NumberAmountTable.Z) * Z/NumberAmountTable.Z)/Scale
				local Ymath = (Object.CFrame.UpVector * -(NumberAmountTable.Y) * Y/NumberAmountTable.Y)/Scale--]]
				Clone.Size = Vector3.new(.5, .5, .5)
				Clone.Position = Clone.Position:Lerp(Object.Position + Xmath + Zmath  + Ymath, 1)
				Clone.BillboardGui:Destroy()
				Clone.Parent = game.Workspace.MarchingCubes
				Clone.Name = "GridPoint"..Number
				Clone.Shape = Enum.PartType.Ball
				Clone.Color = Color3.new(Density/.5, Density/.5, Density/.5)
				Clone.Transparency = Density/.5
				
				--print(Density/.5)
				local NumberValue = Instance.new("NumberValue")
				table.insert(Points, Clone)
				NumberValue.Parent = Clone
				NumberValue.Name = "Density"
				NumberValue.Value = Density/.5
				Number = Number + 1
				--print(Density, Density/.5)
				terrain_data[X][Y][Z]    = {Density > 0.15 and 1 or 0, Density}
				GridData[X][Y][Z] = Clone
--				if Density/.5 < 0 then
--					Clone:Destroy()
--				end
				
			end
			--wait()
		end
		wait()
	end
end
local Part7 = script.Parent.Part7
local NumberAmountTable = {}
NumberAmountTable.Z = (Part7.Position - (Part7.Position + Vector3.new(0,0,Dist))).magnitude
NumberAmountTable.X = (Part7.Position - (Part7.Position + Vector3.new(Dist,0,0))).magnitude
NumberAmountTable.Y = (Part7.Position - (Part7.Position - Vector3.new(0,Dist,0))).magnitude 
Grid(Part7, NumberAmountTable, Scale)
Part7:Destroy()


for Y = 0, NumberAmountTable.Y*Scale - 1 do
	for X = 0, NumberAmountTable.X*Scale - 1 do
		for Z = 0, (NumberAmountTable.Z)*Scale - 1 do
			local HB = game:GetService("RunService").Heartbeat
			local points = {}
			local point_0        = GridData[X][Y][Z]
			local point_1        = GridData[X][Y + 1][Z]
			local point_2        = GridData[X][Y + 1][Z + 1]
			local point_3        = GridData[X][Y][Z + 1]
			local point_4        = GridData[X + 1][Y][Z]
			local point_5        = GridData[X + 1][Y + 1][Z]
			local point_6        = GridData[X + 1][Y + 1][Z + 1]
			local point_7        = GridData[X + 1][Y][Z + 1]
			local pt_0        = terrain_data[X][Y][Z]
			--print(pt_0[1])
			table.insert(points, 1, pt_0)
			local pt_1        = terrain_data[X][Y + 1][Z]
			table.insert(points, 2, pt_1)
			local pt_2        = terrain_data[X][Y + 1][Z + 1]
			table.insert(points, 3,pt_2)
			local pt_3        = terrain_data[X][Y][Z + 1]
			table.insert(points, 4,pt_3)
			local pt_4        = terrain_data[X + 1][Y][Z]
			table.insert(points, 5,pt_4)
			local pt_5        = terrain_data[X + 1][Y + 1][Z]
			table.insert(points, 6,pt_5)
			local pt_6        = terrain_data[X + 1][Y + 1][Z + 1]
			table.insert(points, 7, pt_6)
			local pt_7        = terrain_data[X + 1][Y][Z + 1]
			table.insert(points,  8,pt_7)			
			local String = ""
			for i, v in pairs(points) do
				String = String..v[1]
			end
			if MarchingModule.BinHex(String) == "00" then
				String = 0x00
				--print(TriangleTable[0x00 + 1])
			elseif MarchingModule.BinHex(String) ~= nil then
				print("0x"..MarchingModule.BinHex(String), " = ", tonumber("0x"..MarchingModule.BinHex(String)))
				String = tonumber("0x"..MarchingModule.BinHex(String))
				
			end
			print(String)
			if String ~= 0 then
				
--				print(TriangleTable[String])
--				--Connector(TriangleTable[String])
--				print(String)
				local Section = TriangleTable[String]
				local Mid = MarchingModule.Visualize(point_0, point_1, point_2, point_3, point_4, point_5, point_6, point_7, Section, points)
				
			end
			HB:Wait()
			
		end
	end
end	

for i, v in pairs(Points) do
	v:Destroy()
end

