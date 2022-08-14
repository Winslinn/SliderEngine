local uis = game:GetService("UserInputService")

local mouseDown = false
local activeSlider = nil

local function sliderUpdate()
	local mousePos = uis:GetMouseLocation()
	local slideFrame = activeSlider:FindFirstChildOfClass("Frame")
	local absoluteSizeX = slideFrame.AbsoluteSize.X
	local rSlide = absoluteSizeX / 2
	
	local x = mousePos.X - activeSlider.AbsolutePosition.X - rSlide
	if activeSlider:GetAttribute("Points") > 0 then
		local points = absoluteSizeX / activeSlider:GetAttribute("Points")
		x = math.floor((mousePos.X - activeSlider.AbsolutePosition.X) / points) * points
	end
	
	local absoluteX = math.clamp(x, 0, math.huge)
	local endWay = activeSlider.AbsoluteSize.X - absoluteSizeX

	local xScale = math.clamp(absoluteX / endWay, 0, 1)
	
	slideFrame.AnchorPoint = Vector2.new(xScale, 0.5)
	slideFrame.Position = UDim2.fromScale(xScale , slideFrame.Position.Y.Scale)
	activeSlider:SetAttribute("Result", xScale * activeSlider:GetAttribute("Multiplier"))
end

for _,slider in pairs(game:GetService("CollectionService"):GetTagged("slider")) do
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