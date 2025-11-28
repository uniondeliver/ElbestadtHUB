-- UI Library pour AutoForge
-- Bibliothèque extraite et optimisée

local library = {
	Renders = {},
	Connections = {},
}
local utility = {}
local pages = {}
local sections = {}

do
	library.__index = library
	pages.__index = pages
	sections.__index = sections
end

local tws = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local cre = game:GetService("CoreGui")

function utility:RenderObject(RenderType, RenderProperties, RenderHidden)
	local Render = Instance.new(RenderType)

	if RenderProperties and typeof(RenderProperties) == "table" then
		for Property, Value in pairs(RenderProperties) do
			if Property ~= "RenderTime" then
				Render[Property] = Value
			end
		end
	end

	library.Renders[#library.Renders + 1] = {Render, RenderProperties, RenderHidden, RenderProperties and RenderProperties["RenderTime"] or nil}

	return Render
end

function utility:CreateConnection(ConnectionType, ConnectionCallback)
	local Connection = ConnectionType:Connect(ConnectionCallback)
	library.Connections[#library.Connections + 1] = Connection
	return Connection
end

function utility:MouseLocation()
	return uis:GetMouseLocation()
end

function library:CreateWindow(Properties)
	Properties = Properties or {}

	local Window = {
		Pages = {},
		Accent = Color3.fromRGB(255, 120, 30),
		Enabled = true,
		Key = Enum.KeyCode.Insert
	}

	do
		local ScreenGui = utility:RenderObject("ScreenGui", {
			DisplayOrder = 9999,
			Enabled = true,
			IgnoreGuiInset = true,
			Parent = cre,
			ResetOnSpawn = false,
			ZIndexBehavior = "Global"
		})

		local ScreenGui_MainFrame = utility:RenderObject("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(25, 25, 25),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(12, 12, 12),
			BorderMode = "Inset",
			BorderSizePixel = 1,
			Parent = ScreenGui,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 660, 0, 560)
		})

		local ScreenGui_MainFrame_InnerBorder = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = ScreenGui_MainFrame,
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2)
		})

		local MainFrame_InnerBorder_InnerFrame = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(12, 12, 12),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(60, 60, 60),
			BorderMode = "Inset",
			BorderSizePixel = 1,
			Parent = ScreenGui_MainFrame,
			Position = UDim2.new(0, 3, 0, 3),
			Size = UDim2.new(1, -6, 1, -6)
		})

		local InnerBorder_InnerFrame_Tabs = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(12, 12, 12),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = MainFrame_InnerBorder_InnerFrame,
			Position = UDim2.new(0, 0, 0, 4),
			Size = UDim2.new(0, 74, 1, -4)
		})

		local InnerBorder_InnerFrame_Pages = utility:RenderObject("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = MainFrame_InnerBorder_InnerFrame,
			Position = UDim2.new(1, 0, 0, 4),
			Size = UDim2.new(1, -73, 1, -4)
		})

		local InnerBorder_InnerFrame_TopGradient = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(12, 12, 12),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = MainFrame_InnerBorder_InnerFrame,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 4)
		})

		local InnerFrame_Tabs_List = utility:RenderObject("UIListLayout", {
			Padding = UDim.new(0, 4),
			Parent = InnerBorder_InnerFrame_Tabs,
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			VerticalAlignment = "Top"
		})

		local InnerFrame_Tabs_Padding = utility:RenderObject("UIPadding", {
			Parent = InnerBorder_InnerFrame_Tabs,
			PaddingTop = UDim.new(0, 9)
		})

		local InnerFrame_Pages_InnerBorder = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = InnerBorder_InnerFrame_Pages,
			Position = UDim2.new(0, 1, 0, 0),
			Size = UDim2.new(1, -1, 1, 0)
		})

		local InnerFrame_TopGradient_Gradient = utility:RenderObject("ImageLabel", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = InnerBorder_InnerFrame_TopGradient,
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2),
			Image = "rbxassetid://8508019876",
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		})

		local Pages_InnerBorder_InnerFrame = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = InnerFrame_Pages_InnerBorder,
			Position = UDim2.new(0, 1, 0, 0),
			Size = UDim2.new(1, -1, 1, 0)
		})

		local InnerBorder_InnerFrame_Folder = utility:RenderObject("Folder", {
			Parent = Pages_InnerBorder_InnerFrame
		})

		local InnerBorder_InnerFrame_Pattern = utility:RenderObject("ImageLabel", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Pages_InnerBorder_InnerFrame,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			Image = "rbxassetid://8547666218",
			ImageColor3 = Color3.fromRGB(12, 12, 12),
			ScaleType = "Tile",
			TileSize = UDim2.new(0, 8, 0, 8)
		})

		function Window:SetPage(Page)
			for index, page in pairs(Window.Pages) do
				if page.Open and page ~= Page then
					page:Set(false)
				end
			end
		end

		function Window:Fade(state)
			for index, render in pairs(library.Renders) do
				if not render[3] then
					if render[1].ClassName == "Frame" and (render[2]["BackgroundTransparency"] or 0) ~= 1 then
						tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = state and (render[2]["BackgroundTransparency"] or 0) or 1}):Play()
					elseif render[1].ClassName == "ImageLabel" then
						if (render[2]["BackgroundTransparency"] or 0) ~= 1 then
							tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = state and (render[2]["BackgroundTransparency"] or 0) or 1}):Play()
						end
						if (render[2]["ImageTransparency"] or 0) ~= 1 then
							tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {ImageTransparency = state and (render[2]["ImageTransparency"] or 0) or 1}):Play()
						end
					elseif render[1].ClassName == "TextLabel" then
						if (render[2]["BackgroundTransparency"] or 0) ~= 1 then
							tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = state and (render[2]["BackgroundTransparency"] or 0) or 1}):Play()
						end
						if (render[2]["TextTransparency"] or 0) ~= 1 then
							tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {TextTransparency = state and (render[2]["TextTransparency"] or 0) or 1}):Play()
						end
					elseif render[1].ClassName == "ScrollingFrame" then
						if (render[2]["BackgroundTransparency"] or 0) ~= 1 then
							tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = state and (render[2]["BackgroundTransparency"] or 0) or 1}):Play()
						end
						if (render[2]["ScrollBarImageTransparency"] or 0) ~= 1 then
							tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {ScrollBarImageTransparency = state and (render[2]["ScrollBarImageTransparency"] or 0) or 1}):Play()
						end
					end
				end
			end
		end

		function Window:Unload()
			ScreenGui:Destroy()
			for index, connection in pairs(library.Connections) do
				connection:Disconnect()
			end
			library = nil
			utility = nil
		end

		Window["TabsHolder"] = InnerBorder_InnerFrame_Tabs
		Window["PagesHolder"] = InnerBorder_InnerFrame_Folder

		utility:CreateConnection(uis.InputBegan, function(Input)
			if Input.KeyCode and Input.KeyCode == Window.Key then
				Window.Enabled = not Window.Enabled
				Window:Fade(Window.Enabled)
			end
		end)
	end

	return setmetatable(Window, library)
