--============================================================
-- SHADOW USERNAME CHECKER
-- SAFE ROBLOX STUDIO VERSION
--
-- Generates usernames and checks whether the username
-- resolves to an existing Roblox account.
--
-- ✅ = No Roblox account found
-- ❌ = Roblox account exists
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--============================================================
-- SETTINGS
--============================================================

local DEFAULT_AMOUNT = 10
local DEFAULT_LENGTH = 5

local amount = DEFAULT_AMOUNT
local nameLength = DEFAULT_LENGTH

-- Added "_" so underscores can appear inside usernames
local characters = "abcdefghijklmnopqrstuvwxyz0123456789_"

-- Obviously inappropriate terms to reject
local blockedTerms = {
	"fuck",
	"fuk",
	"fck",
	"shit",
	"sh1t",
	"bitch",
	"b1tch",
	"asshole",
	"arsehole",
	"dick",
	"d1ck",
	"cock",
	"c0ck",
	"pussy",
	"puss",
	"porn",
	"porno",
	"nude",
	"nudes",
	"sex",
	"sexy",
	"rape",
	"rapist",
	"nazi",
	"nigger",
	"nigga",
	"whore",
	"slut",
	"cum",
	"cumming",
	"penis",
	"vagina",
	"boobs",
	"tits",
	"t1ts",
	"balls",
	"anus",
	"anal",
	"horny",
	"blowjob",
	"handjob",
	"masturbat",
	"pedo",
	"pedophile"
}

local results = {}
local checking = false

--============================================================
-- GUI
--============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "ShadowUsernameChecker"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(450, 540)
main.Position = UDim2.new(0.5, -225, 0.5, -270)
main.BackgroundColor3 = Color3.fromRGB(17,17,23)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,15)

local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(100,70,255)
outline.Thickness = 2
outline.Parent = main

--============================================================
-- TITLE
--============================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,0,42)
title.Position = UDim2.fromOffset(15,5)
title.BackgroundTransparency = 1
title.Text = "SHADOW USERNAME CHECKER"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(35,35)
close.Position = UDim2.new(1,-45,0,8)
close.BackgroundColor3 = Color3.fromRGB(35,35,45)
close.Text = "×"
close.TextColor3 = Color3.fromRGB(255,100,100)
close.TextSize = 23
close.Font = Enum.Font.GothamBold
close.Parent = main

Instance.new("UICorner", close).CornerRadius = UDim.new(0,8)

--============================================================
-- TABS
--============================================================

local exampleTab = Instance.new("TextButton")
exampleTab.Size = UDim2.new(.5,-15,0,38)
exampleTab.Position = UDim2.fromOffset(10,55)
exampleTab.BackgroundColor3 = Color3.fromRGB(75,55,180)
exampleTab.Text = "EXAMPLE"
exampleTab.TextColor3 = Color3.new(1,1,1)
exampleTab.TextSize = 13
exampleTab.Font = Enum.Font.GothamBold
exampleTab.Parent = main

Instance.new("UICorner", exampleTab).CornerRadius = UDim.new(0,8)

local usernamesTab = Instance.new("TextButton")
usernamesTab.Size = UDim2.new(.5,-15,0,38)
usernamesTab.Position = UDim2.new(.5,5,0,55)
usernamesTab.BackgroundColor3 = Color3.fromRGB(32,32,42)
usernamesTab.Text = "USERNAMES"
usernamesTab.TextColor3 = Color3.fromRGB(180,180,190)
usernamesTab.TextSize = 13
usernamesTab.Font = Enum.Font.GothamBold
usernamesTab.Parent = main

Instance.new("UICorner", usernamesTab).CornerRadius = UDim.new(0,8)

--============================================================
-- PAGES
--============================================================

local examplePage = Instance.new("Frame")
examplePage.Size = UDim2.new(1,-20,1,-105)
examplePage.Position = UDim2.fromOffset(10,100)
examplePage.BackgroundTransparency = 1
examplePage.Parent = main

