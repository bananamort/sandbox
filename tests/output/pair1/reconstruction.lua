-- chunk: = coverage=828/1544 consts=936
-- subst=0
-- note: then never executed
-- note: then never executed
function start(placeId, port, url)



function waitForChild(parent, childName)
 while true do
  local child = parent:findFirstChild(childName)
  if child then
   return child
  end
  parent.ChildAdded:wait()
 end
end





pcall(function() settings().Network.UseInstancePacketCache = true end)
pcall(function() settings().Network.UsePhysicsPacketCache = true end)

pcall(function() settings()['Task Scheduler'].PriorityMethod = Enum.PriorityMethod.AccumulatedError end)



settings().Network.PhysicsSend = Enum.PhysicsSendMethod.TopNErrors
settings().Network.ExperimentalPhysicsEnabled = true
settings().Network.WaitingForCharacterLogRate = 100
pcall(function() settings().Diagnostics:LegacyScriptMode() end)



local assetId = placeId

local scriptContext = game:GetService('ScriptContext')
pcall(function() scriptContext:AddStarterScript(37801172) end)
scriptContext.ScriptsDisabled = true

game:SetPlaceID(assetId, false)
game:GetService('ChangeHistoryService'):SetEnabled(false)


local ns = game:GetService('NetworkServer')

if url~=nil then
 pcall(function() game:GetService('Players'):SetAbuseReportUrl(url .. '/AbuseReport/InGameChatHandler.ashx') end)
 pcall(function() game:GetService('ScriptInformationProvider'):SetAssetUrl(url .. '/Asset/') end)
 pcall(function() game:GetService('ContentProvider'):SetBaseUrl(url .. '/') end)
 pcall(function() game:GetService('Players'):SetChatFilterUrl(url .. '/Game/ChatFilter.ashx') end)

 game:GetService('BadgeService'):SetPlaceId(placeId)

 game:GetService('BadgeService'):SetIsBadgeLegalUrl('')
 game:GetService('InsertService'):SetBaseSetsUrl(url .. '/Game/Tools/InsertAsset.ashx?nsets=10&type=base')
 game:GetService('InsertService'):SetUserSetsUrl(url .. '/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d')
 game:GetService('InsertService'):SetCollectionUrl(url .. '/Game/Tools/InsertAsset.ashx?sid=%d')
 game:GetService('InsertService'):SetAssetUrl(url .. '/Asset/?id=%d')
 game:GetService('InsertService'):SetAssetVersionUrl(url .. '/Asset/?assetversionid=%d')

 pcall(function() loadfile(url .. '/Game/LoadPlaceInfo.ashx?PlaceId=' .. placeId)() end)






end


settings().Diagnostics.LuaRamLimit = 0





game:GetService('Players').PlayerAdded:connect(function(player)
 print('Player ' .. player.userId .. ' added')
end)

game:GetService('Players').PlayerRemoving:connect(function(player)
 print('Player ' .. player.userId .. ' leaving')
end)

if placeId~=nil and url~=nil then

 wait()


 game:Load(url .. '/asset/?id=' .. placeId)
end


ns:Start(port)


scriptContext:SetTimeout(10)
scriptContext.ScriptsDisabled = false








game:GetService('RunService'):Run()


end

start(0, 53640, 'http://www.gametest1.robloxlabs.com')
-- chunk: =CoreGui.RobloxGui.CoreScripts/DeveloperConsole coverage=180/1608 consts=56
-- subst=0
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed

local useNewConsole = false
pcall(function()
 useNewConsole = settings():GetFFlag('NewInGameDevConsole')
end)

if useNewConsole then
 local DeveloperConsoleModule;
 local function RequireDeveloperConsoleModule()
  if not DeveloperConsoleModule then
   DeveloperConsoleModule = require(game:GetService('CoreGui'):WaitForChild('RobloxGui').Modules.DeveloperConsoleModule)
  end
 end

 local screenGui = script.Parent:FindFirstChild('ControlFrame') or script.Parent

 local ToggleConsole = Instance.new('BindableFunction')
 ToggleConsole.Name = 'ToggleDevConsole'
 ToggleConsole.Parent = screenGui

 local debounce = false

 local developerConsole;
 function ToggleConsole.OnInvoke(duplicate)
  if debounce then
   return
  end
  debounce = true
  RequireDeveloperConsoleModule()
  if not developerConsole or duplicate == true then
   local permissions = DeveloperConsoleModule.GetPermissions()
   local messagesAndStats = DeveloperConsoleModule.GetMessagesAndStats(permissions)
   developerConsole = DeveloperConsoleModule.new(screenGui, permissions, messagesAndStats)
   developerConsole:SetVisible(true)
  else
   developerConsole:SetVisible(not developerConsole.Visible)
  end
  debounce = false
 end
else














local Create = assert(LoadLibrary('RbxUtility')).Create


local gui
if script.Parent:FindFirstChild('ControlFrame') then
 gui = script.Parent:FindFirstChild('ControlFrame')
else
 gui = script.Parent
end



local Dev_Container = Create('Frame')({
 Name = 'DevConsoleContainer',
 Parent = gui,
 BackgroundColor3 = Color3.new(0,0,0),
 BackgroundTransparency = 0.90000000000000002,
 Position = UDim2.new(0, 100, 0, 10),
 Size = UDim2.new(0.5, 20, 0.5, 20),
 Visible = false,
 BackgroundTransparency = 0.90000000000000002
})

local ToggleConsole = Create('BindableFunction')({
 Name = 'ToggleDevConsole',
 Parent = gui
})


local devConsoleInitialized = false
function initializeDeveloperConsole()
 if devConsoleInitialized then
  return
 end
 devConsoleInitialized = true


 local LOCAL_CONSOLE = 1
 local SERVER_CONSOLE = 2
 local SERVER_STATS = 3

 local MAX_LIST_SIZE = 1000

 local minimumSize = Vector2.new(350, 180)
 local currentConsole = LOCAL_CONSOLE

 local localMessageList = {}
 local serverMessageList = {}

 local localOffset = 0
 local serverOffset = 0
 local serverStatsOffset = 0

 local errorToggleOn = true
 local warningToggleOn = true
 local infoToggleOn = true
 local outputToggleOn = true
 local wordWrapToggleOn = false

 local textHolderSize = 0

 local frameNumber = 0



 local Dev_Body = Create('Frame')({
  Name = 'Body',
  Parent = Dev_Container,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.5,
  Position = UDim2.new(0, 0, 0, 21),
  Size = UDim2.new(1, 0, 1, -25)
 })

 local Dev_OptionsHolder = Create('Frame')({
  Name = 'OptionsHolder',
  Parent = Dev_Body,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 318, 0, 0),
  Size = UDim2.new(1, -355, 0, 24),
  ClipsDescendants = true
 })

 local Dev_OptionsBar = Create('Frame')({
  Name = 'OptionsBar',
  Parent = Dev_OptionsHolder,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 1,
  Position = UDim2.new(0,   -250, 0, 4),
  Size = UDim2.new(0, 234, 0, 18)
 })

 local Dev_ErrorToggleFilter = Create('TextButton')({
  Name = 'ErrorToggleButton',
  Parent = Dev_OptionsBar,
  BackgroundColor3 = Color3.new(0,0,0),
  BorderColor3 = Color3.new(1,   0, 0),
  Position = UDim2.new(0, 115, 0, 0),
  Size = UDim2.new(0, 18, 0, 18),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  Text = '',
  TextColor3 = Color3.new(1,   0, 0)
 })

 Create('Frame')({
  Name = 'CheckFrame',
  Parent = Dev_ErrorToggleFilter,
  BackgroundColor3 = Color3.new(1,  0,0),
  BorderColor3 = Color3.new(1,   0, 0),
  Position = UDim2.new(0, 4, 0, 4),
  Size = UDim2.new(0, 10, 0, 10)
 })

 local Dev_InfoToggleFilter = Create('TextButton')({
  Name = 'InfoToggleButton',
  Parent = Dev_OptionsBar,
  BackgroundColor3 = Color3.new(0,0,0),
  BorderColor3 = Color3.new(0.40000000000000002,0.5,1),
  Position = UDim2.new(0, 65, 0, 0),
  Size = UDim2.new(0, 18, 0, 18),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  Text = '',
  TextColor3 = Color3.new(0.40000000000000002,0.5,1)
 })

 Create('Frame')({
  Name = 'CheckFrame',
  Parent = Dev_InfoToggleFilter,
  BackgroundColor3 = Color3.new(0.40000000000000002,0.5,1),
  BorderColor3 = Color3.new(0.40000000000000002,0.5,1),
  Position = UDim2.new(0, 4, 0, 4),
  Size = UDim2.new(0, 10, 0, 10)
 })

 local Dev_OutputToggleFilter = Create('TextButton')({
  Name = 'OutputToggleButton',
  Parent = Dev_OptionsBar,
  BackgroundColor3 = Color3.new(0,0,0),
  BorderColor3 = Color3.new(1,   1,   1),
  Position = UDim2.new(0, 40, 0, 0),
  Size = UDim2.new(0, 18, 0, 18),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  Text = '',
  TextColor3 = Color3.new(1,   1,   1)
 })

 Create('Frame')({
  Name = 'CheckFrame',
  Parent = Dev_OutputToggleFilter,
  BackgroundColor3 = Color3.new(1,   1,   1),
  BorderColor3 = Color3.new(1,   1,   1),
  Position = UDim2.new(0, 4, 0, 4),
  Size = UDim2.new(0, 10, 0, 10)
 })

 local Dev_WarningToggleFilter = Create('TextButton')({
  Name = 'WarningToggleButton',
  Parent = Dev_OptionsBar,
  BackgroundColor3 = Color3.new(0,0,0),
  BorderColor3 = Color3.new(1,   0.59999999999999998,0.40000000000000002),
  Position = UDim2.new(0, 90, 0, 0),
  Size = UDim2.new(0, 18, 0, 18),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  Text = '',
  TextColor3 = Color3.new(1,   0.59999999999999998,0.40000000000000002)
 })

 Create('Frame')({
  Name = 'CheckFrame',
  Parent = Dev_WarningToggleFilter,
  BackgroundColor3 = Color3.new(1,   0.59999999999999998,0.40000000000000002),
  BorderColor3 = Color3.new(1,   0.59999999999999998,0.40000000000000002),
  Position = UDim2.new(0, 4, 0, 4),
  Size = UDim2.new(0, 10, 0, 10)
 })

 local Dev_WordWrapToggle = Create('TextButton')({
  Name = 'WordWrapToggleButton',
  Parent = Dev_OptionsBar,
  BackgroundColor3 = Color3.new(0,0,0),
  BorderColor3 = Color3.new(0.80000000000000004,0.80000000000000004,0.80000000000000004),
  Position = UDim2.new(0, 215, 0, 0),
  Size = UDim2.new(0, 18, 0, 18),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  Text = '',
  TextColor3 = Color3.new(0.80000000000000004,0.80000000000000004,0.80000000000000004)
 })

 Create('Frame')({
  Name = 'CheckFrame',
  Parent = Dev_WordWrapToggle,
  BackgroundColor3 = Color3.new(0.80000000000000004,0.80000000000000004,0.80000000000000004),
  BorderColor3 = Color3.new(0.80000000000000004,0.80000000000000004,0.80000000000000004),
  Position = UDim2.new(0, 4, 0, 4),
  Size = UDim2.new(0, 10, 0, 10),
  Visible = false
 })

 Create('TextLabel')({
  Name = 'Filter',
  Parent = Dev_OptionsBar,
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 0, 0, 0),
  Size = UDim2.new(0, 40, 0, 18),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  Text = 'Filter',
  TextColor3 = Color3.new(1, 1, 1)
 })

 Create('TextLabel')({
  Name = 'WordWrap',
  Parent = Dev_OptionsBar,
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 150, 0, 0),
  Size = UDim2.new(0, 50, 0, 18),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  Text = 'Word Wrap',
  TextColor3 = Color3.new(1, 1, 1)
 })

 local Dev_ScrollBar = Create('Frame')({
  Name = 'ScrollBar',
  Parent = Dev_Body,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.90000000000000002,
  Position = UDim2.new(1, -20, 0, 26),
  Size = UDim2.new(0, 20, 1, -50),
  Visible = false,
  BackgroundTransparency = 0.90000000000000002
 })

 local Dev_ScrollArea = Create('Frame')({
  Name = 'ScrollArea',
  Parent = Dev_ScrollBar,
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 0, 0, 23),
  Size = UDim2.new(1, 0, 1, -46),
  BackgroundTransparency = 1
 })

 local Dev_Handle = Create('ImageButton')({
  Name = 'Handle',
  Parent = Dev_ScrollArea,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.5,
  Position = UDim2.new(0, 0, 0.20000000000000001,0),
  Size = UDim2.new(0, 20, 0, 40),
  BackgroundTransparency = 0.5
 })

 Create('ImageLabel')({
  Name = 'ImageLabel',
  Parent = Dev_Handle,
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 0, 0.5, -8),
  Rotation = 180,
  Size = UDim2.new(1, 0, 0, 16),
  Image = 'http://www.roblox.com/Asset?id=151205881'
 })

 local Dev_DownButton = Create('ImageButton')({
  Name = 'Down',
  Parent = Dev_ScrollBar,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.5,
  Position = UDim2.new(0, 0, 1, -20),
  Size = UDim2.new(0, 20, 0, 20),
  BackgroundTransparency = 0.5
 })

 Create('ImageLabel')({
  Name = 'ImageLabel',
  Parent = Dev_DownButton,
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 3, 0, 3),
  Size = UDim2.new(0, 14, 0, 14),
  Rotation = 180,
  Image = 'http://www.roblox.com/Asset?id=151205813'
 })

 local Dev_UpButton = Create('ImageButton')({
  Name = 'Up',
  Parent = Dev_ScrollBar,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.5,
  Position = UDim2.new(0, 0, 0, 0),
  Size = UDim2.new(0, 20, 0, 20)
 })

 Create('ImageLabel')({
  Name = 'ImageLabel',
  Parent = Dev_UpButton,
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 3, 0, 3),
  Size = UDim2.new(0, 14, 0, 14),
  Image = 'http://www.roblox.com/Asset?id=151205813'
 })

 local flagExists, flagValue = pcall(function () return settings():GetFFlag('ConsoleCodeExecutionEnabled') end)
 local codeExecutionEnabled = flagExists and flagValue
 local creatorFlagExists, creatorFlagValue = pcall(function () return settings():GetFFlag('UseCanManageApiToDetermineConsoleAccess') end)
 local creatorFlagEnabled = creatorFlagExists and creatorFlagValue
 local isCreator = creatorFlagEnabled or game:GetService('Players').LocalPlayer.userId == game.CreatorId
 local function shouldShowCommandBar()
  return codeExecutionEnabled and isCreator
 end
 local function getCommandBarOffset()
  return shouldShowCommandBar() and currentConsole == SERVER_CONSOLE and -22 or 0
 end

 local Dev_TextBox = Create('Frame')({
  Name = 'TextBox',
  Parent = Dev_Body,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.59999999999999998,
  Position = UDim2.new(0, 2, 0, 26),
  Size = UDim2.new(1, -4, 1, -28),
  ClipsDescendants = true
 })

 local Dev_TextHolder = Create('Frame')({
  Name = 'TextHolder',
  Parent = Dev_TextBox,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0,
  Position = UDim2.new(0, 0, 0, 0),
  Size = UDim2.new(1, 0, 1, 0)
 })

 local Dev_OptionsButton = Create('ImageButton')({
  Name = 'OptionsButton',
  Parent = Dev_Body,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 298, 0, 2),
  Size = UDim2.new(0, 20, 0, 20)
 })

 Create('ImageLabel')({
  Name = 'ImageLabel',
  Parent = Dev_OptionsButton,
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 0, 0, 0),
  Size = UDim2.new(1, 0, 1, 0),
  Rotation = 0,
  Image = 'http://www.roblox.com/Asset?id=152093917'
 })

 local Dev_CommandBar = Create('Frame')({
  Name = 'CommandBar',
  Parent = Dev_Container,
  BackgroundTransparency = 0,
  BackgroundColor3 = Color3.new(0, 0, 0),
  BorderSizePixel = 0,
  Size = UDim2.new(1, -25, 0, 24),
  Position = UDim2.new(0, 2, 1, -28),
  Visible = false,
  ZIndex = 2,
  BorderSizePixel = 0
 })

 local Dev_CommandBarTextBox = Create('TextBox')({
  Name = 'CommandBarTextBox',
  Parent = Dev_CommandBar,
  BackgroundTransparency = 1,
  MultiLine = false,
  ZIndex = 2,
  Position = UDim2.new(0, 25, 0, 2),
  Size = UDim2.new(1, -30, 0, 20),
  Font = Enum.Font.Legacy,
  FontSize = Enum.FontSize.Size10,
  TextColor3 = Color3.new(1, 1, 1),
  TextXAlignment = Enum.TextXAlignment.Left,
  TextYAlignment = Enum.TextYAlignment.Center,
  Text = 'Code goes here'
 })

 Create('TextLabel')({
  Name = 'PromptLabel',
  Parent = Dev_CommandBar,
  BackgroundTransparency = 1,
  Size = UDim2.new(0, 20, 1, 0),
  Position = UDim2.new(0, 5, 0, 0),
  Font = Enum.Font.Legacy,
  FontSize = Enum.FontSize.Size10,
  TextColor3 = Color3.new(1, 1, 1),
  TextXAlignment = Enum.TextXAlignment.Center,
  TextYAlignment = Enum.TextYAlignment.Center,
  ZIndex = 2,
  Text = '>'
 })

 Dev_CommandBarTextBox.FocusLost:connect(function(enterPressed)
  if enterPressed then
   local code = Dev_CommandBarTextBox.Text
   game:GetService('LogService'):ExecuteScript(code)
   Dev_CommandBarTextBox.Text = ''


   serverOffset = 0
   Dev_CommandBarTextBox:CaptureFocus()
  end
 end)

 local Dev_ResizeButton = Create('ImageButton')({
  Name = 'ResizeButton',
  Parent = Dev_Body,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.5,
  Position = UDim2.new(1, -20, 1, -20),
  Size = UDim2.new(0, 20, 0, 20)
 })

 Create('ImageLabel')({
  Name = 'ImageLabel',
  Parent = Dev_ResizeButton,
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 6, 0, 6),
  Size = UDim2.new(0.80000000000000004,0,0.80000000000000004,0),
  Rotation = 135,
  Image = 'http://www.roblox.com/Asset?id=151205813'
 })

 Create('TextButton')({
  Name = 'LocalConsole',
  Parent = Dev_Body,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.59999999999999998,
  Position = UDim2.new(0, 7, 0, 5),
  Size = UDim2.new(0, 90, 0, 20),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  Text = 'Local Console',
  TextColor3 = Color3.new(1, 1, 1),
  TextYAlignment = Enum.TextYAlignment.Center
 })

 Create('TextButton')({
  Name = 'ServerConsole',
  Parent = Dev_Body,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.80000000000000004,
  Position = UDim2.new(0, 102, 0, 5),
  Size = UDim2.new(0, 90, 0, 17),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  Text = 'Server Console',
  TextColor3 = Color3.new(1, 1, 1),
  TextYAlignment = Enum.TextYAlignment.Center
 })

 Create('TextButton')({
  Name = 'ServerStats',
  Parent = Dev_Body,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.80000000000000004,
  Position = UDim2.new(0, 197, 0, 5),
  Size = UDim2.new(0, 90, 0, 17),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  Text = 'Server Stats',
  TextColor3 = Color3.new(1, 1, 1),
  TextYAlignment = Enum.TextYAlignment.Center
 })

 local Dev_TitleBar = Create('Frame')({
  Name = 'TitleBar',
  Parent = Dev_Container,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.5,
  Position = UDim2.new(0, 0, 0, 0),
  Size = UDim2.new(1, 0, 0, 20)
 })

 local Dev_CloseButton = Create('ImageButton')({
  Name = 'CloseButton',
  Parent = Dev_TitleBar,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.5,
  Position = UDim2.new(1, -20, 0, 0),
  Size = UDim2.new(0, 20, 0, 20)
 })

 Create('ImageLabel')({
  Parent = Dev_CloseButton,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 3, 0, 3),
  Size = UDim2.new(0, 14, 0, 14),
  Image = 'http://www.roblox.com/Asset?id=151205852'
 })

 Create('TextButton')({
  Name = 'TextButton',
  Parent = Dev_TitleBar,
  BackgroundColor3 = Color3.new(0,0,0),
  BackgroundTransparency = 0.5,
  Position = UDim2.new(0, 0, 0, 0),
  Size = UDim2.new(1, -23, 1, 0),
  Text = '',
  Modal = true
 })

 Create('TextLabel')({
  Name = 'TitleText',
  Parent = Dev_TitleBar,
  BackgroundTransparency = 1,
  Position = UDim2.new(0, 0, 0, 0),
  Size = UDim2.new(0, 185, 0, 20),
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size18,
  Text = 'Server Console',
  TextColor3 = Color3.new(1, 1, 1),
  Text = 'Roblox Developer Console',
  TextYAlignment = Enum.TextYAlignment.Top
 })

 local Dev_StatsChartFrame = Create('Frame')({
  Name = 'ChartFrame',
  BackgroundColor3 = Color3.new(0, 0, 0),
  BackgroundTransparency = 0.5,
  BorderColor3 = Color3.new(1,   1,   1),
  Position = UDim2.new(0, 0, 0, 0),
  Size = UDim2.new(0, 250, 0, 100)
 })

 Create('TextLabel')({
  Name = 'TitleText',
  Parent = Dev_StatsChartFrame,
  BackgroundTransparency = 0.5,
  BackgroundColor3 = Color3.new(255,0,0),
  Position = UDim2.new(0, 0, 0, 0),
  Size = UDim2.new(1, 0, 0, 15),
  Text = '',
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  TextColor3 = Color3.new(1, 1, 1),
  TextYAlignment = Enum.TextYAlignment.Top
 })

 Create('TextLabel')({
  Name = 'ChartValue',
  Parent = Dev_StatsChartFrame,
  BackgroundTransparency = 1,
  BackgroundColor3 = Color3.new(0,0,0),
  Position = UDim2.new(0, 5, 0, 39),
  Size = UDim2.new(0, 100, 0, 15),
  Text = '',
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  TextColor3 = Color3.new(1, 1, 1),
  TextYAlignment = Enum.TextYAlignment.Top,
  TextXAlignment = Enum.TextXAlignment.Left
 })

 Create('TextLabel')({
  Name = 'ChartMaxValue',
  Parent = Dev_StatsChartFrame,
  BackgroundTransparency = 1,
  BackgroundColor3 = Color3.new(0,0,0),
  Position = UDim2.new(0, 5, 0, 15),
  Size = UDim2.new(0, 100, 0, 15),
  Text = 'Max: ',
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  TextColor3 = Color3.new(1, 1, 1),
  TextYAlignment = Enum.TextYAlignment.Top,
  TextXAlignment = Enum.TextXAlignment.Left
 })

 Create('TextLabel')({
  Name = 'ChartMinValue',
  Parent = Dev_StatsChartFrame,
  BackgroundTransparency = 1,
  BackgroundColor3 = Color3.new(0,0,0),
  Position = UDim2.new(0, 5, 0, 27),
  Size = UDim2.new(0, 100, 0, 15),
  Text = 'Min: ',
  Font = 'SourceSansBold',
  FontSize = Enum.FontSize.Size14,
  TextColor3 = Color3.new(1, 1, 1),
  TextYAlignment = Enum.TextYAlignment.Top,
  TextXAlignment = Enum.TextXAlignment.Left
 })

 local Dev_StatsChartBar = Create('TextLabel')({
  Name = 'StatsChartBar',
  BackgroundColor3 = Color3.new(0,255,0),
  Position = UDim2.new(0, 0, 0, 52),
  Size = UDim2.new(0, 5, 0, 40),
  Text = ''
 })


 local previousMousePos = nil
 local pPos = nil

 local previousMousePosResize = nil
 local pSize = nil

 local previousMousePosScroll = nil
 local pScrollHandle = nil
 local pOffset = nil

 local scrollUpIsDown = false
 local scrollDownIsDown = false

 function clean()
  previousMousePos = nil
  pPos = nil
  previousMousePosResize = nil
  pSize = nil
  previousMousePosScroll = nil
  pScrollHandle = nil
  pOffset = nil
  scrollUpIsDown = false
  scrollDownIsDown = false
 end


 local numBars = 40
 local numCharts = 0
 local charts = {}
 local statsListenerConnection = nil

 function initStatsListener()
  if (statsListenerConnection == nil) then
   game:GetService('NetworkClient'):GetChildren()[1]:RequestServerStats(true)
   statsListenerConnection = game:GetService('NetworkClient'):GetChildren()[1].StatsReceived:connect(refreshCharts)
  end
 end

 function removeStatsListener()
  if (statsListenerConnection ~= nil) then
   game:GetService('NetworkClient'):GetChildren()[1]:RequestServerStats(false)
   statsListenerConnection:disconnect()
   statsListenerConnection = nil
  end
 end

 function createChart(_frame)
  local chart = {
   frame = _frame,
   values = {},
   bars = {},
   curIndex = 0
  }
  return chart
 end

 function setupCharts(name)
  local newChart = createChart(Dev_StatsChartFrame:Clone())
  newChart.frame.Parent = Dev_TextHolder
  newChart.frame.TitleText.Text = name
  local newPos = 5 + numCharts * 110
  newChart.frame.Position = UDim2.new(0, 5, 0, newPos);
  for i=  1, numBars do
   local bar = Dev_StatsChartBar:Clone()
   bar.Position = UDim2.new(bar.Position.X.Scale, i * (bar.Size.X.Offset + 1), bar.Position.Y.Scale, bar.Position.Y.Offset)
   bar.Parent = newChart.frame
   table.insert(newChart.bars, bar)
  end

  charts[name] = newChart
  numCharts = numCharts + 1
  textHolderSize = newPos + 110
 end

 function clearCharts()
  for i, chart in pairs(charts) do
   chart.frame.Parent = nil
   charts[i] = nil
  end
  numCharts = 0
 end

 function refreshCharts(stats)
  for name, stat in pairs(stats) do
   if (charts[name] == nil) then
    setupCharts(name)
   end

   local chart = charts[name]
   chart.curIndex = chart.curIndex + 1


   if chart.curIndex > numBars + 1 then
    chart.curIndex = numBars + 1
    table.remove(chart.values, 1)
   end

   chart.values[chart.curIndex] = stat

   updateChart(chart)
  end
 end

 function updateChart(chart)
  local maxValue = 0.0001
  local minValue = chart.values[chart.curIndex]

  for i=  chart.curIndex, chart.curIndex-numBars, -1 do
   if i == 0 then break end
   if chart.values[i] > maxValue then maxValue = chart.values[i] end
   if chart.values[i] < minValue then minValue = chart.values[i] end
  end

  chart.frame.ChartValue.Text = 'Current: '..chart.values[chart.curIndex]
  chart.frame.ChartMaxValue.Text = 'Max: '..maxValue
  chart.frame.ChartMinValue.Text = 'Min: '..minValue

  for i=  1,numBars do

   if chart.curIndex - i + 1 < 1 then
    chart.bars[i].BackgroundTransparency = 1
   else
    chart.bars[i].BackgroundTransparency = 0

    chart.bars[i].Size = UDim2.new(chart.bars[i].Size.X.Scale, chart.bars[i].Size.X.Offset, chart.bars[i].Size.Y.Scale,
     Dev_StatsChartBar.Size.Y.Offset * (chart.values[chart.curIndex - i + 1] / maxValue))

    chart.bars[i].Position = UDim2.new(chart.bars[i].Position.X.Scale, chart.bars[i].Position.X.Offset, Dev_StatsChartBar.Position.Y.Scale,
     Dev_StatsChartBar.Position.Y.Offset + (45 - chart.bars[i].Size.Y.Offset))
   end

  end
 end


 function refreshConsolePosition(x, y)
  if not previousMousePos then
   return
  end

  local delta = Vector2.new(x, y) - previousMousePos
  Dev_Container.Position = UDim2.new(0, pPos.X + delta.X, 0, pPos.Y + delta.Y)
 end

 Dev_TitleBar.TextButton.MouseButton1Down:connect(function(x, y)
  previousMousePos = Vector2.new(x, y)
  pPos = Dev_Container.AbsolutePosition
 end)

 Dev_TitleBar.TextButton.MouseButton1Up:connect(function(x, y)
  clean()
 end)


 function refreshConsoleSize(x, y)
  if not previousMousePosResize then
   return
  end

  local delta = Vector2.new(x, y) - previousMousePosResize
  Dev_Container.Size = UDim2.new(0, math.max(pSize.X + delta.X, minimumSize.X), 0, math.max(pSize.Y + delta.Y, minimumSize.Y))
 end
 Dev_Container.Body.ResizeButton.MouseButton1Down:connect(function(x, y)
  previousMousePosResize = Vector2.new(x, y)
  pSize = Dev_Container.AbsoluteSize
 end)

 Dev_Container.Body.ResizeButton.MouseButton1Up:connect(function(x, y)
  clean()
 end)



 Dev_TitleBar.CloseButton.MouseButton1Down:connect(function(x, y)
  Dev_Container.Visible = false
 end)

 Dev_Container.TitleBar.CloseButton.MouseButton1Up:connect(function()
  clean()
  removeStatsListener()
  clearCharts()
 end)

 local optionsHidden = true
 local animating = false

 function startAnimation()
  if animating then return end
  animating = true

  repeat
   if optionsHidden then
    frameNumber = frameNumber - 1
   else
    frameNumber = frameNumber + 1
   end

   local x = frameNumber / 5
   local smoothStep = x * x * (3 - (2 * x))
   Dev_OptionsButton.ImageLabel.Rotation = smoothStep * 5 * 9
   Dev_OptionsBar.Position = UDim2.new(0, (smoothStep * 5 * 50) - 250, 0, 4)

   wait()
   if (frameNumber <= 0 and optionsHidden) or (frameNumber >= 5 and not optionsHidden) then
    animating = false
   end
  until not animating
 end

 Dev_OptionsButton.MouseButton1Down:connect(function(x, y)
  optionsHidden = not optionsHidden
  startAnimation()
 end)



 function changeOffset(value)
  if (currentConsole == LOCAL_CONSOLE) then
   localOffset = localOffset + value
  elseif (currentConsole == SERVER_CONSOLE) then
   serverOffset = serverOffset + value
  elseif (currentConsole == SERVER_STATS) then
   serverStatsOffset = serverStatsOffset + value
  end

  repositionList()
 end


 function refreshTextHolderForReal()
  local childMessages = Dev_TextHolder:GetChildren()

  local messageList = {}

  if (currentConsole == LOCAL_CONSOLE) then
   messageList = localMessageList
  elseif (currentConsole == SERVER_CONSOLE) then
   messageList = serverMessageList
  end

  local posOffset = 0

  for i=  1, #childMessages do
   childMessages[i].Visible = false
  end

  for i=  1, #messageList do
   local message

   local movePosition = false

   if i > #childMessages then
    message = Create('TextLabel')({
     Name = 'Message',
     Parent = Dev_TextHolder,
     BackgroundTransparency = 1,
     TextXAlignment = 'Left',
     Size = UDim2.new(1, 0, 0, 14),
     FontSize = 'Size10',
     ZIndex = 1
    })
    movePosition = true
   else
    message = childMessages[i]
   end

   if (outputToggleOn or messageList[i].Type ~= Enum.MessageType.MessageOutput)and
      (infoToggleOn or messageList[i].Type ~= Enum.MessageType.MessageInfo)and
      (warningToggleOn or messageList[i].Type ~= Enum.MessageType.MessageWarning)and
      (errorToggleOn or messageList[i].Type ~= Enum.MessageType.MessageError) then
    message.TextWrapped = wordWrapToggleOn
    message.Size = UDim2.new(0.97999999999999998,0,0,2000)
    message.Parent = Dev_Container
    message.Text = messageList[i].Time..' -- '..messageList[i].Message

    message.Size = UDim2.new(0.97999999999999998,0,0,message.TextBounds.Y)
    message.Position = UDim2.new(0, 5, 0, posOffset)
    message.Parent = Dev_TextHolder
    posOffset = posOffset + message.TextBounds.Y

    if movePosition then
     if (currentConsole == LOCAL_CONSOLE and localOffset > 0) or (currentConsole == SERVER_CONSOLE and serverOffset > 0) then
      changeOffset(message.TextBounds.Y)
     end
    end

    message.Visible = true

    if messageList[i].Type == Enum.MessageType.MessageError then
     message.TextColor3 = Color3.new(1, 0, 0)
    elseif messageList[i].Type == Enum.MessageType.MessageInfo then
     message.TextColor3 = Color3.new(0.40000000000000002,0.5,1)
    elseif messageList[i].Type == Enum.MessageType.MessageWarning then
     message.TextColor3 = Color3.new(1, 0.59999999999999998,0.40000000000000002)
    else
     message.TextColor3 = Color3.new(1, 1, 1)
    end
   end


  end

  textHolderSize = posOffset

  repositionList()

 end





 local refreshQueued = false
 function refreshTextHolder()
  if refreshQueued or currentConsole == SERVER_STATS then return end
  Delay(0.10000000000000001,function()
   refreshQueued = false
   refreshTextHolderForReal()
  end) refreshQueued = true
 end



 local inside = 0
 function holdingUpButton()
  if scrollUpIsDown then
   return
  end
  scrollUpIsDown = true
  wait(0.59999999999999998)
  inside = inside + 1
  while scrollUpIsDown and inside < 2 do
   wait()
   changeOffset(12)
  end
  inside = inside - 1
 end

 function holdingDownButton()
  if scrollDownIsDown then
   return
  end
  scrollDownIsDown = true
  wait(0.59999999999999998)
  inside = inside + 1
  while scrollDownIsDown and inside < 2 do
   wait()
   changeOffset(-12)
  end
  inside = inside - 1
 end

 Dev_Container.Body.ScrollBar.Up.MouseButton1Click:connect(function()
  changeOffset(10)
 end)

 Dev_Container.Body.ScrollBar.Up.MouseButton1Down:connect(function()
  changeOffset(10)
  holdingUpButton()
 end)

 Dev_Container.Body.ScrollBar.Up.MouseButton1Up:connect(function()
  clean()
 end)

 Dev_Container.Body.ScrollBar.Down.MouseButton1Down:connect(function()
  changeOffset(-10)
  holdingDownButton()
 end)

 Dev_Container.Body.ScrollBar.Down.MouseButton1Up:connect(function()
  clean()
 end)

 function handleScroll(x, y)
  if not previousMousePosScroll then
   return
  end

  local delta = (Vector2.new(x, y) - previousMousePosScroll).Y

  local backRatio = 1 - (Dev_Container.Body.TextBox.AbsoluteSize.Y / Dev_TextHolder.AbsoluteSize.Y)

  local movementSize = Dev_ScrollArea.AbsoluteSize.Y - Dev_ScrollArea.Handle.AbsoluteSize.Y
  local normalDelta = math.max(math.min(delta, movementSize), 0 - movementSize)
  local normalRatio = normalDelta / movementSize

  local textMovementSize = (backRatio * Dev_TextHolder.AbsoluteSize.Y)
  local offsetChange = textMovementSize * normalRatio

  if (currentConsole == LOCAL_CONSOLE) then
   localOffset = pOffset - offsetChange
  elseif (currentConsole == SERVER_CONSOLE) then
   serverOffset = pOffset - offsetChange
  elseif (currentConsole == SERVER_STATS) then
   serverStatsOffset = pOffset - offsetChange
  end
 end

 Dev_ScrollArea.Handle.MouseButton1Down:connect(function(x, y)
  previousMousePosScroll = Vector2.new(x, y)
  pScrollHandle = Dev_ScrollArea.Handle.AbsolutePosition
  if (currentConsole == LOCAL_CONSOLE) then
   pOffset = localOffset
  elseif (currentConsole == SERVER_CONSOLE) then
   pOffset = serverOffset
  elseif (currentConsole == SERVER_STATS) then
   pOffset = serverStatsOffset
  end

 end)

 Dev_ScrollArea.Handle.MouseButton1Up:connect(function(x, y)
  clean()
 end)

 local function existsInsideContainer(container, x, y)
  local pos = container.AbsolutePosition
  local size = container.AbsoluteSize
  if x < pos.X or x > pos.X + size.X or y < pos.y or y > pos.y + size.y then
   return false
  end
  return true
 end




 function repositionList()

  if (currentConsole == LOCAL_CONSOLE) then
   localOffset = math.min(math.max(localOffset, 0), textHolderSize - Dev_Container.Body.TextBox.AbsoluteSize.Y)
   Dev_TextHolder.Size = UDim2.new(1, 0, 0, textHolderSize)
  elseif (currentConsole == SERVER_CONSOLE) then
   serverOffset = math.min(math.max(serverOffset, 0), textHolderSize - Dev_Container.Body.TextBox.AbsoluteSize.Y)
   Dev_TextHolder.Size = UDim2.new(1, 0, 0, textHolderSize)
  elseif (currentConsole == SERVER_STATS) then
   serverStatsOffset = math.min(math.max(serverStatsOffset, 0), textHolderSize - Dev_Container.Body.TextBox.AbsoluteSize.Y)
   Dev_TextHolder.Size = UDim2.new(1, 0, 0, textHolderSize)
  end

  local ratio = Dev_Container.Body.TextBox.AbsoluteSize.Y / Dev_TextHolder.AbsoluteSize.Y

  if ratio >= 1 then
   Dev_Container.Body.ScrollBar.Visible = false
   Dev_Container.Body.TextBox.Size = UDim2.new(1, -4, 1, -28 + getCommandBarOffset())

   if (currentConsole == LOCAL_CONSOLE) then
    Dev_TextHolder.Position = UDim2.new(0, 0, 1, 0 - textHolderSize)
   elseif (currentConsole == SERVER_CONSOLE) then
    Dev_TextHolder.Position = UDim2.new(0, 0, 1, 0 - textHolderSize)
   end


  else
   Dev_Container.Body.ScrollBar.Visible = true
   Dev_Container.Body.TextBox.Size = UDim2.new(1, -25, 1, -28 + getCommandBarOffset())

   local backRatio = 1 - ratio
   local offsetRatio

   if (currentConsole == LOCAL_CONSOLE) then
    offsetRatio = localOffset / Dev_TextHolder.AbsoluteSize.Y
   elseif (currentConsole == SERVER_CONSOLE) then
    offsetRatio = serverOffset / Dev_TextHolder.AbsoluteSize.Y
   elseif (currentConsole == SERVER_STATS) then
    offsetRatio = (serverStatsOffset / Dev_TextHolder.AbsoluteSize.Y)
   end

   local topRatio = math.max(0, backRatio - offsetRatio)
   local scrollHandleSize = math.max((Dev_ScrollArea.AbsoluteSize.Y) * ratio, 21)

   local scrollRatio = scrollHandleSize / Dev_ScrollArea.AbsoluteSize.Y
   local ratioConversion = (1 - scrollRatio) / (1 - ratio)

   local topScrollRatio = topRatio * ratioConversion

   local sPos = math.min((Dev_ScrollArea.AbsoluteSize.Y) * topScrollRatio, Dev_ScrollArea.AbsoluteSize.Y - scrollHandleSize)

   Dev_ScrollArea.Handle.Size = UDim2.new(1, 0, 0, scrollHandleSize)
   Dev_ScrollArea.Handle.Position = UDim2.new(0, 0, 0, sPos)

   if (currentConsole == LOCAL_CONSOLE) then
    Dev_TextHolder.Position = UDim2.new(0, 0, 1, 0 - textHolderSize + localOffset)
   elseif (currentConsole == SERVER_CONSOLE) then
    Dev_TextHolder.Position = UDim2.new(0, 0, 1, 0 - textHolderSize + serverOffset)
   elseif (currentConsole == SERVER_STATS) then
    Dev_TextHolder.Position = UDim2.new(0, 0, 1, 0 - textHolderSize + serverStatsOffset)
   end

  end
 end


 local function numberWithZero(num)
  return (num < 10 and '0' or '')..num
 end

 local str = '%s:%s:%s'

 function ConvertTimeStamp(timeStamp)
  local localTime = timeStamp - os.time() + math.floor(tick())
  local dayTime = localTime % 86400

  local hour = math.floor(dayTime/3600)

  dayTime = dayTime - (hour * 3600)
  local minute = math.floor(dayTime/60)

  dayTime = dayTime - (minute * 60)
  local second = dayTime

  local h = numberWithZero(hour)
  local m = numberWithZero(minute)
  local s = numberWithZero(dayTime)

  return str:format(h,m,s)
 end



 Dev_OptionsBar.ErrorToggleButton.MouseButton1Down:connect(function(x, y)
  errorToggleOn = not errorToggleOn
  Dev_OptionsBar.ErrorToggleButton.CheckFrame.Visible = errorToggleOn
  refreshTextHolder()
 end)

 Dev_OptionsBar.WarningToggleButton.MouseButton1Down:connect(function(x, y)
  warningToggleOn = not warningToggleOn
  Dev_OptionsBar.WarningToggleButton.CheckFrame.Visible = warningToggleOn
  refreshTextHolder()
 end)

 Dev_OptionsBar.InfoToggleButton.MouseButton1Down:connect(function(x, y)
  infoToggleOn = not infoToggleOn
  Dev_OptionsBar.InfoToggleButton.CheckFrame.Visible = infoToggleOn
  refreshTextHolder()
 end)

 Dev_OptionsBar.OutputToggleButton.MouseButton1Down:connect(function(x, y)
  outputToggleOn = not outputToggleOn
  Dev_OptionsBar.OutputToggleButton.CheckFrame.Visible = outputToggleOn
  refreshTextHolder()
 end)

 Dev_OptionsBar.WordWrapToggleButton.MouseButton1Down:connect(function(x, y)
  wordWrapToggleOn = not wordWrapToggleOn
  Dev_OptionsBar.WordWrapToggleButton.CheckFrame.Visible = wordWrapToggleOn
  refreshTextHolder()
 end)


 function AddLocalMessage(str, messageType, timeStamp)
  localMessageList[#localMessageList+1] = {Message = str, Time = ConvertTimeStamp(timeStamp), Type = messageType}
  while #localMessageList > MAX_LIST_SIZE do
   table.remove(localMessageList, 1)
  end

  refreshTextHolder()
 end

 function AddServerMessage(str, messageType, timeStamp)
  serverMessageList[#serverMessageList+1] = {Message = str, Time = ConvertTimeStamp(timeStamp), Type = messageType}
  while #serverMessageList > MAX_LIST_SIZE do
   table.remove(serverMessageList, 1)
  end

  refreshTextHolder()
 end




 Dev_Container.Body.LocalConsole.MouseButton1Click:connect(function(x, y)
  if (currentConsole ~= LOCAL_CONSOLE) then

   if (currentConsole == SERVER_STATS) then
    removeStatsListener()
    clearCharts()
   end

   Dev_Container.CommandBar.Visible = false

   currentConsole = LOCAL_CONSOLE
   local localConsole = Dev_Container.Body.LocalConsole
   local serverConsole = Dev_Container.Body.ServerConsole
   local serverStats = Dev_Container.Body.ServerStats

   localConsole.Size = UDim2.new(0, 90, 0, 20)
   serverConsole.Size = UDim2.new(0, 90, 0, 17)
   serverStats.Size = UDim2.new(0, 90, 0, 17)
   localConsole.BackgroundTransparency = 0.59999999999999998
   serverConsole.BackgroundTransparency = 0.80000000000000004
   serverStats.BackgroundTransparency = 0.80000000000000004

   if game:GetService('Players') and game:GetService('Players')['LocalPlayer'] then
    local mouse = game:GetService('Players').LocalPlayer:GetMouse()
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    refreshConsolePosition(mouse.X, mouse.Y)
    refreshConsoleSize(mouse.X, mouse.Y)
    handleScroll(mouse.X, mouse.Y)
   end

   refreshTextHolder()
  end
 end)

 Dev_Container.Body.LocalConsole.MouseButton1Up:connect(function()
  clean()
 end)

 local serverHistoryRequested = false;

 Dev_Container.Body.ServerConsole.MouseButton1Click:connect(function(x, y)

  if not serverHistoryRequested then
   serverHistoryRequested = true
   game:GetService('LogService'):RequestServerOutput()
  end

  if (currentConsole ~= SERVER_CONSOLE) then

   Dev_Container.CommandBar.Visible = shouldShowCommandBar()

   if (currentConsole == SERVER_STATS) then
    removeStatsListener()
    clearCharts()
   end

   currentConsole = SERVER_CONSOLE
   local localConsole = Dev_Container.Body.LocalConsole
   local serverConsole = Dev_Container.Body.ServerConsole
   local serverStats = Dev_Container.Body.ServerStats

   serverConsole.Size = UDim2.new(0, 90, 0, 20)
   localConsole.Size = UDim2.new(0, 90, 0, 17)
   serverConsole.BackgroundTransparency = 0.59999999999999998
   localConsole.BackgroundTransparency = 0.80000000000000004
   serverStats.BackgroundTransparency = 0.80000000000000004

   if game:GetService('Players') and game:GetService('Players')['LocalPlayer'] then
    local mouse = game:GetService('Players').LocalPlayer:GetMouse()
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    refreshConsolePosition(mouse.X, mouse.Y)
    refreshConsoleSize(mouse.X, mouse.Y)
    handleScroll(mouse.X, mouse.Y)
   end

   refreshTextHolder()
  end
 end)


 Dev_Container.Body.ServerConsole.MouseButton1Up:connect(function()
  clean()
 end)

 Dev_Container.Body.ServerStats.MouseButton1Click:connect(function(x, y)
  if (currentConsole ~= SERVER_STATS) then

   Dev_Container.CommandBar.Visible = false

   currentConsole = SERVER_STATS
   local localConsole = Dev_Container.Body.LocalConsole
   local serverConsole = Dev_Container.Body.ServerConsole
   local serverStats = Dev_Container.Body.ServerStats

   serverStats.Size = UDim2.new(0, 90, 0, 20)
   serverConsole.Size = UDim2.new(0, 90, 0, 17)
   localConsole.Size = UDim2.new(0, 90, 0, 17)
   serverStats.BackgroundTransparency = 0.59999999999999998
   serverConsole.BackgroundTransparency = 0.80000000000000004
   localConsole.BackgroundTransparency = 0.80000000000000004


   local messages = Dev_TextHolder:GetChildren()
   for i=  1, #messages do
    messages[i].Visible = false
   end

   pcall(function() initStatsListener() end)

  end
 end)

 Dev_Container.Body.ServerStats.MouseButton1Up:connect(function()
  clean()
 end)

 if game:GetService('Players') and game:GetService('Players')['LocalPlayer'] then
  local LocalMouse = game:GetService('Players').LocalPlayer:GetMouse()
  LocalMouse.Move:connect(function()
   if not Dev_Container.Visible then
    return
   end
   local mouse = game:GetService('Players').LocalPlayer:GetMouse()
   local mousePos = Vector2.new(mouse.X, mouse.Y)
   refreshConsolePosition(mouse.X, mouse.Y)
   refreshConsoleSize(mouse.X, mouse.Y)
   handleScroll(mouse.X, mouse.Y)

   refreshTextHolder()
   repositionList()
  end)

  LocalMouse.Button1Up:connect(function()
   clean()
  end)

  LocalMouse.WheelForward:connect(function()
   if not Dev_Container.Visible then
    return
   end
   if existsInsideContainer(Dev_Container, LocalMouse.X, LocalMouse.Y) then
    changeOffset(10)
   end
  end)

  LocalMouse.WheelBackward:connect(function()
   if not Dev_Container.Visible then
    return
   end
   if existsInsideContainer(Dev_Container, LocalMouse.X, LocalMouse.Y) then
    changeOffset(-10)
   end
  end)

 end

 Dev_ScrollArea.Handle.MouseButton1Down:connect(function()
  repositionList()
 end)




 local history = game:GetService('LogService'):GetLogHistory()

 for i=  1, #history do
  AddLocalMessage(history[i].message, history[i].messageType, history[i].timestamp)
 end

 game:GetService('LogService').MessageOut:connect(function(message, messageType)
  AddLocalMessage(message, messageType, os.time())
 end)

 game:GetService('LogService').ServerMessageOut:connect(AddServerMessage)

end

local currentlyToggling = false
function ToggleConsole.OnInvoke()
 if currentlyToggling then
  return
 end

 currentlyToggling = true
 initializeDeveloperConsole()
 Dev_Container.Visible = not Dev_Container.Visible
 currentlyToggling = false

 if not Dev_Container.Visible then
  removeStatsListener()
  clearCharts()
 end

end










end
-- chunk: =CoreGui.RobloxGui.CoreScripts/GamepadMenu coverage=456/1728 consts=238
-- subst=0
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed








local GuiService = game:GetService('GuiService')
local CoreGuiService = game:GetService('CoreGui')
local InputService = game:GetService('UserInputService')
local ContextActionService = game:GetService('ContextActionService')
local HttpService = game:GetService('HttpService')
local StarterGui = game:GetService('StarterGui')
local GuiRoot = CoreGuiService:WaitForChild('RobloxGui')



local tenFootInterface = require(GuiRoot.Modules.TenFootInterface)
local utility = require(GuiRoot.Modules.Settings.Utility)
local recordPage = require(GuiRoot.Modules.Settings.Pages.Record)


local gamepadSettingsFrame = nil
local isVisible = false
local smallScreen = utility:IsSmallTouchScreen()
local isTenFootInterface = tenFootInterface:IsEnabled()
local radialButtons = {}
local lastInputChangedCon = nil

local function getButtonForCoreGuiType(coreGuiType)
 if coreGuiType == Enum.CoreGuiType.All then
  return radialButtons
 else
  for button, table in pairs(radialButtons) do
   if table['CoreGuiType'] == coreGuiType then
    return button
   end
  end
 end

 return nil
end

local function getImagesForSlot(slot)
 if slot == 1 then  return 'rbxasset://textures/ui/Settings/Radial/Top.png', 'rbxasset://textures/ui/Settings/Radial/TopSelected.png',
         'rbxasset://textures/ui/Settings/Radial/Menu.png',
         UDim2.new(0.5,-26,0,18), UDim2.new(0,52,0,41),
         UDim2.new(0,150,0,100), UDim2.new(0.5,-75,0,0)
 elseif slot == 2 then return 'rbxasset://textures/ui/Settings/Radial/TopRight.png', 'rbxasset://textures/ui/Settings/Radial/TopRightSelected.png',
         'rbxasset://textures/ui/Settings/Radial/PlayerList.png',
         UDim2.new(1,-90,0,90), UDim2.new(0,52,0,52),
         UDim2.new(0,108,0,150), UDim2.new(1,-110,0,50)
 elseif slot == 3 then return 'rbxasset://textures/ui/Settings/Radial/BottomRight.png', 'rbxasset://textures/ui/Settings/Radial/BottomRightSelected.png',
         'rbxasset://textures/ui/Settings/Radial/Alert.png',
         UDim2.new(1,-85,1,-150), UDim2.new(0,42,0,58),
         UDim2.new(0,120,0,150), UDim2.new(1,-120,1,-200)
 elseif slot == 4 then  return 'rbxasset://textures/ui/Settings/Radial/Bottom.png', 'rbxasset://textures/ui/Settings/Radial/BottomSelected.png',
         'rbxasset://textures/ui/Settings/Radial/Leave.png',
         UDim2.new(0.5,-20,1,-62), UDim2.new(0,55,0,46),
         UDim2.new(0,150,0,100), UDim2.new(0.5,-75,1,-100)
 elseif slot == 5 then return 'rbxasset://textures/ui/Settings/Radial/BottomLeft.png', 'rbxasset://textures/ui/Settings/Radial/BottomLeftSelected.png',
         'rbxasset://textures/ui/Settings/Radial/Backpack.png',
         UDim2.new(0,40,1,-150), UDim2.new(0,44,0,56),
         UDim2.new(0,110,0,150), UDim2.new(0,0,0,205)
 elseif slot == 6 then return 'rbxasset://textures/ui/Settings/Radial/TopLeft.png', 'rbxasset://textures/ui/Settings/Radial/TopLeftSelected.png',
         'rbxasset://textures/ui/Settings/Radial/Chat.png',
         UDim2.new(0,35,0,100), UDim2.new(0,56,0,53),
         UDim2.new(0,110,0,150), UDim2.new(0,0,0,50)
 end

 return '', '', UDim2.new(0,0,0,0), UDim2.new(0,0,0,0)
end

local function setSelectedRadialButton(selectedObject)
 for button, buttonTable in pairs(radialButtons) do
  local isVisible = (button == selectedObject)
  button:FindFirstChild('Selected').Visible = isVisible
  button:FindFirstChild('RadialLabel').Visible = isVisible
 end
end

local function activateSelectedRadialButton()
 for button, buttonTable in pairs(radialButtons) do
  if button:FindFirstChild('Selected').Visible then
   buttonTable['Function']()
   return true
  end
 end

 return false
end

local function setButtonEnabled(button, enabled)
 if radialButtons[button]['Disabled'] == not enabled then return end

 if button:FindFirstChild('Selected').Visible == true then
  setSelectedRadialButton(nil)
 end

 if enabled then
  button.Image = string.gsub(button.Image, 'rbxasset://textures/ui/Settings/Radial/Empty', 'rbxasset://textures/ui/Settings/Radial/')
  button.ImageTransparency = 0
  button.RadialIcon.ImageTransparency = 0
 else
  button.Image = string.gsub(button.Image, 'rbxasset://textures/ui/Settings/Radial/', 'rbxasset://textures/ui/Settings/Radial/Empty')
  button.ImageTransparency = 0
  button.RadialIcon.ImageTransparency = 1
 end

 radialButtons[button]['Disabled'] = not enabled
end

local emptySelectedImageObject = utility:Create('ImageLabel')(
{
 BackgroundTransparency = 1,
 Size = UDim2.new(1,0,1,0),
 Image = ''
});

local function createRadialButton(name, text, slot, disabled, coreGuiType, activateFunc)
 local slotImage, selectedSlotImage, slotIcon,
   slotIconPosition, slotIconSize, mouseFrameSize, mouseFramePos = getImagesForSlot(slot)

 local radialButton = utility:Create('ImageButton')(
 {
  Name = name,
  Position = UDim2.new(0,0,0,0),
  Size = UDim2.new(1,0,1,0),
  BackgroundTransparency = 1,
  Image = slotImage,
  ZIndex = 2,
  SelectionImageObject = emptySelectedImageObject,
  Parent = gamepadSettingsFrame
 });
 if disabled then
  radialButton.Image = string.gsub(radialButton.Image, 'rbxasset://textures/ui/Settings/Radial/', 'rbxasset://textures/ui/Settings/Radial/Empty')
 end

 local selectedRadial = utility:Create('ImageLabel')(
 {
  Name = 'Selected',
  Position = UDim2.new(0,0,0,0),
  Size = UDim2.new(1,0,1,0),
  BackgroundTransparency = 1,
  Image = selectedSlotImage,
  ZIndex = 2,
  Visible = false,
  Parent = radialButton
 });

 local radialIcon = utility:Create('ImageLabel')(
 {
  Name = 'RadialIcon',
  Position = slotIconPosition,
  Size = slotIconSize,
  BackgroundTransparency = 1,
  Image = slotIcon,
  ZIndex = 3,
  ImageTransparency = disabled and 1 or 0,
  Parent = radialButton
 });

 local nameLabel = utility:Create('TextLabel')(
 {

  Size = UDim2.new(0,220,0,50),
  Position = UDim2.new(0.5, -110, 0.5, -25),
  BackgroundTransparency = 1,
  Text = text,
  Font = Enum.Font.SourceSansBold,
  FontSize = Enum.FontSize.Size14,
  TextColor3 = Color3.new(1,1,1),
  Name = 'RadialLabel',
  Visible = false,
  ZIndex = 2,
  Parent = radialButton
 });
 if not smallScreen then
  nameLabel.FontSize = Enum.FontSize.Size36
  nameLabel.Size = UDim2.new(nameLabel.Size.X.Scale, nameLabel.Size.X.Offset, nameLabel.Size.Y.Scale, nameLabel.Size.Y.Offset + 4)
 end
 local nameBackgroundImage = utility:Create('ImageLabel')(
 {
  Name = text .. 'BackgroundImage',
  Size = UDim2.new(1,0,1,0),
  Position = UDim2.new(0,0,0,2),
  BackgroundTransparency = 1,
  Image = 'rbxasset://textures/ui/Settings/Radial/RadialLabel@2x.png',
  ScaleType = Enum.ScaleType.Slice,
  SliceCenter = Rect.new(24,4,130,42),
  ZIndex = 2,
  Parent = nameLabel
 });

 local mouseFrame = utility:Create('ImageButton')(
 {
  Name = 'MouseFrame',
  Position = mouseFramePos,
  Size = mouseFrameSize,
  ZIndex = 3,
  BackgroundTransparency = 1,
  SelectionImageObject = emptySelectedImageObject,
  Parent = radialButton
 });

 mouseFrame.MouseEnter:connect(function()
  if not radialButtons[radialButton]['Disabled'] then
   setSelectedRadialButton(radialButton)
  end
 end)
 mouseFrame.MouseLeave:connect(function()
  setSelectedRadialButton(nil)
 end)

 mouseFrame.MouseButton1Click:connect(function()
  if selectedRadial.Visible then
   activateFunc()
  end
 end)

 radialButtons[radialButton] = {['Function'] = activateFunc,[ 'Disabled'] = disabled,[ 'CoreGuiType'] = coreGuiType}

 return radialButton
end

local function createGamepadMenuGui()
 gamepadSettingsFrame = utility:Create('Frame')(
 {
  Name = 'GamepadSettingsFrame',
  Position = UDim2.new(0.5,-51,0.5,-51),
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  Size = UDim2.new(0,102,0,102),
  Visible = false,
  Parent = GuiRoot
 });



 local settingsFunc = function()
  toggleCoreGuiRadial(true)
  local MenuModule = require(GuiRoot.Modules.Settings.SettingsHub)
  MenuModule:SetVisibility(true, nil, nil, true)
 end
 local settingsRadial = createRadialButton('Settings', 'Settings', 1, false, nil, settingsFunc)
 settingsRadial.Parent = gamepadSettingsFrame



 local playerListFunc = function()
  toggleCoreGuiRadial(true)
  local PlayerListModule = require(GuiRoot.Modules.PlayerlistModule)
  if not PlayerListModule:IsOpen() then
   PlayerListModule:ToggleVisibility()
  end
 end
 local playerListRadial = createRadialButton('PlayerList', 'Player List', 2, not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList), Enum.CoreGuiType.PlayerList, playerListFunc)
 playerListRadial.Parent = gamepadSettingsFrame



 local gamepadNotifications = Instance.new('BindableEvent')
 gamepadNotifications.Name = 'GamepadNotifications'
 gamepadNotifications.Parent = script
 local notificationsFunc = function()
  toggleCoreGuiRadial()
  gamepadNotifications:Fire(true)
 end
 local notificationsRadial = createRadialButton('Notifications', 'Notifications', 3, false, nil, notificationsFunc)
 if isTenFootInterface then
  setButtonEnabled(notificationsRadial, false)
 end
 notificationsRadial.Parent = gamepadSettingsFrame



 local leaveGameFunc = function()
  toggleCoreGuiRadial(true)
  local MenuModule = require(GuiRoot.Modules.Settings.SettingsHub)
  MenuModule:SetVisibility(true, false, require(GuiRoot.Modules.Settings.Pages.LeaveGame), true)
 end
 local leaveGameRadial = createRadialButton('LeaveGame', 'Leave Game', 4, false, nil, leaveGameFunc)
 leaveGameRadial.Parent = gamepadSettingsFrame



 local backpackFunc = function()
  toggleCoreGuiRadial(true)
  local BackpackModule = require(GuiRoot.Modules.BackpackScript)
  BackpackModule:OpenClose()
 end
 local backpackRadial = createRadialButton('Backpack', 'Backpack', 5, not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack), Enum.CoreGuiType.Backpack, backpackFunc)
 backpackRadial.Parent = gamepadSettingsFrame



 local chatFunc = function()
  toggleCoreGuiRadial()
  local ChatModule = require(GuiRoot.Modules.Chat)
  ChatModule:ToggleVisibility()
 end
 local chatRadial = createRadialButton('Chat', 'Chat', 6, not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat), Enum.CoreGuiType.Chat, chatFunc)
 if isTenFootInterface then
  setButtonEnabled(chatRadial, false)
 end
 chatRadial.Parent = gamepadSettingsFrame




 local closeHintImage = utility:Create('ImageLabel')(
 {
  Name = 'CloseHint',
  Position = UDim2.new(1,10,1,10),
  Size = UDim2.new(0,60,0,60),
  BackgroundTransparency = 1,
  Image = 'rbxasset://textures/ui/Settings/Help/BButtonDark.png',
  Parent = gamepadSettingsFrame
 })
 if isTenFootInterface then
  closeHintImage.Image = 'rbxasset://textures/ui/Settings/Help/BButtonDark@2x.png'
  closeHintImage.Size =  UDim2.new(0,90,0,90)
 end

 local closeHintText = utility:Create('TextLabel')(
 {
  Name = 'closeHintText',
  Position = UDim2.new(1,10,0.5,-12),
  Size = UDim2.new(0,43,0,24),
  Font = Enum.Font.SourceSansBold,
  FontSize = Enum.FontSize.Size24,
  BackgroundTransparency = 1,
  Text = 'Back',
  TextColor3 = Color3.new(1,1,1),
  TextXAlignment = Enum.TextXAlignment.Left,
  Parent = closeHintImage
 })
 if isTenFootInterface then
  closeHintText.FontSize = Enum.FontSize.Size36
 end
































 GuiService:AddSelectionParent(HttpService:GenerateGUID(false), gamepadSettingsFrame)

 gamepadSettingsFrame.Changed:connect(function(prop)
  if prop == 'Visible' then
   if not gamepadSettingsFrame.Visible then
    unbindAllRadialActions()
   end
  end
 end)
end

local function isCoreGuiDisabled()
 for _, enumItem in pairs(Enum.CoreGuiType:GetEnumItems()) do
  if StarterGui:GetCoreGuiEnabled(enumItem) then
   return false
  end
 end

 return true
end

local function setupGamepadControls()
 local freezeControllerActionName = 'doNothingAction'
 local radialSelectActionName = 'RadialSelectAction'
 local thumbstick2RadialActionName = 'Thumbstick2RadialAction'
 local radialCancelActionName = 'RadialSelectCancel'
 local radialAcceptActionName = 'RadialSelectAccept'
 local toggleMenuActionName = 'RBXToggleMenuAction'

 local noOpFunc = function() end
 local doGamepadMenuButton = nil

 function unbindAllRadialActions()
  local success = pcall(function() GuiService.CoreGuiNavigationEnabled = true end)
  if not success then
   GuiService.GuiNavigationEnabled = true
  end

  ContextActionService:UnbindCoreAction(radialSelectActionName)
  ContextActionService:UnbindCoreAction(radialCancelActionName)
  ContextActionService:UnbindCoreAction(radialAcceptActionName)
  ContextActionService:UnbindCoreAction(freezeControllerActionName)
  ContextActionService:UnbindCoreAction(thumbstick2RadialActionName)
 end

 local radialButtonLayout = { PlayerList =  {
              Range = { Begin = 36,
                 End = 96
                }
             },
         Notifications = {
              Range = { Begin = 96,
                 End = 156
                }
             },
         LeaveGame =  {
              Range = { Begin = 156,
                 End = 216
                }
             },
         Backpack =   {
              Range = { Begin = 216,
                 End = 276
                }
             },
         Chat =    {
              Range = { Begin = 276,
                 End = 336
                }
             },
         Settings =   {
              Range = { Begin = 336,
                 End = 36
                }
             }
        }


 local function getSelectedObjectFromAngle(angle, depth)
  local closest = nil
  local closestDistance = 30
  for radialKey, buttonLayout in pairs(radialButtonLayout) do
   if radialButtons[gamepadSettingsFrame[radialKey]]['Disabled'] == false then

    if buttonLayout.Range.Begin < buttonLayout.Range.End then
     if angle > buttonLayout.Range.Begin and angle <= buttonLayout.Range.End then
      return gamepadSettingsFrame[radialKey]
     end
    else
     if angle > buttonLayout.Range.Begin or angle <= buttonLayout.Range.End then
      return gamepadSettingsFrame[radialKey]
     end
    end

    local distanceBegin = math.min(math.abs((buttonLayout.Range.Begin + 360) - angle), math.abs(buttonLayout.Range.Begin - angle))
    local distanceEnd = math.min(math.abs((buttonLayout.Range.End + 360) - angle), math.abs(buttonLayout.Range.End - angle))
    local distance = math.min(distanceBegin, distanceEnd)
    if distance < closestDistance then
     closestDistance = distance
     closest = gamepadSettingsFrame[radialKey]
    end
   end
  end
  return closest
 end

 local radialSelect = function(name, state, input)
  local inputVector = Vector2.new(0,0)

  if input.KeyCode == Enum.KeyCode.Thumbstick1 then
   inputVector = Vector2.new(input.Position.x, input.Position.y)
  end

  local selectedObject = nil

  if inputVector.magnitude > 0.80000000000000004 then

   local angle =  math.atan2(inputVector.X, inputVector.Y) * 180 / math.pi
   if angle < 0 then
    angle = angle + 360
   end

   selectedObject = getSelectedObjectFromAngle(angle)

   setSelectedRadialButton(selectedObject)
  end
 end

 local radialSelectAccept = function(name, state, input)
  if gamepadSettingsFrame.Visible and state == Enum.UserInputState.Begin then
   activateSelectedRadialButton()
  end
 end

 local radialSelectCancel = function(name, state, input)
  if gamepadSettingsFrame.Visible and state == Enum.UserInputState.Begin then
   toggleCoreGuiRadial()
  end
 end

 function setVisibility()
  local children = gamepadSettingsFrame:GetChildren()
  for i=  1, #children do
   if children[i]:FindFirstChild('RadialIcon') then
    children[i].RadialIcon.Visible = isVisible
   end
   if children[i]:FindFirstChild('RadialLabel') and not isVisible then
    children[i].RadialLabel.Visible = isVisible
   end
  end
 end

 function setOverrideMouseIconBehavior()
  pcall(function()
   if InputService:GetLastInputType() == Enum.UserInputType.Gamepad1 then
    InputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
   else
    InputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
   end
  end)
 end

 function toggleCoreGuiRadial(goingToSettings)
  isVisible = not gamepadSettingsFrame.Visible

  setVisibility()

  if isVisible then
   setOverrideMouseIconBehavior()
   pcall(function() lastInputChangedCon = InputService.LastInputTypeChanged:connect(setOverrideMouseIconBehavior) end)

   gamepadSettingsFrame.Visible = isVisible

   local settingsChildren = gamepadSettingsFrame:GetChildren()
   for i=  1, #settingsChildren do
    if settingsChildren[i]:IsA('GuiButton') then
     utility:TweenProperty(settingsChildren[i], 'ImageTransparency', 1, 0, 0.10000000000000001,utility:GetEaseOutQuad(),nil)
    end
   end
   gamepadSettingsFrame:TweenSizeAndPosition(UDim2.new(0,408,0,408), UDim2.new(0.5,-204,0.5,-204),
              Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.17999999999999999,true,
    function()
     setVisibility()
   end)
  else
   if lastInputChangedCon ~= nil then
    lastInputChangedCon:disconnect()
    lastInputChangedCon = nil
   end
   pcall(function() InputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None end)

   local settingsChildren = gamepadSettingsFrame:GetChildren()
   for i=  1, #settingsChildren do
    if settingsChildren[i]:IsA('GuiButton') then
     utility:TweenProperty(settingsChildren[i], 'ImageTransparency', 0, 1, 0.10000000000000001,utility:GetEaseOutQuad(),nil)
    end
   end
   gamepadSettingsFrame:TweenSizeAndPosition(UDim2.new(0,102,0,102), UDim2.new(0.5,-51,0.5,-51),
              Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.10000000000000001,true,
    function()
     if not goingToSettings and not isVisible then GuiService:SetMenuIsOpen(false) end
     gamepadSettingsFrame.Visible = isVisible
   end)
  end

  if isVisible then
   setSelectedRadialButton(nil)

   local success = pcall(function() GuiService.CoreGuiNavigationEnabled = false end)
   if not success then
    GuiService.GuiNavigationEnabled = false
   end

   GuiService:SetMenuIsOpen(true)

   ContextActionService:BindCoreAction(freezeControllerActionName, noOpFunc, false, Enum.UserInputType.Gamepad1)
   ContextActionService:BindCoreAction(radialAcceptActionName, radialSelectAccept, false, Enum.KeyCode.ButtonA)
   ContextActionService:BindCoreAction(radialCancelActionName, radialSelectCancel, false, Enum.KeyCode.ButtonB)
   ContextActionService:BindCoreAction(radialSelectActionName, radialSelect, false, Enum.KeyCode.Thumbstick1)
   ContextActionService:BindCoreAction(thumbstick2RadialActionName, noOpFunc, false, Enum.KeyCode.Thumbstick2)
   ContextActionService:BindCoreAction(toggleMenuActionName, doGamepadMenuButton, false, Enum.KeyCode.ButtonStart)
  else
   unbindAllRadialActions()
  end

  return gamepadSettingsFrame.Visible
 end

 doGamepadMenuButton = function(name, state, input)
  if state ~= Enum.UserInputState.Begin then return end

  if not toggleCoreGuiRadial() then
   unbindAllRadialActions()
  end
 end

 if InputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
  createGamepadMenuGui()
 else
  InputService.GamepadConnected:connect(function(gamepadEnum)
   if gamepadEnum == Enum.UserInputType.Gamepad1 then
    createGamepadMenuGui()
   end
  end)
 end

 local function setRadialButtonEnabled(coreGuiType, enabled)
  local returnValue = getButtonForCoreGuiType(coreGuiType)
  if not returnValue then return end

  local buttonsToDisable = {}
  if type(returnValue) == 'table' then
   for button, buttonTable in pairs(returnValue) do
    if buttonTable['CoreGuiType'] then
     if isTenFootInterface and buttonTable['CoreGuiType'] == Enum.CoreGuiType.Chat then
     else
      buttonsToDisable[#buttonsToDisable + 1] = button
     end
    end
   end
  else
   if isTenFootInterface and returnValue.Name == 'Chat' then
   else
    buttonsToDisable[1] = returnValue
   end
  end

  for i=  1, #buttonsToDisable do
   local button = buttonsToDisable[i]
   setButtonEnabled(button, enabled)
  end
 end
 StarterGui.CoreGuiChangedSignal:connect(setRadialButtonEnabled)

 ContextActionService:BindCoreAction(toggleMenuActionName, doGamepadMenuButton, false, Enum.KeyCode.ButtonStart)
end


setupGamepadControls()

-- chunk: =CoreGui.RobloxGui.CoreScripts/HealthScript coverage=708/2292 consts=6826
-- subst=0
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed








while not game do
 wait(1/60)
end
while not game:GetService('Players') do
 wait(1/60)
end

local useCoreHealthBar = false
local success = pcall(function() useCoreHealthBar = game:GetService('Players'):GetUseCoreScriptHealthBar() end)
if not success or not useCoreHealthBar then
 return
end

local currentHumanoid = nil

local HealthGui = nil
local lastHealth = 100
local HealthPercentageForOverlay = 5
local maxBarTweenTime = 0.29999999999999999
local greenColor = Color3.new(0.20000000000000001,1,0.20000000000000001)
local redColor = Color3.new(1, 0.20000000000000001,0.20000000000000001)
local yellowColor = Color3.new(1, 1, 0.20000000000000001)

local guiEnabled = false
local healthChangedConnection = nil
local humanoidDiedConnection = nil
local characterAddedConnection = nil

local greenBarImage = 'rbxasset://textures/ui/Health-BKG-Center.png'
local greenBarImageLeft = 'rbxasset://textures/ui/Health-BKG-Left-Cap.png'
local greenBarImageRight = 'rbxasset://textures/ui/Health-BKG-Right-Cap.png'
local hurtOverlayImage = 'http://www.roblox.com/asset/?id=34854607'

game:GetService('ContentProvider'):Preload(greenBarImage)
game:GetService('ContentProvider'):Preload(hurtOverlayImage)

while not game:GetService('Players').LocalPlayer do
 wait(1/60)
end




local capHeight = 15
local capWidth = 7

function CreateGui()
 if HealthGui and #HealthGui:GetChildren() > 0 then
  HealthGui.Parent = game:GetService('CoreGui').RobloxGui
  return
 end

 local hurtOverlay = Instance.new('ImageLabel')
 hurtOverlay.Name = 'HurtOverlay'
 hurtOverlay.BackgroundTransparency = 1
 hurtOverlay.Image = hurtOverlayImage
 hurtOverlay.Position = UDim2.new(-10,0,-10,0)
 hurtOverlay.Size = UDim2.new(20,0,20,0)
 hurtOverlay.Visible = false
 hurtOverlay.Parent = HealthGui

 local healthFrame = Instance.new('Frame')
 healthFrame.Name = 'HealthFrame'
 healthFrame.BackgroundTransparency = 1
 healthFrame.BackgroundColor3 = Color3.new(1,1,1)
 healthFrame.BorderColor3 = Color3.new(0,0,0)
 healthFrame.BorderSizePixel = 0
 healthFrame.Position = UDim2.new(0.5,-85,1,-20)
 healthFrame.Size = UDim2.new(0,170,0,capHeight)
 healthFrame.Parent = HealthGui


 local healthBarBackCenter = Instance.new('ImageLabel')
 healthBarBackCenter.Name = 'healthBarBackCenter'
 healthBarBackCenter.BackgroundTransparency = 1
 healthBarBackCenter.Image = greenBarImage
 healthBarBackCenter.Size = UDim2.new(1,-capWidth*2,1,0)
 healthBarBackCenter.Position = UDim2.new(0,capWidth,0,0)
 healthBarBackCenter.Parent = healthFrame
 healthBarBackCenter.ImageColor3 = Color3.new(1,1,1)

 local healthBarBackLeft = Instance.new('ImageLabel')
 healthBarBackLeft.Name = 'healthBarBackLeft'
 healthBarBackLeft.BackgroundTransparency = 1
 healthBarBackLeft.Image = greenBarImageLeft
 healthBarBackLeft.Size = UDim2.new(0,capWidth,1,0)
 healthBarBackLeft.Position = UDim2.new(0,0,0,0)
 healthBarBackLeft.Parent = healthFrame
 healthBarBackLeft.ImageColor3 = Color3.new(1,1,1)

 local healthBarBackRight = Instance.new('ImageLabel')
 healthBarBackRight.Name = 'healthBarBackRight'
 healthBarBackRight.BackgroundTransparency = 1
 healthBarBackRight.Image = greenBarImageRight
 healthBarBackRight.Size = UDim2.new(0,capWidth,1,0)
 healthBarBackRight.Position = UDim2.new(1,-capWidth,0,0)
 healthBarBackRight.Parent = healthFrame
 healthBarBackRight.ImageColor3 = Color3.new(1,1,1)


 local healthBar = Instance.new('Frame')
 healthBar.Name = 'HealthBar'
 healthBar.BackgroundTransparency = 1
 healthBar.BackgroundColor3 = Color3.new(1,1,1)
 healthBar.BorderColor3 = Color3.new(0,0,0)
 healthBar.BorderSizePixel = 0
 healthBar.ClipsDescendants = true
 healthBar.Position = UDim2.new(0, 0, 0, 0)
 healthBar.Size = UDim2.new(1,0,1,0)
 healthBar.Parent = healthFrame


 local healthBarCenter = Instance.new('ImageLabel')
 healthBarCenter.Name = 'healthBarCenter'
 healthBarCenter.BackgroundTransparency = 1
 healthBarCenter.Image = greenBarImage
 healthBarCenter.Size = UDim2.new(1,-capWidth*2,1,0)
 healthBarCenter.Position = UDim2.new(0,capWidth,0,0)
 healthBarCenter.Parent = healthBar
 healthBarCenter.ImageColor3 = greenColor

 local healthBarLeft = Instance.new('ImageLabel')
 healthBarLeft.Name = 'healthBarLeft'
 healthBarLeft.BackgroundTransparency = 1
 healthBarLeft.Image = greenBarImageLeft
 healthBarLeft.Size = UDim2.new(0,capWidth,1,0)
 healthBarLeft.Position = UDim2.new(0,0,0,0)
 healthBarLeft.Parent = healthBar
 healthBarLeft.ImageColor3 = greenColor

 local healthBarRight = Instance.new('ImageLabel')
 healthBarRight.Name = 'healthBarRight'
 healthBarRight.BackgroundTransparency = 1
 healthBarRight.Image = greenBarImageRight
 healthBarRight.Size = UDim2.new(0,capWidth,1,0)
 healthBarRight.Position = UDim2.new(1,-capWidth,0,0)
 healthBarRight.Parent = healthBar
 healthBarRight.ImageColor3 = greenColor

 HealthGui.Parent = game:GetService('CoreGui').RobloxGui
end

function UpdateGui(health)
 if not HealthGui then return end

 local healthFrame = HealthGui:FindFirstChild('HealthFrame')
 if not healthFrame then return end

 local healthBar = healthFrame:FindFirstChild('HealthBar')
 if not healthBar then return end


 local percentHealth = (health/currentHumanoid.MaxHealth)
 if percentHealth ~= percentHealth then
  percentHealth = 1
  healthBar.healthBarCenter.ImageColor3 = yellowColor
  healthBar.healthBarRight.ImageColor3 = yellowColor
  healthBar.healthBarLeft.ImageColor3 = yellowColor
 elseif percentHealth > 0.25  then
  healthBar.healthBarCenter.ImageColor3 = greenColor
  healthBar.healthBarRight.ImageColor3 = greenColor
  healthBar.healthBarLeft.ImageColor3 = greenColor
 else
  healthBar.healthBarCenter.ImageColor3 = redColor
  healthBar.healthBarRight.ImageColor3 = redColor
  healthBar.healthBarLeft.ImageColor3 = redColor
 end

 local width = (health / currentHumanoid.MaxHealth)
  width = math.max(math.min(width,1),0)
  if width ~= width then width = 1 end

 local healthDelta = lastHealth - health
 lastHealth = health

 local percentOfTotalHealth = math.abs(healthDelta/currentHumanoid.MaxHealth)
 percentOfTotalHealth = math.max(math.min(percentOfTotalHealth,1),0)
 if percentOfTotalHealth ~= percentOfTotalHealth then percentOfTotalHealth = 1 end

 local newHealthSize = UDim2.new(width,0,1,0)

 healthBar.Size = newHealthSize

 local sizeX = healthBar.AbsoluteSize.X
 if sizeX < capWidth then
  healthBar.healthBarCenter.Visible = false
  healthBar.healthBarRight.Visible = false
 elseif sizeX < (2*capWidth + 1) then
  healthBar.healthBarCenter.Visible = true
  healthBar.healthBarCenter.Size = UDim2.new(0,sizeX - capWidth,1,0)
  healthBar.healthBarRight.Visible = false
 else
  healthBar.healthBarCenter.Visible = true
  healthBar.healthBarCenter.Size = UDim2.new(1,-capWidth*2,1,0)
  healthBar.healthBarRight.Visible = true
 end

 local thresholdForHurtOverlay = currentHumanoid.MaxHealth * (HealthPercentageForOverlay/100)

 if healthDelta >= thresholdForHurtOverlay and guiEnabled then
  AnimateHurtOverlay()
 end

end

function AnimateHurtOverlay()
 if not HealthGui then return end

 local overlay = HealthGui:FindFirstChild('HurtOverlay')
 if not overlay then return end

 local newSize = UDim2.new(20, 0, 20, 0)
 local newPos = UDim2.new(-10, 0, -10, 0)

 if overlay:IsDescendantOf(game) then

  overlay:TweenSizeAndPosition(newSize,newPos,Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0,true,function()


   overlay.Size = UDim2.new(1,0,1,0)
   overlay.Position = UDim2.new(0,0,0,0)
   overlay.Visible = true


   if overlay:IsDescendantOf(game) then
    overlay:TweenSizeAndPosition(newSize,newPos,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,10,false,function()
     overlay.Visible = false
    end)
   else
    overlay.Size = newSize
    overlay.Position = newPos
   end
  end)
 else
  overlay.Size = newSize
  overlay.Position = newPos
 end

end

function humanoidDied()
  UpdateGui(0)
end

function disconnectPlayerConnections()
 if characterAddedConnection then characterAddedConnection:disconnect() end
 if humanoidDiedConnection then humanoidDiedConnection:disconnect() end
 if healthChangedConnection then healthChangedConnection:disconnect() end
end

function newPlayerCharacter()
 disconnectPlayerConnections()
 startGui()
end

function startGui()
 characterAddedConnection = game:GetService('Players').LocalPlayer.CharacterAdded:connect(newPlayerCharacter)

 local character = game:GetService('Players').LocalPlayer.Character
 if not character then
  return
 end

 currentHumanoid = character:WaitForChild('Humanoid')
 if not currentHumanoid then
  return
 end

 if not game:GetService('StarterGui'):GetCoreGuiEnabled(Enum.CoreGuiType.Health) then
  return
 end

 healthChangedConnection = currentHumanoid.HealthChanged:connect(UpdateGui)
 humanoidDiedConnection = currentHumanoid.Died:connect(humanoidDied)
 UpdateGui(currentHumanoid.Health)

 CreateGui()
end






HealthGui = Instance.new('Frame')
HealthGui.Name = 'HealthGui'
HealthGui.BackgroundTransparency = 1
HealthGui.Size = UDim2.new(1,0,1,0)

game:GetService('StarterGui').CoreGuiChangedSignal:connect(function(coreGuiType,enabled)
 if coreGuiType == Enum.CoreGuiType.Health or coreGuiType == Enum.CoreGuiType.All then
  if guiEnabled and not enabled then
   if HealthGui then
    HealthGui.Parent = nil
   end
   disconnectPlayerConnections()
  elseif not guiEnabled and enabled then
   startGui()
  end

  guiEnabled = enabled
 end
end)

if game:GetService('StarterGui'):GetCoreGuiEnabled(Enum.CoreGuiType.Health) then
 guiEnabled = true
 startGui()
end

-- chunk: =CoreGui.RobloxGui.CoreScripts/MainBotChatScript2 coverage=1158/6042 consts=466
-- subst=0
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
local PURPOSE_DATA = {[
  Enum.DialogPurpose.Quest] = {'rbxasset://textures/DialogQuest.png', Vector2.new(10, 34)},[
  Enum.DialogPurpose.Help] = {'rbxasset://textures/DialogHelp.png', Vector2.new(20, 35)},[
  Enum.DialogPurpose.Shop] = {'rbxasset://textures/ui/DialogShop.png', Vector2.new(22, 43)}
}
local TEXT_HEIGHT = 24
local FONT_SIZE = Enum.FontSize.Size24
local BAR_THICKNESS = 6
local STYLE_PADDING = 17
local CHOICE_PADDING = 6 * 2
local PROMPT_SIZE = Vector2.new(80, 90)
local FRAME_WIDTH = 350

local WIDTH_BONUS = (STYLE_PADDING * 2) - BAR_THICKNESS
local XPOS_OFFSET = -(STYLE_PADDING - BAR_THICKNESS)

local contextActionService = game:GetService('ContextActionService')
local guiService = game:GetService('GuiService')
local YPOS_OFFSET = -math.floor(STYLE_PADDING / 2)
local usingGamepad = false

function setUsingGamepad(input, processed)
 if input.UserInputType == Enum.UserInputType.Gamepad1 or input.UserInputType == Enum.UserInputType.Gamepad2or
  input.UserInputType == Enum.UserInputType.Gamepad3 or input.UserInputType == Enum.UserInputType.Gamepad4 then
  usingGamepad = true
 else
  usingGamepad = false
 end
end

game:GetService('UserInputService').InputBegan:connect(setUsingGamepad)
game:GetService('UserInputService').InputChanged:connect(setUsingGamepad)

function waitForProperty(instance, name)
 while not instance[name] do
  instance.Changed:wait()
 end
end

function waitForChild(instance, name)
 while not instance:FindFirstChild(name) do
  instance.ChildAdded:wait()
 end
end

local filteringEnabledFixFlagSuccess, filteringEnabledFixFlagValue = pcall(function() return settings():GetFFlag('FilteringEnabledDialogFix') end)
local filterEnabledFixActive = (filteringEnabledFixFlagSuccess and filteringEnabledFixFlagValue)

local goodbyeChoiceActiveFlagSuccess, goodbyeChoiceActiveFlagValue = pcall(function() return settings():GetFFlag('GoodbyeChoiceActiveProperty') end)
local goodbyeChoiceActiveFlag = (goodbyeChoiceActiveFlagSuccess and goodbyeChoiceActiveFlagValue)

local mainFrame
local choices = {}
local lastChoice
local choiceMap = {}
local currentConversationDialog
local currentConversationPartner
local currentAbortDialogScript

local coroutineMap = {}
local currentDialogTimeoutCoroutine = nil

local tooFarAwayMessage =           'You are too far away to chat!'
local tooFarAwaySize = 300
local characterWanderedOffMessage = 'Chat ended because you walked away'
local characterWanderedOffSize = 350
local conversationTimedOut =        "Chat ended because you didn\'t reply"
local conversationTimedOutSize = 350

local RobloxReplicatedStorage = game:GetService('RobloxReplicatedStorage')
local setDialogInUseEvent = RobloxReplicatedStorage:WaitForChild('SetDialogInUse')

local player
local screenGui
local chatNotificationGui
local messageDialog
local timeoutScript
local reenableDialogScript
local dialogMap = {}
local dialogConnections = {}
local touchControlGui = nil

local gui = nil
waitForChild(game,'CoreGui')
waitForChild(game:GetService('CoreGui'),'RobloxGui')

game:GetService('CoreGui').RobloxGui:WaitForChild('Modules'):WaitForChild('TenFootInterface')
local isTenFootInterface = require(game:GetService('CoreGui').RobloxGui.Modules.TenFootInterface):IsEnabled()
local utility = require(game:GetService('CoreGui').RobloxGui.Modules.Settings.Utility)
local isSmallTouchScreen = utility:IsSmallTouchScreen()

if isTenFootInterface then
 FONT_SIZE = Enum.FontSize.Size36
 TEXT_HEIGHT = 36
 FRAME_WIDTH = 500
elseif isSmallTouchScreen then
 FONT_SIZE = Enum.FontSize.Size14
 TEXT_HEIGHT = 14
 FRAME_WIDTH = 250
end

if game:GetService('CoreGui').RobloxGui:FindFirstChild('ControlFrame') then
 gui = game:GetService('CoreGui').RobloxGui.ControlFrame
else
 gui = game:GetService('CoreGui').RobloxGui
end
local touchEnabled = game:GetService('UserInputService').TouchEnabled

function currentTone()
 if currentConversationDialog then
  return currentConversationDialog.Tone
 else
  return Enum.DialogTone.Neutral
 end
end


function createChatNotificationGui()
 chatNotificationGui = Instance.new('BillboardGui')
 chatNotificationGui.Name = 'ChatNotificationGui'

 chatNotificationGui.ExtentsOffset = Vector3.new(0,1,0)
 chatNotificationGui.Size = UDim2.new(PROMPT_SIZE.X / 31.5, 0, PROMPT_SIZE.Y / 31.5, 0)
 chatNotificationGui.SizeOffset = Vector2.new(0,0)
 chatNotificationGui.StudsOffset = Vector3.new(0, 3.7000000000000002,0)
 chatNotificationGui.Enabled = true
 chatNotificationGui.RobloxLocked = true
 chatNotificationGui.Active = true

 local button = Instance.new('ImageButton')
 button.Name = 'Background'
 button.Active = false
 button.BackgroundTransparency = 1
 button.Position = UDim2.new(0, 0, 0, 0)
 button.Size = UDim2.new(1, 0, 1, 0)
 button.Image = ''
 button.RobloxLocked = true
 button.Parent = chatNotificationGui

 local icon = Instance.new('ImageLabel')
 icon.Name = 'Icon'
 icon.Position = UDim2.new(0, 0, 0, 0)
 icon.Size = UDim2.new(1, 0, 1, 0)
 icon.Image = ''
 icon.BackgroundTransparency = 1
 icon.RobloxLocked = true
 icon.Parent = button

 local activationButton = Instance.new('ImageLabel')
 activationButton.Name = 'ActivationButton'
 activationButton.Position = UDim2.new(-0.29999999999999999,0,-0.40000000000000002,0)
 activationButton.Size = UDim2.new(0.80000000000000004,0,0.80000000000000004*(PROMPT_SIZE.X/PROMPT_SIZE.Y),0)
 activationButton.Image = 'rbxasset://textures/ui/Settings/Help/XButtonDark.png'
 activationButton.BackgroundTransparency = 1
 activationButton.Visible = false
 activationButton.RobloxLocked = true
 activationButton.Parent = button
end

function getChatColor(tone)
 if tone == Enum.DialogTone.Neutral then
  return Enum.ChatColor.Blue
 elseif tone == Enum.DialogTone.Friendly then
  return Enum.ChatColor.Green
 elseif tone == Enum.DialogTone.Enemy then
  return Enum.ChatColor.Red
 end
end

function styleChoices()
 for _, obj in pairs(choices) do
  obj.BackgroundTransparency = 1
 end
 lastChoice.BackgroundTransparency = 1
end

function styleMainFrame(tone)
 if tone == Enum.DialogTone.Neutral then
  mainFrame.Style = Enum.FrameStyle.ChatBlue
 elseif tone == Enum.DialogTone.Friendly then
  mainFrame.Style = Enum.FrameStyle.ChatGreen
 elseif tone == Enum.DialogTone.Enemy then
  mainFrame.Style = Enum.FrameStyle.ChatRed
 end

 styleChoices()
end
function setChatNotificationTone(gui, purpose, tone)
 if tone == Enum.DialogTone.Neutral then
  gui.Background.Image = 'rbxasset://textures/ui/chatBubble_blue_notify_bkg.png'
 elseif tone == Enum.DialogTone.Friendly then
  gui.Background.Image = 'rbxasset://textures/ui/chatBubble_green_notify_bkg.png'
 elseif tone == Enum.DialogTone.Enemy then
  gui.Background.Image = 'rbxasset://textures/ui/chatBubble_red_notify_bkg.png'
 end

 local newIcon, size = unpack(PURPOSE_DATA[purpose])
 local relativeSize = size / PROMPT_SIZE
 gui.Background.Icon.Size = UDim2.new(relativeSize.X, 0, relativeSize.Y, 0)
 gui.Background.Icon.Position = UDim2.new(0.5 - (relativeSize.X / 2), 0, 0.40000000000000002-(relativeSize.Y/2),0)
 gui.Background.Icon.Image = newIcon
end

function createMessageDialog()
 messageDialog = Instance.new('Frame');
 messageDialog.Name = 'DialogScriptMessage'
 messageDialog.Style = Enum.FrameStyle.Custom
 messageDialog.BackgroundTransparency = 0.5
 messageDialog.BackgroundColor3 = Color3.new(31/255, 31/255, 31/255)
 messageDialog.Visible = false

 local text = Instance.new('TextLabel')
 text.Name = 'Text'
 text.Position = UDim2.new(0,0,0,-1)
 text.Size = UDim2.new(1,0,1,0)
 text.FontSize = Enum.FontSize.Size14
 text.BackgroundTransparency = 1
 text.TextColor3 = Color3.new(1,1,1)
 text.RobloxLocked = true
 text.Parent = messageDialog
end

function showMessage(msg, size)
 messageDialog.Text.Text = msg
 messageDialog.Size = UDim2.new(0,size,0,40)
 messageDialog.Position = UDim2.new(0.5, -size/2, 0.5, -40)
 messageDialog.Visible = true
 wait(2)
 messageDialog.Visible = false
end

function variableDelay(str)
 local length = math.min(string.len(str), 100)
 wait(0.75 + ((length/75) * 1.5))
end

function resetColor(frame)
 frame.BackgroundTransparency = 1
end

function wanderDialog()
 mainFrame.Visible = false
 endDialog()
 showMessage(characterWanderedOffMessage, characterWanderedOffSize)
end

function timeoutDialog()
 mainFrame.Visible = false
 endDialog()
 showMessage(conversationTimedOut, conversationTimedOutSize)
end

function normalEndDialog()
 endDialog()
end

function endDialog()
 if filterEnabledFixActive then
  if currentDialogTimeoutCoroutine then
   coroutineMap[currentDialogTimeoutCoroutine] = false
   currentDialogTimeoutCoroutine = nil
  end
 else
  if currentAbortDialogScript then
   currentAbortDialogScript:Destroy()
   currentAbortDialogScript = nil
  end
 end

 local dialog = currentConversationDialog
 currentConversationDialog = nil
 if dialog and dialog.InUse then
  if filterEnabledFixActive then
   spawn(function()
    wait(5)
    setDialogInUseEvent:FireServer(dialog, false)
   end)
  else
   local reenableScript = reenableDialogScript:Clone()
   reenableScript.Archivable = false
   reenableScript.Disabled = false
   reenableScript.Parent = dialog
  end
 end

 for dialog, gui in pairs(dialogMap) do
  if dialog and gui then
   gui.Enabled = not dialog.InUse
  end
 end

 contextActionService:UnbindCoreAction('Nothing')
 currentConversationPartner = nil

 if touchControlGui then
  touchControlGui.Visible = true
 end
end

function sanitizeMessage(msg)
  if string.len(msg) == 0 then
     return '...'
  else
     return msg
  end
end

function selectChoice(choice)
 renewKillswitch(currentConversationDialog)


 mainFrame.Visible = false
 if choice == lastChoice then
  game:GetService('Chat'):Chat(game:GetService('Players').LocalPlayer.Character, lastChoice.UserPrompt.Text, getChatColor(currentTone()))

  normalEndDialog()
 else
  local dialogChoice = choiceMap[choice]

  game:GetService('Chat'):Chat(game:GetService('Players').LocalPlayer.Character, sanitizeMessage(dialogChoice.UserDialog), getChatColor(currentTone()))
  wait(1)
  currentConversationDialog:SignalDialogChoiceSelected(player, dialogChoice)
  game:GetService('Chat'):Chat(currentConversationPartner, sanitizeMessage(dialogChoice.ResponseDialog), getChatColor(currentTone()))

  variableDelay(dialogChoice.ResponseDialog)
  presentDialogChoices(currentConversationPartner, dialogChoice:GetChildren(), dialogChoice)
 end
end

function newChoice()
 local dummyFrame = Instance.new('Frame')
 dummyFrame.Visible = false

 local frame = Instance.new('TextButton')
 frame.BackgroundColor3 = Color3.new(227/255, 227/255, 227/255)
 frame.BackgroundTransparency = 1
 frame.AutoButtonColor = false
 frame.BorderSizePixel = 0
 frame.Text = ''
 frame.MouseEnter:connect(function() frame.BackgroundTransparency = 0 end)
 frame.MouseLeave:connect(function() frame.BackgroundTransparency = 1 end)
 frame.SelectionImageObject = dummyFrame
 frame.MouseButton1Click:connect(function() selectChoice(frame) end)
 frame.RobloxLocked = true

 local prompt = Instance.new('TextLabel')
 prompt.Name = 'UserPrompt'
 prompt.BackgroundTransparency = 1
 prompt.Font = Enum.Font.SourceSans
 prompt.FontSize = FONT_SIZE
 prompt.Position = UDim2.new(0, 40, 0, 0)
 prompt.Size = UDim2.new(1, -32-40, 1, 0)
 prompt.TextXAlignment = Enum.TextXAlignment.Left
 prompt.TextYAlignment = Enum.TextYAlignment.Center
 prompt.TextWrap = true
 prompt.RobloxLocked = true
 prompt.Parent = frame

 local selectionButton = Instance.new('ImageLabel')
 selectionButton.Name = 'RBXchatDialogSelectionButton'
 selectionButton.Position = UDim2.new(0, 0, 0.5, -33/2)
 selectionButton.Size = UDim2.new(0, 33, 0, 33)
 selectionButton.Image = 'rbxasset://textures/ui/Settings/Help/AButtonLightSmall.png'
 selectionButton.BackgroundTransparency = 1
 selectionButton.Visible = false
 selectionButton.RobloxLocked = true
 selectionButton.Parent = frame

 return frame
end
function initialize(parent)
 choices[1] = newChoice()
 choices[2] = newChoice()
 choices[3] = newChoice()
 choices[4] = newChoice()

 lastChoice = newChoice()
 lastChoice.UserPrompt.Text = 'Goodbye!'
 lastChoice.Size = UDim2.new(1, WIDTH_BONUS, 0, TEXT_HEIGHT + CHOICE_PADDING)

 mainFrame = Instance.new('Frame')
 mainFrame.Name = 'UserDialogArea'
 mainFrame.Size = UDim2.new(0, FRAME_WIDTH, 0, 200)
 mainFrame.Style = Enum.FrameStyle.ChatBlue
 mainFrame.Visible = false

 for n, obj in pairs(choices) do
      obj.RobloxLocked = true
  obj.Parent = mainFrame
 end

 lastChoice.RobloxLocked = true
 lastChoice.Parent = mainFrame

 mainFrame.RobloxLocked = true
 mainFrame.Parent = parent
end

function presentDialogChoices(talkingPart, dialogChoices, parentDialog)
 if not currentConversationDialog then
  return
 end

 currentConversationPartner = talkingPart
 sortedDialogChoices = {}
 for n, obj in pairs(dialogChoices) do
  if obj:IsA('DialogChoice') then
   table.insert(sortedDialogChoices, obj)
  end
 end
 table.sort(sortedDialogChoices, function(a,b) return a.Name < b.Name end)

 if #sortedDialogChoices == 0 then
  normalEndDialog()
  return
 end

 local pos = 1
 local yPosition = 0
 choiceMap = {}
 for n, obj in pairs(choices) do
  obj.Visible = false
 end

 for n, obj in pairs(sortedDialogChoices) do
  if pos <= #choices then

   choices[pos].Size = UDim2.new(1, WIDTH_BONUS, 0, TEXT_HEIGHT * 3)
   choices[pos].UserPrompt.Text = obj.UserDialog
   local height = (math.ceil(choices[pos].UserPrompt.TextBounds.Y / TEXT_HEIGHT) * TEXT_HEIGHT) + CHOICE_PADDING

   choices[pos].Position = UDim2.new(0, XPOS_OFFSET, 0, YPOS_OFFSET + yPosition)
   choices[pos].Size = UDim2.new(1, WIDTH_BONUS, 0, height)
   choices[pos].Visible = true

   choiceMap[choices[pos]] = obj

   yPosition = yPosition + height + 1
   pos = pos + 1
  end
 end

 lastChoice.Size = UDim2.new(1, WIDTH_BONUS, 0, TEXT_HEIGHT * 3)
 lastChoice.UserPrompt.Text = parentDialog.GoodbyeDialog == '' and 'Goodbye!' or parentDialog.GoodbyeDialog
 local height = (math.ceil(lastChoice.UserPrompt.TextBounds.Y / TEXT_HEIGHT) * TEXT_HEIGHT) + CHOICE_PADDING
 lastChoice.Size = UDim2.new(1, WIDTH_BONUS, 0, height)
 lastChoice.Position = UDim2.new(0, XPOS_OFFSET, 0, YPOS_OFFSET + yPosition)
 lastChoice.Visible = true

 if goodbyeChoiceActiveFlag and not parentDialog.GoodbyeChoiceActive then
  lastChoice.Visible = false
  mainFrame.Size = UDim2.new(0, FRAME_WIDTH, 0, yPosition + (STYLE_PADDING * 2) + (YPOS_OFFSET * 2))
 else
  mainFrame.Size = UDim2.new(0, FRAME_WIDTH, 0, yPosition + lastChoice.AbsoluteSize.Y + (STYLE_PADDING * 2) + (YPOS_OFFSET * 2))
 end

 mainFrame.Position = UDim2.new(0,20,1,   -mainFrame.Size.Y.Offset-20)
 if isSmallTouchScreen then
  local touchScreenGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild('TouchGui')
  if touchScreenGui then
   touchControlGui = touchScreenGui:FindFirstChild('TouchControlFrame')
   if touchControlGui then
    touchControlGui.Visible = false
   end
  end
  mainFrame.Position = UDim2.new(0,10,1,   -mainFrame.Size.Y.Offset)
 end
 styleMainFrame(currentTone())
 mainFrame.Visible = true

 if usingGamepad then
  Game:GetService('GuiService').SelectedCoreObject = choices[1]
 end
end

function doDialog(dialog)
 if dialog.InUse then
  return
 else
  dialog.InUse = true
  if filterEnabledFixActive then
   setDialogInUseEvent:FireServer(dialog, true)
  end
 end

 currentConversationDialog = dialog
 game:GetService('Chat'):Chat(dialog.Parent, dialog.InitialPrompt, getChatColor(dialog.Tone))
 variableDelay(dialog.InitialPrompt)

 presentDialogChoices(dialog.Parent, dialog:GetChildren(), dialog)
end

function renewKillswitch(dialog)
 if filterEnabledFixActive then
  if currentDialogTimeoutCoroutine then
   coroutineMap[currentDialogTimeoutCoroutine] = false
   currentDialogTimeoutCoroutine = nil
  end
 else
  if currentAbortDialogScript then
   currentAbortDialogScript:Destroy()
   currentAbortDialogScript = nil
  end
 end

 if filterEnabledFixActive then
  currentDialogTimeoutCoroutine = coroutine.create(function(thisCoroutine)
   wait(15)
   if thisCoroutine ~= nil then
    if coroutineMap[thisCoroutine] == nil then
     setDialogInUseEvent:FireServer(dialog, false)
    end
    coroutineMap[thisCoroutine] = nil
   end
  end)
  coroutine.resume(currentDialogTimeoutCoroutine, currentDialogTimeoutCoroutine)
 else
  currentAbortDialogScript = timeoutScript:Clone()
  currentAbortDialogScript.Archivable = false
  currentAbortDialogScript.Disabled = false
  currentAbortDialogScript.Parent = dialog
 end
end

function checkForLeaveArea()
 while currentConversationDialog do
  if currentConversationDialog.Parent and (player:DistanceFromCharacter(currentConversationDialog.Parent.Position) >= currentConversationDialog.ConversationDistance) then
   wanderDialog()
  end
  wait(1)
 end
end

function startDialog(dialog)
 if dialog.Parent and dialog.Parent:IsA('BasePart') then
  if player:DistanceFromCharacter(dialog.Parent.Position) >= dialog.ConversationDistance then
   showMessage(tooFarAwayMessage, tooFarAwaySize)
   return
  end

  for dialog, gui in pairs(dialogMap) do
   if dialog and gui then
    gui.Enabled = false
   end
  end

  contextActionService:BindCoreAction('Nothing', function() end, false, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4)

  renewKillswitch(dialog)

  delay(1, checkForLeaveArea)
  doDialog(dialog)
 end
end

function removeDialog(dialog)
   if dialogMap[dialog] then
      dialogMap[dialog]:Destroy()
      dialogMap[dialog] = nil
   end
 if dialogConnections[dialog] then
  dialogConnections[dialog]:disconnect()
  dialogConnections[dialog] = nil
 end
end

function addDialog(dialog)
 if dialog.Parent then
  if dialog.Parent:IsA('BasePart') then
   local chatGui = chatNotificationGui:clone()
   chatGui.Enabled = not dialog.InUse
   chatGui.Adornee = dialog.Parent
   chatGui.RobloxLocked = true

   chatGui.Parent = game:GetService('CoreGui')

   chatGui.Background.MouseButton1Click:connect(function() startDialog(dialog) end)
   setChatNotificationTone(chatGui, dialog.Purpose, dialog.Tone)

   dialogMap[dialog] = chatGui

   dialogConnections[dialog] = dialog.Changed:connect(function(prop)
    if prop == 'Parent' and dialog.Parent then

     removeDialog(dialog)
     addDialog(dialog)
    elseif prop == 'InUse' then
     chatGui.Enabled = not currentConversationDialog and not dialog.InUse
     if dialog == currentConversationDialog then
      timeoutDialog()
     end
    elseif prop == 'Tone' or prop == 'Purpose' then
     setChatNotificationTone(chatGui, dialog.Purpose, dialog.Tone)
    end
   end)
  else
   dialogConnections[dialog] = dialog.Changed:connect(function(prop)
    if prop == 'Parent' and dialog.Parent then

     removeDialog(dialog)
     addDialog(dialog)
    end
   end)
  end
 end
end

function fetchScripts()
 local model = game:GetService('InsertService'):LoadAsset(39226062)
    if type(model) == 'string' then
  wait(0.10000000000000001)
  model = game:GetService('InsertService'):LoadAsset(39226062)
 end
 if type(model) == 'string' then
  return
 end

 waitForChild(model,'TimeoutScript')
 timeoutScript = model.TimeoutScript
 waitForChild(model,'ReenableDialogScript')
 reenableDialogScript = model.ReenableDialogScript
end

function onLoad()
  waitForProperty(game:GetService('Players'), 'LocalPlayer')
  player = game:GetService('Players').LocalPlayer
  waitForProperty(player, 'Character')


  createChatNotificationGui()


  createMessageDialog()
  messageDialog.RobloxLocked = true
  messageDialog.Parent = gui

  if not filterEnabledFixActive then
 fetchScripts()
  end


  waitForChild(gui, 'BottomLeftControl')


  local frame = Instance.new('Frame')
  frame.Name = 'DialogFrame'
  frame.Position = UDim2.new(0,0,0,0)
  frame.Size = UDim2.new(0,0,0,0)
  frame.BackgroundTransparency = 1
  frame.RobloxLocked = true
  game:GetService('GuiService'):AddSelectionParent('RBXDialogGroup', frame)

  if (touchEnabled and not isSmallTouchScreen) then
 frame.Position = UDim2.new(0,20,0.5,0)
 frame.Size = UDim2.new(0.25,0,0.10000000000000001,0)
 frame.Parent = gui
  elseif isSmallTouchScreen then
 frame.Position = UDim2.new(0,0,0.90000000000000002,-10)
 frame.Size = UDim2.new(0.25,0,0.10000000000000001,0)
 frame.Parent = gui
  else
 frame.Parent = gui.BottomLeftControl
  end
  initialize(frame)


  game:GetService('CollectionService').ItemAdded:connect(function(obj) if obj:IsA('Dialog') then addDialog(obj) end end)
  game:GetService('CollectionService').ItemRemoved:connect(function(obj) if obj:IsA('Dialog') then removeDialog(obj) end end)
  for i, obj in pairs(game:GetService('CollectionService'):GetCollection('Dialog')) do
    if obj:IsA('Dialog') then
       addDialog(obj)
    end
  end
end

local lastClosestDialog = nil
local getClosestDialogToPosition = guiService.GetClosestDialogToPosition

game:GetService('RunService').Heartbeat:connect(function()
 local closestDistance = math.huge
 local closestDialog = nil
 if usingGamepad == true then
  if game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
   local characterPosition = game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart').Position
   closestDialog = getClosestDialogToPosition(guiService, characterPosition)
  end
 end

 if closestDialog ~= lastClosestDialog then
  if dialogMap[lastClosestDialog] then
   dialogMap[lastClosestDialog].Background.ActivationButton.Visible = false
  end
  lastClosestDialog = closestDialog
  contextActionService:UnbindCoreAction('StartDialogAction')
  if closestDialog ~= nil then
   contextActionService:BindCoreAction('StartDialogAction',
            function(actionName, userInputState, inputObject)
             if userInputState == Enum.UserInputState.Begin then
              if closestDialog and closestDialog.Parent then
               startDialog(closestDialog)
              end
             end
            end,
            false,
            Enum.KeyCode.ButtonX)
   if dialogMap[closestDialog] then
    dialogMap[closestDialog].Background.ActivationButton.Visible = true
   end
  end
 end
end)

local lastSelectedChoice = nil

guiService.Changed:connect(function(property)
 if property == 'SelectedCoreObject' then
  if lastSelectedChoice and lastSelectedChoice:FindFirstChild('RBXchatDialogSelectionButton') then
   lastSelectedChoice:FindFirstChild('RBXchatDialogSelectionButton').Visible = false
   lastSelectedChoice.BackgroundTransparency = 1
  end
  lastSelectedChoice = guiService.SelectedCoreObject
  if lastSelectedChoice and lastSelectedChoice:FindFirstChild('RBXchatDialogSelectionButton') then
   lastSelectedChoice:FindFirstChild('RBXchatDialogSelectionButton').Visible = true
   lastSelectedChoice.BackgroundTransparency = 0
  end
 end
end)

onLoad()
-- chunk: =CoreGui.RobloxGui.CoreScripts/NotificationScript2 coverage=648/9732 consts=2473
-- subst=0
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed














local BadgeService = game:GetService('BadgeService')
local GuiService = game:GetService('GuiService')
local Players = game:GetService('Players')
local PointsService = game:GetService('PointsService')
local MarketplaceService = game:GetService('MarketplaceService')
local TeleportService = game:GetService('TeleportService')
local HttpService = game:GetService('HttpService')
local ContextActionService = game:GetService('ContextActionService')
local CoreGui = game:GetService('CoreGui')
local RobloxGui = CoreGui:WaitForChild('RobloxGui')
local Settings = UserSettings()
local GameSettings = Settings.GameSettings


local getNotificationDisableSuccess, notificationsDisableActiveValue = pcall(function() return settings():GetFFlag('SetCoreDisableNotifications') end)
local allowDisableNotifications = getNotificationDisableSuccess and notificationsDisableActiveValue

local getSendNotificationSuccess, sendNotificationActiveValue = pcall(function() return settings():GetFFlag('SetCoreSendNotifications') end)
local allowSendNotifications = getSendNotificationSuccess and sendNotificationActiveValue


local LocalPlayer = nil
while not Players.LocalPlayer do
 wait()
end
LocalPlayer = Players.LocalPlayer
local RbxGui = script.Parent
local NotificationQueue = {}
local OverflowQueue = {}
local FriendRequestBlacklist = {}
local CurrentGraphicsQualityLevel = GameSettings.SavedQualityLevel.Value
local BindableEvent_SendNotification = Instance.new('BindableFunction')
BindableEvent_SendNotification.Name = 'SendNotification'
BindableEvent_SendNotification.Parent = RbxGui
local isPaused = false
RobloxGui:WaitForChild('Modules'):WaitForChild('TenFootInterface')
local isTenFootInterface = require(RobloxGui.Modules.TenFootInterface):IsEnabled()

local pointsNotificationsActive = true
local badgesNotificationsActive = true


local BG_TRANSPARENCY = 0.69999999999999996
local MAX_NOTIFICATIONS = 3
local NOTIFICATION_Y_OFFSET = 64
local IMAGE_SIZE = 48
local EASE_DIR = Enum.EasingDirection.InOut
local EASE_STYLE = Enum.EasingStyle.Sine
local TWEEN_TIME = 0.34999999999999998
local DEFAULT_NOTIFICATION_DURATION = 5


local PLAYER_POINTS_IMG = 'http://www.roblox.com/asset?id=206410433'
local BADGE_IMG = 'http://www.roblox.com/asset?id=206410289'
local FRIEND_IMAGE = 'http://www.roblox.com/thumbs/avatar.ashx?userId='


local function createFrame(name, size, position, bgt)
 local frame = Instance.new('Frame')
 frame.Name = name
 frame.Size = size
 frame.Position = position
 frame.BackgroundTransparency = bgt

 return frame
end

local function createTextButton(name, text, position)
 local button = Instance.new('TextButton')
 button.Name = name
 button.Size = UDim2.new(0.5, -2, 0.5, 0)
 button.Position = position
 button.BackgroundTransparency = BG_TRANSPARENCY
 button.BackgroundColor3 = Color3.new(0, 0, 0)
 button.Font = Enum.Font.SourceSansBold
 button.FontSize = Enum.FontSize.Size18
 button.TextColor3 = Color3.new(1, 1, 1)
 button.Text = text

 return button
end

local NotificationFrame = createFrame('NotificationFrame', UDim2.new(0, 200, 0.41999999999999998,0),UDim2.new(1,-204,0.5,0),1)
NotificationFrame.Parent = RbxGui

local DefaultNotifcation = createFrame('Notifcation', UDim2.new(1, 0, 0, NOTIFICATION_Y_OFFSET), UDim2.new(0, 0, 0, 0), BG_TRANSPARENCY)
DefaultNotifcation.BackgroundColor3 = Color3.new(0, 0, 0)
DefaultNotifcation.BorderSizePixel = 0

local NotificationTitle = Instance.new('TextLabel')
NotificationTitle.Name = 'NotificationTitle'
NotificationTitle.Size = UDim2.new(0, 0, 0, 0)
NotificationTitle.Position = UDim2.new(0.5, 0, 0.5, -12)
NotificationTitle.BackgroundTransparency = 1
NotificationTitle.Font = Enum.Font.SourceSansBold
NotificationTitle.FontSize = Enum.FontSize.Size18
NotificationTitle.TextColor3 = Color3.new(0.96999999999999997,0.96999999999999997,0.96999999999999997)

local NotificationText = Instance.new('TextLabel')
NotificationText.Name = 'NotificationText'
NotificationText.Size = UDim2.new(1, -20, 0, 28)
NotificationText.Position = UDim2.new(0, 10, 0.5, 1)
NotificationText.BackgroundTransparency = 1
NotificationText.Font = Enum.Font.SourceSans
NotificationText.FontSize = Enum.FontSize.Size14
NotificationText.TextColor3 = Color3.new(0.92000000000000004,0.92000000000000004,0.92000000000000004)
NotificationText.TextWrap = true
NotificationText.TextYAlignment = Enum.TextYAlignment.Top

local NotificationImage = Instance.new('ImageLabel')
NotificationImage.Name = 'NotificationImage'
NotificationImage.Size = UDim2.new(0, IMAGE_SIZE, 0, IMAGE_SIZE)
NotificationImage.Position = UDim2.new(0, 8, 0.5, -24)
NotificationImage.BackgroundTransparency = 1
NotificationImage.Image = ''


local PopupFrame = createFrame('PopupFrame', UDim2.new(0, 360, 0, 160), UDim2.new(0.5, -180, 0.5, -50), 0)
PopupFrame.Style = Enum.FrameStyle.DropShadow
PopupFrame.ZIndex = 4
PopupFrame.Visible = false
PopupFrame.Parent = RbxGui

local PopupAcceptButton = Instance.new('TextButton')
PopupAcceptButton.Name = 'PopupAcceptButton'
PopupAcceptButton.Size = UDim2.new(0, 100, 0, 50)
PopupAcceptButton.Position = UDim2.new(0.5, -102, 1, -58)
PopupAcceptButton.Style = Enum.ButtonStyle.RobloxRoundButton
PopupAcceptButton.Font = Enum.Font.SourceSansBold
PopupAcceptButton.FontSize = Enum.FontSize.Size24
PopupAcceptButton.TextColor3 = Color3.new(1, 1, 1)
PopupAcceptButton.Text = 'Accept'
PopupAcceptButton.ZIndex = 5
PopupAcceptButton.Parent = PopupFrame

local PopupDeclineButton = PopupAcceptButton:Clone()
PopupDeclineButton.Name = 'PopupDeclineButton'
PopupDeclineButton.Position = UDim2.new(0.5, 2, 1, -58)
PopupDeclineButton.Text = 'Decline'
PopupDeclineButton.Parent = PopupFrame

local PopupOKButton = PopupAcceptButton:Clone()
PopupOKButton.Name = 'PopupOKButton'
PopupOKButton.Position = UDim2.new(0.5, -50, 1, -58)
PopupOKButton.Text = 'OK'
PopupOKButton.Visible = false
PopupOKButton.Parent = PopupFrame

local PopupText = Instance.new('TextLabel')
PopupText.Name = 'PopupText'
PopupText.Size = UDim2.new(1, -16, 0.80000000000000004,0)
PopupText.Position = UDim2.new(0, 8, 0, 8)
PopupText.BackgroundTransparency = 1
PopupText.Font = Enum.Font.SourceSansBold
PopupText.FontSize = Enum.FontSize.Size36
PopupText.TextColor3 = Color3.new(0.96999999999999997,0.96999999999999997,0.96999999999999997)
PopupText.TextWrap = true
PopupText.ZIndex = 5
PopupText.TextYAlignment = Enum.TextYAlignment.Top
PopupText.Text = 'This is a popup'
PopupText.Parent = PopupFrame


local insertNotifcation = nil
local removeNotification = nil

local function createNotification(title, text, image)
 local notificationFrame = DefaultNotifcation:Clone()
 notificationFrame.Position = UDim2.new(1, 4, 1, -NOTIFICATION_Y_OFFSET - 4)

 local notificationTitle = NotificationTitle:Clone()
 notificationTitle.Text = title
 notificationTitle.Parent = notificationFrame

 local notificationText = NotificationText:Clone()
 notificationText.Text = text
 notificationText.Parent = notificationFrame

 if image and image ~= '' then
  local notificationImage = NotificationImage:Clone()
  notificationImage.Image = image
  notificationImage.Parent = notificationFrame

  notificationTitle.Position = UDim2.new(0, NotificationImage.Size.X.Offset + 16, 0.5, -12)
  notificationTitle.TextXAlignment = Enum.TextXAlignment.Left

  notificationText.Size = UDim2.new(1, -IMAGE_SIZE - 16, 0, 28)
  notificationText.Position = UDim2.new(0, IMAGE_SIZE + 16, 0.5, 1)
  notificationText.TextXAlignment = Enum.TextXAlignment.Left
 end

 GuiService:AddSelectionParent(HttpService:GenerateGUID(false), notificationFrame)

 return notificationFrame
end

local function findNotification(notification)
 local index = nil
 for i=  1, #NotificationQueue do
  if NotificationQueue[i] == notification then
   return i
  end
 end
end

local function updateNotifications()
 local pos = 1
 local yOffset = 0
 for i=  #NotificationQueue, 1, -1 do
  local currentNotification = NotificationQueue[i]
  if currentNotification then
   local frame = currentNotification.Frame
   if frame and frame.Parent then
    local thisOffset = currentNotification.IsFriend and (NOTIFICATION_Y_OFFSET + 2) * 1.5 or NOTIFICATION_Y_OFFSET
    yOffset = yOffset + thisOffset
    frame:TweenPosition(UDim2.new(0, 0, 1, -yOffset - (pos * 4)), EASE_DIR, EASE_STYLE, TWEEN_TIME, true)
    pos = pos + 1
   end
  end
 end
end

local lastTimeInserted = 0
insertNotifcation = function(notification)
 spawn(function()
  while isPaused do wait() end
  notification.IsActive = true
  local size = #NotificationQueue
  if size == MAX_NOTIFICATIONS then
   OverflowQueue[#OverflowQueue + 1] = notification
   return
  end

  NotificationQueue[size + 1] = notification
  notification.Frame.Parent = NotificationFrame
  delay(notification.Duration, function()
   removeNotification(notification)
  end)
  while tick() - lastTimeInserted < TWEEN_TIME do
   wait()
  end
  lastTimeInserted = tick()

  updateNotifications()
 end)
end

removeNotification = function(notification)
 if not notification then return end

 local index = findNotification(notification)
 table.remove(NotificationQueue, index)
 local frame = notification.Frame
 if frame and frame.Parent then
  notification.IsActive = false
  spawn(function()
   while isPaused do wait() end

   frame:TweenPosition(UDim2.new(1, 0, 1, frame.Position.Y.Offset), EASE_DIR, EASE_STYLE, TWEEN_TIME, true,
    function()
     frame:Destroy()
     notification = nil
    end)
  end)
 end
 if #OverflowQueue > 0 then
  local nextNofication = OverflowQueue[1]
  table.remove(OverflowQueue, 1)
  insertNotifcation(nextNofication)
 else
  updateNotifications()
 end
end

local function sendNotifcation(title, text, image, duration, callback, button1Text, button2Text)
 local notification = {}
 local notificationFrame = createNotification(title, text, image)


 local button1 = nil
 if button1Text and button1Text ~= '' then
  notification.IsFriend = true
  button1 = createTextButton('Button1', button1Text, UDim2.new(0, 0, 1, 2))
  button1.Parent = notificationFrame
  local button1ClickedConnection = nil
  button1ClickedConnection = button1.MouseButton1Click:connect(function()
   if button1ClickedConnection then
    button1ClickedConnection:disconnect()
    button1ClickedConnection = nil
    removeNotification(notification)
    if callback and type(callback) ~= 'function' then
     pcall(function() callback:Invoke(button1Text) end)
    elseif type(callback) == 'function' then
     callback(button1Text)
    end
   end
  end)
 end

 if button2Text and button2Text ~= '' then
  notification.IsFriend = true
  local button2 = createTextButton('Button1', button2Text, UDim2.new(0.5, 2, 1, 2))
  button2.Parent = notificationFrame
  local button2ClickedConnection = nil
  button2ClickedConnection = button2.MouseButton1Click:connect(function()
   if button2ClickedConnection then
    button2ClickedConnection:disconnect()
    button2ClickedConnection = nil
    removeNotification(notification)
    if callback and type(callback) ~= 'function' then
     pcall(function() callback:Invoke(button2Text) end)
    elseif type(callback) == 'function' then
     callback(button2Text)
    end
   end
  end)
 else

  if button1 then
   button1.Size = UDim2.new(1, -2, 0.5,0)
  end
 end

 notification.Frame = notificationFrame
 notification.Duration = duration
 insertNotifcation(notification)
end
BindableEvent_SendNotification.OnInvoke = function(title, text, image, duration, callback)
 sendNotifcation(title, text, image, duration, callback)
end


spawn(function()
 local RobloxReplicatedStorage = game:GetService('RobloxReplicatedStorage')
 local RemoteEvent_NewFollower = RobloxReplicatedStorage:WaitForChild('NewFollower')

 RemoteEvent_NewFollower.OnClientEvent:connect(function(followerRbxPlayer)
  sendNotifcation('New Follower', followerRbxPlayer.Name..' is now following you!',
   FRIEND_IMAGE..followerRbxPlayer.userId..'&x=48&y=48', 5, function() end)
 end)
end)

local function sendFriendNotification(fromPlayer)
 local notification = {}
 local notificationFrame = createNotification(fromPlayer.Name, 'Sent you a friend request!',
  FRIEND_IMAGE..tostring(fromPlayer.userId)..'&x=48&y=48')
 notificationFrame.Position = UDim2.new(1, 4, 1, -(NOTIFICATION_Y_OFFSET + 2) * 1.5 - 4)

 local acceptButton = createTextButton('AcceptButton', 'Accept', UDim2.new(0, 0, 1, 2))
 acceptButton.Parent = notificationFrame

 local declineButton = createTextButton('DeclineButton', 'Decline', UDim2.new(0.5, 2, 1, 2))
 declineButton.Parent = notificationFrame

 acceptButton.MouseButton1Click:connect(function()
  if not notification.IsActive then return end
  if notification then
   removeNotification(notification)
  end
  LocalPlayer:RequestFriendship(fromPlayer)
 end)

 declineButton.MouseButton1Click:connect(function()
  if not notification.IsActive then return end
  if notification then
   removeNotification(notification)
  end
  LocalPlayer:RevokeFriendship(fromPlayer)
  FriendRequestBlacklist[fromPlayer] = true
 end)

 notification.Frame = notificationFrame
 notification.Duration = 8
 notification.IsFriend = true
 insertNotifcation(notification)
end


local function onFriendRequestEvent(fromPlayer, toPlayer, event)
 if fromPlayer ~= LocalPlayer and toPlayer ~= LocalPlayer then return end

 if fromPlayer == LocalPlayer then
  if event == Enum.FriendRequestEvent.Accept then
   sendNotifcation('New Friend', 'You are now friends with '..toPlayer.Name..'!',
    FRIEND_IMAGE..tostring(toPlayer.userId)..'&x=48&y=48', DEFAULT_NOTIFICATION_DURATION, nil)
  end
 elseif toPlayer == LocalPlayer then
  if event == Enum.FriendRequestEvent.Issue then
   if FriendRequestBlacklist[fromPlayer] then return end
   sendFriendNotification(fromPlayer)
  elseif event == Enum.FriendRequestEvent.Accept then
   sendNotifcation('New Friend', 'You are now friends with '..fromPlayer.Name..'!',
    FRIEND_IMAGE..tostring(fromPlayer.userId)..'&x=48&y=48', DEFAULT_NOTIFICATION_DURATION, nil)
  end
 end
end


local function onPointsAwarded(userId, pointsAwarded, userBalanceInGame, userTotalBalance)
 if pointsNotificationsActive and userId == LocalPlayer.userId then
  if pointsAwarded == 1 then
   sendNotifcation('Point Awarded', 'You received '..tostring(pointsAwarded)..' point!', PLAYER_POINTS_IMG, DEFAULT_NOTIFICATION_DURATION, nil)
  elseif pointsAwarded > 0 then
   sendNotifcation('Points Awarded', 'You received '..tostring(pointsAwarded)..' points!', PLAYER_POINTS_IMG, DEFAULT_NOTIFICATION_DURATION, nil)
  elseif pointsAwarded < 0 then
   sendNotifcation('Points Lost', 'You lost '..tostring(-pointsAwarded)..' points!', PLAYER_POINTS_IMG, DEFAULT_NOTIFICATION_DURATION, nil)
  end
 end
end


local function onBadgeAwarded(message, userId, badgeId)
 if badgesNotificationsActive and userId == LocalPlayer.userId then
  sendNotifcation('Badge Awarded', message, BADGE_IMG, DEFAULT_NOTIFICATION_DURATION, nil)
 end
end


function onGameSettingsChanged(property, amount)
 if property == 'SavedQualityLevel' then
  local level = GameSettings.SavedQualityLevel.Value + amount
  if level > 10 then
   level = 10
  elseif level < 1 then
   level = 1
  end

  if level > 0 and level ~= CurrentGraphicsQualityLevel then
   if level > CurrentGraphicsQualityLevel then
    sendNotifcation('Graphics Quality', 'Increased to ('..tostring(level)..')', '', 2, nil)
   else
    sendNotifcation('Graphics Quality', 'Decreased to ('..tostring(level)..')', '', 2, nil)
   end
   CurrentGraphicsQualityLevel = level
  end
 end
end


if not isTenFootInterface then
 Players.FriendRequestEvent:connect(onFriendRequestEvent)
 PointsService.PointsAwarded:connect(onPointsAwarded)
 BadgeService.BadgeAwarded:connect(onBadgeAwarded)

 game.GraphicsQualityChangeRequest:connect(function(graphicsIncrease)
  onGameSettingsChanged('SavedQualityLevel', graphicsIncrease == true and 1 or -1)
 end)
end

GuiService.SendCoreUiNotification = function(title, text)
 local notification = createNotification(title, text, '')
 notification.BackgroundTransparency = 0.5
 notification.Size = UDim2.new(0.5,0, 0.10000000000000001,0)
 notification.Position = UDim2.new(0.25,0, -0.10000000000000001,0)
 notification.NotificationTitle.FontSize = Enum.FontSize.Size36
 notification.NotificationText.FontSize = Enum.FontSize.Size24
 notification.Parent = RbxGui
 notification:TweenPosition(UDim2.new(0.25,0, 0, 0), EASE_DIR, EASE_STYLE, TWEEN_TIME, true)
 wait(5)
 if notification then
  notification:Destroy()
 end
end



local function onClientLuaDialogRequested(msg, accept, decline)
 PopupText.Text = msg

 local acceptCn, declineCn = nil, nil
 local function disconnectCns()
  if acceptCn then acceptCn:disconnect() end
  if declineCn then declineCn:disconnect() end

  GuiService:RemoveCenterDialog(PopupFrame)
  PopupFrame.Visible = false
 end

 acceptCn = PopupAcceptButton.MouseButton1Click:connect(function()
  disconnectCns()
  MarketplaceService:SignalServerLuaDialogClosed(true)
 end)
 declineCn = PopupDeclineButton.MouseButton1Click:connect(function()
  disconnectCns()
  MarketplaceService:SignalServerLuaDialogClosed(false)
 end)

 local centerDialogSuccess = pcall(
  function()
   GuiService:AddCenterDialog(PopupFrame, Enum.CenterDialogType.QuitDialog,
    function()
     PopupOKButton.Visible = false
     PopupAcceptButton.Visible = true
     PopupDeclineButton.Visible = true
     PopupAcceptButton.Text = accept
     PopupDeclineButton.Text = decline
     PopupFrame.Visible = true
    end,
    function()
     PopupFrame.Visible = false
    end)
  end)

 if not centerDialogSuccess then
  PopupFrame.Visible = true
  PopupAcceptButton.Text = accept
  PopupDeclineButton.Text = decline
 end

 return true
end
MarketplaceService.ClientLuaDialogRequested:connect(onClientLuaDialogRequested)


local function createDeveloperNotification(notificationTable)
 if type(notificationTable) == 'table' then
  if type(notificationTable.Title) == 'string' and type(notificationTable.Text) == 'string' then
   local iconImage = (type(notificationTable.Icon) == 'string' and notificationTable.Icon or '')
   local duration = (type(notificationTable.Duration) == 'number' and notificationTable.Duration or DEFAULT_NOTIFICATION_DURATION)
   local success, bindable = pcall(function() return (notificationTable.Callback:IsA('BindableFunction') and notificationTable.Callback or nil) end)
   local button1Text = (type(notificationTable.Button1) == 'string' and notificationTable.Button1 or '')
   local button2Text = (type(notificationTable.Button2) == 'string' and notificationTable.Button2 or '')
   sendNotifcation(notificationTable.Title, notificationTable.Text, iconImage, duration, bindable, button1Text, button2Text)
  end
 end
end

if allowDisableNotifications then
 game:WaitForChild('StarterGui'):RegisterSetCore('PointsNotificationsActive', function(value) if type(value) == 'boolean' then pointsNotificationsActive = value end end)
 game:WaitForChild('StarterGui'):RegisterSetCore('BadgesNotificationsActive', function(value) if type(value) == 'boolean' then badgesNotificationsActive = value end end)
else
 game:WaitForChild('StarterGui'):RegisterSetCore('PointsNotificationsActive', function() end)
 game:WaitForChild('StarterGui'):RegisterSetCore('BadgesNotificationsActive', function() end)
end

game:WaitForChild('StarterGui'):RegisterGetCore('PointsNotificationsActive', function() return pointsNotificationsActive end)
game:WaitForChild('StarterGui'):RegisterGetCore('BadgesNotificationsActive', function() return badgesNotificationsActive end)

if allowSendNotifications then
 game:WaitForChild('StarterGui'):RegisterSetCore('SendNotification', createDeveloperNotification)
else
 game:WaitForChild('StarterGui'):RegisterSetCore('SendNotification', function() end)
end

if not isTenFootInterface then
 local gamepadMenu = RobloxGui:WaitForChild('CoreScripts/GamepadMenu')
 local gamepadNotifications = gamepadMenu:FindFirstChild('GamepadNotifications')
 while not gamepadNotifications do
  wait()
  gamepadNotifications = gamepadMenu:FindFirstChild('GamepadNotifications')
 end

 local leaveNotificationFunc = function(name, state, inputObject)
  if state ~= Enum.UserInputState.Begin then return end

  if GuiService.SelectedCoreObject:IsDescendantOf(NotificationFrame) then
   GuiService.SelectedCoreObject = nil
  end

  ContextActionService:UnbindCoreAction('LeaveNotificationSelection')
 end

 gamepadNotifications.Event:connect(function(isSelected)
  if not isSelected then return end

  isPaused = true
  local notifications = NotificationFrame:GetChildren()
  for i=  1, #notifications do
   local noteComponents = notifications[i]:GetChildren()
   for j=  1, #noteComponents do
    if noteComponents[j]:IsA('GuiButton') and noteComponents[j].Visible then
     GuiService.SelectedCoreObject = noteComponents[j]
     break
    end
   end
  end

  if GuiService.SelectedCoreObject then
   ContextActionService:BindCoreAction('LeaveNotificationSelection', leaveNotificationFunc, false, Enum.KeyCode.ButtonB)
  else
   isPaused = false
   local utility = require(RobloxGui.Modules.Settings.Utility)
   local okPressedFunc = function() end
   utility:ShowAlert('You have no notifications', 'Ok', settingsHub, okPressedFunc, true)
  end
 end)

 GuiService.Changed:connect(function(prop)
  if prop == 'SelectedCoreObject' then
   if not GuiService.SelectedCoreObject or not GuiService.SelectedCoreObject:IsDescendantOf(NotificationFrame) then
    isPaused = false
   end
  end
 end)
end

local UserInputService = game:GetService('UserInputService')
local Platform = UserInputService:GetPlatform()
local Modules = RobloxGui:FindFirstChild('Modules')
if Platform == Enum.Platform.XBoxOne then


 local PlatformService = nil
 pcall(function() PlatformService = game:GetService('PlatformService') end)
 if PlatformService and Modules then
  local controllerStateManager = require(Modules:FindFirstChild('ControllerStateManager'))
  if controllerStateManager then
   controllerStateManager:Initialize()



   controllerStateManager:CheckUserConnected()
  end
 end
end

-- chunk: =CoreGui.RobloxGui.CoreScripts/PurchasePromptScript2 coverage=624/17316 consts=322
-- subst=0
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed








local GuiService = game:GetService('GuiService')
local HttpService = game:GetService('HttpService')
local HttpRbxApiService = game:GetService('HttpRbxApiService')
local InsertService = game:GetService('InsertService')
local MarketplaceService = game:GetService('MarketplaceService')
local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')


local RobloxGui = script.Parent
local ThirdPartyProductName = nil


local platform = UserInputService:GetPlatform()
local IsNativePurchasing = platform == Enum.Platform.XBoxOneor
       platform == Enum.Platform.IOSor
       platform == Enum.Platform.Androidor
       platform == Enum.Platform.UWP

local IsCurrentlyPrompting = false
local IsCurrentlyPurchasing = false
local IsPurchasingConsumable = false
local IsCheckingPlayerFunds = false
RobloxGui:WaitForChild('Modules'):WaitForChild('TenFootInterface')
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local isTenFootInterface = TenFootInterface:IsEnabled()
local freezeControllerActionName = 'doNothingActionPrompt'
local freezeThumbstick1Name = 'doNothingThumbstickPrompt'
local freezeThumbstick2Name = 'doNothingThumbstickPrompt'
local _,largeFont = pcall(function() return Enum.FontSize.Size42 end)
largeFont = largeFont or Enum.FontSize.Size36
local scaleFactor = 3
local purchaseState = nil


local PurchaseData = {
 AssetId = nil,
 ProductId = nil,
 CurrencyType = nil,
 EquipOnPurchase = nil,
 ProductInfo = nil,
 ItemDescription = nil
}


local BASE_URL = game:GetService('ContentProvider').BaseUrl:lower()
BASE_URL = string.gsub(BASE_URL, '/m.', '/www.')
local THUMBNAIL_URL = BASE_URL..'thumbs/asset.ashx?assetid='

local BG_IMAGE = 'rbxasset://textures/ui/Modal.png'
local PURCHASE_BG = 'rbxasset://textures/ui/LoadingBKG.png'
local BUTTON_LEFT = 'rbxasset://textures/ui/ButtonLeft.png'
local BUTTON_LEFT_DOWN = 'rbxasset://textures/ui/ButtonLeftDown.png'
local BUTTON_RIGHT = 'rbxasset://textures/ui/ButtonRight.png'
local BUTTON_RIGHT_DOWN = 'rbxasset://textures/ui/ButtonRightDown.png'
local BUTTON = 'rbxasset://textures/ui/SingleButton.png'
local BUTTON_DOWN = 'rbxasset://textures/ui/SingleButtonDown.png'
local ROBUX_ICON = 'rbxasset://textures/ui/RobuxIcon.png'
local TIX_ICON = 'rbxasset://textures/ui/TixIcon.png'
local ERROR_ICON = 'rbxasset://textures/ui/ErrorIcon.png'
local A_BUTTON = 'rbxasset://textures/ui/Settings/Help/AButtonDark.png'
local B_BUTTON = 'rbxasset://textures/ui/Settings/Help/BButtonDark.png'
local DEFAULT_XBOX_IMAGE = 'rbxasset://textures/ui/Shell/Icons/ROBUXIcon@1080.png'

local CONTROLLER_CONFIRM_ACTION_NAME = 'CoreScriptPurchasePromptControllerConfirm'
local CONTROLLER_CANCEL_ACTION_NAME = 'CoreScriptPurchasePromptControllerCancel'
local GAMEPAD_BUTTONS = {}

local ERROR_MSG = {
 PURCHASE_DISABLED = 'In-game purchases are temporarily disabled',
 INVALID_FUNDS = 'your account does not have enough ROBUX',
 UNKNOWN = 'ROBLOX is performing maintenance',
 UNKNWON_FAILURE = 'something went wrong'
}
local PURCHASE_MSG = {
 SUCCEEDED = 'Your purchase of itemName succeeded!',
 FAILED = 'Your purchase of itemName failed because errorReason. Your account has not been charged. Please try again later.',
 PURCHASE = 'Want to buy the assetType\nitemName for',
 PURCHASE_TIX = 'Want to buy the assetType\nitemName for',
 FREE = 'Would you like to take the assetType itemName for FREE?',
 FREE_BALANCE = 'Your account balance will not be affected by this transaction.',
 BALANCE_FUTURE = 'Your balance after this transaction will be ',
 BALANCE_NOW = 'Your balance is now ',
 ALREADY_OWN = 'You already own this item. Your account has not been charged.'
}
local PURCHASE_FAILED = {
 DEFAULT_ERROR = 0,
 IN_GAME_PURCHASE_DISABLED = 1,
 CANNOT_GET_BALANCE = 2,
 CANNOT_GET_ITEM_PRICE = 3,
 NOT_FOR_SALE = 4,
 NOT_ENOUGH_TIX = 5,
 UNDER_13 = 6,
 LIMITED = 7,
 DID_NOT_BUY_ROBUX = 8,
 PROMPT_PURCHASE_ON_GUEST = 9,
 THIRD_PARTY_DISABLED = 10
}
local PURCHASE_STATE = {
 DEFAULT = 1,
 FAILED = 2,
 SUCCEEDED = 3,
 BUYITEM = 4,
 BUYROBUX = 5,
 BUYINGROBUX = 6,
 BUYBC = 7
}
local BC_LVL_TO_STRING = {
 'Builders Club',
 'Turbo Builders Club',
 'Outrageous Builders Club'
}
local ASSET_TO_STRING = {[
  1] =  'Image',[
  2] =  'T-Shirt',[
  3] =  'Audio',[
  4] =  'Mesh',[
  5] =  'Lua',[
  6] =  'HTML',[
  7] =  'Text',[
  8] =  'Hat',[
  9] =  'Place',[
  10] = 'Model',[
  11] = 'Shirt',[
  12] = 'Pants',[
  13] = 'Decal',[
  16] = 'Avatar',[
  17] = 'Head',[
  18] = 'Face',[
  19] = 'Gear',[
  21] = 'Badge',[
  22] = 'Group Emblem',[
  24] = 'Animation',[
  25] = 'Arms',[
  26] = 'Legs',[
  27] = 'Torso',[
  28] = 'Right Arm',[
  29] = 'Left Arm',[
  30] = 'Left Leg',[
  31] = 'Right Leg',[
  32] = 'Package',[
  33] = 'YouTube Video',[

  34] = 'Game Pass',[
  38] = 'Plugin',[
  0] =  'Product'
}
local BC_ROBUX_PRODUCTS = { 90, 180, 270, 360, 450, 1000, 2750 }
local NON_BC_ROBUX_PRODUCTS = { 80, 160, 240, 320, 400, 800, 2000 }

local DIALOG_SIZE = UDim2.new(0, 324, 0, 180)
local DIALOG_SIZE_TENFOOT = UDim2.new(0, 324*scaleFactor, 0, 180*scaleFactor)
local SHOW_POSITION = UDim2.new(0.5, -162, 0.5, -90)
local SHOW_POSITION_TENFOOT = UDim2.new(0.5, -162*scaleFactor, 0.5, -90*scaleFactor)
local HIDE_POSITION = UDim2.new(0.5, -162, 0, -181)
local HIDE_POSITION_TENFOOT = UDim2.new(0.5, -162*scaleFactor, 0, -180*scaleFactor - 1)
local BTN_SIZE = UDim2.new(0, 162, 0, 44)
local BTN_SIZE_TENFOOT = UDim2.new(0, 162*scaleFactor, 0, 44*scaleFactor)
local BODY_SIZE = UDim2.new(0, 324, 0, 136)
local BODY_SIZE_TENFOOT = UDim2.new(0, 324*scaleFactor, 0, 136*scaleFactor)
local TWEEN_TIME = 0.29999999999999999

local BTN_L_POS = UDim2.new(0, 0, 0, 136)
local BTN_L_POS_TENFOOT = UDim2.new(0, 0, 0, 136*scaleFactor)
local BTN_R_POS = UDim2.new(0.5, 0, 0, 136)
local BTN_R_POS_TENFOOT = UDim2.new(0.5, 0, 0, 136*scaleFactor)


local function lerp( start, finish, t)
 return (1 - t) * start + t * finish
end

local function formatNumber(value)
 return tostring(value):reverse():gsub('%d%d%d', '%1,'):reverse():gsub('^,', '')
end


local function createFrame(name, size, position, bgTransparency, bgColor)
 local frame = Instance.new('Frame')
 frame.Name = name
 frame.Size = size
 frame.Position = position or UDim2.new(0, 0, 0, 0)
 frame.BackgroundTransparency = bgTransparency
 frame.BackgroundColor3 = bgColor or Color3.new()
 frame.BorderSizePixel = 0
 frame.ZIndex = 8

 return frame
end

local function createTextLabel(name, size, position, font, fontSize, text)
 local textLabel = Instance.new('TextLabel')
 textLabel.Name = name
 textLabel.Size = size or UDim2.new(0, 0, 0, 0)
 textLabel.Position = position
 textLabel.BackgroundTransparency = 1
 textLabel.Font = font
 textLabel.FontSize = fontSize
 textLabel.TextColor3 = Color3.new(1, 1, 1)
 textLabel.Text = text
 textLabel.ZIndex = 8

 return textLabel
end

local function createImageLabel(name, size, position, image)
 local imageLabel = Instance.new('ImageLabel')
 imageLabel.Name = name
 imageLabel.Size = size
 imageLabel.BackgroundTransparency = 1
 imageLabel.Position = position
 imageLabel.Image = image

 return imageLabel
end

local function createImageButtonWithText(name, position, image, imageDown, text, font)
 local imageButton = Instance.new('ImageButton')
 imageButton.Name = name
 imageButton.Size = isTenFootInterface and BTN_SIZE_TENFOOT or BTN_SIZE
 imageButton.Position = position
 imageButton.Image = image
 imageButton.BackgroundTransparency = 1
 imageButton.AutoButtonColor = false
 imageButton.ZIndex = 8
 imageButton.Modal = true

 local textLabel = createTextLabel(name..'Text', UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), font, isTenFootInterface and largeFont or Enum.FontSize.Size24, text)
 textLabel.ZIndex = 9
 textLabel.Parent = imageButton

 imageButton.MouseEnter:connect(function()
  imageButton.Image = imageDown
 end)
 imageButton.MouseLeave:connect(function()
  imageButton.Image = image
 end)
 imageButton.MouseButton1Click:connect(function()
  imageButton.Image = image
 end)

 return imageButton
end


local PurchaseDialog = isTenFootInterface and createFrame('PurchaseDialog', DIALOG_SIZE_TENFOOT, HIDE_POSITION_TENFOOT, 1, nil) or createFrame('PurchaseDialog', DIALOG_SIZE, HIDE_POSITION, 1, nil)
PurchaseDialog.Visible = false
PurchaseDialog.Parent = RobloxGui

 local ContainerFrame = createFrame('ContainerFrame', UDim2.new(1, 0, 1, 0), nil, 1, nil)
 ContainerFrame.Parent = PurchaseDialog

  local ContainerImage = createImageLabel('ContainerImage', isTenFootInterface and BODY_SIZE_TENFOOT or BODY_SIZE, UDim2.new(0, 0, 0, 0), BG_IMAGE)
  ContainerImage.ZIndex = 8
  ContainerImage.Parent = ContainerFrame

  local ItemPreviewImage = isTenFootInterface and createImageLabel('ItemPreviewImage', UDim2.new(0, 64*scaleFactor, 0, 64*scaleFactor), UDim2.new(0, 27*scaleFactor, 0, 20*scaleFactor), '') or createImageLabel('ItemPreviewImage', UDim2.new(0, 64, 0, 64), UDim2.new(0, 27, 0, 20), '')
  ItemPreviewImage.ZIndex = 9
  ItemPreviewImage.Parent = ContainerFrame

  local ItemDescriptionText = createTextLabel('ItemDescriptionText', isTenFootInterface and UDim2.new(0, 210*scaleFactor - 20, 0, 96*scaleFactor) or UDim2.new(0, 210, 0, 96), isTenFootInterface and UDim2.new(0, 110*scaleFactor, 0, 18*scaleFactor) or UDim2.new(0, 110, 0, 18),
   Enum.Font.SourceSans, isTenFootInterface and Enum.FontSize.Size48 or Enum.FontSize.Size18, PURCHASE_MSG.PURCHASE)
  ItemDescriptionText.TextXAlignment = Enum.TextXAlignment.Left
  ItemDescriptionText.TextYAlignment = Enum.TextYAlignment.Top
  ItemDescriptionText.TextWrapped = true
  ItemDescriptionText.Parent = ContainerFrame

  local RobuxIcon = createImageLabel('RobuxIcon', isTenFootInterface and UDim2.new(0, 20*scaleFactor, 0, 20*scaleFactor) or UDim2.new(0, 20, 0, 20), UDim2.new(0, 0, 0, 0), ROBUX_ICON)
  RobuxIcon.ZIndex = 9
  RobuxIcon.Visible = false
  RobuxIcon.Parent = ContainerFrame

  local TixIcon = createImageLabel('TixIcon', isTenFootInterface and UDim2.new(0, 20*scaleFactor, 0, 20*scaleFactor) or UDim2.new(0, 20, 0, 20), UDim2.new(0, 0, 0, 0), TIX_ICON)
  TixIcon.ZIndex = 9
  TixIcon.Visible = false
  TixIcon.Parent = ContainerFrame

  local CostText = createTextLabel('CostText', UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0),
   Enum.Font.SourceSansBold, isTenFootInterface and largeFont or Enum.FontSize.Size18, '')
  CostText.TextXAlignment = Enum.TextXAlignment.Left
  CostText.Visible = false
  CostText.Parent = ContainerFrame

  local PostBalanceText = createTextLabel('PostBalanceText', UDim2.new(1, -20, 0, 30), isTenFootInterface and UDim2.new(0, 10, 0, 100*scaleFactor) or UDim2.new(0, 10, 0, 100), Enum.Font.SourceSans,
   isTenFootInterface and Enum.FontSize.Size36 or Enum.FontSize.Size14, '')
  PostBalanceText.TextWrapped = true
  PostBalanceText.Parent = ContainerFrame

  local BuyButton = createImageButtonWithText('BuyButton', isTenFootInterface and BTN_L_POS_TENFOOT or BTN_L_POS, BUTTON_LEFT, BUTTON_LEFT_DOWN, 'Buy Now', Enum.Font.SourceSansBold)
  BuyButton.Parent = ContainerFrame
  local BuyButtonText = BuyButton:FindFirstChild('BuyButtonText')

  local gamepadButtonXLocation = (BuyButton.AbsoluteSize.X/2 - BuyButtonText.TextBounds.X/2)/2
  local buyButtonGamepadImage = Instance.new('ImageLabel')
  buyButtonGamepadImage.BackgroundTransparency = 1
  buyButtonGamepadImage.Image = A_BUTTON
  buyButtonGamepadImage.Size = UDim2.new(1, -8, 1, -8)
  buyButtonGamepadImage.SizeConstraint = Enum.SizeConstraint.RelativeYY
  buyButtonGamepadImage.Parent = BuyButton
  buyButtonGamepadImage.Position = UDim2.new(0, gamepadButtonXLocation - buyButtonGamepadImage.AbsoluteSize.X/2, 0, 5)
  buyButtonGamepadImage.Visible = false
  buyButtonGamepadImage.ZIndex = BuyButton.ZIndex
  table.insert(GAMEPAD_BUTTONS, buyButtonGamepadImage)

  local CancelButton = createImageButtonWithText('CancelButton', isTenFootInterface and BTN_R_POS_TENFOOT or BTN_R_POS, BUTTON_RIGHT, BUTTON_RIGHT_DOWN, 'Cancel', Enum.Font.SourceSans)
  CancelButton.Parent = ContainerFrame

  local cancelButtonGamepadImage = buyButtonGamepadImage:Clone()
  cancelButtonGamepadImage.Image = B_BUTTON
  cancelButtonGamepadImage.ZIndex = CancelButton.ZIndex
  cancelButtonGamepadImage.Parent = CancelButton
  table.insert(GAMEPAD_BUTTONS, cancelButtonGamepadImage)

  local BuyRobuxButton = createImageButtonWithText('BuyRobuxButton', isTenFootInterface and BTN_L_POS_TENFOOT or BTN_L_POS, BUTTON_LEFT, BUTTON_LEFT_DOWN, IsNativePurchasing and 'Buy' or 'Buy R$',
   Enum.Font.SourceSansBold)
  BuyRobuxButton.Visible = false
  BuyRobuxButton.Parent = ContainerFrame

  local buyRobuxGamepadImage = buyButtonGamepadImage:Clone()
  buyRobuxGamepadImage.ZIndex = BuyRobuxButton.ZIndex
  buyRobuxGamepadImage.Parent = BuyRobuxButton
  table.insert(GAMEPAD_BUTTONS, buyRobuxGamepadImage)

  local BuyBCButton = createImageButtonWithText('BuyBCButton', isTenFootInterface and BTN_L_POS_TENFOOT or BTN_L_POS, BUTTON_LEFT, BUTTON_LEFT_DOWN, 'Upgrade', Enum.Font.SourceSansBold)
  BuyBCButton.Visible = false
  BuyBCButton.Parent = ContainerFrame

  local buyBCGamepadImage = buyButtonGamepadImage:Clone()
  buyBCGamepadImage.ZIndex = BuyBCButton.ZIndex
  buyBCGamepadImage.Parent = BuyBCButton
  table.insert(GAMEPAD_BUTTONS, buyBCGamepadImage)

  local FreeButton = createImageButtonWithText('FreeButton', isTenFootInterface and BTN_L_POS_TENFOOT or BTN_L_POS, BUTTON_LEFT, BUTTON_LEFT_DOWN, 'Take Free', Enum.Font.SourceSansBold)
  FreeButton.Visible = false
  FreeButton.Parent = ContainerFrame

  local OkButton = createImageButtonWithText('OkButton', isTenFootInterface and UDim2.new(0, 2, 0, 136*scaleFactor) or UDim2.new(0, 2, 0, 136), BUTTON, BUTTON_DOWN, 'OK', Enum.Font.SourceSans)
  OkButton.Size = isTenFootInterface and UDim2.new(0, 320*scaleFactor, 0, 44*scaleFactor) or UDim2.new(0, 320, 0, 44)
  OkButton.Visible = false
  OkButton.Parent = ContainerFrame

  local okButtonGamepadImage = buyButtonGamepadImage:Clone()
  okButtonGamepadImage.ZIndex = OkButton.ZIndex
  okButtonGamepadImage.Parent = OkButton
  table.insert(GAMEPAD_BUTTONS, okButtonGamepadImage)

  local OkPurchasedButton = createImageButtonWithText('OkPurchasedButton', isTenFootInterface and UDim2.new(0, 2, 0, 136*scaleFactor) or UDim2.new(0, 2, 0, 136), BUTTON, BUTTON_DOWN, 'OK', Enum.Font.SourceSans)
  OkPurchasedButton.Size = isTenFootInterface and UDim2.new(0, 320*scaleFactor, 0, 44*scaleFactor) or UDim2.new(0, 320, 0, 44)
  OkPurchasedButton.Visible = false
  OkPurchasedButton.Parent = ContainerFrame

  local okPurchasedGamepadImage = buyButtonGamepadImage:Clone()
  okPurchasedGamepadImage.ZIndex = OkPurchasedButton.ZIndex
  okPurchasedGamepadImage.Parent = OkPurchasedButton
  table.insert(GAMEPAD_BUTTONS, okPurchasedGamepadImage)

 local PurchaseFrame = createImageLabel('PurchaseFrame', UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), PURCHASE_BG)
 PurchaseFrame.ZIndex = 8
 PurchaseFrame.Visible = false
 PurchaseFrame.Parent = PurchaseDialog

  local PurchaseText = createTextLabel('PurchaseText', nil, UDim2.new(0.5, 0, 0.5, -36), Enum.Font.SourceSans,
   isTenFootInterface and largeFont or Enum.FontSize.Size36, 'Purchasing')
  PurchaseText.Parent = PurchaseFrame

  local LoadingFrames = {}
  local xOffset = -40
  for i=  1, 3 do
   local frame = createFrame('Loading', UDim2.new(0, 16, 0, 16), UDim2.new(0.5, xOffset, 0.5, 0), 0, Color3.new(132/255, 132/255, 132/255))
   table.insert(LoadingFrames, frame)
   frame.Parent = PurchaseFrame
   xOffset = xOffset + 32
  end


local function noOpFunc() end

local function enableControllerMovement()
 game:GetService('ContextActionService'):UnbindCoreAction(freezeThumbstick1Name)
 game:GetService('ContextActionService'):UnbindCoreAction(freezeThumbstick2Name)
 game:GetService('ContextActionService'):UnbindCoreAction(freezeControllerActionName)
end

local function disableControllerMovement()
 game:GetService('ContextActionService'):BindCoreAction(freezeControllerActionName, noOpFunc, false, Enum.UserInputType.Gamepad1)
 game:GetService('ContextActionService'):BindCoreAction(freezeThumbstick1Name, noOpFunc, false, Enum.KeyCode.Thumbstick1)
 game:GetService('ContextActionService'):BindCoreAction(freezeThumbstick2Name, noOpFunc, false, Enum.KeyCode.Thumbstick2)
end


local function getCurrencyString(currencyType)
 return currencyType == Enum.CurrencyType.Tix and 'Tix' or 'R$'
end

local function setInitialPurchaseData(assetId, productId, currencyType, equipOnPurchase)
 PurchaseData.AssetId = assetId
 PurchaseData.ProductId = productId
 PurchaseData.CurrencyType = currencyType
 PurchaseData.EquipOnPurchase = equipOnPurchase

 IsPurchasingConsumable = productId ~= nil
end

local function setCurrencyData(playerBalance)
 local priceInRobux = tonumber(PurchaseData.ProductInfo['PriceInRobux'])
 local priceInTickets = tonumber(PurchaseData.ProductInfo['PriceInTickets'])

 if PurchaseData.CurrencyType == Enum.CurrencyType.Default or PurchaseData.CurrencyType == Enum.CurrencyType.Robux then
  if priceInRobux and priceInRobux ~= 0 then
   PurchaseData.CurrencyAmount = priceInRobux
   PurchaseData.CurrencyType = Enum.CurrencyType.Robux
  else
   PurchaseData.CurrencyAmount = priceInTickets
   PurchaseData.CurrencyType = Enum.CurrencyType.Tix
  end
 elseif PurchaseData.CurrencyType == Enum.CurrencyType.Tix then
  if priceInTickets and priceInTickets ~= 0 then
   PurchaseData.CurrencyAmount = priceInTickets
  else
   PurchaseData.CurrencyAmount = priceInRobux
   PurchaseData.CurrencyType = Enum.CurrencyType.Robux
  end
 end
end

local function setPreviewImageXbox(productInfo, assetId)

 local id = nil
 if IsPurchasingConsumable and productInfo and productInfo['IconImageAssetId'] then
  id = productInfo['IconImageAssetId']
 elseif assetId then
  id = assetId
 else
  ItemPreviewImage.Image = DEFAULT_XBOX_IMAGE
  return
 end

 local path = 'asset-thumbnail/json?assetId=%d&width=100&height=100&format=png'
 path = BASE_URL..string.format(path, id)
 spawn(function()


  local success, result = pcall(function()
   return game:HttpGetAsync(path)
  end)
  if not success then
   ItemPreviewImage.Image = DEFAULT_XBOX_IMAGE
   return
  end

  local decodeSuccess, decodeResult = pcall(function()
   return HttpService:JSONDecode(result)
  end)
  if not decodeSuccess then
   ItemPreviewImage.Image = DEFAULT_XBOX_IMAGE
   return
  end

  if decodeResult['Final'] == true then
   ItemPreviewImage.Image = THUMBNAIL_URL..tostring(id)..'&x=100&y=100&format=png'
  else
   ItemPreviewImage.Image = DEFAULT_XBOX_IMAGE
  end
 end)
end

local function setPreviewImage(productInfo, assetId)

 if platform == Enum.Platform.XBoxOne then
  setPreviewImageXbox(productInfo, assetId)
  return
 end
 if IsPurchasingConsumable then
  if productInfo then
   ItemPreviewImage.Image = THUMBNAIL_URL..tostring(productInfo['IconImageAssetId']..'&x=100&y=100&format=png')
  end
 else
  if assetId then
   ItemPreviewImage.Image = THUMBNAIL_URL..tostring(assetId)..'&x=100&y=100&format=png'
  end
 end
end

local function clearPurchaseData()
 for k,v in pairs(PurchaseData) do
  PurchaseData[k] = nil
 end
 RobuxIcon.Visible = false
 TixIcon.Visible = false
 CostText.Visible = false
end


local function setButtonsVisible(...)
 local args = {...}
 local argCount = select('#', ...)

 for _,child in pairs(ContainerFrame:GetChildren()) do
  if child:IsA('ImageButton') then
   child.Visible = false
   for i=  1, argCount do
    if child == args[i] then
     child.Visible = true
    end
   end
  end
 end
end

local function tweenBackgroundColor(frame, endColor, duration)
 local t = 0
 local prevTime = tick()
 local startColor = frame.BackgroundColor3
 while t < duration do
  local s = t / duration
  local r = lerp(startColor.r, endColor.r, s)
  local g = lerp(startColor.g, endColor.g, s)
  local b = lerp(startColor.b, endColor.b, s)
  frame.BackgroundColor3 = Color3.new(r, g, b)

  t = t + (tick() - prevTime)
  prevTime = tick()
  wait()
 end
 frame.BackgroundColor3 = endColor
end

local isPurchaseAnimating = false
local function startPurchaseAnimation()
 if PurchaseFrame.Visible then return end

 ContainerFrame.Visible = false
 PurchaseFrame.Visible = true

 spawn(function()
  isPurchaseAnimating = true
  local i = 1
  while isPurchaseAnimating do
   local frame = LoadingFrames[i]
   local prevPosition = frame.Position
   local newPosition = UDim2.new(prevPosition.X.Scale, prevPosition.X.Offset, prevPosition.Y.Scale, prevPosition.Y.Offset - 2)
   spawn(function()
    tweenBackgroundColor(frame, Color3.new(0, 162/255, 1), 0.25)
   end)
   frame:TweenSizeAndPosition(UDim2.new(0, 16, 0, 20), newPosition, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.25, true, function()
    spawn(function()
     tweenBackgroundColor(frame, Color3.new(132/255, 132/255, 132/255), 0.25)
    end)
    frame:TweenSizeAndPosition(UDim2.new(0, 16, 0, 16), prevPosition, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.25, true)
   end)
   i = i + 1
   if i > 3 then
    i = 1
    wait(0.25)
   end
   wait(0.5)
  end
 end)
end

local function stopPurchaseAnimation()
 isPurchaseAnimating = false
 PurchaseFrame.Visible = false
 ContainerFrame.Visible = true
end

local function setPurchaseDataInGui(isFree, invalidBC)
 local  descriptionText = PurchaseData.CurrencyType == Enum.CurrencyType.Tix and PURCHASE_MSG.PURCHASE_TIX or PURCHASE_MSG.PURCHASE
 if isFree then
  descriptionText = PURCHASE_MSG.FREE
  PostBalanceText.Text = PURCHASE_MSG.FREE_BALANCE
 end

 local productInfo = PurchaseData.ProductInfo
 if not productInfo then
  return false
 end
 local itemDescription = string.gsub(descriptionText, 'itemName', string.sub(productInfo['Name'], 1, 20))
 itemDescription = string.gsub(itemDescription, 'assetType', ASSET_TO_STRING[productInfo['AssetTypeId']] or 'Unknown')
 ItemDescriptionText.Text = itemDescription

 if not isFree then
  if PurchaseData.CurrencyType == Enum.CurrencyType.Tix then
   TixIcon.Visible = true
   TixIcon.Position = UDim2.new(0, isTenFootInterface and 110*scaleFactor or 110, 0, ItemDescriptionText.Position.Y.Offset + ItemDescriptionText.TextBounds.y + (isTenFootInterface and 6*scaleFactor or 6))
   CostText.TextColor3 = Color3.new(204/255, 158/255, 113/255)
  else
   RobuxIcon.Visible = true
   RobuxIcon.Position = UDim2.new(0, isTenFootInterface and 110*scaleFactor or 110, 0, ItemDescriptionText.Position.Y.Offset + ItemDescriptionText.TextBounds.y + (isTenFootInterface and 6*scaleFactor or 6))
   CostText.TextColor3 = Color3.new(2/255, 183/255, 87/255)
  end
  CostText.Text = formatNumber(PurchaseData.CurrencyAmount)
  CostText.Position = UDim2.new(0, isTenFootInterface and 134*scaleFactor or 134, 0, ItemDescriptionText.Position.Y.Offset + ItemDescriptionText.TextBounds.y + (isTenFootInterface and 15*scaleFactor or 15))
  CostText.Visible = true
 end

 setPreviewImage(productInfo, PurchaseData.AssetId)
 purchaseState = PURCHASE_STATE.BUYITEM
 setButtonsVisible(isFree and FreeButton or BuyButton, CancelButton)
 PostBalanceText.Visible = true

 if invalidBC then
  local neededBcLevel = PurchaseData.ProductInfo['MinimumMembershipLevel']
  PostBalanceText.Text = 'This item requires '..BC_LVL_TO_STRING[neededBcLevel]..".\nClick \'Upgrade\' to upgrade your Builders Club!"
  purchaseState = PURCHASE_STATE.BUYBC
  setButtonsVisible(BuyBCButton, CancelButton)
 end
 return true
end

local function getRobuxProduct(amountNeeded, isBCMember)
 local productArray = nil

 if platform == Enum.Platform.XBoxOne then
  productArray = {}
  local platformCatalogData = require(RobloxGui.Modules.PlatformCatalogData)

  local catalogInfo = platformCatalogData:GetCatalogInfoAsync()
  if catalogInfo then
   for _, productInfo in pairs(catalogInfo) do
    local robuxValue = platformCatalogData:ParseRobuxValue(productInfo)
    table.insert(productArray, robuxValue)
   end
  end
 else
  productArray = isBCMember and BC_ROBUX_PRODUCTS or NON_BC_ROBUX_PRODUCTS
 end

 table.sort(productArray, function(a,b) return a < b end)

 for i=  1, #productArray do
  if productArray[i] >= amountNeeded then
   return productArray[i]
  end
 end

 return nil
end

local function getRobuxProductToBuyItem(amountNeeded)
 local isBCMember = Players.LocalPlayer.MembershipType ~= Enum.MembershipType.None

 local productCost = getRobuxProduct(amountNeeded, isBCMember)
 if not productCost then
  return nil
 end




 local isUsingNewProductId = (platform == Enum.Platform.Android) or (platform == Enum.Platform.UWP)

 local prependStr, appendStr, appPrefix = '', '', ''
 if isUsingNewProductId then
  prependStr = 'robux'
  if isBCMember then
   appendStr = 'bc'
  end
  appPrefix = 'com.roblox.client.'
 elseif platform == Enum.Platform.XBoxOne then
  local platformCatalogData = require(RobloxGui.Modules.PlatformCatalogData)

  local catalogInfo = platformCatalogData:GetCatalogInfoAsync()
  if catalogInfo then
   for _, productInfo in pairs(catalogInfo) do
    if platformCatalogData:ParseRobuxValue(productInfo) == productCost then
     return productInfo.ProductId, productCost
    end
   end
  end
 else
  appendStr = isBCMember and 'RobuxBC' or 'RobuxNonBC'
  appPrefix = 'com.roblox.robloxmobile.'
 end

 local productStr = appPrefix..prependStr..tostring(productCost)..appendStr
 return productStr, productCost
end

local function setBuyMoreRobuxDialog(playerBalance)
 local playerBalanceInt = tonumber(playerBalance['robux'])
 local neededRobux = PurchaseData.CurrencyAmount - playerBalanceInt
 local productInfo = PurchaseData.ProductInfo

 local descriptionText = 'You need %s more ROBUX to buy the %s %s'
 descriptionText = string.format(descriptionText, formatNumber(neededRobux), productInfo['Name'], ASSET_TO_STRING[productInfo['AssetTypeId']] or '')

 purchaseState = PURCHASE_STATE.BUYROBUX
 setButtonsVisible(BuyRobuxButton, CancelButton)

 if IsNativePurchasing then
  local productCost = nil
  ThirdPartyProductName, productCost = getRobuxProductToBuyItem(neededRobux)

  if not ThirdPartyProductName then
   descriptionText = 'This item cost more ROBUX than you can purchase. Please visit www.roblox.com to purchase more ROBUX.'
   purchaseState = PURCHASE_STATE.FAILED
   setButtonsVisible(OkButton)
  else
   local remainder = playerBalanceInt + productCost - PurchaseData.CurrencyAmount
   descriptionText = descriptionText..'. Would you like to buy '..formatNumber(productCost)..' ROBUX?'
   PostBalanceText.Text = 'The remaining '..formatNumber(remainder)..' ROBUX will be credited to your balance.'
   PostBalanceText.Visible = true
  end
 else
  descriptionText = descriptionText..'. Would you like to buy more ROBUX?'
 end
 ItemDescriptionText.Text = descriptionText
 setPreviewImage(productInfo, PurchaseData.AssetId)
end

local function showPurchasePrompt()
 stopPurchaseAnimation()
 PurchaseDialog.Visible = true
 if isTenFootInterface then
  UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
 end
 PurchaseDialog:TweenPosition(isTenFootInterface and SHOW_POSITION_TENFOOT or SHOW_POSITION, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, TWEEN_TIME, true)
 disableControllerMovement()
 enableControllerInput()
end


local function onPurchaseFailed(failType)
 setButtonsVisible(OkButton)
 ItemPreviewImage.Image = ERROR_ICON
 PostBalanceText.Text = ''

 local itemName = PurchaseData.ProductInfo and PurchaseData.ProductInfo['Name'] or ''
 local failedText = string.gsub(PURCHASE_MSG.FAILED, 'itemName', string.sub(itemName, 1, 20))

 if itemName == '' then
  failedText = string.gsub(failedText, ' of ', '')
 end

 if failType == PURCHASE_FAILED.DEFAULT_ERROR then
  failedText = string.gsub(failedText, 'errorReason', ERROR_MSG.UNKNWON_FAILURE)
 elseif failType == PURCHASE_FAILED.IN_GAME_PURCHASE_DISABLED then
  failedText = string.gsub(failedText, 'errorReason', ERROR_MSG.PURCHASE_DISABLED)
 elseif failType == PURCHASE_FAILED.CANNOT_GET_BALANCE then
  failedText = 'Cannot retrieve your balance at this time. Your account has not been charged. Please try again later.'
 elseif failType == PURCHASE_FAILED.CANNOT_GET_ITEM_PRICE then
  failedText = "We couldn\'t retrieve the price of the item at this time. Your account has not been charged. Please try again later."
 elseif failType == PURCHASE_FAILED.NOT_FOR_SALE then
  failedText = 'This item is not currently for sale. Your account has not been charged.'
  setPreviewImage(PurchaseData.ProductInfo, PurchaseData.AssetId)
 elseif failType == PURCHASE_FAILED.NOT_ENOUGH_TIX then
  failedText = 'This item cost more tickets than you currently have. Try trading currency on www.roblox.com to get more tickets.'
  setPreviewImage(PurchaseData.ProductInfo, PurchaseData.AssetId)
 elseif failType == PURCHASE_FAILED.UNDER_13 then
  failedText = 'Your account is under 13. Purchase of this item is not allowed. Your account has not been charged.'
 elseif failType == PURCHASE_FAILED.LIMITED then
  failedText = 'This limited item has no more copies. Try buying from another user on www.roblox.com. Your account has not been charged.'
  setPreviewImage(PurchaseData.ProductInfo, PurchaseData.AssetId)
 elseif failType == PURCHASE_FAILED.DID_NOT_BUY_ROBUX then
  failedText = string.gsub(failedText, 'errorReason', ERROR_MSG.INVALID_FUNDS)
 elseif failType == PURCHASE_FAILED.PROMPT_PURCHASE_ON_GUEST then
  failedText = 'You need to create a ROBLOX account to buy items, visit www.roblox.com for more info.'
 elseif failType == PURCHASE_FAILED.THIRD_PARTY_DISABLED then
  failedText = 'Third-party item sales have been disabled for this place. Your account has not been charged.'
  setPreviewImage(PurchaseData.ProductInfo, PurchaseData.AssetId)
 end

 RobuxIcon.Visible = false
 TixIcon.Visible = false
 CostText.Visible = false

 purchaseState = PURCHASE_STATE.FAILED

 ItemDescriptionText.Text = failedText
 showPurchasePrompt()
end

local function closePurchaseDialog()
 PurchaseDialog:TweenPosition(isTenFootInterface and HIDE_POSITION_TENFOOT or HIDE_POSITION, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, TWEEN_TIME, true, function()
   PurchaseDialog.Visible = false
   IsCurrentlyPrompting = false
   IsCurrentlyPurchasing = false
   IsCheckingPlayerFunds = false
   purchaseState = PURCHASE_STATE.DEFAULT
   if isTenFootInterface then
    UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
   end
  end)
end


local function onPromptEnded(isSuccess)
 local didPurchase = (purchaseState == PURCHASE_STATE.SUCCEEDED)

 closePurchaseDialog()
 if IsPurchasingConsumable then
  MarketplaceService:SignalPromptProductPurchaseFinished(Players.LocalPlayer.userId, PurchaseData.ProductId, didPurchase)
 else
  MarketplaceService:SignalPromptPurchaseFinished(Players.LocalPlayer, PurchaseData.AssetId, didPurchase)
 end
 clearPurchaseData()
 enableControllerMovement()
 disableControllerInput()
end


local function isMarketplaceDown()
 local success, result = pcall(function() return settings():GetFFlag('Order66') end)
 if not success then
  print('PurchasePromptScript: isMarketplaceDown failed because', result)
  return false
 end

 return result
end

local function checkMarketplaceAvailable()
 local success, result = pcall(function() return settings():GetFFlag('CheckMarketplaceAvailable') end)
 if not success then
  print('PurchasePromptScript: checkMarketplaceAvailable failed because', result)
  return false
 end

 return result
end

local function areThirdPartySalesRestricted()
 local success, result = pcall(function() return settings():GetFFlag('RestrictSales') end)
 if not success then
  print('PurchasePromptScript: areThirdPartySalesRestricted failed because', result)
  return false
 end

 return result
end



local function isMarketplaceAvailable()
 local success, result = pcall(function()
  return HttpRbxApiService:GetAsync('my/economy-status', false,
   Enum.ThrottlingPriority.Extreme)
 end)
 if not success then
  print('PurchasePromptScript: isMarketplaceAvailable() failed because', result)
  return false
 end
 result = HttpService:JSONDecode(result)
 if result['isMarketplaceEnabled'] ~= nil then
  if result['isMarketplaceEnabled'] == false then
   return true, false
  end
 end
 return true, true
end

local function getProductInfo()
 local success, result = nil, nil
 if IsPurchasingConsumable then
  success, result = pcall(function()
   return MarketplaceService:GetProductInfo(PurchaseData.ProductId, Enum.InfoType.Product)
  end)
 else
  success, result = pcall(function()
   return MarketplaceService:GetProductInfo(PurchaseData.AssetId)
  end)
 end

 if not success or not result then
  print('PurchasePromptScript: getProductInfo failed because', result)
  return nil
 end

 if type(result) ~= 'table' then
  result = HttpService:JSONDecode(result)
 end

 return result
end


local function doesPlayerOwnItem()
 if not PurchaseData.AssetId or PurchaseData.AssetId <= 0 then
  return false, nil
 end

 local success, result = pcall(function()
  local apiPath = 'ownership/hasAsset'
  local params = '?userId='..tostring(Players.LocalPlayer.userId)..'&assetId='..tostring(PurchaseData.AssetId)
  return HttpRbxApiService:GetAsync(apiPath..params, true)
 end)

 if not success then
  print('PurchasePromptScript: doesPlayerOwnItem() failed because', result)
  return false, nil
 end

 if result == true or result == 'true' then
  return true, true
 end

 return true, false
end

local function isFreeItem()
 return PurchaseData.ProductInfo and PurchaseData.ProductInfo['IsPublicDomain'] == true
end

local function getPlayerBalance()
 local apiPath = platform == Enum.Platform.XBoxOne and 'my/platform-currency-budget' or 'currency/balance'

 local success, result = pcall(function()
  return HttpRbxApiService:GetAsync(apiPath, true)
 end)

 if not success then
  print('PurchasePromptScript: getPlayerBalance() failed because', result)
  return nil
 end

 if result == '' then return end

 result = HttpService:JSONDecode(result)
 if platform == Enum.Platform.XBoxOne then
  result['robux'] = result['Robux']
  result['tickets'] = '0'
 end

 return result
end

local function isNotForSale()
 return PurchaseData.ProductInfo['IsForSale'] == false and PurchaseData.ProductInfo['IsPublicDomain'] == false
end

local function playerHasFundsForPurchase(playerBalance)
 local currencyTypeStr = nil
 if PurchaseData.CurrencyType == Enum.CurrencyType.Robux then
  currencyTypeStr = 'robux'
 elseif PurchaseData.CurrencyType == Enum.CurrencyType.Tix then
  currencyTypeStr = 'tickets'
 else
  return false
 end

 local playerBalanceInt = tonumber(playerBalance[currencyTypeStr])
 if not playerBalanceInt then
  return false
 end

 local afterBalanceAmount = playerBalanceInt - PurchaseData.CurrencyAmount
 local currencyStr = getCurrencyString(PurchaseData.CurrencyType)
 if afterBalanceAmount < 0 and PurchaseData.CurrencyType == Enum.CurrencyType.Robux then
  PostBalanceText.Visible = false
  return true, false
 elseif afterBalanceAmount < 0 and PurchaseData.CurrencyType == Enum.CurrencyType.Tix then
  PostBalanceText.Visible = true
  PostBalanceText.Text = 'You need '..formatNumber(-afterBalanceAmount)..' more '..currencyStr..' to buy this item.'
  return true, false
 end

 if PurchaseData.CurrencyType == Enum.CurrencyType.Tix then
  PostBalanceText.Text = PURCHASE_MSG.BALANCE_FUTURE..formatNumber(afterBalanceAmount)..' '..currencyStr..'.'
 else
  PostBalanceText.Text = PURCHASE_MSG.BALANCE_FUTURE..currencyStr..formatNumber(afterBalanceAmount)..'.'
 end

 return true, true
end

local function isUnder13()
 if PurchaseData.ProductInfo['ContentRatingTypeId'] == 1 then
  if Players.LocalPlayer:GetUnder13() then
   return true
  end
 end
 return false
end

local function isLimitedUnique()
 local productInfo = PurchaseData.ProductInfo
 if productInfo then
  if (productInfo['IsLimited'] or productInfo['IsLimitedUnique'])and
   (productInfo['Remaining'] == '' or productInfo['Remaining'] == 0 or productInfo['Remaining'] == nil or productInfo['Remaining'] == 'null') then
   return true
  end
 end
 return false
end


local function canPurchase(disableUpsell)
 if game.Players.LocalPlayer.userId < 0 then
  onPurchaseFailed(PURCHASE_FAILED.PROMPT_PURCHASE_ON_GUEST)
  return false
 end

 if isMarketplaceDown() then
  onPurchaseFailed(PURCHASE_FAILED.IN_GAME_PURCHASE_DISABLED)
  return false
 end

 if checkMarketplaceAvailable() then
  local success, isAvailable = isMarketplaceAvailable()
  if success then
   if not isAvailable then
    onPurchaseFailed(PURCHASE_FAILED.IN_GAME_PURCHASE_DISABLED)
    return false
   end
  else
   onPurchaseFailed(PURCHASE_FAILED.DEFAULT_ERROR)
   return false
  end
 end

 PurchaseData.ProductInfo = getProductInfo()
 if not PurchaseData.ProductInfo then
  onPurchaseFailed(PURCHASE_FAILED.IN_GAME_PURCHASE_DISABLED)
  return false
 end

 if isNotForSale() then
  onPurchaseFailed(PURCHASE_FAILED.NOT_FOR_SALE)
  return false
 end


 local isRestrictedThirdParty = false
 if not IsPurchasingConsumable then
  local success, doesOwnItem = doesPlayerOwnItem()
  if not success then
   onPurchaseFailed(PURCHASE_FAILED.DEFAULT_ERROR)
   return false
  elseif doesOwnItem then
   if not PurchaseData.ProductInfo then
    onPurchaseFailed(PURCHASE_FAILED.DEFAULT_ERROR)
    return false
   end
   purchaseState = PURCHASE_STATE.FAILED
   setPreviewImage(PurchaseData.ProductInfo, PurchaseData.AssetId)
   ItemDescriptionText.Text = PURCHASE_MSG.ALREADY_OWN
   PostBalanceText.Visible = false
   setButtonsVisible(OkButton)
   return true
  end


  if areThirdPartySalesRestricted() and not game:GetService('Workspace').AllowThirdPartySales then
   local ProductCreator = tonumber(PurchaseData.ProductInfo['Creator']['Id'])
   local RobloxCreator = 1
   if ProductCreator ~= game.CreatorId and ProductCreator ~= RobloxCreator then
    isRestrictedThirdParty = true
   end
  end
 end

 local isFree = isFreeItem()

 if not isFree and isRestrictedThirdParty then
  onPurchaseFailed(PURCHASE_FAILED.THIRD_PARTY_DISABLED)
  return false
 end

 local playerBalance = getPlayerBalance()
 if not playerBalance then
  onPurchaseFailed(PURCHASE_FAILED.CANNOT_GET_BALANCE)
  return false
 end


 setCurrencyData(playerBalance)
 if not PurchaseData.CurrencyAmount and not isFree then
  onPurchaseFailed(PURCHASE_FAILED.CANNOT_GET_ITEM_PRICE)
  return false
 end


 local hasFunds = nil
 if not isFree then
  local success = nil
  success, hasFunds = playerHasFundsForPurchase(playerBalance)
  if success then
   if not hasFunds then
    if PurchaseData.CurrencyType == Enum.CurrencyType.Tix then
     onPurchaseFailed(PURCHASE_FAILED.NOT_ENOUGH_TIX)
     return false
    elseif not disableUpsell then
     setBuyMoreRobuxDialog(playerBalance)
    end
   end
  else
   onPurchaseFailed(PURCHASE_FAILED.CANNOT_GET_BALANCE)
   return false
  end
 end


 local invalidBCLevel = PurchaseData.ProductInfo['MinimumMembershipLevel'] > Players.LocalPlayer.MembershipType.Value


 if isUnder13() then
  onPurchaseFailed(PURCHASE_FAILED.UNDER_13)
  return false
 end

 if isLimitedUnique() then
  onPurchaseFailed(PURCHASE_FAILED.LIMITED)
  return false
 end

 if (hasFunds or isFree or invalidBCLevel) then
  if not setPurchaseDataInGui(isFree, invalidBCLevel) then
   onPurchaseFailed(PURCHASE_FAILED.DEFAULT_ERROR)
   return false
  end
 end

 return true
end


local function getToolAsset(assetId)
 local tool = InsertService:LoadAsset(assetId)
 if not tool then return nil end

 if tool:IsA('Tool') then
  return tool
 end

 local children = tool:GetChildren()
 for i=  1, #children do
  if children[i]:IsA('Tool') then
   return children[i]
  end
 end
end

local function onPurchaseSuccess()
 IsCheckingPlayerFunds = false
 local descriptionText = PURCHASE_MSG.SUCCEEDED

 descriptionText = string.gsub(descriptionText, 'itemName', string.sub(PurchaseData.ProductInfo['Name'], 1, 20))
 ItemDescriptionText.Text = descriptionText

 local playerBalance = getPlayerBalance()
 local currencyType = PurchaseData.CurrencyType == Enum.CurrencyType.Tix and 'tickets' or 'robux'
 local newBalance = playerBalance[currencyType]

 if currencyType == 'robux' then
  PostBalanceText.Text = PURCHASE_MSG.BALANCE_NOW..getCurrencyString(PurchaseData.CurrencyType)..formatNumber(newBalance)..'.'
 else
  PostBalanceText.Text = PURCHASE_MSG.BALANCE_NOW..formatNumber(newBalance)..' '..getCurrencyString(PurchaseData.CurrencyType)..'.'
 end

 if isFreeItem() then PostBalanceText.Visible = false end

 purchaseState = PURCHASE_STATE.SUCCEEDED

 setButtonsVisible(OkPurchasedButton)
 stopPurchaseAnimation()
end

local function onAcceptPurchase()
 if IsCurrentlyPurchasing then return end

 if purchaseState ~= PURCHASE_STATE.BUYITEM then
  return
 end


 disableControllerInput()
 IsCurrentlyPurchasing = true
 startPurchaseAnimation()
 local startTime = tick()
 local apiPath = nil
 local params = nil
 local currencyTypeInt = nil
 if PurchaseData.CurrencyType == Enum.CurrencyType.Robux or PurchaseData.CurrencyType == Enum.CurrencyType.Default then
  currencyTypeInt = 1
 elseif PurchaseData.CurrencyType == Enum.CurrencyType.Tix then
  currencyTypeInt = 2
 end

 local productId = PurchaseData.ProductInfo['ProductId']
 if IsPurchasingConsumable then
  apiPath = 'marketplace/submitpurchase'
  params = 'productId='..tostring(productId)..'&currencyTypeId='..tostring(currencyTypeInt)..
   '&expectedUnitPrice='..tostring(PurchaseData.CurrencyAmount)..'&placeId='..tostring(game.PlaceId)
  params = params..'&requestId='..HttpService:UrlEncode(HttpService:GenerateGUID(false))
 else
  apiPath = 'marketplace/purchase'
  params = 'productId='..tostring(productId)..'&currencyTypeId='..tostring(currencyTypeInt)..
   '&purchasePrice='..tostring(PurchaseData.CurrencyAmount or 0)..'&locationType=Game&locationId='..tostring(game.PlaceId)
 end

 local success, result = pcall(function()
  return HttpRbxApiService:PostAsync(apiPath, params, true, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationUrlEncoded)
 end)


 if IsPurchasingConsumable then
  local retries = 3
  local wasSuccess = success and result and result ~= ''
  while retries > 0 and not wasSuccess do
   wait(1)
   retries = retries - 1
   success, result = pcall(function()
    return HttpRbxApiService:PostAsync(apiPath, params, true, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationUrlEncoded)
   end)
   wasSuccess = success and result and result ~= ''
  end

  game:ReportInGoogleAnalytics('Developer Product', 'Purchase',
   wasSuccess and ('success. Retries = '..(3 - retries)) or ('failure: ' .. tostring(result)), 1)
 end

 if tick() - startTime < 1 then wait(1) end

 enableControllerInput()

 if not success then
  print('PurchasePromptScript: onAcceptPurchase() failed because', result)
  onPurchaseFailed(PURCHASE_FAILED.DEFAULT_ERROR)
  return
 end

 result = HttpService:JSONDecode(result)
 if result then
  if result['success'] == false then
   if result['status'] ~= 'AlreadyOwned' then
    print('PurchasePromptScript: onAcceptPurchase() response failed because', tostring(result['status']))
    if result['status'] == 'EconomyDisabled' then
     onPurchaseFailed(PURCHASE_FAILED.IN_GAME_PURCHASE_DISABLED)
    else
     onPurchaseFailed(PURCHASE_FAILED.DEFAULT_ERROR)
    end
    return
   end
  end
 else
  print('PurchasePromptScript: onAcceptPurchase() failed to parse JSON of', productId)
  onPurchaseFailed(PURCHASE_FAILED.DEFAULT_ERROR)
  return
 end

 if PurchaseData.EquipOnPurchase and PurchaseData.AssetId and tonumber(PurchaseData.ProductInfo['AssetTypeId']) == 19 then
  local tool = getToolAsset(tonumber(PurchaseData.AssetId))
  if tool then
   tool.Parent = Players.LocalPlayer.Backpack
  end
 end

 if IsPurchasingConsumable then
  if not result['receipt'] then
   print('PurchasePromptScript: onAcceptPurchase() failed because no dev product receipt was returned for', tostring(productId))
   onPurchaseFailed(PURCHASE_FAILED.DEFAULT_ERROR)
   return
  end
  MarketplaceService:SignalClientPurchaseSuccess(tostring(result['receipt']), Players.LocalPlayer.userId, productId)
 else
  onPurchaseSuccess()
 end
end


local function onPurchasePrompt(player, assetId, equipIfPurchased, currencyType, productId)
 if player == Players.LocalPlayer and not IsCurrentlyPrompting then
  IsCurrentlyPrompting = true
  setInitialPurchaseData(assetId, productId, currencyType, equipIfPurchased)
  if canPurchase() then
   showPurchasePrompt()
  end
 end
end

function hasEnoughMoneyForPurchase()
 local playerBalance = getPlayerBalance()
 if playerBalance then
  local success, hasFunds = nil
  success, hasFunds = playerHasFundsForPurchase(playerBalance)
  return success and hasFunds
 end

 return false
end

function retryPurchase(overrideRetries)
 local canMakePurchase = canPurchase(true) and hasEnoughMoneyForPurchase()
 if not canMakePurchase then
  local retries = 40
  if overrideRetries then
   retries = overrideRetries
  end
  while retries > 0 and not canMakePurchase do
   wait(0.5)
   canMakePurchase = canPurchase(true) and hasEnoughMoneyForPurchase()
   retries = retries - 1
  end
 end

 return canMakePurchase
end

function nativePurchaseFinished(wasPurchased)
 if wasPurchased then
  local isPurchasing = retryPurchase()
  if isPurchasing then
   onAcceptPurchase()
  else
   onPurchaseFailed(PURCHASE_FAILED.DEFAULT_ERROR)
  end
 else
  onPurchaseFailed(PURCHASE_FAILED.DID_NOT_BUY_ROBUX)
  stopPurchaseAnimation()
 end
end

local function onBuyRobuxPrompt()
 if purchaseState ~= PURCHASE_STATE.BUYROBUX then
  return
 end
 if RunService:IsStudio() then
  return
 end

 purchaseState = PURCHASE_STATE.BUYINGROBUX

 startPurchaseAnimation()
 if IsNativePurchasing then
  if platform == Enum.Platform.XBoxOne then
   spawn(function()
    local PlatformService = nil
    pcall(function() PlatformService = Game:GetService('PlatformService') end)
    if PlatformService then
     local platformPurchaseReturnInt = -1
     local purchaseCallSuccess, purchaseErrorMsg = pcall(function()
      platformPurchaseReturnInt = PlatformService:BeginPlatformStorePurchase(ThirdPartyProductName)
     end)
     if purchaseCallSuccess then
      nativePurchaseFinished(platformPurchaseReturnInt == 0)
     else
      nativePurchaseFinished(purchaseCallSuccess)
     end
    end
   end)
  else
   MarketplaceService:PromptNativePurchase(Players.LocalPlayer, ThirdPartyProductName)
  end
 else
  IsCheckingPlayerFunds = true
  GuiService:OpenBrowserWindow(BASE_URL..'Upgrades/Robux.aspx')
 end
end

local function onUpgradeBCPrompt()
 if purchaseState ~= PURCHASE_STATE.BUYBC then
  return
 end

 IsCheckingPlayerFunds = true
 GuiService:OpenBrowserWindow(BASE_URL..'Upgrades/BuildersClubMemberships.aspx')
end

function enableControllerInput()
 local cas = game:GetService('ContextActionService')


 cas:BindCoreAction(
  CONTROLLER_CONFIRM_ACTION_NAME,
  function(actionName, inputState, inputObject)
   if inputState ~= Enum.UserInputState.Begin then return end

   if purchaseState == PURCHASE_STATE.SUCCEEDED then
    onPromptEnded()
   elseif purchaseState == PURCHASE_STATE.FAILED then
    onPromptEnded()
   elseif purchaseState == PURCHASE_STATE.BUYITEM then
    onAcceptPurchase()
   elseif purchaseState == PURCHASE_STATE.BUYROBUX then
    onBuyRobuxPrompt()
   elseif  purchaseState == PURCHASE_STATE.BUYBC then
    onUpgradeBCPrompt()
   end
  end,
  false,
  Enum.KeyCode.ButtonA)



 cas:BindCoreAction(
  CONTROLLER_CANCEL_ACTION_NAME,
  function(actionName, inputState, inputObject)
   if inputState ~= Enum.UserInputState.Begin then return end

   if (OkPurchasedButton.Visible or OkButton.Visible or CancelButton.Visible) and (not PurchaseFrame.Visible) then
    onPromptEnded(false)
   end
  end,
  false,
  Enum.KeyCode.ButtonB)

end

function disableControllerInput()
 local cas = game:GetService('ContextActionService')
 cas:UnbindCoreAction(CONTROLLER_CONFIRM_ACTION_NAME)
 cas:UnbindCoreAction(CONTROLLER_CANCEL_ACTION_NAME)
end

function showGamepadButtons()
 for _, button in pairs(GAMEPAD_BUTTONS) do
  button.Visible = true
 end
end

function hideGamepadButtons()
 for _, button in pairs(GAMEPAD_BUTTONS) do
  button.Visible = false
 end
end

function valueInTable(val, tab)
 for _, v in pairs(tab) do
  if v == val then
   return true
  end
 end
 return false
end

function onInputChanged(inputObject)
 local input = inputObject.UserInputType
 local inputs = Enum.UserInputType
 if valueInTable(input, {inputs.Gamepad1, inputs.Gamepad2, inputs.Gamepad3, inputs.Gamepad4}) then
  if inputObject.KeyCode == Enum.KeyCode.Thumbstick1 or inputObject.KeyCode == Enum.KeyCode.Thumbstick2 then
   if math.abs(inputObject.Position.X) > 0.10000000000000001or math.abs(inputObject.Position.Z)>0.10000000000000001or math.abs(inputObject.Position.Y)>0.10000000000000001 then
    showGamepadButtons()
   end
  else
   showGamepadButtons()
  end
 else
  hideGamepadButtons()
 end
end
UserInputService.InputChanged:connect(onInputChanged)
UserInputService.InputBegan:connect(onInputChanged)
hideGamepadButtons()


CancelButton.MouseButton1Click:connect(function()
 if IsCurrentlyPurchasing then return end
 onPromptEnded(false)
end)
BuyButton.MouseButton1Click:connect(onAcceptPurchase)
FreeButton.MouseButton1Click:connect(onAcceptPurchase)
OkButton.MouseButton1Click:connect(function()
 if purchaseState == PURCHASE_STATE.FAILED then
  onPromptEnded(false)
 end
end)
OkPurchasedButton.MouseButton1Click:connect(function()
 if purchaseState == PURCHASE_STATE.SUCCEEDED then
  onPromptEnded(true)
 end
end)
BuyRobuxButton.MouseButton1Click:connect(onBuyRobuxPrompt)
BuyBCButton.MouseButton1Click:connect(onUpgradeBCPrompt)

MarketplaceService.PromptProductPurchaseRequested:connect(function(player, productId, equipIfPurchased, currencyType)
 onPurchasePrompt(player, nil, equipIfPurchased, currencyType, productId)
end)
MarketplaceService.PromptPurchaseRequested:connect(function(player, assetId, equipIfPurchased, currencyType)
 onPurchasePrompt(player, assetId, equipIfPurchased, currencyType, nil)
end)
MarketplaceService.ServerPurchaseVerification:connect(function(serverResponseTable)
 if not serverResponseTable then
  onPurchaseFailed(PURCHASE_FAILED.DEFAULT_ERROR)
  return
 end

 if serverResponseTable['playerId'] and tonumber(serverResponseTable['playerId']) == Players.LocalPlayer.userId then
  onPurchaseSuccess()
 end
end)


GuiService.BrowserWindowClosed:connect(function()
 if IsCheckingPlayerFunds then
  retryPurchase(4)
 end

 onPurchaseFailed(PURCHASE_FAILED.DID_NOT_BUY_ROBUX)
 stopPurchaseAnimation()
end)

if IsNativePurchasing then
 MarketplaceService.NativePurchaseFinished:connect(function(player, productId, wasPurchased)
  nativePurchaseFinished(wasPurchased)
 end)
end

-- chunk: =CoreGui.RobloxGui.Modules.BackpackScript coverage=11996/28380 consts=43174
-- subst=0
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed







local BackpackScript = {}
BackpackScript.OpenClose = nil
BackpackScript.IsOpen = false
BackpackScript.StateChanged = Instance.new('BindableEvent')





local ICON_SIZE = 60
local FONT_SIZE = Enum.FontSize.Size14
local ICON_BUFFER = 5

local BACKGROUND_FADE = 0.5
local BACKGROUND_COLOR = Color3.new(31/255, 31/255, 31/255)

local SLOT_DRAGGABLE_COLOR = Color3.new(49/255, 49/255, 49/255)
local SLOT_EQUIP_COLOR = Color3.new(90/255, 142/255, 233/255)
local SLOT_EQUIP_THICKNESS = 0.10000000000000001
local SLOT_FADE_LOCKED = 0.5
local SLOT_BORDER_COLOR = Color3.new(1, 1, 1)

local TOOLTIP_BUFFER = 6
local TOOLTIP_HEIGHT = 16
local TOOLTIP_OFFSET = -25

local ARROW_IMAGE_OPEN = 'rbxasset://textures/ui/Backpack_Open.png'
local ARROW_IMAGE_CLOSE = 'rbxasset://textures/ui/Backpack_Close.png'
local ARROW_SIZE = UDim2.new(0, 14, 0, 9)
local ARROW_HOTKEY = Enum.KeyCode.Backquote.Value
local ARROW_HOTKEY_STRING = '\096'

local HOTBAR_SLOTS_FULL = 10
local HOTBAR_SLOTS_MINI = 3
local HOTBAR_SLOTS_WIDTH_CUTOFF = 1024
local HOTBAR_OFFSET_FROMBOTTOM = -30

local INVENTORY_ROWS_FULL = 4
local INVENTORY_ROWS_MINI = 2
local INVENTORY_HEADER_SIZE = 40




local SEARCH_BUFFER = 5
local SEARCH_WIDTH = 200
local SEARCH_TEXT = '   Search'
local SEARCH_TEXT_OFFSET_FROMLEFT = 0
local SEARCH_BACKGROUND_COLOR = Color3.new(0.37, 0.37, 0.37)
local SEARCH_BACKGROUND_FADE = 0.14999999999999999

local DOUBLE_CLICK_TIME = 0.5




local PlayersService = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local StarterGui = game:GetService('StarterGui')
local GuiService = game:GetService('GuiService')
local CoreGui = game:GetService('CoreGui')
local ContextActionService = game:GetService('ContextActionService')
local RobloxGui = CoreGui:WaitForChild('RobloxGui')
RobloxGui:WaitForChild('Modules'):WaitForChild('TenFootInterface')
local isTenFootInterface = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local utility = require(RobloxGui.Modules.Settings.Utility)
local topbarEnabled = true

if isTenFootInterface then
 ICON_SIZE = 100
 FONT_SIZE = Enum.FontSize.Size24
end

local gamepadActionsBound = false

local IS_PHONE = UserInputService.TouchEnabled and GuiService:GetScreenResolution().X < HOTBAR_SLOTS_WIDTH_CUTOFF

local HOTBAR_SLOTS = (IS_PHONE) and HOTBAR_SLOTS_MINI or HOTBAR_SLOTS_FULL
local HOTBAR_SIZE = UDim2.new(0, ICON_BUFFER + (HOTBAR_SLOTS * (ICON_SIZE + ICON_BUFFER)), 0, ICON_BUFFER + ICON_SIZE + ICON_BUFFER)
local ZERO_KEY_VALUE = Enum.KeyCode.Zero.Value
local DROP_HOTKEY_VALUE = Enum.KeyCode.Backspace.Value
local INVENTORY_ROWS = (IS_PHONE) and INVENTORY_ROWS_MINI or INVENTORY_ROWS_FULL

local Player = PlayersService.LocalPlayer

local MainFrame = nil
local HotbarFrame = nil
local InventoryFrame = nil
local ScrollingFrame = nil

local Character = nil
local Humanoid = nil
local Backpack = nil

local Slots = {}
local LowestEmptySlot = nil
local SlotsByTool = {}
local HotkeyFns = {}
local Dragging = {}
local FullHotbarSlots = 0
local UpdateArrowFrame = nil
local ActiveHopper = nil
local StarterToolFound = false
local WholeThingEnabled = false
local TextBoxFocused = false
local ResultsIndices = nil
local HotkeyStrings = {}
local CharConns = {}
local TopBarEnabled = false
local GamepadEnabled = false

local lastEquippedSlot = nil





local function NewGui(className, objectName)
 local newGui = Instance.new(className)
 newGui.Name = objectName
 newGui.BackgroundColor3 = Color3.new(0, 0, 0)
 newGui.BackgroundTransparency = 1
 newGui.BorderColor3 = Color3.new(0, 0, 0)
 newGui.BorderSizePixel = 0
 newGui.Size = UDim2.new(1, 0, 1, 0)
 if className:match('Text') then
  newGui.TextColor3 = Color3.new(1, 1, 1)
  newGui.Text = ''
  newGui.Font = Enum.Font.SourceSans
  newGui.FontSize = FONT_SIZE
  newGui.TextWrapped = true
  if className == 'TextButton' then
   newGui.Font = Enum.Font.SourceSansBold
   newGui.BorderSizePixel = 1
  end
 end
 return newGui
end

local function FindLowestEmpty()
 for i=  1, HOTBAR_SLOTS do
  local slot = Slots[i]
  if not slot.Tool then
   return slot
  end
 end
 return nil
end

local function AdjustHotbarFrames()
 local inventoryOpen = InventoryFrame.Visible
 local visualTotal = (inventoryOpen) and HOTBAR_SLOTS or FullHotbarSlots
 local visualIndex = 0
 for i=  1, HOTBAR_SLOTS do
  local slot = Slots[i]
  if slot.Tool or inventoryOpen then
   visualIndex = visualIndex + 1
   slot:Readjust(visualIndex, visualTotal)
   slot.Frame.Visible = true
  else
   slot.Frame.Visible = false
  end
 end
end

local function CheckBounds(guiObject, x, y)
 local pos = guiObject.AbsolutePosition
 local size = guiObject.AbsoluteSize
 return (x > pos.X and x <= pos.X + size.X and y > pos.Y and y <= pos.Y + size.Y)
end

local function GetOffset(guiObject, point)
 local centerPoint = guiObject.AbsolutePosition + (guiObject.AbsoluteSize / 2)
 return (centerPoint - point).magnitude
end

local function DisableActiveHopper()
 ActiveHopper:ToggleSelect()
 SlotsByTool[ActiveHopper]:UpdateEquipView()
 ActiveHopper = nil
end

local function UnequipAllTools()
 if Humanoid then
  Humanoid:UnequipTools()
  if ActiveHopper then
   DisableActiveHopper()
  end
 end
end

local function EquipNewTool(tool)
 UnequipAllTools()
 if tool:IsA('HopperBin') then
  tool:ToggleSelect()
  SlotsByTool[tool]:UpdateEquipView()
  ActiveHopper = tool
 else

  tool.Parent = Character
 end
end

local function IsEquipped(tool)
 return tool and ((tool:IsA('HopperBin') and tool.Active) or tool.Parent == Character)
end

local function MakeSlot(parent, index)
 index = index or (#Slots + 1)



 local slot = {}
 slot.Tool = nil
 slot.Index = index
 slot.Frame = nil

 local SlotFrame = nil
 local ToolIcon = nil
 local ToolName = nil
 local ToolChangeConn = nil
 local HighlightFrame = nil


 local ToolTip = nil
 local SlotNumber = nil



 local function UpdateSlotFading()
  SlotFrame.BackgroundTransparency = (SlotFrame.Draggable) and 0 or SLOT_FADE_LOCKED
  SlotFrame.BackgroundColor3 = (SlotFrame.Draggable) and SLOT_DRAGGABLE_COLOR or BACKGROUND_COLOR
 end

 function slot:Reposition()

  local index = (ResultsIndices and ResultsIndices[self]) or self.Index
  local sizePlus = ICON_BUFFER + ICON_SIZE

  local modSlots = 0
  modSlots = ((index - 1) % HOTBAR_SLOTS) + 1

  local row = 0
  row = (index > HOTBAR_SLOTS) and (math.floor((index - 1) / HOTBAR_SLOTS)) - 1 or 0

  SlotFrame.Position = UDim2.new(0, ICON_BUFFER + ((modSlots - 1) * sizePlus), 0, ICON_BUFFER + (sizePlus * row))
 end

 function slot:Readjust(visualIndex, visualTotal)
  local centered = HOTBAR_SIZE.X.Offset / 2
  local sizePlus = ICON_BUFFER + ICON_SIZE
  local midpointish = (visualTotal / 2) + 0.5
  local factor = visualIndex - midpointish
  SlotFrame.Position = UDim2.new(0, centered - (ICON_SIZE / 2) + (sizePlus * factor), 0, ICON_BUFFER)
 end

 function slot:Fill(tool)
  if not tool then
   return self:Clear()
  end

  self.Tool = tool

  local function assignToolData()
   local icon = tool.TextureId
   ToolIcon.Image = icon
   ToolName.Text = (icon == '') and tool.Name or ''
   if ToolTip and tool:IsA('Tool') then
    ToolTip.Text = tool.ToolTip
    local width = ToolTip.TextBounds.X + TOOLTIP_BUFFER
    ToolTip.Size = UDim2.new(0, width, 0, TOOLTIP_HEIGHT)
    ToolTip.Position = UDim2.new(0.5, -width / 2, 0, TOOLTIP_OFFSET)
   end
  end
  assignToolData()

  if ToolChangeConn then
   ToolChangeConn:disconnect()
   ToolChangeConn = nil
  end

  ToolChangeConn = tool.Changed:connect(function(property)
   if property == 'TextureId' or property == 'Name' or property == 'ToolTip' then
    assignToolData()
   end
  end)

  local hotbarSlot = (self.Index <= HOTBAR_SLOTS)
  local inventoryOpen = InventoryFrame.Visible

  if not hotbarSlot or inventoryOpen then
   SlotFrame.Draggable = true
  end

  self:UpdateEquipView()

  if hotbarSlot then
   FullHotbarSlots = FullHotbarSlots + 1
  end

  SlotsByTool[tool] = self
  LowestEmptySlot = FindLowestEmpty()
  UpdateArrowFrame()
 end

 function slot:Clear()
  if not self.Tool then return end

  if ToolChangeConn then
   ToolChangeConn:disconnect()
   ToolChangeConn = nil
  end

  ToolIcon.Image = ''
  ToolName.Text = ''
  if ToolTip then
   ToolTip.Text = ''
   ToolTip.Visible = false
  end
  SlotFrame.Draggable = false

  self:UpdateEquipView(true)

  if self.Index <= HOTBAR_SLOTS then
   FullHotbarSlots = FullHotbarSlots - 1
  end

  SlotsByTool[self.Tool] = nil
  self.Tool = nil
  LowestEmptySlot = FindLowestEmpty()
  UpdateArrowFrame()
 end

 function slot:UpdateEquipView(unequippedOverride)
  if not unequippedOverride and IsEquipped(self.Tool) then
   lastEquippedSlot = slot
   if not HighlightFrame then
    HighlightFrame = NewGui('Frame', 'Equipped')
    HighlightFrame.ZIndex = SlotFrame.ZIndex
    local t = SLOT_EQUIP_THICKNESS
    local dataTable = {
     {t, 1, 0, 0},
     {1, t, 0, 0},
     {t, 1, 1 - t, 0},
     {1, t, 0, 1 - t}
    }
    for _, data in pairs(dataTable) do
     local edgeFrame = NewGui('Frame', 'Edge')
     edgeFrame.BackgroundTransparency = 0
     edgeFrame.BackgroundColor3 = SLOT_EQUIP_COLOR
     edgeFrame.Size = UDim2.new(data[1], 0, data[2], 0)
     edgeFrame.Position = UDim2.new(data[3], 0, data[4], 0)
     edgeFrame.ZIndex = HighlightFrame.ZIndex
     edgeFrame.Parent = HighlightFrame
    end
   end
   HighlightFrame.Parent = SlotFrame
  else
   if HighlightFrame then
    HighlightFrame.Parent = nil
   end
  end
  UpdateSlotFading()
 end

 function slot:IsEquipped()
  return IsEquipped(self.Tool)
 end

 function slot:Delete()
  SlotFrame:Destroy()
  table.remove(Slots, self.Index)
  local newSize = #Slots


  for i=  self.Index, newSize do
   Slots[i]:SlideBack()
  end

  if newSize % HOTBAR_SLOTS == 0 then
   local lastSlot = Slots[newSize]
   local lowestPoint = lastSlot.Frame.Position.Y.Offset + lastSlot.Frame.Size.Y.Offset
   ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, lowestPoint + ICON_BUFFER)
  end
 end

 function slot:Swap(targetSlot)
  local myTool, otherTool = self.Tool, targetSlot.Tool
  self:Clear()
  if otherTool then
   targetSlot:Clear()
   self:Fill(otherTool)
  end
  if myTool then
   targetSlot:Fill(myTool)
  else
   targetSlot:Clear()
  end
 end

 function slot:SlideBack()
  self.Index = self.Index - 1
  SlotFrame.Name = self.Index
  self:Reposition()
 end

 function slot:TurnNumber(on)
  if SlotNumber then
   SlotNumber.Visible = on
  end
 end

 function slot:SetClickability(on)
  if self.Tool then
   SlotFrame.Draggable = not on
   UpdateSlotFading()
  end
 end

 function slot:CheckTerms(terms)
  local hits = 0
  local function checkEm(str, term)
   local _, n = str:lower():gsub(term, '')
   hits = hits + n
  end
  local tool = self.Tool
  for term in pairs(terms) do
   checkEm(tool.Name, term)
   if tool:IsA('Tool') then
    checkEm(tool.ToolTip, term)
   end
  end
  return hits
 end



 SlotFrame = NewGui('TextButton', index)
 SlotFrame.BackgroundColor3 = BACKGROUND_COLOR
 SlotFrame.BorderColor3 = SLOT_BORDER_COLOR
 SlotFrame.Text = ''
 SlotFrame.AutoButtonColor = false
 SlotFrame.BorderSizePixel = 0
 SlotFrame.Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
 SlotFrame.Active = true
 SlotFrame.Draggable = false
 SlotFrame.BackgroundTransparency = SLOT_FADE_LOCKED
 SlotFrame.MouseButton1Click:connect(function() changeSlot(slot) end)
 slot.Frame = SlotFrame

 ToolIcon = NewGui('ImageLabel', 'Icon')
 ToolIcon.Size = UDim2.new(0.80000000000000004,0,0.80000000000000004,0)
 ToolIcon.Position = UDim2.new(0.10000000000000001,0,0.10000000000000001,0)
 ToolIcon.Parent = SlotFrame

 ToolName = NewGui('TextLabel', 'ToolName')
 ToolName.Size = UDim2.new(1, -2, 1, -2)
 ToolName.Position = UDim2.new(0, 1, 0, 1)
 ToolName.Parent = SlotFrame

 slot:Reposition()

 if index <= HOTBAR_SLOTS then

  ToolTip = NewGui('TextLabel', 'ToolTip')
  ToolTip.TextWrapped = false
  ToolTip.TextYAlignment = Enum.TextYAlignment.Top
  ToolTip.BackgroundColor3 = Color3.new(0.40000000000000002,0.40000000000000002,0.40000000000000002)
  ToolTip.BackgroundTransparency = 0
  ToolTip.Visible = false
  ToolTip.Parent = SlotFrame
  SlotFrame.MouseEnter:connect(function()
   if ToolTip.Text ~= '' then
    ToolTip.Visible = true
   end
  end)
  SlotFrame.MouseLeave:connect(function() ToolTip.Visible = false end)


  function slot:Select()
   local tool = slot.Tool
   if tool then
    if IsEquipped(tool) then
     UnequipAllTools()
    elseif tool.Parent == Backpack then
     EquipNewTool(tool)
    end
   end
  end

  function slot:MoveToInventory()
   if slot.Index <= HOTBAR_SLOTS then
    local tool = slot.Tool
    self:Clear()
    local newSlot = MakeSlot(ScrollingFrame)
    newSlot:Fill(tool)
    if IsEquipped(tool) then
     UnequipAllTools()
    end

    if ResultsIndices then
     newSlot.Frame.Visible = false
    end
   end
  end


  if index < 10 or index == HOTBAR_SLOTS then
   local slotNum = (index < 10) and index or 0
   SlotNumber = NewGui('TextLabel', 'Number')
   SlotNumber.Text = slotNum
   SlotNumber.Size = UDim2.new(0.14999999999999999,0,0.14999999999999999,0)
   SlotNumber.Visible = false
   SlotNumber.Parent = SlotFrame
   HotkeyFns[ZERO_KEY_VALUE + slotNum] = slot.Select
  end
 else

  local newRow = false
  newRow = (index % HOTBAR_SLOTS == 1)

  if newRow then
   local lowestPoint = SlotFrame.Position.Y.Offset + SlotFrame.Size.Y.Offset
   ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, lowestPoint + ICON_BUFFER)
  end


  if InventoryFrame.Visible and not ResultsIndices then
   local offset = ScrollingFrame.CanvasSize.Y.Offset - ScrollingFrame.AbsoluteSize.Y
   ScrollingFrame.CanvasPosition = Vector2.new(0, math.max(0, offset))
  end
 end

 
  local startPoint = SlotFrame.Position
  local lastUpTime = 0
  local startParent = nil

  SlotFrame.DragBegin:connect(function(dragPoint)
   Dragging[SlotFrame] = true
   startPoint = dragPoint

   SlotFrame.BorderSizePixel = 2


   SlotFrame.ZIndex = 2
   ToolIcon.ZIndex = 2
   ToolName.ZIndex = 2
   if SlotNumber then
    SlotNumber.ZIndex = 2
   end
   if HighlightFrame then
    HighlightFrame.ZIndex = 2
    for _, child in pairs(HighlightFrame:GetChildren()) do
     child.ZIndex = 2
    end
   end


   startParent = SlotFrame.Parent
   if startParent == ScrollingFrame then
    SlotFrame.Parent = InventoryFrame
    local pos = ScrollingFrame.Position
    local offset = ScrollingFrame.CanvasPosition - Vector2.new(pos.X.Offset, pos.Y.Offset)
    SlotFrame.Position = SlotFrame.Position - UDim2.new(0, offset.X, 0, offset.Y)
   end
  end)

  SlotFrame.DragStopped:connect(function(x, y)
   local now = tick()
   SlotFrame.Position = startPoint
   SlotFrame.Parent = startParent

   SlotFrame.BorderSizePixel = 0


   SlotFrame.ZIndex = 1
   ToolIcon.ZIndex = 1
   ToolName.ZIndex = 1
   if SlotNumber then
    SlotNumber.ZIndex = 1
   end
   if HighlightFrame then
    HighlightFrame.ZIndex = 1
    for _, child in pairs(HighlightFrame:GetChildren()) do
     child.ZIndex = 1
    end
   end

   Dragging[SlotFrame] = nil


   if not slot.Tool then
    return
   end


   if CheckBounds(InventoryFrame, x, y) then
    if slot.Index <= HOTBAR_SLOTS then
     slot:MoveToInventory()
    end

    if slot.Index > HOTBAR_SLOTS and now - lastUpTime < DOUBLE_CLICK_TIME then
     if LowestEmptySlot then
      local myTool = slot.Tool
      slot:Clear()
      LowestEmptySlot:Fill(myTool)
      slot:Delete()
     end
     now = 0
    end
   elseif CheckBounds(HotbarFrame, x, y) then
    local closest = {math.huge, nil}
    for i=  1, HOTBAR_SLOTS do
     local otherSlot = Slots[i]
     local offset = GetOffset(otherSlot.Frame, Vector2.new(x, y))
     if offset < closest[1] then
      closest = {offset, otherSlot}
     end
    end
    local closestSlot = closest[2]
    if closestSlot ~= slot then
     slot:Swap(closestSlot)
     if slot.Index > HOTBAR_SLOTS then
      local tool = slot.Tool
      if not tool then
       slot:Delete()
      else
       if IsEquipped(tool) then
        UnequipAllTools()
       end

       if ResultsIndices then
        slot.Frame.Visible = false
       end
      end
     end
    end
   else





    if slot.Index <= HOTBAR_SLOTS then
     slot:MoveToInventory()
    end
   end

   lastUpTime = now
  end)
    end


 SlotFrame.Parent = parent
 Slots[index] = slot
 return slot
end

local function OnChildAdded(child)
 if not child:IsA('Tool') and not child:IsA('HopperBin') then
  if child:IsA('Humanoid') and child.Parent == Character then
   Humanoid = child
  end
  return
 end
 local tool = child

 if ActiveHopper and tool.Parent == Character then
  DisableActiveHopper()
 end


 if not StarterToolFound and tool.Parent == Character and not SlotsByTool[tool] then
  local starterGear = Player:FindFirstChild('StarterGear')
  if starterGear then
   if starterGear:FindFirstChild(tool.Name) then
    StarterToolFound = true
    local slot = LowestEmptySlot or MakeSlot(ScrollingFrame)
    for i=  slot.Index, 1, -1 do
     local curr = Slots[i]
     local pIndex = i - 1
     if pIndex > 0 then
      local prev = Slots[pIndex]
      prev:Swap(curr)
     else
      curr:Fill(tool)
     end
    end

    for _, child in pairs(Character:GetChildren()) do
     if child:IsA('Tool') and child ~= tool then
      child.Parent = Backpack
     end
    end
    AdjustHotbarFrames()
    return
   end
  end
 end


 local slot = SlotsByTool[tool]
 if slot then
  slot:UpdateEquipView()
 else
  slot = LowestEmptySlot or MakeSlot(ScrollingFrame)
  slot:Fill(tool)
  if slot.Index <= HOTBAR_SLOTS and not InventoryFrame.Visible then
   AdjustHotbarFrames()
  end
  if tool:IsA('HopperBin') then
   if tool.Active then
    UnequipAllTools()
    ActiveHopper = tool
   end
  end
 end
end

local function OnChildRemoved(child)
 if not child:IsA('Tool') and not child:IsA('HopperBin') then
  return
 end
 local tool = child


 local newParent = tool.Parent
 if newParent == Character or newParent == Backpack then
  return
 end

 local slot = SlotsByTool[tool]
 if slot then
  slot:Clear()
  if slot.Index > HOTBAR_SLOTS then
   slot:Delete()
  elseif not InventoryFrame.Visible then
   AdjustHotbarFrames()
  end
 end

 if tool == ActiveHopper then
  ActiveHopper = nil
 end
end

local function OnCharacterAdded(character)

 for i=  #Slots, 1, -1 do
  local slot = Slots[i]
  if slot.Tool then
   slot:Clear()
  end
  if i > HOTBAR_SLOTS then
   slot:Delete()
  end
 end
 ActiveHopper = nil


 for _, conn in pairs(CharConns) do
  conn:disconnect()
 end
 CharConns = {}


 Character = character
 table.insert(CharConns, character.ChildRemoved:connect(OnChildRemoved))
 table.insert(CharConns, character.ChildAdded:connect(OnChildAdded))
 for _, child in pairs(character:GetChildren()) do
  OnChildAdded(child)
 end



 Backpack = Player:WaitForChild('Backpack')
 table.insert(CharConns, Backpack.ChildRemoved:connect(OnChildRemoved))
 table.insert(CharConns, Backpack.ChildAdded:connect(OnChildAdded))
 for _, child in pairs(Backpack:GetChildren()) do
  OnChildAdded(child)
 end

 AdjustHotbarFrames()
end

local function OnInputBegan(input, isProcessed)

 if input.UserInputType == Enum.UserInputType.Keyboard and not TextBoxFocused and (WholeThingEnabled or input.KeyCode.Value == DROP_HOTKEY_VALUE) then
  local hotkeyBehavior = HotkeyFns[input.KeyCode.Value]
  if hotkeyBehavior then
   hotkeyBehavior(isProcessed)
  end
 end
end

local function OnUISChanged(property)
 if property == 'KeyboardEnabled' then
  local on = UserInputService.KeyboardEnabled
  for i=  1, HOTBAR_SLOTS do
   Slots[i]:TurnNumber(on)
  end
 end
end






local lastChangeToolInputObject = nil
local lastChangeToolInputTime = nil
local maxEquipDeltaTime = 0.059999999999999998
local noOpFunc = function() end
local selectDirection = Vector2.new(0,0)
local hotbarVisible = false

function unbindAllGamepadEquipActions()
 ContextActionService:UnbindCoreAction('RBXBackpackHasGamepadFocus')
 ContextActionService:UnbindCoreAction('RBXCloseInventory')
end

local function setHotbarVisibility(visible, isInventoryScreen)
 for i=  1, HOTBAR_SLOTS do
  local hotbarSlot = Slots[i]
  if hotbarSlot and hotbarSlot.Frame and (isInventoryScreen or hotbarSlot.Tool) then
   hotbarSlot.Frame.Visible = visible
  end
 end
end

local function getInputDirection(inputObject)
 local buttonModifier = 1
 if inputObject.UserInputState == Enum.UserInputState.End then
  buttonModifier = -1
 end

 if inputObject.KeyCode == Enum.KeyCode.Thumbstick1 then

  local magnitude = inputObject.Position.magnitude

  if magnitude > 0.97999999999999998 then
   local normalizedVector = Vector2.new(inputObject.Position.x / magnitude, -inputObject.Position.y / magnitude)
   selectDirection =  normalizedVector
  else
   selectDirection = Vector2.new(0,0)
  end
 elseif inputObject.KeyCode == Enum.KeyCode.DPadLeft then
  selectDirection = Vector2.new(selectDirection.x - 1 * buttonModifier, selectDirection.y)
 elseif inputObject.KeyCode == Enum.KeyCode.DPadRight then
  selectDirection = Vector2.new(selectDirection.x + 1 * buttonModifier, selectDirection.y)
 elseif inputObject.KeyCode == Enum.KeyCode.DPadUp then
  selectDirection = Vector2.new(selectDirection.x, selectDirection.y - 1 * buttonModifier)
 elseif inputObject.KeyCode == Enum.KeyCode.DPadDown then
  selectDirection = Vector2.new(selectDirection.x, selectDirection.y + 1 * buttonModifier)
 else
  selectDirection = Vector2.new(0,0)
 end

 return selectDirection
end

local selectToolExperiment = function(actionName, inputState, inputObject)

 local inputDirection = getInputDirection(inputObject)

 if inputDirection == Vector2.new(0,0) then
  return
 end

 local angle = math.atan2(inputDirection.y, inputDirection.x) - math.atan2(-1, 0)
 if angle < 0 then
  angle = angle + (math.pi * 2)
 end

 local quarterPi = (math.pi * 0.25)

 local index = (angle/quarterPi) + 1
 index = math.floor(index + 0.5)
 if index > HOTBAR_SLOTS then
  index = 1
 end

 if index > 0 then
  local selectedSlot = Slots[index]
  if selectedSlot and selectedSlot.Tool and not selectedSlot:IsEquipped() then
   selectedSlot:Select()
  end
 else
  UnequipAllTools()
 end
end

local changeToolFunc = function(actionName, inputState, inputObject)
 if inputState ~= Enum.UserInputState.Begin then return end

 if lastChangeToolInputObject then
  if (lastChangeToolInputObject.KeyCode == Enum.KeyCode.ButtonR1and
   inputObject.KeyCode == Enum.KeyCode.ButtonL1)or
   (lastChangeToolInputObject.KeyCode == Enum.KeyCode.ButtonL1and
   inputObject.KeyCode == Enum.KeyCode.ButtonR1) then
    if (tick() - lastChangeToolInputTime) <= maxEquipDeltaTime then
     UnequipAllTools()
     lastChangeToolInputObject = inputObject
     lastChangeToolInputTime = tick()
     return
    end
  end
 end

 lastChangeToolInputObject = inputObject
 lastChangeToolInputTime = tick()

 delay(maxEquipDeltaTime, function()
  if lastChangeToolInputObject ~= inputObject then return end

  local moveDirection = 0
  if (inputObject.KeyCode == Enum.KeyCode.ButtonL1) then
   moveDirection = -1
  else
   moveDirection = 1
  end

  for i=  1, HOTBAR_SLOTS do
   local hotbarSlot = Slots[i]
   if hotbarSlot:IsEquipped() then

    local newSlotPosition = moveDirection + i
    if newSlotPosition > HOTBAR_SLOTS then
     newSlotPosition = 1
    elseif newSlotPosition < 1 then
     newSlotPosition = HOTBAR_SLOTS
    end

    local origNewSlotPos = newSlotPosition
    while not Slots[newSlotPosition].Tool do
     newSlotPosition = newSlotPosition + moveDirection
     if newSlotPosition == origNewSlotPos then return end

     if newSlotPosition > HOTBAR_SLOTS then
      newSlotPosition = 1
     elseif newSlotPosition < 1 then
      newSlotPosition = HOTBAR_SLOTS
     end
    end

    Slots[newSlotPosition]:Select()
    return
   end
  end

  if lastEquippedSlot and lastEquippedSlot.Tool then
   lastEquippedSlot:Select()
   return
  end

  for i=  1, HOTBAR_SLOTS do
   if Slots[i].Tool then
    Slots[i]:Select()
    return
   end
  end
 end)
end

function getGamepadSwapSlot()
 for i=  1, #Slots do
  if Slots[i].Frame.BorderSizePixel > 0 then
   return Slots[i]
  end
 end
end


function changeSlot(slot)
 if slot.Frame == GuiService.SelectedCoreObject then
  local currentlySelectedSlot = getGamepadSwapSlot()

  if currentlySelectedSlot then
   currentlySelectedSlot.Frame.BorderSizePixel = 0
   if currentlySelectedSlot ~= slot then
    slot:Swap(currentlySelectedSlot)

    if slot.Index > HOTBAR_SLOTS and not slot.Tool then
     if GuiService.SelectedCoreObject == slot.Frame then
      GuiService.SelectedCoreObject = currentlySelectedSlot.Frame
     end
     slot:Delete()
    end

    if currentlySelectedSlot.Index > HOTBAR_SLOTS and not currentlySelectedSlot.Tool then
     if GuiService.SelectedCoreObject == currentlySelectedSlot.Frame then
      GuiService.SelectedCoreObject = slot.Frame
     end
     currentlySelectedSlot:Delete()
    end
   end
  else
   local startSize = slot.Frame.Size
   local startPosition = slot.Frame.Position
   slot.Frame:TweenSizeAndPosition(startSize + UDim2.new(0, 10, 0, 10), startPosition - UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.10000000000000001,true,function()slot.Frame:TweenSizeAndPosition(startSize,startPosition,Enum.EasingDirection.In,Enum.EasingStyle.Quad,0.10000000000000001,true)end)
   slot.Frame.BorderSizePixel = 3
  end
 else
  slot:Select()
 end
end


function enableGamepadInventoryControl()
 local goBackOneLevel = function(actionName, inputState, inputObject)
  if inputState ~= Enum.UserInputState.Begin then return end

  local selectedSlot = getGamepadSwapSlot()
  if selectedSlot then
   local selectedSlot = getGamepadSwapSlot()
   if selectedSlot then
    selectedSlot.Frame.BorderSizePixel = 0
    return
   end
  elseif InventoryFrame.Visible then
   BackpackScript.OpenClose()
   spawn(function() GuiService:SetMenuIsOpen(false) end)
  end
 end

 ContextActionService:BindCoreAction('RBXBackpackHasGamepadFocus', noOpFunc, false, Enum.UserInputType.Gamepad1)
 ContextActionService:BindCoreAction('RBXCloseInventory', goBackOneLevel, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)

 GuiService.SelectedCoreObject = HotbarFrame:FindFirstChild('1')
end

function disableGamepadInventoryControl()
 unbindAllGamepadEquipActions()

 for i=  1, HOTBAR_SLOTS do
  local hotbarSlot = Slots[i]
  if hotbarSlot and hotbarSlot.Frame then
   hotbarSlot.Frame.BorderSizePixel = 0
  end
 end

 if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(MainFrame) then
  GuiService.SelectedCoreObject = nil
 end
end

function gamepadDisconnected()
 GamepadEnabled = false
 disableGamepadInventoryControl()
end

function gamepadConnected()
 GamepadEnabled = true
 GuiService:AddSelectionParent('RBXBackpackSelection', MainFrame)

 if not gamepadActionsBound then
  gamepadActionsBound = true
  ContextActionService:BindCoreAction('RBXHotbarEquip', changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
 end

 if InventoryFrame.Visible then
  enableGamepadInventoryControl()
 end
end






local function OnCoreGuiChanged(coreGuiType, enabled)

 if coreGuiType == Enum.CoreGuiType.Backpack or coreGuiType == Enum.CoreGuiType.All then
  enabled = enabled and topbarEnabled
  WholeThingEnabled = enabled
  MainFrame.Visible = enabled


  for _, keyString in pairs(HotkeyStrings) do
   if enabled then
    GuiService:AddKey(keyString)
   else
    GuiService:RemoveKey(keyString)
   end
  end

  if GamepadEnabled then
   if enabled then
    gamepadActionsBound = true
    ContextActionService:BindCoreAction('RBXHotbarEquip', changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
   else
    disableGamepadInventoryControl()
    gamepadActionsBound = false
    ContextActionService:UnbindCoreAction('RBXHotbarEquip')
   end
  end
 end


 if not TopBarEnabled and (coreGuiType == Enum.CoreGuiType.Health or coreGuiType == Enum.CoreGuiType.All) then
  MainFrame.Position = UDim2.new(0, 0, 0, enabled and HOTBAR_OFFSET_FROMBOTTOM or 0)
 end
end








pcall(function() TopBarEnabled = settings():GetFFlag('UseInGameTopBar') end)


MainFrame = NewGui('Frame', 'Backpack')
MainFrame.Visible = false
MainFrame.Parent = RobloxGui


HotbarFrame = NewGui('Frame', 'Hotbar')
HotbarFrame.Size = HOTBAR_SIZE
HotbarFrame.Position = UDim2.new(0.5, -HotbarFrame.Size.X.Offset / 2, 1, -HotbarFrame.Size.Y.Offset)
HotbarFrame.Parent = MainFrame


for i=  1, HOTBAR_SLOTS do
 local slot = MakeSlot(HotbarFrame, i)
 slot.Frame.Visible = false

 if not LowestEmptySlot then
  LowestEmptySlot = slot
 end
end


InventoryFrame = NewGui('Frame', 'Inventory')
InventoryFrame.BackgroundTransparency = BACKGROUND_FADE
InventoryFrame.BackgroundColor3 = BACKGROUND_COLOR
InventoryFrame.Active = true
InventoryFrame.Size = UDim2.new(0, HotbarFrame.Size.X.Offset, 0, (HotbarFrame.Size.Y.Offset * INVENTORY_ROWS) + INVENTORY_HEADER_SIZE)
InventoryFrame.Position = UDim2.new(0.5, -InventoryFrame.Size.X.Offset / 2, 1, HotbarFrame.Position.Y.Offset - InventoryFrame.Size.Y.Offset)
InventoryFrame.Visible = false
InventoryFrame.Parent = MainFrame


ScrollingFrame = NewGui('ScrollingFrame', 'ScrollingFrame')
ScrollingFrame.Selectable = false
ScrollingFrame.Size = UDim2.new(1, ScrollingFrame.ScrollBarThickness + 1, 1, -INVENTORY_HEADER_SIZE)

ScrollingFrame.Position = UDim2.new(0, 0, 0, INVENTORY_HEADER_SIZE)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.Parent = InventoryFrame














local gamepadHintsFrame = utility:Create('Frame')(
{
 Name = 'GamepadHintsFrame',
 Size = UDim2.new(0, HotbarFrame.Size.X.Offset, 0, (isTenFootInterface and 95 or 60)),
 BackgroundTransparency = 1,
 Visible = false,
 Parent = MainFrame
})

local function addGamepadHint(hintImage, hintImageLarge, hintText)
 local hintFrame = utility:Create('Frame')(
 {
  Name = 'HintFrame',
  Size = UDim2.new(1, 0, 1, -5),
  Position = UDim2.new(0, 0, 0, 0),
  BackgroundTransparency = 1,
  Parent = gamepadHintsFrame
 })

 local hintImage = utility:Create('ImageLabel')(
 {
  Name = 'HintImage',
  Size = (isTenFootInterface and UDim2.new(0,90,0,90) or UDim2.new(0,60,0,60)),
  BackgroundTransparency = 1,
  Image = (isTenFootInterface and hintImageLarge or hintImage),
  Parent = hintFrame
 })

 local hintText = utility:Create('TextLabel')(
 {
  Name = 'HintText',
  Position = UDim2.new(0, (isTenFootInterface and 100 or 70), 0, 0),
  Size = UDim2.new(1, -(isTenFootInterface and 100 or 70), 1, 0),
  Font = Enum.Font.SourceSansBold,
  FontSize = (isTenFootInterface and Enum.FontSize.Size36 or Enum.FontSize.Size24),
  BackgroundTransparency = 1,
  Text = hintText,
  TextColor3 = Color3.new(1,1,1),
  TextXAlignment = Enum.TextXAlignment.Left,
  Parent = hintFrame
 })
end

local function resizeGamepadHintsFrame()
 gamepadHintsFrame.Size = UDim2.new(HotbarFrame.Size.X.Scale, HotbarFrame.Size.X.Offset, 0, (isTenFootInterface and 95 or 60))
 gamepadHintsFrame.Position = UDim2.new(HotbarFrame.Position.X.Scale, HotbarFrame.Position.X.Offset, InventoryFrame.Position.Y.Scale, InventoryFrame.Position.Y.Offset - gamepadHintsFrame.Size.Y.Offset)

 local spaceTaken = 0

 local gamepadHints = gamepadHintsFrame:GetChildren()

 for i=  1, #gamepadHints do
  gamepadHints[i].Size = UDim2.new(1, 0, 1, -5)
  gamepadHints[i].Position = UDim2.new(0, 0, 0, 0)
  spaceTaken = spaceTaken + (gamepadHints[i].HintText.Position.X.Offset + gamepadHints[i].HintText.TextBounds.X)
 end


 local spaceBetweenElements = (gamepadHintsFrame.AbsoluteSize.X - spaceTaken)/(#gamepadHints - 1)
 for i=  1, #gamepadHints do
  gamepadHints[i].Position = (i == 1 and UDim2.new(0, 0, 0, 0) or UDim2.new(0, gamepadHints[i-1].Position.X.Offset + gamepadHints[i-1].Size.X.Offset + spaceBetweenElements, 0, 0))
  gamepadHints[i].Size = UDim2.new(0, (gamepadHints[i].HintText.Position.X.Offset + gamepadHints[i].HintText.TextBounds.X), 1, -5)
 end
end

addGamepadHint('rbxasset://textures/ui/Settings/Help/XButtonDark.png', 'rbxasset://textures/ui/Settings/Help/XButtonDark@2x.png', 'Remove From Hotbar')
addGamepadHint('rbxasset://textures/ui/Settings/Help/AButtonDark.png', 'rbxasset://textures/ui/Settings/Help/AButtonDark@2x.png', 'Select/Swap')
addGamepadHint('rbxasset://textures/ui/Settings/Help/BButtonDark.png', 'rbxasset://textures/ui/Settings/Help/BButtonDark@2x.png', 'Close Backpack')


 local searchFrame = NewGui('Frame', 'Search')
 searchFrame.BackgroundColor3 = SEARCH_BACKGROUND_COLOR
 searchFrame.BackgroundTransparency = SEARCH_BACKGROUND_FADE
 searchFrame.Size = UDim2.new(0, SEARCH_WIDTH - (SEARCH_BUFFER * 2), 0, INVENTORY_HEADER_SIZE - (SEARCH_BUFFER * 2))
 searchFrame.Position = UDim2.new(1, -searchFrame.Size.X.Offset - SEARCH_BUFFER, 0, SEARCH_BUFFER)
 searchFrame.Parent = InventoryFrame

 local searchBox = NewGui('TextBox', 'TextBox')
 searchBox.Text = SEARCH_TEXT
 searchBox.ClearTextOnFocus = false
 searchBox.FontSize = Enum.FontSize.Size24
 searchBox.TextXAlignment = Enum.TextXAlignment.Left
 searchBox.Size = searchFrame.Size - UDim2.new(0, SEARCH_TEXT_OFFSET_FROMLEFT, 0, 0)
 searchBox.Position = UDim2.new(0, SEARCH_TEXT_OFFSET_FROMLEFT, 0, 0)
 searchBox.Parent = searchFrame

 local xButton = NewGui('TextButton', 'X')
 xButton.Text = 'x'
 xButton.TextColor3 = SLOT_EQUIP_COLOR
 xButton.FontSize = Enum.FontSize.Size24
 xButton.TextYAlignment = Enum.TextYAlignment.Bottom
 xButton.BackgroundColor3 = SEARCH_BACKGROUND_COLOR
 xButton.BackgroundTransparency = 0
 xButton.Size = UDim2.new(0, searchFrame.Size.Y.Offset - (SEARCH_BUFFER * 2), 0, searchFrame.Size.Y.Offset - (SEARCH_BUFFER * 2))
 xButton.Position = UDim2.new(1, -xButton.Size.X.Offset - (SEARCH_BUFFER * 2), 0.5, -xButton.Size.Y.Offset / 2)
 xButton.ZIndex = 0
 xButton.Visible = true
 xButton.BorderSizePixel = 0
 xButton.Parent = searchFrame

 local function search()
  local terms = {}
  for word in searchBox.Text:gmatch('%S+') do
   terms[word:lower()] = true
  end

  local hitTable = {}
  for i=  HOTBAR_SLOTS + 1, #Slots do
   local slot = Slots[i]
   local hits = slot:CheckTerms(terms)
   table.insert(hitTable, {slot, hits})
   slot.Frame.Visible = false
  end

  table.sort(hitTable, function(left, right)
   return left[2] > right[2]
  end)
  ResultsIndices = {}

  for i, data in ipairs(hitTable) do
   local slot, hits = data[1], data[2]
   if hits > 0 then
    ResultsIndices[slot] = HOTBAR_SLOTS + i
    slot:Reposition()
    slot.Frame.Visible = true
   end
  end

  ScrollingFrame.CanvasPosition = Vector2.new(0, 0)

  xButton.ZIndex = 3
 end

 local function clearResults()
  if xButton.ZIndex > 0 then
   ResultsIndices = nil
   for i=  HOTBAR_SLOTS + 1, #Slots do
    local slot = Slots[i]
    slot:Reposition()
    slot.Frame.Visible = true
   end
   xButton.ZIndex = 0
  end
 end

 local function reset()
  clearResults()
  searchBox.Text = SEARCH_TEXT
 end

 local function onChanged(property)
  if property == 'Text' then
   local text = searchBox.Text
   if text == '' then
    clearResults()
   elseif text ~= SEARCH_TEXT then
    search()
   end
  end
 end

 local function onFocused()
  if searchBox.Text == SEARCH_TEXT then
   searchBox.Text = ''
  end
 end

 local function focusLost(enterPressed)
  if enterPressed then

   search()
  elseif searchBox.Text == '' then
   searchBox.Text = SEARCH_TEXT
  end
 end

 searchBox.Focused:connect(onFocused)
 xButton.MouseButton1Click:connect(reset)
 searchBox.Changed:connect(onChanged)
 searchBox.FocusLost:connect(focusLost)

 BackpackScript.StateChanged.Event:connect(function(isNowOpen)
  xButton.Modal = isNowOpen
  if not isNowOpen then
   reset()
  end
 end)

 HotkeyFns[Enum.KeyCode.Escape.Value] = function(isProcessed)
  if isProcessed then
   reset()
  elseif InventoryFrame.Visible then
   BackpackScript.OpenClose()
  end
 end

 local function detectGamepad(input, processed)
  if input.UserInputType == Enum.UserInputType.Gamepad1 then
   searchFrame.Visible = false
  else
   searchFrame.Visible = true
  end
 end
 local uis = game:GetService('UserInputService')
 uis.InputBegan:connect(detectGamepad)
 uis.InputChanged:connect(detectGamepad)
   end


 local arrowFrame, arrowIcon = nil, nil, nil
 local collapsed, closed, opened = nil, nil, nil

 local removeHotBarSlot = function(name, state, input)
  if state ~= Enum.UserInputState.Begin then return end
  if not GuiService.SelectedCoreObject then return end

  for i=  1, HOTBAR_SLOTS do
   if Slots[i].Frame == GuiService.SelectedCoreObject and Slots[i].Tool then
    Slots[i]:MoveToInventory()
    return
   end
  end
 end

 local function openClose()
  if not next(Dragging) then
   InventoryFrame.Visible = not InventoryFrame.Visible
   local nowOpen = InventoryFrame.Visible
   if arrowIcon then
    arrowIcon.Image = (nowOpen) and ARROW_IMAGE_CLOSE or ARROW_IMAGE_OPEN
   end
   AdjustHotbarFrames()
   UpdateArrowFrame()
   HotbarFrame.Active = not HotbarFrame.Active
   for i=  1, HOTBAR_SLOTS do
    Slots[i]:SetClickability(not nowOpen)
   end
  end

  if GamepadEnabled then
   if InventoryFrame.Visible then
    local lastInputType = UserInputService:GetLastInputType()
               local currentlyUsingGamepad = (lastInputType == Enum.UserInputType.Gamepad1 or lastInputType == Enum.UserInputType.Gamepad2or
                                                lastInputType == Enum.UserInputType.Gamepad3 or lastInputType == Enum.UserInputType.Gamepad4)
        if currentlyUsingGamepad then
     resizeGamepadHintsFrame()
     gamepadHintsFrame.Visible = true
    end
    enableGamepadInventoryControl()
   else
    gamepadHintsFrame.Visible = false
    disableGamepadInventoryControl()
   end
  end

  if InventoryFrame.Visible and GamepadEnabled then
   ContextActionService:BindCoreAction('RBXRemoveSlot', removeHotBarSlot, false, Enum.KeyCode.ButtonX)
  elseif GamepadEnabled then
   ContextActionService:UnbindCoreAction('RBXRemoveSlot')
  end

  BackpackScript.IsOpen = InventoryFrame.Visible
  BackpackScript.StateChanged:Fire(InventoryFrame.Visible)

  local SettingsHub = require(RobloxGui.Modules.Settings:WaitForChild('SettingsHub'))
  if SettingsHub.Instance.Visible then
   SettingsHub:SetVisibility(false)
  end
 end
 HotkeyFns[ARROW_HOTKEY] = openClose
 BackpackScript.OpenClose = openClose

 if not TopBarEnabled then
  arrowFrame = NewGui('Frame', 'Arrow')
  arrowFrame.BackgroundTransparency = BACKGROUND_FADE
  arrowFrame.BackgroundColor3 = BACKGROUND_COLOR
  arrowFrame.Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE / 2)
  local hotbarBottom = HotbarFrame.Position.Y.Offset + HotbarFrame.Size.Y.Offset
  arrowFrame.Position = UDim2.new(0.5, -arrowFrame.Size.X.Offset / 2, 1, hotbarBottom - arrowFrame.Size.Y.Offset)

  arrowIcon = NewGui('ImageLabel', 'Icon')
  arrowIcon.Image = ARROW_IMAGE_OPEN
  arrowIcon.Size = ARROW_SIZE
  arrowIcon.Position = UDim2.new(0.5, -arrowIcon.Size.X.Offset / 2, 0.5, -arrowIcon.Size.Y.Offset / 2)
  arrowIcon.Parent = arrowFrame

  collapsed = arrowFrame.Position
  closed = collapsed + UDim2.new(0, 0, 0, -HotbarFrame.Size.Y.Offset)
  opened = closed + UDim2.new(0, 0, 0, -InventoryFrame.Size.Y.Offset)

  arrowFrame.Parent = MainFrame
 end


 UpdateArrowFrame = function()
  if arrowFrame then
   arrowFrame.Position = (InventoryFrame.Visible) and opened or ((FullHotbarSlots == 0) and collapsed or closed)
  end
 end
   end




while not Player do
 wait()
 Player = PlayersService.LocalPlayer
end


Player.CharacterAdded:connect(OnCharacterAdded)
if Player.Character then
 OnCharacterAdded(Player.Character)
end



 for i=  0, 9 do
  table.insert(HotkeyStrings, tostring(i))
 end
 table.insert(HotkeyStrings, ARROW_HOTKEY_STRING)


 UserInputService.InputBegan:connect(OnInputBegan)


 UserInputService.TextBoxFocused:connect(function() TextBoxFocused = true end)
 UserInputService.TextBoxFocusReleased:connect(function() TextBoxFocused = false end)


 HotkeyFns[DROP_HOTKEY_VALUE] = function()
  if ActiveHopper then
   UnequipAllTools()
  end
 end


 UserInputService.Changed:connect(OnUISChanged)
 OnUISChanged('KeyboardEnabled')


 if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
  gamepadConnected()
 end
 UserInputService.GamepadConnected:connect(function(gamepadEnum)
  if gamepadEnum == Enum.UserInputType.Gamepad1 then
   gamepadConnected()
  end
 end)
 UserInputService.GamepadDisconnected:connect(function(gamepadEnum)
  if gamepadEnum == Enum.UserInputType.Gamepad1 then
   gamepadDisconnected()
  end
 end)
   end

function BackpackScript:TopbarEnabledChanged(enabled)
 topbarEnabled = enabled

 OnCoreGuiChanged(Enum.CoreGuiType.Backpack, StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
end


StarterGui.CoreGuiChangedSignal:connect(OnCoreGuiChanged)
local backpackType, healthType = Enum.CoreGuiType.Backpack, Enum.CoreGuiType.Health
OnCoreGuiChanged(backpackType, StarterGui:GetCoreGuiEnabled(backpackType))
OnCoreGuiChanged(healthType, StarterGui:GetCoreGuiEnabled(healthType))

return BackpackScript

-- chunk: =CoreGui.RobloxGui.Modules.Settings.Pages.Record coverage=1212/2184 consts=539
-- subst=0
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed







local CoreGui = game:GetService('CoreGui')
local RobloxGui = CoreGui:WaitForChild('RobloxGui')
local GuiService = game:GetService('GuiService')
local Settings = UserSettings()
local GameSettings = Settings.GameSettings


RobloxGui:WaitForChild('Modules'):WaitForChild('TenFootInterface')
local utility = require(RobloxGui.Modules.Settings.Utility)
local isTenFootInterface = require(RobloxGui.Modules.TenFootInterface):IsEnabled()


local PageInstance = nil



local function Initialize()
 local settingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
 local this = settingsPageFactory:CreateNewPage()
 local isRecordingVideo = false

 local recordingEvent = Instance.new('BindableEvent')
 recordingEvent.Name = 'RecordingEvent'
 this.RecordingChanged = recordingEvent.Event
 function this:IsRecording()
  return isRecordingVideo
 end


 this.TabHeader.Name = 'RecordTab'

 this.TabHeader.Icon.Image = 'rbxasset://textures/ui/Settings/MenuBarIcons/RecordTab.png'
 this.TabHeader.Icon.Size = UDim2.new(0,41,0,40)
 this.TabHeader.Icon.Position = UDim2.new(0,5,0.5,-20)

 this.TabHeader.Icon.Title.Text = 'Record'

 this.TabHeader.Size = UDim2.new(0,130,1,0)



 this.Page.Name = 'Record'

 local function makeTextLabel(name, text, bold, size, pos, parent)
  local textLabel = utility:Create('TextLabel')(
  {
   Name = name,
   BackgroundTransparency = 1,
   Text = text,
   TextWrapped = true,
   Font = Enum.Font.SourceSans,
   FontSize = Enum.FontSize.Size24,
   TextColor3 = Color3.new(1,1,1),
   Size = size,
   Position = pos,
   TextXAlignment = Enum.TextXAlignment.Left,
   TextYAlignment = Enum.TextYAlignment.Top,
   ZIndex = 2,
   Parent = parent
  });
  if bold then textLabel.Font = Enum.Font.SourceSansBold end

  return textLabel
 end



 function this:SetHub(newHubRef)
  this.HubRef = newHubRef

  local recordEnumNames = {}
  recordEnumNames[1] = 'Save To Disk'
  recordEnumNames[2] = 'Upload to YouTube'

  local startSetting = 2
  if GameSettings.VideoUploadPromptBehavior == Enum.UploadSetting['Never'] then
   startSetting = 1
  end


  local screenshotTitle = makeTextLabel('ScreenshotTitle',
            'Screenshot',
            true, UDim2.new(1,0,0,36), UDim2.new(0,10,0.050000000000000003,0),this.Page)
  screenshotTitle.FontSize = Enum.FontSize.Size36

  local screenshotBody = makeTextLabel('ScreenshotBody',
            "By clicking the \'Take Screenshot\' button, the menu will close and take a screenshot and save it to your computer.",
            false, UDim2.new(1,-10,0,70), UDim2.new(0,0,1,0), screenshotTitle)

  local closeSettingsFunc = function()
   this.HubRef:SetVisibility(false, true)
  end
  this.ScreenshotButton = utility:MakeStyledButton('ScreenshotButton', 'Take Screenshot', UDim2.new(0,300,0,44), closeSettingsFunc, this)

  this.ScreenshotButton.Position = UDim2.new(0,400,1,0)
  this.ScreenshotButton.Parent = screenshotBody



  local videoTitle = makeTextLabel('VideoTitle',
            'Video',
            true, UDim2.new(1,0,0,36), UDim2.new(0,10,0.5,0), this.Page)
  videoTitle.FontSize = Enum.FontSize.Size36

  local videoBody = makeTextLabel('VideoBody',
            "By clicking the \'Record Video\' button, the menu will close and start recording your screen.",
            false, UDim2.new(1,-10,0,70), UDim2.new(0,0,1,0), videoTitle)

  this.VideoSettingsFrame,
  this.VideoSettingsLabel,
  this.VideoSettingsMode = utility:AddNewRow(this, 'Video Settings', 'Selector', recordEnumNames, startSetting, 270)

  this.VideoSettingsMode.IndexChanged:connect(function(newIndex)
   if newIndex == 1 then
    GameSettings.VideoUploadPromptBehavior = Enum.UploadSetting.Never
   elseif newIndex == 2 then
    GameSettings.VideoUploadPromptBehavior = Enum.UploadSetting.Always
   end
  end)


  local recordButton = utility:MakeStyledButton('RecordButton', 'Record Video', UDim2.new(0,300,0,44), closeSettingsFunc, this)

  recordButton.Position = UDim2.new(0,410,1,10)
  recordButton.Parent = this.VideoSettingsMode.SelectorFrame.Parent
  recordButton.MouseButton1Click:connect(function()
   recordingEvent:Fire(not isRecordingVideo)
  end)

  local gameOptions = settings():FindFirstChild('Game Options')
  if gameOptions then
   gameOptions.VideoRecordingChangeRequest:connect(function(recording)
    isRecordingVideo = recording
    if recording then
     recordButton.RecordButtonTextLabel.Text = 'Stop Recording'
    else
     recordButton.RecordButtonTextLabel.Text = 'Record Video'
    end
   end)
  end


  recordButton:SetVerb('RecordToggle')
  this.ScreenshotButton:SetVerb('Screenshot')

  this.Page.Size = UDim2.new(1,0,0,400)
 end

 return this
end



PageInstance = Initialize()

PageInstance.Displayed.Event:connect(function(switchedFromGamepadInput)
 if switchedFromGamepadInput then
  GuiService.SelectedCoreObject = PageInstance.ScreenshotButton
 end
end)


return PageInstance
-- chunk: =CoreGui.RobloxGui.Modules.Settings.SettingsPageFactory coverage=2844/5484 consts=1196
-- subst=0
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed







local GuiService = game:GetService('GuiService')
local HttpService = game:GetService('HttpService')
local UserInputService = game:GetService('UserInputService')

local CoreGui = game:GetService('CoreGui')
local RobloxGui = CoreGui:WaitForChild('RobloxGui')


local utility = require(RobloxGui.Modules.Settings.Utility)



RobloxGui:WaitForChild('Modules'):WaitForChild('TenFootInterface')
local isTenFootInterface = require(RobloxGui.Modules.TenFootInterface):IsEnabled()


local HEADER_SPACING = 5
if utility:IsSmallTouchScreen() then
 HEADER_SPACING = 0
end


local function Initialize()
 local this = {}
 this.HubRef = nil
 this.LastSelectedObject = nil
 this.TabPosition = 0
 this.Active = false
 this.OpenStateChangedCount = 0
 local rows = {}
 local displayed = false


 this.TabHeader = utility:Create('TextButton')(
 {
  Name = 'Header',
  Text = '',
  BackgroundTransparency = 1,
  Size = UDim2.new(0,169,1,0),
  Position = UDim2.new(0.5,0,0,0)
 });
 if utility:IsSmallTouchScreen() then
  this.TabHeader.Size = UDim2.new(0,84,1,0)
 elseif isTenFootInterface then
  this.TabHeader.Size = UDim2.new(0,220,1,0)
 end
 this.TabHeader.MouseButton1Click:connect(function()
  if this.HubRef then
   this.HubRef:SwitchToPage(this, true)
  end
 end)

 local icon = utility:Create('ImageLabel')(
 {
  Name = 'Icon',
  BackgroundTransparency = 1,
  Size = UDim2.new(0,44,0,37),
  Position = UDim2.new(0,10,0.5,-18),
  Image = '',
  ImageTransparency = 0.5,
  Parent = this.TabHeader
 });

 local title = utility:Create('TextLabel')(
 {
  Name = 'Title',
  Text = 'Change Me',
  Font = Enum.Font.SourceSansBold,
  FontSize = Enum.FontSize.Size24,
  TextColor3 = Color3.new(1,1,1),
  BackgroundTransparency = 1,
  Size = UDim2.new(1.05,0,1,0),
  Position = UDim2.new(1.2,0,0,0),
  TextXAlignment = Enum.TextXAlignment.Left,
  TextTransparency = 0.5,
  Parent = icon
 });
 if utility:IsSmallTouchScreen() then
  title.FontSize = Enum.FontSize.Size18
 elseif isTenFootInterface then
  title.FontSize = Enum.FontSize.Size48
 end

 local tabSelection = utility:Create('ImageLabel')(
 {
  Name = 'TabSelection',
  Image = 'rbxasset://textures/ui/Settings/MenuBarAssets/MenuSelection.png',
  ScaleType = Enum.ScaleType.Slice,
  SliceCenter = Rect.new(3,1,4,5),
  Visible = false,
  BackgroundTransparency = 1,
  Size = UDim2.new(1,0,0,6),
  Position = UDim2.new(0,0,1,-6),
  Parent = this.TabHeader
 });


 this.Page = utility:Create('Frame')(
 {
  Name = 'Page',
  BackgroundTransparency = 1,
  Size = UDim2.new(1,0,1,0)
 });


 GuiService:AddSelectionParent(HttpService:GenerateGUID(false), this.Page)



 this.Displayed = Instance.new('BindableEvent')
 this.Displayed.Name = 'Displayed'

 this.Displayed.Event:connect(function()
  if not this.HubRef.Shield.Visible then return end

  this:SelectARow()
 end)

 this.Hidden = Instance.new('BindableEvent')
 this.Hidden.Event:connect(function()
  if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(this.Page) then
   GuiService.SelectedCoreObject = nil
  end
 end)
 this.Hidden.Name = 'Hidden'


 function this:SelectARow(forced)
  if forced or not GuiService.SelectedCoreObject or not GuiService.SelectedCoreObject:IsDescendantOf(this.Page) then
   if this.LastSelectedObject then
    GuiService.SelectedCoreObject = this.LastSelectedObject
   else
    if rows and #rows > 0 then
     local valueChangerFrame = nil

     if type(rows[1].ValueChanger) ~= 'table' then
      valueChangerFrame = rows[1].ValueChanger
     else
      valueChangerFrame = rows[1].ValueChanger.SliderFrameand
             rows[1].ValueChanger.SliderFrame or rows[1].ValueChanger.SelectorFrame
     end
     GuiService.SelectedCoreObject = valueChangerFrame
    end
   end
  end
 end

 function this:Display(pageParent, skipAnimation)
  this.OpenStateChangedCount = this.OpenStateChangedCount + 1

  if this.TabHeader then
   this.TabHeader.TabSelection.Visible = true
   this.TabHeader.Icon.ImageTransparency = 0
   this.TabHeader.Icon.Title.TextTransparency = 0
  end

  this.Page.Parent = pageParent
  this.Page.Visible = true

  local endPos = UDim2.new(0,0,0,0)
  local animationComplete = function()
   this.Page.Visible = true
   displayed = true
   this.Displayed:Fire()
  end
  if skipAnimation then
   this.Page.Position = endPos
   animationComplete()
  else
   this.Page:TweenPosition(endPos, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.10000000000000001,true,animationComplete)
  end
 end
 function this:Hide(direction, newPagePos, skipAnimation, delayBeforeHiding)
  this.OpenStateChangedCount = this.OpenStateChangedCount + 1

  if this.TabHeader then
   this.TabHeader.TabSelection.Visible = false
   this.TabHeader.Icon.ImageTransparency = 0.5
   this.TabHeader.Icon.Title.TextTransparency = 0.5
  end

  if this.Page.Parent then
   local endPos = UDim2.new(1 * direction,0,0,0)
   local animationComplete = function()
    this.Page.Visible = false
    this.Page.Position = UDim2.new(this.TabPosition - newPagePos,0,0,0)
    displayed = false
    this.Hidden:Fire()
   end

   local remove = function()
    if skipAnimation then
     this.Page.Position = endPos
     animationComplete()
    else
     this.Page:TweenPosition(endPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.10000000000000001,true,animationComplete)
    end
   end

   if delayBeforeHiding then
    local myOpenStateChangedCount = this.OpenStateChangedCount
    delay(delayBeforeHiding, function()
     if myOpenStateChangedCount == this.OpenStateChangedCount then
      remove()
     end
    end)
   else
    remove()
   end
  end
 end

 function this:GetDisplayed()
  return displayed
 end

 function this:GetVisibility()
  return this.Page.Parent
 end

 function this:GetTabHeader()
  return this.TabHeader
 end

 function this:SetHub(hubRef)
  this.HubRef = hubRef

  for i, row in next, rows do
   if type(row.ValueChanger) == 'table' then
    row.ValueChanger.HubRef = this.HubRef
   end
  end
 end

 function this:GetSize()
  return this.Page.AbsoluteSize
 end

 function this:AddRow(RowFrame, RowLabel, ValueChangerInstance, ExtraRowSpacing)
  rows[#rows + 1] = {SelectionFrame = RowFrame, Label = RowLabel, ValueChanger = ValueChangerInstance}

  local rowFrameYSize = 0
  if RowFrame then
   rowFrameYSize = RowFrame.Size.Y.Offset
  end

  if ExtraRowSpacing then
   this.Page.Size = UDim2.new(1, 0, 0, this.Page.Size.Y.Offset + rowFrameYSize + ExtraRowSpacing)
  else
   this.Page.Size = UDim2.new(1, 0, 0, this.Page.Size.Y.Offset + rowFrameYSize)
  end

  if this.HubRef and type(ValueChangerInstance) == 'table' then
   ValueChangerInstance.HubRef = this.HubRef
  end
 end

 return this
end



local moduleApiTable = {}

function moduleApiTable:CreateNewPage()
 return Initialize()
end

return moduleApiTable
-- chunk: =CoreGui.RobloxGui.Modules.Settings.Utility coverage=1824/3792 consts=1627
-- subst=0
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: loop-body never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed








local SELECTED_COLOR = Color3.new(0,162/255,1)
local NON_SELECTED_COLOR = Color3.new(78/255,84/255,96/255)

local SELECTED_LEFT_IMAGE = 'rbxasset://textures/ui/Settings/Slider/SelectedBarLeft.png'
local NON_SELECTED_LEFT_IMAGE = 'rbxasset://textures/ui/Settings/Slider/BarLeft.png'
local SELECTED_RIGHT_IMAGE = 'rbxasset://textures/ui/Settings/Slider/SelectedBarRight.png'
local NON_SELECTED_RIGHT_IMAGE= 'rbxasset://textures/ui/Settings/Slider/BarRight.png'

local CONTROLLER_SCROLL_DELTA = 0.20000000000000001
local CONTROLLER_THUMBSTICK_DEADZONE = 0.80000000000000004


local HttpService = game:GetService('HttpService')
local UserInputService = game:GetService('UserInputService')
local GuiService = game:GetService('GuiService')
local RunService = game:GetService('RunService')
local CoreGui = game:GetService('CoreGui')
local RobloxGui = CoreGui:FindFirstChild('RobloxGui')
local ContextActionService = game:GetService('ContextActionService')


local tenFootInterfaceEnabled = false

 RobloxGui:WaitForChild('Modules'):WaitForChild('TenFootInterface')
 tenFootInterfaceEnabled = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
   end




local Util = {}

 function Util.Create(instanceType)
  return function(data)
   local obj = Instance.new(instanceType)
   for k, v in pairs(data) do
    if type(k) == 'number' then
     v.Parent = obj
    else
     obj[k] = v
    end
   end
   return obj
  end
 end
   end



local noSelectionObject = Util.Create('ImageLabel')(
{
 Image = '',
 BackgroundTransparency = 1
});



function clamp(low, high, input)
 return math.max(low, math.min(high, input))
end

function ClampVector2(low, high, input)
 return Vector2.new(clamp(low.x, high.x, input.x), clamp(low.y, high.y, input.y))
end


local Linear = function(t, b, c, d)
 if t >= d then return b + c end

 return c*t/d + b
end

local EaseOutQuad = function(t, b, c, d)
 if t >= d then return b + c end

 t = t/d;
 return -c * t*(t-2) + b
end

local EaseInOutQuad = function(t, b, c, d)
 if t >= d then return b + c end

 t = t / (d/2);
 if (t < 1) then return c/2*t*t + b end;
 t = t - 1;
 return -c/2 * (t*(t-2) - 1) + b;
end

function PropertyTweener(instance, prop, start, final, duration, easingFunc, cbFunc)
 local this = {}
 this.StartTime = tick()
 this.EndTime = this.StartTime + duration
 this.Cancelled = false

 local finished = false
 local percentComplete = 0

 local function finalize()
  if instance then
   instance[prop] = easingFunc(1, start, final - start, 1)
  end
  finished = true
  percentComplete = 1
  if cbFunc then
   cbFunc()
  end
 end


 instance[prop] = easingFunc(0, start, final - start, duration)
 spawn(function()
  local now = tick()
  while now < this.EndTime and instance do
   if this.Cancelled then
    return
   end
   instance[prop] = easingFunc(now - this.StartTime, start, final - start, duration)
   percentComplete = clamp(0, 1, (now - this.StartTime) / duration)
   RunService.RenderStepped:wait()
   now = tick()
  end
  if this.Cancelled == false and instance then
   finalize()
  end
 end)

 function this:GetFinal()
  return final
 end

 function this:GetPercentComplete()
  return percentComplete
 end

 function this:IsFinished()
  return finished
 end

 function this:Finish()
  if not finished then
   self:Cancel()
   finalize()
  end
 end

 function this:Cancel()
  this.Cancelled = true
 end

 return this
end



local function CreateSignal()
 local sig = {}

 local mSignaler = Instance.new('BindableEvent')

 local mArgData = nil
 local mArgDataCount = nil

 function sig:fire(...)
  mArgData = {...}
  mArgDataCount = select('#', ...)
  mSignaler:Fire()
 end

 function sig:connect(f)
  if not f then error('connect(nil)', 2) end
  return mSignaler.Event:connect(function()
   f(unpack(mArgData, 1, mArgDataCount))
  end)
 end

 function sig:wait()
  mSignaler.Event:wait()
  assert(mArgData, 'Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.')
  return unpack(mArgData, 1, mArgDataCount)
 end

 return sig
end

local function getViewportSize()
 while not game.Workspace.CurrentCamera do
  game.Workspace.Changed:wait()
 end

 while game.Workspace.CurrentCamera.ViewportSize == Vector2.new(0,0) do
  game.Workspace.CurrentCamera.Changed:wait()
 end

 return game.Workspace.CurrentCamera.ViewportSize
end

local function isSmallTouchScreen()
 return UserInputService.TouchEnabled and getViewportSize().Y <= 500
end

local function isTenFootInterface()
 return tenFootInterfaceEnabled
end

local function usesSelectedObject()
 if UserInputService.TouchEnabled and not UserInputService.GamepadEnabled then return false end

 return true
end

local function isPosOverGui(pos, gui, debug)
 local ax, ay = gui.AbsolutePosition.x, gui.AbsolutePosition.y
 local sx, sy = gui.AbsoluteSize.x, gui.AbsoluteSize.y
 local bx, by = ax+sx, ay+sy

 if pos.x > ax and pos.x < bx and pos.y > ay and pos.y < by then
  return true
 else
  return false
 end
end

local function isPosOverGuiWithClipping(pos, gui)
 if not isPosOverGui(pos, gui) then
  return false
 end

 local clipping = false
 local check = gui
 while true do
  if check == nil or (not check:IsA('GuiObject')and not check:IsA('LayerCollector'))then
   clipping = true
   if check and check:IsA('CoreGui')then
    clipping = false
   end
   break
  end

  if check:IsA('GuiObject')and not check.Visible then
   clipping = true
   break
  end
  if check:IsA('LayerCollector')or check.ClipsDescendants then
   if not isPosOverGui(pos, check) then
    clipping = true
    break
   end
  end

  check = check.Parent
 end

 if clipping then
  return false
 else
  return true
 end
end

local function areGuisIntersecting(a, b)
 local aax, aay = a.AbsolutePosition.x, a.AbsolutePosition.y
 local asx, asy = a.AbsoluteSize.x, a.AbsoluteSize.y
 local abx, aby = aax+asx, aay+asy
 local bax, bay = b.AbsolutePosition.x, b.AbsolutePosition.y
 local bsx, bsy = b.AbsoluteSize.x, b.AbsoluteSize.y
 local bbx, bby = bax+bsx, bay+bsy

 local intersectingX = aax < bbx and abx > bax
 local intersectingY = aay < bby and aby > bay
 local intersecting = intersectingX and intersectingY

 return intersecting
end

local function isGuiVisible(gui, debug)
 local clipping = false
 local check = gui
 while true do
  if check == nil or not check:IsA('GuiObject')and not check:IsA('LayerCollector')then
   clipping = true
   if check and check:IsA('CoreGui')then
    clipping = false
   end
   break
  end

  if check:IsA('GuiObject')and not check.Visible then
   clipping = true
   break
  end
  if check:IsA('LayerCollector')or check.ClipsDescendants then
   if not areGuisIntersecting(check, gui) then
    clipping = true
    break
   end
  end

  check = check.Parent
 end

 if clipping then
  return false
 else
  return true
 end
end

local function MakeButton(name, text, size, clickFunc, pageRef, hubRef)
 local SelectionOverrideObject = Util.Create('ImageLabel')(
 {
  Image = '',
  BackgroundTransparency = 1
 });

 local button = Util.Create('ImageButton')(
 {
  Name = name .. 'Button',
  Image = 'rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png',
  ScaleType = Enum.ScaleType.Slice,
  SliceCenter = Rect.new(8,6,46,44),
  AutoButtonColor = false,
  BackgroundTransparency = 1,
  Size = size,
  ZIndex = 2,
  SelectionImageObject = SelectionOverrideObject
 });
 button.NextSelectionLeft = button
 button.NextSelectionRight = button

 local enabled = Util.Create('BoolValue')(
 {
  Name = 'Enabled',
  Parent = button,
  Value = true
 })

 if clickFunc then
  button.MouseButton1Click:connect(function()
   local lastInputType = nil
   pcall(function() lastInputType = UserInputService:GetLastInputType() end)
   if lastInputType then
    clickFunc(lastInputTypee == Enum.UserInputType.Gamepad1 or lastInputType == Enum.UserInputType.Gamepad2or
     lastInputType == Enum.UserInputType.Gamepad3 or lastInputType == Enum.UserInputType.Gamepad4)
   else
    clickFunc(false)
   end
  end)
 end

 local function isPointerInput(inputObject)
  return (inputObject.UserInputType == Enum.UserInputType.MouseMovement or inputObject.UserInputType == Enum.UserInputType.Touch)
 end

 local function selectButton()
  local hub = hubRef
  if hub == nil then
   if pageRef then
    hub = pageRef.HubRef
   end
  end

  if (hub and hub.Active or hub == nil) then
   button.Image = 'rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png'

   local scrollTo = button
   if rowRef then
    scrollTo = rowRef
   end
   if hub then
    hub:ScrollToFrame(scrollTo)
   end
  end
 end

 local function deselectButton()
  button.Image = 'rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png'
 end

 button.InputBegan:connect(function(inputObject)
  if button.Selectable and isPointerInput(inputObject) then
   selectButton()
  end
 end)
 button.InputEnded:connect(function(inputObject)
  if button.Selectable and GuiService.SelectedCoreObject ~= button and isPointerInput(inputObject) then
   deselectButton()
  end
 end)

 local rowRef = nil
 local function setRowRef(ref)
  rowRef = ref
 end
 button.SelectionGained:connect(function()
  selectButton()
 end)
 button.SelectionLost:connect(function()
  deselectButton()
 end)

 local textLabel = Util.Create('TextLabel')(
 {
  Name = name .. 'TextLabel',
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  Size = UDim2.new(1, 0, 1, -8),
  Position = UDim2.new(0,0,0,0),
  TextColor3 = Color3.new(1,1,1),
  TextYAlignment = Enum.TextYAlignment.Center,
  Font = Enum.Font.SourceSansBold,
  FontSize = Enum.FontSize.Size24,
  Text = text,
  TextWrapped = true,
  ZIndex = 2,
  Parent = button
 });

 if isSmallTouchScreen() then
  textLabel.FontSize = Enum.FontSize.Size18
 elseif isTenFootInterface() then
  textLabel.FontSize = Enum.FontSize.Size36
 end

 local guiServiceCon = GuiService.Changed:connect(function(prop)
  if prop ~= 'SelectedCoreObject' then return end
  if not usesSelectedObject() then return end

  if GuiService.SelectedCoreObject == nil or GuiService.SelectedCoreObject ~= button then
   deselectButton()
   return
  end

  if button.Selectable then
   selectButton()
  end
 end)

 return button, textLabel, setRowRef
end

local function CreateDropDown(dropDownStringTable, startPosition, settingsHub)

 local DEFAULT_DROPDOWN_TEXT = 'Choose One'
 local SCROLLING_FRAME_PIXEL_OFFSET = 25
 local SELECTION_TEXT_COLOR_NORMAL = Color3.new(0.69999999999999996,0.69999999999999996,0.69999999999999996)
 local SELECTION_TEXT_COLOR_HIGHLIGHTED = Color3.new(1,1,1)


 local lastSelectedCoreObject= nil


 local this = {}
 this.CurrentIndex = nil

 local indexChangedEvent = Instance.new('BindableEvent')
 indexChangedEvent.Name = 'IndexChanged'

 if type(dropDownStringTable) ~= 'table' then
  error('CreateDropDown dropDownStringTable (first arg) is not a table')
  return this
 end

 local indexChangedEvent = Instance.new('BindableEvent')
 indexChangedEvent.Name = 'IndexChanged'

 local interactable = true
 local guid = HttpService:GenerateGUID(false)
 local dropDownButtonEnabled

 this.CurrentIndex = 0


 local DropDownFullscreenFrame = Util.Create('ImageButton')(
 {
  Name = 'DropDownFullscreenFrame',
  BackgroundTransparency = 0.20000000000000001,
  BorderSizePixel = 0,
  Size = UDim2.new(1, 0, 1, 0),
  BackgroundColor3 = Color3.new(0,0,0),
  ZIndex = 10,
  Active = true,
  Visible = false,
  Selectable = false,
  AutoButtonColor = false,
  Parent = CoreGui.RobloxGui
 });

 local DropDownSelectionFrame = Util.Create('ImageLabel')(
 {
  Name = 'DropDownSelectionFrame',
  Image = 'rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png',
  ScaleType = Enum.ScaleType.Slice,
  SliceCenter = Rect.new(8,6,46,44),
  BackgroundTransparency = 1,
  Size = UDim2.new(0, 400, 0.90000000000000002,0),
  Position = UDim2.new(0.5, -200, 0.050000000000000003,0),
  ZIndex = 10,
  Parent = DropDownFullscreenFrame
 });

 local DropDownScrollingFrame = Util.Create('ScrollingFrame')(
 {
  Name = 'DropDownScrollingFrame',
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  Size = UDim2.new(1, -20, 1, -SCROLLING_FRAME_PIXEL_OFFSET),
  Position = UDim2.new(0, 10, 0, 10),
  ZIndex = 10,
  Parent = DropDownSelectionFrame
 });

 local guiServiceChangeCon = nil
 local active = false
 local hideDropDownSelection = function(name, inputState)
  if name ~= nil and inputState ~= Enum.UserInputState.Begin then return end
  this.DropDownFrame.Selectable = interactable

  if DropDownFullscreenFrame.Visible and usesSelectedObject() then
   GuiService.SelectedCoreObject = lastSelectedCoreObject
  end
  DropDownFullscreenFrame.Visible = false
  if guiServiceChangeCon then guiServiceChangeCon:disconnect() end
  ContextActionService:UnbindCoreAction(guid .. 'Action')
  ContextActionService:UnbindCoreAction(guid .. 'FreezeAction')

  settingsHub:SetActive(true)

  dropDownButtonEnabled.Value = interactable
  active = false
 end
 local noOpFunc = function() end

 local DropDownFrameClicked = function()
  if not interactable then return end

  this.DropDownFrame.Selectable = false
  active = true

  DropDownFullscreenFrame.Visible = true
  if not this.CurrentIndex then this.CurrentIndex = 1 end
  if this.CurrentIndex <= 0 then this.CurrentIndex = 1 end

  lastSelectedCoreObject = this.DropDownFrame
  GuiService.SelectedCoreObject = this.Selections[this.CurrentIndex]

  guiServiceChangeCon = GuiService.Changed:connect(function(prop)
   if not prop == 'SelectedCoreObject' then return end
   for i=  1, #this.Selections do
    if GuiService.SelectedCoreObject == this.Selections[i] then
     this.Selections[i].TextColor3 = SELECTION_TEXT_COLOR_HIGHLIGHTED
    else
     this.Selections[i].TextColor3 = SELECTION_TEXT_COLOR_NORMAL
    end
   end
  end)

  ContextActionService:BindCoreAction(guid .. 'FreezeAction', noOpFunc, false, Enum.UserInputType.Keyboard, Enum.UserInputType.Gamepad1)
  ContextActionService:BindCoreAction(guid .. 'Action', hideDropDownSelection, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)

  settingsHub:SetActive(false)

  dropDownButtonEnabled.Value = false
 end

 local dropDownFrameSize = UDim2.new(0,400,0,44)
 if isSmallTouchScreen() then
  dropDownFrameSize = UDim2.new(0,300,0,44)
 end
 this.DropDownFrame = MakeButton('DropDownFrame', DEFAULT_DROPDOWN_TEXT, dropDownFrameSize, DropDownFrameClicked)
 dropDownButtonEnabled = this.DropDownFrame.Enabled
 local selectedTextLabel = this.DropDownFrame.DropDownFrameTextLabel
 local dropDownImage = Util.Create('ImageLabel')(
 {
  Name = 'DropDownImage',
  Image = 'rbxasset://textures/ui/Settings/DropDown/DropDown.png',
  BackgroundTransparency = 1,
  Size = UDim2.new(0,15,0,10),
  Position = UDim2.new(1, -45,0.5,-7),
  ZIndex = 2,
  Parent = this.DropDownFrame
 });



 local function setSelection(index)
  local shouldFireChanged = false
  for i, selectionLabel in pairs(this.Selections) do
   if i == index then
    selectedTextLabel.Text = selectionLabel.Text
    this.CurrentIndex = i

    shouldFireChanged = true
   end
  end

  if shouldFireChanged then
   indexChangedEvent:Fire(index)
  end
 end

 local function setSelectionByValue(value)
  local shouldFireChanged = false
  for i, selectionLabel in pairs(this.Selections) do
   if selectionLabel.Text == value then
    selectedTextLabel.Text = selectionLabel.Text
    this.CurrentIndex = i

    shouldFireChanged = true
   end
  end

  if shouldFireChanged then
   indexChangedEvent:Fire(this.CurrentIndex)
  end
  return shouldFireChanged
 end

 local enterIsDown = false
 local function processInput(input)
  if input.UserInputState == Enum.UserInputState.Begin then
   if input.KeyCode == Enum.KeyCode.Return then
    if GuiService.SelectedCoreObject == this.DropDownFrame or this.SelectionInfo and this.SelectionInfo[GuiService.SelectedCoreObject] then
     enterIsDown = true
    end
   end
  elseif input.UserInputState == Enum.UserInputState.End then
   if input.KeyCode == Enum.KeyCode.Return and enterIsDown then
    enterIsDown = false
    if GuiService.SelectedCoreObject == this.DropDownFrame then
     DropDownFrameClicked()
    elseif this.SelectionInfo and this.SelectionInfo[GuiService.SelectedCoreObject] then
     local info = this.SelectionInfo[GuiService.SelectedCoreObject]
     info.Clicked()
    end
   end
  end
 end



 this.IndexChanged = indexChangedEvent.Event

 function this:SetSelectionIndex(newIndex)
  setSelection(newIndex)
 end

 function this:SetSelectionByValue(value)
  return setSelectionByValue(value)
 end

 function this:ResetSelectionIndex()
  this.CurrentIndex = nil
  selectedTextLabel.Text = DEFAULT_DROPDOWN_TEXT
  hideDropDownSelection()
 end

 function this:GetSelectedIndex()
  return this.CurrentIndex
 end

 function this:SetZIndex(newZIndex)
  this.DropDownFrame.ZIndex = newZIndex
  dropDownImage.ZIndex = newZIndex
  selectedTextLabel.ZIndex = newZIndex
 end

 function this:SetInteractable(value)
  interactable = value
  this.DropDownFrame.Selectable = interactable

  if not interactable then
   hideDropDownSelection()
   this:SetZIndex(1)
  else
   this:SetZIndex(2)
  end

  dropDownButtonEnabled.Value = value and not active
 end


 function this:UpdateDropDownList(dropDownStringTable)
  if this.Selections then
   for i=  1, #this.Selections do
    this.Selections[i]:Destroy()
   end
  end

  this.Selections = {}
  this.SelectionInfo = {}

  for i,v in pairs(dropDownStringTable) do
   local SelectionOverrideObject = Util.Create('Frame')(
   {
    BackgroundTransparency = 0.69999999999999996,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, 0)
   });

   local nextSelection = Util.Create('TextButton')(
   {
    Name = 'Selection' .. tostring(i),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Size = UDim2.new(1, -28, 0, 50),
    Position = UDim2.new(0,14,0, (i - 1) * 51),
    TextColor3 = SELECTION_TEXT_COLOR_NORMAL,
    Font = Enum.Font.SourceSans,
    FontSize = Enum.FontSize.Size24,
    Text = v,
    ZIndex = 10,
    SelectionImageObject = SelectionOverrideObject,
    Parent = DropDownScrollingFrame
   });

   if i == startPosition then
    this.CurrentIndex = i
    selectedTextLabel.Text = v
    nextSelection.TextColor3 = SELECTION_TEXT_COLOR_HIGHLIGHTED
   elseif not startPosition and i == 1 then
    nextSelection.TextColor3 = SELECTION_TEXT_COLOR_HIGHLIGHTED
   end

   local clicked = function()
    selectedTextLabel.Text = nextSelection.Text
    hideDropDownSelection()
    this.CurrentIndex = i
    indexChangedEvent:Fire(i)
   end

   nextSelection.MouseButton1Click:connect(clicked)

   nextSelection.MouseEnter:connect(function()
    if usesSelectedObject() then
     GuiService.SelectedCoreObject = nextSelection
    end
   end)

   this.Selections[i] = nextSelection
   this.SelectionInfo[nextSelection] = {Clicked = clicked}
  end

  GuiService:RemoveSelectionGroup(guid)
  GuiService:AddSelectionTuple(guid, unpack(this.Selections))

  DropDownScrollingFrame.CanvasSize = UDim2.new(1,-20,0,#dropDownStringTable * 51)

  local function updateDropDownSize()
   if DropDownScrollingFrame.CanvasSize.Y.Offset < (DropDownFullscreenFrame.AbsoluteSize.Y - 10) then
    DropDownSelectionFrame.Size = UDim2.new(DropDownSelectionFrame.Size.X.Scale, DropDownSelectionFrame.Size.X.Offset,
              0,DropDownScrollingFrame.CanvasSize.Y.Offset + SCROLLING_FRAME_PIXEL_OFFSET)
    DropDownSelectionFrame.Position = UDim2.new(DropDownSelectionFrame.Position.X.Scale, DropDownSelectionFrame.Position.X.Offset,
               0.5, -DropDownSelectionFrame.Size.Y.Offset/2)
   else
    DropDownSelectionFrame.Size = UDim2.new(0, 400, 0.90000000000000002,0)
    DropDownSelectionFrame.Position = UDim2.new(0.5, -200, 0.050000000000000003,0)
   end
  end

  DropDownFullscreenFrame.Changed:connect(function(prop)
   if prop ~= 'AbsoluteSize' then return end
   updateDropDownSize()
  end)

  updateDropDownSize()
 end


 this:UpdateDropDownList(dropDownStringTable)

 DropDownFullscreenFrame.MouseButton1Click:connect(hideDropDownSelection)

 settingsHub.PoppedMenu:connect(function(poppedMenu)
  if poppedMenu == DropDownFullscreenFrame then
   hideDropDownSelection()
  end
 end)

 UserInputService.InputBegan:connect(processInput)
 UserInputService.InputEnded:connect(processInput)

 return this
end


local function CreateSelector(selectionStringTable, startPosition)


 local lastInputDirection = 0
 local TweenTime = 0.14999999999999999


 local this = {}
 this.HubRef = nil

 if type(selectionStringTable) ~= 'table' then
  error('CreateSelector selectionStringTable (first arg) is not a table')
  return this
 end

 local indexChangedEvent = Instance.new('BindableEvent')
 indexChangedEvent.Name = 'IndexChanged'

 local interactable = true

 this.CurrentIndex = 0


 this.SelectorFrame = Util.Create('ImageButton')(
 {
  Name = 'Selector',
  Image = '',
  AutoButtonColor = false,
  NextSelectionLeft = this.SelectorFrame,
  NextSelectionRight = this.SelectorFrame,
  BackgroundTransparency = 1,
  Size = UDim2.new(0,502,0,50),
  ZIndex = 2,
  SelectionImageObject = noSelectionObject
 });
 if isSmallTouchScreen() then
  this.SelectorFrame.Size = UDim2.new(0,400,0,50)
 end

 local leftButton = Util.Create('ImageButton')(
 {
  Name = 'LeftButton',
  BackgroundTransparency = 1,
  Position = UDim2.new(0,-10,0.5,-25),
  Size =  UDim2.new(0,60,0,50),
  Image =  '',
  ZIndex = 3,
  Selectable = false,
  Active = true,
  Parent = this.SelectorFrame
 });
 local rightButton = Util.Create('ImageButton')(
 {
  Name = 'RightButton',
  BackgroundTransparency = 1,
  Position = UDim2.new(1,-50,0.5,-25),
  Size =  UDim2.new(0,50,0,50),
  Image =  '',
  ZIndex = 3,
  Selectable = false,
  Parent = this.SelectorFrame
 });

 local leftButtonImage = Util.Create('ImageLabel')(
 {
  Name = 'LeftButton',
  BackgroundTransparency = 1,
  Position = UDim2.new(1,-24,0.5,-15),
  Size =  UDim2.new(0,18,0,30),
  Image =  'rbxasset://textures/ui/Settings/Slider/Left.png',
  ZIndex = 2,
  Active = true,
  Parent = leftButton
 });
 local rightButtonImage = Util.Create('ImageLabel')(
 {
  Name = 'RightButton',
  BackgroundTransparency = 1,
  Position = UDim2.new(0,6,0.5,-15),
  Size =  UDim2.new(0,18,0,30),
  Image =  'rbxasset://textures/ui/Settings/Slider/Right.png',
  ZIndex = 2,
  Parent = rightButton
 });


 this.Selections = {}
 local isSelectionLabelVisible = {}
 local isAutoSelectButton = {}

 for i,v in pairs(selectionStringTable) do
  local nextSelection = Util.Create('TextLabel')(
  {
   Name = 'Selection' .. tostring(i),
   BackgroundTransparency = 1,
   BorderSizePixel = 0,
   Size = UDim2.new(1,leftButton.Size.X.Offset * -2, 1, 0),
   Position = UDim2.new(1,0,0,0),
   TextColor3 = Color3.new(1,1,1),
   TextYAlignment = Enum.TextYAlignment.Center,
   TextTransparency = 0.5,
   Font = Enum.Font.SourceSans,
   FontSize = Enum.FontSize.Size24,
   Text = v,
   ZIndex = 2,
   Visible = false,
   Parent = this.SelectorFrame
  });
  if isTenFootInterface() then
   nextSelection.FontSize = Enum.FontSize.Size36
  end

  if i == startPosition then
   this.CurrentIndex = i
   nextSelection.Position = UDim2.new(0,leftButton.Size.X.Offset,0,0)
   nextSelection.Visible = true

   isSelectionLabelVisible[nextSelection] = true
  else
   isSelectionLabelVisible[nextSelection] = false
  end

  local autoSelectButton = Util.Create('ImageButton')({
   Name = 'AutoSelectButton',
   BackgroundTransparency = 1,
   Image = '',
   Size = UDim2.new(1, 0, 1, 0),
   Parent = nextSelection,
   ZIndex = 2
  })
  autoSelectButton.MouseButton1Click:connect(function()
   local newIndex = this.CurrentIndex + 1
   if newIndex > #this.Selections then
    newIndex = 1
   end
   this:SetSelectionIndex(newIndex)
   if usesSelectedObject() then
    GuiService.SelectedCoreObject = this.SelectorFrame
   end
  end)
  isAutoSelectButton[autoSelectButton] = true

  this.Selections[i] = nextSelection
 end



 local function setSelection(index, direction)
  for i, selectionLabel in pairs(this.Selections) do
   local isSelected = (i == index)

   if not selectionLabel:IsDescendantOf(game) then
    this.CurrentIndex = i
    indexChangedEvent:Fire(index)
    return
   end

   local tweenPos = UDim2.new(0,leftButton.Size.X.Offset * direction * 3,0,0)
   if isSelectionLabelVisible[selectionLabel] then
    tweenPos = UDim2.new(0,leftButton.Size.X.Offset * -direction * 3,0,0)
   end

   if tweenPos.X.Offset < 0 then
    tweenPos = UDim2.new(0,tweenPos.X.Offset + (selectionLabel.AbsoluteSize.X/4),0,0)
   end

   if isSelected then
    isSelectionLabelVisible[selectionLabel] = true
    selectionLabel.Position = tweenPos
    selectionLabel.Visible = true
    PropertyTweener(selectionLabel, 'TextTransparency', 1, 0, TweenTime * 1.1000000000000001,EaseOutQuad)
    selectionLabel:TweenPosition(UDim2.new(0,leftButton.Size.X.Offset,0,0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, TweenTime, true)
    this.CurrentIndex = i
    indexChangedEvent:Fire(index)
   elseif isSelectionLabelVisible[selectionLabel] then
    isSelectionLabelVisible[selectionLabel] = false
    PropertyTweener(selectionLabel, 'TextTransparency', 0, 1, TweenTime * 1.1000000000000001,EaseOutQuad)
    selectionLabel:TweenPosition(tweenPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, TweenTime * 0.90000000000000002,true)
   end
  end
 end

 local function stepFunc(inputObject, step)
  if not interactable then return end

  if inputObject ~= nil and inputObject.UserInputType ~= Enum.UserInputType.MouseButton1and
   inputObject.UserInputType ~= Enum.UserInputType.Gamepad1 and inputObject.UserInputType ~= Enum.UserInputType.Gamepad2and
   inputObject.UserInputType ~= Enum.UserInputType.Gamepad3 and inputObject.UserInputType ~= Enum.UserInputType.Gamepad4and
   inputObject.UserInputType ~= Enum.UserInputType.Keyboard then return end

  if usesSelectedObject() then
   GuiService.SelectedCoreObject = this.SelectorFrame
  end

  local newIndex = step + this.CurrentIndex

  local direction = 0
  if newIndex > this.CurrentIndex then
   direction = 1
  else
   direction = -1
  end

  if newIndex > #this.Selections then
   newIndex = 1
  elseif newIndex < 1 then
   newIndex = #this.Selections
  end

  setSelection(newIndex, direction)
 end

 local guiServiceCon = nil
 local function connectToGuiService()
  guiServiceCon = GuiService.Changed:connect(function(prop)
   if prop == 'SelectedCoreObject' then
    if GuiService.SelectedCoreObject == this.SelectorFrame then
     this.Selections[this.CurrentIndex].TextTransparency = 0
    else
     if GuiService.SelectedCoreObject ~= nil and isAutoSelectButton[GuiService.SelectedCoreObject] then
      GuiService.SelectedCoreObject = this.SelectorFrame
     else
      this.Selections[this.CurrentIndex].TextTransparency = 0.5
     end
    end
   end
  end)
 end


 this.IndexChanged = indexChangedEvent.Event

 function this:SetSelectionIndex(newIndex)
  setSelection(newIndex, 1)
 end

 function this:GetSelectedIndex()
  return this.CurrentIndex
 end

 function this:SetZIndex(newZIndex)
  leftButton.ZIndex = newZIndex
  rightButton.ZIndex = newZIndex
  leftButtonImage.ZIndex = newZIndex
  rightButtonImage.ZIndex = newZIndex

  for i=  1, #this.Selections do
   this.Selections[i].ZIndex = newZIndex
  end
 end

 function this:SetInteractable(value)
  interactable = value
  this.SelectorFrame.Selectable = interactable
 end


 leftButton.InputBegan:connect(function(inputObject)
  if inputObject.UserInputType == Enum.UserInputType.Touch then
   stepFunc(nil, -1)
  end
 end)
 leftButton.MouseButton1Click:connect(function()
  if not UserInputService.TouchEnabled then
   stepFunc(nil, -1)
  end
 end)
 rightButton.InputBegan:connect(function(inputObject)
  if inputObject.UserInputType == Enum.UserInputType.Touch then
   stepFunc(nil, 1)
  end
 end)
 rightButton.MouseButton1Click:connect(function()
  if not UserInputService.TouchEnabled then
   stepFunc(nil, 1)
  end
 end)

 local isInTree = true

 UserInputService.InputBegan:connect(function(inputObject)
  if not interactable then return end
  if not isInTree then return end

  if inputObject.UserInputType ~= Enum.UserInputType.Gamepad1 and inputObject.UserInputType ~= Enum.UserInputType.Keyboard then return end
  if GuiService.SelectedCoreObject ~= this.SelectorFrame then return end

  if inputObject.KeyCode == Enum.KeyCode.DPadLeft or inputObject.KeyCode == Enum.KeyCode.Left or inputObject.KeyCode == Enum.KeyCode.A then
   stepFunc(inputObject, -1)
  elseif inputObject.KeyCode == Enum.KeyCode.DPadRight or inputObject.KeyCode == Enum.KeyCode.Right or inputObject.KeyCode == Enum.KeyCode.D then
   stepFunc(inputObject, 1)
  end
 end)

 UserInputService.InputChanged:connect(function(inputObject)
  if not interactable then return end
  if not isInTree then lastInputDirection = 0 return end

  if inputObject.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
  if GuiService.SelectedCoreObject ~= this.SelectorFrame then return end
  if inputObject.KeyCode ~= Enum.KeyCode.Thumbstick1 then return end


  if inputObject.Position.X > CONTROLLER_THUMBSTICK_DEADZONE and inputObject.Delta.X > 0 and lastInputDirection ~= 1 then
   lastInputDirection = 1
   stepFunc(inputObject, lastInputDirection)
  elseif inputObject.Position.X < -CONTROLLER_THUMBSTICK_DEADZONE and inputObject.Delta.X < 0 and lastInputDirection ~= -1 then
   lastInputDirection = -1
   stepFunc(inputObject, lastInputDirection)
  elseif math.abs(inputObject.Position.X) < CONTROLLER_THUMBSTICK_DEADZONE then
   lastInputDirection = 0
  end
 end)

 this.SelectorFrame.AncestryChanged:connect(function(child, parent)
  isInTree = parent
  if not isInTree then
   if guiServiceCon then guiServiceCon:disconnect() end
  else
   connectToGuiService()
  end
 end)

 connectToGuiService()

 return this
end

local function ShowAlert(alertMessage, okButtonText, settingsHub, okPressedFunc, hasBackground)
 if CoreGui.RobloxGui:FindFirstChild('AlertViewFullScreen') then return end

 local NON_SELECTED_TEXT_COLOR = Color3.new(59/255, 166/255, 241/255)
 local SELECTED_TEXT_COLOR = Color3.new(1,1,1)

 local AlertViewBacking = Util.Create('ImageLabel')(
 {
  Name = 'AlertViewBacking',
  Image = 'rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png',
  ScaleType = Enum.ScaleType.Slice,
  SliceCenter = Rect.new(8,6,46,44),
  BackgroundTransparency = 1,
  ImageTransparency = 1,
  Size = UDim2.new(0, 400, 0, 350),
  Position = UDim2.new(0.5, -200, 0.5, -175),
  ZIndex = 9,
  Parent = CoreGui.RobloxGui
 });
 if hasBackground then
  AlertViewBacking.ImageTransparency = 0
 else
  AlertViewBacking.Size = UDim2.new(0.80000000000000004,0,0,350)
  AlertViewBacking.Position = UDim2.new(0.10000000000000001,0,0.10000000000000001,0)
 end

 if CoreGui.RobloxGui.AbsoluteSize.Y <= AlertViewBacking.Size.Y.Offset then
  AlertViewBacking.Size = UDim2.new(AlertViewBacking.Size.X.Scale, AlertViewBacking.Size.X.Offset,
           AlertViewBacking.Size.Y.Scale, CoreGui.RobloxGui.AbsoluteSize.Y)
  AlertViewBacking.Position = UDim2.new(0.5, -AlertViewBacking.Size.X.Offset/2, 0.5, -AlertViewBacking.Size.Y.Offset/2)
 end

 local AlertViewText = Util.Create('TextLabel')(
 {
  Name = 'AlertViewText',
  BackgroundTransparency = 1,
  Size = UDim2.new(0.94999999999999996,0,0.59999999999999998,0),
  Position = UDim2.new(0.025000000000000001,0,0.050000000000000003,0),
  Font = Enum.Font.SourceSansBold,
  FontSize = Enum.FontSize.Size36,
  Text = alertMessage,
  TextWrapped = true,
  TextColor3 = Color3.new(1,1,1),
  TextXAlignment = Enum.TextXAlignment.Center,
  TextYAlignment = Enum.TextYAlignment.Center,
  ZIndex = 10,
  Parent = AlertViewBacking
 });

 local SelectionOverrideObject = Util.Create('ImageLabel')(
 {
  Image = '',
  BackgroundTransparency = 1
 });

 local removeId = HttpService:GenerateGUID(false)

 local destroyAlert = function()
  AlertViewBacking:Destroy()
  if okPressedFunc then
   okPressedFunc()
  end
  ContextActionService:UnbindCoreAction(removeId)
  Game.GuiService.SelectedCoreObject = nil
  if settingsHub then
   settingsHub:ShowBar()
  end
 end

 local AlertViewButtonSize = UDim2.new(1, -20, 0, 60)
 local AlertViewButtonPosition = UDim2.new(0, 10, 0.65000000000000002,0)
 if not hasBackground then
  AlertViewButtonSize = UDim2.new(0, 200, 0, 50)
  AlertViewButtonPosition = UDim2.new(0.5, -100, 0.65000000000000002,0)
 end

 local AlertViewButton, AlertViewText = MakeButton('AlertViewButton', okButtonText, AlertViewButtonSize, destroyAlert)
 AlertViewButton.Position = AlertViewButtonPosition
 AlertViewButton.NextSelectionLeft = AlertViewButton
 AlertViewButton.NextSelectionRight = AlertViewButton
 AlertViewButton.NextSelectionUp = AlertViewButton
 AlertViewButton.NextSelectionDown = AlertViewButton
 AlertViewButton.ZIndex = 10
 AlertViewText.ZIndex = AlertViewButton.ZIndex
 AlertViewButton.Parent = AlertViewBacking

 if usesSelectedObject() then
  Game.GuiService.SelectedCoreObject = AlertViewButton
 end

 GuiService.SelectedCoreObject = AlertViewButton

 ContextActionService:BindCoreAction(removeId, destroyAlert, false, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonA)

 if settingsHub then
  settingsHub:HideBar()
  settingsHub.Pages.CurrentPage:Hide(1, 1)
 end
end

local function CreateNewSlider(numOfSteps, startStep, minStep)

 local this = {}

 local spacing = 4
 local initialSpacing = 8
 local steps = tonumber(numOfSteps)
 local currentStep = startStep

 local lastInputDirection = 0
 local timeAtLastInput = nil

 local interactable = true

 local renderStepBindName = HttpService:GenerateGUID(false)


 numOfSteps = ''
 startStep = ''

 if steps <= 0 then
  error('CreateNewSlider failed because numOfSteps (first arg) is 0 or negative, please supply a positive integer')
  return
 end

 local valueChangedEvent = Instance.new('BindableEvent')
 valueChangedEvent.Name = 'ValueChanged'


 this.SliderFrame = Util.Create('ImageButton')(
 {
  Name = 'Slider',
  Image = '',
  AutoButtonColor = false,
  NextSelectionLeft = this.SliderFrame,
  NextSelectionRight = this.SliderFrame,
  BackgroundTransparency = 1,
  Size = UDim2.new(0,502,0,50),
  SelectionImageObject = noSelectionObject,
  ZIndex = 2
 });
 if isSmallTouchScreen() then
  this.SliderFrame.Size = UDim2.new(0,400,0,30)
 end

 local leftButton = Util.Create('ImageButton')(
 {
  Name = 'LeftButton',
  BackgroundTransparency = 1,
  Position = UDim2.new(0,0,0.5,-25),
  Size =  UDim2.new(0,50,0,50),
  Image =  '',
  ZIndex = 2,
  Selectable = false,
  Active = true,
  Parent = this.SliderFrame
 });
 local rightButton = Util.Create('ImageButton')(
 {
  Name = 'RightButton',
  BackgroundTransparency = 1,
  Position = UDim2.new(1,-50,0.5,-25),
  Size =  UDim2.new(0,50,0,50),
  Image =  '',
  ZIndex = 2,
  Selectable = false,
  Active = true,
  Parent = this.SliderFrame
 });

 local leftButtonImage = Util.Create('ImageLabel')(
 {
  Name = 'LeftButton',
  BackgroundTransparency = 1,
  Position = UDim2.new(1,-24,0.5,-15),
  Size =  UDim2.new(0,18,0,30),
  Image =  'rbxasset://textures/ui/Settings/Slider/Left.png',
  ZIndex = 2,
  Parent = leftButton
 });
 local rightButtonImage = Util.Create('ImageLabel')(
 {
  Name = 'RightButton',
  BackgroundTransparency = 1,
  Position = UDim2.new(0,6,0.5,-15),
  Size =  UDim2.new(0,18,0,30),
  Image =  'rbxasset://textures/ui/Settings/Slider/Right.png',
  ZIndex = 2,
  Parent = rightButton
 });


 this.Steps = {}
 local stepXSize = 35
 if isSmallTouchScreen() then
  stepXSize = 25
 end

 for i=  1, steps do
  local nextStep = Util.Create('ImageButton')(
  {
   Name = 'Step' .. tostring(i),
   BackgroundColor3 = SELECTED_COLOR,
   BackgroundTransparency = 0.35999999999999999,
   BorderSizePixel = 0,
   AutoButtonColor = false,
   Active = false,
   Position = UDim2.new(0,initialSpacing + leftButton.Size.X.Offset + ((stepXSize + spacing) * (i - 1)),0.5,-12),
   Size =  UDim2.new(0,stepXSize,0, 24),
   Image =  '',
   ZIndex = 2,
   Selectable = false,
   ImageTransparency = 0.35999999999999999,
   Parent = this.SliderFrame
  });

  if i > currentStep then
   nextStep.BackgroundColor3 = NON_SELECTED_COLOR
  end

  if i == 1 or i == steps then
   nextStep.BackgroundTransparency = 1
   nextStep.ScaleType = Enum.ScaleType.Slice
   nextStep.SliceCenter = Rect.new(3,3,32,21)

   if i <= currentStep then
    if i == 1 then
     nextStep.Image = SELECTED_LEFT_IMAGE
    else
     nextStep.Image = SELECTED_RIGHT_IMAGE
    end
   else
    if i == 1 then
     nextStep.Image = NON_SELECTED_LEFT_IMAGE
    else
     nextStep.Image = NON_SELECTED_RIGHT_IMAGE
    end
   end
  end

  this.Steps[#this.Steps + 1] = nextStep
 end

 local xSize = initialSpacing + (leftButton.Size.X.Offset) + this.Steps[#this.Steps].Size.X.Offset+
     this.Steps[#this.Steps].Position.X.Offset
 this.SliderFrame.Size = UDim2.new(0, xSize, 0, this.SliderFrame.Size.Y.Offset)



 local function hideSelection()
  for i=  1, steps do
   this.Steps[i].BackgroundColor3 = NON_SELECTED_COLOR
   if i == 1 then
    this.Steps[i].Image = NON_SELECTED_LEFT_IMAGE
   elseif i == steps then
    this.Steps[i].Image = NON_SELECTED_RIGHT_IMAGE
   end
  end
 end
 local function showSelection()
  for i=  1, steps do
   if i > currentStep then break end
   this.Steps[i].BackgroundColor3 = SELECTED_COLOR
   if i == 1 then
    this.Steps[i].Image = SELECTED_LEFT_IMAGE
   elseif i == steps then
    this.Steps[i].Image = SELECTED_RIGHT_IMAGE
   end
  end
 end
 local function modifySelection(alpha)
  for i=  1, steps do
   if i == 1 or i == steps then
    this.Steps[i].ImageTransparency = alpha
   else
    this.Steps[i].BackgroundTransparency = alpha
   end
  end
 end

 local function setCurrentStep(newStepPosition)
  if not minStep then minStep = 0 end

  leftButton.Visible = true
  rightButton.Visible = true

  if newStepPosition <= minStep then
   newStepPosition = minStep
   leftButton.Visible = false
  end
  if newStepPosition >= steps then
   newStepPosition = steps
   rightButton.Visible = false
  end

  if currentStep == newStepPosition then return end

  currentStep = newStepPosition

  hideSelection()
  showSelection()

  timeAtLastInput = tick()
  valueChangedEvent:Fire(currentStep)
 end

 local function mouseDownFunc(inputObject, newStepPos, repeatAction)
  if not interactable then return end

  if inputObject == nil then return end
  if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 and inputObject.UserInputType ~= Enum.UserInputType.Touch then return end

  if usesSelectedObject() then
   GuiService.SelectedCoreObject = this.SliderFrame
  end

  if repeatAction then
   lastInputDirection = newStepPos - currentStep
  else
   lastInputDirection = 0

   local mouseInputMovedCon = nil
   local mouseInputEndedCon = nil
   mouseInputMovedCon = UserInputService.InputChanged:connect(function( inputObject )
    if inputObject.UserInputType ~= Enum.UserInputType.MouseMovement and inputObject.UserInputType ~= Enum.UserInputType.Touch then return end

    local mousePos = inputObject.Position.X
    for i=  1, steps do
     local stepPosition = this.Steps[i].AbsolutePosition.X
     local stepSize = this.Steps[i].AbsoluteSize.X
     if mousePos >= stepPosition and mousePos <= stepPosition + stepSize then
      setCurrentStep(i)
      break
     elseif i == 1 and mousePos < stepPosition then
      setCurrentStep(0)
      break
     elseif i == steps and mousePos >= stepPosition then
      setCurrentStep(i)
      break
     end
    end
   end)
   mouseInputEndedCon = UserInputService.InputEnded:connect(function( inputObject )
    if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 and inputObject.UserInputType ~= Enum.UserInputType.Touch then return end

    lastInputDirection = 0
    mouseInputEndedCon:disconnect()
    mouseInputMovedCon:disconnect()
   end)
  end

  setCurrentStep(newStepPos)
 end

 local function mouseUpFunc(inputObject)
  if not interactable then return end
  if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

  lastInputDirection = 0
 end

 local function touchClickFunc(inputObject, newStepPos, repeatAction)
  mouseDownFunc(inputObject, newStepPos, repeatAction)
 end


 this.ValueChanged = valueChangedEvent.Event

 function this:SetValue(newValue)
  setCurrentStep(newValue)
 end

 function this:GetValue()
  return currentStep
 end

 function this:SetInteractable(value)
  lastInputDirection = 0
  interactable = value
  this.SliderFrame.Selectable = value
  if not interactable then
   hideSelection()
  else
   showSelection()
  end
 end

 function this:SetZIndex(newZIndex)
  leftButton.ZIndex = newZIndex
  rightButton.ZIndex = newZIndex
  leftButtonImage.ZIndex = newZIndex
  rightButtonImage.ZIndex = newZIndex

  for i=  1, #this.Steps do
   this.Steps[i].ZIndex = newZIndex
  end
 end

 function this:SetMinStep(newMinStep)
  if newMinStep >= 0 and newMinStep <= steps then
   minStep = newMinStep
  end

  if currentStep <= minStep then
   currentStep = minStep
   leftButton.Visible = false
  end
  if currentStep >= steps then
   currentStep = steps
   rightButton.Visible = false
  end
 end



 leftButton.InputBegan:connect(function(inputObject) mouseDownFunc(inputObject, currentStep - 1, true) end)
 leftButton.InputEnded:connect(function(inputObject) mouseUpFunc(inputObject) end)
 leftButton.MouseButton1Click:connect(function()
  if UserInputService.TouchEnabled and not UserInputService.GamepadEnabled then
   touchClickFunc(inputObject, currentStep - 1, true)
  end
 end)
 rightButton.InputBegan:connect(function(inputObject) mouseDownFunc(inputObject, currentStep + 1, true) end)
 rightButton.InputEnded:connect(function(inputObject) mouseUpFunc(inputObject) end)
 rightButton.MouseButton1Click:connect(function()
  if UserInputService.TouchEnabled and not UserInputService.GamepadEnabled then
   touchClickFunc(inputObject, currentStep + 1, true)
  end
 end)

 for i=  1, steps do
  this.Steps[i].InputBegan:connect(function(inputObject) mouseDownFunc(inputObject, i) end)
  this.Steps[i].InputEnded:connect(function(inputObject) mouseUpFunc(inputObject) end)
 end

 this.SliderFrame.InputBegan:connect(function(inputObject) mouseDownFunc(inputObject, currentStep) end)
 this.SliderFrame.InputEnded:connect(function(inputObject) mouseUpFunc(inputObject) end)


 local stepSliderFunc = function()
  if timeAtLastInput == nil then return end

  local currentTime = tick()
  local timeSinceLastInput = currentTime - timeAtLastInput

  if timeSinceLastInput >= CONTROLLER_SCROLL_DELTA then
   setCurrentStep(currentStep + lastInputDirection)
  end
 end

 local isInTree = true
 UserInputService.InputBegan:connect(function(inputObject)
  if not interactable then return end
  if not isInTree then return end

  if inputObject.UserInputType ~= Enum.UserInputType.Gamepad1 and inputObject.UserInputType ~= Enum.UserInputType.Keyboard then return end
  if GuiService.SelectedCoreObject ~= this.SliderFrame then return end

  if inputObject.KeyCode == Enum.KeyCode.DPadLeft or inputObject.KeyCode == Enum.KeyCode.Left or inputObject.KeyCode == Enum.KeyCode.A then
   lastInputDirection = -1
   setCurrentStep(currentStep - 1)
  elseif inputObject.KeyCode == Enum.KeyCode.DPadRight or inputObject.KeyCode == Enum.KeyCode.Right or inputObject.KeyCode == Enum.KeyCode.D then
   lastInputDirection = 1
   setCurrentStep(currentStep + 1)
  end
 end)

 UserInputService.InputEnded:connect(function(inputObject)
  if not interactable then return end

  if inputObject.UserInputType ~= Enum.UserInputType.Gamepad1 and inputObject.UserInputType ~= Enum.UserInputType.Keyboard then return end
  if GuiService.SelectedCoreObject ~= this.SliderFrame then return end

  if inputObject.KeyCode == Enum.KeyCode.Thumbstick1 or inputObject.KeyCode == Enum.KeyCode.DPadLeftor
      inputObject.KeyCode == Enum.KeyCode.DPadRight or inputObject.KeyCode == Enum.KeyCode.Leftor
      inputObject.KeyCode == Enum.KeyCode.A or inputObject.KeyCode == Enum.KeyCode.Right or inputObject.KeyCode == Enum.KeyCode.D then
    lastInputDirection = 0
  end
 end)

 UserInputService.InputChanged:connect(function(inputObject)
  if not interactable then
   lastInputDirection = 0
   return
  end
  if not isInTree then
   lastInputDirection = 0
   return
  end

  if inputObject.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
  if GuiService.SelectedCoreObject ~= this.SliderFrame then return end
  if inputObject.KeyCode ~= Enum.KeyCode.Thumbstick1 then return end

  if inputObject.Position.X > CONTROLLER_THUMBSTICK_DEADZONE and inputObject.Delta.X > 0 and lastInputDirection ~= 1 then
   lastInputDirection = 1
   setCurrentStep(currentStep + 1)
  elseif inputObject.Position.X < -CONTROLLER_THUMBSTICK_DEADZONE and inputObject.Delta.X < 0 and lastInputDirection ~= -1 then
   lastInputDirection = -1
   setCurrentStep(currentStep - 1)
  elseif math.abs(inputObject.Position.X) < CONTROLLER_THUMBSTICK_DEADZONE then
   lastInputDirection = 0
  end
 end)

 GuiService.Changed:connect(function(prop)
  if prop ~= 'SelectedCoreObject' then return end

  if GuiService.SelectedCoreObject == this.SliderFrame then
   modifySelection(0)
   RunService:BindToRenderStep(renderStepBindName, Enum.RenderPriority.Input.Value + 1, stepSliderFunc)
  else
   modifySelection(0.35999999999999999)
   RunService:UnbindFromRenderStep(renderStepBindName)
  end
 end)

 this.SliderFrame.AncestryChanged:connect(function(child, parent)
  isInTree = parent
 end)

 setCurrentStep(currentStep)

 return this
end

local ROW_HEIGHT = 50
if isTenFootInterface() then ROW_HEIGHT = 90 end

local nextPosTable = {}
local function AddNewRow(pageToAddTo, rowDisplayName, selectionType, rowValues, rowDefault, extraSpacing)
 local nextRowPositionY = 0
 local isARealRow = selectionType ~= 'TextBox'

 if nextPosTable[pageToAddTo] then
  nextRowPositionY = nextPosTable[pageToAddTo]
 end

 local RowFrame = nil
 RowFrame = Util.Create('ImageButton')(
 {
  Name = rowDisplayName .. 'Frame',
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  Image = '',
  Active = false,
  AutoButtonColor = false,
  Size = UDim2.new(1,0,0,ROW_HEIGHT),
  Position = UDim2.new(0,0,0,nextRowPositionY),
  ZIndex = 2,
  Selectable = false,
  Parent = pageToAddTo.Page
 });

 if RowFrame and extraSpacing then
  RowFrame.Position = UDim2.new(RowFrame.Position.X.Scale,RowFrame.Position.X.Offset,
          RowFrame.Position.Y.Scale,RowFrame.Position.Y.Offset + extraSpacing)
 end

 local RowLabel = nil
 RowLabel = Util.Create('TextLabel')(
 {
  Name = rowDisplayName .. 'Label',
  Text = rowDisplayName,
  Font = Enum.Font.SourceSansBold,
  FontSize = Enum.FontSize.Size24,
  TextColor3 = Color3.new(1,1,1),
  TextXAlignment = Enum.TextXAlignment.Left,
  BackgroundTransparency = 1,
  Size = UDim2.new(0,200,1,0),
  Position = UDim2.new(0,10,0,0),
  ZIndex = 2,
  Parent = RowFrame
 });
 if isTenFootInterface() then
  RowLabel.FontSize = Enum.FontSize.Size36
 end
 if not isARealRow then
  RowLabel.Text = ''
 end

 local ValueChangerSelection = nil
 local ValueChangerInstance = nil
 if selectionType == 'Slider' then
  ValueChangerInstance = CreateNewSlider(rowValues, rowDefault)
  ValueChangerInstance.SliderFrame.Position = UDim2.new(1,-ValueChangerInstance.SliderFrame.Size.X.Offset,
              0.5,-ValueChangerInstance.SliderFrame.Size.Y.Offset/2)
  ValueChangerInstance.SliderFrame.Parent = RowFrame
  ValueChangerSelection = ValueChangerInstance.SliderFrame
 elseif selectionType == 'Selector' then
  ValueChangerInstance = CreateSelector(rowValues, rowDefault)
  ValueChangerInstance.SelectorFrame.Position = UDim2.new(1,-ValueChangerInstance.SelectorFrame.Size.X.Offset,
              0.5,-ValueChangerInstance.SelectorFrame.Size.Y.Offset/2)
  ValueChangerInstance.SelectorFrame.Parent = RowFrame
  ValueChangerSelection = ValueChangerInstance.SelectorFrame
 elseif selectionType == 'DropDown' then
  ValueChangerInstance = CreateDropDown(rowValues, rowDefault, pageToAddTo.HubRef)
  ValueChangerInstance.DropDownFrame.Position = UDim2.new(1,-ValueChangerInstance.DropDownFrame.Size.X.Offset - 50,
              0.5,-ValueChangerInstance.DropDownFrame.Size.Y.Offset/2)
  ValueChangerInstance.DropDownFrame.Parent = RowFrame
  ValueChangerSelection = ValueChangerInstance.DropDownFrame
 elseif selectionType == 'TextBox' then
  local isMouseOverRow = false
  local forceReturnSelectionOnFocusLost = false
  local SelectionOverrideObject = Util.Create('ImageLabel')(
  {
   Image = '',
   BackgroundTransparency = 1
  });

  ValueChangerInstance = {}
  ValueChangerInstance.HubRef = nil

  local box = Util.Create('TextBox')(
  {
   Size = UDim2.new(1,-10,0,100),
   Position = UDim2.new(0,5,0,nextRowPositionY),
   Text = rowDisplayName,
   TextColor3 = Color3.new(49/255, 49/255, 49/255),
   BackgroundTransparency = 0.5,
   BorderSizePixel = 0,
   TextYAlignment = Enum.TextYAlignment.Top,
   TextXAlignment = Enum.TextXAlignment.Left,
   TextWrapped = true,
   Font = Enum.Font.SourceSans,
   FontSize = Enum.FontSize.Size24,
   ZIndex = 2,
   SelectionImageObject = SelectionOverrideObject,
   ClearTextOnFocus = false,
   Parent = pageToAddTo.Page
  });
  ValueChangerSelection = box

  box.Focused:connect(function()
   if usesSelectedObject() then
    GuiService.SelectedCoreObject = box
   end

   if box.Text == rowDisplayName then
    box.Text = ''
   end
  end)
  box.FocusLost:connect(function(enterPressed, inputObject)
   if GuiService.SelectedCoreObject == box and (not isMouseOverRow or forceReturnSelectionOnFocusLost) then
    GuiService.SelectedCoreObject = nil
   end
   forceReturnSelectionOnFocusLost = false
  end)
  if extraSpacing then
   box.Position = UDim2.new(box.Position.X.Scale,box.Position.X.Offset,
          box.Position.Y.Scale,box.Position.Y.Offset + extraSpacing)
  end

  ValueChangerSelection.SelectionGained:connect(function()
   if usesSelectedObject() then
    box.BackgroundTransparency = 0.10000000000000001

    if ValueChangerInstance.HubRef then
     ValueChangerInstance.HubRef:ScrollToFrame(ValueChangerSelection)
    end
   end
  end)
  ValueChangerSelection.SelectionLost:connect(function()
   if usesSelectedObject() then
    box.BackgroundTransparency = 0.5
   end
  end)

  local setRowSelection = function()
   local fullscreenDropDown = CoreGui.RobloxGui:FindFirstChild('DropDownFullscreenFrame')
   if fullscreenDropDown and fullscreenDropDown.Visible then return end

   local valueFrame = ValueChangerSelection

   if valueFrame and valueFrame.Visible and valueFrame.ZIndex > 1 and usesSelectedObject() and pageToAddTo.Active then
    GuiService.SelectedCoreObject = valueFrame
    isMouseOverRow = true
   end
  end
  local function processInput(input)
   if input.UserInputState == Enum.UserInputState.Begin then
    if input.KeyCode == Enum.KeyCode.Return then
     if GuiService.SelectedCoreObject == ValueChangerSelection then
      forceReturnSelectionOnFocusLost = true
      box:CaptureFocus()
     end
    end
   end
  end
  RowFrame.MouseEnter:connect(setRowSelection)
  RowFrame.Size = UDim2.new(1, 0, 0, 100)

  UserInputService.InputBegan:connect(processInput)
 end

 ValueChangerInstance.Name = rowDisplayName .. 'ValueChanger'

 nextRowPositionY = nextRowPositionY + ROW_HEIGHT
 if extraSpacing then
  nextRowPositionY = nextRowPositionY + extraSpacing
 end

 nextPosTable[pageToAddTo] = nextRowPositionY

 if isARealRow then
  local setRowSelection = function()
   local fullscreenDropDown = CoreGui.RobloxGui:FindFirstChild('DropDownFullscreenFrame')
   if fullscreenDropDown and fullscreenDropDown.Visible then return end

   local valueFrame = ValueChangerInstance.SliderFrame
   if not valueFrame then
    valueFrame = ValueChangerInstance.SliderFrame
   end
   if not valueFrame then
    valueFrame = ValueChangerInstance.DropDownFrame
   end
   if not valueFrame then
    valueFrame = ValueChangerInstance.SelectorFrame
   end

   if valueFrame and valueFrame.Visible and valueFrame.ZIndex > 1 and usesSelectedObject() and pageToAddTo.Active then
    GuiService.SelectedCoreObject = valueFrame
   end
  end
  RowFrame.MouseEnter:connect(setRowSelection)

  ValueChangerSelection.SelectionGained:connect(function()
   if usesSelectedObject() then
    RowFrame.BackgroundTransparency = 0.5

    if ValueChangerInstance.HubRef then
     ValueChangerInstance.HubRef:ScrollToFrame(RowFrame)
    end
   end
  end)
  ValueChangerSelection.SelectionLost:connect(function()
   if usesSelectedObject() then
    RowFrame.BackgroundTransparency = 1
   end
  end)
 end

 pageToAddTo:AddRow(RowFrame, RowLabel, ValueChangerInstance, extraSpacing, false)

 ValueChangerInstance.Selection = ValueChangerSelection

 return RowFrame, RowLabel, ValueChangerInstance
end

local function AddNewRowObject(pageToAddTo, rowDisplayName, rowObject, extraSpacing)
 local nextRowPositionY = 0

 if nextPosTable[pageToAddTo] then
  nextRowPositionY = nextPosTable[pageToAddTo]
 end

 local RowFrame = Util.Create('ImageButton')(
 {
  Name = rowDisplayName .. 'Frame',
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  Image = '',
  Active = false,
  AutoButtonColor = false,
  Size = UDim2.new(1,0,0,ROW_HEIGHT),
  Position = UDim2.new(0,0,0,nextRowPositionY),
  ZIndex = 2,
  Selectable = false,
  SelectionImageObject = noSelectionObject,
  Parent = pageToAddTo.Page
 });
 RowFrame.SelectionGained:connect(function()
  RowFrame.BackgroundTransparency = 0.5
 end)
 RowFrame.SelectionLost:connect(function()
  RowFrame.BackgroundTransparency = 1
 end)

 local RowLabel = Util.Create('TextLabel')(
 {
  Name = rowDisplayName .. 'Label',
  Text = rowDisplayName,
  Font = Enum.Font.SourceSansBold,
  FontSize = Enum.FontSize.Size24,
  TextColor3 = Color3.new(1,1,1),
  TextXAlignment = Enum.TextXAlignment.Left,
  BackgroundTransparency = 1,
  Size = UDim2.new(0,200,1,0),
  Position = UDim2.new(0,10,0,0),
  ZIndex = 2,
  Parent = RowFrame
 });
 if isTenFootInterface() then
  RowLabel.FontSize = Enum.FontSize.Size36
 end

 if extraSpacing then
  RowFrame.Position = UDim2.new(RowFrame.Position.X.Scale,RowFrame.Position.X.Offset,
          RowFrame.Position.Y.Scale,RowFrame.Position.Y.Offset + extraSpacing)
 end

 nextRowPositionY = nextRowPositionY + ROW_HEIGHT
 if extraSpacing then
  nextRowPositionY = nextRowPositionY + extraSpacing
 end

 nextPosTable[pageToAddTo] = nextRowPositionY

 local setRowSelection = function()
  if RowFrame.Visible then
   GuiService.SelectedCoreObject = RowFrame
  end
 end
 RowFrame.MouseEnter:connect(setRowSelection)

 rowObject.SelectionImageObject = noSelectionObject

 rowObject.SelectionGained:connect(function()
   RowFrame.BackgroundTransparency = 0.5
  end)
 rowObject.SelectionLost:connect(function()
  RowFrame.BackgroundTransparency = 1
 end)

 rowObject.Parent = RowFrame

 pageToAddTo:AddRow(RowFrame, RowLabel, rowObject, extraSpacing, true)
 return RowFrame
end


local moduleApiTable = {}

function moduleApiTable:Create(instanceType)
 return function(data)
  local obj = Instance.new(instanceType)
  for k, v in pairs(data) do
   if type(k) == 'number' then
    v.Parent = obj
   else
    obj[k] = v
   end
  end
  return obj
 end
end

function moduleApiTable:GetEaseLinear()
 return Linear
end
function moduleApiTable:GetEaseOutQuad()
 return EaseOutQuad
end
function moduleApiTable:GetEaseInOutQuad()
 return EaseInOutQuad
end

function moduleApiTable:CreateNewSlider(numOfSteps, startStep, minStep)
 return CreateNewSlider(numOfSteps, startStep, minStep)
end

function moduleApiTable:CreateNewSelector(selectionStringTable, startPosition)
 return CreateSelector(selectionStringTable, startPosition)
end

function moduleApiTable:CreateNewDropDown(dropDownStringTable, startPosition)
 return CreateDropDown(dropDownStringTable, startPosition, nil)
end

function moduleApiTable:AddNewRow(pageToAddTo, rowDisplayName, selectionType, rowValues, rowDefault, extraSpacing)
 return AddNewRow(pageToAddTo, rowDisplayName, selectionType, rowValues, rowDefault, extraSpacing)
end

function moduleApiTable:AddNewRowObject(pageToAddTo, rowDisplayName, rowObject, extraSpacing)
 return AddNewRowObject(pageToAddTo, rowDisplayName, rowObject, extraSpacing)
end

function moduleApiTable:ShowAlert(alertMessage, okButtonText, settingsHub, okPressedFunc, hasBackground)
 ShowAlert(alertMessage, okButtonText, settingsHub, okPressedFunc, hasBackground)
end

function moduleApiTable:IsSmallTouchScreen()
 return isSmallTouchScreen()
end

function moduleApiTable:MakeStyledButton(name, text, size, clickFunc, pageRef, hubRef)
 return MakeButton(name, text, size, clickFunc, pageRef, hubRef)
end

function moduleApiTable:CreateSignal()
 return CreateSignal()
end

function  moduleApiTable:UsesSelectedObject()
 return usesSelectedObject();
end

function moduleApiTable:TweenProperty(instance, prop, start, final, duration, easingFunc, cbFunc)
 return PropertyTweener(instance, prop, start, final, duration, easingFunc, cbFunc)
end

return moduleApiTable
-- chunk: =CoreGui.RobloxGui.Modules.TenFootInterface coverage=876/1656 consts=294
-- subst=0
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed







local HEALTH_GREEN_COLOR = Color3.new(27/255, 252/255, 107/255)
local DISPLAY_POS_INIT_INSET = 0
local DISPLAY_ITEM_OFFSET = 4
local FORCE_TEN_FOOT_INTERFACE = false


local CoreGui = game:GetService('CoreGui')
local RobloxGui = CoreGui:WaitForChild('RobloxGui')
local UserInputService = game:GetService('UserInputService')
local GuiService = game:GetService('GuiService')


local tenFootInterfaceEnabled = false

 local platform = UserInputService:GetPlatform()

 tenFootInterfaceEnabled = (platform == Enum.Platform.XBoxOne or platform == Enum.Platform.WiiU or platform == Enum.Platform.PS4or
  platform == Enum.Platform.AndroidTV or platform == Enum.Platform.XBox360 or platform == Enum.Platform.PS3or
  platform == Enum.Platform.Ouya or platform == Enum.Platform.SteamOS)
   end

if FORCE_TEN_FOOT_INTERFACE then
 tenFootInterfaceEnabled = true
end

local Util = {}

 function Util.Create(instanceType)
  return function(data)
   local obj = Instance.new(instanceType)
   for k, v in pairs(data) do
    if type(k) == 'number' then
     v.Parent = obj
    else
     obj[k] = v
    end
   end
   return obj
  end
 end
   end

local function CreateModule()
 local this = {}
 local nextObjectDisplayYPos = DISPLAY_POS_INIT_INSET
 local displayStack = {}


 local function createContainer()
  if not this.Container then
   this.Container = Util.Create('ImageButton')(
   {
    Name = 'TopRightContainer',
    Size = UDim2.new(0, 350, 0, 100),
    Position = UDim2.new(1,-360,0,10),
    AutoButtonColor = false,
    Image = '',
    Active = false,
    BackgroundTransparency = 1,
    Parent = RobloxGui
   });
  end
 end

 function removeFromDisplayStack(displayObject)
  local moveUpFromHere = nil

  for i=  1, #displayStack do
   if displayStack[i] == displayObject then
    moveUpFromHere = i + 1
    break
   end
  end

  local prevObject = displayObject
  for i=  moveUpFromHere, #displayStack do
   local objectToMoveUp = displayStack[i]
   objectToMoveUp.Position = UDim2.new(objectToMoveUp.Position.X.Scale, objectToMoveUp.Position.X.Offset,
            objectToMoveUp.Position.Y.Scale, prevObject.AbsolutePosition.Y)
   prevObject = objectToMoveUp
  end
 end

 function addBackToDisplayStack(displayObject)
  for i=  1, #displayStack do
   if displayStack[i] == displayObject then
    moveDownFromHere = i + 1
    break
   end
  end

  local prevObject = displayObject
  for i=  moveDownFromHere, #displayStack do
   local objectToMoveDown = displayStack[i]
   local nextDisplayPos = prevObject.AbsolutePosition.Y + prevObject.AbsoluteSize.Y + DISPLAY_ITEM_OFFSET
   objectToMoveDown.Position = UDim2.new(objectToMoveDown.Position.X.Scale, objectToMoveDown.Position.X.Offset,
            objectToMoveDown.Position.Y.Scale, nextDisplayPos)
   prevObject = objectToMoveDown
  end
 end

 function addToDisplayStack(displayObject)
  local lastDisplayed = nil
  if #displayStack > 0 then
   lastDisplayed = displayStack[#displayStack]
  end
  displayStack[#displayStack + 1] = displayObject

  local nextDisplayPos = DISPLAY_POS_INIT_INSET
  if lastDisplayed then
   nextDisplayPos = lastDisplayed.AbsolutePosition.Y + lastDisplayed.AbsoluteSize.Y + DISPLAY_ITEM_OFFSET
  end

  displayObject.Position = UDim2.new(displayObject.Position.X.Scale, displayObject.Position.X.Offset,
           displayObject.Position.Y.Scale, nextDisplayPos)

  createContainer()
  displayObject.Parent = this.Container

  displayObject.Changed:connect(function(prop)
   if prop == 'Visible' then
    if not displayObject.Visible then
     removeFromDisplayStack(displayObject)
    else
     addBackToDisplayStack(displayObject)
    end
   end
  end)
 end

 function this:CreateHealthBar()
  this.HealthContainer = Util.Create('Frame')({
   Name = 'HealthContainer',
   Size = UDim2.new(1, -86, 0, 50),
   Position = UDim2.new(0, 92, 0, 0),
   BorderSizePixel = 0,
   BackgroundColor3 = Color3.new(0,0,0),
   BackgroundTransparency = 0.5
  });

  local healthFillHolder = Util.Create('Frame')({
   Name = 'HealthFillHolder',
   Size = UDim2.new(1, -10, 1, -10),
   Position = UDim2.new(0, 5, 0, 5),
   BorderSizePixel = 0,
   BackgroundColor3 = Color3.new(1,1,1),
   BackgroundTransparency = 1,
   Parent = this.HealthContainer
  });

  local healthFill = Util.Create('Frame')({
   Name = 'HealthFill',
   Size = UDim2.new(1, 0, 1, 0),
   Position = UDim2.new(0, 0, 0, 0),
   BorderSizePixel = 0,
   BackgroundTransparency = 0,
   BackgroundColor3 = HEALTH_GREEN_COLOR,
   Parent = healthFillHolder
  });

  local healthText = Util.Create('TextLabel')({
   Name = 'HealthText',
   Size = UDim2.new(0, 98, 0, 50),
   Position = UDim2.new(0, -100, 0, 0),
   BackgroundTransparency = 0.5,
   BackgroundColor3 = Color3.new(0,0,0),
   Font = Enum.Font.SourceSans,
   FontSize = Enum.FontSize.Size36,
   Text = 'Health',
   TextColor3 = Color3.new(1,1,1),
   BorderSizePixel = 0,
   Parent = this.HealthContainer
  });

  local username = Util.Create('TextLabel')({
   Visible = false
  })

  addToDisplayStack(this.HealthContainer)
  createContainer()

  return this.Container, username, this.HealthContainer, healthFill
 end

 function this:SetupTopStat()
  local topStatEnabled = true
  local displayedStat = nil
  local displayedStatChangedCon = nil
  local displayedStatParentedCon = nil
  local leaderstatsChildAddedCon = nil
  local tenFootInterfaceStat = nil

  local function makeTenFootInterfaceStat()
   if tenFootInterfaceStat then return end

   tenFootInterfaceStat = Util.Create('Frame')({
    Name = 'OneStatFrame',
    Size = UDim2.new(1, 0, 0, 36),
    Position = UDim2.new(0, 0, 0, 0),
    BorderSizePixel = 0,
    BackgroundTransparency = 1
   });
   local statName = Util.Create('TextLabel')({
    Name = 'StatName',
    Size = UDim2.new(0.5,0,0,36),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSans,
    FontSize = Enum.FontSize.Size36,
    TextStrokeColor3 = Color3.new(104/255, 104/255, 104/255),
    TextStrokeTransparency = 0,
    Text = ' StatName:',
    TextColor3 = Color3.new(1,1,1),
    TextXAlignment = Enum.TextXAlignment.Left,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = tenFootInterfaceStat
   });
   local statValue = statName:clone()
   statValue.Position = UDim2.new(0.5,0,0,0)
   statValue.Name = 'StatValue'
   statValue.Text = '123,643,231'
   statValue.TextXAlignment = Enum.TextXAlignment.Right
   statValue.Parent = tenFootInterfaceStat

   addToDisplayStack(tenFootInterfaceStat)
  end

  local function setDisplayedStat(newStat)
   if displayedStatChangedCon then displayedStatChangedCon:disconnect() displayedStatChangedCon = nil end
   if displayedStatParentedCon then displayedStatParentedCon:disconnect() displayedStatParentedCon = nil end

   displayedStat = newStat

   if displayedStat then
    makeTenFootInterfaceStat()
    updateTenFootStat(displayedStat)
    displayedStatParentedCon = displayedStat.AncestryChanged:connect(function() updateTenFootStat(displayedStat, 'Parent') end)
    displayedStatChangedCon = displayedStat.Changed:connect(function(prop) updateTenFootStat(displayedStat, prop) end)
   end
  end

  function updateTenFootStat(statObj, property)
   if property and property == 'Parent' then
    tenFootInterfaceStat.StatName.Text = ''
    tenFootInterfaceStat.StatValue.Text = ''
    setDisplayedStat(nil)

    tenFootInterfaceChanged()
   else
    if topStatEnabled then
     tenFootInterfaceStat.StatName.Text = ' ' .. tostring(statObj.Name) .. ':'
     tenFootInterfaceStat.StatValue.Text = tostring(statObj.Value)
    else
     tenFootInterfaceStat.StatName.Text = ''
     tenFootInterfaceStat.StatValue.Text = ''
    end
   end
  end

  local function isValidStat(obj)
   return obj:IsA('StringValue') or obj:IsA('IntValue') or obj:IsA('BoolValue') or obj:IsA('NumberValue')or
    obj:IsA('DoubleConstrainedValue') or obj:IsA('IntConstrainedValue')
  end

  local function tenFootInterfaceNewStat( newStat )
   if not displayedStat and isValidStat(newStat) then
    setDisplayedStat(newStat)
   end
  end

  function tenFootInterfaceChanged()
   game:WaitForChild('Players')
   while not game.Players.LocalPlayer do
    wait()
   end

   local leaderstats = game.Players.LocalPlayer:FindFirstChild('leaderstats')
   if leaderstats then
    local statChildren = leaderstats:GetChildren()
    for i=  1, #statChildren do
     tenFootInterfaceNewStat(statChildren[i])
    end
    if leaderstatsChildAddedCon then leaderstatsChildAddedCon:disconnect() end
    leaderstatsChildAddedCon = leaderstats.ChildAdded:connect(function(newStat)
     tenFootInterfaceNewStat(newStat)
    end)
   end
  end

  game:WaitForChild('Players')
  while not game.Players.LocalPlayer do
   wait()
  end

  local leaderstats = game.Players.LocalPlayer:FindFirstChild('leaderstats')
  if leaderstats then
   tenFootInterfaceChanged()
  else
   game.Players.LocalPlayer.ChildAdded:connect(tenFootInterfaceChanged)
  end



  local topStatApiTable = {}

  function topStatApiTable:SetTopStatEnabled(value)
   topStatEnabled = value
   if displayedStat then
    updateTenFootStat(displayedStat, '')
   end
  end

  return topStatApiTable
 end

 return this
end




local moduleApiTable = {}

 local TenFootInterfaceModule = CreateModule()

 function moduleApiTable:IsEnabled()
  return tenFootInterfaceEnabled
 end

 function moduleApiTable:CreateHealthBar()
  return TenFootInterfaceModule:CreateHealthBar()
 end

 function moduleApiTable:SetupTopStat()
  return TenFootInterfaceModule:SetupTopStat()
 end

return moduleApiTable
-- chunk: =RbxUtility coverage=600/1180 consts=0
-- subst=0
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: else never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
local t = {}



































local string = string
local math = math
local table = table
local error = error
local tonumber = tonumber
local tostring = tostring
local type = type
local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs
local assert = assert
local Chipmunk = Chipmunk


local StringBuilder = {
 buffer = {}
}

function StringBuilder:New()
 local o = {}
 setmetatable(o, self)
 self.__index = self
 o.buffer = {}
 return o
end

function StringBuilder:Append(s)
 self.buffer[#self.buffer+1] = s
end

function StringBuilder:ToString()
 return table.concat(self.buffer)
end

local JsonWriter = {
 backslashes = {[
   '\b'] = '\\b',[
   '\t'] = '\\t',[
   '\n'] = '\\n',[
   '\f'] = '\\f',[
   '\r'] = '\\r',[
   '\"'] = '\\\"',[
   '\\'] = '\\\\',[
   '/'] =  '\\/'
 }
}

function JsonWriter:New()
 local o = {}
 o.writer = StringBuilder:New()
 setmetatable(o, self)
 self.__index = self
 return o
end

function JsonWriter:Append(s)
 self.writer:Append(s)
end

function JsonWriter:ToString()
 return self.writer:ToString()
end

function JsonWriter:Write(o)
 local t = type(o)
 if t == 'nil' then
  self:WriteNil()
 elseif t == 'boolean' then
  self:WriteString(o)
 elseif t == 'number' then
  self:WriteString(o)
 elseif t == 'string' then
  self:ParseString(o)
 elseif t == 'table' then
  self:WriteTable(o)
 elseif t == 'function' then
  self:WriteFunction(o)
 elseif t == 'thread' then
  self:WriteError(o)
 elseif t == 'userdata' then
  self:WriteError(o)
 end
end

function JsonWriter:WriteNil()
 self:Append('null')
end

function JsonWriter:WriteString(o)
 self:Append(tostring(o))
end

function JsonWriter:ParseString(s)
 self:Append('\"')
 self:Append(string.gsub(s, '[%z%c\\\"/]', function(n)
  local c = self.backslashes[n]
  if c then return c end
  return string.format('\\u%.4X', string.byte(n))
 end))
 self:Append('\"')
end

function JsonWriter:IsArray(t)
 local count = 0
 local isindex = function(k)
  if type(k) == 'number' and k > 0 then
   if math.floor(k) == k then
    return true
   end
  end
  return false
 end
 for k,v in pairs(t) do
  if not isindex(k) then
   return false, '\123','}'
  else
   count = math.max(count, k)
  end
 end
 return true, '[', ']', count
end

function JsonWriter:WriteTable(t)
 local ba, st, et, n = self:IsArray(t)
 self:Append(st)
 if ba then
  for i=  1, n do
   self:Write(t[i])
   if i < n then
    self:Append(',')
   end
  end
 else
  local first = true;
  for k, v in pairs(t) do
   if not first then
    self:Append(',')
   end
   first = false;
   self:ParseString(k)
   self:Append(':')
   self:Write(v)
  end
 end
 self:Append(et)
end

function JsonWriter:WriteError(o)
 error(string.format(
  'Encoding of %s unsupported',
  tostring(o)))
end

function JsonWriter:WriteFunction(o)
 if o == Null then
  self:WriteNil()
 else
  self:WriteError(o)
 end
end

local StringReader = {
 s = '',
 i = 0
}

function StringReader:New(s)
 local o = {}
 setmetatable(o, self)
 self.__index = self
 o.s = s or o.s
 return o
end

function StringReader:Peek()
 local i = self.i + 1
 if i <= #self.s then
  return string.sub(self.s, i, i)
 end
 return nil
end

function StringReader:Next()
 self.i = self.i+1
 if self.i <= #self.s then
  return string.sub(self.s, self.i, self.i)
 end
 return nil
end

function StringReader:All()
 return self.s
end

local JsonReader = {
 escapes = {[
   't'] = '\t',[
   'n'] = '\n',[
   'f'] = '\f',[
   'r'] = '\r',[
   'b'] = '\b'
 }
}

function JsonReader:New(s)
 local o = {}
 o.reader = StringReader:New(s)
 setmetatable(o, self)
 self.__index = self
 return o;
end

function JsonReader:Read()
 self:SkipWhiteSpace()
 local peek = self:Peek()
 if peek == nil then
  error(string.format(
   "Nil string: \'%s\'",
   self:All()))
 elseif peek == '\123'then
  return self:ReadObject()
 elseif peek == '[' then
  return self:ReadArray()
 elseif peek == '\"'then
  return self:ReadString()
 elseif string.find(peek, '[%+%-%d]') then
  return self:ReadNumber()
 elseif peek == 't' then
  return self:ReadTrue()
 elseif peek == 'f' then
  return self:ReadFalse()
 elseif peek == 'n' then
  return self:ReadNull()
 elseif peek == '/' then
  self:ReadComment()
  return self:Read()
 else
  return nil
 end
end

function JsonReader:ReadTrue()
 self:TestReservedWord({'t','r','u','e'})
 return true
end

function JsonReader:ReadFalse()
 self:TestReservedWord({'f','a','l','s','e'})
 return false
end

function JsonReader:ReadNull()
 self:TestReservedWord({'n','u','l','l'})
 return nil
end

function JsonReader:TestReservedWord(t)
 for i, v in ipairs(t) do
  if self:Next() ~= v then
    error(string.format(
    "Error reading \'%s\': %s",
    table.concat(t),
    self:All()))
  end
 end
end

function JsonReader:ReadNumber()
        local result = self:Next()
        local peek = self:Peek()
        while peek ~= nil and string.find(
  peek,
  '[%+%-%d%.eE]') do
            result = result .. self:Next()
            peek = self:Peek()
 end
 result = tonumber(result)
 if result == nil then
         error(string.format(
   "Invalid number: \'%s\'",
   result))
 else
  return result
 end
end

function JsonReader:ReadString()
 local result = ''
 assert(self:Next() == '\"')
        while self:Peek() ~= '\"'do
  local ch = self:Next()
  if ch == '\\' then
   ch = self:Next()
   if self.escapes[ch] then
    ch = self.escapes[ch]
   end
  end
                result = result .. ch
 end
        assert(self:Next() == '\"')
 local fromunicode = function(m)
  return string.char(tonumber(m, 16))
 end
 return string.gsub(
  result,
  'u%x%x(%x%x)',
  fromunicode)
end

function JsonReader:ReadComment()
        assert(self:Next() == '/')
        local second = self:Next()
        if second == '/' then
            self:ReadSingleLineComment()
        elseif second == '*' then
            self:ReadBlockComment()
        else
            error(string.format(
  'Invalid comment: %s',
  self:All()))
 end
end

function JsonReader:ReadBlockComment()
 local done = false
 while not done do
  local ch = self:Next()
  if ch == '*' and self:Peek() == '/' then
   done = true
                end
  if not doneand
   ch == '/'and
   self:Peek() == '*' then
                    error(string.format(
   "Invalid comment: %s, \'/*\' illegal.",
   self:All()))
  end
 end
 self:Next()
end

function JsonReader:ReadSingleLineComment()
 local ch = self:Next()
 while ch ~= '\r' and ch ~= '\n' do
  ch = self:Next()
 end
end

function JsonReader:ReadArray()
 local result = {}
 assert(self:Next() == '[')
 local done = false
 if self:Peek() == ']' then
  done = true;
 end
 while not done do
  local item = self:Read()
  result[#result+1] = item
  self:SkipWhiteSpace()
  if self:Peek() == ']' then
   done = true
  end
  if not done then
   local ch = self:Next()
   if ch ~= ',' then
    error(string.format(
     "Invalid array: \'%s\' due to: \'%s\'",
     self:All(), ch))
   end
  end
 end
 assert(']' == self:Next())
 return result
end

function JsonReader:ReadObject()
 local result = {}
 assert(self:Next() == '\123')
 local done = false
 if self:Peek() == '}' then
  done = true
 end
 while not done do
  local key = self:Read()
  if type(key) ~= 'string' then
   error(string.format(
    'Invalid non-string object key: %s',
    key))
  end
  self:SkipWhiteSpace()
  local ch = self:Next()
  if ch ~= ':' then
   error(string.format(
    "Invalid object: \'%s\' due to: \'%s\'",
    self:All(),
    ch))
  end
  self:SkipWhiteSpace()
  local val = self:Read()
  result[key] = val
  self:SkipWhiteSpace()
  if self:Peek() == '}' then
   done = true
  end
  if not done then
   ch = self:Next()
                 if ch ~= ',' then
    error(string.format(
     "Invalid array: \'%s\' near: \'%s\'",
     self:All(),
     ch))
   end
  end
 end
 assert(self:Next() == '}')
 return result
end

function JsonReader:SkipWhiteSpace()
 local p = self:Peek()
 while p ~= nil and string.find(p, '[%s/]') do
  if p == '/' then
   self:ReadComment()
  else
   self:Next()
  end
  p = self:Peek()
 end
end

function JsonReader:Peek()
 return self.reader:Peek()
end

function JsonReader:Next()
 return self.reader:Next()
end

function JsonReader:All()
 return self.reader:All()
end

function Encode(o)
 local writer = JsonWriter:New()
 writer:Write(o)
 return writer:ToString()
end

function Decode(s)
 local reader = JsonReader:New(s)
 return reader:Read()
end

function Null()
 return Null
end


t.DecodeJSON = function(jsonString)
 pcall(function() warn("RbxUtility.DecodeJSON is deprecated, please use Game:GetService(\'HttpService\'):JSONDecode() instead.")end)

 if type(jsonString) == 'string' then
  return Decode(jsonString)
 end
 print('RbxUtil.DecodeJSON expects string argument!')
 return nil
end

t.EncodeJSON = function(jsonTable)
 pcall(function() warn("RbxUtility.EncodeJSON is deprecated, please use Game:GetService(\'HttpService\'):JSONEncode() instead.")end)
 return Encode(jsonTable)
end


















t.MakeWedge = function(x, y, z, defaultmaterial)
 return game:GetService('Terrain'):AutoWedgeCell(x,y,z)
end

t.SelectTerrainRegion = function(regionToSelect, color, selectEmptyCells, selectionParent)
 local terrain = game:GetService('Workspace'):FindFirstChild('Terrain')
 if not terrain then return end

 assert(regionToSelect)
 assert(color)

 if not type(regionToSelect) == 'Region3' then
  error('regionToSelect (first arg), should be of type Region3, but is type',type(regionToSelect))
 end
 if not type(color) == 'BrickColor' then
  error('color (second arg), should be of type BrickColor, but is type',type(color))
 end


 local GetCell = terrain.GetCell
 local WorldToCellPreferSolid = terrain.WorldToCellPreferSolid
 local CellCenterToWorld = terrain.CellCenterToWorld
 local emptyMaterial = Enum.CellMaterial.Empty


 local selectionContainer = Instance.new('Model')
 selectionContainer.Name = 'SelectionContainer'
 selectionContainer.Archivable = false
 if selectionParent then
  selectionContainer.Parent = selectionParent
 else
  selectionContainer.Parent = game:GetService('Workspace')
 end

 local updateSelection = nil
 local currentKeepAliveTag = nil
 local aliveCounter = 0
 local lastRegion = nil
 local adornments = {}
 local reusableAdorns = {}

 local selectionPart = Instance.new('Part')
 selectionPart.Name = 'SelectionPart'
 selectionPart.Transparency = 1
 selectionPart.Anchored = true
 selectionPart.Locked = true
 selectionPart.CanCollide = false
 selectionPart.FormFactor = Enum.FormFactor.Custom
 selectionPart.Size = Vector3.new(4.2000000000000002,4.2000000000000002,4.2000000000000002)

 local selectionBox = Instance.new('SelectionBox')


 function Region3ToRegion3int16(region3)
  local theLowVec = region3.CFrame.p - (region3.Size/2) + Vector3.new(2,2,2)
  local lowCell = WorldToCellPreferSolid(terrain,theLowVec)

  local theHighVec = region3.CFrame.p + (region3.Size/2) - Vector3.new(2,2,2)
  local highCell = WorldToCellPreferSolid(terrain, theHighVec)

  local highIntVec = Vector3int16.new(highCell.x,highCell.y,highCell.z)
  local lowIntVec = Vector3int16.new(lowCell.x,lowCell.y,lowCell.z)

  return Region3int16.new(lowIntVec,highIntVec)
 end


 function createAdornment(theColor)
  local selectionPartClone = nil
  local selectionBoxClone = nil

  if #reusableAdorns > 0 then
   selectionPartClone = reusableAdorns[1]['part']
   selectionBoxClone = reusableAdorns[1]['box']
   table.remove(reusableAdorns,1)

   selectionBoxClone.Visible = true
  else
   selectionPartClone = selectionPart:Clone()
   selectionPartClone.Archivable = false

   selectionBoxClone = selectionBox:Clone()
   selectionBoxClone.Archivable = false

   selectionBoxClone.Adornee = selectionPartClone
   selectionBoxClone.Parent = selectionContainer

   selectionBoxClone.Adornee = selectionPartClone

   selectionBoxClone.Parent = selectionContainer
  end

  if theColor then
   selectionBoxClone.Color = theColor
  end

  return selectionPartClone, selectionBoxClone
 end


 function cleanUpAdornments()
  for cellPos, adornTable in pairs(adornments) do

   if adornTable.KeepAlive ~= currentKeepAliveTag then
    adornTable.SelectionBox.Visible = false
    table.insert(reusableAdorns,{part = adornTable.SelectionPart, box = adornTable.SelectionBox})
    adornments[cellPos] = nil
   end
  end
 end


 function incrementAliveCounter()
  aliveCounter = aliveCounter + 1
  if aliveCounter > 1000000 then
   aliveCounter = 0
  end
  return aliveCounter
 end


 function adornFullCellsInRegion(region, color)
  local regionBegin = region.CFrame.p - (region.Size/2) + Vector3.new(2,2,2)
  local regionEnd = region.CFrame.p + (region.Size/2) - Vector3.new(2,2,2)

  local cellPosBegin = WorldToCellPreferSolid(terrain, regionBegin)
  local cellPosEnd = WorldToCellPreferSolid(terrain, regionEnd)

  currentKeepAliveTag = incrementAliveCounter()
  for y=  cellPosBegin.y, cellPosEnd.y do
   for z=  cellPosBegin.z, cellPosEnd.z do
    for x=  cellPosBegin.x, cellPosEnd.x do
     local cellMaterial = GetCell(terrain, x, y, z)

     if cellMaterial ~= emptyMaterial then
      local cframePos = CellCenterToWorld(terrain, x, y, z)
      local cellPos = Vector3int16.new(x,y,z)

      local updated = false
      for cellPosAdorn, adornTable in pairs(adornments) do
       if cellPosAdorn == cellPos then
        adornTable.KeepAlive = currentKeepAliveTag
        if color then
         adornTable.SelectionBox.Color = color
        end
        updated = true
        break
       end
      end

      if not updated then
       local selectionPart, selectionBox = createAdornment(color)
       selectionPart.Size = Vector3.new(4,4,4)
       selectionPart.CFrame = CFrame.new(cframePos)
       local adornTable = {SelectionPart = selectionPart, SelectionBox = selectionBox, KeepAlive = currentKeepAliveTag}
       adornments[cellPos] = adornTable
      end
     end
    end
   end
  end
  cleanUpAdornments()
 end



 lastRegion = regionToSelect

 if selectEmptyCells then
  local selectionPart, selectionBox = createAdornment(color)

  selectionPart.Size = regionToSelect.Size
  selectionPart.CFrame = regionToSelect.CFrame

  adornments.SelectionPart = selectionPart
  adornments.SelectionBox = selectionBox

  updateSelection =
   function (newRegion, color)
    if newRegion and newRegion ~= lastRegion then
     lastRegion = newRegion
      selectionPart.Size = newRegion.Size
     selectionPart.CFrame = newRegion.CFrame
    end
    if color then
     selectionBox.Color = color
    end
   end
 else
  adornFullCellsInRegion(regionToSelect, color)
  updateSelection =
   function (newRegion, color)
    if newRegion and newRegion ~= lastRegion then
     lastRegion = newRegion
     adornFullCellsInRegion(newRegion, color)
    end
   end

 end

 local destroyFunc = function()
  updateSelection = nil
  if selectionContainer then selectionContainer:Destroy() end
  adornments = nil
 end

 return updateSelection, destroyFunc
end












































function t.CreateSignal()
 local this = {}

 local mBindableEvent = Instance.new('BindableEvent')
 local mAllCns = {}


 function this:connect(func)
  if self ~= this then error('connect must be called with \096:\096, not \096.\096',2)end
  if type(func) ~= 'function' then
   error('Argument #1 of connect must be a function, got a '..type(func), 2)
  end
  local cn = mBindableEvent.Event:connect(func)
  mAllCns[cn] = true
  local pubCn = {}
  function pubCn:disconnect()
   cn:disconnect()
   mAllCns[cn] = nil
  end
  return pubCn
 end
 function this:disconnect()
  if self ~= this then error('disconnect must be called with \096:\096, not \096.\096',2)end
  for cn, _ in pairs(mAllCns) do
   cn:disconnect()
   mAllCns[cn] = nil
  end
 end
 function this:wait()
  if self ~= this then error('wait must be called with \096:\096, not \096.\096',2)end
  return mBindableEvent.Event:wait()
 end
 function this:fire(...)
  if self ~= this then error('fire must be called with \096:\096, not \096.\096',2)end
  mBindableEvent:Fire(...)
 end

 return this
end



































































































local function Create_PrivImpl(objectType)
 if type(objectType) ~= 'string' then
  error('Argument of Create must be a string', 2)
 end




 return function(dat)

  dat = dat or {}


  local obj = Instance.new(objectType)


  local ctor = nil

  for k, v in pairs(dat) do

   if type(k) == 'string' then
    obj[k] = v



   elseif type(k) == 'number' then
    if type(v) ~= 'userdata' then
     error('Bad entry in Create body: Numeric keys must be paired with children, got a: '..type(v), 2)
    end
    v.Parent = obj



   elseif type(k) == 'table' and k.__eventname then
    if type(v) ~= 'function' then
     error("Bad entry in Create body: Key \096[Create.E\'"..k.__eventname.."\']\096 must have a function value\n\t\t\t\t\t       got: "..
                    tostring(v), 2)
    end
    obj[k.__eventname]:connect(v)



   elseif k == t.Create then
    if type(v) ~= 'function' then
     error('Bad entry in Create body: Key \096[Create]\096 should be paired with a constructor function, \n\t\t\t\t\t       got: '..
                    tostring(v), 2)
    elseif ctor then

     error('Bad entry in Create body: Only one constructor function is allowed', 2)
    end
    ctor = v


   else
    error('Bad entry ('..tostring(k)..' => '..tostring(v)..') in Create body', 2)
   end
  end


  if ctor then
   ctor(obj)
  end


  return obj
 end
end


t.Create = setmetatable({}, {__call = function(tb, ...) return Create_PrivImpl(...) end})



t.Create.E = function(eventName)
 return {__eventname = eventName}
end














t.Help =
 function(funcNameOrFunc)

  if funcNameOrFunc == 'DecodeJSON' or funcNameOrFunc == t.DecodeJSON then
   return 'Function DecodeJSON.  '..
          'Arguments: (string).  '..
          'Side effect: returns a table with all parsed JSON values'
  end
  if funcNameOrFunc == 'EncodeJSON' or funcNameOrFunc == t.EncodeJSON then
   return 'Function EncodeJSON.  '..
          'Arguments: (table).  '..
          'Side effect: returns a string composed of argument table in JSON data format'
  end
  if funcNameOrFunc == 'MakeWedge' or funcNameOrFunc == t.MakeWedge then
   return 'Function MakeWedge. '..
          'Arguments: (x, y, z, [default material]). '..
          'Description: Makes a wedge at location x, y, z. Sets cell x, y, z to default material if '..
          'parameter is provided, if not sets cell x, y, z to be whatever material it previously was. '..
          'Returns true if made a wedge, false if the cell remains a block '
  end
  if funcNameOrFunc == 'SelectTerrainRegion' or funcNameOrFunc == t.SelectTerrainRegion then
   return 'Function SelectTerrainRegion. '..
          'Arguments: (regionToSelect, color, selectEmptyCells, selectionParent). '..
          'Description: Selects all terrain via a series of selection boxes within the regionToSelect '..
          '(this should be a region3 value). The selection box color is detemined by the color argument '..
          '(should be a brickcolor value). SelectionParent is the parent that the selection model gets placed to (optional).'..
          'SelectEmptyCells is bool, when true will select all cells in the '..
          'region, otherwise we only select non-empty cells. Returns a function that can update the selection,'..
          'arguments to said function are a new region3 to select, and the adornment color (color arg is optional). '..
          'Also returns a second function that takes no arguments and destroys the selection'
  end
  if funcNameOrFunc == 'CreateSignal' or funcNameOrFunc == t.CreateSignal then
   return 'Function CreateSignal. '..
          'Arguments: None. '..
          'Returns: The newly created Signal object. This object is identical to the RBXScriptSignal class '..
          'used for events in Objects, but is a Lua-side object so it can be used to create custom events in'..
          'Lua code. '..
          'Methods of the Signal object: :connect, :wait, :fire, :disconnect. '..
          'For more info you can pass the method name to the Help function, or view the wiki page '..
          "for this library. EG: Help(\'Signal:connect\')."
  end
  if funcNameOrFunc == 'Signal:connect' then
   return 'Method Signal:connect. '..
          'Arguments: (function handler). '..
          'Return: A connection object which can be used to disconnect the connection to this handler. '..
          'Description: Connectes a handler function to this Signal, so that when |fire| is called the '..
          'handler function will be called with the arguments passed to |fire|.'
  end
  if funcNameOrFunc == 'Signal:wait' then
   return 'Method Signal:wait. '..
          'Arguments: None. '..
          'Returns: The arguments passed to the next call to |fire|. '..
          'Description: This call does not return until the next call to |fire| is made, at which point it '..
          'will return the values which were passed as arguments to that |fire| call.'
  end
  if funcNameOrFunc == 'Signal:fire' then
   return 'Method Signal:fire. '..
          'Arguments: Any number of arguments of any type. '..
          'Returns: None. '..
          'Description: This call will invoke any connected handler functions, and notify any waiting code '..
          'attached to this Signal to continue, with the arguments passed to this function. Note: The calls '..
          'to handlers are made asynchronously, so this call will return immediately regardless of how long '..
          'it takes the connected handler functions to complete.'
  end
  if funcNameOrFunc == 'Signal:disconnect' then
   return 'Method Signal:disconnect. '..
          'Arguments: None. '..
          'Returns: None. '..
          'Description: This call disconnects all handlers attacched to this function, note however, it '..
          'does NOT make waiting code continue, as is the behavior of normal Roblox events. This method '..
          'can also be called on the connection object which is returned from Signal:connect to only '..
          'disconnect a single handler, as opposed to this method, which will disconnect all handlers.'
  end
  if funcNameOrFunc == 'Create' then
   return 'Function Create. '..
          'Arguments: A table containing information about how to construct a collection of objects. '..
          'Returns: The constructed objects. '..
          'Descrition: Create is a very powerfull function, whose description is too long to fit here, and '..
          'is best described via example, please see the wiki page for a description of how to use it.'
  end
 end



return t



























-- chunk: =Script Context.ServerStarterScript coverage=192/1328 consts=11409
-- subst=0
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed







local runService = nil
while runService == nil or not runService:IsRunning() do
 wait(0.10000000000000001)
 runService = game:GetService('RunService')
end


local RobloxReplicatedStorage = game:GetService('RobloxReplicatedStorage')
local ScriptContext = game:GetService('ScriptContext')


local serverFollowersSuccess, serverFollowersEnabled = pcall(function() return settings():GetFFlag('UserServerFollowers') end)
local IsServerFollowers = serverFollowersSuccess and serverFollowersEnabled

local RemoteEvent_NewFollower = nil



if IsServerFollowers then
 ScriptContext:AddCoreScriptLocal('ServerCoreScripts/ServerSocialScript', script.Parent)
else

 RemoteEvent_NewFollower = Instance.new('RemoteEvent')
 RemoteEvent_NewFollower.Name = 'NewFollower'
 RemoteEvent_NewFollower.Parent = RobloxReplicatedStorage
end


local RemoteEvent_SetDialogInUse = Instance.new('RemoteEvent')
RemoteEvent_SetDialogInUse.Name = 'SetDialogInUse'
RemoteEvent_SetDialogInUse.Parent = RobloxReplicatedStorage





local function onNewFollower(followerRbxPlayer, followedRbxPlayer)
 RemoteEvent_NewFollower:FireClient(followedRbxPlayer, followerRbxPlayer)
end
if RemoteEvent_NewFollower then
 RemoteEvent_NewFollower.OnServerEvent:connect(onNewFollower)
end

local function setDialogInUse(player, dialog, value)
 if dialog ~= nil then
  dialog.InUse = value
 end
end
RemoteEvent_SetDialogInUse.OnServerEvent:connect(setDialogInUse)

-- chunk: =Script Context.StarterScript coverage=948/2100 consts=325
-- subst=0
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed




local scriptContext = game:GetService('ScriptContext')
local touchEnabled = game:GetService('UserInputService').TouchEnabled

local RobloxGui = game:GetService('CoreGui'):WaitForChild('RobloxGui')

local soundFolder = Instance.new('Folder')
soundFolder.Name = 'Sounds'
soundFolder.Parent = RobloxGui


local topbarSuccess, topbarFlagValue = pcall(function() return settings():GetFFlag('UseInGameTopBar') end)
local useTopBar = (topbarSuccess and topbarFlagValue == true)
if useTopBar then
 scriptContext:AddCoreScriptLocal('CoreScripts/Topbar', RobloxGui)
end


local luaControlsSuccess, luaControlsFlagValue = pcall(function() return settings():GetFFlag('UseLuaCameraAndControl') end)


scriptContext:AddCoreScriptLocal('CoreScripts/MainBotChatScript2', RobloxGui)


scriptContext:AddCoreScriptLocal('CoreScripts/DeveloperConsole', RobloxGui)


scriptContext:AddCoreScriptLocal('CoreScripts/NotificationScript2', RobloxGui)


if useTopBar then
 spawn(function() require(RobloxGui.Modules.Chat) end)
 spawn(function() require(RobloxGui.Modules.PlayerlistModule) end)
end

local luaBubbleChatSuccess, luaBubbleChatFlagValue = pcall(function() return settings():GetFFlag('LuaBasedBubbleChat') end)
if luaBubbleChatSuccess and luaBubbleChatFlagValue then
 scriptContext:AddCoreScriptLocal('CoreScripts/BubbleChat', RobloxGui)
end


scriptContext:AddCoreScriptLocal('CoreScripts/PurchasePromptScript2', RobloxGui)


if not useTopBar then
 scriptContext:AddCoreScriptLocal('CoreScripts/HealthScript', RobloxGui)
end


 spawn(function() require(RobloxGui.Modules.BackpackScript) end)
   end

if useTopBar then
 scriptContext:AddCoreScriptLocal('CoreScripts/VehicleHud', RobloxGui)
end

scriptContext:AddCoreScriptLocal('CoreScripts/GamepadMenu', RobloxGui)

if touchEnabled then

 scriptContext:AddCoreScriptLocal('CoreScripts/ContextActionTouch', RobloxGui)

 RobloxGui:WaitForChild('ControlFrame')
 RobloxGui.ControlFrame:WaitForChild('BottomLeftControl')
 RobloxGui.ControlFrame.BottomLeftControl.Visible = false
end

-- chunk: =obfuscated_1 coverage=9820/14420 consts=192244
-- subst=0
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
-- note: then never executed
-- note: loop-body never executed
-- note: then never executed
-- note: then never executed
-- note: else never executed
                                                return(function(...)local j={"^C7ea8esen]=T\'@97;","^j\'p!L*O",'^7\096hP*bU%Fh7HqNH$:K','^etK0Liapbr*nL>','^Ctq1U','^G\\8k8X3\\[*dIC+&X3_','^M^SFo','^C/u]\"2g','^oRW1n6\"03','^ff<\"]WsFD!3hA-H\\=AX9gM','^2ed1mGk%','^=3jOhjK','^C<\0969(etnjPb$:,t=<','^','^is/\\FCtu','^3nn','^mj,/7=Pua:jK','^_]Em^','^iLZW)o\\_<&pWArN',"^=\\cKdj\'@C?C1=T+",'^_]E@&p_','^jSe@E<pG','^!eneGRRC','^CrALBdH->2d,Q','^bg=B!b.,5OKNS9.er8','^mPsP/t..;Q','^pI4+mGuO,','^3nu','^BL1WOK()/sCkWWf*O',"^_]Euq=3iblC@I\'",'^C]o52','^p66\"l','^dnMJ1C%=b,X=ZsMBmC)','^Rqk3','^<h>Qb3n9RjGC_#?bJ','^<$\096phpA2\0964C9\\-e','^<Uoa0KlZQQKN>12s:3','^*>XX43q','^_]E/njeqV','^=SPm1pH?','^XnsW#pI%O',"^X>LO#j\'jrqj\'@cr=3[V>",'^=3i$>','^bg\"I=i)jLDBp4)81\096,','^363OY*?L4fjs_?8p_','^oO','^X*\\:h$OKcUdMF','^CkK$hCX7','^i$\096oP','^/9QSdb2C','^=p)?Dp6e58','^jZP3\\*O','^G\\2IneOoXeiapbr','^*+JMkpI(',"^=p)si*n\'*\\",'^=JP\0962CtV','^$uhRujK','^jU0PndAYL/j9D>.bJ','^i.s]!','^*nLS>mT3'}for v,I in ipairs({{1698899956%9183243,227807615%3861145},{637298+-637297,76803-76749},{-575034-(-575089),461169840%15372326}})do while I[1039849-1039848]<I[262411736%6728506]do j[I[458630949%4985119]],j[I[398149802%16589575]],I[-949947-(-949948)],I[62171558%10361926] =j[I[868790-868788]],j[I[1964312465%14443474]],I[737553-737552]+(478490-478489),I[1638316682%13652639]-216512137%9021339 end end local function v(v)return j[v+(241302+-234580)]end local v=math.floor local I=j local C=table.insert local b=type local O=string.char local i=string.len local K={N=-80788-(-80791),['.']=2569826107%10575416,[',']=960193240%4874077,a=330614219%2623922,Q=-699576+699588,c=-414718+414760,Z=1437501605%6624431,j=148001798%2242451,[')']=970807-970732,O=-316295+316349,['0']=-22030+22097,['+']=-290252+290316,['5']=179478-179472,['-']=416013-415968,o=107156-107138,['3']=259860+-259826,E=258516+-258476,l=-728836-(-728837),R=-135083+135141,X=844587-844560,['$']=472044699%1983381,S=320542-320533,A=-333642-(-333685),[']']=1865427375%8040635,['\"']=-1047435-(-1047481),H=882171+-882130,[';']=1230616689%14650198,G=638680-638652,p=462346-462311,Y=27710249%1731886,K=950760+-950721,['\\']=1532999382%12263995,F=-617736+617736,['=']=711647905%3785361,_=1137400950%9478341,['4']=-1004475-(-1004551),r=129269-129192,['2']=743508+-743497,t=719027+-718947,W=142517+-142451,['&']=659509-659450,P=-521452-(-521460),q=969968+-969908,C=515541+-515510,e=-189814+189836,L=28458+-28443,['[']=164261924%1244408,['(']=537573158%2357777,[':']=-861316-(-861399),V=242870-242786,f=-141808-(-141869),['6']=-216199-(-216212),['!']=-588855-(-588925),I=1574064757%13929776,['@']=990360-990307,T=-260845+260849,['1']=2091342817%11815496,['9']=248719550%12435975,h=1120439536%16238253,n=-765767-(-765832),J=440713+-440650,['?']=-342679+342684,['<']=221473-221450,s=-942760-(-942780),g=42381-42333,m=-401766-(-401804),M=636444342%3857238,B=2116732689%16536974,['8']=887568-887486,['^']=240807-240755,['#']=-531000+531062,d=10435-10419,["\'"]=773921563%14883106,k=670182381%8935764,['\096']=688735290%7486253,i=171270+-171237,u=1570660601%14150095,['%']=1203445152%5928301,U=895158+-895084,['7']=-686508-(-686534),['*']=-174290-(-174326),['>']=-522838-(-522848),b=110859084%1421270,D=369981205%1728884,['/']=300191-300147}local r={['3']=1217620941%10496732,H=63484890%1923783,['7']=-948964+948970,O=897762+-897701,s=-409501+409546,V=249166+-249127,w=3249640025%13050763,['/']=1969468676%13397746,S=-1016659+1016660,f=835841634%10319032,k=-684555+684604,['1']=533998+-533961,N=234715418%998789,a=105030+-105009,m=1046153-1046122,d=880723-880664,M=302786+-302746,u=182952+-182917,G=-981532-(-981582),Y=171180-171139,K=-586598+586630,p=2010573628%12111889,A=-155875-(-155902),b=1026552-1026518,Q=-558983+559009,e=1728571456%8642857,o=716830-716773,l=660991323%4348627,t=30290023%6057996,i=-773898-(-773953),C=1043510799%10331790,F=227228-227176,['+']=-1048046-(-1048108),z=304417+-304413,E=-992904-(-992921),q=-456288-(-456304),r=937376+-937365,['9']=-324307-(-324320),['6']=-194750-(-194780),g=80052278%3078933,X=46910-46888,['2']=836422+-836422,v=599891437%5503591,j=817318-817258,['4']=-238761-(-238814),['5']=171026-171014,D=3269743878%16767917,W=387717201%5239421,T=-51247-(-51262),B=-1004797+1004802,R=-635228-(-635236),L=1334368140%10186016,['0']=904923+-904921,J=139339201%1678785,h=977330-977306,P=1674304590%7375791,n=875829337%13684833,y=1084040860%9109587,c=725656-725633,I=941113016%8113043,x=328011-327963,['8']=204654891%5531213,Z=296356980%12348206,U=582549-582491}local n=string.sub local Y=table.concat for j=651526-651525,#I,3407163255%14079187 do local U=I[j]if b(U)=='string'then local b=n(U,380899-380898,-714906+714907)if b=='?'then U =n(U,236486-236484)local b=i(U)local K={}local W=478476751%1913907 local p=734132-734132 local k=1307073348%5186799 while W<=b do local j=n(U,W,W)local I=r[j]if I then p =p+I*((-47949+48013)^((557492804%15067373-k)))k =k+(470934+-470933)if k==-916854+916858 then k =369128+-369128 local j=v(p/(-152395+217931))local I=v((p%(438310+-372774))/(-864170-(-864426)))local b=p%(556372+-556116)C(K,O(j,I,b))p =26110668%2175889 end elseif j=='='then C(K,O(v(p/(-760663-(-826199)))))if W>=bor n(U,W+(282114+-282113),W+(-274973+274974))~='='then C(K,O(v((p%(311491-245955))/(502393+-502137))))end break end W =W+(123989+-123988)end I[j] =Y(K)elseif b=='^'then U =n(U,-459653+459655)local b=i(U)local r={}local W=1945966065%8176328 while W<=b do local j=(b-W)+3697433432%16288253 local I=j>=-105722+105727and-408283-(-408288)or j local i=118934805%2162451 local Y=I>705881+-705880 for j=-469592-(-469592),305407402%4127127,1692490081%9955824 do local v if j<I then local I=n(U,W+j,W+j)v =K[I]if not v then Y =false break end else v =340465-340381 end i =i*(507151499%6586382)+v end if Y then local j=v(i/(-673480+17450696))%(141968+-141712)local b=v(i/(9896714%4915589))%(570678+-570422)local K=v(i/(1105206528%8247808))%(54061969%524871)local n=i%(-586840-(-587096))if I==997967+-997962 then C(r,O(j,b,K,n))elseif I==-991339-(-991343)then C(r,O(j,b,K))elseif I==1042007-1042004 then C(r,O(j,b))elseif I==399870-399868 then C(r,O(j))end end W =W+I end I[j] =Y(r)end end end end return(function(r,O,i,K,C,b,j,Y,k,S,W,L,d,M,D,y,I,o,n,p,U)L,n,y,S,W,I,Y,o,U,M,D,k,p,d =function(j,v)local C=p(v)local b=function(...)return I(j,{...},v,C)end return b end,{},function(j,v)local C=p(v)local b=function(b,O,i,K,r)return I(j,{b,O,i,K,r},v,C)end return b end,function(j,v)local C=p(v)local b=function(b,O)return I(j,{b,O},v,C)end return b end,-993027-(-993027),function(I,b,O,i)local r,l,H,m,w,p,N,X,R,Y,L,k,z,e,A,T,V,Z,f,x,a,c,Q,h,q,F,B,J,u,s,P,t,W,E,g,G while I do if 3188581738%18373834>I then if I>4356397921%17837657 then if 7588099-648294>I then if I>6142853-914218 then if I<614683944%12686471 then if I<6258146-758109 then I,u =884368822%13754214,t w =u m[u] =w u =nil elseif I<5388654-(-198101)then e =n[W]f,q =I,e I =eand 3255391-71898or 5699588427%27322469 else W,r,p =v(631264+-637959),4811287-813612,3029916168%14100587 Y =W^p I =r-Y r,Y =v(-190643-(-183939)),I I =r/Y r ={I}I =j[v(368037-374702)]end else if 6161400-29766>I then Y,p =v(97730+-104396),-584126-(-584126)I =j[Y]W =n[O[-753775+753783]]Y =I(W,p)I =10585855-(-111972)elseif 2237060815%12892457>I then n[W] =a I =h h =n[W]I =hand 765580+14606929or 15779760-(-42015)else P =U()t =U()G,u,R =v(1011543-1018232),{},v(920824+-927532)s =d(331965-241225,{t,J,L,X})n[t] =u m,w =nil,{}u =U()n[u] =s T,B,s =nil,v(852558+-859256),{}n[P] =s s =j[R]g =n[P]x ={[G]=g,[B]=T}R =s(w,x)W =R X =o(X)I =2213735942%13038230 s =D(-387266+1251431,{P,t,H,J,L,u})H =o(H)k,H,Q =nil,v(589277+-595995),nil t =o(t)u =o(u)p =s J =o(J)P =o(P)X =v(553973+-560642)L =o(L)L =j[X]V =nil V =684530+22126427928141 J =p(H,V)X =W[J]H =v(250096-256816)k =L[X]L,V =v(-759164-(-752489)),12834712500851-(-122085)L =k[L]J =p(H,V)X =W[J]L =L(k,X)k =v(284294-290958)k =L[k]k =k(L)end end else if I>352708+4238255 then if 4257506312%18570409>I then e =I z =n[W]f,I =z,zand-1008395+12736934or-1020963+3053408 elseif 2628439164%14335966>I then p =67632-67431 W =n[O[405224090%3787141]]Y =W*p W =813047+-812790 r =Y%W n[O[-193067-(-193070)]] =r p =259178-259177 W =n[O[-1045249-(-1045252)]]Y =W~=p I =Yand-506767+2430573or 671851+4255249 else I,r =j[v(125559-132226)],{}end else if 194706665%19060682>I then t,w =t+P,not R u =s>=t u =wand u w =t>=s w =Rand w u =wor u w =478954+4990644 I =uand w u =2188073607%12874775 I =Ior u elseif I<949837+3272307 then I =1031879285%4230381 else r,I ={},j[v(-177857+171174)]end end end else if I<641232+7361282 then if I<7686296-153736 then if I<-1039181+8117731 then I =11089745-(-389537)elseif I<1115980821%18174527 then I,R =1032998196%13395701,v(879101-885813)h =j[R]R =v(980623-987323)j[R] =h else V =4216014-(-418435)>2408665078%25256100 H =n[W]r =H==V I =rand 2736022754%14161540or 6770001-(-217731)end else if I<7930917-308750 then r =v(-992869-(-986192))I =j[r]Y =n[O[2359963979%13038475]]H =v(-530220-(-523530))V =S(48922+5594113,{})k =v(984136-990809)p =j[k]J =j[H]H ={J(V)}X,J ={C(H)},-1002189-(-1002191)L =X[J]k =p(L)p =v(978543+-985262)W =Y(k,p)Y ={W()}r =I(C(Y))W =n[O[-614435+614440]]I,Y =Wand 11775744-99073or 430086+10876692,r r =W elseif 7517879-(-276807)>I then I ={}n[O[2130273742%15216241]] =I H =v(154283-160997)r =n[O[767506+-767503]]L,J,I,k =-71189+35184372160021,-1046780+1047035,9668961-(-333552),r r =W%L n[O[215115+-215111]] =r V =3953341%329445 X =W%J J =-256602+256604 L =X+J n[O[440177701%15720632]] =L X =#Y J =v(-818827-(-812113))m =1228537741%6081870 p[W] =J J,Q,u =-896946-(-897150),X,m m =483472374%1910958 t =m>u m =V-u else W =n[O[310634-310632]]p =n[O[768398-768395]]Y =W==p r,I =Y,1564718696%14264014 end end else if 8347428-(-625073)>I then if 7785641-(-545728)>I then H =v(714272-720973)r =n[W]I =r~=H I =Iand-627791+16570381or 436630+3184312 elseif I<8764055-104920 then c =n[W]h =I I,a =cand 11160205-(-345372)or 6415017-(-24614),c else Y,r =v(490998-497684),v(546952+-553618)I =j[r]r =I(Y)I,r =j[v(-253189+246480)],{}end else if I<-727388+10227743 then Y,r =v(-373283-(-366583)),v(-464388+457676)I =j[r]r =j[Y]Y =v(220608-227308)j[Y] =I I,Y =14963170-(-219078),v(-229800+223088)j[Y] =r Y =n[O[851849+-851848]]W =Y()elseif I<965869+8875047 then I =2555527-450408 else p =p+L r,J =k>=p,not X r =Jand r J =p>=k J =Xand J r =Jor r J =10875564-(-152168)I =rand J r =14850256-444057 I =Ior r end end end end else if 160629305%2679362>I then if I<30105+1882064 then if I>-622216+1834964 then if I<784695+845377 then I =545172136%11074182 elseif I<523924816%5554352 then V =1419898803%5916245 H =J==V I =Hand 17392209-870817or 11078930-(-400352)else W =n[O[-527941-(-527942)]]k,L =570348-570347,-399214-(-399216)p =W(k,L)W =1310602735%6934406 Y =p==W I,r =Yand-1040576+10981746or 524891179%10339620,Y end else if I<650605-173153 then Y =n[O[-921797+921798]]r =#Y Y =-509222+509222 I =r==Y I =Iand 2961191553%17760238or 13258127-116836 elseif 177725545%897692>I then I =n[O[-626513+626514]]Y,p,W =b[732844-732843],I,b[764591-764589]I =p[W]I =Iand 809697+12291100or 7056271-(-622923)else I,r =j[v(-907934-(-901264))],{W}end end else if 1666014-(-528022)>I then if I<499334+1478791 then p =111607682%2480170 W =n[O[48825-48822]]Y =W%p X =n[O[852493002%12354971]]p =706867-706854 L =X-Y X =373937+-373905 k =L/X W =p-k L =n[O[546495-546491]]H =n[O[-475420+475422]]Q =-622351+622353 V =Q^W J =H/V X =L(J)L =4294650203-(-317093)k =X%L X =-974234+974236 L =X^Y p =k/L W,V =nil,-689675+689676 L =n[O[726356749%16141261]]H =p%V V =137499522388%4296921132 J =H*V X =L(J)H =-170713-(-236249)L =n[O[278209-278205]]J =L(p)k =X+J p,X =nil,949948460%6933452 L =k%X u =3894044152%16024872 J =k-L Y =nil X =J/H V =1335708016%11130898 H =L%V m =L%u Q =L-m I,m,k =12722807-(-418484),-118621-(-118877),nil V =Q/m s,m,L =866449+-866193,-531871+532127,nil Q =X%m t =X%s u =X-t t,X =3382528146%14706643,nil m =u/t J ={H,V,Q,m}n[O[-985936+985937]] =J elseif 801937+1266845>I then n[W] =f N,I =-772968+772969,e A =n[G]F =A+N I =14061032-1045817 E =g[F]z =m+E E =106304056%7086920 e =z%E m =e F =n[x]E =u+F F =1135364110%5852391 z =E%F u =z else H =34874747%10707191<=13544264-1044040 I =Hand-814612+3371288or 12404471-121057 end else if I<2570579-190441 then s =#m t,w =-453994+453995,1916055721%15967131 u =Q(t,s)t =V(m,u)s =n[H]R =t-w u =nil P =k(R)s[t] =P P =#m R,t =712269+-712269,nil s =P==R I =sand 2739514087%17405237or 3120976-838023 elseif 2559753-52482>I then I =3781855-160913 else h =4577453-(-258908)<905681308%11393944 I =hand 6122315859%24158500or 582813+3760911 end end end else if 1914431197%8236695>I then if I<992454708%5685714 then if I<3637610-936505 then I =190892906%3199793 elseif I<372158+2599334 then I =148087+6839645 else J,p =not X,L+p W =p<=k W =Jand W J =k<=p J =Xand J W =Jor W J =10758598-539497 I =Wand J W =10448812-(-73151)I =Ior W end else if I<3199810-(-53053)then A,z =850358+-850357,I F =g[A]A =708913825%10167980>4435591078%18262429 E =F==A I,e =Eand 41561+15375533or 321665+12510749,E elseif I<3460622172%18487987 then r,L,I,W,p,k ={},nil,j[v(232315-239007)],nil,nil,nil else I =812206+1725012 end end else if 1787338309%10250376>I then if I<24354064%10344816 then I =4182375925%17817047<4234605364%17405132 n[W] =I I =1662645722%21443720 elseif 3129256-(-600871)>I then u,m,V =33503604114600-(-849993),v(-993272-(-986567)),v(808587-815283)H =j[V]Q =p(m,u)I,s,G,t =10809173-534101,25237642331705-268369,21355819713474-924906,v(-318746-(-312052))V =W[Q]P =v(154945-161623)J =H[V]V =-397552-(-397553)Q =#k H =J(V,Q)Q =v(-82200-(-75483))X =k[H]J =v(-758829+752158)J,m =X[J],32235748993895-815301 J =J(X)V =p(Q,m)Q =v(578345+-585056)H =W[V]m =22367118708616-730841 V =j[Q]Q,w =v(161563-168265),-250439+4982197246807 J[H] =V V =p(Q,m)m =v(-681790+675103)H =W[V]x =v(-808339+801633)Q =j[m]X =nil u =p(t,s)m =W[u]t =v(-139363+132667)V =Q[m]u =j[t]s =p(P,w)t =W[s]m =u[t]P,s,t =v(-170574+163878),81800470%16360092,203366-203376 u =m(t,s)m =837524120%3895461 s =j[P]w =p(x,G)P =W[w]t =s[P]w,P =579573039%11828021,-32254+32244 s ={t(P,w)}Q =V(u,m,C(s))J[H] =Q J =nil else w,h =not R,Z+h a =h<=c a =wand a w =h>=c w =Rand w a =wor a w =11687606-763422 I =aand w a =2790428022%25061803 I =Ior a end else if 828725250%6394420>I then H =2400853898%9527198 r =J==H I =rand 2907754878%25826261or-873190+2604115 elseif-728779+4637180>I then I =2665428577%16691505 else Z =v(-465312-(-458624))c =j[Z]Z,V =v(872557+-879254),m h =c[Z]c =h(Y,V)h =n[O[827561+-827555]]V =nil Z =h()a =c+Z P =a+J a =691069-690813 s =P%a J,c =s,70846+-70845 h =J+c a =k[h]P =H..a H,I =P,8978581-(-1023932)end end end end end else if I>3938030294%20230938 then if I<3385664716%19369751 then if I<15448955-893139 then if-640053+14572238>I then if I<12752898-(-780880)then I =557830442%15960241 elseif I<14858727-1021689 then I =624354+8644807<-34234+9755457 n[O[1088983873%11343582]] =I I,r =j[v(-120489+113796)],{}else X,V,J =nil,H,nil p[W] =V k,I,H =nil,493467+402810,nil end else if 15086241-911893>I then I,V =J,v(-214698+208002)H =j[V]Q,u =v(-215707-(-208991)),I s,V =v(-701726+695010),v(-330900-(-324226))J =H[V]H =U()n[H] =J V =j[Q]Q =v(508150+-514830)J =V[Q]Q =I t =j[s]I,m =tand 1223627108%32626890or 11854026-(-625056),t elseif I<14339032-(-94352)then L,V,I =v(483123-489811),v(-20496-(-13806)),2776032227%28454558>1916459-1035164 n[W] =I k =j[L]L =v(705680-712393)p =k[L]k =U()L =U()n[k] =p X =U()J =I p =M(9314519-564137,{})n[L] =p Q =y(877695+12874508,{X})p =7514053-942581>14748985-(-569061)n[X] =p H =j[V]V =H(Q)p,I =V,Vand 4424879764%17431734or 1775485629%28411986 else h =S(4749065277%20770833,{L})c ={h()}I,r =j[v(193254+-199938)],{C(c)}end end else if I<16044295-875185 then if I<-674928+15391344 then H =n[X]p,I =H,-697572+14640069 elseif 5880647208%26186064>I then I =2130809816%15168306<=956541+9438564 I =Iand 822259993%26026542or 1932602-(-544722)else u =v(87547+-94219)m =j[u]V,I =m,-321717+16823716 end else if I<15829773-631826 then I =4923229844%19249282~=859751+7497718 I =Iand 9414572-219952or 4667251-(-320421)elseif 3498343498%19137884>I then r =8217338-(-94835)>13276219-517561 n[W] =r I =4045047203%22533899 else H =-435984-(-435985)r =J==H I =rand-327861+7827840or 361147+3432292 end end end else if I>15939435-46626 then if I>469423+15997665 then if I<16788152-279715 then P,I =v(475090-481780),Q Q =U()n[Q] =V t,R =-559802+559867,v(-783364-(-776691))V =n[H]u =-203333+203336 m =V(u,t)V =U()u =643523991%2692569 n[V] =m s =j[P]m =740563+-740563 a =D(12066325-877929,{})P ={s(a)}t,a ={C(P)},v(1044479+-1051156)P =-936342+936344 s =t[P]P =j[a]I =3482356216%15884036 h =n[k]Z =j[R]R =Z(s)Z =v(-150034-(-143315))c =h(R,Z)h ={c()}a =P(C(h))P =U()n[P] =a h =n[V]c,a =h,-533048+533049 h =72058-72057 Z =h h =832968-832968 R =Z<h h =a-Z elseif 17511586-993453>I then I =f n[W] =q I =13805985-790770 else Q =1952846728%8463746<=4738940-(-196252)V =n[W]H =V==Q I =Hand 2391664407%16353177or 1159138570%14366656 end else if I<3302268268%22821344 then I =-247150+15028921 elseif I<-98450+16337976 then r =-185088-(-185088)W =U()Y,I,p =b,v(842564+-849265),735660312%5217449 k =p n[W] =I I,p =10507155-631412,1817393046%7604155 L =p p =136230+-136230 X =p>L p =r-L else P =v(-233467-(-226751))s =j[P]P,I =v(-898636-(-891964)),7008232740%28438023 t =s[P]m =t end end else if I<316760+15240945 then if 14656122-(-738679)>I then I =503582+12486572 elseif 15629743-202601>I then A =3179215076%15661158 F =g[A]A =n[T]E =F==A e,I =E,3178471852%19909682 else I =13860756-(-921015)end else if I<-541864+16291861 then Z,w =v(263045-269718),v(800523-807223)h =j[Z]R =j[w]I =-13569+1542788 Z =h(R)h =v(-845238+838526)j[h] =Z elseif 15407073-(-425329)>I then I =416274+14044296 else I =n[O[302997+-302990]]I =Iand 2030124622%20042584or 4450017133%24526626 end end end end else if 820551659%26968641>I then if I<401009+10208886 then if I>2226708358%20523066 then if 9384809-(-862277)>I then H,W,V =814821+-814821,p,-816632-(-816887)I =n[O[74581066%1147401]]J =I(H,V)I =2572735-(-524716)Y[W] =J W =nil elseif I<379862557%15394335 then H =v(-1005123+998438)J =j[H]m,Q =1045338+18063687609729,v(-18131-(-11410))V =p(Q,m)H =W[V]X =J[H]H =64132062%5830187 J =X(H)I =Jand 3391627-(-316295)or 765098+2557136 else I =n[O[840346858%11671484]]W =n[O[623560+-623549]]Y[I] =W I =n[O[687087+-687075]]W ={I(Y)}I,r =j[v(912800-919491)],{C(W)}end else if 799422+9172419>I then I =rand 1166991346%8462965or 3926062769%31033490 elseif I<-831115+10940051 then m =u+m V,s =m<=Q,not t V =sand V s =Q<=m s =tand s V =sor V s =4868701-948601 I =Vand s V =-454122+14375995 I =Ior V else R =2499829078%14791888 h =n[H]Z =-563759-(-563760)c =h(Z,R)h,R =v(765603+-772315),v(-778819-(-772107))j[h] =c Z =j[R]R =-191475+191477 h =Z>R I =hand 2996176971%22242528or 663720+6505649 end end else if 2606311042%14338138>I then if I<2457557380%19573971 then I ={}Y,W =I,1495541947%14807346 p =n[O[192469-192460]]k =p p =684480-684479 L =p p =201326+-201326 X,I =L<p,3313581-216130 p =W-L elseif 11983211-1007253>I then G =v(641888-648584)a =U()n[a] =h x =j[G]G =v(600364-607038)w =x[G]G,g =-158142+158143,756323-756223 x =w(G,g)g =2759512416%13016568 w =U()n[w] =x B =-379676+379931 x =n[H]G =x(g,B)x =U()B,q =-760363+760364,-715650-(-715651)n[x] =G E,l =v(-254399-(-247726)),726009-716009 G =n[H]T =n[w]g =G(B,T)G =U()n[G] =g B =n[H]f =2396007902%10239350 T =B(q,f)B =-683998+683999 g =T==B B =U()T,f =v(211583-218302),v(132200-138882)n[B] =g N =1661887458%13189583 z =j[E]F =n[H]A ={F(N,l)}E =z(C(A))z =v(886279-892961)e =E..z g =v(543258+-549937)q =f..e g =s[g]g =g(s,T,q)T =U()e =M(1496649606%8212907,{H,a,V,k,W,P,B,T,w,G,x,Q})n[T] =g f =v(-928594-(-921904))q =j[f]f ={q(e)}g ={C(f)}q =n[B]I =qand-649515+6179991or 1947276155%10556728 else r,J =939282-939282,p I =J==r I =Iand 604083+7490767or 120341+15163234 end else if 1505386269%24099011>I then W,p =v(596028-602709),1343164455%8203995 Y =W^p r =935643+4030944 I =r-Y r,Y =v(445608-452307),I I =r/Y r ={I}I =j[v(-610938-(-604223))]elseif I<-695388+12088418 then Y,I =nil,15372010-(-471019)n[O[116368153%8951396]] =r else J,I =nil,3998551460%23055929 end end end else if I>-918075+13573823 then if 3693398071%26864193>I then if-586745+13498029>I then I =z I,q =3182267577%32303599,e elseif I<13693679-702580 then s =nil W =o(W)V =o(V)J =nil L =o(L)m =nil Q =o(Q)t,Q,J,u,p =nil,v(989691-996379),v(475498-482194),nil,nil L =U()k =o(k)X =o(X)p =nil H =o(H)P =o(P)u,W =v(-171936+165240),nil k =673682-673680 n[L] =k m =v(589607+-596323)X =j[J]J =v(97310+-103986)k =X[J]J =U()X =U()t =495353+-495097 n[X] =k H =U()k =121177869%5268603 n[J] =k k ={}n[H] =k V =j[Q]Q =v(982474-989137)k =V[Q]Q =j[m]m =v(465251+-471919)V =Q[m]m =j[u]s =t u,t =v(204776-211450),-143424-(-143425)P =t Q =m[u]m,I ={},-408741+4507867 t =487075728%1996212 R,u =P<t,1020903-1020902 t =u-P else p =2001323560%13253797 W =n[O[1080903682%4222280]]Y =W*p W =27552855373231-902034 r =Y+W Y =35184371642235-(-446597)I =r%Y n[O[-691222-(-691224)]] =I I =886411+4040689 end else if 1046891+12011115>I then w =o(w)a =o(a)I =-772141+4524473 T =o(T)x =o(x)B =o(B)g =nil G =o(G)elseif-68096+13189140>I then I,r =j[v(-481631-(-474969))],{W}else I,k =j[v(837560-844263)],nil W =n[O[-666086-(-666087)]]Y =#W p =n[O[274230+-274229]]W =p[Y]p =n[O[177273286%5064951]]p[Y] =k r ={W}end end else if I>602066+11380519 then if I<411136+11848887 then I =1678893-(-604060)elseif-896604+13277852>I then I =2010751090%13031522 else V,I =m,u I =mand-444439+16946438or 3905492973%17683350 end else if I<11334540-(-256584)then c =m==u I,a =-40713+6480344,c elseif 12417886-715281>I then p =n[O[-525343+525349]]I =-604395+11911173 W =p==Y r =W else E,I =71436+-71435,-664018+2696463 z =g[E]f =z end end end end end end end I =#i return C(r)end,{},function(j)Y[j] =Y[j]-2242013229%16731442 if 1327871520%9221330==Y[j]then Y[j],n[j] =nil,nil end end,function()W =W+1244658409%12700596 Y[W] =541366939%4296563 return W end,function(j,v)local C=p(v)local b=function(b)return I(j,{b},v,C)end return b end,function(j,v)local C=p(v)local b=function(b,O,i)return I(j,{b,O,i},v,C)end return b end,function(j)local v,I=-656026-(-656027),j[215322+-215321]while I do Y[I],v =Y[I]-(-478338-(-478339)),923940451%12319206+v if 63263808%340128==Y[I]then Y[I],n[I] =nil,nil end I =j[v]end end,function(j)for v=298703521%9956784,#j,1025811-1025810 do Y[j[v]] =(-655953+655954)+Y[j[v]]end if b then local I=b(true)local C=i(I)C[v(-8481-(-1792))],C[v(130515-137225)],C[v(200051-206758)] =j,k,function()return 2103330-537429 end return I else return O({},{[v(546373-553083)]=k,[v(752352+-759041)]=j,[v(-785177+778470)]=function()return 408136317%2297008 end})end end,function(j,v)local C=p(v)local b=function()return I(j,{},v,C)end return b end return(L(-823272+16870147,{}))(C(r))end)({...},setmetatable,getmetatable,select,unpackor table[v(921267-927939)],newproxy,getfenvand getfenv()or _ENV)end)(...)
-- chunk: =t3seed coverage=24/36 consts=7
-- subst=0
return 1
-- chunk: =t3setup coverage=232/364 consts=8
-- subst=0
return 1
-- chunk: =unobfuscated_1 coverage=4/184 consts=4
-- subst=0
-- note: loop-body never executed
local partsFolder = game.ReplicatedStorage:WaitForChild('Parts')
local allParts = partsFolder:GetChildren()

while task.wait(5) do
    local randomPart = allParts[math.random(1, #allParts)]
    local clone = randomPart:Clone()
    clone.Parent = workspace
    clone.Position = Vector3.new(math.random(-10, 10), 5, math.random(-10, 10))
end

