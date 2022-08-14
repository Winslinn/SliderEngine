local uis = game:GetService("UserInputService")

local getSliders = game:GetService("CollectionService"):GetTagged("slider")
local mouseDown = false

local activeSlider = nil
local points

local function sliderUpdate()
	local mousePos = uis:GetMouseLocation()
	local slideFrame = activeSlider:FindFirstChildOfClass("Frame")
	local absoluteSizeX = slideFrame.AbsoluteSize.X
	local rSlide = absoluteSizeX / 2
	
	local absoluteX = math.clamp(mousePos.X - activeSlider.AbsolutePosition.X - rSlide, 0, math.huge)
	local endWay = activeSlider.AbsoluteSize.X - absoluteSizeX

	local xScale = math.clamp(absoluteX / endWay, 0, 1)
	if activeSlider:GetAttribute("Points") > 0 then
		if activeSlider:GetAttribute("Percentages") == true then
			points = activeSlider:GetAttribute("Points") * 0.01
		else
			points = activeSlider:GetAttribute("Points") / (activeSlider:GetAttribute("Multiplier") / 100)
			if points < 1 then return end
			points *= 0.01
		end
		
		xScale = math.floor(math.clamp(absoluteX / endWay, 0, 1) / points) * points
	end
	
	slideFrame.AnchorPoint = Vector2.new(xScale, 0.5)
	slideFrame.Position = UDim2.fromScale(xScale , slideFrame.Position.Y.Scale)
	activeSlider:SetAttribute("Result", xScale * activeSlider:GetAttribute("Multiplier"))
end

for _,slider in pairs(getSliders) do
	slider.MouseButton1Down:Connect(function()
		mouseDown = true
		activeSlider = slider
		sliderUpdate()
	end)
end

uis.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	mouseDown = false
	activeSlider = nil
end)

uis.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and mouseDown then
		sliderUpdate()
	end
end)