local usernamesPage = Instance.new("Frame")
usernamesPage.Size = UDim2.new(1,-20,1,-105)
usernamesPage.Position = UDim2.fromOffset(10,100)
usernamesPage.BackgroundTransparency = 1
usernamesPage.Visible = false
usernamesPage.Parent = main
--============================================================
-- GENERATION MODES
--============================================================

local numberMode = false
local letterMode = false

local numberModeButton = Instance.new("TextButton")
numberModeButton.Size = UDim2.fromOffset(120,32)
numberModeButton.Position = UDim2.fromOffset(275,3)
numberModeButton.BackgroundColor3 = Color3.fromRGB(32,32,42)
numberModeButton.Text = "NUMBER MODE: OFF"
numberModeButton.TextColor3 = Color3.fromRGB(180,180,190)
numberModeButton.TextSize = 11
numberModeButton.Font = Enum.Font.GothamBold
numberModeButton.Parent = usernamesPage

Instance.new("UICorner", numberModeButton).CornerRadius = UDim.new(0,7)

local letterModeButton = Instance.new("TextButton")
letterModeButton.Size = UDim2.fromOffset(120,32)
letterModeButton.Position = UDim2.fromOffset(275,46)
letterModeButton.BackgroundColor3 = Color3.fromRGB(32,32,42)
letterModeButton.Text = "LETTER MODE: OFF"
letterModeButton.TextColor3 = Color3.fromRGB(180,180,190)
letterModeButton.TextSize = 11
letterModeButton.Font = Enum.Font.GothamBold
letterModeButton.Parent = usernamesPage

Instance.new("UICorner", letterModeButton).CornerRadius = UDim.new(0,7)

numberModeButton.MouseButton1Click:Connect(function()

	numberMode = not numberMode

	if numberMode then
		letterMode = false

		numberModeButton.Text = "NUMBER MODE: ON"
		numberModeButton.BackgroundColor3 = Color3.fromRGB(75,55,180)
		numberModeButton.TextColor3 = Color3.new(1,1,1)

		letterModeButton.Text = "LETTER MODE: OFF"
		letterModeButton.BackgroundColor3 = Color3.fromRGB(32,32,42)
		letterModeButton.TextColor3 = Color3.fromRGB(180,180,190)
	else
		numberModeButton.Text = "NUMBER MODE: OFF"
		numberModeButton.BackgroundColor3 = Color3.fromRGB(32,32,42)
		numberModeButton.TextColor3 = Color3.fromRGB(180,180,190)
	end
end)

letterModeButton.MouseButton1Click:Connect(function()

	letterMode = not letterMode

	if letterMode then
		numberMode = false

		letterModeButton.Text = "LETTER MODE: ON"
		letterModeButton.BackgroundColor3 = Color3.fromRGB(75,55,180)
		letterModeButton.TextColor3 = Color3.new(1,1,1)

		numberModeButton.Text = "NUMBER MODE: OFF"
		numberModeButton.BackgroundColor3 = Color3.fromRGB(32,32,42)
		numberModeButton.TextColor3 = Color3.fromRGB(180,180,190)
	else
		letterModeButton.Text = "LETTER MODE: OFF"
		letterModeButton.BackgroundColor3 = Color3.fromRGB(32,32,42)
		letterModeButton.TextColor3 = Color3.fromRGB(180,180,190)
	end
end)

--============================================================
-- EXAMPLE PAGE
--============================================================

local exampleTitle = Instance.new("TextLabel")
exampleTitle.Size = UDim2.new(1,0,0,35)
exampleTitle.BackgroundTransparency = 1
exampleTitle.Text = "HOW RESULTS LOOK"
exampleTitle.TextColor3 = Color3.new(1,1,1)
exampleTitle.TextSize = 18
exampleTitle.Font = Enum.Font.GothamBold
exampleTitle.Parent = examplePage

local exampleBox = Instance.new("Frame")
exampleBox.Size = UDim2.new(1,-20,0,235)
exampleBox.Position = UDim2.fromOffset(10,55)
exampleBox.BackgroundColor3 = Color3.fromRGB(24,24,32)
exampleBox.Parent = examplePage