end

function library:CreatePage(Properties)
	Properties = Properties or {}

	local Page = {
		Image = (Properties.image or Properties.Image or Properties.icon or Properties.Icon),
		Size = (Properties.size or Properties.Size or UDim2.new(0, 50, 0, 50)),
		Open = false,
		Window = self
	}

	do
		local Page_Tab = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Page.Window["TabsHolder"],
			Size = UDim2.new(1, 0, 0, 72)
		})

		local Page_Tab_Border = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Page_Tab,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = false,
			ZIndex = 2,
			RenderTime = 0.15
		})

		local Page_Tab_Image = utility:RenderObject("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Page_Tab,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = Page.Size,
			ZIndex = 2,
			Image = Page.Image,
			ImageColor3 = Color3.fromRGB(100, 100, 100)
		})

		local Page_Tab_Button = utility:RenderObject("TextButton", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Page_Tab,
			Size = UDim2.new(1, 0, 1, 0),
			Text = ""
		})

		local Tab_Border_Inner = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Page_Tab_Border,
			Position = UDim2.new(0, 0, 0, 1),
			Size = UDim2.new(1, 1, 1, -2),
			ZIndex = 2,
			RenderTime = 0.15
		})

		local Border_Inner_Inner = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Tab_Border_Inner,
			Position = UDim2.new(0, 0, 0, 1),
			Size = UDim2.new(1, 0, 1, -2),
			ZIndex = 2,
			RenderTime = 0.15
		})

		local Inner_Inner_Pattern = utility:RenderObject("ImageLabel", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Border_Inner_Inner,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			Image = "rbxassetid://8509210785",
			ImageColor3 = Color3.fromRGB(12, 12, 12),
			ScaleType = "Tile",
			TileSize = UDim2.new(0, 8, 0, 8),
			ZIndex = 2
		})

		local Page_Page = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Page.Window["PagesHolder"],
			Position = UDim2.new(0, 20, 0, 20),
			Size = UDim2.new(1, -40, 1, -40),
			Visible = false
		})

		local Page_Page_Left = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Page_Page,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0.5, -10, 1, 0)
		})

		local Page_Page_Right = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Parent = Page_Page,
			Position = UDim2.new(0.5, 10, 0, 0),
			Size = UDim2.new(0.5, -10, 1, 0)
		})

		local Page_Left_List = utility:RenderObject("UIListLayout", {
			Padding = UDim.new(0, 18),
			Parent = Page_Page_Left,
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			VerticalAlignment = "Top"
		})

		local Page_Right_List = utility:RenderObject("UIListLayout", {
			Padding = UDim.new(0, 18),
			Parent = Page_Page_Right,
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			VerticalAlignment = "Top"
		})

		Page["Page"] = Page_Page
		Page["Left"] = Page_Page_Left
		Page["Right"] = Page_Page_Right

		function Page:Set(state)
			Page.Open = state
			Page_Page.Visible = Page.Open
			Page_Tab_Border.Visible = Page.Open
			Page_Tab_Image.ImageColor3 = Page.Open and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90)

			if Page.Open then
				Page.Window:SetPage(Page)
			end
		end

		utility:CreateConnection(Page_Tab_Button.MouseButton1Click, function(Input)
			if not Page.Open then
				Page:Set(true)
			end
		end)

		utility:CreateConnection(Page_Tab_Button.MouseEnter, function(Input)
			Page_Tab_Image.ImageColor3 = Color3.fromRGB(172, 172, 172)
		end)

		utility:CreateConnection(Page_Tab_Button.MouseLeave, function(Input)
			Page_Tab_Image.ImageColor3 = Page.Open and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90)
		end)
	end

	if #Page.Window.Pages == 0 then Page:Set(true) end
	Page.Window.Pages[#Page.Window.Pages + 1] = Page
	return setmetatable(Page, pages)
end

-- Retourne la bibliothèque
return library