Instance.new("UICorner", exampleBox).CornerRadius = UDim.new(0,12)

local function createExampleRow(text, y, textColor)

	local row = Instance.new("TextLabel")
	row.Size = UDim2.new(1,-20,0,42)
	row.Position = UDim2.fromOffset(10,y)
	row.BackgroundColor3 = Color3.fromRGB(30,30,40)
	row.Text = text
	row.TextColor3 = textColor
	row.TextSize = 14
	row.Font = Enum.Font.GothamSemibold
	row.TextXAlignment = Enum.TextXAlignment.Left
	row.Parent = exampleBox

	Instance.new("UICorner", row).CornerRadius = UDim.new(0,7)
end

createExampleRow(
	"  ⏳  Shadow123 — Checking...",
	10,
	Color3.fromRGB(255,210,80)
)

createExampleRow(
	"  ❌  Roblox — Unavailable",
	62,
	Color3.fromRGB(255,100,100)
)

createExampleRow(
	"  ✅  RandomName — Available!",
	114,
	Color3.fromRGB(100,255,150)
)

--============================================================
-- USERNAME PAGE
--============================================================

local amountLabel = Instance.new("TextLabel")
amountLabel.Size = UDim2.fromOffset(160,30)
amountLabel.Position = UDim2.fromOffset(5,5)
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "Usernames to generate"
amountLabel.TextColor3 = Color3.fromRGB(205,205,215)
amountLabel.TextSize = 13
amountLabel.Font = Enum.Font.GothamSemibold
amountLabel.TextXAlignment = Enum.TextXAlignment.Left
amountLabel.Parent = usernamesPage

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.fromOffset(90,32)
amountBox.Position = UDim2.fromOffset(175,3)
amountBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
amountBox.Text = tostring(DEFAULT_AMOUNT)
amountBox.TextColor3 = Color3.new(1,1,1)
amountBox.TextSize = 13
amountBox.Font = Enum.Font.GothamBold
amountBox.ClearTextOnFocus = false
amountBox.Parent = usernamesPage

Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0,7)

local lengthLabel = Instance.new("TextLabel")
lengthLabel.Size = UDim2.fromOffset(160,30)
lengthLabel.Position = UDim2.fromOffset(5,48)
lengthLabel.BackgroundTransparency = 1
lengthLabel.Text = "Characters per name"
lengthLabel.TextColor3 = Color3.fromRGB(205,205,215)
lengthLabel.TextSize = 13
lengthLabel.Font = Enum.Font.GothamSemibold
lengthLabel.TextXAlignment = Enum.TextXAlignment.Left
lengthLabel.Parent = usernamesPage

local lengthBox = Instance.new("TextBox")
lengthBox.Size = UDim2.fromOffset(90,32)
lengthBox.Position = UDim2.fromOffset(175,46)
lengthBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
lengthBox.Text = tostring(DEFAULT_LENGTH)
lengthBox.TextColor3 = Color3.new(1,1,1)
lengthBox.TextSize = 13
lengthBox.Font = Enum.Font.GothamBold
lengthBox.ClearTextOnFocus = false
lengthBox.Parent = usernamesPage

Instance.new("UICorner", lengthBox).CornerRadius = UDim.new(0,7)

--============================================================
-- COUNTERS
--============================================================

local counters = Instance.new("TextLabel")
counters.Size = UDim2.new(1,-10,0,30)
counters.Position = UDim2.fromOffset(5,84)
counters.BackgroundTransparency = 1
counters.Text = "✅ 0 Available     ❌ 0 Taken"
counters.TextColor3 = Color3.fromRGB(180,180,195)
counters.TextSize = 12
counters.Font = Enum.Font.GothamSemibold
counters.Parent = usernamesPage

--============================================================
-- RESULTS
--============================================================

local resultsFrame = Instance.new("ScrollingFrame")
resultsFrame.Size = UDim2.new(1,-10,0,265)
resultsFrame.Position = UDim2.fromOffset(5,115)
resultsFrame.BackgroundColor3 = Color3.fromRGB(11,11,16)
resultsFrame.BorderSizePixel = 0
resultsFrame.ScrollBarThickness = 4
resultsFrame.CanvasSize = UDim2.new(0,0,0,0)
resultsFrame.Parent = usernamesPage

Instance.new("UICorner", resultsFrame).CornerRadius = UDim.new(0,10)

local resultLayout = Instance.new("UIListLayout")
resultLayout.Padding = UDim.new(0,5)
resultLayout.Parent = resultsFrame

local resultPadding = Instance.new("UIPadding")
resultPadding.PaddingTop = UDim.new(0,7)
resultPadding.PaddingLeft = UDim.new(0,7)
resultPadding.PaddingRight = UDim.new(0,7)
resultPadding.Parent = resultsFrame

--============================================================
-- HELPERS
--============================================================

local function updateCanvas()

	resultsFrame.CanvasSize = UDim2.fromOffset(
		0,
		resultLayout.AbsoluteContentSize.Y + 15
	)
end

local function clearResults()

	for _, child in ipairs(resultsFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	results = {}

	counters.Text = "✅ 0 Available     ❌ 0 Taken"
end

--============================================================
-- USERNAME FILTER
--============================================================

local function isUsernameSafe(username)

	local lowerName = string.lower(username)

	for _, blockedTerm in ipairs(blockedTerms) do

		if string.find(lowerName, blockedTerm, 1, true) then
			return false
		end

	end

	return true
end

--============================================================
-- USERNAME GENERATOR
--============================================================

local function generateUsername(length)

	local result = ""

	local generationCharacters = characters

	if numberMode then
		generationCharacters = "0123456789_"

	elseif letterMode then
		generationCharacters = "abcdefghijklmnopqrstuvwxyz_"
	end

	repeat

		result = ""

		for i = 1,length do

			local index = math.random(
				1,
				#generationCharacters
			)

			result ..= generationCharacters:sub(
				index,
				index
			)
		end

	-- Make sure "_" can only appear inside the username
	until result:sub(1,1) ~= "_"
		and result:sub(-1) ~= "_"
		and isUsernameSafe(result)

	return result
end

local function createResult(username)

	local row = Instance.new("TextLabel")

	row.Size = UDim2.new(1,-5,0,34)
	row.BackgroundColor3 = Color3.fromRGB(24,24,33)

	row.Text =
		"  ⏳  " ..
		username ..
		" — Checking..."

	row.TextColor3 =
		Color3.fromRGB(255,210,80)

	row.TextSize = 13
	row.Font = Enum.Font.GothamSemibold
	row.TextXAlignment = Enum.TextXAlignment.Left
	row.Parent = resultsFrame

	Instance.new("UICorner", row).CornerRadius = UDim.new(0,7)

	local data = {
		username = username,
		row = row,
		state = "checking"
	}

	table.insert(results, data)

	return data
end

local function updateCounters()

	local available = 0
	local taken = 0

	for _, data in ipairs(results) do

		if data.state == "available" then
			available += 1

		elseif data.state == "taken" then
			taken += 1
		end
	end

	counters.Text =
		"✅ " ..
		available ..
		" Available     ❌ " ..
		taken ..
		" Taken"
end

--============================================================
-- ROBLOX USERNAME LOOKUP
--============================================================

local function checkUsername(data)

	local username = data.username

	local success, userId = pcall(function()

		return Players:GetUserIdFromNameAsync(
			username
		)

	end)

	if success and userId then

		data.state = "taken"

		data.row.Text =
			"  ❌  " ..
			username ..
			" — Unavailable"

		data.row.TextColor3 =
			Color3.fromRGB(255,100,100)

	else

		data.state = "available"

		data.row.Text =
			"  ✅  " ..
			username ..
			" — Available!"

		data.row.TextColor3 =
			Color3.fromRGB(100,255,150)
	end

	updateCounters()
	updateCanvas()
end

--============================================================
-- GENERATE
--============================================================

local generate = Instance.new("TextButton")
generate.Size = UDim2.new(1,-10,0,40)
generate.Position = UDim2.new(0,5,1,-45)
generate.BackgroundColor3 = Color3.fromRGB(75,55,180)
generate.Text = "GENERATE & CHECK"
generate.TextColor3 = Color3.new(1,1,1)
generate.TextSize = 13
generate.Font = Enum.Font.GothamBold
generate.Parent = usernamesPage

Instance.new("UICorner", generate).CornerRadius = UDim.new(0,8)

generate.MouseButton1Click:Connect(function()

	if checking then
		return
	end

	checking = true

	local enteredAmount = tonumber(amountBox.Text)
	local enteredLength = tonumber(lengthBox.Text)

	if enteredAmount then

		amount = math.clamp(
			math.floor(enteredAmount),
			1,
			100
		)

		amountBox.Text = tostring(amount)
	end

	if enteredLength then

		nameLength = math.clamp(
			math.floor(enteredLength),
			3,
			20
		)

		lengthBox.Text = tostring(nameLength)
	end

	clearResults()

	generate.Text = "CHECKING..."

	for i = 1, amount do

		local username = generateUsername(nameLength)

		local duplicate = false

		for _, data in ipairs(results) do
			if data.username == username then
				duplicate = true
				break
			end
		end

		if not duplicate then

			local data = createResult(username)

			updateCanvas()

			task.spawn(function()
				checkUsername(data)
			end)

			task.wait(0.15)
		end
	end

	repeat
		task.wait()
	until (function()

		for _, data in ipairs(results) do
			if data.state == "checking" then
				return false
			end
		end

		return true

	end)()

	generate.Text = "GENERATE & CHECK"

	checking = false
end)

--============================================================
-- TAB SWITCHING
--============================================================

exampleTab.MouseButton1Click:Connect(function()

	examplePage.Visible = true
	usernamesPage.Visible = false

	exampleTab.BackgroundColor3 =
		Color3.fromRGB(75,55,180)

	usernamesTab.BackgroundColor3 =
		Color3.fromRGB(32,32,42)

	exampleTab.TextColor3 =
		Color3.new(1,1,1)

	usernamesTab.TextColor3 =
		Color3.fromRGB(180,180,190)
end)

usernamesTab.MouseButton1Click:Connect(function()

	examplePage.Visible = false
	usernamesPage.Visible = true

	usernamesTab.BackgroundColor3 =
		Color3.fromRGB(75,55,180)

	exampleTab.BackgroundColor3 =
		Color3.fromRGB(32,32,42)

	usernamesTab.TextColor3 =
		Color3.new(1,1,1)

	exampleTab.TextColor3 =
		Color3.fromRGB(180,180,190)
end)

--============================================================
-- DRAGGING
--============================================================

local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = main.Position

		input.Changed:Connect(function()

			if input.UserInputState ==
				Enum.UserInputState.End then

				dragging = false
			end

		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		local delta =
			input.Position - dragStart

		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

--============================================================
-- CLOSE / REOPEN
--============================================================

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(45,45)
reopen.Position = UDim2.new(1,-55,0.5,-22)
reopen.BackgroundColor3 = Color3.fromRGB(75,55,180)
reopen.Text = "S"
reopen.TextColor3 = Color3.new(1,1,1)
reopen.TextSize = 18
reopen.Font = Enum.Font.GothamBold
reopen.Visible = false
reopen.Parent = gui

Instance.new("UICorner", reopen).CornerRadius = UDim.new(0,10)

local reopenOutline = Instance.new("UIStroke")
reopenOutline.Color = Color3.fromRGB(100,70,255)
reopenOutline.Thickness = 2
reopenOutline.Parent = reopen

close.MouseButton1Click:Connect(function()
	main.Visible = false
	reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
	main.Visible = true
	reopen.Visible = false
end)

print("Shadow Username Checker loaded.")