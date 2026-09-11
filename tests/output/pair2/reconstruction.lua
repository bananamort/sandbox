-- chunk: = coverage=621/1158 consts=1107
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
-- chunk: =CoreGui.RobloxGui.CoreScripts/DeveloperConsole coverage=90/804 consts=48
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
-- chunk: =CoreGui.RobloxGui.CoreScripts/GamepadMenu coverage=228/864 consts=204
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

-- chunk: =CoreGui.RobloxGui.CoreScripts/HealthScript coverage=354/1146 consts=4434
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

-- chunk: =CoreGui.RobloxGui.CoreScripts/MainBotChatScript2 coverage=579/3021 consts=364
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
-- chunk: =CoreGui.RobloxGui.CoreScripts/NotificationScript2 coverage=324/4866 consts=1646
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

-- chunk: =CoreGui.RobloxGui.CoreScripts/PurchasePromptScript2 coverage=312/8658 consts=276
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

-- chunk: =CoreGui.RobloxGui.Modules.BackpackScript coverage=5928/13992 consts=27121
-- subst=0
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

-- chunk: =CoreGui.RobloxGui.Modules.Settings.Pages.Record coverage=606/1092 consts=462
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
-- chunk: =CoreGui.RobloxGui.Modules.Settings.SettingsPageFactory coverage=1422/2742 consts=1008
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
-- chunk: =CoreGui.RobloxGui.Modules.Settings.Utility coverage=912/1896 consts=1176
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
-- chunk: =CoreGui.RobloxGui.Modules.TenFootInterface coverage=438/828 consts=252
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
-- chunk: =RbxUtility coverage=900/1770 consts=534
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



























-- chunk: =Script Context.ServerStarterScript coverage=108/747 consts=8628
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

-- chunk: =Script Context.StarterScript coverage=474/1050 consts=276
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

-- chunk: =obfuscated_2 coverage=108/28359 consts=57
-- subst=0
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed
-- note: then never executed

return setmetatable({[ 972932]=0, As=function(fO,yV,tN7,hO,O8,ak1,vk0,DN6,tU,BG,yl2) local aJ='Detected by [https://keyforge.win/obfuscator]' local uC=function() fO[143](print,aJ);fO[218](aJ,0) end if ak1(yV)~='table' then DN6(print,'Detected by [https://keyforge.win/obfuscator]');vk0('Detected by [https://keyforge.win/obfuscator]',0) end    local _gf=tU;local _e=_G if ak1(_gf)=='function' then local _ok,_r=DN6(_gf);if _ok and ak1(_r)=='table' then _e =_r end end tU =function(_t)if _t==nilor _t==0 or _t==1 then return _e end if ak1(_t)=='number' then error('invalid level',2) end if ak1(_t)=='function' then if ak1(_gf)=='function' then local _ok,_env=DN6(_gf,_t);if _ok and ak1(_env)=='table' then return _env end end local _ok2,_env2=DN6(function() return debug.getfenv(_t) end) if _ok2 and ak1(_env2)=='table' then return _env2 end end return _e end    end if ak1(BG)~='function'then BG =function(_t,_e)if ak1(_t)~='function'or ak1(_e)~='table'then error('invalid argument',2) end local _ok,_err=DN6(function() debug.setfenv(_t,_e) end) if not _ok then if ak1(_err)=='string' and not _err:find('setfenv',1,true) then error(_err,2) end end return _t end end if ak1(yV.lrotate)~='function' then local _b=yV;local _lr=function(_x,_n) _n =_b.band(_n,31);if _n==0 then return _b.band(_x,4294967295)end return _b.bor(_b.lshift(_x,_n),_b.rshift(_x,32-_n)) end yV ={band=_b.band,bxor=_b.bxor,bor=_b.bor,lshift=_b.lshift,rshift=_b.rshift,lrotate=_lr,bnot=_b.bnot}end fO[95] =yV.band;fO[106] =yV.bxor;fO[121] =yV.bor;fO[215] =yV.lshift;fO[87] =yV.rshift;fO[174] =yV.lrotate;fO[181] =yV.bnot;fO[140] =tN7.byte;fO[158] =tN7.char;fO[25] =tN7.sub;fO[206] =hO.concat;fO[186] =hO.pack;fO[86] =hO.unpack;fO[166] =O8.floor;fO[202] =ak1;fO[218] =vk0;fO[143] =DN6;fO[230] =tU;fO[193] =BG;fO[204] =yl2;fO[113] =nil;fO[186] =function(...)return {n=select('#',...),...} end fO[86] =function(_t,_i,_j)if ak1(_t)~='table' then return end _i =_ior 1;if _j==nil then _j =_t.n;if ak1(_j)~='number'then _j =#_t end end return hO.unpack(_t,_i,_j)end local ja=nil local xw=nil    local _cLs=fO[206]({fO[158](fO[106](115,31)),fO[158](fO[106](67,44)),fO[158](fO[106](88,57)),fO[158](fO[106](34,70)),fO[158](fO[106](32,83)),fO[158](fO[106](20,96)),fO[158](fO[106](31,109)),fO[158](fO[106](19,122)),fO[158](fO[106](233,135)),fO[158](fO[106](243,148))}) local _cLd=fO[206]({fO[158](fO[106](89,53)),fO[158](fO[106](45,66)),fO[158](fO[106](46,79)),fO[158](fO[106](56,92))}) local _cGenv=fO[206]({fO[158](fO[106](116,19)),fO[158](fO[106](69,32)),fO[158](fO[106](89,45)),fO[158](fO[106](93,58)),fO[158](fO[106](34,71)),fO[158](fO[106](58,84)),fO[158](fO[106](23,97))}) local _cPin1=fO[206]({fO[158](fO[106](24,71)),fO[158](fO[106](63,84)),fO[158](fO[106](7,97)),fO[158](fO[106](49,110)),fO[158](fO[106](21,123)),fO[158](fO[106](233,136)),fO[158](fO[106](225,149)),fO[158](fO[106](203,162)),fO[158](fO[106](217,175)),fO[158](fO[106](217,188)),fO[158](fO[106](150,201)),fO[158](fO[106](162,214)),fO[158](fO[106](134,227)),fO[158](fO[106](136,240)),fO[158](fO[106](137,253)),fO[158](fO[106](85,10)),fO[158](fO[106](123,23)),fO[158](fO[106](87,36))}) local _cPin2=fO[206]({fO[158](fO[106](12,83)),fO[158](fO[106](11,96)),fO[158](fO[106](11,109)),fO[158](fO[106](37,122)),fO[158](fO[106](247,135)),fO[158](fO[106](253,148)),fO[158](fO[106](207,161)),fO[158](fO[106](241,174)),fO[158](fO[106](216,187)),fO[158](fO[106](167,200)),fO[158](fO[106](184,213)),fO[158](fO[106](146,226))}) local _cPin3=fO[206]({fO[158](fO[106](62,97)),fO[158](fO[106](5,110)),fO[158](fO[106](29,123)),fO[158](fO[106](215,136)),fO[158](fO[106](251,149)),fO[158](fO[106](195,162)),fO[158](fO[106](219,175)),fO[158](fO[106](213,188)),fO[158](fO[106](191,201)),fO[158](fO[106](179,214)),fO[158](fO[106](188,227)),fO[158](fO[106](156,240)),fO[158](fO[106](142,253))}) local _cDead={} local function _cProbe(_fn) if ak1(_fn)~='function' or _cDead[_fn] or _fn==xw then return nil end local _ok,_res=DN6(_fn,'return 1') if _ok and ak1(_res)=='function' then return _fn end return nil end local function _cPush(_list,_fn) if ak1(_fn)=='function' then _list[#_list+1] =_fn end end local function _cNamed(_list,_t)if ak1(_t)=='table' then _cPush(_list,_t[_cLs]) _cPush(_list,_t[_cLd]) _cPush(_list,_t.__cload) end end local function _cResolve() local _cands={} local _env=tU() if ak1(_env)~='table' then _env =_G end local _ge=nil local _gg=_env[_cGenv]if ak1(_gg)~='function' then _gg =_G[_cGenv]end if ak1(_gg)=='function' then local _ok,_v=DN6(_gg) if _ok and ak1(_v)=='table' then _ge =_v end end _cPush(_cands,rawget(_G,_cPin1))_cPush(_cands,rawget(_G,_cPin2)) _cPush(_cands,rawget(_G,_cPin3)) _cNamed(_cands,_env.Real) _cNamed(_cands,_env.Delta) _cNamed(_cands,_env.Xeno) _cNamed(_cands,_env.Opiumware) _cNamed(_cands,_env.Volt) if _ge then _cNamed(_cands,_ge.Real) _cNamed(_cands,_ge.Delta) _cNamed(_cands,_ge.Xeno) _cNamed(_cands,_ge.Opiumware) _cNamed(_cands,_ge.Volt) _cPush(_cands,_ge[_cLs]) _cPush(_cands,_ge[_cLd]) end _cNamed(_cands,_G.Real) _cNamed(_cands,_G.Delta) _cNamed(_cands,_G.Xeno) _cNamed(_cands,_G.Opiumware) _cNamed(_cands,_G.Volt) _cPush(_cands,_env[_cLs]) _cPush(_cands,_env[_cLd]) _cPush(_cands,_G[_cLs]) _cPush(_cands,_G[_cLd]) for _i=1,#_cands do local _fn=_cands[_i] if _fn~=xw then local _p=_cProbe(_fn) if _p then return _p end end end return nil end ja =_cResolve()xw =function(...)local _last=nil for _=1,8 do local _ls=_cResolve() if ak1(_ls)~='function' then break end if _ls==_last then break end _last =_ls local _ok,_a,_b=DN6(_ls,...)if _ok then return _a,_b end local _msg=ak1(_a)=='string' and _a or '' if _msg:find('RobloxScript',1,true) or _msg:find('not available',1,true) then _cDead[_ls] =true else vk0(_a,0)end end vk0('loadstring is not available',0) end    end local _nSet=fO[206]({fO[158](fO[106](40,91)),fO[158](fO[106](13,104)),fO[158](fO[106](1,117)),fO[158](fO[106](236,130)),fO[158](fO[106](238,143)),fO[158](fO[106](241,156)),fO[158](fO[106](204,169)),fO[158](fO[106](213,182)),fO[158](fO[106](162,195)),fO[158](fO[106](188,208)),fO[158](fO[106](177,221)),fO[158](fO[106](135,234)),fO[158](fO[106](146,247)),fO[158](fO[106](112,4)),fO[158](fO[106](121,17)),fO[158](fO[106](113,30)),fO[158](fO[106](79,43))}) local _nRaw=fO[206]({fO[158](fO[106](72,47)),fO[158](fO[106](89,60)),fO[158](fO[106](61,73)),fO[158](fO[106](36,86)),fO[158](fO[106](2,99)),fO[158](fO[106](7,112)),fO[158](fO[106](16,125)),fO[158](fO[106](239,138)),fO[158](fO[106](227,151)),fO[158](fO[106](197,164)),fO[158](fO[106](197,177)),fO[158](fO[106](223,190)),fO[158](fO[106](169,203)),fO[158](fO[106](180,216)),fO[158](fO[106](128,229))}) local _nGenv=fO[206]({fO[158](fO[106](116,19)),fO[158](fO[106](69,32)),fO[158](fO[106](89,45)),fO[158](fO[106](93,58)),fO[158](fO[106](34,71)),fO[158](fO[106](58,84)),fO[158](fO[106](23,97))}) local _nLs=fO[206]({fO[158](fO[106](115,31)),fO[158](fO[106](67,44)),fO[158](fO[106](88,57)),fO[158](fO[106](34,70)),fO[158](fO[106](32,83)),fO[158](fO[106](20,96)),fO[158](fO[106](31,109)),fO[158](fO[106](19,122)),fO[158](fO[106](233,135)),fO[158](fO[106](243,148))}) local _nLd=fO[206]({fO[158](fO[106](89,53)),fO[158](fO[106](45,66)),fO[158](fO[106](46,79)),fO[158](fO[106](56,92))}) local _nNc=fO[206]({fO[158](fO[106](22,73)),fO[158](fO[106](9,86)),fO[158](fO[106](13,99)),fO[158](fO[106](17,112)),fO[158](fO[106](16,125)),fO[158](fO[106](239,138)),fO[158](fO[106](244,151)),fO[158](fO[106](197,164)),fO[158](fO[106](221,177)),fO[158](fO[106](210,190))}) local _env=tU() local _ncCache={} local function _pick(_n) local _v=_env[_n] if ak1(_v)=='function' then return _v end    local _gg=_env[_nGenv] if ak1(_gg)=='function' then local _ok,_ge=DN6(_gg) if _ok and ak1(_ge)=='table' then local _w=_ge[_n] if ak1(_w)=='function' then return _w end end end    end return nil end local function _ident(_m)if ak1(_m)~='string'or#_m<1 or #_m>64 then return false end for _i=1,#_m do local _b=tN7.byte(_m,_i) local _ok=(_b>=65 and _b<=90) or (_b>=97 and _b<=122) or _b==95 or (_i>1 and _b>=48 and _b<=57) if not _ok then return false end end return true end fO[113] =function(_obj,_method,...)if ak1(_obj)=='userdata' then local _tr=_ncCache[_method] if _tr==nil then _tr =false if _ident(_method)then local _ls=xw if ak1(_ls)=='function' then local _ok,_chunk=DN6(_ls,'return function(__s,...)return __s:'.._method..'(...)end') if _ok and ak1(_chunk)=='function' then local _ok2,_fn=DN6(_chunk) if _ok2 and ak1(_fn)=='function' then _tr =_fn end end end end _ncCache[_method] =_tr end if ak1(_tr)=='function'then return _tr(_obj,...)end local _set=_pick(_nSet) local _gr=_pick(_nRaw) if ak1(_set)=='function' and ak1(_gr)=='function' and ak1(_method)=='string' then local _ok,_mt=DN6(_gr,_obj) if _ok and ak1(_mt)=='table' and ak1(_mt[_nNc])=='function' then _set(_method) return _mt[_nNc](_obj,...) end end local _f=_obj[_method] return _f(_obj,...) else local _f=_obj[_method] return _f(_obj,...) end end    end local CO=fO[206]({'y(kTn((8LchV&c;<[TF=EDLLtHE9]1[=-n$>]yD.RGeW\123=[[irvA/\123KA&_:2S~xs(FmqCdv>Hm+)tm|1DNS','8cx%m%x]2}3~MBp40R*6z%=BY39f}nSG\0964].e8MCa\123wgY[1S]/*2=U','s#|))a;HTRF+RExEMFd36O6\123x-UJv56l','GC%jeLLuQe4|!@/*hDu+9]5Zhr','MToUhGv74]n\096c>-H>VMCjHaD%6*2$|w(lFQf(',')8.F&Qyr3Zix<;hWE/(\123<N2w>!Q@CNbfc1+s&w-+n/fc-','8O|sukUWLFUSBS8f;aonC)_NwuVF(eZ5VE+3bwu>tfn=QFN#yur@ndU0S)QMc8*li#','&@9!#[a*x.t&KDFc@_@HZV#WlT=[Q','9JiJpB~Q\123eY!Dq1\1232CD/4fUqt8-.|Duz>C)mvlD!1xij\123!Y9;63@fQ(2inV0/xB8GM7m[hOS!jw.[gW7c!4<*#Bs\096>QgD','6@4W<30W>p5kH8hly.!!gb[AxgE\1236s4q|[]ftucT*!HaV(qW(bcMH','emS@6o*ftBTitrx\096A$T2;7w]Ay0f8ns9R-+1C|(ksN$.h_rW.L.1Qb|/5','l;6&rOYa[Ql-M0cJ)BUe_Cn_ojy%b5.xGO$#[k4O5:d3Z\123Vo!71#w}%QrHKl(onSAotL#D]CmJ(dVbNg','b9lL@$KQn24luMGdwdo03:g*~[=:aJA1wE2\123kG3mAuFbaO(','8K}8q=rYni#_+BWJdkD<>j[<&>_+oBW~5Rm3W#G=KEf+Y@cCBV$0:Mv~YvkHYgBB;:Splx19Oxc:RL9)OlH7oK','N&|4\096saW.h<\123w4LZ;$q$2_O-]mrnnK]F%/;3*}iv2YwaV=FN*=Vs6t1n65ZT-.md%','[7o.AH6}(:#k9/WnYWZvo*gqu.g|;p\123','FLzKOxa@/Z&@>#GU2dr#]Zyj1)efvR\123oHb5!4Gn','\096axJ(dEv=zO8W>F|F2q+@bp6jGzg=R@d>J~jT7xJ1]~=LFC@m#5Vhl$*4cc:K\096[G!94%LKOoWN>QdZhdUKf58p%4;z1rA%','@]m:O:$\096pOVb\0967}WkQ8M_woOCmn2>c;}OtL:_1D&4)}\123oY(oD8)6vOMExO\123_4urw*rWnu$;E-E}$R[6|5O]Cbj\1230Ny=fyC)','y3]t4+CC4D!Do13<Z(ckLTR9','JNAgqWZ-BxT.ww_+owk(=vTsjDJdl5tKa','8Cd(ocJh}g2Oyo*B_3p_n]|bL#jdbsYwsb#FEUHA\096)HfNx*9.Bpf4:f&zG:F78*nMVtxH%n\123ExVO|tqeE<9$]KC*T>E<J8','dq_uRQ}CwFYpbmOH<uaZBSf-$$6byTH<M4}\123o}35%O6\123}18b_]h',':Q((0bc4zW\123Nz.t<c&s*@U6=Sk6&','#Cx8gu;0UQGREvk<H+Vq5N~[!mv$L8F\096+=#sD<Q<RCM]oHWvbWt_a&rvM/h5*5BMmdUW','t(1tc0Q3lm&.9q:M/uEwHGDB|Sbe\123}z-446.#m8','Vy;borANK23p.UfH|amVYvte;C26xqNnr}o$&MjbjVAwC6E4il]pr<BJ&_c][','.W<7tBgEm3fVW>w~m&hx}Az/|>/:t12c9aE%Jjx|}-}tC\123jNu9s6','fWf&<DB8wR3yGqy#Oe5+a3lTuK*>F%DrajM\123qG\096.|2j+81c}g9!)Q=Mi4kCCgfyp%.@oc','stiix5$788fyY@<]y[r=V5C+7V>Q6M7o@Q!!_ved=tWUsSf92F.YdViAe89U&b)Ox','e3uu&5C0$N)kjY512EjT5sB;a$D(d+N:o+wVZ:nnM;aKc0G+v2(AWc/v_-VB','3%\096OcxN3%d:Q.@5DlcQ3#pdN[swgG7;b_.sAQM','hjsWNNGqKBAiCj<L#7kN<ix3mcp<-CfHBdxw}SVu/Tp(s/*F9C','KoHb5E||.hFT1Gl|~JNe$>!%(FWhOq0\096&|E|o)63[RV\0965spEMGk+4\096cDMO[Ad>\123:0}6sKaWs:\123h+BNx+}A7K\096g|','T:w=aV~d*J0!Eqe=6wf6jR5[F@Yq1V(y61;xs!NdKxCp=ac=F)7vnC','BF4j%v}b!7d]\096~g<g9$b:HN}iK$GE/#4ZEs[7','lRYzt.1+v-&Du5>>BSKUtCy_$w}e%2m##l4Ye.~Ksa/\123evM/d>&93Tkbd#<2(Gxo1q-N9sy~&9Ukba!|aDWZaYmi','B}z|69#is9E#eoq9!JJQjkC\096:TN4Z5M<;k*G\123k>});*knDaGDEoEJz]%tq','}TiqN#0Ku;wfK*OYctHqh$*Scpq4RU\123u%-HYO0LCL%Vxy3Gbza\123y+@JOSN-J|V[|<#!p]D/hldpDtRL(r#D4QORnGK6','W.t-JEWJxJQa#\123=F!]eNblN7>YL=8=:8wv&d}l:o*UHB}','683[G6E=@kq$!d]u1=m.KC-c90.@e)s/U\123sxbQy!Z1ehqu-(/Uby6L1LQY_x',']T\123Ki]LJ6t1@J0c+Ml|\096%[Vm}4U6+Q69t~\1233s)\096UA7rGq$z(5RSsiW3+g;!.ri~:3vpEhvM8[l_)MvCZ}5TY','G97;@C;>ckA<WDtby-AAcfH!8Z','!mJsKqiD9qa;myh/o#4s$1lil;<\123p(}y>i/8*57+MsOQ>OH*nJU8aCQiTZHtV\123(R$3CL2:Hog','2HdWmeMH@*--sE#&-#ZOHE%4!\096S/u_K.','4f2n8Y~Oy\096ucNs5H;hLJFER1(pSEhtiT+ES=SQO6YWo}i/xYin4O/\09616=77hO9d+u.#nMc6);;Ye*)#}/D%%j@M','Tv16Km$..Ko4}#2w>59cNeg2j]Cztuv[fUq_yDr|Num}ao\096x+i1:FLdJSAj<acn*l','>QrgiKL95ebB.eaq$/TCR|NY<nej:h)Al~L}8E\123#4)WZUr[','Q|34q~1:sw97sWh@6;F0|4~1:+@>)gr>meU>$!7}qno0GU=bzFYa','(OrQ$b~m2(R!lm%m%K8RCKrel@L/q6VV&7j+|9MA*b]92(|E7','pnwu&o/(En\096$T|N!z\123@fgz08RwD&m;hT\123HEN&eWTOx%GCJ2QWG+!%5;f)R','HK7w3o7bLv;Vwsw>\096a%LW:%0\123k=/\123*xwT/7r&9ZJQ(','iL~VStzj#S40Yj>&1NrOskK/(exfGG~xYh2Af%FYnqyoosqL#J>D/;Ot%p}qA@t','NN)OUx[C5Mk&TU;uv}1-A+V#\123=}!CN&Mxl@5ce0V61On.a|0]:M;zLGv@=tlNZab\123~z3m4nwv=Or','v|6pT$s)w&qeji4>Nd~c%(6@d@Z:wj8sN(Qu0.<Nm7TC!%j(fgYz[i8]@7\123Lnloo5WK&ca8FtwsJNhFe+U$g<2m0)','GhR[*\123nYJY2b1RWC8hhuDC\123%8-B#H+@~F$5\123a=%:moe[Yv-bUS;yvJD@!r!JD}GF0R>=5#','FQLc9w}wEo_0fNl(q\096\096s.vexBA+dOu2Kl|7u.o}:2VoxQD&q)46}c','E/\123Qf#.1Mhw@leeK0[vH#x8k8_&s<M8J/mWub|!}>6T14S|WGmg0J1[b]~MxeKL@!M=swM|QA|','dT>|>Ol1x#]@6zu<h\096_ei<F$zJ\123Yz<u|\1237V$3W}lhhL31=R[v0zOZBzC#4m+|+MmfkC!SM]z','9B&vw\123fzGiyMOgl<|F%:\1238h*C\123M_m=7Q<6D531W/31GMoLKrxxKSgs:O~#Y9$[-j+D6~u~(4]L!(9|!$z&K[Q','5U!oSwtF>l5fd#QR\123V05B0sUOuj##!]y#bz/9us<VvA-0J9Tfbr&p88}R:l])s([8(DKTZ/(ch','_;Dx!}v!*4R!y%p3WkMg!>e&(-DF)vUL<!4JTa\096yZBg6j*!B=]s.J_m(','RkVhJCHQJJ8i%Wg-0U&hSrsC#C2GBGW/Dbx|SCyO:GQF\1232n|%jhi-s\096}BTkCH2slHMC%nS<','H8VvUhAD0vdQ=jJnu(ZQkx+A~1&Qdr\096*bex>R6Uq|~Z4)Ep-ew_QM/pD3$@cr06d8Q-Wq9#/LaO[(k@k.c!<7\1235W)H@._[|','M/v]9}+d9g4}0)m_=.=#T/__nJ*kF*l>/<','9oD&6;AVKi\123.a+/F%HiaW+8S~FqvBMrcRhD1nJFE\096kTyJ5h.$xDN>WGG$','NCF[*Z~f]cECt2\123v<~#iGZGp<FrZVS8<_V};Hm6uVc]p.zUpHw)s;}Rux$+0','Vk||Ufb10_m&}Tdzy;<J/s8m\0965M14EkC/vmB6we!-31Tp4lg;}/chO~Tti+q;LDUE*Zi|i\096[z>k','\096gexsG5L=6AMBTvM\096dK*\096Bu<7J3(oT7Oq9','FtS*l&LMzZ0&Ex[rY(RZMNCFDmH)m)t_=SBBfygMs%~}vE&J4voar]S2#LcNz}=e','l/1oN!%G/4TAG-Sz4]RVfWvB#:oj4LJl*<}s(yb;AV!}cWL4qdp])o97hu*5FiTm+o/73c/MKJT=/08zZ','Nxi:3269:)ok\123xMqa<aCz-)CS@','wE@p\123<Ztm-oQ&GGKoSt)K/Vg#hg5mY[Zc||1rCZh%\123Sr7RantTZ\1232UHE&jQ%e9W=@7oQ1\096zT\096l52Cc~ee\123|V!+TQ3','AoW#tx/.c\123g%(>l3Bl}N_/<a.fx:/\123rH','+%A)Rm4o1<~3_tj[tYhhm4u}:hQvwzg<ZL9Ozz3$:D0v3$pAejKUj','lHrBYN8us:QEJttLJVl:9](fulL)gSie*fmw','/Uh_A*cRW#\123N=8qR6/8078HpkMMu<lr)qH>m#L/Cs483oj3%OR;H;+1:kFowT9#s0hK]ZL0m;FKBW+>5(Uy)H5~D*gu','(fa!\096.m]JbomW((i%]4z~#306ZHf5-qZ0b','GA]x:#V>dZ}\123>6o~UFFnh5*nF:2\123F','$B*D(D-a[)CV[p43R$E)b5H6m%[5.366RE-8\096uBZD>y+|D}a4n>vNz5\096/fOO1>*QBlq@zOnJ/uL1!})RaRoV6*w0woK7>*','7wE2W;AA1N9&Juus)mlF-+)YtRx9lyuR','m)8&fNt9ujY=o-#mri33B4V(LE>B@.%e0s8*DzRvJ1ze8)M.[n4(x*r2Lb@9u!3MC@m;K&L','YfE_ua!m\096yO37|$d+nf0SEZ_>bvv@lDza[OYp&Rp+&v(r.<k1Jn[<@t]v2;p<~','uFg-pMh+\096S&)#Mfexv|_Cc&kld.1~l0!c0H7m#;z_=\096%Uw+7fc(C|-2$=s.&9mL*az8#G@+yue','+)B4+.O5.m~JhBV13Fz;;:5%u59#&qq$~*yc9&[CMy%4Dz9s\096pE',']y\096hA$x7o}\123y/#lqVRARlp(9elrBr@O0udKyV8$(0>@_}b]*\123;ZWBZHWkO|n\123H','!9WuH044:3|DDm9-KBCGT$*5*VKw3Skr(AD.7clp57n#+[%4S0yum1uF:3w\096)O\096#tURT=h%[Hn!OZaG|J\123j+k','xZJ3UE~xGrt$&[jNYtca13K]Fs~A>TU.S8m*;NRpz@&(z/pA','}14}z1|V:JKb19w06!]V.md<sbkzY))a;HTkwr_vgA4q).paj\123snG;!Y425%n}y\123\123yNor]=zL5=QCG\096(.=7JMd]Qz7','}0mqnAo=HjVGG~j+Rvlfq_px(Dl39~R&62S#bv@@Qyg)5SF<).dtj)}.o]Ct<iG63vC','s#-[J8O>1\123wZ.n|J1nY6wZS\096B\0962snx[_;BLt5(g%BcT/uT~z%Hy2n)Rqo[gMUC9CTka~','uLR.d=4~UVMh*G:azO!M0W6}8N','Kbp=BLm}z}#M4.1=\123A\096mM=7siz-lUo(s=TFWjMDEm$%gch.A3\096;C!/fhl|2(Qlj&c-J\096x!','h&+OZTe>Lt6Gv>+VZ0Myf%:<br|l)DC\123FNF0/5J}H\123qG_#9%Zm[sJ92&tGNwhq3Mg!]*AoNAjzr&OsuOC','x]MCBhb!nCv_\096Z)a5.1p*r;*Lds~9}llgB:Jp;','|e!-wBKfczB$ESi3qv~N]leosT;;','pxp.2=v3e)RiQkG/N2eBE|BV.(N','}sC}B.A_l#~G/_E/cJl7/ibH2(pt2Vi3xw*RURK>7wp\096d=','DKdO]Zhu:t||<36<UwKEg6x\123>YUe$8MzWU5L)5teKre3@(W<H13]8>Oz~)#ghw1GYH/!Rs:CRVpQBo8[\096Rf[T7*xf\096}$hD','+Q5B#]@(j!s\096>vVGH*)hVN~G))}jmNQ|VRGHR+\096;+&_FV.:!F+Q867j|ZR}8z6~@:xU::;','+4!r[+i#=e2CaC)9hO=bf=~%42G]Jux=dm4YyFKs#\096UDR]aYF.\123MN}V4w~JRv\096\123:KVJ1','086ff2hv4L[:aY.vCe7|<;}5gCB(Z(p@>3~>=xvhAswg:);z6~}lf4;O06psy:;JD)/5!W5h1/b2wBcc1#hHat04=jZ','ZK<M|Oa7xMgojjK7jRc~BTA8|bVNG.QopYsehDmMfFZAL]J','0q7CE1$TfQY3_QUWxB)%A/akKm;yLf_\123fU)%29qSo~m22iD8*w6l~dM@q#>','=.yDNx@:(n;b+S3F<1nj5*|~au6]4u@f=D}FmV(0VueDZo+iCF[(=>HDv+wSEgrGU6rC|ddLJJm366!x.[0bl/<','\0967xUi6BJ$vR=f3e;cD5gTDm}[Z~\123&4%3MW+jMq81k2xKzHm!_Wa}c59NJ2%go\123/laxf;N/}C~fjTo2):_[\123','bn059x>m6z0<LMAmM_@F.5_1p.iEt[a<M)&S','f)Q#t+U>6Y%nq9/\096LH[u46|aUc#Z)&9srEf1MDT)f\096dgJ=fLG4E@7V0','HH5Ucy\1238x/GxB/AL+%n!t9+dZ4li52L!u\096dmy~B2-#/U2$FL1WFt52_+9HV8h@6T)HwH_B:Zh2zrWw[*&&4@]\096pMO5*','FKgM:&!;tZig%Y=;N&:BqGW6WGTx~C[5Z9','LU.>O]ZEZe]Jelo2FM#\123tWFnJm}_5#7%.D7za]-MZel%\0962','7HDz$$.}\096\096n_w]uF(GQV0Q=<p*\123Gnm9zF\096a*9}\096)|/!wt1%~@jpBT:Yt~;86:j];=1#4aitJUR!CLNuE#a@vgK(>','Ex4u]ViZeTNc;$x}|MJ>9W>%syo/Oh~)35\123mhqj.EJ;EAJM1jdEh:yefq0t.zoU\096([9-~]jm','1cTCTEtj4hF@enVg>~&tg+No|\096|;LqYCy8AEK\123u&|aQ|R;L_Z<x;#','EvAOQQnF>8:#)KwtAAF)YZqhmsLqslaCfqc@Sx%qSAYl5*7yTMz]93[e0D:74p]GA2msCJUy\12365j5Yzm>|\123]j','NCgM@S:xY~JEZL)NC%hEe|lbZrNySu|~!h<','QeDo&Ay8<Q|dxuEmA9|G=H.|9h|55(ToKJ[$QHofCN.r099M','4K#oU.#/9SSz<HFmSr[Z\123A&Ybgmj6B_nJf+#g(@][d$pBS~}L$L>|$K/uyu-T$9Y<gN6bMtRY*(}+0_u!y6931hWt)5KR','e.gpY0hZtQD$M5&~|+}j0@l_1Bv=KO2GU7Urb&#KMqaoHMs&tJ@r]9mD!&[W3Vc%cdoM@kz(umUC(}S13z_','iYwO%)7v:z]|lA2[Fj5q4*oauhj)#=V_R%;93b:MaG\096','!OFByd#N-_x!}#8p!Ql1WGDW:$#(o','8vql=cjQE4MNy_fjOBsh\096*G27jd%G!Cs3o~xs@#7)_Zm4C}8w=1c\123R8k3','EZWM~f]RvOi=d\123R4%:*G)hCvMn1C57u8+dM_WawjBf:ac|zK0)is%O<q&17-[0v\123rJE]y2*hcEdn=s2hi$a*','L6f7=6o5D@q22Vlbn;]n<JLzyjiEon]-&bfq9J&T+aHG=.5O@rGH}1Y/r46f8Uqq','Vr%.FK&@TS84F-~TgFcACvNncAF%ZCL]Y*12Q71@Bbg05G-*]<Dn.@(/x!uW.\123',':&giLGwCUz\1238jj46Z8-5r<Y}n','k\096nyzcB-R1kZ~e|aV3v>4x$1m2ps]V<ehjshBp2p;_~OwJ+~K%J&t!G5z_dt~VDxvR+D\096Y8zVTcn=M8tp)EU4N','E85(~pjdJLD.Gls(iiUvmCx;4FL/b!d%([hRWE6han.ti6yF0&%d&A>','~zFl7$wBk\123Td@xE;gOvo=z:/A7T9E<0Oal|hcNfezb0>NJ(f5TQ~n&9n>9oS5CV\123RWJ;QzmpB[JV$5=wJ','}b8rmaSh]2&o%chK.5]LD&5~H*H$bm1Kit(aF*AJV=oTy6i=!x+8.y6oVsC>4]kuSV3|:G89','w@Bu]p%D$HL&6U|sh+@$G@f$kU3)q6D)F*$e9JEyJ<px\0964w<Z','[\096U(l~qwJ2ahWjBy/K~Y%:J0z1~nsksVRW6Zr<>Jz6G!<r2H80NOhcOkl\096G/o|%amsZy/<.4#4B6f=8)MeTpni.','$btSC(WwJ8G1]EaG&$m7Dpdq})!czy<W\123_-t;(3VQS[vA*xLjT(h0MF-[>D\0962C3Esg(QqfKN2_s<','}j(~GHEqpV)j~%3C;__j/:e#o()rZkGBfDbH@&sv=@3z\096gVqUlU12','q<gch:fx%6hG$Gn86mJ~\123.*Dp%s;sS&*0j9pm8Na}N','h3n5H#Q4p-\0964@k}~>vwx07>xVC</xG\123ZDd75n5elzEiM~l\123)C>0)Y~:','Uu$WLH*j1Dzckd)pu<v0bzc&DS_x*$hkj43GT5G757}Fr]+Ux%','G]m@JQQa/F7]yH9@#b|<vE.8d)M\096*;jcj!t.2v%FV','#K$=B2*N6[(REQC.sB#O5yv}[bzhtw%F~sS}F7>~-;n/i0b\123OF)H8OUyl3\096)soSV:','hRrj-vxv4=1yAT}1@xNJ=Ah!uGAn%:anyKEC$#GFV@WSisy0JDF(|h','o_T9iw151C*@[BYuW[(<KvJ;1vx1rNt0H]oNZ4S#eBDt#wL\0961~6e;7\123~3','Cj8gm-;-g0~A@y)GRZ\096N4.<lV\096(!\096V','c.VgkwQoq_h.HfL96A($apJ~.K7w|/!Zw\096Zo@e75&DM[7ugK\096s0s~eA/G$Te4Tdlt20Oo\123M\123emg*2!-nQr#;U7Wx(','l~iAQd!B;C4$6VEabfpq%2G9!3*-_pYw\1230Z~[S2g]ZA}ns','x#s5k|J\123$VJFFT4](kO}xLioqu!SNwuxKRoD=2.\096y|3~Wr\0962v3*ag;(ApQC!2U\123>','AD[[4h=g4A1);:pldAfs\096FdZ|mrE9A3-QM&NDK5ECyj\1238y9]JUM!CTfdWCq<(s)_cb','8iO.Sm<Gboj<sFH-.Co9\096&aTuf#e&Sb9:qRdx:G4','~!|5_fvV>x;D>pEHqdH1#@(Lp/G791}cCC5:q):O\096AiyLh=G\123N2Ug)_jx0]%n]h','.H~GOHV[\096xS=WVMC\123=)diJ&NYxZQ%U:o72es5LieJD','jFW(<o8TEi5x(t6<%rZg0pGyS2l\123ZU%3%Ra]rnaQL;J7vgEhgbt\096Kcs(ZZ[WkW7:q@Y[Z;5(6#EV)W9wE:qoTv>E;6MZ([NR','-foN=J$0L/)>/_#Gb!Reqh&!n)C&','ibrbU_OG%gW-dCWWT~LK|k}F#LpbfE+J=~b1RWyzA\096','&F\096RL)L0DT]xw:pw](@chg}FEp<(hw(e|ET}Di;tea\123eG7O/_3|','<_D=WQgF;p[Gnlj[6m;+t|-sy3((pf}fes','5\096dr9lkLGo1wfH;%w;Fg!dH+OU%+Zd@6gRL!|e-@-MlpZ1ghyWnW1UR9-t:tx_4aFr14[$y&F787O(6_j7]\096f\123A.Cc}>W.\123|','s<g;3!kh6A9i[])W%i[59E_e/kZ#3YTMBuh[fn>w:&]5-1\123cZ;L<qmL\1233Q-SRZLk*zA)#1!lr|','tq+pq.\096_JZpxONn~#7|a%Gtt2TdU9$t\096|TS_Udf#:Z2zNB>w:urG<9e9:x&D/8uojxJ+Ue','j#N-Z@!W\0969Q@itT\096|axi5Wd&0&&EMtv=\123m6A]l5c=','fsFh%:qktxoRr3EjlWWjYOE4|OV]-j<17;@:2[W0o]Y60tul-C(\096]8Ai#gc1E0rw_:$-','uvWV_:s(zEBt/!g7zujbAtfCd@6n7TZBfm>T|%gwGn;2|Re\123yelthC7S-%a6NC!ZG','R9tR*%Cy9gcTvEo8~;Mbo/:2r58AK_8$b\096ZMYJ]Mp[','3aG.\096)@FWw#x\123rA;-Y/[sa7be+o\123qkiDnR6kq4oc]Hieg0+i\1232JW~AR*xNsTBaC$+oD3d>gF1','g(*ONKK_Mwvt;~uS~1JH>\096c(Vgf$&u7:W2s_6Q-9wmlZlHs7%Z~hkbkO/!=++AA3:K\096s=U4=ryd','##*g4N!dVJNqF.SCpmA\123hH}oE}v(|n5u)','=]wDDp;4E)gu;VmnFtkqSh$#Loc\096MG)j+dE@<tzVGprB$0OCd[(S.G','dwj\096hQQ.>Mu59W)beCHJhu4>i@w@.SOc%a=Jy<zHn\096d}gOW*kBO+gb$%sBCY#','L+sN|xYd5-0y=}8Dtcd5y(r7_3b6M|0S<qWCctx;Rd/n\123;T.CkW6Wu09k*Q\0963W>4zy02Z16EO9VD7(V','2z>9G1#g2k:\1230BTu]/CdKdRu6:Hm;p\096\123Nw\096EZ}O6Olxw|K-+N>%DMONCsc@hL+R>@rw\123l\096_mvYf>Q>];','M6k_})eem1&btbCF~>\123h>|A]7uZ5uFo.o~}(Fq3/','9=|%dajM\123TMaBKAb=zf4DR\123GC;)S!l3@86:0vKGLYt_%$>(5fiL2by0\096K:\123Bpe','lrBr)!}}Q|o35Ra8-q98QVJ_L+\1230Ou+wOYop\096(lUk_M~iiaM;_=*y5tTnwG','1K&Th=kKFBWmw$$\123L$>6$i%Uq>R/n!+DGNfj$H\123c}]g2JvTdpmJ3(z*D\096t9pMg1>#/LG7cxxhRl&T*F}+%=x[Lq','H!\096A>TU.Sh)5YW<__ytQQ#2A@2D2F8>fzn&LrCUr_LxKM;s>Wui#','wUnhZ=TRF=]AkxRc=rnUM-]QsE!*#K.CQ!4G5[Skjf>h*5H04&mZ+Q~S@>JN:*d}iHaQL;s','$o(&}_\123gG~Q4eFdl<>T16N1h/Rb1Cfkdzr6(9Rqew@@m&&4','<#x>+.Y:ezN=j1FkMsSx[b\096bN3_#W&|dd8=5QKM>]M5Z]egzC17dc1K&#oEVthn_W|de22aafl=O5*1&sr}/qS0~dn.@|ndt',';~=TeAgp4GQRa~D=>Rq><2v9Ww[Vow6','_kHV[8/\096(g[5bQhg@qhfg+G]VW3@|9~yAk:~)\123Sc7&c-J2xQ=e)G#~B5N}L)B>*Wwli~G5>QwCA<0w1~V:Z-@CEK6t03q3b','=7LNq|y/z75M5J\123ZK3dJD7c$sk1.1KV$v+o||BH_g94>x2Oj(3K>*dO_sH0\096Mb$4/+yF_=wR[W3llj/:_DazSyW.L.1Q','b|mym!|)2+GD]!Egq!bC;>r5|6DL4AAmT~j','tY7~1H[.xeRtaFq@|!b&FuZ}<o\096(nEfL||#R~3i%g/%m3!R0b=$bKOe#Ll<;#]!v6\096MO#u\123q\096+cqloj*/[(','T~JLfqhUSOMA3KBzG}U8Oftlh8&>wlg*}~e#3*qc','wJ)A/r(qE<9uwNZ((W=(\096[NJR<8','wYjQq5dJ}cy+ubcl[CMdU&gS~KAo3SjEL\096iDrG:coT','hb@u}gzN#-5ye$HbH#+8n[tdJ','rJ&cyeeWiKUR6kS&kv-RR\123n-)CQT7zsij01dw:8d}a]QYtEy\096dkqRU8.gCq=Yx3dmb97a+4$nq*(]HEAU#(kg','nJ+R&EO\123vmF%=W+!l|T5Hus7ZpUqM*GjH3@NS1HC\096N;k:Mj[ZL5[jUc&H!t_$T>7G)n[dF_}]sBv|c\123d*j','LmCO&[7}+|Kx0Vj67%hk+GK:','%M[0:F>Vv-*Dys4D39+r&<C$RZQ&@U3]<b8%5fjp5JqL}ylH%Ze8wA#C$DuORRFqLv*VWZqz.+jO]x','Hzk8bkz#!:YtkfEh(VtK.5Bi~SZN6V8nhBC3&OnwQ<|Ujdn6EzWKy:x-Rb*0E8+5*#(62E:ss','vmMc4+@jDv<+;Jf}.]>r5)qj','0nFt$38@59+=\1231\123Q$p@Kk:EqmGn2qv[TGM4/w+dS7}O','}jlKpAo:if%0eVy3CA.b_zi27$]xC*FgnD%k7yd*Yx6T1\096aL#s|x0H~5_B>GzT|Z!f9','-N|CA:BBih$/U[a/:M7%2b.$<AB[cfNNY1yq1_sk*jMhH&i|/W8}$Bnr!1LS#\096E','AuQO)J7HS;0!nz3HdBNsT<dvTfToS%QQ-a4uK.%O3[zZL92Ge(FDDFj*EG[QH;H:;u0~7}9Y\096@','j%bC]k3imO/=kvmi7&$fSjzBp(ERibC9d@97xme26xqNzW8zw*LC>TqZ/xWE;q[<OA','aZs-]b]L\096_(n;Uj92$MWy.DtoyGST:L\096v$OT~()Rh(N%:80>!uU*wV:[k.to*dlB8GR\096H[8','|!2s(!wjJvA7@C]\096wSyvpp;83hS>%d3tKhr[l%','v8K\096=;9y<:h<yd:T1@=c4~\096q=r:r))mw>EUNqZh=>nM2>n','uhFHCn)E|)xm51h@+&V1Dwfq>9K;E00h\096m<TT)HKd*T2w9ytLU#fGmW(\123_)','-e&il7QOnlj/ga\096ya5ij#i/r0}$HQL1RhT!~C+!vx2v;N3%f','kqZ9$)1sG*8G0~Dq1J/&n\096:$','Q%RvslvA}GlTO<UL>LqYL1;~o6:nd1on','cwVL\096tB2OW#kVi8>hNt4+y=YE<KqRbu#T)nQ_FlGmC(1UeFS%)usr\096Z;5hRZ/68\123lq1pUck_Dz7vw6D<M&MbHj(6|ZLw4\123|','N!:0e9ux>|)}QH|7Lj):+Js51c8yH\123s[~+E+!86_d','s>$041w[w]s9;+7CU#1]%ih<xj/;','RBA_-x64pLe5j8c=y)kxy_c2b5A','7!OZ$703\123gKdVa#.VJjv3k[b[FMRKy1tr\096_$w}e%','EOG9[Tx4O2:6|~\1230EMo1g/J(F%hDiT+G4','aq+2l3R092J9g:jc1BC5#pLSC$CgL.\1239LVkS2SdvrU:84B9g]Y>z-eJ[2A:',';j$#zft-ATEf-**r(l%p<k%tmYsDTz8R}sR!FK*Oki3S-2t9hR','V(slHtv]%K7g_wpGu@.iQMuZ)665/e9(:Gr&:lhYlC6#9NqF\1237W2GYEvU$CCQ<F&;cGZ!ZMg<0zeu$',':NB1cg!J.:[6v2dhi3\096~374&\096v~l$*uit:)R','Z\096Y.:*(Y[mmtd]tHwSwi$7[y','@\123LJG\096/&[Bj+ksj#.mE3F[g0i0=~/oVMqwKxU)p.ZL!@3iG3fNx2p$b(','HfOh(oC(||@!Hs4WbSm>l&%WQ_S<xp2<[_ddOd~e7NM5Ejtno;G@+Ln3a@o#WVUvc8FzVnu;fM|)F2=tM','FWUQ\096R%}<z~k-50dz~.ch][Z]E10:$ylV1DHe*Ec<8=/~','\123xs@\123KZ02dG4}G28e(+UJdO:Q+wAd<]:-as$3p=<n27sQFaDc8dfu2Frjj\123d&@ds6bo<B@Wi|)B|St4Wk:','Tt1MGeh*+*V_gG*4T2Q/j}YLy3ULa*N]','L<#71)/Z|Br8cl/jdMFk\096@.(Qd2yhR7+cKy;\096mEjrUw9:AHLS*fb!>_hzFJei@2w#(tc@m-%$SOF-sMor_M6J','fAbNj./.QC).dGsw<dB\096Col_!O!UV:J5D+u=Ku1-=5jwER=HS7m24\096%.ti~6U|c;1-1;_4s&z\123zNO%J63Cb-fe','fY$J@H8:=$;GjQBix-(~!STN<NLWh\123H\123*zy*_urat6C9218_eeR/=Wen78)M0z|]w~i|\096u1m','EBn!f1}.inMDALAS3o\123ORkeR25Q','>|WEN+V<2@9hjH.xsr~T~yg>Dl.','93#qxMTBN\0963(YOnvor&y=N_npb0}&tr+1;V3.m#3|!(oqqTk&mGLVW@VyG5G','S_@=-JS>}btDl|@nzxbujE1~[k_e5cRL1#+t2Am)\123!C5l0lp>-Z/gaZ587)MG<.0$CE9yC=axGziM)8m%oTN2Wvk','W/m\096$1pRUh/c\123n!At7Bt)qKtJ\123~%8KuqloLWhrl',':\0962fO@~auVfqk9VZ#}\096gYl_Wl*=S>8~%c*yv6j0JpC+\096nd}l4toT~p+pSs$KS1+U!~D%Z1%*KpB:NF.x22K>]UxKD;jy(/o','h|s@C1e@amU:~F7B}h8N&s+O9[JK/Z}qofVhJq!n7z','q#Ut_v~UEu@2E-N3ZyWtk)F48B~!~Mq#+[i}+xV\096T93uLNi>4Z-OD[nL0Oi9=:TKGy76&ChrxQD&7GnV7=b}*NFQ5\123','d5<R.SgU>+Co|ns\123$W.bS7mqkK#\096*D~MzM%b9l\096;<72zL9Z0\096zJtgk','+m$iUSGGocC+U(onHrqWAOR.Z(+eBEeF5fqd>8E$o/SoNsUQmU\096r0W*~E0=Um3&fkBq$)%76','h;Qp$dWZtoB@nJ(h}@[N&x+:2$VwcH}Rao;%htOmJa0T.-F<S=F@k/s;|\0968','ckZ_]A7a]aBx0>\123Tp3\123l8HTk~}j4vF','3tFw!;ZvJJuUa/dz586A:LOvha}','4edjy]|HtFvx%;=%0-K(*=4./&#+YH]wB=sprvm>p[lE9Jd/&&]ligThD$kU]lgyW0BzBL&j1;DLua].v4<M','K.&O6ES5MyFa\096}UiB1$[)0;FpGQ60ei8i]Uu#L*c9=}ZWOa','0t=xb~[*11KV:\123=*$W.m):m@!CK%fdbY.Ec1B$SWadp[-Fm[(e*]lTFf55]14*#l5z/v*O5$A-nLUBf#D0@_','2D%~BL#fNA|AhE+J@\123zZpdvChx+!#ziJOzRR/[hv\096c','J}hU90ql8\1230]Y.Md]YvazOA<B0W;T[u~)6V/k4tp%ErnLFDFTz-@\123i','_<}U.+</R<v3&9/)2D;pUD6(Gjj@y!:12|DTb!c@K1*B%):u~!j','Ln)GSZf$0y@Q+q==J:|tb&wp%B>&.z6A(GTE0=Hzse&6J(~haUp]=6YVVq=Jj1KzWBj7(~Q;vj','ikr:B|9&=-pR@i/S+#SZyE;M\123[5@7L.vTz1g}vg-(d$2f|.Hn@C}dTi.:.;jZzZ4S[6DM-b9f(\096eipDHDzu#UecC\096Mwu','m\0966Uit>tQ6xB#Hc>Jq&_jf>/D(<@We\123+L5>:e((5\123@v*','~$(ZC\096y\123+\096%fS5d(tmn1NysRoUMx[+w6CT<','g~N=Jv&lL~&oE6=#dvT.\123tYQ.*gY_+.9)Vh8r*nzmV','cbd\096%D~Qd+jv2<Kh|\096q\123]b2h0gyyqDcJe(/nDLL5:).d#qWai','uv[5-yn0p7%2xj>9G|lSz\096Qs+.N<TUos>*ad[F-&\096&=q|*$C>Wbdqz\096','hjbl&ET2iH70j#Z7zAg.NsOR&sCq0S(4<y#]ZQOZN*Qf/\096YSQ.-VCj_ns>l3Bl}}0::J]10A]vZv#s}p&}v6U1%i#C*|g[Ga','C\096zn%Hi6dcO%/np\096o0_WQ_QwdSpV9F1pl.$d&oz_2seaKl|Zjmn[gYz.mRSkxZy858p-#d9m#CwryYh','j%)EK<Anzio3hsKofTk19o:V])5(C@!~/n|$>Q]5U70\123ef;S\123(!)','_>ZSdU\123@i>2JrhqVA[pbhcdCY5UF44!JgUob>2t\096-@gW*n3|5-#>0:\096','ms:8(_ClFrq3mdnd$h88S1Z/yJUB}O*Ux[$mKQ','bfQj;yK#[x6E5Rd34>G#Zz~\123Me','J|#YoV7ZB9u-]b1-gu;Vmt$<l\123lK(}..x@N3)&Sh.bO2]@y_:zV(4+tHW9mAoSaCK2nZ)D}oGAl\123ejcs','|Mv;ns(\1232N7FRGZFt8jd\123j;2q#!bW(S&w[l_','mg>$N50&qM/)zV(hB\123*pj0db9t4M!+3x*EAhSFl899kD','jdjjUW;df1ea#W*%\096_s=SxY]ZS/CHtb$EMaO(Y#hGFLi+cf>[9\096\123*py}5w|ReF#:-','dvl_(.Bt45fvct+M..igsfJul-s/4rGC0i0Gl*uOkk]$J.U91>/UU(V5A\123@2fliBq#81;L$!','}}Jjz1pLJ+dk6fa-.xksfMcNDNhnRGNko2HKrCv!;r_vD','ngQ4$7(b%qwH$VO)@4\096t_vk7}QV','hSqfm7@;B!\123Be(<36@1}cQ7&<.ca8-He}bU\1234Jed)}WoqKY!o','H\123E>2Bx_V@Han*#aCOu9fQ%vFBhhF!om1\096_~o~A3Ll|.%dRuym]nkM0clC/T*_mGgKtdHS/=.s);pgZQRl<c2-.*m~Bb',';Ka2N*(9kz;7#zs!Jl&1=:wq9BH%*]swS4&eC_88l\096MsN0ZN\096E#FCE%L)y3Yx0BNb[','Ng@~x0@.Tn)NviF96to_9-=O)h8)nu9Vdy%fkt+nkTF\123OA=2p@v$7q(nUg[AU\096/s<8}j4','cb6og($$Wt6KKs7rQefWavad3]KN~63}71wExo#qgzwED!fV)EuA:uit~zA&uvyw!*C(h.Nkq9A+!M','&j.Z4_Ncdtbdy\1235~2u+08fjG(rYf_|&9*lyVigH\123aOoB5SVeH4L(b=6Z4fz6yvOyKlN+bunfgm4','27yZ3d\123@Nd3u7#sb;0;aYdTAe.#g[sjtz_-=ulTr>D7~1AS0\096Oh$jbsV_G4#56xj2-cJ*=$69[aA@9T|;1T','G*5*M=)HRHzQ9N~\1238vb4Oe=GmWle}qu6','Q~>_fz#Kw&D.1hW]NZ\123.ACyd91Qqiq:uSVC]Q&vjvJT$f_<9>-62Nfm!6*o;9}g#*b&<zlp','&VUz8xWGUuA}1_jay2]Lb37#~QMKQ\123','L##!k5fnZ4d@-~}kgGuY-(b~vs4G','FEZf!q2*t7#;39d7AR*[j:.*hSWpQ21Fi.@rHwNF:Y@WWO1Fv.n(}eJjGSjZ~A2c','#Od5i|v#mgxl]wBQ+;dWyHl2','=6LxsR3)fOw9+E}:#FTE5tMGJ9qAc$V%CRx:<!aQx7la>HNT*q>mowp7!}+wn/D#4O2','+zAE3:\096)%4zA}(T&ecuC>FMct(n:DJY6MLNQ[cyqSrS.>fV]#Af/%ZMrAqvdhBO]4<Z$CU','qvG&u-RdlWA[YtDVYaF5_N_FZ@WJ.sBd5U2u=\096kDr3-Mb&Q','s~>H-zCV04uM\123i@[q$/%y<xj[U4@+Qy}2&7O:6f4}8:R:B6fhT','Q)qNAs.1Urukp98[u:2u=M!(U6e(f}<Rh0W!uG19-J[&w','>(M2+l[)BTx>>f0!OC!w>$~0dxT','h5kK2DE\123QxlmbO-As3CdAn/y+4c;8hL_]h=;2L#!|+xAp~6buQLT_n)iH32j5e#j5DuT(CO',')7F1CBnc4:/z$$\096R:pUlt;<\12359$$NG\123lmsF6wHmGo>vT>CyR(AHb[','GA+9t_g}T94O:_cR@w)]|ppV28dGo6aB=4:jLR1<D;p6u>4]1[1VvZ8x=yhQj[tH:xKllN#$]-2q\123(8lm<0l.Md-l<VA)','0gaJ#sYLEc&/G);}|D6j%V:#3d&T2v3DZeWyG$_DLr=oG\096b0g','YeiKjp;OE&-Y@$qrF14-c%Q1mrff]sx@;j*1|VN/Jl]g}L*5DhF1eT(JQ_F[M&>/u*i:s}[@NgCh[qhf','zNEkM=pt~vvGj$}|@54l.Sprso>z;.n>c>+[','}b%_MaSx+NfSU\096(6EhDn<!tG~MLBAQW#)%~u98J#}\096J9Aq','Fs*R~Jvd]#\096*xj<Jie&4ZFzZGO%/*0R\096e@:%&x$2=k&K/ob8Km0|x!E3#>>Wb)\123qcVul$u@9J@Sjipie@DDg<W%q','W)O;&ip9Z$a}V(o*y9Gws;=hNiAK*/mck#kq-]d|L|9j]4Wtdp\123-k$L+TGh$pp42AleH:5v6G7s@pqW&4J','3ojM\123qG\096O~44upgN5k|)37=Jt<8-:@DQMm9l\096dTGC@Sfq%\096728p','71zUKkb$K4g>BRL9sVbnQ=<[1YLy6c-\096Bi3i$S/Z~Ts/sT3UCnH$x9=ku(AMvCj0pm)Lg-*F<\123]C(.goc5','/#bz%BsM~So)%w050nZg[VYZ.@aD]8:g\123b)3+SmfbMw|5Zq:LK)t8kAz7|;7;b_.s','ngbs)jxo%A/]fNi%.Q&RK)rkgUu6/mdywMn&of','0pF>z|&6sQW<$aV+Su54*=;TBTOCYhO-.!l_&cU1u[h!&d=09aB(-@hN;3%;6;V\096GMVkc0OWR*$QZ7ga>BQ*EHE%dOU_.','rDfgz;:n>4>)z7=j;0OM<LCBFl$Gu(Gkl_Z:bCm!r&owN$3~][xQ9+\123Y+Z+1U|+ct;rWeCace2|@nR8g/nQBh9Sqb(\1236','}J>ej!/fYZv(u<;LFbDV9N)KarVek!;e@>_0%Jy;ch!Z9%Dx.\123*a#rTg=eqWal0|0U=Bc/B;dZ1>f~/9DLq7}%qkUgyO/@he','2OR@Q-[$Ymi|RUx-Qrb9bT-}$=4M3+}4%wTn!#a-).rU>(za9wlj\123+O%tmrii=>1nEJE','B35vRBkt.:Z(f+7Y+MG4W}v)yhLNiOkLUb|H!sgiV*','j\123u7F5#8u\096=+6O$xJa>vJW>.1NtfKO$\123kkTy]YUH4jV5$<0z','eu$[7y&/p](.\123MeUh]tx#}@+=+KG6dcm~$d>rpQV&z$t:Y5UvTBj&)W!f','L;$0#]#FkjH.6g;FBU4GDH>|y3','Gp+;|2M|l|Jp$os+K:JGnEy/;*pHkZn[FT0\123DKb_\123ECF!Zq','65D!(<(i]#;Gg4f1<n/Ujt8W*Tb#GUSUQtn(cSZ-K|dN9+~8p6O','y;Gnk&\096dC)=0x+Epgb$.A0B*:Nk]lzO7&i(.uT9d<*f=7]','*dnEyaE!#tZskG#<ky9y=\096)s4}3||~j:E[!WUb9)2!cp(bi!*c|+/V(SFCDS8bm3g+1rw(|<DmJ_5k-)bkx|Dw*r/=4L[<G','_<$\123xbH+(H[@+wi#j1h&jFDu+R>]3RU:#p#MJ1t#T(#Av=.cvptz+Kl!azpl[eg\096L4ri%@hri(B6SK_aB=R8#S0fBh%w49','z!@N[fw#(tc@uu\096Yn-mb#x:h!26!hB*Z2W=S','Nvqt2G89;_VU|>M-Sj!usb|.>+u=dd/R[]5U|[Zn!7V+<s4Z.}Tb6y8\096Y0[C;}\096b%S50thp','VO_7[eLuYH;rp!o;v/3.R)xuuf+ww_[#0y','*[7\123eD5Gb/x\096Aioez\123]Zd}%W8','}<w#hC.)(V}WCK0OquxK.vYcvA9d2$|p=.EO!y-+_d(alf\096n!!oHLn7\096@noG','v>Ju.ju0K@t@J}3RJ|*\123@UBAjpt%6Ep0Jb$-.R9Z1i9aq\123[te+->}+;Eg&GK','T+%-#urLOHf6QO6f!2A[DW&GwDHVx}xL%6\123+&>[.j_G#[@A','oMq[S\123!9=.JC73$;pA_kcAfttm//R+Lj','D@jJ<5o.&TVS+g}g<;UCY})]koBk}v1FV3>7]=ei##Rgdk@OJg;y[+','!QC1Kf;36md)$E3EDx0R)g\1239aLo','y}%:xVT=gs}GRg}VDB*t\123\123)s#aE-}ceT\1236','wimr+w#KLT9HKB79+)Y.m_/KMUcG*L]>E','<}6D:Fyp8RYx;4nxB=&ie*2$zSy1U)]K/;>Lg]BC7xLG]o(&657\096','lU#g*qi50xJ_#Ei6M&3DtQ&yf6$03QmxC-','OVs|r[Vto>/8~2T:S-[)]jSJzoj3Q@%!>4Q*Cx!W)uUTC-&*]HW\123l<><3wdzsss<_efa;5r','ZJYo3KOmOWEngcu78vZ%m92M_t1AlrV\096z5|cs&&','&T1J+SlpM|B\123($*ag:o2Brs1d&#\096Klg>LUUge9~HWlDx#F+E=%Z;Z9mFbW82K\096:Ha/2WN+]Ldq6kb','C;VUjJ6[d3#fR32z0#meqi@T%].gem-8xJp=R5T','C!51@@Z(Ve6HaG+dsNHVL:3Kljz\123S]:tO(2i=Fn:Tf_0-.h];rdR&nwMUU(Q','r6nFADVF)6UBgY\123/5EFbHZMgQT4lg!My7#lEJFfijCQ+[clt;JBebRb]x@','oJ;6d*hLB.wBba73sh7}3Mq7BOv%2/7WVt$=;cOVn(q2bA!Y$|Mm>vW}z','N4WrNnxMOyL(@83AC)$/saT2T~9H6uT.M','5;01#)Z}j4qtoTyys+*w)<fAwkA=o9DZZaZ[ARM-()vB*cGN-0J','R:zKWbxGO#S~@4f(0eZpl&\12328O:>4fo=-[c-RG%jyZQCO|vz$e@in;R:l+\123t3seka9','E9Vqid*Ffyu/AL8HKq&v(4=T_EE!.0us\096<3r(>Zo9%0e6\096','05H3ff.V4iL|5%x|oiu:eGawCQjdWi6RjfnF0$L_MVV7jK5fj@KA/)6&c-JKxs&)9dC$JY[s0U/A)bxK*WN#RZKk','$rsT[r1WE9S#}qq6@ml-.u@8jTnqTeTB;T)Uhn\123$kqRnuVC2G|a','A+<$4c3q)j|h3L5T\096!>\096;jA)%t_LU<@7e+K]u9Re84EidG','Z4>On0SU%;Nf&nv-FK\096A5Cl$a0V<H%VrL\123kSJs-_L(eKEFR*g',')R\096fwhZLDql7]+(UJ#U<(BZ/CGp\123p3!KbBY-jEJff7vl}/Dfg4GW/..','}hLEr0V0u}oj+k\123SCTzT.h6<.th\096nQH<ep>536mfW#\123_r9mKT4\096~E-3[GcNY7u9-@WOr)Z_Q%1slz6\123l&:O:%d-sE}[','eFWpyUi]h\096bh%sAw<&-xN/-YV3s3eU@','k&64=%xJuZ@eaNH|0h):AaKBaFoh2\096K','vS[C:e]x;UEd7iQ$uT*}vDpjB&&&e7B3TFB0$LqG]Ciofv&gyDfuyj~QjFjht%(','mr.8~W>+iVN+5cpoxb4u(ugZUs8t;aTrhgyQQ8bs}E|e','.%#V&w|_B_-<hEDHxmrN0E])z<gO/)Z8QRt[27hlFBJ5ZWuz_8sgE<x;l','5_$(N/F*2;1mW]|MNT*lK0~)|})5[W\123;+:&KJh.3c7!>))WtT\096lgSihRFl!Qo}Mtv~sph','5x(b;:n|0NesR:repq31JJ\096xtDwW5EhuT/@iKgCAL*(iY_-(@CO+9daT','bYQO]]x<8VU6W=_nvzS;Dr$NF]4vtNHF#)yy;07+Hj4e*]g_r#-','=aYyO}gjpA\12315Ma;Yv_C=JT]0LV14._l$-0Yz9VHO-Zy(e%EMK4_jBCxKuKi<HD','t]g|\0969<fbnV)QV6D++<V4R8+Gx+YETFfkmW\123(myQvwlHb9R]V@/yb#jiT(','83VVWf4=R@~]\0965|D|tN]&yHQ!CzsN--eZ2~L!:!sbU&>#WJQ80D[','nE*@!RS@mM.h-g}\096]WVs.v+qnFZt)>',']=-9Hzv%AH36#@yK_kV&\123f;@%>sxeFp:++]dzlwL>cJS|[1B+>',')sD~u!kecqd[!>ioZ9FhtaK&','|~]QRx#kQz;UnmZ4@%k+#[QU4)Kb&Mn<|W7-/!j_NF<E5uF8z7v%_@B\096M4c(O74~86m','MSUWNGU(4aQcJKocNFLR:+E4D~Jck0-#32KhH0kb*6hV;_-U\096K[->m8]vY/RF2-Ltw#-hwtR}%n@0k0MnJ-xx=jxUJSv7','H!2D.DiSDe9e7Q+H\096[[V01K&T|DK+ar=pARu<0ze_$i%*:<',')ULuoWmh}<plw3/$qCzf*O*jCz@e:qAl3k.dl%EtlWE[@)iy:_[Qy*BD7)AiH|yE-@7FmSh)JKy#U24W','<DvC!v*ECLbG&u&zW|L)1K..','g5GT0;ix~cO%T9i<Nyb/t#0Lb\096CuUu\123x-Uh!i4CWm@>gskS>!;|&q4\1236M;<iTJ)pRMToUu/4/:]=y2//jVG','Gpj(6_7JdyGkl<>)[t_s%>Gvjrz>.5z@','K-+|7cm0FL]-*l.|_Bz<M.zvgUo.tiv8OlKNw*N\096apMBmjz9vo<w-Gv}h<6cMSl/;[=GqOff0QYVETw6[jv->21@bi.','>d*cdKl!b~/qtq\12393kMcb]H1_)W\123@6+FoxNL','4/BJpBtT*81kxE7nRB\123Tc:gVAK!*x(=dgwvE_E3@|/x-iDp\123FsHG=&c-J','\096xQ=gx_cZG}sy6Mn>*Ww>7;$','wF=Q\123C8qLOzR6@Lry|wNyUj.U0V#sMBOy/z7>wu\123dFsB++u7c$sgMyz',']d:EJrZsB**>T:+Ua*c>j3z-_T.yA(Y-h>|Y=@MoOWZVuGL3y%(T7gVJcoKj\123-y3.HU2','j>T2U@N0vZx.c%1Ucz.lY=<3C*$Q\096hSt8*DH;1=Z~b;|E_<-NaZWn/-E/%VD+OH\0963t6j9B]K(UbZTk7zx(@amwm~[JkADA#m','|N4h9#.A/=0\09641(\096kg!\096s9TgFqJZK;w&)ai}D3S\123ihZn!r>h.JDei9cm2kh9@9RhTy*5)(gDnR',':E>3xBWZ.bV5vkKm@>y$sfl7|i&w3cqdKUoNFWG.Ns6Oz!-',';+-Hsu|c>|bu<qn+~_SE:)sK0ksp=Y#57sZh;-+FhJi0);r5E[2t2T2qv-t=#Lhx_N0!#EOCG-SH[z=4aFyn>xmV','~Jw;WQE&ZcvNau7&1Ri\123%@V@W[j','|;-dG}Md<2YB(/-][6OMFaD-uY5CRt=/','GctQ2z!~oREU;z79F%Rk>H!_ttx;;YHAKHpv~Way<3~DY[<tM|HoYV0cZ$>we>}rl\123LRAC%rnp&QTaqgsWKJNxF3hTT7!','|N|.CMr;N]}i6at$7Fo:igLz1)S.\123Vgl8<(Cp3$D=ASwL>#DL@&sN\096t2Q_2[f|&yp4q@|W2j*>','g}7fAA[6G9n1WB9D\096FUTEv;0.git=!-rW/E_DyDh:Fi*#HJZ&8vd-nl7e','gj}d_w3ey:w.\123!xvmD::iL;MET3s#8nNNOu*NA#cu:1-3*63#nGlGA[yV0pn','dRzOA.Z%w5|aEe+f\123T_6dEQ=lbj@sn\1239kWi|>=6e3g}\123A','pljgAGEmYCOgW.udz4/C)J:dQ+h*uC$t2)@y=+\096O1bFNc(T6oM(SjcqjN#3zl_dLN3eS0|\123%ud0Zyll2hyf]4-2cEQxZ','JMlpch2SHK\123T17EO=z/Oq:Ax','0b)]_UwFY:};(V6\123hYke*n/Cs4voi/0[Us:[QH;Nt=jBWb=~SO4_Qi;cRf#S7\123lpJu\123|gUMCsEjBJRT1[9NJ}s}Ec1','kSA4du>#asn8Kbl6]Zv##*<5H]@GxBCczdBM}!MDAU0eivVoGA}ys$m/N8jz$uk4@V3%EtNkM[W<YbqD_&9V$R\123','lFHs0Hlw~l6N.-ELfjHZLHTC!Q.UW*6g#%Qe_@HL5)F\096GksU2Atx1F<;','e8a@Y6rfRy0:%!lRsF]#UWOeqv]cu:Kb<!','L5d~EgOReh\096p-m:ZN~u@N;+m()WxT=Tw50v_qo1V\096NOij;nb!','D0fyK@C2mv]jQ<pa&%VD1o6NCO)$1:@RE/GTZ4e:gKcKWFm@%&\123aYx-z<DLVUf=iq#@6>','<2/0aO%N~Yth+_oH3zZ.|*Z7Yo#%#!Cg!~2Myd*Ax~4C)(ZgW\1237m','VGY66:}E2z3|w>*WaQx1)w$D>Y$vu#T<&\096(k','M<&fB:C>w>M&u%(1@K9@7$3yM3Lq1pZ_3K6qrmUi<$\096=xzQ/(n','$Wup5q2n.}yrBuUMFURFr|~35-\096z%9~z.gs','Sy=OCBM~Uo2qJH=t+fm[[OH|J\0966aUzD\096BB_8dvAkufmb[hdgO}Y;&.no*/|sb','RUYow9q8su8%3kT}EB37U=#uau}6Z}l\096l+dK:q~','z4fR\123puN(%5lV(|)qGcv.wq~=g)\0965)v6|2uJ!SpY5=FpposCB_K8*>o=e|1~raCx!\123Qcod/7aZa$8RSmcgiE:','aeSMxa)w!U6EZ2%#Y~]oBT\1237DN*g=3ZG%w[.gl+mdk3TB39h0.-qK*OYyx','~TBaL!CeZW.L.N%R#v$of+}lo8&A\123/_#\096~(GxlDNzo$EC]3)xoBO9W$1vTbCZqcv$\123kk[H','UW7Y(8.V;<0zeu$[7yVAMdxEe%Mm6]txpu:lQUzx}DZf;0}Saj!\096NQ9&:A.[/u(-UsH(B1h25h&yaTudHD\123qh:v|%Dl96','s+$RQ.477|aE_)_xS-0yZK4)-LAiZigb[0bOgwgG#B1:8D;.qfO6n:=~7~r<Q7F1uGOcZ>#goohxq7kB\123','8Cm:cG89;0M7>)}Q!WF3---@m\096K:kBOlq<a\123m5-@)<tMvy9Clm$]/~$}G2Dr3yKW>gkJ:T~z}1+\0969=0CDu.@&-i%]WNr','_+asH3ZVc@!s@M.1W&)ByJ&:DtrAJs#2','fNOq>67[TRv0pFr$TD_)qhaxEQEcLxsdiF|eK%%+RL*HwHaUMo]o8Zm2<ElDaT=tJ}.+(l_y%\096C~fv*ZH!H.fsQ','he6JW\096L[rD9a(:jE.Y\096z3xplq8iZZGcb)8Rh/EDJ<RutS=D@HL]Q)W9G2j','c4or;ujq9z|\123rzEGlr}D)D~MBi\123oTUFMR3HmZNxy0$68T6:ojF$1!uHY(i[Nr]&6N#zHfWb=Ut0Z','waus%e:\123NrhplcvjCZ(:oD2jf<Qo\096-6:Qv.yV_BEhlxyhJ:yRm&FV6<1qrNW};10]$iA}xGbBu@N]3Fg\0964xVVp','V3y-Qf/\096Es*$=i3f\123GM.W(}@SH>!&NBC#A~7*xHNmb>o}=<3xRGgoU>7frh80K;ymw$[rh)N@cWJ2\096#|0[D5zi[9k;4rCoL','6ur\123++Mk=Z@B:(3_r}28.4]l0K-%3sKq\123M]J8#~h#[~C<eKsY*5z8flx0Oz_%\123N@f','DaR(V!Qb><7L/k3qwZ1Fu5>=!c<|wp1%fVy/D}.(w+3ki}|klDB.~6%k[YWg\123E/%d-*;E','qU\096\123<unA/DEoz.lo#f\096Z1$}~|RQT7m+z2eBB!u|','-(0[1gOHv@}05x*B-]]M&(/nU8z/55wDilAl/2i*',':xlR\123TT0cEr2+ziFNKZrJS!|Gzl/!lKujs4w}r<A8..L[%:+<F','t4v!TV@t0.ACzL|@6p|6#$2t=4-\123E;zq#*j2@TBLz','*b8ub/@U~|F0RJLfyrgE6U<SAxV\096qCNUa','*K.5]LcTO$rBOi9+=faF&L8Fo9/*$+)Z)a|v\096%r9j-%4-aLwm/tHO4)&V[.!:',':GBcrLmO_>\123aCBif/muhq2s8CO<]<R:Td):Wb$*.Zeh9kZ=UE|','sV#Ou#W9-ibvC.Gdpp=cJf=2ollgkDFyLJ|3}ui<kQ','Dcr@0UY8NaMb7D*|t%#Le#=];9\123Z7t}Y;R!}~:eu1','/7SV;63OTmi78WDh@Sa0T.n9uo\123[\123j3w8]Zrj7Z_]zy+n}N(m]c$A&Q','Vrcc9;as=ay800Gr=S<zlVfcdvM*0/&0T6@LY*Sin%Blt8OO8','lx]Tm_Nx:xou\123)_KSWugxoAmtEzbUsVH7V@bz_cq2KtG=rdDU0OS#o|Ed+%Q(Kp-:cC|\123|Z41sA0R[q4he;','D%rq\096tRieCNZ9-6Y&xR&(}}yA#c<T;4iB7uWhD#kM&]Umms*AM}/R/+1=x!%k$sO.9tkU7B%BtN1yjtDb[Sc):US.vK/Z.$','v&/L[=Vwx]&aOJ~0tcG4%*_Qj#_Caj_|%lB=$xCl\0968','=m/poO|O5#x(h08.HUr5lSll2*l%o@q!2oi}}6o7cs>','f\096\096_EjFnf4GaxEFtMFwN}pH\096F4bsQ)$L/rN}*#.O5ZHUxco]0~AZ0Ml','YUgV-~8T3.V*O\1235Tl[Wp0fx6w\123B[8Bf>J<O-j!u-[N5kc','NV<F&d0lD<U5!w}$v13r<(@*vRFKkCD)/|%)7alBECqe:FFi&3;bp;C)np@|<O81w>}.7lvDm.ztHMQe.cvnM2F','#N1dl/5bF|A4itRWy|);h0[oE*e-$\096CA!dW14~:Vy2ACQ!ev:o&R3V|TQ%)_Lc|3A~4jaj_S',':Vsc->E&SD2mz5$SB&4T]znZSz@+A;4RuV\09691V\096','=.o<B0:laV<<4<razGd>B_6#A<9.U#MTC\123/bwE:#dBqRq4S#v/[\0968-mi>-2b&O:sjtJdF}Y@EUegnZf%z1T8}lqe5-U;HJN','lS14sSFGT\096Hn_A91\1232S+x\123al&m._xO$D~n0QJl[m9b','sJ9zw-#49lF%$01U7>=u}7uM=oU_RK<vf%Tkx(<B)y1|\123L6;-kF2iH}fg10[8UOok7p!)[eqG]oh]yz5}R','iOp~Qf/GFi!VtHmo5zUnn89M-vi8>&jZ9a','$M[mC.R/p\096-obq_~@V5YFM-vk>i_8kZ6cRrU_%%Uxm|j=b0kdrc@sy%80:b','H7G@xnfj)b@Oh+lmgv\096ug>mSmtT!8h[8i+25&Qwk!G','b5d<Z@zAlZFD[v)BMh742hE2;0q3$Aj$Do5Ea','cy2~[>BGMKmCvcdz1x8%(O#KtCt%<3DgF1g(*O','\096\096TwHBJ/(&jDRDJe&wMlJq<rq[+wL4#zY67_9ql6Mbxt;A\096S#hyS(uv\096rJ/):Bs&%8W[p5E!$#VZVu9lJkmq(sUzqN~b','Tq1hdlqn<j%%MeJYe+Vvz>Z%Q0=BZ-EFxcTu\096f<W0vF+74VOtpz3}BjF4LZq.K#<e_)sCx!!e<_','JsoGAlL#)WS/2kuji5Rc$BF12jM7yw@mZav@V*w)<01~T&iL3_;(G-9sG;','-=]Gvj<\096OG(]x5mzs*k3VryQ7&6LJ)i/ujdgAxF5\123/ES*<Y0kfeMGh3<1F=qbLLw9-:>oD600<My-W','L~Z4)=]}0=f8BlL|yK;}WJ@&Yd\123hrTOOj%5lafai}+(iq~','}Je>()NJ]>bZ~WQ_zuZj75oe7-YK>]AC1\096sxKj-gM7MC]!}}JV9.}c$<Qv#4qBV','\096>!+8ybv\123*msy\09624Vaz>=.CLCp[l\096(e-)}bt]','kd$wC(Nx7:&l>M>}!g4|g(dN_2nkxV2(eU4>BksbtMc=biQ0-jnqrEp-:j!6E:<2/b0ckNqfTyh@9Hj)B~fm<*rfy51K&q7','NWaLJb;gWB<0z0#Nz7(yy95/73e2f))WMKd6&HTJ6~>Ag<wi|~T$}%8UKu9NpQob\096z%!HBAaJaJW]QaGi%oMq0e09=pzG','w*ypdYr_eJwMBN9G*Loin1]T~kbS}-M21|8c#fSyq7*7\096z9C[L6uA\123q}u]=Aw_<wBgl','!.%pi2\123OJF\123J(1tLM~0LplB(O[l&$V}','GsafL)K(MLMjJ5z@;7}j(6u[Lm\123sH0]90.t_s:oZL9lEw2#SAn[ETO-~08t','y|}7[#$FlJ@gY0U+c3Y2q>$\096r+x\123mS&54-*eB_p}d<8K2=.![Vz)2CB/5}Vp&()srn)qgRKpF$WTiV/kc&o9.dS5r','NTU$1Lbs>goc:gxB|jDjx(ETw\096cTGG61pw&@RBNOO.AY1tx8:>FuEbCw4&[#lNKnyo-=ckbf|+Udd}WGep2~GS<Q%-tO;h','fU}G&Ow1|lj=a6M[|>qW$50w1~4fy[zfx4r;W<]ys5#s','MB~dQ67a$NUv/sB+=Msh~4Zl)D','E>$9UkANNTA>+51w5@4kDhLL/3g2mx3}-nf.Ql(SH2m]9b>lj/yAbj19[1n(}Zmfu!ku83m*7o4Q0a_5F.>\096Hgh}GVLyM','9}2:\1239U/EEd23w:NxJO\123doxKR\096;|:S#}\096G.cUtK.6(o[hN42zy&GnCsj>:=isps3&[1OhRh%','s2De#!wgv]pN.+DYSm_Y:f#<]4=d2qSu]QgLnp;v72!xB;3i/z_%e!','F9qON1(i8Qf3f&+6K5~)m]W<kbc@#kD/n0.2Z2jox6m~!','GO_JF&sS:)Rbs;n2iqFBi)1#My2&;Ea2Q]%3#9ZkuO!}sG~R=60d#@a%h3yBfe\096M-}5J/WR_xv:\123.3j#Ak%K>>9+Dqw]Q','k7q_F&vbi%i)A+#%]}[/aU%4$EZ4[f*','Y@u+6i.=880vN\096)djp&dY[\096Ey<r+)nb@_VVCb=5\123<W\096(_ES','1b&v@-vFr3V-fF2(B=:QgiG(d~f90GNTd@hM&R','>c_N:~xMmgq2F$(_*kfUOFk%4Jrtl',':Bzi@1%Yy=L4B<Tvi$x7>N!a<RZap\123sRBMJ@+tNG$te;a])LwMiRj!.7zBE@A<$Oe9eFV+\096+U[a%Vb**A7w*rB;=1w','J<sp8CJ+%=_]qfB<a:L6=HF\096c6wEGv(g8%\123Gd72Njk1v4e}C#Z-7@p+Dh]TZn}-w_','1Q$~KtQ;xUhN<TnCASRO}Y&+~Wo0B!A2(Ogah6J}x\123@JeFR=Ca[}>q|dTckWvbFFj]kjteTnL)~','\096$l5x$wW64cQ$K&S\123At)aV*=o$1*#\123MK@~YWoSxTKyOlb.o\096BFD$K&\096B>t=CK8&$Q|8B%','f&K1:%SvjzfS]mJVAy\096>94$ax*Z','|zQ=af+z.($9k<n=2HOf-ae\123%4ug|qN0T_]vhGUhl6}Jj9N32H/1!Ba/AbyiCB*V_bvOSDj','K7jxMv\123<l@2jhLBd(tLm>mh>bDOLH>Wz].~\123}$q:qa47dz@oNy|','xxUuy\096:7Ss(DQ!J%LQJkkxW$D1|G*2%(RN.yf~EW8/}]*[xS81','zsg-Dz(+1x;A;mQ/=y0bDDc;r1ps\123=B6qa4l/%L3)e)2=hpbE#U:%EB<tR4E7oehcp}~CzLqu|/V\096Fr@nC!f','6=ClZ>q_UL;F$$B\096L/tFY2f_$BwV>.o<OETf#v1B!MWmdudlp+;~3_vmx\096emT7]!Ap]l@@<_*97mooGgLTF-7','96DSm26AzdJNit}T/zS7fDH.JO90Vm1_BRlD+>/8xTjM2fqgU',')&4QKe|xFwQi\123H2B2i=C6G[HwRQb%\123b=i}v)fs4\123LkR','o).#17mAH0Wi4HG7y3*$o~-ncW\096mD5AzC=$Gcpg62l8_oGAe#/Zgd1Za2','@YKsU8=cjQ(D+f]NB}EMLN!OMlLKTA#nYmnuoQT9Wx0','Su(h@~\123r]fkm|[hQ-t_g#Q$H\096ydRT_<2@FD}J3ZK=<uFf|Ch-Whu54slwW~b4~','OdfUvKN81S%xbJ=OCB.~D9;z*.)=5mu62=H8C1*4G8Rf}','eg3Q|]Y8dy;gpaalM]5*gFQ}&<Ci2*&L;f)@&=K~emY1qq8ZY','/Q21sv)WZU.!72Uj=Lr=_O=90%Jy;*BE\096AZnVs!-\1232ZCmea\096d<t6jj[O]k$84$iZe|i!f+-','Uk=WfqfBYl=F(Jbq!Q4FScn<h;&bY/[!jon+L=<fxfLQwb0_k}js\096q#&s}zCe5[}B4VK93x<)}%gy1Z','i@G0nW6_5U6G&LkuD*;fZp-Ln}sAiq22+h=0*lZTp~@<Y3T3KG2Ns_ol\123r4/8Z6}j','e~00B\123<]!tB1mVOh)#BJT5H7Qe0orS$GV2\123=+sr/VG*e&]c.!kH[~ewZf)z9p~iB(VWfxE3','!dJjuu4vs*}KvDL6\123Hp/E(>enndNkF3@1cVy\123\096~(LW+d9','M&0=LMYy9]o(6V*[]145MNU:lZ@Ai-f(.HbfyzeG}zmA','HuozNekxw(Libg_eoE]H$DMHp+a(b<!yNljTdD#}dH69+/mk%ej]AM\096t~UQ\123<9KRy<OsfYVceJ','OF*9%0RlOmt\123KUR8oK\096|Rujt\123Q*J>\096e!Bw~/@n1/9_@o(*gzs)FMQAGsH#8WxOA@\096v\123E~mQmnURK=[','oxjumk|kuhF3HT#>v.tiOjO%l=nd=|Cdb=WS\123#p+k((#r7Og#\123m;b*3+ms(a',':O\096[FU):*at!#AyqyGo.eg.qu9bxZ9&9zvarpCo/Aei<E7x\123WC$','1r=*6/.qc\096n<qN!BOcOsrxsqyQAyL_7OFl#nQx}&8gtWojWwpZ[&;C(N2$]w','EUDZ/rfV.BZ)LL$mos>4bLh4Jmg6n\096KA7rGqN!\096muu_gZS)g/Q+17H>D]sLp(\096#;Do','9Z*4qKHypgZ~r6RQw#[7@EcAWdptSZ&:C3C:Q|dx_!SV[Q0ucLxB83+\096Qi\123USaJD','bN8jAc)lhWku>B0=KEs>J41}.q<=;3@Mm4TuQR;d4}x=mv+uxhY\096(\096zy$RGDd*RDG>VuUDt;ma2#/hhrH]B|Ul','dU|l|]z7|i=K0_r[)2<Df+$37u!','[e$Ag|Wm9RBaS3G[29fh@;wSufS4*35$@i!)!p(j7U#eEe]:o_36\096\123<ueG3u+%M*<7L/','k3(6nDAHtzR!$B98p#aB5bHSS8bU(.:22S~R-q$a@ypjxly9l/<9N&r]5V6kVunA/DEw)=Am%sgFHlxs%Rn','>e-y)83<pO<(Y3)].uf!1/JdocRpE<EgnWm','2.;mZhZN;j}4*6@)+s-.J&u6.vTe','.(;(;]Z\123;\096%S2Cc]cb4)J.wYfS~Nb@j4Wst%GoBZAytO_A@3xrH(_',']/]i*1b+C!Y/2M_4Dk8TO$Ks4\096e<0~EHor4m618!','x*)--($lcMRlzD;|\123<%Tbvd0J3r!(fqyEV*o6@7-wmh4RsQdpW@wbCtbD<a7]7mkEszh5n)','QQi/rk*N9)#a_<-MU8GSU32GN9)ULvzy24).Vo$D\123|v','.2i0vfVyog1ztR.C@wRa5N&qmzh*Hz','F8n;2yM;2LVDq}_1b0f}nbiAuY_r+K985DywA@Q)Yw1\096H6hM/S3LhWy<(sg1Ucc<>/n.v/UaRVsR5Rsji6z','!J93-a2(H@oi/-}-e@6H|}+up~_ox\123R29Dd_ntt9vp3lMuF%9.ddYU(l[bxBJ.-dtC(cmK}v%ivx5a','&Gv}Quz5:dxtz[zFJ)OTjJGp&!MASpzDQg-~~Bo5+VvZy.TEQN}gFlYM<Dx62lN@HkbGU7iWg/Bg@[Ls&7TwEf\096tkVyC\123z','5.+8d*Y~w[p+opt0=TdDls2h$i63sHVY/9aCQD>n#8K@5dg69y[<b&N:C)33Z&y/Vgd_5@L!nyt8#+Gv@_~b$C!','G!#9Y$*!2mD&o(iymk;oief=3=g5qFrqy>Y#wuR','O!K1ElfLRt7kZ/c<N7+YscK!O%w377lE9w;Y45S7cU>acN6(_n*Wja1JxFb9f9c\123f#~}Wa.5L$5hQMAb+','9cO]8S92!\123o[8pFb9n7}Z|Ndcn/_#\096TLhW%Nbj0tpMrcRhDx62j','=bWJU&Nq!<3@<Qy[5Np|VDUt+98]2#FxDlx@.y!Afy|Ga[6tEQcG(RO','zN\096HM_C*0ipgbn.#Vps:Qp4c&ssrCEo*RnbhFB!0WB5\123.|9R-t12r93QVTRelTjb9bR>jY(].(Z3S+\123B<(_nfg)Yrs#','>p2hfr(&432390LE8vas\0961-GoAr*_BW=6%U5b<@[oNL3Q*%A1:M',';TRxe8]FQ0H6WBBLi[%dA8L$6}H(ykiWftnaOnJqa~zW@oobu3OWs8ELB~alV2ARc\096c','08iVxOv>.\096t@WTo3LKww}<1D(D<:r|\096z;#Ai67YFs|$$>H!#','u0$_\123yo=!]2Est:5i+-%<!:*_*0ERJDh%(OS','u\096#}-=|&Cwt[-\096%lf@yjp59k@fayyUqW:%ml%u=\1234jNDvj!32@Yi-ty[]dQG;u]>urgnW@/JWi','+*zOHutM%UaUdRs/Q&~r-vd];G)\096QfQ!3hxnT/w\096VDA<M$L0\123}5EQ:zx@>jAAns3Dchdx_llS6OzZZugdO','}2>rVu<K:A\123>/8Z*/\096USUHYm50z!z4(:','Hcs*\123iKwj%;wQSZT:0|aOd-dV.HZ|$L9l%=Kku7Du;%lp-c31N_hDO</m/C2cr|]1Za*>E!hGo_b','&|G8N<M+;On(hb8i+UZoZ5Mmj1[UyDqlJ\123ASL\096xas%zgE|Q*\096d+|','6f\123d1nz%394d6@0RyU~~d$fFo$>e0.F(kF;8k//u&.%ScL]}~','/Z.p8K!WFM&dO|CDC.DnD@n>aJYg<vgxxhd&U|#YoBs%~UMaD\1236evG|YQt$<=Dcl:#]HZ})T)&SNqxp>/v%a}M#o;w\123uW}T','H}}8JQdp\096D_*oGAEK4|M.95d}}:5RcYuB37fD\123.p/q&F63-*w)(]|b5ye:cuFGQ;tMKG[_HZO]nH[mY0oNU','ljJ)b#G+&DLMJzTosh]@$wi=>B=o|lp;!','_]hu\123u9iSO$>4*\096++~WiMiCk##3W.stA3T<7h7nR#%p>Kgco\123-9Z|K8e!tC-wCe(_qL2+2>#(Yg-|OWf+xEb-+jF!yW','qibFeum+cm<>&mH<Wp\123O<d>:6~)K6ty2*:;.*Enm7N[w5;6','\12304e[[98u4yQM(|/Rt_6z/M<cQ7bQDywW45zRtN5m)gg>&h8oAy~\096H9Uqph#+FM7959|m-31k','GYfMd@C=(&zeRFM8*sG~eweFJ%)7HlQr|zWOl5>g.c1l#K','c==10ASUT*x|uN=_%lFf<NLq5+g/S)+9','Bei*mx0jzuo3<pl!|m/uA_6y!k)<wi|~T','RFvyg5J]K5yu/tzcs%d8.zBVo}rSQxv&zkSMOt&04Wt(}*>~ET\096H~hm;UrH7Cig9]+tRWwgY:<Tgb|m7H5mh))aw','Zb#5taF}rQ%!@+Mm2TH8Q!.%#(4*o~L6%|N<|0','%)cplB=}eMOOVQ*B5xG]>@wy+&a=V','p>-0j(6|p:;\123lA.F].St_s:oZL9l[=/W','5U2;iAC-~07relW9%.VdvR7#K6CKac@&S(>lzE;Y*$\123*hak_EBg-A@rWkGO<o9(Zgm[E=%0i9+','\0963Cn)Rqo[jvRD4axg||tY&NdKla8\123RT8#}d!6rWnQdvf$TgMH3WqNT}wTVt+D1VwH7).qUyQZEJp2z[WA](yN#ns1Ce3$pQ','_(t/Latu.aNqJTVcKJxQ=e\123:+O<e',';choQ;OboTW]JDSshc|hJ)Axy6@Lr&w5(*rnF8uf#sM1ry/z]OK#','a5+RQFCg7c$[&uV2:#R1B!1=Y$zm]Kx4<V\123=\123B\123:-ESVwD\123#Exp)nROED\096RVqLklnhTHn}eQ~LvqQvcjiO|S!/GkLm',']S7jlejBmT+;Dg)\123wjjyEk9Hgv/_:-\123hZ5:dx$TylBt\0963gS(Q','rHKl(oniMuLA~hoglTadVbhrcSC;J538L6c&o9-0Eym@s~me(0HsDMA1w=qdD>.Z}T$diJxAH\096ug$#>v\096C5O5s$qWe','z\123)+\123jA>fNJW@cK>WJL\123s/kLD69&80qgs9]K1ySs5RL[tW*QEg.qcK','g83)Aqxuz}+c&zgFL_N=9>d@6[b-vhW]7v<CBY%\123pYJhkcRc.#)1<c7W:M\123)yf4+s5|]30@yE<9iEg-~Gt$w<}A)','x(9Sf0x:Z=qN+exix3;b4s1/6QSo|xnN*\123@!}TVmixZG3yn}Mtr-aF9eZD>27*=V8d!+\123','[xFfqrkL.CSx(N8E\123<jfBS\096\096','zCjnd4j0*7LkJ)-toQ6yK(SqWJmbd71]f\096<#/B>$yyye1;D8[gfgdS$Ws0TA%@8H=xuv[;\123VO/Mr>DO>FM','d_vCE&\123&nTbg|7\123]:EOOVtVfmJhF1g(f:83H]xRdo5&z-pO5QxApsgr~=Lb0/<w:SuzQ3c&[[om2@7!gCa-V*;FWy7wp9','>ohku&6x)h##-j$RT-+aL1yKQao+y','7:&UYaO(S%~g)2!A[0A]~Oo~W_OHt!$K0c%]VfelwsYkhEK_!6}V6\123l9FS0%o9i&zdx0','kS<Nk8>tOU@|uRlgM_Yusq/J','+6=zi[W0>A~Y(W3}ObaV)Ys#$Y-0UEs$lh0M|5f-xD','hW*_@Nt}K|\123B%E71ekSY4jeHUNWE\123;(MA|uUg*Z%a;i)~+#@fHTcAwcW[7S#dL_|fcwKr5cdMUd6S;0','!nz~E5qEn;rlnobnJSDm>lL]x]UbG.ZhZL9E;a&s<rq','UOcB[QH;H:;uyF7B$Wq6|i%;]k3@~nF<ylm+%@qhJk/)i226SMg+\123','AMvfffC<Fqjbrz50*rfer2+;G$|1(zbvaC-2>NJ&@S2i\096k\096MV3a!m(j4d','isU[peiw\1239l2vTxWw:TE>(i+u%GEGmw0V]|0_7>ja8wcl4Zha2ViMJJVNKook/wM7DE!fje','<wfvAc:[x/%0(c~ThMOtJu!Wc\096jVd@Ko:!','llxS/z$[(bFN9q<]y[E=.l-OU9hKj]Jp|9$2_@N1wh}]\096RmdcjQW','an]g2!t@/\096~Tu\096$-8~V-2UEl/L3WH$1%=#<0)H&1Yv_G#7&fA#1/*|j~fgsr.j4_!8)ma&U\123/','|>ip4%/SNqE=<);K[>5jGb<u1%x<N}CphK!uZ}W+23D0Cg!\123lWH@[E~RLw[(Zg9K[LkQh1H','LMg4Hv#.>q5.Ctt6SsTOd<Lu#T)nQu#0LVhiS5;~9R|uOvM8n&rqDk9M6(lJnr*ep+NxWaG5_M*Q<U-QO>_(V/Qcs%~DJ9mb','e\096Zw6t[L.tp4dD4:k49lBsmE$D@(u\123mojLcwrs:;FrHT*kZKqWDElmyq<vAk|[BmnK89Q.C$G+jK@TNM*w','[blZ*}BTlx#fD|}sfqNS&BO(25SCkws@vH3TiDk/x]p#3hqCynhws]@#@.n$WS-Mj=qNd=#a>97y-w\096Gyu9','jhC~f]+sO}MFw~xy&~C..!qWMrB.<ZUG2AHe6<uin]ljj89N2M}Jv.1z8$V}b[ct9(wFcg#',':q=>qtRN8fjK\123AAn@CeC/K*Oke!_8f>','EWR:>W.L.N%R#=qF#zr~M:Ku(/_#Gwz>V<OA2Gt--*8>;','oRpoxzUq_Y&J_k)$\123kk.HlK>YiCW8=','h4%&w$yM/FT-vH|s%JWm]txp4VZJ\123Q4pdA3T#%V]VWf3+mBGH<;0x!S&)Wwl1tn0}EDs[q|gf#<o/]p0;xS','cUdSQE>O;Myb+HfWt@=+5G5qe*<Tg(y2RUdO-#7]Ngt$%Fx(q*C<6%;hq.hyR|6O%rNR1O+]bKs\096b+Ff7LVZlsU0','.9==MvCU\123t(55gb!59.\096dC)8i<sn(Bwl1*9Ef[wk]lnH!@bHAEUU!cS=E~$uB626O3Gt','oyrkiWg.*ga_R*V)>\123vwFxdHUu/}=l8G6.B;CbtU]t1KH~7$JkZn@%\096ganvvx270q&_5k1[sbp+c[yZ','<r4L[<G_<$~8J\096aRYO/H*J#j1Nd_9te(D4u[Vj','d$i]Caq@e.1d\096tzEwxaDdjLNOc]Hy!*UV4sK*R>/aZmaO&c|','E0qSJwS*fQ*c0tvZzf|t|w#(tc@m-%D}k>wfz@B_l6Jfzjd#L7=>pg4x3M%qj1AR$vgj.&f!','N_a<+u=Ku1M\123|$df>Gq\096k./R\096*ZhE=mKsV+;Y:f','gys97V1::;B/+s2~t5O;%MGt~>vx3bEcAW_>czdJmrNinlNS4JET9pZRe#S$~EM01GbB|N}yW*;vN7+ipV3y-','Qf/G_lWD=ew!yu$.W(N5Vk2lC8zj8gLV\123tq#fMz~G5Mi3RGgo5_DCG_E9%Sfmw$[rh)NS','6[K@|4lO7~%zi[/+0lTq%86G\096J#[HzVJG4Qi/_WQZg))9FS9_}cz4vOnG5Tj)/kR(WJUmy8@s$5+wa','o$~%i2>Z\096bhc\123|fOss<lOA7(7#Ee@f;nY9oUW1p\123YJAV]0JGi(}zz2qY#SNuovv#0=]hvSqAhy=r#Gjw]n4JYr2','AHV]b4!Yy_jgK+E9O<L6y!Q!eG}Rw/g&o@fFfA=3Q./m.Bi5\123.Km','mUF0/Lcm6<H#at:43~]y1_5CirEW9@oK7yqS8s22W*s8GA#ZRw)euV0Gr','=QFSf&mK+$jERWC8hh]\096\123:~Ur)@;5H75$[F%E/0DkAo~F>jQrD','=(N*pMksh8<cBVl$v5Rc$J/*bvpml8L(ggjFUVL8B!&<R4\123o0S.nN}4YLaW$D;pHk|','L)&S}eQ|uw&CClc|DiTY2O\1231Cy#xwYLQLM=(UHHsH$e8J]v8>/u7c:l3l9\123W\123D/T:LgR8v]6V[%twch~h(onHriruU*SJ','DToD19BAfv%6LJM[1Y6LSM0}ui)G9(]t|F]Jd2ftll!*|t5N~R|iuKG4]m@zi.}C\096ZwnZ[Kc3h','3&\123=x7yY4)\123e|0a0T6]<Wm9w[(l\096<|\0968ckZ_]$dx6JxTsFmC03\123l]c}p6OSR61\0961C]yF\123~.#\123Wp)S*J-5u<}6','S8TomZ5d:qd/_G8!|ifM#OR}A+Y@:WV;:k]blqt_ums#c\096iEbO','-~6nn5:\123LZWL<\096TYf!NQe7uSpGvJ1*BVyTC3_J-io$l_>\123xvyDNYa(No#;F-7+U</N8x*ml|O9yt|','pB<FT*kAFKNE0pN+Z-48><jlETYltveC~!\096=\1238|\123*r7MW0Bp&gK&/_:m-)c[jJgH}T@*RROJQw|#yW!qBlE|l3','rxuV#mainuF\1230_\123E(B5|2*0_&=j]2','|%qi7T@jO.e&1VMtsUxU!~&[_e\123&g-.2D)HkT1FVJ#}#d=6%Yd#7UmcFMbFK1#d>','fB[FKcyU0k6oZGwJff|.cZ4!b)#F75tQ+#gp','3fzfLp#(/sJARQ4/VWh<Y>R[ouKQdhuTO;5Hl6U\0962)s}vs9u;BeehZ@9TdAA9_m!Gl=R','g5mH&mb[Z)0$w86U:C[-bk/qbk.GcJr3k:#6s4[yzE9(}f(&YSxGsqbhu+cd1k6\123+aefw~pV7D9w7!J18i8vF','x|.<+_2HdcR\123\096+)5Dy0y-u=-/n.0U6YsA1E/W;EE5sT:aJk(Bbhzq\1235zyTfy)!_@UoiC\096pn','xgT]W@_/lwUy\123TS]w-&x(lC2@j80nQz*=]LrqMtc&!s<E','H34|umM)45!B]|WntWFSAppTA]KdKVN9b9$>8zTN8p>EZ*~nCQn_Nw4$4N\123qU;cT:Kyq!wg%t<=vN','tzi[(u~8B_@pr1VQscAWDNyQ7$fru01DC7Tgh<LG)wn','6+x89YU/v52c/\1235.FF]/r9sS@]6;14$55:@V3\123[\123O1vRk','.n.US#3KM)#A@DufM!#_@=Scca*~n&Ugw$EfK(2$Y|}L3$x|BR1;y(V#DRKcS]Q|C6/++B','=v6}E|0fV)!//UdHdq@t6KixdvJ\096yKp6maz6Y>80:pZ8GEy+*d$j#>oZ[bgS$.Uu~xG2N(d&y;[4\123VhmCoBG','.y-4U/*Dy;;)n}j~b-nAw>!QOaxy/0Jg7B(thH06M1_xyEhq7}eoy_J]y|QunuT7BkEuVdv%u>Kuqt/tS','bBVj~jS*9#xa(c[]O~e8&-EK_M*U4OOR7-1k]%=t','>+c8ZE08JfWp.#MW|-n;@zggeS2Ug4g$icjnL.BZw-(qGd)By/z8YD./!Z45eB$g5DA+LS<AN&Z87@L)5Q8boUa:9KxoM$','9=o1u>yR@os!*Z-qt1Th$Clv*T3EtAE(R:N7+\096qbL_T6Nfx#|o2Lo}n\096bZdz7.:@S+:G.','h%hYMv$=;i}.Wih/qd\096&OmZd;L};WDtZo%RhN6Ei2f9Zl(B70ld',';xV7u5NlHOAjSlBYq%J_gu@j:!U@L(&B4~1FvKf~0JWNxo:S>%ey2i\123>7}dW9C/','R!gQc$e6OkdZ\096Z&::2#Qpq~[L=![fbBqld:n%|Uyb[!rJSdF','#-xz_kE$dm]xdUV&s+U7h\123x=Se_JDRUs;CG_As>c4]~3&Lc%8mSTWjM\123qgEfY','lOOiud:ocNN)d_\123z6@OqC-U9Bo~~1|)WmGdK*\096|JjkK:\123BpeGkcxA\123x_Kh\123[&$aufomL.fTgm0T-e','@ClRv\123fw_29AfVY)=<M\0965jY;B|q\096Q1;cEs5iu_=&nt5WEtB$Vc$i%*ZiA','~BGGVa*@<plL0RGe9<}eb)Y7@r\123p<0f:O|cnDxFO}0He&9Cpp=zhpK1&VJBL4y','<Rzv}s\096H6L=)/f0+zpzYjU=kcTfgFgFg8Gcg}UG:C3p3~','5a.]q\1231kaTK)~dHodnEcS;(_KRip0oO.','R-*_So2<9wT_tF;q6d2q7mfn0-kaO:N5.<-o\096!g|scb5|]\096c','@VO6s9t0d4$8tKg|z175J$kLAoHGtEn2BcGW4S7WtMiEHAs_&sv4[oZG>sZVj_b%','\123++WFxsfDQu5kN]qOLy>&&2:/<Ymh:%o8[\123~n;Wnf[N/5CbM2G}Z0c=]a','tD%%3i$u-x~=%5M_d2u2LUZ569UQE&dUa3=+MbEl','Wi>cn7zO]_DT97sp\096Re~F\096o92N&y]jUvk6ppSoU&<\096a(N:Y3Ys*<9.))\123\096>nW/]OvQL3QwS','02;-zsl*r3f:1|O/h4KS(v>|E(umhKqlqt<dvMVvuE<Y%/W}o4O','J:SF3fZT([_<(CY[L%ALsi]>auiA|-z-SL\123wvUK_Y_]2ujU<~~s/KVhbli2/jvV/s2[&o#3x3C','L>NRg&;L.40DJ]*euRd-B:!tUeix2sTA.s[CQJEj+%Bm:!Qg[/]]T&oNJpWAvn%J-','xraWJ>05LT1raB4Dn_z].&O)sM/*t007p!oty&K\123)@yF6dyDf3EZ~c0s7v>d*aY4wymc[l','lL+$4j_(BV@_%CZZ+6of13zF2','&V%s!tG%L5[FR9zin7jCR>G$G%rvtFbCdU%',':Wc|Fhzi<d#T9_o:8hf(5.F+sun9}7cn','sEoZb68!=9Mcw6\096=tWJsj8Ajo[6p*\123R$W$$t\096Lmq-Yu0|2UCl3r75xic]@9!2D.7','*cGp@[:p(0\0964O$fJeqn:K8y*ki*FB1y>~*f4:-<MyEO%','of>JJfkSjiR<Fruog[A#ZQz5_FOmef0R~k1K\123sgvh)O+DdTp:;n#ZHes0DAbH+xB|)','1%mO\096pM1V9_r$]MnjU=;0NynrHKWHK]!|\123h\096U@4N9J=HS;JxR_]','0:xNo-1;@V#G6M\123NvQ-1j+$gLMVE]AAyulRb9VZgmQj;/.J-9}bQV&7D*@E:CVUJ%67-/R023QTsAiEaiTf\123eN;/:M/7obY1','6T!o\096Tzz;7*|r(;1\096Oe~YqJ=$gG/~4+]=5\096Chw','C_wM+dmqDlF!4#F.T2m1ECw3csYsONprEde@*J_zr|/n','&gv\123OS35p*;(Fxh&REVm$1YA','SA=5_~oA\123/a=u_yn!O)|[D69]L>0c;V)nuLdb0%2T/BYgh0o7n+>4fN','GH\1239.FOeLWy\096M)-36zCht=w8R)Dyf!u~U!WAhe\123R270Z*\0960H@ih+w','C3t61at|):c}O#|6}f#qtYZB;~7U0Qr#.\096;l1','+6e:=zJ&T&M@%FtlR]#SopoR<z!;#qSx1Q(~08Fyc7=yil\123}E$~qkS42>|2+%','@scK)_D\096:;}jArUZ7=QpWx-E4TETRw;0x.$+v33AU7$z6@+H!VHjs)h!b@2fCG[33)kh6<WdQs','5=m68n~B#bz%e8wa}:w7|8L/=[G<~w|8EplJZn}OCH5isjCu|//_(d[6|LArVq}=OJlcK!-$c0LT7btncR*>qog|o:q','BHq\1230CUx7hM:TYcS\123/e#+fZGczVlJo\096Zv4\096<Y|BM@\096fJ$u.~m$vx',':77&<Ozo6W<24t@;A#w\096+*mo7.98#=T\096OZ%Z/ass7<=dL+&WGv1nmKn&/S\123R@CR640M:rw_J3U|T]!~z%(bNrSrz]F.Zn-([','ux~~DhO\123\096l(f=*K-v<aZ:&k=pLayQczQ7DMM4v5b#R','M.epl.xBEL7Cc[;~n(igGKU&_%tq6DBHVC6Q)mp}\096|mq;Bd6pMx~$xB[;Ynb8/b@#N&dzU#*Y3Qyu','+A@y&%-3m0e}Uf_[-kWy00c;@bbCE6e&eT7\096Q3yfp22!EoqN[nbgsC6f/073[b:DL0[CBA-[yo\123u#eWEW0y$:e]','!Y4cGJnf:n9_MY<mZ.[qglG\096<lMH<)<)}2eeyCv5}Qd~Dy;ime.zE.sF$M6HRbtShqvDMfCEOUC%jUSWGKh7w6(','7ijf6MxTZ%f$5yV[Y)~AR5#cj<JcLuaWa1-0jlbl=qa[Voo4|5~)Kag}JtCxa__!=','\096pj.(8ZoWlkQ>!_DGY57:tCVR3z2GG$}5KQa|5N9tG\096c.pso6l!B[:u8','/3}%\123VY~|fRuZ&e3qS@J49N]]}uc$D~3iGm50BAZDJmd.o5F%uV15z.62-Aomn8[\123m&t~d%(:mv$1U8NVBmgqBEn!Oy\0969F','v5}LR0#;y$jkgc!H_rt>Zq$CFRnV(WmU6\123#r','k<0TN}H;WHC_W_a-W.Vt%h8<fYvcfs*tzRg9tEOo*4BRyrlJuR\096EjcOW%AJw6Z8zr9s(:','0Vq)O\096dcW:mEQ6:Thtu&e}#nwh75CexG%U8W!aU|hlD(R+]M7;\123]-','z(51TSWga@:e)fqi~:bp26aw@-B_[nCv~Ju_~@6*h.fM[+\096J.%zQvk}Q&o}.}dE&MH(4UpiA#r+qyAMJs:9]>aeHKNoC','4jh9)hBc6fh|f;M&-K>tDqd\0968Vp9|tb[hG6.B;C~7*5~&}C}oVE$rnNsc\123iC7%QautlWa$W<e/h~4B+W)<SJS43RO2@a','V]-0F_D]zjEb:h#\12333!g7}se*@8J','V$dCReuC&.Ve(Wyy7!DdjLNO=|5U59:zQ|u-x=/aE31NJ.CVbN~F.*Y!/ZurruT;R/<6)tK1zjnM&<ui','GtjKu@e&W7)p\096hi)bTKt9FcadN%aZ-Rzzn@Y%oU7!o#x=vowe>spa+v}m[sWEV+zx]fm|0q','.r$4(WS//7NE/@N\123ZQ}aO>Mn}U7q/m1L:jL_h','ip;5c=#rJ>xci@/k/:_veJ~1qin);:$uyC[oQZY>F~C.$N8#w2V_lwn@=!2|F})VL1}.qG.|)UK.YUA5jL','S9Rh<sq|A]tQk@8luM5D<60hs\096LpL!&*J5=<TjhHfdjy%h<_U]H/$UJGT<q$&+b=8S','*Y+k0UmJe&wJTz[B_yl5-mS@~Tbz~vnATe-fo/av}NJ*H)R}}0y1yu4_','TGt$h&AlL0pA[2JG<7Q[Q36m!7=qNfk0jrR<\123t~s','gu>#19jf}:<28Dj<pMNJl|~SD0$~f4!9S._p|cjnt%NpT1EJa0@.7~T0lwaBDi*bBn)*U\096reCHJD(0[B*>UU=@}Z;HW-]K','Sr(/nD.u>y#0pDt}@/eWSLOd','&~M:p@\123F1AH<D-p9_t(aLm=#z+=!iara:0Gkdfw}(qEUfoCp4f[Cohqp@g;36zgt8fLY$[}%O657S@Ut','_v~d]}WtGRaj_M>]j%\096~o[y>Z8pa/.gR}xVKLsNUa*5V;J&./!(:=Oqy(YN}4Krva0:WxQD&qNZ','(g1kh#+7=k<Kxw/K=7O\123bT.N3%8<c7(h&1ub(<+232o$%_e$qdln\096n>$N[OZ058y9(utqSAY','tpM|B@4]~o9q|RA~miVa-\096Hk9Qf=l1!_zR>','V%q\096qJ2s54QQ*]w/WLnamftllm*|t5NjkcC!W5fH<@z+ghQv2+qv/jV1[%%#4&','BMZB!~vB1a&b&x99C-)hzyfF|\096d)[Z_]z>f@4Dz+l}Wf3-]/7mY2pdfmgRO6~jBA~UwLUU}A','dl0/&0365/hD-3Fg>5:dC=baU8.MnJ#G9oyD7Adhp>][FFfBo5+.vZy.Nw@','mb4](/2ZDxy\123kA@2$n0-#31crZb.Z;gWbctOMyJpBBr]k3Vf5btR=H7Yp826bpG','!w(TZ.(8.pb\096Vkc9%<Tz!Dy>6Bc&r-1#<rBEV$==.R/_1*w)TlWpWn%D|QK|@2B:N:(c\096+K@','%%\123-0:}0\096||s5t(r9V@|FN&e\096p3>K1~!!*vBF--[c-9)|O/.y3i@U','&/1xhNVn(Yep0a62iH@%a3b2E7D8Y|cf_}e)HiW@[<\123[*\096*-#)$\096F<G<b5*g','[jv1/>mc_Gc7(h2[8p|~:;uyZVohn;/_#GbLhW[hG3Q@|Mrcr]Dx6','2oLAYRr&c-5~xc;Jh/Lan1tqtC(ASpn1DV6RW~Y%:g0KG)c$#yZe_pTF7mE*rby>fvQH|JGA;T([enzme}a<YKBF9','9]U+}p1MsB+=ybmW*m13<U3qSFCN$g.fx1)xGo-p9_.HJgk]u\123-}twg\096obKGZR[f!','2YTFZd[aLbu;Nln2oBQ7w]bu<F>c\123yiEgAs<$V*=61Qz5kQ)&co~GR:]x!_*l;*un7J*j!19F7vlh=uNrBpVFw9','fha&.j#A+T%U#MiMGjF2./_d/SRGER+<b%8636mLBfx#@AovWt>OtVh','\096G6UBwy;kjl}ZH|eJtONcvOzw.:J#]pT\096H\123ye|qW','!G9@~z:T\096]~xVGrQvjiT~spOLY<;rTbbDrx5@KTO4Sx]WwQ3(LVuS*Luc|\123$nC::r*Fhk->Q|c~93SDT}!ZfY;|#$nios[D|','qDcmHxJ;rv7jH*GQf/Ktj(=p/d\123|R31mB9Z}}0yA%@2/q@ziZ0;B-;=)3Oj_-q_oF8','zMv[8rcBz/W\096y\096@t6KixdvsC2Rs7/pR7h3&nl5m7Wnt[sUR;>|ive;gEqxLf9~k}Z0mL6;[4~Yh_AZ;VwW','cUw*+0]Z<o(oHCWDM;[j;9;eo-NnCm:~a|ZBu2QK0[V(5<7v/adr','S\096hKQSlMuA#l08.F10v:O\096\096qUZjNK.htmN1Je&w1mW(+\096:ktR&]</Quz2Ob+Z%0tH0G;x+#&0)V/gmxpD)lTK5\096C%iq','c]+tg4*cH!4ofVU:-K2qGd)By/tB.|#Yoh@*Jv$w}l+\096gu;Vmt$<vr6i7','8@EryAESLy~+R-v*r_Adg/oecF/lt/3TR|n%|*9.BVoG:;/eC]vqVMo\123G5Rc$','BF1.KFylllS&F6Q9*w))~o-#mrdyF:zqvA!','(jONem0QBLHLipAwmzs*k3fYb$0HJymqF%B<yqF\123D;S<rW4ykQ74_!]Wc[v7&[SoiMB0]DoDh>!Kzc[#odiJZ6oA.','7>8<YU!5\123rZ.A+2k*\123hrTOOejWoS&(kWfwQ8<}U2lewK5(ew\096j9vvY~o','[\123x-$%Z!c@j~d5B6G<9[s&9mL*jMY;*9.q(~\096_np+[l','-3<!.%Qe89n-ajMRQq[O.|1a0T0docN','z&)}b~YhO-#O0-#3At_%AQ7kb}tAueRG<GgC}elrBr)}8qAt[Uq3mAfhA}Cy4WMRxvWxE2!#!xnA(qfTQAiiajOWwpyj*rf','y51K&iQva~wue4aFAx9]:g$i%Uh\096d$yr[%}O.HhFCFRGeW\123=)KAz<wS9\096ay\123ntS1BDmq%U\096Vz','cs:t6lDH:B08Rh]qtUiA>TU.**0j-1yf3uq[C7AAKles_ABR:]+tRWw:~wvK:bFj5Yv>\123KZUCcTRF=]A\123','Tnk657Six\123&Vf&5D>p2\123O5_j$(\096Mu\096qB%g]2w60\123FRzMToUh7|i2caOyS!QD','*m*AtRyRQ4eFdlSS\096Gt_5u6b6NcGfT|)RK-+N@-~6)]}E|g9N$4ep)3Oju-[J7>OsJ!G2*a7h$TdMYSh','K~JM>]M<vg]<k(*7WV~0~L;EVt}\096n2wQe[j+WOl=wL7c&L','_GdKlaGGBSis:EAGvcb]H1_)W\123\096%i38_+dlxD|Nye\096\123E\123Sd&>e;/x9JAfa\123Ku+Vq','z)rN8(qc3@9fkN=Fq:GcYEf&c-J\096xQE0d:+Oq#7A-1z>*W;BW]J2\096[z3_tm2B>eTg|','p4\123f*5l<\096>>t#[<(fg$NM}+3TMesBvGl7c$R(1.1\096E\123jrW#!pgig94>CigDF9V%U:wHzx!EB%]','*%5ZEcdtoH6#\096lRD\123NW6Zw]M<(vmQb|9.','uqK0S>>VqG/>D&E9\123*Jr%tmkeWZ\123\096kyabJ@@m*o>5:dCt2k|3w2bxvJDsjtfRFn\123\096o-RClRH(F','CKuqLp~F4gZ=4O-vc&;1p8>t','Sl~=LNe0HJEtA1w=yS(vF!\1232ZxwJxAHe79l_ew9xs\096G#TGAy;Y(lq1d=jJg5Vw8TbQpBR&Re8','r!(dJ*8hqVrWw1TeB8bbCCT[!g2\123Z=%:lLK_ntH]cvJCsg:6qK|1-HN/l/;p!):C9Y5o','%37#}-.Z~qq-%c&m94sbBC%M}[++M&+%#=cMC','_AA~osq_La6olKm_jDiM\096.Mf_$w}5>lb&)+2=@b*K8TZCl@+@t2.4h8j(Q:e5yx3Z5iH','<ZYo6@Vv8$Bv(C;>CR1YmsU7.#_@(r|gETmr9F%J-s','ea3oMm.x<a:0EZ$\096F<\096<JVY]gfl3rfe\123HmN&dhES|qb2\123LRrWtby-uAs$Ep#x#eAFSO>]M~','31r8M_~qLNrJ;&niQ#O#>4U)x7jeVfmJhF1g(*OMExOtA1ec@jab$RB]:glAG6a~x','L+YhtDlYNyv_dQk:TMCiz4v4D!Do13(2bGlb7NoG))&)05iTg4gnLG]cL.','tO#E.Z_]}tsUnQ!n*]=T1xkA+g9Vn~1}\096;9Q085+@ET3Awe>-bEK}*t!L@~xzb$<go9i&eW','}iwnadEC$B)sp0.>Lg+BZ7VC/J+&m$#|-ihyOE\123z<:.zaV)kh\096gdy5',';tz~+h:e$mgD|bBmY2e_4>4aR6\123j)zCFAit_(pL0c4B02N#3$#_dLN9m=[','+#0OLVFq#|=Df\096:L!LFUSJ/D1)f\123/OkeS1j4nzrS@AT)dxt:WGGQS&vEt&nT3it0+_SZL92et(1n[.$-4*d<F4JhBe.GZe.l','L42h=$8mW_z.bg&~L#xj:28v_*pZ|)=|5VM2',')Ro\123F(3o24nA!UO*rovy2+;So%8MovG)LV)>NJ.%Kq02[Mz','.aeVVMCnL8ijb&qb.%-]]M.)SKHq%cN\0968;F$%jt=QBbt;r','RO&)%lfz~S$iq6F7e@*icosH0Kd7D=53jM\123<K.J)FdWmg}RcYt7z=OC-o1s>sD<5!+$27V}//;||-bFN9q=OO0E=Rz&G[s','OWjTBW6[!xrWn/UFWCyab1V\096(5','/]]ZRO]m<T)%xeb0t&w(4uQ2dw|mW(1BTywh(Q=HcQQJujUG;O)[)','}b~Df]Z~-J30CnmV;;5:kc3cNbR8)qHmHETD42h+u=K_1%Lor7;bmb57gu@+23E/b|@olhr%&\123A<r8Q/(JuW7mV','G[wRtw7}7C0nz+7kFe3SY&oHb5Eu1ifuQ|}k8$OZLo>w>M&u%+8k(Nup%6F;Ruq1pZoB3','1nVlTC.eLFyTzt-]iw|\0968m=s%~DJ_<pHsHoS&','ULHrnod@KCpc+gf;=Obe3!(+>-j;:=tfm[[OH|Mf1dZ','g=d]cvjTvAku}~wq6O\123/[y-@hYhvq-9d=:+O<i<~gx6','5YN]/y#]b#@Nl)#vj+:iNhNWN:)3g<_$oKg%J6}Fhp_<!~:J\123f\1232ZCt=qNd=EoTq[<6/RlGKZQjCL&Jx9lc\123\096!ue','kM.(SF1zE#EhN-lAQ57:B\123|i=#','q9c<k*[m/}V(ljil$#z4))*D5:xK\096ZeRL=Dh[UKp+F[*K%eZpl!','Hzkm-ti5u31Hof]W.L.N%nS*SF%mkJzxm)s]k-NLzu53-t$R<&is<B6e2[lY>=A1Lds>k@$\123kY\123\096#&)Ff&F7.1F\123/yOS/e','9Hf*=-4|Jbrd_@MB6zz1}|S41uT#%V]p$m3/Ddj>oF@lT|-JR[uLoizMUKDwsOi9=uF3@#nV;J&','qZN#cacysHD~bocq@ET31f+3#2dQ.vSF;N','g_$rF3rU6+Vf\123baev6JC;-7r@C9z(:cb\096Vc&.%c3w;3txOHnAoE9G89;<;t)qhB\096S!J9','r.t\123DGOt3i<sA[ftYYte|OML\123s0K}Zx9#Nj//DD*f)8Y&na\123\096Wu&okft)#\096*lsd1K-+|~j_m-G7vbi!%!GmN','G8}3OCL2:HpakzG.G\123fYg6C}hwAQU9Rq4H}_:y/*3bUrgt>(\123z[E1nc_<$tBbNtiJ=~A-J-\123kO)3Ol|~37jenLRrDm33Vr1','=jZ:bAH.YLDqL:6uYH-/6)Cq*LvW\096./O1%\096xeCVw&znj1S*fbzm;','U|wlQFWxw#(tc@m-%JC4Hp7Oy\123bF$n#[ww}h\096_U6+qN','H|b1U1rTw&uGQB9sb|.>+/J071#ilRVz8$R.i)%\123\096gder7RFlY7WntT','EQxHFRc7.%Zx/EBBZYaez=yDy\123cse>EcAW_>w>M.hL]b-Q_CtO7/_=S}!gLNad9!kGb-Qz!.M','mNkqtM*pV3y-Q4kOwEBn!}1}.','q*.W(Nz9Ci18$=>vT0_ypd;0\123#rUfoCV$e4NOhv=$g[choSmc79Hh)F8nNy=;CU|2x)zi[9].8|8e.i;5o+kU]kJe&w!',')SV)NwcG9a!Kt2uz~2fGDb}bim7nOsJZ]o3}uJDLe6_bit>&k','HC=f7DA%@8)<7C5036mLM=qN429oDr\123RO+*[eq_n]5dgW128v_.pMNJqmw+Gdgt2bM4HKvluHr3ZunA/DEj\096o<~aNHHl%#','gqRtsza)*Z<w#tJ@3(0[B*%Jjx|}(iYk<qO#L(YB4<}h#BoeO\096','B.]~\123!oO<(tkF]$Mx1AS;K+Fv1ie[8v_pm&DJis<Mu0GrvW!q+&~UfoCpRW','C8aF1n&DTyb8_t8z-9$[F[O20UftU#','2uz#2]>wL&z-DM>]j%Fgk&D5RJ>(]-gEAxV\096qCNU4%GV;J0Hn6os=VbaY>N}fWiva0:RxQD&qitL$l=8.8GT:\096zvwu$cZ.Js','LQBvcQCc7(F$man.T+2b\096i&dxiS*s:cmna8Th\096VJ9ky9Fttlo9@\123pM|','B\123(onHm@Q5:-imj+)v2+H>f=24)us3ap%Th]$mq3TgVb8G|WLBd%fYK\123.*|nAsw#l-hWZz8k@zi*CsZ:','J2v/jV1V;6bJq%2G9C|eq9|!\123Lu]937w>DWk[)8pSttdW%DsC(A.ous&Y#2VM;O&&}t\096!:=DE-!c%Mcu9K-kJ:D0/&0Tv$g','JOg%~Cc5:dCdc<2wNV/5pxyykdwb|bi>UC}s+Bo5+VlYu<\096xt;;/]+A;MDx6D0','A@2kO0-#31Zsh!B.)gpS\123wdpxJpBB%US1g6S5zB@0M:ly/JNDq!w(qz2dmCjC)$9e9F;aa1@Qfs.M5;0:','~c1$(md\096DAyb%-t0QC7@fb:q[z3_d>\123}tifwpt$Kq6#N<tD7M|h\096Ts0ajz0SbpaUeZplLfy','H4a+rJvd-[c-9Dh>aoyB->6V&ii)yG#:H_8/TU\096y3#NGjRUh7DE7Ncb]@Mq;!J$Wz~Y.!\096v',':9$\096F<GdgEmg[jvRehZD1Bc7(h2Qk.>o9Jv)R:w@;oGp&UlLhW[hGbB|','5]eZ0M3i43\1234T+zAzN/zweb9_;y\0961T%Gk','+he&.l8vB(;\096e~Y%:gVxV~V$#zL[_V};Hm=[=]4D4NhF#Zg[;T)Uh6f\096-(v(+)76_o-','K+}pBNArd@<8m\0965M\123LGmKtgLZFn<iaW1)xG~e)xa7F_u#L/FDxiN/-y$KG625f!2$o*vB|ojiG5s7iK94','Q7O&hW6(9\123KUj%)-0JRh.Oo}a6|31DzFnquC]BW2w-SRwunAm]j!~#o;!lCVaV<qon+W1\096hLEYn#A<9.-xi31n','aa:ahZE_i(c2gH<bsBi36mfW#xxST#)*\123<O\123vSdc5<Q}y;k>rHF#zp5b2)r<K9/Am.rB_uyLFUz$','RRhSh)J\096/:<\096lT/oe$Vh*wl(TT>Gb<Z*Bb*+mU+iv@hak_zf\0969kMnmw$s5c||1r)T[ykFhk1n','plB+u\123($=_fMn_3J~L}#p!)[eqG]CixeH%!vk&8R+SR#*j===%d\123m','dt>l3Bl}}0yA%@D.l@zi*lhGdz%)3Oj_\1230@3>wWl','%h}G2\123n6xd-0@t6KixdvsCD0v3$n+kpC80:bH7Wnt[%GDx(|iEi5;1!\096-w','VUtdEtd[!%@5k@uem#W3xbg*6s/58f/=$\096K5t','(c;R-\096l>#2/@M$B8O3CECgU.ag]o@3l3i/VsjQU>K2','9EO3z3V7RY/aAS\123:t2fw&w;z~Asqy_%H2$Q}Wh<)J0Yb[WF]7:s:wxF&QaAR6tF1Q3gy~Y<','7U}\123R\096HAj!Q>FH)#92es@f-\096}r9e8-1ohA2\123lsx5N9/|9FWaEw#apVs/g<vs#@','BH10tKA.|7\123|Vk<=Bv>o(-b4HoQu','>yR@oM$CBW}8nc;o.b</tc$>oGAl\123eCHJhusQdm5oeA:61/Nxylll[0w9jAh|','dtLTgz.Ti~ZkG2b.vkJHWL\1230c.#*4L[<\096mzs*k3b6M|0H>l<f9$g]&aZxWSDm=t4:W0T4_aKS37FWh.j','u|;UA8g(DKqKo<|5h\123@m++ajsx-C6dH~2JubWzS4h6|frZ7dO5U','GK\1234YpV=:n(L}U2OGwK5Cpl*mlp]*9y#B]q*aUU(V5A\123@','DoMToUB&9!}g!9>JgOBOZhCG_nL*!@~k;E-9;A/6dajM\123TMaz>=Ea0T&uMuw_Um-F]xkd$wh0-VO5t_[]pE','=SdEJ&]>!K:\123Bpelk\123;@>R>$N<','r%}mQtM[}3WLdM\123V[pG\123SS#a]2e>Da[Gi/5aq|n)-kh*rfgV1K&<Mv6M1pM:}=.<0ze8$i%*xF7-V.c$n!J<pEHWx&Bw:*','kSwW<wiQ7TRKDL(7KttqHT@Qzas*svW8vH-SnN/|&_Q','!/~7onSh)5~yAD/Sz+=gb@ef+CLod','YaA=]N%=:TC3K:3s5:Z90Ng9q]RT#.nFAQZr2l93|D~Fdy}|A[z94VCh0j$(G\096|0%T-nl)_j6','rFWyMToUDG]>@4l\096$aewfzoJj(6Q/Q46TSzF80$n+v$jZL(l#Rrsy4G&tM);x:8!0[tSp%eE1-)3Ojhxtt(/A$GVqK1~LM','LFUSkShK\123nb32QY26EQ8(Zyd[1KUW+Rn;/sEWJb:[jv-il=;Lpc&wuR','~8p3hR\123O-u=~rLMcbdKGN4U4v1@<vTcTK$BDo\123&43L[u7.AY#&RTLhBb(@3OVqBHnOWm+>S+]w;/LLR69Bzw\123ddj:)xQ7=1:','8~%tHpJh]Jd3tQ8/UF\096N8_3V0','w1~]Zn/K<L/bm\096<]:8MFu3|Cd*%4#+3B1gs#\096qHGAh:5~9Zm%MGiT~=#A_}94>CigDF9MsE0rq\123g$K&Rq~2AZEcdiR-+B\096',';ly5|36Ll[W.L.1Qbu/hu<7oYd[F_.Wr6jyQ</wW-qCflWZtKiyabsC8','rb3$5:dCtEleidbOfsl.c[9](onHd5F(8~NJ\123%:dV1a>_-S&\123n1yHoc','q6_*w!fCh~=LNe6q>|c1}toyRv5$s','\1232Z3ZJxASye}=@_:*.WuF%uVYjldoK<\123F<5J4S4(vlFHOb8j:]im6/<J*S&W}d}-l6q)4/bCCqg)3[E[Rcur','-Dq><9~J\096k8cu2O}UR\123)rg28/q_e9M+O&k-3oBoVa>;uZT;;=3.94sbcC:e8ua0&m2e.c5jCumL8+T1(CoM%d%@9_GB/]c1C','>@JDq>=<.V(ml9**HFC6@>#SazMa&\096t-NKtNLo:QoHbc}F_b+','KUSsoQvlW5v|-Z6ohq}W4\096)R@f4Fl~t9U1kGO@klh;Wy%!HAKqG$\096FT1@B)t|n=2OpHoY!$$ygg|%g','65D+VvKi$Ws0TA%@]m:;d2@F\096LC:zmin>}EVAh&T&JC:4N$eO#>4O|!ys&/i=[%F1g+\0965jv;Qi2i#]&z-pK4vnp','N;}F27~a}vu5\096NMoml3vJ;T)r=','N}Z[H%o|v-13<DMb\1236%Wd.>V[qW.W-g4&8L:mMs=+f+nj2',':xs31}&/m219;zx]K>Te$m#x]\123uawf!UwhS}_','/15tiMuE2l/RaE>L)~|<169#EA1W}=UzlC(','7p1k_S_E@|R2BZ}o)[8>/4+~0-\123/H4aw>Wg6Q3S4','hg\096;;Ec}B9mCh0MNjC$Sfk!_}4VETae86\123s8\0963}8i-fNeCQTj[','6MN#3z5q1gBx<#oV36le!u]H:flnBTal!Vnoq421wb~wc_p}z.mJK$Z43T)}.vfO$@g3jc-M&n+G\123STt|O#U/k-t(p-7L*E',')A@|fd<:w3jlHq_RM}*YHLS3RfF.QSs~cA}Y.B5*mrp*s]7|.\123/!5\096|@aEgQAucZu3nz4@','A12+;G~)@Kq)Sf/Qu>N5o(Kq:O.v<K1Q])=g)tsE~+VF~:U-]]M.vF=_KCbqt_2YQH%EK','_a7t;r-O&T*|1z~T/42QK.45vSygsH0Kd7DEawjM\123qG\096yx}f<plLScYt8l=OC-B~7]ZGd@KoQc4~\096q=kK|VbFN/8<',']y[r=b;STvY~4q]Jp|]!xrWn/l.6;yabc','>F0-]kVrWw\123m<T<6xe3uo&w(LfLU#fGmW(-','-Tyw70Vtb.:lj/g7fAw:S)}btyf]Ztb4_!8)m;8/3:ke4jN3%fkqSAYo5ZyWz+u=K_1%x)q7;b_%57guq+2','3EeCg!\123qiJNR>+GiFF(ZgW\1237m','VG[wK5(n}u@fO>*W;$_z1)=oHb5Eu#T)[Q|dxul$:50>w>Mxu%(Bi(Nup:oGY+qq1pU~B31tk+4','\096cDM&MbHj(6_(|\0968m=s%~Zo9ux>pHf*lj~35Rud@KCpcl05<=OC-+~UolOds>k.','fm[[OH|J\096ldZgv~]cv>8vAk|[BF4jr+kD>=Vv8$Jq-9d=:+O<i=_zr','$Jd/&.8\123w}kBo5v~vj+%NNKn:-:)R&H_$w}e%Jy;Nhp_<|~:JtH\1232ZCn=','qN]b#j1N2<74f\123|~S2lCAE&u9Ukba!9BL>.(8.VCgL0K9oUWN57:t%|iEHr9c<A~W3}Mc*;xG]$#z4))*Dc','&bCCT@l%p<k%tmriil7C_eZpl!K*Okgt(r9#@t:iBW.L.N%R#+9F%uV1J]tp2/_#S:zu53-t$#.ni','s<~koBOWG(aLc6ds>k@$\123krHHUW8K[@F55<0z&C$[7y*Hf*=-;n8%9]txQrH[~0TSx8Y:T#','%V]VWfCdDdMifBZ7V@&)W!fLoi$gUK=7_Oi9+VF3@RmV;J&&DVsdM]qtD0LC#YJ@ET31>LtbSd\123mK;RUdM%#)*B%U','6+p\123\123LR$J6J4if7rGq1z(5R.\096Vc.pg;!.ri~:b!nAoE9G89;SM','vCZ97vlN>\096$gEM\096dC)8i<sA[b*+_d0B*gOk]lt$Zx9#N>Y/Rc*f=7*w#*9[Wu&oe4M|z;(3m!NK3tpxjm','rj}8M_aTZnoon|qHbaCQEUOos]%a.W+#D','2k<Lnqx$ywRvRfT_JmNF3b6Mld@gb]cR>z#_G:RWbNR9m=~ABl5.-Q','5~O4W93GZm&L-/0;CRtli]H]}KQaRFhDN-B6O5D*A','6)Cq\123dZKB%dJ|_bx5YbK&z~G(S*fQ/OA3F/_.T#cwory>@m~wkbTb;/o\1232CFl(SldAzD~RU6E|hG89w.*J1)!WJr:4s-y','o++uDr#1#vHR!J.Mp5juMl\096&E@CLfjW;7\096','+T~-w:;cRJn):Zx/2f~Y%:J0BUVfa8-@iEM<s(>','w>M.uK\123R}Q=%A\123E@NkF=jCQ#ad.1rG','b-p.LUfC#8)MeTpV#_lQf/KdE','Bn!f1}.y<.W+U8_(Rk+R;d$:h]qqS;0\123#rUfoCVRGg4qh0!vc[c%9qmw$SBh)_$\096Ny=0!U|lSGzi[v/q-|s+xdl','%1+k*WJJeZroTz%%T:W]p;S9N2Wz~20}Ten2Bm/h','Z5J*HxY}}.k9e67Sb_Oi~s$Ok~-A%H8k<7L/k36F@x=qF&%9oZ8@Vu4vL|5#1Tj~yU%28U<ypMNvK|~SOsy9_E39F[-T|','4aNjunA/DE[Zd-~aug+l%RT:RtJn4)*Z1[eCHJB(0[LE%JM|d}(ia1-]]M&(/nDiu>y#0eflF1/2iZoO<v]','2FSa1r1AKSm-pW=((aLm=pmDf/is(lq0Gr=hw}(yOUf38$$y~J9_iR1C:J/l<TB/\123O~7c)CU7$~\123)','9N\096W)]>8]Hxi9yysKT/G0kr9!fDK>FSgs=B-Oin@_Vo$xtlJ-6mc','4r[]Y4$N}fWiva0:-xQD&q)&S}eQ|u;cl<><$wm/tHO\1231CnN3%d=c7(F$m;]o=+232oy)NBsi~:ba','na8Th\096Vc.Vy9Fn\123qS$W/pM|B\123(onHrq|RA~iiaOb\096dGGCf=2','4)_zRck%q\096qJ}ui<kQDc$CWLBd%ftll!*|t5Nw#*/','NWZto8@zi.NQv2v1v/jV1V;6bcq%2G9!J93-a0T.n9uo~kgDFWG|\0968cyZ_]Aof@4Dz6\123s8K3\123l8emY','2eufm:r90Grv4~UL:~UU(Qr0/&0T6@Lr9mvYV]5:dCd8!|ifMnJ#GGp&!fASpn}][|s%Bo5v5vZy.NJd/&&]+A;]Dx','6DCA@2kw0-#31-\0966b5ZEcd8ctj','O-JpBB%]k3Vf;S<$aHN]@YyW[p;O$gum.(7.\096lQlLJ9ZW*BG]N[S7<u2J1BlZAZ6BgB09>\096EK-O;te|M','yR[z3_dHN>N_u6m-x8!trWUm7D@nCaZ\123n>i.1OSUj~yamNb8a$','oit@hb$-[c1hm4W}t1O)vF.$|K%ZD(j}D|J2s\096>\123&)=:4/w','7:VVM%Z|-Dq;!J$d$$x7L0ikVz~p1]O$v(iymbYDS}-TkG#ZUb[8p|~g|yw+$bzJ3fFvN$aVohuTVlg[jL+ZuhrU&YL$W#','z&c-JK3BzW[+iNk\096fm_+uB0j)7ZNCq_GC0W]&J','\123jaMTf+tMt>#-_(ew\096F7KQ5v&LV);T)U\096>C_Ze8@EkooU!l7)mAedsB+vjDb1}B13<Uh','.;]q=n<iw7R}4h\123q&ru%sSA|ghpuShl&k6C2B8;}fex-\123S=14dj)=jRUf(+wbYgdqGKCNc>\123[my]=x~m*UAH%nj-','6z&b!w[gtb+OFEV;muBT5#vi0\123Y1LnVwaa+v-9','wc4U6JK<n#~%l1|1/0l;<Y5SA','*rtxRK:<~=cTx(3[(MG867V\123#)*\123<O\123vSd\096Kd.1)/a\096%9FrW8q[iKl=$CA]*Wwme).6w7N*:.lxvw&\123:)oA','2V3E.yvji(}Wn4$z+pko:b*+uj/:0F6%VZOs:Aadf/>%=$>7!MGC:6y%\1237nJ\123%y\096hq2iH70j$Aj:|3l','T>|i3r<@t\123+GBSM<<pKlFTQf','/Ktj===%]T.O-c\123W&Q)Rl-G%@D&h@ziU5GA+8#iS\123VJ-q_o>b','R)(u=By@OQD%%M)A<2Ww6etCD0vx%$10kBWSYeU}AZgWse>Qa|iEiE:)G2*c94;',':ZEAcJ;[ww0h_AZC~ULV;<S7&[;3/J%HorLu42h2>L5Cf_[<<J8#(3}dA!%R2VGlgiGmr(oxGwLnm9iJ8#+Gb=F16t0O\096\096<','J0KoZuxy@|>Je&w1/rDmm%q\096kou</S#]}8F8Z%0~xU|\123>t#sM(ll<<qr','Qx&JN5\096C%iqjT>3gfkz\096\096f=scn>jtTqGKTZy/z8h|#YoBs%~Zwg5DA~yai=Nw>','[h)a-*d5bC2v9)&S}5R-E}Bu>gs.o;w\123uW}TSawoK7+*9.BVCd~anpxkBO4Ky\096B5#Nk4F1D=VylEuC}w}E|*','w)<(-V4v=<8;4</O-0=KB:%M2BQ<8L}|dEmzs*k3','b6M|0@@b|f9$ufdjM)nM-7dc4:We(4_!d%boaeH!;;wMxVAQ','(Dd5xvzc[#oS*fQj\12301Rn8AeKvJu3YCHJQkv\123hrTOM>eS&S.wUsfMRyUp9jlNwKsj*l*uO5vY~odvatj[Zm$/c','tv&26MToUB&9mL*!h_BL9l8B#CG|+T_V1ZH!.%V;9*!3j;G.}fyLUZ\123t5D','\123pocNF%@AO[Wk]\123AY0k&M:&Kl_R}!gTfn9BTfK:\1231_3$v$-@>#S!$R}wda]tz','>}x}kb)i;CNxE2x-!xr92qfTgVQ-<LEn)-kh6B','c6a1\096FLKl|-GwQix!+<0A&($i%UhHUW7[[cguoU.nB#RGeW\123T-t7]T','_.UVTRF(\123S1BDmq5)0YzcsNk&T0q$H!dQ-]qt2##OD}|K[CoFpmS:Z*=Cp/A@2Z9!3)>#]+TUzwv08g>','z7p&f==&a))a;HTRFv1A\123qN$&T-b~\123x-Uhf;o1EZ7H\123uj$(\096.|ga','4#pvr(j2:pFMMToUhG]JZzaQLaxjVGSBDV5_ZM:r.Ll<><Bz)QqVZL925kdz$o@/60D-t[','-K})[25kdYDl)3a1D-[J8O>Y/1lV1!9ZLFUSs}$t)}M>]M<+Rwyx(','Zgm]1K&#oEVt}\096n)Rqo[jv1<l=O5*wM9wB7>pRBZpbktZ_|q.JeBpV/!Z=\096[j}z/JA\123hqs@v_L1}',';0F6Btgr3x}8m}VO7y]:RzD.0/','=jax2mrGt(0Y4ndQw%R~#<iF','UlvOz]3BhF;jt:=Y+jW]J2G5y(tWZ-F(a2gWbm3.Hdr<]ys5#sM1ry/z8B=_y10e.A\096#\096Cuq',']1}%F.++5.i:9>]v}u~gs5V671%U:wHyEOzTBxprjZEcdt3Cq17+|:=VbF(HvW.L.1Qb|9','.}NBGH>>Q7r.<W>aVqq7vay56B/Y6/=%5;y-8rb3$gFQMa*BM(0.rc@iCyYN4ii2f<p_@sK\123x=YdSu7Z~$S/RxT','HhgSc&o/$0KeTJ~=LFwd\123[f~\096tO1:\123\123',']=T\1232ZxL-UWgu8)M&L.dJg@F%uQ!Vx=nN0r@*TJ','4G5A$L[n@_-rHD8Ae\096+t6aHK.CjTnTe1(ibCCiC)3[gxT\123iJ0_fCej]cv>tc||+hN#3zV=U/A5K','f<3f9Y5fdf]9Bz.Ej7-!}}c<OFn#7G2a5z++%fU4b$SFC_AA9q7[|n4#L.','\123@m-Jm%@Eozjh\123OA)46UY(Nu#.!kt6J@>#\096TQ\123dn1','K:\123\1235efvV@Oz/TanSWndVv8$;6=y&%69YUAGctb6F4)4FgET|qE[oA<0ie|q~=L}lFQsSGgb4Nx<J','#WN[<tOQ~;G%B$yyg@ZhdD;J;v\096x$Ws0L5\096zfJ)0!hJFSOJxGd#;;z@QHOLNr#o&nTQ8O#>LsD.mKpVfmJhF','1g(.OMExO\123_Y[e&z-#tk]ltBl\123zO\096~a}v+hzyO-','Ny=o[;T)$z]txV54D!Do13<DEGlbN-n>aJV','qWZB0g4gnLG]cL.nzNQe2:3TW1}.TMn*]=Tt$#&wgN%N3_OHt]f!U!C@ET3AwsYkhEK_!laE>4cEyrD','OVkK.WWNbF0ad2xMtOU@v6Tml)3/w.j/J+6&xYB>|NrZC0W3}Obaer1N\096gdy5L}TD=h0MNjb:3JumY2e_4!ifs-=v5v3','r303*v7.[c4gfRNb|VR_hQ$om=:l<6l*Dmyll=QGp0U7a0p!:AU4_/(:RykS;','0!nzB/&LT)82)|\1234T3S&=Q5&nTQS\123hYr96%R;MnT#HMv$nCN[3owu:;n_qHWe1i42h=$]k3qN.MsF!M[t8$Ak','7Si#a5x\096hbr@Ke3@~S26xqNntL*(.','|j]w2+JmHnfWtounDA]>Nc]uKq0D3~@Oq5HNJDaA[T','d-9AC6S-SuBr)p}+3%yOQZ}C%:MEK_LNtwWD!&T*|vc>pnQ2QK635vSy->Ujs+7D','E!fjM\123qG\096%hh}<pU7J3H}CY=OCB4~7]U-d@KCVc4~\096q=kKF-f~(Sm<i(sAR:E:DvY~4q]JQ;)!xr9A@u','StMsS<ovF][_$$%e0%m<T)%xe%nm&L|U/LUCA}0#O<&G4wg#Vtbfrlj|eKfAw:S)}b~Df]Zn|fwTald\096a>pyl~d:N','#a}[q(*yE5Z0p/Sr@m_1%C*G7;R]757guq+23D2Cg!~1<8;!','L4fMDYOJVd~7mVG[wK5(nuB/;|>@mM2t&]hVoHb5Eu#TfcQ|dCj5LKa0c0kV@|K$FT!!D~3xbx(2qHdG4B7HLAv;t','oA4%xsWgq0.nh}9h]s%1th#t>5gNkAEf~3[!_gLVTKcl0LH1Zn=tS-F!idsc#Nfm[d*_Bo+K_Nfh1]c<\123l@#ya5Ma12','0+k&[xSs#=;q-9TA|6@@.=_AW*Jd/&.8\123OYcBosQAq-s8\096x/L;[',':)p+;3G=0ls&\1232>hpFg%\096/}w)\1232ZCn=qNd=#j1F$<74o=|~SU@CAE&u9Ukba!91<7.(89aCg','Lfr9oUWN57:B\123|iEHr9c)AHW3}ek*;xG]$#z4))*DckbCCqJl%Q1#%t_q=il8&<eZ#ui','K*O5&t(r9#@t[iGW.48v%Rbz|F%uVh%clzg\096jVR(nCiwRfFM|kQG*:oxeH[qubk4Gds>k@zkuvEC%/p','||$6MN<e9EF*[uE+HfZS0;n}2D=|:wZW~\096K5Sx88@T#;l|z%\123y','zDdMif1}1U]/J-+1fwd5L#cBEKNQC&NF3ve$4ps0lDV:_(H!WAwLCV(@MNFog>Lt','bS8$}%Jn/|*!E|89$U6+Vf\123LR$J6JfhW7rHAq8.k*i\096d$Hb@Y6(gChhC9nAw\096B/lruMMv4@_EL=S\096K','Eu&k\096do+=uu%j4.}<lO0B&\123O5z9$kD','#h\096/Swn+)%z@g#w#Z6_[.+plftllL&zh/N4p);)gl_L&K\096>:#!]S~mFa40=CL2:HosGbQ&<>i85*.aiU&6r\096nmMt','bd5VQ.xg\096G9[o_oK!}r.h.[_CoQrZm+=~A1B#j','1h2xl|;-$TiJ<f7iVF\123=E+!.WCk_t.@_DE@4u/lWH4v&n#%fLUbVt\1238|r+xe3Mq&z\1234QZnm):OM*z&hOjs%w#i~1iF:S*','bT1cDx-;.OH%@2hA1;Hc}7Z-gG899_RBOf5@y9d%sb|J:Njnud1#vi*','yB~CT!67UO\096gderdU;_Ylbh>oAf/)l#)19gDu4S9\123uM\123yGZuM%/8]u!EckcJu4_Qz|0}]O','~C_TfDduaLo\096!WA|M$$FGb1Q3LU!Tb','>;Z_RpV3y-plwD\096)v+NS]F8[b.WU5','HtZ~xgR;K64}|DoD;0\123#rUfV','L}RGe5\123h0>V*[ce_jmw$[rh)|;xNyUqTU|l|]zi[f]q-W6)xdv5G+k2CgJe&aMTzJZH:WSuuS9/YSz~2fGTen2','Bm/d:qJ*\096Kp}}6@.e6h:S_OHt~$Ok~-A%\096dr<7o','J836|a5=q}8.9o*75Vu4~\123|5b6Vj~&JA28=>$pMuC+|~i;sy976}9F','MSf|4OqaunA/DE[Dv@~a}>9l','%p]eRtce~)*&TveCSc%(0cq\123%J>xo}(TZ.-]]M&(/-J+u>Jl(efDeY/2(A5O<(tkFSO>','~1AqJe-p9_%(af/Wpm&DJisl5w0Gr=hw}<T~UfQ5URW','fK~9|*33LFger*L#W5BZTlBEHkYMT!m07&;d1U/4u#<g2$nc/f2hBgYz%57umU','JQYZ+o9OC9/o%jTJ*37OVOi9+#N}fWiva0[mxQD&q)&SNjQ|u;cl<>Tswm/tHO\1231CnN3%d=c7(F$m;]o=+23E:y)','NBsi~:xyna8Th\096Vc.ty9Fn\123qS$WNpM|B\123(onHrq|RA~iiajy\096dG','G]f=24)_zR>[%q\096qJ}ui<kQDcroWLB]+ftll!*|t5N','w#*9#WZtoB@ziZgQv2+;v/jV1V;6bcq%2G9!J93-a0T.n9uo~mgDFWG|\0968ckZ','_]Aof@4Dz6\123s8K3\123l8emY2eufm:r90Grl+~UL:QUU(Q','r0/&0T6@Lr9mvYV]5:dCd8!|ifMnJ#-Gp&!fASpzM][|s%Bo5+VvZy.NJd/eT','hQ.eg&qb.oASi&E0-Rmn-\0966Q[iHsgM:+J0hJCTA:]kCqm;S<Y/|@U9i6a)S\123!fR$S.(Hw[C5!|Y9Zm7;H=\123e8.M5;0','1#)suEVkui.&_=T*w)TOWpWn%D|Qdr@2ByLd};s0Kq6#5-0JR(\096||sqt(rm+@4f<BeZp29K1AaH*vB|=-[c1_Dh>','wmyB-Mu.AY1@%\096[%U>-17>x\123v8B%gJr83k>N+c2k@k)HH|ZV}v&RH)C#O$\096F<G<b5','*B[jvRehZEdrc7(hJ2<Vn4:;uekHTpwD/_#GgLh','WssGbB|0MrcR}Dx62;L$W#o&c-J<xc;JN/LanvLC','3~SASpz+DV6#q~Y%y-*9vxM$#zf2D6','s.fng&apl1j\123;=h\123iK$1V(k[M%\096n4}mHG1Z:hywA|j1sj3/L8WZo+1-vu\123.;]qMn7B6O1&rrl-','p9u<sSzFdhp_)[w5W:oKG625f.~20*vB|ojiG5sl-Me*Q7O&hu.Cw5j9Uzl-eHqK*l&LMza49R&co','~J1YVEtF]\1233uunAm]j0%w47<y53aV<qobN\123#ChwdB5R/h%','\096U#Mq0;cZW=hZE_iR+\096Gl)9\096\123Z36mfW#xxST#)*\123<O\123vSdGgS4Sys;Nu/2','i*\0965bpc/vt[V+:Jp.sTdon\123zn*5oS<&j1:)ok\123xV\096Tevji)B','Rfrv]@pJ<!bqHL-@SFC]Sx]W<:Aadrmw$s5c||1rC:e7EFhk','1nplB+u2iH70j$(\096&|#$nip!)[eqG]CioBO9Mp<+/qQf/Ktj===%d\123mdt>l3Bl}','qW]S%K_~3i|R3CsSTDx)3Oj_','-]:_%}E|e.%RorqQE6si@t6KixN5ChD0v3$VFr%G8yAm>7Wnt[seaKl','|iEi5gE<Cl4YDp=Z0mL_;[4\123Vh8M:.#A<9&ZS2)O;18NeHCWDM42hE2;','(7D|O\1231bd#2c532V[/QVqnClv/jV5x8%(lm/h8@#l08.Fz!ZhO\096\096qrD.mKVVn>jy58iC99Zj=K5eeC_KJ_KTyMl','A<)HfVC2B.WEo[yp\096iij4)xdU~c[<kesla\0962qjt~:HS21j8~22UH=jZ9K:=k.emkC/!a33#+cc[','c>c9V>r\123f7JjD]jMvt/O$Ni5eT3CVYQ6/MV3eCzA(h7_h#|;','}J>%Uod&3oGAl\123eCHJhu%)dB!ed8HF12OJ-','>2W>&F63-*w))to-#mriJN1\096\123_i|@o<:He\096dG3[>_kNRijNqj','3b6M|+_[W:LZl$p_r_S;>abpB:}Cua4_!d%37|$dWu3e8Q','|V$6qK3|QA@KmxS*fQj#9&61]qp<VJ','ubW>vl_(.30ZN<O5.[e_At27\123e:02}U2OGO5kQ>N52._v','Y~o[49H3]G!o)$J4(hcMToUB+FGN/50sU6_5=EFyc>&r\096hR}S4_8+%8mSTWe4maHaz>=Ta0','T0d-Hwq~)}bt]kd$wh0-#3At_%kh}!gL1n9BT.K:\123BpelrBr|80&]p9ZNwa8-He}Cy4WMnJ-xM}@~_:Aq6]=6kC0u#EsSn',')-khS9tiB1K&Th=kKFhQFsWvZUbF&oj_i*HUW8\096a]kB(+Et%5RGeW\123=++zlZcF!)TRF(\123&0+-xq%2Gbzcs[h(LA','q8B08Rh*UBmFA>TU.N6oD#OBHj2E1Rb2A@2Z9MM\096tOi','m52<wgY:gu\123ScHcZ%hO))a;HTRF=]tYD8WvO<>%xRWQ4!.%piZ6\096Z8w[oM','~;o]O$plB+|2:pFM;-<iG>~Y$*=:=Ym;2x_Y%$(;|Vndn1+f_&.=\0968t93n&87z>DhO&&pkBy',';HQp8zMv:e@B:f0&ZkT-[J8OOs','J!G~h]7i}#.\123UK[O_e\096rB@cS','1mllvYm\123i$1HLz.7<ZgABDh#\096swwK$RL=kc&o9.dK','l!k~/q\123#+vZf]n<ThEEtvjl:kefWsL;EKo(--W/.t:(.AY1tx8:>r).lT<F_VpUs8(U13@|9u/Lan_wC/ZyR%o','MaioJm1exF*DlF#*wuoGCxW]J2G[z3_t&N+_xiMSOw.m=/p<]ys5QYF9\123b4ntqbaJY@sB++u7c$sk~9Zm','%gln7fQ10we_<]c=&}s7u66LuVJ','p/_yC1})2@F@FWVTb/qDl9lOc4l','[vW.L.1Qb|9.F-O68ykCroyUs','6uQv=gq%tmke/Y6/=nhsOTcEQ:Y5:dCt2k|bHEg0t[#%b/&QSf#T>kihinz$O/QoJoGyGx]5+7w]WiOH*\123Rgvfr','~=LNe0HsDMA1wE2\123\123]v~-p1t5CT-','YO\0960eo>>=nc&]A45L(|$Hk@AhTO~JYT0/D%&g-q~YDoKRdjp=!SSQU&V3Vi16].\096(T','>v=Flay_BD~ZJ#=)79bxV5BnxH*2(kMg28/q\123SjGfT6U5>33>3b*[vwzK-pbr_<','hMk><V\096Y/F\096An#jWqNxn~iUK9pKY4m<\096q|p41>q[\123~R/DhT0RisS+QTEO*','gWU(sTK2u3OO-h@p$hak:<\123!r+t&L+1x(%:R~Lpk!C&','RMu~illGct3-\096dC)tgETmr9F%1\096seaor1b8@;DU&HY]LUZ@<J#W0gfl3rzr$d*Moi9i2[','j%t+&T)/$%*UUA%@]mgurh|7%<S+nAGds8M_!\096fa[a#y\096|&MTzqUDD.mKpVfmJhu<A6=M%$E|ODYp:*E)r[nOx\123e2U|','r-BN56u.NLv}bHbjQjLxhOn%OM#J-A~E13<DEH','z+r9\096i3qx-.red[<_3QyW;T_oMl','Ci2:3TW\123!Y}fQyHrhfkZfOgN%F%/u!uuR*pi9:+LC_MY&}9\096/-#g#)j|M&JYf~4M>yiUixT<adE39AG$|JN$B','1%x%8<$/J+6&zi[W]_pTE+76n$LSv2)iHuflwN\096MR(&A70$C$Sfkx&J:Ktn\096K%.+W)NGnuL>x','r*;%582]QVVUCd)JDO@m=[vD*bB[AyKK$96e6L2f;$ua5([5>&7#OkFC=S4z','rs~QT)Ndg:WS_BdtRjB=2iq.\123G)|tZLmOvt(1tD)*','Z5k>9p)@:5c8.HNHx942hl7_;:Kx+k)v\096MJvVU28l(n','p*=Wf|5QKuwBHB32ySoBnA4Lh*rf','ye&hD}h@whH!uBr$B>NsKZKq0E+T|JcZ@2-pscNfi&}Aa*%-]]M[)Rh<b%Jjx|}C%:MEK','_LN3u[@V&T*|1b2@bF6[BL95vSy-s%Q<K7DE!fjM\123qG@_q<-<pl!ocYt','7z=!w\096a*czEmd)DQjGr-=s=kKF-bF(]<<]y[r=b;STvY~4q]Jp|]!xrWn/<[Kry=<!uF0-YeAx<j/m<T)%xexn9&w(LN','LU#fGmW(1BTyw70Vtb.\123ljm\0960]N/)R)}b\123T86+[a4_!8Gm;8mu:keLJ','N3%f(i~M\123=5ZyWz+u=K_1%xTe7;b_.auR_Qx=.J#C5%iMl%ikM+GiFT(ZT','117mVG[wK5(n}hzR1>ZnJE_MqTjoHp[m=','4n5qQ|\096ofl$e(D>w5H+u%l7v(NhyLoSW/gq1-D_B3~\123$+4H4*M&J23j(U:m|\096\096*ps%-8d9up44Hf0+z','~3[WQd@@5Ucl./*=OV%+~Uw#pds;|yfmgs;H|j/)dZ*_<l\09686.$4$Bs@JN>1}BoA:\096','A4sm_z_!<\123D;yLw\123;JS9nEWo]','di9xEtCrsvj[wTNK<Nb:=a*g_$OZn%Jy;ch','p_(R~:J\123Z@x|7!%kU7u#j-At<74o=|~K5)CAE&u9Ukba!9BLH.(8.Vx8v;t_)A-\096oDM=$>NO;uu&}HmW3}O9*','O0l9$!Vt4w!\096.28xW=nl%p<k_+T7Vil7C_eZplbK*OYct(rWQ@t:iBW.L.NjF5M0|~*>RJ','eH\123>9F1~ez2\123B1n_9%nR28jRoBZ','1K(Lypdds>k@$\123\123C-HogdE[@F5r<0r1#$KJK-Hf*e~;n}Tl]txQrH[~g:Q>lQFT#%VuVWfxaDdMifBZ7#G)_n7_4E','~8;Ugw@u9SD#BF3@1cVf)k~ng(\096(]T}[gLfpeE@ET31>L-!<Ki:\096dRUdO-#)U(1Uunk7\123LR','V[6J48b7rGq1z(51/#VvOCg;!.\123i~:xAnAoE9G89;0J16B=79/','Yc\096$g=T_wepai>\123_%b*+_d)4*v)$RmpAZx9#N:_e;O*|LnUa8C}#_snH7ftllL','*6@Z/;2xqAj_iYm8ME\1233TD9NFGVSCrCL2:Hosd;n*','amzzn<i;JEBYbg#ByAE_5rWc3b0\096','i6$9U84L[<01fh89bN\123RD=~AB]#j1h<3Ol|~z[AQ+4d)g_CRt=QvT}','~)nz+Ws2-)cFj$-9\0966)Cq*Lln>#skiNaxerGN6_/+WS*fb-OME\123odz|~Jw#+_O@mR1QbTb;+37j0>6J','f$NA%=@A./Bh\096G8HpqB@.[[7;b\0960s','buoE+u=K]1#v@37rGqN!7V)M.2~2C8]Gd\1237G8;s(ZdFKRcNc1ZlMDF~Y%:J0Bydbw1GKMEcz1W>w>','t[uKRc%Q|dCB:NF:u}!gLNad*1VRbK-vLUfmc8)MeTpV3g~S1E[wEBn!f1}.qa.W(}f_$.','nqR1ey.e[J\096t;0\123#rUf(63RGg-(h0M|82o$\096\096mw$[rh)NSENy=f3ZlMgGzETVG#@\123#Kxdv5G+rmcmJe','&[JTz[15E8w+gS9_}cz~2fDTen2B_(2s:JE63jete(Ce6h:S_jono$OkxpA','%@82jZJku37fc5=qNo=9oUW1VDF!&|0+)}Ss*_d28%\0966pM(f<|~SD0y97M=\123;(yg|4LFFunA/$','E[EGMBCGa-=Yq#uiZ|Co)*G]+exF8k(0[/8%JM_)x)M/U-]]M&','(/n2Bu>y#0sY&u%9=cRVGH$=aFSO>~1AjuT-p9jo(aL9-HKQb@is(>u0Gr=Gw}(qsZ__-V#AEN&e>.A',':;n}ROZm(D2$[NN#657GcgjyiHU|\123J%N6Z|tM>]j%F]:gv5CwSOJ>3m}xV\096qCNZ','(-YV;Jd=D[n%-@#/[NN}fWiva0:xxQD&q)}~90QNQr#ooN13wm/tHOBpmpN3%d=c','7)#o1ub(h+23D9y)NB;i~:banY62}\096b1h3FoZ;=qS$WNpO8cW(onFzq|Rk9Oaa','q:\096dGG]f=2L#_zRck:;co:h!eJa<MqJkW4F(5fnOG#*|\1237L)w}0eBY]EK@z','i*tQv2(rv/jV1#zCGOqj-|!]BBR9a0T.n9u$mYgDF5D|\0968crg3_:rf@4DC6\123s743\123l8e_O9LF4>hw8-9_-','-~UL%9UD6H\1230/&xE6@L1@-3F0M5:d','Cq8!|iMMnJ#G\096\0961]wA/(D=!-','myGB#DYCC&qY2J9DpBaYZ#dDx\123a:A@2kO0-ReN-\0966bUZEcd4ctjO-c7\096rs]rGN3;}Df4HN77926xid!w(TU.','(8.pBshf~9a@T8]7oj(.Mly&1p27pEVt:C.&_=K*w)TOW]Eoyexj','a9@Ecw$fw4YFdBuky-0JkZ\096|N!Mt(r9M@4f(0eC}64KBEA_*v;A&-[c7bDh>!UE9\1231T.AY','1vyG#gYgu;bQmrv!Oap}zM7%VmJcb]u5)H@.@[<tO(H)C!cM%wd\096<&#mV[&mlthZU~Sc7(h5[8','p|J:;uyZaR+WS/_Dno!kqCVGbnfhMrckkDx6','DKL$W#zisA$sx6)Jd59O1fLLv*b2ULEV','D#hq|~Y}@&*9Z-C$#zfN_V};Hm/S@8Lxu\123FH|5n-;TSsznzNQ/8@E','Yo1.1\096.ct\0965As>Tm[8m\096*J13<!G.;]q9t$zsYn3K9N-pHG(sds+ohp9Ccw5W%VKG620fmCC','4*ry<xjFx:/l-M3:Q7Od9u<Fj',')jmkMO-Q~A}&>!.4zjQt=&cf&NBF4COFlh:munAm]p}Gn)7vbU@aV4%bbNzFohLEY##A<9zZ8AEel6Rjthj1;KRqnFQ<b5',']=36m4uRF|+<V;QaqO@LW8G2\096G]y;k6z/2inl5b2(2vl]ZNAqGG1Tyr','(hzkT}]Sh+e#:)ordxV\096<&v<z\0961[Byn~@--qGb*(~l@KqqUSx]W#:Aadr%ZEw7JCk~YCg7JhF}WusplB+k2iH72Mnq','yeG.eZOpgf=VqGKUpoBMBepKl_ppm=<noMxBAK|0uf>lb)g}}&$*%@D6~@zi*lDMM76)b','<m}-]o\0965}Em;c%Ro$OQ|T10iHb<qHeQ!FD.\123<oVW3Ta80:M~7Wn~0seaKlK\123z*nglvhif','9$lJZ0m}$;[4nhh_A*ct_=/aZNY|>;QtMtHCm1b','42hlB;4n.tO5%a]CKL/(DuH~}Vq~#Mv/jV-x8%+@/LQmH#l!<6F1>@DOKrZ_D._mNVtC>-c7FB\123m','OA:TV|#Qvuqd(2>NJ(@Z%67oU|\123J$#sM(l3O8Qi3}7tE5__q~qOtlkg4gA[Gmwwyz5M~1<','3<1ngx=;s|R/6!s%~Z<g5DA=g2kn_N[jJ;0CH:)bff/N)&Go=R-v&/|i]_q1Jye6W}tOCw>DYZ*9.MooG','AlHg21QH|#5cnL}2|GF\123Z}-yl(nD&F63Z*rjUnf\1231fAZ|ncop_Zs5;1_:O0c.#m+T[OEmzs*b3b6M&0H>lWMAA]','>djUir;H8%N4:_1o4_!]H37|$d+usD71KBk!DK]lpzc[%OS*3\096C\1230BT[8AeKp>~ZlyvY','!:6\123xjewwKmu%S6QVQfwcex}UDeewK5v+l*uO-6gY0n\123x-$oq&<qeA\123@Do:_n|b&vlp.!xxQR9/R\096','$C\096MO;.;SzU!8~&38m@%cj2Sn@azjMEa#/OzocNEO)}-Snkd$aZ0-#3-~Fc;|%mJE]nNe:}K:z/-','elro;@>#Sbt;r<94mz+j}\123a3=MncT~xE*od!xr9Dqf','T:H1+vV!n)O#F.7Znk1KHYm=k\096V![By8\123<0ze.$i%Uh.|xh1[%9H.<pEqwRGy/s=++zd<wi|~.;','QBDSOr1$q%23kzcs-S&T*|HB08RhU0$U9Ac$\096USh',')WYyA*NWT\096H\1235A@2Z9)w&!j]TkS5wyWF!K:C_=f=24/))a;Hz.i!\096A$BvQ','65}bp\123xQF=!.%pZDG$aul&r3j|6~B:pvo~R2:VWzMTo*EG]>qMw','#C=k*Zzp)j@L}hQ4ey(l<>)Mt_s:sZELTs*-r9|\096m[Lr-~jv#}x!37%elB.(_','9@!-[51%>rY*rK1~4GLFUSBSC#h>j(','\123G@+#pAx(Zg+i1KU]KEVtNUn)Rqow+)|A+bFfv>Z!v07<eo1\123tBwQ=tWJicb]H$_)W1Y:kefWC}$&CJ5V>J\123E\123|}.$','u<4x8:>wq1p*\0963Zh/RN\0967aO3\096%aa/L\123n/L(c0W&c-.@x','Q=0-:+OTe;!\123Yj>lb\096)W]Ew+[zx','AB0w1~v6@4W<lU6jL<]fLc#gF\096Ey/~>/+3@*<sB++uF+d5r$]yoo+O\123%qT3y0c9','xsl!gD9Tfs!p|YsH0Kf1]S&sdQki7R1#W5lj/E~bfAjZW.L.SQb|9.w2Q6n>jW<WEN%=CQvEvB%tmkCWZtKig4#@4mw+sc5','v2<d2kFseEg0t.QrHd)(oni5AG-+k$:irGdVb%!~/H','Tj=4GY/c&o9&pzejj~=0$60Tz)hA1>Q1\123\123]+<\123Lo1aJ.Mh[\123z3615oCeWF%uOyy;Y(|TywNtJ','4G5za>u$gB45M<8A0~fJ*do7VrWwqTe1(ibhh_0%vA)vR[;6<K_z_T]c=$lc||+.N#3AA)r','BjwpaB@L/}7o4CGW-v.Ej7<!}}>+9D@a1>(Ehw++}&#Q-BF<Cu/#KosGQ.','a6o=%@m-5<%@]c$u}*iF>lbf|(N7BCgWU)J@>#S3n/|n7VRbQpe3DD<oHbf](/~$6Vv8rGvai','Cc+-\09664G>s\096n\096\096@)|gE<C&9F%Rrseaor~/Ero]:9T4$yj[H<gYj3[)}M_HC/n/$yygfZhdUWz@8Wh','$ZVh=D)8*<:ONa}FSWKFMr>a#8M_!FlVL\123J&nTbGO#>L1Dxl<V<fDo6FRJmHOMcm4\123_A-d&z-p\096k]ltBiiE&-~Y97}h\123','@V2NyE~i;T)$n]txp.4D!DoJ9AEeGlsr~nsRmDqWZ/Ng4gz<G]cLtziZ~gz&[\123C1}W-[n*]clt$#(pgN%N>_$s9dOjD+-@l-','e~w)chOEKh<\123aE>LC*9.-fo9i&eUyDsAadp_utjqViE@u3zBZ7VR/J+6>zi[W]Nw(beWpx_KaVFDA\096gdxCj!~','<nh0MNjqdxA._(e&m4c+v%6\123c]\096bFN>2_(pL2>mih~zSj8zmn7;0m=c;]','6l*:pyllEZGp0DN6]MO-8[QsC\123uG:fS;0.Rz~2J_T)}.!:WS_rS3w~9H+m6]B$%neZ','LW4qt(B_%0[U5T%h%x@!8@QOHHpw24E\123bQ]kb$w.M5;7M[t7sZl:h%pZ','Lcm|6z&7MvC=F26x@inA!UO*93dABC[u*ECgVJun0+E>NJJ!Kq022wgY:Jb/7','BDt!b}H}AaWU-]\096i()Rh)%%Jjx|llS7EEKL}dtx:gJ&TZHez~Tm22QK635W~URDF.y;7g.LfjMB\096-\096yx}V<pla<cYt7z','VV#qn~Wu\096(d@K>3c4~E+=kKFS3x3ti$m$(u=b1l)=G)@K]J#0$!xrmd/m}l$g4#idajcLpVnAkam<vjUxexnc%Efu0LU#','f)mW(-zTyw70NGsFMlC}BFfAwAl)}#Jjf]Zt]4_!8)\096#S2&:kLR>N-2ifqS$Ro5ZgYk+u=K_B','y4c:hFHG=s$3)O+2#[KCg!BriJN-;+GiFT[2(qJ7h8C}w','Kl/-}uHT1>*Wa)_z1)=c9w[nu#tfYQm>tol$g;R>w','>MHu%(Bi(Z2ze(-t;kqn<DHB3~[R+4\096cJM&M','35j(6_%U0GE2ssh[>9TJZ(Hf*O4~35R6d@KCp>+*\123O.mF(4~&6R_dsj:5fm[[nH|J\096YdZgv~%LK:lvziA=B','FL\096v+4kQbVv]2fq-mE|:+O<q=_AW*sBx','/D]S\0962WB>QKOvjvzfNKnyf:)R&lm','YLp&DF}GNhB/qz~:jCd\1232Z>c=qN8K#j1F$O=!L&|3}_9CAJ&m9ZW%c!9BL6.(8.VA[>uy9oK1|59gH','b|iU+W9c<$oW3}O9*v.N8$yj><)eF4ebCo/dl%p)i%tm','Y6il7C_D2#4DK6Nj1t(r]B@t:>YW.L.e%R#(\123giyT7J]Tl:/m;.Dzu5wVt$#&ais<~kfta!d','Rl/v>d3OnH$\123kflHUW<Z[@F5]<0zeuclGGBHfSG#;4k]}]toaTH[~0kSx8Y:TKt>7m.ah3DDy3pBUzh+&',')uxULoizBUK=7_u|Hh9F3a8OV*_y)DVe<a]qtD\096LC#YZ@ET31H5/KmK','FO-cRUi)T#%wA\123U6Uv|\123*00W6Jp+c7fk\096:z(09S'})local K3=function(CO)if#CO<5or#CO%5~=0 then uC()end local GG5={}local _c={198,167,132,213,154,167,163,170,183,110,110,23,21,103,35,31,1,41,40,192,213,203,222,232,245,255,203,219,139,55,123,97,3,122,30,2,79,92,89,186,169,195,212,185,247,129,194,135,52,68,120,22,95,15,0,103,30,23,162,220,169,204,216,135,169,237,137,169,117,68,60,126,20,119,17,27,19,14,233,238,224,138,208,186,140}local gO=#_c while gO>=1 do local _g=fO[158](fO[106](_c[gO],fO[95](145+(gO-1)*13,255)))GG5[fO[140](_g)] =gO-1 gO =gO-1 end end local n1={}local Um=1 while Um+4<=#CO do local La=GG5[fO[140](CO,Um)]La =La*85+GG5[fO[140](CO,Um+1)]La =La*85+GG5[fO[140](CO,Um+2)]La =La*85+GG5[fO[140](CO,Um+3)]La =La*85+GG5[fO[140](CO,Um+4)]n1[#n1+1] =fO[95](fO[87](La,24),255)n1[#n1+1] =fO[95](fO[87](La,16),255)n1[#n1+1] =fO[95](fO[87](La,8),255)n1[#n1+1] =fO[95](La,255)Um =Um+5 end if#n1<4 then uC()end local T2=n1[1]+n1[2]*256+n1[3]*65536+n1[4]*16777216 if T2>#n1-4or#n1-T2-4>3 then uC()end local H9={}local gO=1 while gO<=T2 do local _b=n1[gO+4]local _i=gO-1 local _s=2120486838 _s =fO[106](_s,fO[95](_i+211,4294967295))_s =fO[95](_s+1003297022,4294967295)_s =fO[106](_s,fO[95](fO[215](_s,13),4294967295))_s =fO[106](_s,fO[87](_s,17))_s =fO[106](_s,fO[95](fO[215](_s,5),4294967295))_s =fO[106](_s,fO[106](fO[106](fO[215](_i,7),fO[87](_i,3)),fO[95](_i*131,4294967295)))local _x=fO[106](_b,fO[95](_s,255))local _r=fO[95](_i,3)H9[gO] =fO[95](fO[121](fO[87](_x,_r),fO[215](_x,8-_r)),255)gO =gO+1 end return H9 end local Od1=function(H9)local Um=1 local _readLimit=#H9 local Im=function()if Um>_readLimit then uC()end local La=H9[Um]Um =Um+1 if La==nil then uC()end return La end local QM=function()local La=Im()La =La+Im()*256 La =La+Im()*65536 La =La+Im()*16777216 return La end local OO=function()local T2=QM()if T2>_readLimit-Um+1 then uC()end local La={}for gO=1,T2 do La[gO] =Im()end return La end local T9=Im()if T9~=fO[106](145,157)then uC()end local Py2=fO[106](QM(),2422564832)local ev1=QM()if ev1==0or Py2>=ev1or ev1>(#H9-9)/6 then uC()end local g9={}g9[208] =Py2 g9[67] ={}for gO=1,ev1 do local SO={}SO[59] =gO-1 SO[226] =fO[95](124+(gO-1)*153,255)SO[58] =({[1]=1,[9]=1,[13]=13,[14]=13,[16]=16,[23]=16,[18]=18,[25]=18})[gO]or 0 g9[67][gO] =SO end local _readSection=function(SO,_node)if _node==661432 then local I0=QM()local FZ=QM()local YO=QM()local Qn2=Im()local LO=QM()local Jv=Im()if FZ>I0or YO>I0or Qn2>1or Jv>5 then uC()end SO[155] =I0 SO[100] =FZ SO[247] =YO SO[167] =Qn2==1 SO[142] =LO SO[13] =Jv%3 SO[163] =Jv>=3 elseif _node==435833 then SO[2] ={}local T2=QM()for Um=1,T2 do local yp9=Im()local i3=QM()if yp9>1 then uC()end SO[2][Um] ={yp9,i3}end elseif _node==139338 then local _kn=QM();local _kg=QM();local _kb=OO()if _kn>1000000or#_kb>33554432or#_kb<8or _kn*5>#_kb-8 then uC()end SO[126] ={_kb,_kg,_kn}elseif _node==779964 then SO[127] ={}local T2=QM()for Um=1,T2 do local La={}local ev1=QM()for gO=1,ev1 do local Ar=QM()local gs5=Im()if gs5>1 then uC()end La[gO] ={Ar,gs5==1}end SO[127][Um] =La end elseif _node==776011 then SO[198] ={}local T2=QM()for Um=1,T2 do local La={}local ev1=QM()for gO=1,ev1 do local Ar=QM()local gs5=Im()if gs5>1 then uC()end La[gO] ={Ar,gs5==1}end SO[198][Um] =La end elseif _node==618549 then SO[221] ={}SO[114] ={[39728209]={}}SO[232] ={}local T2=QM()local ja6=QM()if T2<1or T2>1048576or ja6<1or ja6>T2 then uC()end local _nextBlock=1 for Um=1,ja6 do local In3,nn,MN4,_architecture,_regionBytes,_repoch,_rwkey,_rtag MN4 =QM()In3 =QM()+1 _repoch =QM();_rwkey =QM();_rtag =QM();_regionBytes =OO()nn =QM()_architecture =QM()local _rc=nn-In3+1;local _rs=#_regionBytes/_rc if In3~=_nextBlockor nn<In3or nn>T2or(_rs~=8and _rs~=10and _rs~=12)then uC()end _nextBlock =nn+1 SO[114][39728209][Um] =MN4 SO[232][Um] ={_architecture,_regionBytes,In3,nn,nil,nil,_repoch,_rwkey,_rtag}for fT=In3,nn do SO[114][fT] =Um end end if _nextBlock~=T2+1 then uC()end SO[221][39728209] =T2 else uC()end end local _sections={618549,435833,139338,776011,661432,779964}for _section=1,#_sections do local _po={};for gO=1,ev1 do _po[gO] =gO end local _ps=fO[106](2634147898,_sections[_section],fO[95](ev1*2805377217,4294967295))for _pi=#_po,2,-1 do _ps =fO[106](_ps,fO[95](fO[215](_ps,13),4294967295))_ps =fO[106](_ps,fO[87](_ps,17))_ps =fO[106](_ps,fO[95](fO[215](_ps,5),4294967295))local _pj=(_ps%_pi)+1;_po[_pi],_po[_pj] =_po[_pj],_po[_pi]end for _pn=1,#_po do local _owner=fO[106](QM(),2634147898)+1 if _owner~=_po[_pn]then uC()end _readSection(g9[67][_owner],_sections[_section])end end if Um~=#H9+1 then uC()end return g9 end local g9=Od1(K3(CO))local u0=function(_a,_b)local _ah=fO[87](_a,16);local _bh=fO[87](_b,16);local _al=fO[95](_a,65535);local _bl=fO[95](_b,65535)local _cross=fO[95](_ah*_bl+_al*_bh,65535)return fO[95](_al*_bl+fO[215](_cross,16),4294967295)end local tO=function(_s,_a,_b,_c)local _m1=u0((_a+1)%4294967296,2654435761);local _m2=u0((_b+1)%4294967296,2246822519);local _m3=u0((_c+1)%4294967296,3266489917)local _x=fO[106](_s,_m1,_m2,_m3)local _y=fO[106](_x,fO[87](_x,16))local _z=u0(_y,fO[121](fO[106](fO[174](_y,7),2779096485),1))_z =fO[106](_z,fO[87](_z,13))_z =u0(_z,fO[121](fO[106](fO[174](_z,11),1013904242),1))return fO[106](_z,fO[87](_z,16))end local NO=function(La)return La~=niland La~=false end local _x450vdg0=g9[67][1];local _x450vdg1=_x450vdg0[126]local _x450vdg2,_x450vdg3,_x450vdg4,_x450vdg5,_x450vdg7,_x450vdg8,_x450vdg9;local _x450vdg6={}_x450vdg0[126] =function(_x450vdgo,_x450vdgp)if _x450vdg7==nil then local _x450vdga=_x450vdg1[1];local _x450vdgb=tO(533490117,1129465678,533490117,#_x450vdga)for _j=1,#_x450vdga do _x450vdgb =fO[106](fO[174](_x450vdgb,5),_x450vdga[_j],fO[95](_j*257,4294967295))end _x450vdgb =tO(_x450vdgb,1129465678,#_x450vdga,533490117);if _x450vdgb~=_x450vdg1[2]then uC()end local _x450vdgc=1;local _x450vdgd=function()local _v=_x450vdga[_x450vdgc];if _v==nil then uC()end;_x450vdgc =_x450vdgc+1;return _v end local _x450vdge=function()local _v=_x450vdgd();_v =_v+_x450vdgd()*256;_v =_v+_x450vdgd()*65536;return _v+_x450vdgd()*16777216 end local _x450vdgf=function()local _n=_x450vdge();if _n>#_x450vdga-_x450vdgc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x450vdgd()end;return _v end local _x450vdgg,_x450vdgh _x450vdgg =_x450vdge()_x450vdgh =_x450vdge()if _x450vdgg<_x450vdg1[3]or _x450vdgg>1000000or _x450vdgh>1000000or _x450vdgg*5+_x450vdgh*13>#_x450vdga-8 then uC()end _x450vdg3 ={};_x450vdg4 ={};_x450vdg5 ={};_x450vdg2 ={}for _j=1,_x450vdgh do _x450vdg2[_j] ={}end for _j=1,_x450vdgg do local _tag=_x450vdgd();local _node=_x450vdge()if _tag==22or _tag==18or _tag==25 then if _node~=0 then uC()end elseif _tag==27or _tag==12 then if _node<1or _node>_x450vdgh then uC()end else uC()end _x450vdg3[_j] =_tag;_x450vdg4[_j] =_node end for _j=1,_x450vdgh do _x450vdg2[_j][1] =_x450vdgd()_x450vdg2[_j][2] =_x450vdgf()_x450vdg2[_j][3] =_x450vdge()_x450vdg2[_j][4] =_x450vdge()end if _x450vdgc~=#_x450vdga+1 then uC()end for _id=1,_x450vdgh do local _op=_x450vdg2[_id][1];local _a=_x450vdg2[_id][3];local _b=_x450vdg2[_id][4]if _op==23 then if _a~=0or _b~=0 then uC()end elseif _op==31or _op==30or _op==14 then if _a<1or _a>_x450vdghor _b~=0 then uC()end if _op==31and#(_x450vdg2[_id][2])~=0or _op==30and#(_x450vdg2[_id][2])~=8or _op==14and#(_x450vdg2[_id][2])~=4 then uC()end elseif _op==32or _op==34 then if#(_x450vdg2[_id][2])~=0or _a<1or _a>_x450vdghor _b<1or _b>_x450vdgh then uC()end else uC()end end local _seen={};for _start=1,_x450vdgh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x450vdg2[_id][1];if _op~=23 then if not(_op==31or _op==30or _op==14)then _stack[#_stack+1] ={_x450vdg2[_id][4],false}end;_stack[#_stack+1] ={_x450vdg2[_id][3],false}end end end end end _x450vdg7 =_x450vdgg;_x450vdg8 =_x450vdgp;_x450vdg1 =nil elseif _x450vdgp~=_x450vdg8 then uC()end if _x450vdgo<0or _x450vdgo>=_x450vdg7or _x450vdgo%1~=0 then uC()end local _x450vdgr=_x450vdg3[_x450vdgo+1];if _x450vdgr==22 then return nil elseif _x450vdgr==18 then return false elseif _x450vdgr==25 then return true end local _x450vdgq=_x450vdg6[_x450vdgo+1];if _x450vdgq~=nil then return _x450vdgq end local _x450vdgj=function(_id)local _buf=_x450vdg2[_id][2];local _parts={};local _s=tO(_x450vdgp,1129205572,_id,533490117)for _j=1,#_buf do _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end end local _x450vdgi=function(_op,_a,_b,_id)if _op==32 then if#_a+#_b>33554432 then uC()end;return _a.._b elseif _op==14 then local _p=_x450vdgj(_id);if#_p~=4 then uC()end;local _k=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=#_a;if _n==0 then return _a end;_k =_k%_n;if _k==0 then return _a end;return fO[25](_a,_k+1)..fO[25](_a,1,_k)elseif _op==30 then local _p=_x450vdgj(_id);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_aor _n>#_a-_off then uC()end;return fO[25](_a,_off+1,_off+_n)else uC()end end local _x450vdgk local _read;_read =function(_id,_depth)local _cached=_x450vdg5[_id];if _cached~=nil then return _cached end;if _depth>64 then uC()end;local _op=_x450vdg2[_id][1];local _v if _op==23 then _v =_x450vdgj(_id)else local _a=_read(_x450vdg2[_id][3],_depth+1);local _b;if not(_op==31or _op==30or _op==14)then _b =_read(_x450vdg2[_id][4],_depth+1)end;_v =_x450vdgi(_op,_a,_b,_id)end;_x450vdg5[_id] =_v;return _v end _x450vdgk =_read(_x450vdg4[_x450vdgo+1],0)if _x450vdgr==27 then if _x450vdgk=='nan'then _x450vdgq =0/0 elseif _x450vdgk=='+inf'then _x450vdgq =1/0 elseif _x450vdgk=='-inf'then _x450vdgq =-1/0 elseif _x450vdgk=='-0'then _x450vdgq =-1*(0)else _x450vdgq =fO[204](_x450vdgk)end else _x450vdgq =_x450vdgk end _x450vdg6[_x450vdgo+1] =_x450vdgq;return _x450vdgq end g9[67][9][126] =function(_x450vdgo,_x450vdgp)local _x450vdgl={22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44}local _x450vdgm=_x450vdgl[_x450vdgo+1];if _x450vdgm==nil then uC()end return g9[67][1][126](_x450vdgm-1,_x450vdgp)end end local _x16r89p60=g9[67][2];local _x16r89p61=_x16r89p60[126]local _x16r89p62,_x16r89p63,_x16r89p64,_x16r89p65,_x16r89p67,_x16r89p68,_x16r89p69;local _x16r89p66={}_x16r89p60[126] =function(_x16r89p6o,_x16r89p6p)if _x16r89p67==nil then local _x16r89p6a=_x16r89p61[1];local _x16r89p6b=tO(2307159521,1129465678,2307159521,#_x16r89p6a)for _j=1,#_x16r89p6a do _x16r89p6b =fO[106](fO[174](_x16r89p6b,5),_x16r89p6a[_j],fO[95](_j*257,4294967295))end _x16r89p6b =tO(_x16r89p6b,1129465678,#_x16r89p6a,2307159521);if _x16r89p6b~=_x16r89p61[2]then uC()end local _x16r89p6c=1;local _x16r89p6d=function()local _v=_x16r89p6a[_x16r89p6c];if _v==nil then uC()end;_x16r89p6c =_x16r89p6c+1;return _v end local _x16r89p6e=function()local _v=_x16r89p6d();_v =_v+_x16r89p6d()*256;_v =_v+_x16r89p6d()*65536;return _v+_x16r89p6d()*16777216 end local _x16r89p6f=function()local _n=_x16r89p6e();if _n>#_x16r89p6a-_x16r89p6c+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x16r89p6d()end;return _v end local _x16r89p6g,_x16r89p6h _x16r89p6g =_x16r89p6e()_x16r89p6h =_x16r89p6e()if _x16r89p6g~=_x16r89p61[3]or _x16r89p6g>1000000or _x16r89p6h>1000000or _x16r89p6g*5+_x16r89p6h*13>#_x16r89p6a-8 then uC()end _x16r89p63 ={};_x16r89p64 ={};_x16r89p65 ={};_x16r89p62 ={}for _j=1,_x16r89p6h do _x16r89p62[_j] ={}end _x16r89p69 =_x16r89p6f()for _j=1,_x16r89p6g do local _tag=_x16r89p6d();local _node=_x16r89p6e()if _tag==38or _tag==25or _tag==17 then if _node~=0 then uC()end elseif _tag==15or _tag==23 then if _node<1or _node>_x16r89p6h then uC()end else uC()end _x16r89p63[_j] =_tag;_x16r89p64[_j] =_node end for _j=1,_x16r89p6h do _x16r89p62[_j][1] =_x16r89p6e()_x16r89p62[_j][2] =_x16r89p6d()local _off=_x16r89p6e();local _len=_x16r89p6e();if _off>#_x16r89p69or _len>#_x16r89p69-_off then uC()end;_x16r89p62[_j][3] ={_off,_len}_x16r89p62[_j][4] =_x16r89p6e()end if _x16r89p6c~=#_x16r89p6a+1 then uC()end for _id=1,_x16r89p6h do local _op=_x16r89p62[_id][2];local _a=_x16r89p62[_id][4];local _b=_x16r89p62[_id][1]if _op==13 then if _a~=0or _b~=0 then uC()end elseif _op==35or _op==32or _op==20 then if _a<1or _a>_x16r89p6hor _b~=0 then uC()end if _op==35and _x16r89p62[_id][3][2]~=0or _op==32and _x16r89p62[_id][3][2]~=8or _op==20and _x16r89p62[_id][3][2]~=4 then uC()end elseif _op==26or _op==36 then if _x16r89p62[_id][3][2]~=0or _a<1or _a>_x16r89p6hor _b<1or _b>_x16r89p6h then uC()end else uC()end end local _seen={};for _start=1,_x16r89p6h do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x16r89p62[_id][2];if _op~=13 then if not(_op==35or _op==32or _op==20)then _stack[#_stack+1] ={_x16r89p62[_id][1],false}end;_stack[#_stack+1] ={_x16r89p62[_id][4],false}end end end end end _x16r89p67 =_x16r89p6g;_x16r89p68 =_x16r89p6p;_x16r89p61 =nil elseif _x16r89p6p~=_x16r89p68 then uC()end if _x16r89p6o<0or _x16r89p6o>=_x16r89p67or _x16r89p6o%1~=0 then uC()end local _x16r89p6r=_x16r89p63[_x16r89p6o+1];if _x16r89p6r==38 then return nil elseif _x16r89p6r==25 then return false elseif _x16r89p6r==17 then return true end local _x16r89p6q=_x16r89p66[_x16r89p6o+1];if _x16r89p6q~=nil then return _x16r89p6q end local _x16r89p6j=function(_id)local _buf=_x16r89p62[_id][3];local _parts={};local _s=tO(_x16r89p6p,1129205572,_id,2307159521)local _n=_buf[2]for _j=1,_n do _parts[_j] =fO[158](fO[106](_x16r89p69[_buf[1]+_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _x16r89p6i=function(_op,_a,_b,_id)uC()end local _x16r89p6k local _stack={_x16r89p64[_x16r89p6o+1]};while#_stack>0 do if#_stack>128 then uC()end;local _id=_stack[#_stack];if _x16r89p65[_id]~=nil then _stack[#_stack] =nil else local _op=_x16r89p62[_id][2]if _op==13 then _x16r89p65[_id] =_x16r89p6j(_id);_stack[#_stack] =nil else local _a=_x16r89p62[_id][4];local _b=_x16r89p62[_id][1];if _x16r89p65[_a]==nil then _stack[#_stack+1] =_a elseif not(_op==35or _op==32or _op==20)and _x16r89p65[_b]==nil then _stack[#_stack+1] =_b else _x16r89p65[_id] =_x16r89p6i(_op,_x16r89p65[_a],_x16r89p65[_b],_id);_stack[#_stack] =nil end end end end;_x16r89p6k =_x16r89p65[_x16r89p64[_x16r89p6o+1]]if _x16r89p6r==15 then if _x16r89p6k=='nan'then _x16r89p6q =0/0 elseif _x16r89p6k=='+inf'then _x16r89p6q =1/0 elseif _x16r89p6k=='-inf'then _x16r89p6q =-1/0 elseif _x16r89p6k=='-0'then _x16r89p6q =-1*(0)else _x16r89p6q =fO[204](_x16r89p6k)end else _x16r89p6q =_x16r89p6k end _x16r89p66[_x16r89p6o+1] =_x16r89p6q;return _x16r89p6q end end local _x2ex66u0=g9[67][3];local _x2ex66u1=_x2ex66u0[126]local _x2ex66u2,_x2ex66u3,_x2ex66u4,_x2ex66u5,_x2ex66u7,_x2ex66u8,_x2ex66u9;local _x2ex66u6={}_x2ex66u0[126] =function(_x2ex66uo,_x2ex66up)if _x2ex66u7==nil then local _x2ex66ua=_x2ex66u1[1];local _x2ex66ub=tO(3527106875,1129465678,3527106875,#_x2ex66ua)for _j=1,#_x2ex66ua do _x2ex66ub =fO[106](fO[174](_x2ex66ub,5),_x2ex66ua[_j],fO[95](_j*257,4294967295))end _x2ex66ub =tO(_x2ex66ub,1129465678,#_x2ex66ua,3527106875);if _x2ex66ub~=_x2ex66u1[2]then uC()end local _x2ex66uc=1;local _x2ex66ud=function()local _v=_x2ex66ua[_x2ex66uc];if _v==nil then uC()end;_x2ex66uc =_x2ex66uc+1;return _v end local _x2ex66ue=function()local _v=_x2ex66ud();_v =_v+_x2ex66ud()*256;_v =_v+_x2ex66ud()*65536;return _v+_x2ex66ud()*16777216 end local _x2ex66uf=function()local _n=_x2ex66ue();if _n>#_x2ex66ua-_x2ex66uc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x2ex66ud()end;return _v end local _x2ex66ug,_x2ex66uh _x2ex66ug =_x2ex66ue()_x2ex66uh =_x2ex66ue()if _x2ex66ug~=_x2ex66u1[3]or _x2ex66ug>1000000or _x2ex66uh>1000000or _x2ex66ug*5+_x2ex66uh*13>#_x2ex66ua-8 then uC()end _x2ex66u3 ={};_x2ex66u4 ={};_x2ex66u5 ={};_x2ex66u2 ={}for _j=1,_x2ex66uh do _x2ex66u2[_j] ={}end _x2ex66u9 =_x2ex66uf()for _j=1,_x2ex66ug do local _tag=_x2ex66ud();local _node=_x2ex66ue()if _tag==25or _tag==26or _tag==20 then if _node~=0 then uC()end elseif _tag==17or _tag==30 then if _node<1or _node>_x2ex66uh then uC()end else uC()end _x2ex66u3[_j] =_tag;_x2ex66u4[_j] =_node end for _j=1,_x2ex66uh do local _off=_x2ex66ue();local _len=_x2ex66ue();if _off>#_x2ex66u9or _len>#_x2ex66u9-_off then uC()end;_x2ex66u2[_j][1] ={_off,_len}_x2ex66u2[_j][2] =_x2ex66ue()_x2ex66u2[_j][3] =_x2ex66ud()_x2ex66u2[_j][4] =_x2ex66ue()end if _x2ex66uc~=#_x2ex66ua+1 then uC()end for _id=1,_x2ex66uh do local _op=_x2ex66u2[_id][3];local _a=_x2ex66u2[_id][2];local _b=_x2ex66u2[_id][4]if _op==21 then if _a~=0or _b~=0 then uC()end elseif _op==23or _op==13or _op==28 then if _a<1or _a>_x2ex66uhor _b~=0 then uC()end if _op==23and _x2ex66u2[_id][1][2]~=0or _op==13and _x2ex66u2[_id][1][2]~=8or _op==28and _x2ex66u2[_id][1][2]~=4 then uC()end elseif _op==14or _op==22 then if _x2ex66u2[_id][1][2]~=0or _a<1or _a>_x2ex66uhor _b<1or _b>_x2ex66uh then uC()end else uC()end end local _seen={};for _start=1,_x2ex66uh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x2ex66u2[_id][3];if _op~=21 then if not(_op==23or _op==13or _op==28)then _stack[#_stack+1] ={_x2ex66u2[_id][4],false}end;_stack[#_stack+1] ={_x2ex66u2[_id][2],false}end end end end end _x2ex66u7 =_x2ex66ug;_x2ex66u8 =_x2ex66up;_x2ex66u1 =nil elseif _x2ex66up~=_x2ex66u8 then uC()end if _x2ex66uo<0or _x2ex66uo>=_x2ex66u7or _x2ex66uo%1~=0 then uC()end local _x2ex66ur=_x2ex66u3[_x2ex66uo+1];if _x2ex66ur==25 then return nil elseif _x2ex66ur==26 then return false elseif _x2ex66ur==20 then return true end local _x2ex66uq=_x2ex66u6[_x2ex66uo+1];if _x2ex66uq~=nil then return _x2ex66uq end local _x2ex66uj=function(_id)local _buf=_x2ex66u2[_id][1];local _parts={};local _s=tO(_x2ex66up,1129205572,_id,3527106875)local _n=_buf[2]for _j=1,_n do _parts[_j] =fO[158](fO[106](_x2ex66u9[_buf[1]+_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _x2ex66ui=function(_op,_a,_b,_id)uC()end local _x2ex66uk local _stack={_x2ex66u4[_x2ex66uo+1]};while#_stack>0 do if#_stack>128 then uC()end;local _id=_stack[#_stack];if _x2ex66u5[_id]~=nil then _stack[#_stack] =nil else local _op=_x2ex66u2[_id][3]if _op==21 then _x2ex66u5[_id] =_x2ex66uj(_id);_stack[#_stack] =nil else local _a=_x2ex66u2[_id][2];local _b=_x2ex66u2[_id][4];if _x2ex66u5[_a]==nil then _stack[#_stack+1] =_a elseif not(_op==23or _op==13or _op==28)and _x2ex66u5[_b]==nil then _stack[#_stack+1] =_b else _x2ex66u5[_id] =_x2ex66ui(_op,_x2ex66u5[_a],_x2ex66u5[_b],_id);_stack[#_stack] =nil end end end end;_x2ex66uk =_x2ex66u5[_x2ex66u4[_x2ex66uo+1]]if _x2ex66ur==17 then if _x2ex66uk=='nan'then _x2ex66uq =0/0 elseif _x2ex66uk=='+inf'then _x2ex66uq =1/0 elseif _x2ex66uk=='-inf'then _x2ex66uq =-1/0 elseif _x2ex66uk=='-0'then _x2ex66uq =-1*(0)else _x2ex66uq =fO[204](_x2ex66uk)end else _x2ex66uq =_x2ex66uk end _x2ex66u6[_x2ex66uo+1] =_x2ex66uq;return _x2ex66uq end end local _xx16ik00=g9[67][4];local _xx16ik01=_xx16ik00[126]local _xx16ik02,_xx16ik03,_xx16ik04,_xx16ik05,_xx16ik07,_xx16ik08,_xx16ik09;local _xx16ik06={}_xx16ik00[126] =function(_xx16ik0o,_xx16ik0p)if _xx16ik07==nil then local _xx16ik0a=_xx16ik01[1];local _xx16ik0b=tO(2044004152,1129465678,2044004152,#_xx16ik0a)for _j=1,#_xx16ik0a do _xx16ik0b =fO[106](fO[174](_xx16ik0b,5),_xx16ik0a[_j],fO[95](_j*257,4294967295))end _xx16ik0b =tO(_xx16ik0b,1129465678,#_xx16ik0a,2044004152);if _xx16ik0b~=_xx16ik01[2]then uC()end local _xx16ik0c=1;local _xx16ik0d=function()local _v=_xx16ik0a[_xx16ik0c];if _v==nil then uC()end;_xx16ik0c =_xx16ik0c+1;return _v end local _xx16ik0e=function()local _v=_xx16ik0d();_v =_v+_xx16ik0d()*256;_v =_v+_xx16ik0d()*65536;return _v+_xx16ik0d()*16777216 end local _xx16ik0f=function()local _n=_xx16ik0e();if _n>#_xx16ik0a-_xx16ik0c+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_xx16ik0d()end;return _v end local _xx16ik0g,_xx16ik0h _xx16ik0h =_xx16ik0e()_xx16ik0g =_xx16ik0e()if _xx16ik0g~=_xx16ik01[3]or _xx16ik0g>1000000or _xx16ik0h>1000000or _xx16ik0g*5+_xx16ik0h*13>#_xx16ik0a-8 then uC()end _xx16ik03 ={};_xx16ik04 ={};_xx16ik05 ={};_xx16ik02 ={}for _j=1,4 do _xx16ik02[_j] ={}end for _j=1,_xx16ik0h do _xx16ik02[1][_j] =_xx16ik0f()end for _j=1,_xx16ik0h do _xx16ik02[2][_j] =_xx16ik0e()end for _j=1,_xx16ik0h do _xx16ik02[3][_j] =_xx16ik0d()end for _j=1,_xx16ik0h do _xx16ik02[4][_j] =_xx16ik0e()end for _j=1,_xx16ik0g do local _tag=_xx16ik0d();local _node=_xx16ik0e()if _tag==39or _tag==16or _tag==19 then if _node~=0 then uC()end elseif _tag==37or _tag==23 then if _node<1or _node>_xx16ik0h then uC()end else uC()end _xx16ik03[_j] =_tag;_xx16ik04[_j] =_node end if _xx16ik0c~=#_xx16ik0a+1 then uC()end for _id=1,_xx16ik0h do local _op=_xx16ik02[3][_id];local _a=_xx16ik02[4][_id];local _b=_xx16ik02[2][_id]if _op==29 then if _a~=0or _b~=0 then uC()end elseif _op==20or _op==36or _op==33 then if _a<1or _a>_xx16ik0hor _b~=0 then uC()end if _op==20and#(_xx16ik02[1][_id])~=0or _op==36and#(_xx16ik02[1][_id])~=8or _op==33and#(_xx16ik02[1][_id])~=4 then uC()end elseif _op==17or _op==12 then if#(_xx16ik02[1][_id])~=0or _a<1or _a>_xx16ik0hor _b<1or _b>_xx16ik0h then uC()end else uC()end end local _seen={};for _start=1,_xx16ik0h do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_xx16ik02[3][_id];if _op~=29 then if not(_op==20or _op==36or _op==33)then _stack[#_stack+1] ={_xx16ik02[2][_id],false}end;_stack[#_stack+1] ={_xx16ik02[4][_id],false}end end end end end _xx16ik07 =_xx16ik0g;_xx16ik08 =_xx16ik0p;_xx16ik01 =nil elseif _xx16ik0p~=_xx16ik08 then uC()end if _xx16ik0o<0or _xx16ik0o>=_xx16ik07or _xx16ik0o%1~=0 then uC()end local _xx16ik0r=_xx16ik03[_xx16ik0o+1];if _xx16ik0r==39 then return nil elseif _xx16ik0r==16 then return false elseif _xx16ik0r==19 then return true end local _xx16ik0q=_xx16ik06[_xx16ik0o+1];if _xx16ik0q~=nil then return _xx16ik0q end local _xx16ik0j=function(_id)local _buf=_xx16ik02[1][_id];local _parts={};local _s=tO(_xx16ik0p,1129205572,_id,2044004152)local _j=0 local _n=#_buf while _j<_n do _j =_j+1 _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _xx16ik0i=function(_op,_a,_b,_id)uC()end local _xx16ik0k if _xx16ik05[_xx16ik04[_xx16ik0o+1]]==nil then local _remaining=#_xx16ik02[3];local _round=0;while _remaining>0 do local _progress=0;_remaining =0;_round =_round+1;if _round>64 then uC()end for _id=1,#_xx16ik02[3]do if _xx16ik05[_id]==nil then local _op=_xx16ik02[3][_id];if _op==29 then _xx16ik05[_id] =_xx16ik0j(_id);_progress =_progress+1 else local _a=_xx16ik05[_xx16ik02[4][_id]];local _b=_xx16ik05[_xx16ik02[2][_id]];if _a~=niland((_op==20or _op==36or _op==33)or _b~=nil)then _xx16ik05[_id] =_xx16ik0i(_op,_a,_b,_id);_progress =_progress+1 else _remaining =_remaining+1 end end end end if _remaining>0and _progress==0 then uC()end end end;_xx16ik0k =_xx16ik05[_xx16ik04[_xx16ik0o+1]]if _xx16ik0r==37 then if _xx16ik0k=='nan'then _xx16ik0q =0/0 elseif _xx16ik0k=='+inf'then _xx16ik0q =1/0 elseif _xx16ik0k=='-inf'then _xx16ik0q =-1/0 elseif _xx16ik0k=='-0'then _xx16ik0q =-1*(0)else _xx16ik0q =fO[204](_xx16ik0k)end else _xx16ik0q =_xx16ik0k end _xx16ik06[_xx16ik0o+1] =_xx16ik0q;return _xx16ik0q end end local _xbo86rb0=g9[67][5];local _xbo86rb1=_xbo86rb0[126]local _xbo86rb2,_xbo86rb3,_xbo86rb4,_xbo86rb5,_xbo86rb7,_xbo86rb8,_xbo86rb9;local _xbo86rb6={}_xbo86rb0[126] =function(_xbo86rbo,_xbo86rbp)if _xbo86rb7==nil then local _xbo86rba=_xbo86rb1[1];local _xbo86rbb=tO(323544956,1129465678,323544956,#_xbo86rba)for _j=1,#_xbo86rba do _xbo86rbb =fO[106](fO[174](_xbo86rbb,5),_xbo86rba[_j],fO[95](_j*257,4294967295))end _xbo86rbb =tO(_xbo86rbb,1129465678,#_xbo86rba,323544956);if _xbo86rbb~=_xbo86rb1[2]then uC()end local _xbo86rbc=1;local _xbo86rbd=function()local _v=_xbo86rba[_xbo86rbc];if _v==nil then uC()end;_xbo86rbc =_xbo86rbc+1;return _v end local _xbo86rbe=function()local _v=_xbo86rbd();_v =_v+_xbo86rbd()*256;_v =_v+_xbo86rbd()*65536;return _v+_xbo86rbd()*16777216 end local _xbo86rbf=function()local _n=_xbo86rbe();if _n>#_xbo86rba-_xbo86rbc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_xbo86rbd()end;return _v end local _xbo86rbg,_xbo86rbh _xbo86rbh =_xbo86rbe()_xbo86rbg =_xbo86rbe()if _xbo86rbg~=_xbo86rb1[3]or _xbo86rbg>1000000or _xbo86rbh>1000000or _xbo86rbg*5+_xbo86rbh*13>#_xbo86rba-8 then uC()end _xbo86rb3 ={};_xbo86rb4 ={};_xbo86rb5 ={};_xbo86rb2 ={}for _j=1,_xbo86rbh do _xbo86rb2[_j] ={}end _xbo86rb9 =_xbo86rbf()for _j=1,_xbo86rbg do local _tag=_xbo86rbd();local _node=_xbo86rbe()if _tag==16or _tag==22or _tag==13 then if _node~=0 then uC()end elseif _tag==19or _tag==31 then if _node<1or _node>_xbo86rbh then uC()end else uC()end _xbo86rb3[_j] =_tag;_xbo86rb4[_j] =_node end for _j=1,_xbo86rbh do _xbo86rb2[_j][1] =_xbo86rbe()_xbo86rb2[_j][2] =_xbo86rbe()_xbo86rb2[_j][3] =_xbo86rbd()local _off=_xbo86rbe();local _len=_xbo86rbe();if _off>#_xbo86rb9or _len>#_xbo86rb9-_off then uC()end;_xbo86rb2[_j][4] ={_off,_len}end if _xbo86rbc~=#_xbo86rba+1 then uC()end for _id=1,_xbo86rbh do local _op=_xbo86rb2[_id][3];local _a=_xbo86rb2[_id][2];local _b=_xbo86rb2[_id][1]if _op==27 then if _a~=0or _b~=0 then uC()end elseif _op==36or _op==32or _op==24 then if _a<1or _a>_xbo86rbhor _b~=0 then uC()end if _op==36and _xbo86rb2[_id][4][2]~=0or _op==32and _xbo86rb2[_id][4][2]~=8or _op==24and _xbo86rb2[_id][4][2]~=4 then uC()end elseif _op==21or _op==12 then if _xbo86rb2[_id][4][2]~=0or _a<1or _a>_xbo86rbhor _b<1or _b>_xbo86rbh then uC()end else uC()end end local _seen={};for _start=1,_xbo86rbh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_xbo86rb2[_id][3];if _op~=27 then if not(_op==36or _op==32or _op==24)then _stack[#_stack+1] ={_xbo86rb2[_id][1],false}end;_stack[#_stack+1] ={_xbo86rb2[_id][2],false}end end end end end _xbo86rb7 =_xbo86rbg;_xbo86rb8 =_xbo86rbp;_xbo86rb1 =nil elseif _xbo86rbp~=_xbo86rb8 then uC()end if _xbo86rbo<0or _xbo86rbo>=_xbo86rb7or _xbo86rbo%1~=0 then uC()end local _xbo86rbr=_xbo86rb3[_xbo86rbo+1];if _xbo86rbr==16 then return nil elseif _xbo86rbr==22 then return false elseif _xbo86rbr==13 then return true end local _xbo86rbq=_xbo86rb6[_xbo86rbo+1];if _xbo86rbq~=nil then return _xbo86rbq end local _xbo86rbj=function(_id)local _buf=_xbo86rb2[_id][4];local _parts={};local _s=tO(_xbo86rbp,1129205572,_id,323544956)local _n=_buf[2]for _j=1,_n do _parts[_j] =fO[158](fO[106](_xbo86rb9[_buf[1]+_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _xbo86rbi=function(_op,_a,_b,_id)uC()end local _xbo86rbk local _stack={_xbo86rb4[_xbo86rbo+1]};while#_stack>0 do if#_stack>128 then uC()end;local _id=_stack[#_stack];if _xbo86rb5[_id]~=nil then _stack[#_stack] =nil else local _op=_xbo86rb2[_id][3]if _op==27 then _xbo86rb5[_id] =_xbo86rbj(_id);_stack[#_stack] =nil else local _a=_xbo86rb2[_id][2];local _b=_xbo86rb2[_id][1];if _xbo86rb5[_a]==nil then _stack[#_stack+1] =_a elseif not(_op==36or _op==32or _op==24)and _xbo86rb5[_b]==nil then _stack[#_stack+1] =_b else _xbo86rb5[_id] =_xbo86rbi(_op,_xbo86rb5[_a],_xbo86rb5[_b],_id);_stack[#_stack] =nil end end end end;_xbo86rbk =_xbo86rb5[_xbo86rb4[_xbo86rbo+1]]if _xbo86rbr==19 then if _xbo86rbk=='nan'then _xbo86rbq =0/0 elseif _xbo86rbk=='+inf'then _xbo86rbq =1/0 elseif _xbo86rbk=='-inf'then _xbo86rbq =-1/0 elseif _xbo86rbk=='-0'then _xbo86rbq =-1*(0)else _xbo86rbq =fO[204](_xbo86rbk)end else _xbo86rbq =_xbo86rbk end _xbo86rb6[_xbo86rbo+1] =_xbo86rbq;return _xbo86rbq end end local _xtuncj0=g9[67][6];local _xtuncj1=_xtuncj0[126]local _xtuncj2,_xtuncj3,_xtuncj4,_xtuncj5,_xtuncj7,_xtuncj8,_xtuncj9;local _xtuncj6={}_xtuncj0[126] =function(_xtuncjo,_xtuncjp)if _xtuncj7==nil then local _xtuncja=_xtuncj1[1];local _xtuncjb=tO(224915518,1129465678,224915518,#_xtuncja)for _j=1,#_xtuncja do _xtuncjb =fO[106](fO[174](_xtuncjb,5),_xtuncja[_j],fO[95](_j*257,4294967295))end _xtuncjb =tO(_xtuncjb,1129465678,#_xtuncja,224915518);if _xtuncjb~=_xtuncj1[2]then uC()end local _xtuncjc=1;local _xtuncjd=function()local _v=_xtuncja[_xtuncjc];if _v==nil then uC()end;_xtuncjc =_xtuncjc+1;return _v end local _xtuncje=function()local _v=_xtuncjd();_v =_v+_xtuncjd()*256;_v =_v+_xtuncjd()*65536;return _v+_xtuncjd()*16777216 end local _xtuncjf=function()local _n=_xtuncje();if _n>#_xtuncja-_xtuncjc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_xtuncjd()end;return _v end local _xtuncjg,_xtuncjh _xtuncjh =_xtuncje()_xtuncjg =_xtuncje()if _xtuncjg~=_xtuncj1[3]or _xtuncjg>1000000or _xtuncjh>1000000or _xtuncjg*5+_xtuncjh*13>#_xtuncja-8 then uC()end _xtuncj3 ={};_xtuncj4 ={};_xtuncj5 ={};_xtuncj2 ={}for _j=1,4 do _xtuncj2[_j] ={}end for _j=1,_xtuncjh do _xtuncj2[1][_j] =_xtuncje()end for _j=1,_xtuncjh do _xtuncj2[2][_j] =_xtuncjd()end for _j=1,_xtuncjh do _xtuncj2[3][_j] =_xtuncjf()end for _j=1,_xtuncjh do _xtuncj2[4][_j] =_xtuncje()end for _j=1,_xtuncjg do local _tag=_xtuncjd();local _node=_xtuncje()if _tag==29or _tag==27or _tag==12 then if _node~=0 then uC()end elseif _tag==25or _tag==26 then if _node<1or _node>_xtuncjh then uC()end else uC()end _xtuncj3[_j] =_tag;_xtuncj4[_j] =_node end if _xtuncjc~=#_xtuncja+1 then uC()end for _id=1,_xtuncjh do local _op=_xtuncj2[2][_id];local _a=_xtuncj2[1][_id];local _b=_xtuncj2[4][_id]if _op==22 then if _a~=0or _b~=0 then uC()end elseif _op==11or _op==16or _op==20 then if _a<1or _a>_xtuncjhor _b~=0 then uC()end if _op==11and#(_xtuncj2[3][_id])~=0or _op==16and#(_xtuncj2[3][_id])~=8or _op==20and#(_xtuncj2[3][_id])~=4 then uC()end elseif _op==17or _op==33 then if#(_xtuncj2[3][_id])~=0or _a<1or _a>_xtuncjhor _b<1or _b>_xtuncjh then uC()end else uC()end end local _seen={};for _start=1,_xtuncjh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_xtuncj2[2][_id];if _op~=22 then if not(_op==11or _op==16or _op==20)then _stack[#_stack+1] ={_xtuncj2[4][_id],false}end;_stack[#_stack+1] ={_xtuncj2[1][_id],false}end end end end end _xtuncj7 =_xtuncjg;_xtuncj8 =_xtuncjp;_xtuncj1 =nil elseif _xtuncjp~=_xtuncj8 then uC()end if _xtuncjo<0or _xtuncjo>=_xtuncj7or _xtuncjo%1~=0 then uC()end local _xtuncjr=_xtuncj3[_xtuncjo+1];if _xtuncjr==29 then return nil elseif _xtuncjr==27 then return false elseif _xtuncjr==12 then return true end local _xtuncjq=_xtuncj6[_xtuncjo+1];if _xtuncjq~=nil then return _xtuncjq end local _xtuncjj=function(_id)local _buf=_xtuncj2[3][_id];local _parts={};local _s=tO(_xtuncjp,1129205572,_id,224915518)local _j=0 local _n=#_buf while _j<_n do _j =_j+1 _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _xtuncji=function(_op,_a,_b,_id)if _op==17 then if#_a+#_b>33554432 then uC()end;return fO[206]({_a,_b})elseif _op==20 then local _p=_xtuncjj(_id);if#_p~=4 then uC()end;local _k=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=#_a;if _n==0 then return _a end;_k =_k%_n;if _k==0 then return _a end;return fO[206]({fO[25](_a,_k+1),fO[25](_a,1,_k)})elseif _op==16 then local _p=_xtuncjj(_id);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_aor _n>#_a-_off then uC()end;return fO[25](_a,_off+1,_off+_n)else uC()end end local _xtuncjl={[1]={286331153},[2]={572662306},[3]={4294967296},[4]={2143289345},[5]={16777619}}local _hit=_xtuncjl[_xtuncjo+1];if _hit~=nil then _xtuncjq =_hit[1];_xtuncj6[_xtuncjo+1] =_xtuncjq;return _xtuncjq end end local _xtuncjk if _xtuncj5[_xtuncj4[_xtuncjo+1]]==nil then local _remaining=#_xtuncj2[2];local _round=0;while _remaining>0 do local _progress=0;_remaining =0;_round =_round+1;if _round>64 then uC()end for _id=1,#_xtuncj2[2]do if _xtuncj5[_id]==nil then local _op=_xtuncj2[2][_id];if _op==22 then _xtuncj5[_id] =_xtuncjj(_id);_progress =_progress+1 else local _a=_xtuncj5[_xtuncj2[1][_id]];local _b=_xtuncj5[_xtuncj2[4][_id]];if _a~=niland((_op==11or _op==16or _op==20)or _b~=nil)then _xtuncj5[_id] =_xtuncji(_op,_a,_b,_id);_progress =_progress+1 else _remaining =_remaining+1 end end end end if _remaining>0and _progress==0 then uC()end end end;_xtuncjk =_xtuncj5[_xtuncj4[_xtuncjo+1]]if _xtuncjr==25 then if _xtuncjk=='nan'then _xtuncjq =0/0 elseif _xtuncjk=='+inf'then _xtuncjq =1/0 elseif _xtuncjk=='-inf'then _xtuncjq =-1/0 elseif _xtuncjk=='-0'then _xtuncjq =-1*(0)else _xtuncjq =fO[204](_xtuncjk)end else _xtuncjq =_xtuncjk end _xtuncj6[_xtuncjo+1] =_xtuncjq;return _xtuncjq end end local _x52on9l0=g9[67][7];local _x52on9l1=_x52on9l0[126]local _x52on9l2,_x52on9l3,_x52on9l4,_x52on9l5,_x52on9l7,_x52on9l8,_x52on9l9;local _x52on9l6={}_x52on9l0[126] =function(_x52on9lo,_x52on9lp)if _x52on9l7==nil then local _x52on9la=_x52on9l1[1];local _x52on9lb=tO(3380020331,1129465678,3380020331,#_x52on9la)for _j=1,#_x52on9la do _x52on9lb =fO[106](fO[174](_x52on9lb,5),_x52on9la[_j],fO[95](_j*257,4294967295))end _x52on9lb =tO(_x52on9lb,1129465678,#_x52on9la,3380020331);if _x52on9lb~=_x52on9l1[2]then uC()end local _x52on9lc=1;local _x52on9ld=function()local _v=_x52on9la[_x52on9lc];if _v==nil then uC()end;_x52on9lc =_x52on9lc+1;return _v end local _x52on9le=function()local _v=_x52on9ld();_v =_v+_x52on9ld()*256;_v =_v+_x52on9ld()*65536;return _v+_x52on9ld()*16777216 end local _x52on9lf=function()local _n=_x52on9le();if _n>#_x52on9la-_x52on9lc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x52on9ld()end;return _v end local _x52on9lg,_x52on9lh _x52on9lg =_x52on9le()_x52on9lh =_x52on9le()if _x52on9lg~=_x52on9l1[3]or _x52on9lg>1000000or _x52on9lh>1000000or _x52on9lg*5+_x52on9lh*13>#_x52on9la-8 then uC()end _x52on9l3 ={};_x52on9l4 ={};_x52on9l5 ={};_x52on9l2 ={}for _j=1,_x52on9lh do _x52on9l2[_j] ={}end _x52on9l9 =_x52on9lf()for _j=1,_x52on9lg do local _tag=_x52on9ld();local _node=_x52on9le()if _tag==37or _tag==30or _tag==20 then if _node~=0 then uC()end elseif _tag==15or _tag==25 then if _node<1or _node>_x52on9lh then uC()end else uC()end _x52on9l3[_j] =_tag;_x52on9l4[_j] =_node end for _j=1,_x52on9lh do _x52on9l2[_j][1] =_x52on9le()local _off=_x52on9le();local _len=_x52on9le();if _off>#_x52on9l9or _len>#_x52on9l9-_off then uC()end;_x52on9l2[_j][2] ={_off,_len}_x52on9l2[_j][3] =_x52on9le()_x52on9l2[_j][4] =_x52on9ld()end if _x52on9lc~=#_x52on9la+1 then uC()end for _id=1,_x52on9lh do local _op=_x52on9l2[_id][4];local _a=_x52on9l2[_id][1];local _b=_x52on9l2[_id][3]if _op==36 then if _a~=0or _b~=0 then uC()end elseif _op==28or _op==26or _op==16 then if _a<1or _a>_x52on9lhor _b~=0 then uC()end if _op==28and _x52on9l2[_id][2][2]~=0or _op==26and _x52on9l2[_id][2][2]~=8or _op==16and _x52on9l2[_id][2][2]~=4 then uC()end elseif _op==32or _op==14 then if _x52on9l2[_id][2][2]~=0or _a<1or _a>_x52on9lhor _b<1or _b>_x52on9lh then uC()end else uC()end end local _seen={};for _start=1,_x52on9lh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x52on9l2[_id][4];if _op~=36 then if not(_op==28or _op==26or _op==16)then _stack[#_stack+1] ={_x52on9l2[_id][3],false}end;_stack[#_stack+1] ={_x52on9l2[_id][1],false}end end end end end _x52on9l7 =_x52on9lg;_x52on9l8 =_x52on9lp;_x52on9l1 =nil elseif _x52on9lp~=_x52on9l8 then uC()end if _x52on9lo<0or _x52on9lo>=_x52on9l7or _x52on9lo%1~=0 then uC()end local _x52on9lr=_x52on9l3[_x52on9lo+1];if _x52on9lr==37 then return nil elseif _x52on9lr==30 then return false elseif _x52on9lr==20 then return true end local _x52on9lq=_x52on9l6[_x52on9lo+1];if _x52on9lq~=nil then return _x52on9lq end local _x52on9lj=function(_id)local _buf=_x52on9l2[_id][2];local _parts={};local _s=tO(_x52on9lp,1129205572,_id,3380020331)local _n=_buf[2]for _j=1,_n do _parts[_j] =fO[158](fO[106](_x52on9l9[_buf[1]+_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _x52on9lk local _m1=_x52on9lj(1)_x52on9lk =({[1]=_m1})[_x52on9l4[_x52on9lo+1]]if _x52on9lr==15 then if _x52on9lk=='nan'then _x52on9lq =0/0 elseif _x52on9lk=='+inf'then _x52on9lq =1/0 elseif _x52on9lk=='-inf'then _x52on9lq =-1/0 elseif _x52on9lk=='-0'then _x52on9lq =-1*(0)else _x52on9lq =fO[204](_x52on9lk)end else _x52on9lq =_x52on9lk end _x52on9l6[_x52on9lo+1] =_x52on9lq;return _x52on9lq end end local _x1mp5mkb0=g9[67][8];local _x1mp5mkb1=_x1mp5mkb0[126]local _x1mp5mkb2,_x1mp5mkb3,_x1mp5mkb4,_x1mp5mkb5,_x1mp5mkb7,_x1mp5mkb8,_x1mp5mkb9;local _x1mp5mkb6={}_x1mp5mkb0[126] =function(_x1mp5mkbo,_x1mp5mkbp)if _x1mp5mkb7==nil then local _x1mp5mkba=_x1mp5mkb1[1];local _x1mp5mkbb=tO(1731257506,1129465678,1731257506,#_x1mp5mkba)for _j=1,#_x1mp5mkba do _x1mp5mkbb =fO[106](fO[174](_x1mp5mkbb,5),_x1mp5mkba[_j],fO[95](_j*257,4294967295))end _x1mp5mkbb =tO(_x1mp5mkbb,1129465678,#_x1mp5mkba,1731257506);if _x1mp5mkbb~=_x1mp5mkb1[2]then uC()end local _x1mp5mkbc=1;local _x1mp5mkbd=function()local _v=_x1mp5mkba[_x1mp5mkbc];if _v==nil then uC()end;_x1mp5mkbc =_x1mp5mkbc+1;return _v end local _x1mp5mkbe=function()local _v=_x1mp5mkbd();_v =_v+_x1mp5mkbd()*256;_v =_v+_x1mp5mkbd()*65536;return _v+_x1mp5mkbd()*16777216 end local _x1mp5mkbf=function()local _n=_x1mp5mkbe();if _n>#_x1mp5mkba-_x1mp5mkbc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x1mp5mkbd()end;return _v end local _x1mp5mkbg,_x1mp5mkbh _x1mp5mkbg =_x1mp5mkbe()_x1mp5mkbh =_x1mp5mkbe()if _x1mp5mkbg~=_x1mp5mkb1[3]or _x1mp5mkbg>1000000or _x1mp5mkbh>1000000or _x1mp5mkbg*5+_x1mp5mkbh*13>#_x1mp5mkba-8 then uC()end _x1mp5mkb3 ={};_x1mp5mkb4 ={};_x1mp5mkb5 ={};_x1mp5mkb2 ={}for _j=1,4 do _x1mp5mkb2[_j] ={}end for _j=1,_x1mp5mkbh do _x1mp5mkb2[1][_j] =_x1mp5mkbd()end for _j=1,_x1mp5mkbh do _x1mp5mkb2[2][_j] =_x1mp5mkbf()end for _j=1,_x1mp5mkbh do _x1mp5mkb2[3][_j] =_x1mp5mkbe()end for _j=1,_x1mp5mkbh do _x1mp5mkb2[4][_j] =_x1mp5mkbe()end for _j=1,_x1mp5mkbg do local _tag=_x1mp5mkbd();local _node=_x1mp5mkbe()if _tag==32or _tag==36or _tag==27 then if _node~=0 then uC()end elseif _tag==24or _tag==18 then if _node<1or _node>_x1mp5mkbh then uC()end else uC()end _x1mp5mkb3[_j] =_tag;_x1mp5mkb4[_j] =_node end if _x1mp5mkbc~=#_x1mp5mkba+1 then uC()end for _id=1,_x1mp5mkbh do local _op=_x1mp5mkb2[1][_id];local _a=_x1mp5mkb2[4][_id];local _b=_x1mp5mkb2[3][_id]if _op==26 then if _a~=0or _b~=0 then uC()end elseif _op==13or _op==15or _op==14 then if _a<1or _a>_x1mp5mkbhor _b~=0 then uC()end if _op==13and#(_x1mp5mkb2[2][_id])~=0or _op==15and#(_x1mp5mkb2[2][_id])~=8or _op==14and#(_x1mp5mkb2[2][_id])~=4 then uC()end elseif _op==33or _op==38 then if#(_x1mp5mkb2[2][_id])~=0or _a<1or _a>_x1mp5mkbhor _b<1or _b>_x1mp5mkbh then uC()end else uC()end end local _seen={};for _start=1,_x1mp5mkbh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x1mp5mkb2[1][_id];if _op~=26 then if not(_op==13or _op==15or _op==14)then _stack[#_stack+1] ={_x1mp5mkb2[3][_id],false}end;_stack[#_stack+1] ={_x1mp5mkb2[4][_id],false}end end end end end _x1mp5mkb7 =_x1mp5mkbg;_x1mp5mkb8 =_x1mp5mkbp;_x1mp5mkb1 =nil elseif _x1mp5mkbp~=_x1mp5mkb8 then uC()end if _x1mp5mkbo<0or _x1mp5mkbo>=_x1mp5mkb7or _x1mp5mkbo%1~=0 then uC()end local _x1mp5mkbr=_x1mp5mkb3[_x1mp5mkbo+1];if _x1mp5mkbr==32 then return nil elseif _x1mp5mkbr==36 then return false elseif _x1mp5mkbr==27 then return true end local _x1mp5mkbq=_x1mp5mkb6[_x1mp5mkbo+1];if _x1mp5mkbq~=nil then return _x1mp5mkbq end local _x1mp5mkbj=function(_id)local _buf=_x1mp5mkb2[2][_id];local _parts={};local _s=tO(_x1mp5mkbp,1129205572,_id,1731257506)local _j=0 local _n=#_buf while _j<_n do _j =_j+1 _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _x1mp5mkbi=function(_op,_a,_b,_id)if _op==33 then if#_a+#_b>33554432 then uC()end;return fO[206]({_a,_b})elseif _op==14 then local _p=_x1mp5mkbj(_id);if#_p~=4 then uC()end;local _k=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=#_a;if _n==0 then return _a end;_k =_k%_n;if _k==0 then return _a end;return fO[206]({fO[25](_a,_k+1),fO[25](_a,1,_k)})elseif _op==15 then local _p=_x1mp5mkbj(_id);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_aor _n>#_a-_off then uC()end;return fO[25](_a,_off+1,_off+_n)else uC()end end local _x1mp5mkbk if _x1mp5mkb5[_x1mp5mkb4[_x1mp5mkbo+1]]==nil then local _remaining=#_x1mp5mkb2[1];local _round=0;while _remaining>0 do local _progress=0;_remaining =0;_round =_round+1;if _round>64 then uC()end for _id=1,#_x1mp5mkb2[1]do if _x1mp5mkb5[_id]==nil then local _op=_x1mp5mkb2[1][_id];if _op==26 then _x1mp5mkb5[_id] =_x1mp5mkbj(_id);_progress =_progress+1 else local _a=_x1mp5mkb5[_x1mp5mkb2[4][_id]];local _b=_x1mp5mkb5[_x1mp5mkb2[3][_id]];if _a~=niland((_op==13or _op==15or _op==14)or _b~=nil)then _x1mp5mkb5[_id] =_x1mp5mkbi(_op,_a,_b,_id);_progress =_progress+1 else _remaining =_remaining+1 end end end end if _remaining>0and _progress==0 then uC()end end end;_x1mp5mkbk =_x1mp5mkb5[_x1mp5mkb4[_x1mp5mkbo+1]]if _x1mp5mkbr==24 then if _x1mp5mkbk=='nan'then _x1mp5mkbq =0/0 elseif _x1mp5mkbk=='+inf'then _x1mp5mkbq =1/0 elseif _x1mp5mkbk=='-inf'then _x1mp5mkbq =-1/0 elseif _x1mp5mkbk=='-0'then _x1mp5mkbq =-1*(0)else _x1mp5mkbq =fO[204](_x1mp5mkbk)end else _x1mp5mkbq =_x1mp5mkbk end _x1mp5mkb6[_x1mp5mkbo+1] =_x1mp5mkbq;return _x1mp5mkbq end end local _x1tu7ljj0=g9[67][10];local _x1tu7ljj1=_x1tu7ljj0[126]local _x1tu7ljj2,_x1tu7ljj3,_x1tu7ljj4,_x1tu7ljj5,_x1tu7ljj7,_x1tu7ljj8,_x1tu7ljj9;local _x1tu7ljj6={}_x1tu7ljj0[126] =function(_x1tu7ljjo,_x1tu7ljjp)if _x1tu7ljj7==nil then local _x1tu7ljja=_x1tu7ljj1[1];local _x1tu7ljjb=tO(524218918,1129465678,524218918,#_x1tu7ljja)for _j=1,#_x1tu7ljja do _x1tu7ljjb =fO[106](fO[174](_x1tu7ljjb,5),_x1tu7ljja[_j],fO[95](_j*257,4294967295))end _x1tu7ljjb =tO(_x1tu7ljjb,1129465678,#_x1tu7ljja,524218918);if _x1tu7ljjb~=_x1tu7ljj1[2]then uC()end local _x1tu7ljjc=1;local _x1tu7ljjd=function()local _v=_x1tu7ljja[_x1tu7ljjc];if _v==nil then uC()end;_x1tu7ljjc =_x1tu7ljjc+1;return _v end local _x1tu7ljje=function()local _v=_x1tu7ljjd();_v =_v+_x1tu7ljjd()*256;_v =_v+_x1tu7ljjd()*65536;return _v+_x1tu7ljjd()*16777216 end local _x1tu7ljjf=function()local _n=_x1tu7ljje();if _n>#_x1tu7ljja-_x1tu7ljjc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x1tu7ljjd()end;return _v end local _x1tu7ljjg,_x1tu7ljjh _x1tu7ljjg =_x1tu7ljje()_x1tu7ljjh =_x1tu7ljje()if _x1tu7ljjg~=_x1tu7ljj1[3]or _x1tu7ljjg>1000000or _x1tu7ljjh>1000000or _x1tu7ljjg*5+_x1tu7ljjh*13>#_x1tu7ljja-8 then uC()end _x1tu7ljj3 ={};_x1tu7ljj4 ={};_x1tu7ljj5 ={};_x1tu7ljj2 ={}for _j=1,4 do _x1tu7ljj2[_j] ={}end for _j=1,_x1tu7ljjh do _x1tu7ljj2[1][_j] =_x1tu7ljjd()end for _j=1,_x1tu7ljjh do _x1tu7ljj2[2][_j] =_x1tu7ljjf()end for _j=1,_x1tu7ljjh do _x1tu7ljj2[3][_j] =_x1tu7ljje()end for _j=1,_x1tu7ljjh do _x1tu7ljj2[4][_j] =_x1tu7ljje()end for _j=1,_x1tu7ljjg do local _tag=_x1tu7ljjd();local _node=_x1tu7ljje()if _tag==17or _tag==12or _tag==36 then if _node~=0 then uC()end elseif _tag==33or _tag==23 then if _node<1or _node>_x1tu7ljjh then uC()end else uC()end _x1tu7ljj3[_j] =_tag;_x1tu7ljj4[_j] =_node end if _x1tu7ljjc~=#_x1tu7ljja+1 then uC()end for _id=1,_x1tu7ljjh do local _op=_x1tu7ljj2[1][_id];local _a=_x1tu7ljj2[3][_id];local _b=_x1tu7ljj2[4][_id]if _op==37 then if _a~=0or _b~=0 then uC()end elseif _op==14or _op==18or _op==27 then if _a<1or _a>_x1tu7ljjhor _b~=0 then uC()end if _op==14and#(_x1tu7ljj2[2][_id])~=0or _op==18and#(_x1tu7ljj2[2][_id])~=8or _op==27and#(_x1tu7ljj2[2][_id])~=4 then uC()end elseif _op==24or _op==39 then if#(_x1tu7ljj2[2][_id])~=0or _a<1or _a>_x1tu7ljjhor _b<1or _b>_x1tu7ljjh then uC()end else uC()end end local _seen={};for _start=1,_x1tu7ljjh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x1tu7ljj2[1][_id];if _op~=37 then if not(_op==14or _op==18or _op==27)then _stack[#_stack+1] ={_x1tu7ljj2[4][_id],false}end;_stack[#_stack+1] ={_x1tu7ljj2[3][_id],false}end end end end end _x1tu7ljj7 =_x1tu7ljjg;_x1tu7ljj8 =_x1tu7ljjp;_x1tu7ljj1 =nil elseif _x1tu7ljjp~=_x1tu7ljj8 then uC()end if _x1tu7ljjo<0or _x1tu7ljjo>=_x1tu7ljj7or _x1tu7ljjo%1~=0 then uC()end local _x1tu7ljjr=_x1tu7ljj3[_x1tu7ljjo+1];if _x1tu7ljjr==17 then return nil elseif _x1tu7ljjr==12 then return false elseif _x1tu7ljjr==36 then return true end local _x1tu7ljjq=_x1tu7ljj6[_x1tu7ljjo+1];if _x1tu7ljjq~=nil then return _x1tu7ljjq end local _x1tu7ljjj=function(_id)local _buf=_x1tu7ljj2[2][_id];local _parts={};local _s=tO(_x1tu7ljjp,1129205572,_id,524218918)local _j=0 local _n=#_buf while _j<_n do _j =_j+1 _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _x1tu7ljji=function(_op,_a,_b,_id)uC()end local _x1tu7ljjk if _x1tu7ljj5[_x1tu7ljj4[_x1tu7ljjo+1]]==nil then local _remaining=#_x1tu7ljj2[1];local _round=0;while _remaining>0 do local _progress=0;_remaining =0;_round =_round+1;if _round>64 then uC()end for _id=1,#_x1tu7ljj2[1]do if _x1tu7ljj5[_id]==nil then local _op=_x1tu7ljj2[1][_id];if _op==37 then _x1tu7ljj5[_id] =_x1tu7ljjj(_id);_progress =_progress+1 else local _a=_x1tu7ljj5[_x1tu7ljj2[3][_id]];local _b=_x1tu7ljj5[_x1tu7ljj2[4][_id]];if _a~=niland((_op==14or _op==18or _op==27)or _b~=nil)then _x1tu7ljj5[_id] =_x1tu7ljji(_op,_a,_b,_id);_progress =_progress+1 else _remaining =_remaining+1 end end end end if _remaining>0and _progress==0 then uC()end end end;_x1tu7ljjk =_x1tu7ljj5[_x1tu7ljj4[_x1tu7ljjo+1]]if _x1tu7ljjr==33 then if _x1tu7ljjk=='nan'then _x1tu7ljjq =0/0 elseif _x1tu7ljjk=='+inf'then _x1tu7ljjq =1/0 elseif _x1tu7ljjk=='-inf'then _x1tu7ljjq =-1/0 elseif _x1tu7ljjk=='-0'then _x1tu7ljjq =-1*(0)else _x1tu7ljjq =fO[204](_x1tu7ljjk)end else _x1tu7ljjq =_x1tu7ljjk end _x1tu7ljj6[_x1tu7ljjo+1] =_x1tu7ljjq;return _x1tu7ljjq end end local _x1jfv2uw0=g9[67][11];local _x1jfv2uw1=_x1jfv2uw0[126]local _x1jfv2uw2,_x1jfv2uw3,_x1jfv2uw4,_x1jfv2uw5,_x1jfv2uw7,_x1jfv2uw8,_x1jfv2uw9;local _x1jfv2uw6={}_x1jfv2uw0[126] =function(_x1jfv2uwo,_x1jfv2uwp)if _x1jfv2uw7==nil then local _x1jfv2uwa=_x1jfv2uw1[1];local _x1jfv2uwb=tO(4199070681,1129465678,4199070681,#_x1jfv2uwa)for _j=1,#_x1jfv2uwa do _x1jfv2uwb =fO[106](fO[174](_x1jfv2uwb,5),_x1jfv2uwa[_j],fO[95](_j*257,4294967295))end _x1jfv2uwb =tO(_x1jfv2uwb,1129465678,#_x1jfv2uwa,4199070681);if _x1jfv2uwb~=_x1jfv2uw1[2]then uC()end local _x1jfv2uwc=1;local _x1jfv2uwd=function()local _v=_x1jfv2uwa[_x1jfv2uwc];if _v==nil then uC()end;_x1jfv2uwc =_x1jfv2uwc+1;return _v end local _x1jfv2uwe=function()local _v=_x1jfv2uwd();_v =_v+_x1jfv2uwd()*256;_v =_v+_x1jfv2uwd()*65536;return _v+_x1jfv2uwd()*16777216 end local _x1jfv2uwf=function()local _n=_x1jfv2uwe();if _n>#_x1jfv2uwa-_x1jfv2uwc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x1jfv2uwd()end;return _v end local _x1jfv2uwg,_x1jfv2uwh _x1jfv2uwg =_x1jfv2uwe()_x1jfv2uwh =_x1jfv2uwe()if _x1jfv2uwg~=_x1jfv2uw1[3]or _x1jfv2uwg>1000000or _x1jfv2uwh>1000000or _x1jfv2uwg*5+_x1jfv2uwh*13>#_x1jfv2uwa-8 then uC()end _x1jfv2uw3 ={};_x1jfv2uw4 ={};_x1jfv2uw5 ={};_x1jfv2uw2 ={}for _j=1,_x1jfv2uwh do _x1jfv2uw2[_j] ={}end for _j=1,_x1jfv2uwg do local _tag=_x1jfv2uwd();local _node=_x1jfv2uwe()if _tag==17or _tag==33or _tag==35 then if _node~=0 then uC()end elseif _tag==15or _tag==14 then if _node<1or _node>_x1jfv2uwh then uC()end else uC()end _x1jfv2uw3[_j] =_tag;_x1jfv2uw4[_j] =_node end for _j=1,_x1jfv2uwh do _x1jfv2uw2[_j][1] =_x1jfv2uwf()_x1jfv2uw2[_j][2] =_x1jfv2uwd()_x1jfv2uw2[_j][3] =_x1jfv2uwe()_x1jfv2uw2[_j][4] =_x1jfv2uwe()end if _x1jfv2uwc~=#_x1jfv2uwa+1 then uC()end for _id=1,_x1jfv2uwh do local _op=_x1jfv2uw2[_id][2];local _a=_x1jfv2uw2[_id][3];local _b=_x1jfv2uw2[_id][4]if _op==13 then if _a~=0or _b~=0 then uC()end elseif _op==20or _op==29or _op==26 then if _a<1or _a>_x1jfv2uwhor _b~=0 then uC()end if _op==20and#(_x1jfv2uw2[_id][1])~=0or _op==29and#(_x1jfv2uw2[_id][1])~=8or _op==26and#(_x1jfv2uw2[_id][1])~=4 then uC()end elseif _op==32or _op==25 then if#(_x1jfv2uw2[_id][1])~=0or _a<1or _a>_x1jfv2uwhor _b<1or _b>_x1jfv2uwh then uC()end else uC()end end local _seen={};for _start=1,_x1jfv2uwh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x1jfv2uw2[_id][2];if _op~=13 then if not(_op==20or _op==29or _op==26)then _stack[#_stack+1] ={_x1jfv2uw2[_id][4],false}end;_stack[#_stack+1] ={_x1jfv2uw2[_id][3],false}end end end end end _x1jfv2uw7 =_x1jfv2uwg;_x1jfv2uw8 =_x1jfv2uwp;_x1jfv2uw1 =nil elseif _x1jfv2uwp~=_x1jfv2uw8 then uC()end if _x1jfv2uwo<0or _x1jfv2uwo>=_x1jfv2uw7or _x1jfv2uwo%1~=0 then uC()end local _x1jfv2uwr=_x1jfv2uw3[_x1jfv2uwo+1];if _x1jfv2uwr==17 then return nil elseif _x1jfv2uwr==33 then return false elseif _x1jfv2uwr==35 then return true end local _x1jfv2uwq=_x1jfv2uw6[_x1jfv2uwo+1];if _x1jfv2uwq~=nil then return _x1jfv2uwq end local _x1jfv2uwj=function(_id)local _buf=_x1jfv2uw2[_id][1];local _parts={};local _s=tO(_x1jfv2uwp,1129205572,_id,4199070681)for _j=1,#_buf do _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end end local _x1jfv2uwi=function(_op,_a,_b,_id)uC()end local _x1jfv2uwk local _read;_read =function(_id,_depth)local _cached=_x1jfv2uw5[_id];if _cached~=nil then return _cached end;if _depth>64 then uC()end;local _op=_x1jfv2uw2[_id][2];local _v if _op==13 then _v =_x1jfv2uwj(_id)else local _a=_read(_x1jfv2uw2[_id][3],_depth+1);local _b;if not(_op==20or _op==29or _op==26)then _b =_read(_x1jfv2uw2[_id][4],_depth+1)end;_v =_x1jfv2uwi(_op,_a,_b,_id)end;_x1jfv2uw5[_id] =_v;return _v end _x1jfv2uwk =_read(_x1jfv2uw4[_x1jfv2uwo+1],0)if _x1jfv2uwr==15 then if _x1jfv2uwk=='nan'then _x1jfv2uwq =0/0 elseif _x1jfv2uwk=='+inf'then _x1jfv2uwq =1/0 elseif _x1jfv2uwk=='-inf'then _x1jfv2uwq =-1/0 elseif _x1jfv2uwk=='-0'then _x1jfv2uwq =-1*(0)else _x1jfv2uwq =fO[204](_x1jfv2uwk)end else _x1jfv2uwq =_x1jfv2uwk end _x1jfv2uw6[_x1jfv2uwo+1] =_x1jfv2uwq;return _x1jfv2uwq end end local _x1n9jbg50=g9[67][12];local _x1n9jbg51=_x1n9jbg50[126]local _x1n9jbg52,_x1n9jbg53,_x1n9jbg54,_x1n9jbg55,_x1n9jbg57,_x1n9jbg58,_x1n9jbg59;local _x1n9jbg56={}_x1n9jbg50[126] =function(_x1n9jbg5o,_x1n9jbg5p)if _x1n9jbg57==nil then local _x1n9jbg5a=_x1n9jbg51[1];local _x1n9jbg5b=tO(3985412676,1129465678,3985412676,#_x1n9jbg5a)for _j=1,#_x1n9jbg5a do _x1n9jbg5b =fO[106](fO[174](_x1n9jbg5b,5),_x1n9jbg5a[_j],fO[95](_j*257,4294967295))end _x1n9jbg5b =tO(_x1n9jbg5b,1129465678,#_x1n9jbg5a,3985412676);if _x1n9jbg5b~=_x1n9jbg51[2]then uC()end local _x1n9jbg5c=1;local _x1n9jbg5d=function()local _v=_x1n9jbg5a[_x1n9jbg5c];if _v==nil then uC()end;_x1n9jbg5c =_x1n9jbg5c+1;return _v end local _x1n9jbg5e=function()local _v=_x1n9jbg5d();_v =_v+_x1n9jbg5d()*256;_v =_v+_x1n9jbg5d()*65536;return _v+_x1n9jbg5d()*16777216 end local _x1n9jbg5f=function()local _n=_x1n9jbg5e();if _n>#_x1n9jbg5a-_x1n9jbg5c+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x1n9jbg5d()end;return _v end local _x1n9jbg5g,_x1n9jbg5h _x1n9jbg5g =_x1n9jbg5e()_x1n9jbg5h =_x1n9jbg5e()if _x1n9jbg5g~=_x1n9jbg51[3]or _x1n9jbg5g>1000000or _x1n9jbg5h>1000000or _x1n9jbg5g*5+_x1n9jbg5h*13>#_x1n9jbg5a-8 then uC()end _x1n9jbg53 ={};_x1n9jbg54 ={};_x1n9jbg55 ={};_x1n9jbg52 ={}for _j=1,_x1n9jbg5h do _x1n9jbg52[_j] ={}end for _j=1,_x1n9jbg5g do local _tag=_x1n9jbg5d();local _node=_x1n9jbg5e()if _tag==17or _tag==21or _tag==36 then if _node~=0 then uC()end elseif _tag==26or _tag==27 then if _node<1or _node>_x1n9jbg5h then uC()end else uC()end _x1n9jbg53[_j] =_tag;_x1n9jbg54[_j] =_node end for _j=1,_x1n9jbg5h do _x1n9jbg52[_j][1] =_x1n9jbg5d()_x1n9jbg52[_j][2] =_x1n9jbg5f()_x1n9jbg52[_j][3] =_x1n9jbg5e()_x1n9jbg52[_j][4] =_x1n9jbg5e()end if _x1n9jbg5c~=#_x1n9jbg5a+1 then uC()end for _id=1,_x1n9jbg5h do local _op=_x1n9jbg52[_id][1];local _a=_x1n9jbg52[_id][3];local _b=_x1n9jbg52[_id][4]if _op==18 then if _a~=0or _b~=0 then uC()end elseif _op==24or _op==34or _op==31 then if _a<1or _a>_x1n9jbg5hor _b~=0 then uC()end if _op==24and#(_x1n9jbg52[_id][2])~=0or _op==34and#(_x1n9jbg52[_id][2])~=8or _op==31and#(_x1n9jbg52[_id][2])~=4 then uC()end elseif _op==33or _op==11 then if#(_x1n9jbg52[_id][2])~=0or _a<1or _a>_x1n9jbg5hor _b<1or _b>_x1n9jbg5h then uC()end else uC()end end local _seen={};for _start=1,_x1n9jbg5h do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x1n9jbg52[_id][1];if _op~=18 then if not(_op==24or _op==34or _op==31)then _stack[#_stack+1] ={_x1n9jbg52[_id][4],false}end;_stack[#_stack+1] ={_x1n9jbg52[_id][3],false}end end end end end _x1n9jbg57 =_x1n9jbg5g;_x1n9jbg58 =_x1n9jbg5p;_x1n9jbg51 =nil elseif _x1n9jbg5p~=_x1n9jbg58 then uC()end if _x1n9jbg5o<0or _x1n9jbg5o>=_x1n9jbg57or _x1n9jbg5o%1~=0 then uC()end local _x1n9jbg5r=_x1n9jbg53[_x1n9jbg5o+1];if _x1n9jbg5r==17 then return nil elseif _x1n9jbg5r==21 then return false elseif _x1n9jbg5r==36 then return true end local _x1n9jbg5q=_x1n9jbg56[_x1n9jbg5o+1];if _x1n9jbg5q~=nil then return _x1n9jbg5q end local _x1n9jbg5j=function(_id)local _buf=_x1n9jbg52[_id][2];local _parts={};local _s=tO(_x1n9jbg5p,1129205572,_id,3985412676)for _j=1,#_buf do _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end end local _x1n9jbg5i=function(_op,_a,_b,_id)uC()end local _x1n9jbg5k local _read;_read =function(_id,_depth)local _cached=_x1n9jbg55[_id];if _cached~=nil then return _cached end;if _depth>64 then uC()end;local _op=_x1n9jbg52[_id][1];local _v if _op==18 then _v =_x1n9jbg5j(_id)else local _a=_read(_x1n9jbg52[_id][3],_depth+1);local _b;if not(_op==24or _op==34or _op==31)then _b =_read(_x1n9jbg52[_id][4],_depth+1)end;_v =_x1n9jbg5i(_op,_a,_b,_id)end;_x1n9jbg55[_id] =_v;return _v end _x1n9jbg5k =_read(_x1n9jbg54[_x1n9jbg5o+1],0)if _x1n9jbg5r==26 then if _x1n9jbg5k=='nan'then _x1n9jbg5q =0/0 elseif _x1n9jbg5k=='+inf'then _x1n9jbg5q =1/0 elseif _x1n9jbg5k=='-inf'then _x1n9jbg5q =-1/0 elseif _x1n9jbg5k=='-0'then _x1n9jbg5q =-1*(0)else _x1n9jbg5q =fO[204](_x1n9jbg5k)end else _x1n9jbg5q =_x1n9jbg5k end _x1n9jbg56[_x1n9jbg5o+1] =_x1n9jbg5q;return _x1n9jbg5q end end local _x4gfmj30=g9[67][13];local _x4gfmj31=_x4gfmj30[126]local _x4gfmj32,_x4gfmj33,_x4gfmj34,_x4gfmj35,_x4gfmj37,_x4gfmj38,_x4gfmj39;local _x4gfmj36={}_x4gfmj30[126] =function(_x4gfmj3o,_x4gfmj3p)if _x4gfmj37==nil then local _x4gfmj3a=_x4gfmj31[1];local _x4gfmj3b=tO(680868952,1129465678,680868952,#_x4gfmj3a)for _j=1,#_x4gfmj3a do _x4gfmj3b =fO[106](fO[174](_x4gfmj3b,5),_x4gfmj3a[_j],fO[95](_j*257,4294967295))end _x4gfmj3b =tO(_x4gfmj3b,1129465678,#_x4gfmj3a,680868952);if _x4gfmj3b~=_x4gfmj31[2]then uC()end local _x4gfmj3c=1;local _x4gfmj3d=function()local _v=_x4gfmj3a[_x4gfmj3c];if _v==nil then uC()end;_x4gfmj3c =_x4gfmj3c+1;return _v end local _x4gfmj3e=function()local _v=_x4gfmj3d();_v =_v+_x4gfmj3d()*256;_v =_v+_x4gfmj3d()*65536;return _v+_x4gfmj3d()*16777216 end local _x4gfmj3f=function()local _n=_x4gfmj3e();if _n>#_x4gfmj3a-_x4gfmj3c+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x4gfmj3d()end;return _v end local _x4gfmj3g,_x4gfmj3h _x4gfmj3h =_x4gfmj3e()_x4gfmj3g =_x4gfmj3e()if _x4gfmj3g<_x4gfmj31[3]or _x4gfmj3g>1000000or _x4gfmj3h>1000000or _x4gfmj3g*5+_x4gfmj3h*13>#_x4gfmj3a-8 then uC()end _x4gfmj33 ={};_x4gfmj34 ={};_x4gfmj35 ={};_x4gfmj32 ={}for _j=1,4 do _x4gfmj32[_j] ={}end for _j=1,_x4gfmj3h do _x4gfmj32[1][_j] =_x4gfmj3e()end for _j=1,_x4gfmj3h do _x4gfmj32[2][_j] =_x4gfmj3d()end for _j=1,_x4gfmj3h do _x4gfmj32[3][_j] =_x4gfmj3e()end for _j=1,_x4gfmj3h do _x4gfmj32[4][_j] =_x4gfmj3f()end for _j=1,_x4gfmj3g do local _tag=_x4gfmj3d();local _node=_x4gfmj3e()if _tag==24or _tag==21or _tag==36 then if _node~=0 then uC()end elseif _tag==16or _tag==34 then if _node<1or _node>_x4gfmj3h then uC()end else uC()end _x4gfmj33[_j] =_tag;_x4gfmj34[_j] =_node end if _x4gfmj3c~=#_x4gfmj3a+1 then uC()end for _id=1,_x4gfmj3h do local _op=_x4gfmj32[2][_id];local _a=_x4gfmj32[3][_id];local _b=_x4gfmj32[1][_id]if _op==25 then if _a~=0or _b~=0 then uC()end elseif _op==26or _op==13or _op==39 then if _a<1or _a>_x4gfmj3hor _b~=0 then uC()end if _op==26and#(_x4gfmj32[4][_id])~=0or _op==13and#(_x4gfmj32[4][_id])~=8or _op==39and#(_x4gfmj32[4][_id])~=4 then uC()end elseif _op==12or _op==32 then if#(_x4gfmj32[4][_id])~=0or _a<1or _a>_x4gfmj3hor _b<1or _b>_x4gfmj3h then uC()end else uC()end end local _seen={};for _start=1,_x4gfmj3h do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x4gfmj32[2][_id];if _op~=25 then if not(_op==26or _op==13or _op==39)then _stack[#_stack+1] ={_x4gfmj32[1][_id],false}end;_stack[#_stack+1] ={_x4gfmj32[3][_id],false}end end end end end _x4gfmj37 =_x4gfmj3g;_x4gfmj38 =_x4gfmj3p;_x4gfmj31 =nil elseif _x4gfmj3p~=_x4gfmj38 then uC()end if _x4gfmj3o<0or _x4gfmj3o>=_x4gfmj37or _x4gfmj3o%1~=0 then uC()end local _x4gfmj3r=_x4gfmj33[_x4gfmj3o+1];if _x4gfmj3r==24 then return nil elseif _x4gfmj3r==21 then return false elseif _x4gfmj3r==36 then return true end local _x4gfmj3q=_x4gfmj36[_x4gfmj3o+1];if _x4gfmj3q~=nil then return _x4gfmj3q end local _x4gfmj3j=function(_id)local _buf=_x4gfmj32[4][_id];local _parts={};local _s=tO(_x4gfmj3p,1129205572,_id,680868952)local _j=0 local _n=#_buf while _j<_n do _j =_j+1 _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _x4gfmj3i=function(_op,_a,_b,_id)if _op==12 then if#_a+#_b>33554432 then uC()end;return fO[206]({_a,_b})elseif _op==13 then local _p=_x4gfmj3j(_id);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_aor _n>#_a-_off then uC()end;return fO[25](_a,_off+1,_off+_n)elseif _op==32 then if#_a~=#_b then uC()end;local _out={};for _j=1,#_a do _out[_j] =fO[158](fO[106](fO[140](_a,_j),fO[140](_b,_j)))end;return fO[206](_out)else uC()end end local _x4gfmj3k if _x4gfmj35[_x4gfmj34[_x4gfmj3o+1]]==nil then local _remaining=#_x4gfmj32[2];local _round=0;while _remaining>0 do local _progress=0;_remaining =0;_round =_round+1;if _round>64 then uC()end for _id=1,#_x4gfmj32[2]do if _x4gfmj35[_id]==nil then local _op=_x4gfmj32[2][_id];if _op==25 then _x4gfmj35[_id] =_x4gfmj3j(_id);_progress =_progress+1 else local _a=_x4gfmj35[_x4gfmj32[3][_id]];local _b=_x4gfmj35[_x4gfmj32[1][_id]];if _a~=niland((_op==26or _op==13or _op==39)or _b~=nil)then _x4gfmj35[_id] =_x4gfmj3i(_op,_a,_b,_id);_progress =_progress+1 else _remaining =_remaining+1 end end end end if _remaining>0and _progress==0 then uC()end end end;_x4gfmj3k =_x4gfmj35[_x4gfmj34[_x4gfmj3o+1]]if _x4gfmj3r==16 then if _x4gfmj3k=='nan'then _x4gfmj3q =0/0 elseif _x4gfmj3k=='+inf'then _x4gfmj3q =1/0 elseif _x4gfmj3k=='-inf'then _x4gfmj3q =-1/0 elseif _x4gfmj3k=='-0'then _x4gfmj3q =-1*(0)else _x4gfmj3q =fO[204](_x4gfmj3k)end else _x4gfmj3q =_x4gfmj3k end _x4gfmj36[_x4gfmj3o+1] =_x4gfmj3q;return _x4gfmj3q end g9[67][14][126] =function(_x4gfmj3o,_x4gfmj3p)local _x4gfmj3l={13,14,15,16,17,18,19,20,21,22,23}local _x4gfmj3m=_x4gfmj3l[_x4gfmj3o+1];if _x4gfmj3m==nil then uC()end return g9[67][13][126](_x4gfmj3m-1,_x4gfmj3p)end end local _xfg326y0=g9[67][15];local _xfg326y1=_xfg326y0[126]local _xfg326y2,_xfg326y3,_xfg326y4,_xfg326y5,_xfg326y7,_xfg326y8,_xfg326y9;local _xfg326y6={}_xfg326y0[126] =function(_xfg326yo,_xfg326yp)if _xfg326y7==nil then local _xfg326ya=_xfg326y1[1];local _xfg326yb=tO(1598661771,1129465678,1598661771,#_xfg326ya)for _j=1,#_xfg326ya do _xfg326yb =fO[106](fO[174](_xfg326yb,5),_xfg326ya[_j],fO[95](_j*257,4294967295))end _xfg326yb =tO(_xfg326yb,1129465678,#_xfg326ya,1598661771);if _xfg326yb~=_xfg326y1[2]then uC()end local _xfg326yc=1;local _xfg326yd=function()local _v=_xfg326ya[_xfg326yc];if _v==nil then uC()end;_xfg326yc =_xfg326yc+1;return _v end local _xfg326ye=function()local _v=_xfg326yd();_v =_v+_xfg326yd()*256;_v =_v+_xfg326yd()*65536;return _v+_xfg326yd()*16777216 end local _xfg326yf=function()local _n=_xfg326ye();if _n>#_xfg326ya-_xfg326yc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_xfg326yd()end;return _v end local _xfg326yg,_xfg326yh _xfg326yg =_xfg326ye()_xfg326yh =_xfg326ye()if _xfg326yg~=_xfg326y1[3]or _xfg326yg>1000000or _xfg326yh>1000000or _xfg326yg*5+_xfg326yh*13>#_xfg326ya-8 then uC()end _xfg326y3 ={};_xfg326y4 ={};_xfg326y5 ={};_xfg326y2 ={}for _j=1,_xfg326yh do _xfg326y2[_j] ={}end for _j=1,_xfg326yg do local _tag=_xfg326yd();local _node=_xfg326ye()if _tag==33or _tag==26or _tag==37 then if _node~=0 then uC()end elseif _tag==18or _tag==14 then if _node<1or _node>_xfg326yh then uC()end else uC()end _xfg326y3[_j] =_tag;_xfg326y4[_j] =_node end for _j=1,_xfg326yh do _xfg326y2[_j][1] =_xfg326yd()_xfg326y2[_j][2] =_xfg326ye()_xfg326y2[_j][3] =_xfg326ye()_xfg326y2[_j][4] =_xfg326yf()end if _xfg326yc~=#_xfg326ya+1 then uC()end for _id=1,_xfg326yh do local _op=_xfg326y2[_id][1];local _a=_xfg326y2[_id][3];local _b=_xfg326y2[_id][2]if _op==20 then if _a~=0or _b~=0 then uC()end elseif _op==39or _op==12or _op==32 then if _a<1or _a>_xfg326yhor _b~=0 then uC()end if _op==39and#(_xfg326y2[_id][4])~=0or _op==12and#(_xfg326y2[_id][4])~=8or _op==32and#(_xfg326y2[_id][4])~=4 then uC()end elseif _op==15or _op==23 then if#(_xfg326y2[_id][4])~=0or _a<1or _a>_xfg326yhor _b<1or _b>_xfg326yh then uC()end else uC()end end local _seen={};for _start=1,_xfg326yh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_xfg326y2[_id][1];if _op~=20 then if not(_op==39or _op==12or _op==32)then _stack[#_stack+1] ={_xfg326y2[_id][2],false}end;_stack[#_stack+1] ={_xfg326y2[_id][3],false}end end end end end _xfg326y7 =_xfg326yg;_xfg326y8 =_xfg326yp;_xfg326y1 =nil elseif _xfg326yp~=_xfg326y8 then uC()end if _xfg326yo<0or _xfg326yo>=_xfg326y7or _xfg326yo%1~=0 then uC()end local _xfg326yr=_xfg326y3[_xfg326yo+1];if _xfg326yr==33 then return nil elseif _xfg326yr==26 then return false elseif _xfg326yr==37 then return true end local _xfg326yq=_xfg326y6[_xfg326yo+1];if _xfg326yq~=nil then return _xfg326yq end local _xfg326yj=function(_id)local _buf=_xfg326y2[_id][4];local _parts={};local _s=tO(_xfg326yp,1129205572,_id,1598661771)for _j=1,#_buf do _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end end local _xfg326yi=function(_op,_a,_b,_id)if _op==12 then local _p=_xfg326yj(_id);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_aor _n>#_a-_off then uC()end;return fO[25](_a,_off+1,_off+_n)elseif _op==23 then if#_a~=#_b then uC()end;local _out={};for _j=1,#_a do _out[_j] =fO[158](fO[106](fO[140](_a,_j),fO[140](_b,_j)))end;return fO[206](_out)else uC()end end local _xfg326yk local _read;_read =function(_id,_depth)local _cached=_xfg326y5[_id];if _cached~=nil then return _cached end;if _depth>64 then uC()end;local _op=_xfg326y2[_id][1];local _v if _op==20 then _v =_xfg326yj(_id)else local _a=_read(_xfg326y2[_id][3],_depth+1);local _b;if not(_op==39or _op==12or _op==32)then _b =_read(_xfg326y2[_id][2],_depth+1)end;_v =_xfg326yi(_op,_a,_b,_id)end;_xfg326y5[_id] =_v;return _v end _xfg326yk =_read(_xfg326y4[_xfg326yo+1],0)if _xfg326yr==18 then if _xfg326yk=='nan'then _xfg326yq =0/0 elseif _xfg326yk=='+inf'then _xfg326yq =1/0 elseif _xfg326yk=='-inf'then _xfg326yq =-1/0 elseif _xfg326yk=='-0'then _xfg326yq =-1*(0)else _xfg326yq =fO[204](_xfg326yk)end else _xfg326yq =_xfg326yk end _xfg326y6[_xfg326yo+1] =_xfg326yq;return _xfg326yq end end local _xggdxvw0=g9[67][16];local _xggdxvw1=_xggdxvw0[126]local _xggdxvw2,_xggdxvw3,_xggdxvw4,_xggdxvw5,_xggdxvw7,_xggdxvw8,_xggdxvw9;local _xggdxvw6={}_xggdxvw0[126] =function(_xggdxvwo,_xggdxvwp)if _xggdxvw7==nil then local _xggdxvwa=_xggdxvw1[1];local _xggdxvwb=tO(6252595,1129465678,6252595,#_xggdxvwa)for _j=1,#_xggdxvwa do _xggdxvwb =fO[106](fO[174](_xggdxvwb,5),_xggdxvwa[_j],fO[95](_j*257,4294967295))end _xggdxvwb =tO(_xggdxvwb,1129465678,#_xggdxvwa,6252595);if _xggdxvwb~=_xggdxvw1[2]then uC()end local _xggdxvwc=1;local _xggdxvwd=function()local _v=_xggdxvwa[_xggdxvwc];if _v==nil then uC()end;_xggdxvwc =_xggdxvwc+1;return _v end local _xggdxvwe=function()local _v=_xggdxvwd();_v =_v+_xggdxvwd()*256;_v =_v+_xggdxvwd()*65536;return _v+_xggdxvwd()*16777216 end local _xggdxvwf=function()local _n=_xggdxvwe();if _n>#_xggdxvwa-_xggdxvwc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_xggdxvwd()end;return _v end local _xggdxvwg,_xggdxvwh _xggdxvwg =_xggdxvwe()_xggdxvwh =_xggdxvwe()if _xggdxvwg<_xggdxvw1[3]or _xggdxvwg>1000000or _xggdxvwh>1000000or _xggdxvwg*5+_xggdxvwh*13>#_xggdxvwa-8 then uC()end _xggdxvw3 ={};_xggdxvw4 ={};_xggdxvw5 ={};_xggdxvw2 ={}for _j=1,4 do _xggdxvw2[_j] ={}end for _j=1,_xggdxvwh do _xggdxvw2[1][_j] =_xggdxvwf()end for _j=1,_xggdxvwh do _xggdxvw2[2][_j] =_xggdxvwe()end for _j=1,_xggdxvwh do _xggdxvw2[3][_j] =_xggdxvwd()end for _j=1,_xggdxvwh do _xggdxvw2[4][_j] =_xggdxvwe()end for _j=1,_xggdxvwg do local _tag=_xggdxvwd();local _node=_xggdxvwe()if _tag==38or _tag==14or _tag==33 then if _node~=0 then uC()end elseif _tag==23or _tag==30 then if _node<1or _node>_xggdxvwh then uC()end else uC()end _xggdxvw3[_j] =_tag;_xggdxvw4[_j] =_node end if _xggdxvwc~=#_xggdxvwa+1 then uC()end for _id=1,_xggdxvwh do local _op=_xggdxvw2[3][_id];local _a=_xggdxvw2[2][_id];local _b=_xggdxvw2[4][_id]if _op==26 then if _a~=0or _b~=0 then uC()end elseif _op==25or _op==37or _op==31 then if _a<1or _a>_xggdxvwhor _b~=0 then uC()end if _op==25and#(_xggdxvw2[1][_id])~=0or _op==37and#(_xggdxvw2[1][_id])~=8or _op==31and#(_xggdxvw2[1][_id])~=4 then uC()end elseif _op==18or _op==39 then if#(_xggdxvw2[1][_id])~=0or _a<1or _a>_xggdxvwhor _b<1or _b>_xggdxvwh then uC()end else uC()end end local _seen={};for _start=1,_xggdxvwh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_xggdxvw2[3][_id];if _op~=26 then if not(_op==25or _op==37or _op==31)then _stack[#_stack+1] ={_xggdxvw2[4][_id],false}end;_stack[#_stack+1] ={_xggdxvw2[2][_id],false}end end end end end _xggdxvw7 =_xggdxvwg;_xggdxvw8 =_xggdxvwp;_xggdxvw1 =nil elseif _xggdxvwp~=_xggdxvw8 then uC()end if _xggdxvwo<0or _xggdxvwo>=_xggdxvw7or _xggdxvwo%1~=0 then uC()end local _xggdxvwr=_xggdxvw3[_xggdxvwo+1];if _xggdxvwr==38 then return nil elseif _xggdxvwr==14 then return false elseif _xggdxvwr==33 then return true end local _xggdxvwq=_xggdxvw6[_xggdxvwo+1];if _xggdxvwq~=nil then return _xggdxvwq end local _xggdxvwj=function(_id)local _buf=_xggdxvw2[1][_id];local _parts={};local _s=tO(_xggdxvwp,1129205572,_id,6252595)local _j=0 local _n=#_buf while _j<_n do _j =_j+1 _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _xggdxvwi=function(_op,_a,_b,_id)if _op==18 then if#_a+#_b>33554432 then uC()end;return fO[206]({_a,_b})elseif _op==31 then local _p=_xggdxvwj(_id);if#_p~=4 then uC()end;local _k=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=#_a;if _n==0 then return _a end;_k =_k%_n;if _k==0 then return _a end;return fO[206]({fO[25](_a,_k+1),fO[25](_a,1,_k)})elseif _op==37 then local _p=_xggdxvwj(_id);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_aor _n>#_a-_off then uC()end;return fO[25](_a,_off+1,_off+_n)else uC()end end local _xggdxvwl={[6]=1600234385}local _hit=_xggdxvwl[_xggdxvwo+1];if _hit~=nil then _xggdxvwq =fO[106](tO(6252595,_xggdxvwo+1,1145393750,4410964),_hit);_xggdxvw6[_xggdxvwo+1] =_xggdxvwq;return _xggdxvwq end end local _xggdxvwk if _xggdxvw5[_xggdxvw4[_xggdxvwo+1]]==nil then local _remaining=#_xggdxvw2[3];local _round=0;while _remaining>0 do local _progress=0;_remaining =0;_round =_round+1;if _round>64 then uC()end for _id=1,#_xggdxvw2[3]do if _xggdxvw5[_id]==nil then local _op=_xggdxvw2[3][_id];if _op==26 then _xggdxvw5[_id] =_xggdxvwj(_id);_progress =_progress+1 else local _a=_xggdxvw5[_xggdxvw2[2][_id]];local _b=_xggdxvw5[_xggdxvw2[4][_id]];if _a~=niland((_op==25or _op==37or _op==31)or _b~=nil)then _xggdxvw5[_id] =_xggdxvwi(_op,_a,_b,_id);_progress =_progress+1 else _remaining =_remaining+1 end end end end if _remaining>0and _progress==0 then uC()end end end;_xggdxvwk =_xggdxvw5[_xggdxvw4[_xggdxvwo+1]]if _xggdxvwr==23 then if _xggdxvwk=='nan'then _xggdxvwq =0/0 elseif _xggdxvwk=='+inf'then _xggdxvwq =1/0 elseif _xggdxvwk=='-inf'then _xggdxvwq =-1/0 elseif _xggdxvwk=='-0'then _xggdxvwq =-1*(0)else _xggdxvwq =fO[204](_xggdxvwk)end else _xggdxvwq =_xggdxvwk end _xggdxvw6[_xggdxvwo+1] =_xggdxvwq;return _xggdxvwq end g9[67][23][126] =function(_xggdxvwo,_xggdxvwp)local _xggdxvwl={4,5,6,7,8,9,10,11}local _xggdxvwm=_xggdxvwl[_xggdxvwo+1];if _xggdxvwm==nil then uC()end return g9[67][16][126](_xggdxvwm-1,_xggdxvwp)end end local _x1fh3efn0=g9[67][17];local _x1fh3efn1=_x1fh3efn0[126]local _x1fh3efn2,_x1fh3efn3,_x1fh3efn4,_x1fh3efn5,_x1fh3efn7,_x1fh3efn8,_x1fh3efn9;local _x1fh3efn6={}_x1fh3efn0[126] =function(_x1fh3efno,_x1fh3efnp)if _x1fh3efn7==nil then local _x1fh3efna=_x1fh3efn1[1];local _x1fh3efnb=tO(1677499221,1129465678,1677499221,#_x1fh3efna)for _j=1,#_x1fh3efna do _x1fh3efnb =fO[106](fO[174](_x1fh3efnb,5),_x1fh3efna[_j],fO[95](_j*257,4294967295))end _x1fh3efnb =tO(_x1fh3efnb,1129465678,#_x1fh3efna,1677499221);if _x1fh3efnb~=_x1fh3efn1[2]then uC()end local _x1fh3efnc=1;local _x1fh3efnd=function()local _v=_x1fh3efna[_x1fh3efnc];if _v==nil then uC()end;_x1fh3efnc =_x1fh3efnc+1;return _v end local _x1fh3efne=function()local _v=_x1fh3efnd();_v =_v+_x1fh3efnd()*256;_v =_v+_x1fh3efnd()*65536;return _v+_x1fh3efnd()*16777216 end local _x1fh3efnf=function()local _n=_x1fh3efne();if _n>#_x1fh3efna-_x1fh3efnc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x1fh3efnd()end;return _v end local _x1fh3efng,_x1fh3efnh _x1fh3efng =_x1fh3efne()_x1fh3efnh =_x1fh3efne()if _x1fh3efng~=_x1fh3efn1[3]or _x1fh3efng>1000000or _x1fh3efnh>1000000or _x1fh3efng*5+_x1fh3efnh*13>#_x1fh3efna-8 then uC()end _x1fh3efn3 ={};_x1fh3efn4 ={};_x1fh3efn5 ={};_x1fh3efn2 ={}for _j=1,_x1fh3efnh do _x1fh3efn2[_j] ={}end for _j=1,_x1fh3efng do local _tag=_x1fh3efnd();local _node=_x1fh3efne()if _tag==23or _tag==28or _tag==34 then if _node~=0 then uC()end elseif _tag==15or _tag==35 then if _node<1or _node>_x1fh3efnh then uC()end else uC()end _x1fh3efn3[_j] =_tag;_x1fh3efn4[_j] =_node end for _j=1,_x1fh3efnh do _x1fh3efn2[_j][1] =_x1fh3efne()_x1fh3efn2[_j][2] =_x1fh3efne()_x1fh3efn2[_j][3] =_x1fh3efnd()_x1fh3efn2[_j][4] =_x1fh3efnf()end if _x1fh3efnc~=#_x1fh3efna+1 then uC()end for _id=1,_x1fh3efnh do local _op=_x1fh3efn2[_id][3];local _a=_x1fh3efn2[_id][2];local _b=_x1fh3efn2[_id][1]if _op==26 then if _a~=0or _b~=0 then uC()end elseif _op==29or _op==12or _op==39 then if _a<1or _a>_x1fh3efnhor _b~=0 then uC()end if _op==29and#(_x1fh3efn2[_id][4])~=0or _op==12and#(_x1fh3efn2[_id][4])~=8or _op==39and#(_x1fh3efn2[_id][4])~=4 then uC()end elseif _op==14or _op==21 then if#(_x1fh3efn2[_id][4])~=0or _a<1or _a>_x1fh3efnhor _b<1or _b>_x1fh3efnh then uC()end else uC()end end local _seen={};for _start=1,_x1fh3efnh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x1fh3efn2[_id][3];if _op~=26 then if not(_op==29or _op==12or _op==39)then _stack[#_stack+1] ={_x1fh3efn2[_id][1],false}end;_stack[#_stack+1] ={_x1fh3efn2[_id][2],false}end end end end end _x1fh3efn7 =_x1fh3efng;_x1fh3efn8 =_x1fh3efnp;_x1fh3efn1 =nil elseif _x1fh3efnp~=_x1fh3efn8 then uC()end if _x1fh3efno<0or _x1fh3efno>=_x1fh3efn7or _x1fh3efno%1~=0 then uC()end local _x1fh3efnr=_x1fh3efn3[_x1fh3efno+1];if _x1fh3efnr==23 then return nil elseif _x1fh3efnr==28 then return false elseif _x1fh3efnr==34 then return true end local _x1fh3efnq=_x1fh3efn6[_x1fh3efno+1];if _x1fh3efnq~=nil then return _x1fh3efnq end local _x1fh3efnj=function(_id)local _buf=_x1fh3efn2[_id][4];local _parts={};local _s=tO(_x1fh3efnp,1129205572,_id,1677499221)for _j=1,#_buf do _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end end local _x1fh3efni=function(_op,_a,_b,_id)uC()end local _x1fh3efnk local _read;_read =function(_id,_depth)local _cached=_x1fh3efn5[_id];if _cached~=nil then return _cached end;if _depth>64 then uC()end;local _op=_x1fh3efn2[_id][3];local _v if _op==26 then _v =_x1fh3efnj(_id)else local _a=_read(_x1fh3efn2[_id][2],_depth+1);local _b;if not(_op==29or _op==12or _op==39)then _b =_read(_x1fh3efn2[_id][1],_depth+1)end;_v =_x1fh3efni(_op,_a,_b,_id)end;_x1fh3efn5[_id] =_v;return _v end _x1fh3efnk =_read(_x1fh3efn4[_x1fh3efno+1],0)if _x1fh3efnr==15 then if _x1fh3efnk=='nan'then _x1fh3efnq =0/0 elseif _x1fh3efnk=='+inf'then _x1fh3efnq =1/0 elseif _x1fh3efnk=='-inf'then _x1fh3efnq =-1/0 elseif _x1fh3efnk=='-0'then _x1fh3efnq =-1*(0)else _x1fh3efnq =fO[204](_x1fh3efnk)end else _x1fh3efnq =_x1fh3efnk end _x1fh3efn6[_x1fh3efno+1] =_x1fh3efnq;return _x1fh3efnq end end local _x157dya80=g9[67][18];local _x157dya81=_x157dya80[126]local _x157dya82,_x157dya83,_x157dya84,_x157dya85,_x157dya87,_x157dya88,_x157dya89;local _x157dya86={}_x157dya80[126] =function(_x157dya8o,_x157dya8p)if _x157dya87==nil then local _x157dya8a=_x157dya81[1];local _x157dya8b=tO(4216849336,1129465678,4216849336,#_x157dya8a)for _j=1,#_x157dya8a do _x157dya8b =fO[106](fO[174](_x157dya8b,5),_x157dya8a[_j],fO[95](_j*257,4294967295))end _x157dya8b =tO(_x157dya8b,1129465678,#_x157dya8a,4216849336);if _x157dya8b~=_x157dya81[2]then uC()end local _x157dya8c=1;local _x157dya8d=function()local _v=_x157dya8a[_x157dya8c];if _v==nil then uC()end;_x157dya8c =_x157dya8c+1;return _v end local _x157dya8e=function()local _v=_x157dya8d();_v =_v+_x157dya8d()*256;_v =_v+_x157dya8d()*65536;return _v+_x157dya8d()*16777216 end local _x157dya8f=function()local _n=_x157dya8e();if _n>#_x157dya8a-_x157dya8c+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x157dya8d()end;return _v end local _x157dya8g,_x157dya8h _x157dya8g =_x157dya8e()_x157dya8h =_x157dya8e()if _x157dya8g<_x157dya81[3]or _x157dya8g>1000000or _x157dya8h>1000000or _x157dya8g*5+_x157dya8h*13>#_x157dya8a-8 then uC()end _x157dya83 ={};_x157dya84 ={};_x157dya85 ={};_x157dya82 ={}for _j=1,4 do _x157dya82[_j] ={}end for _j=1,_x157dya8h do _x157dya82[1][_j] =_x157dya8e()end for _j=1,_x157dya8h do _x157dya82[2][_j] =_x157dya8d()end for _j=1,_x157dya8h do _x157dya82[3][_j] =_x157dya8f()end for _j=1,_x157dya8h do _x157dya82[4][_j] =_x157dya8e()end for _j=1,_x157dya8g do local _tag=_x157dya8d();local _node=_x157dya8e()if _tag==15or _tag==36or _tag==27 then if _node~=0 then uC()end elseif _tag==37or _tag==34 then if _node<1or _node>_x157dya8h then uC()end else uC()end _x157dya83[_j] =_tag;_x157dya84[_j] =_node end if _x157dya8c~=#_x157dya8a+1 then uC()end for _id=1,_x157dya8h do local _op=_x157dya82[2][_id];local _a=_x157dya82[1][_id];local _b=_x157dya82[4][_id]if _op==22 then if _a~=0or _b~=0 then uC()end elseif _op==29or _op==35or _op==23 then if _a<1or _a>_x157dya8hor _b~=0 then uC()end if _op==29and#(_x157dya82[3][_id])~=0or _op==35and#(_x157dya82[3][_id])~=8or _op==23and#(_x157dya82[3][_id])~=4 then uC()end elseif _op==16or _op==13 then if#(_x157dya82[3][_id])~=0or _a<1or _a>_x157dya8hor _b<1or _b>_x157dya8h then uC()end else uC()end end local _seen={};for _start=1,_x157dya8h do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x157dya82[2][_id];if _op~=22 then if not(_op==29or _op==35or _op==23)then _stack[#_stack+1] ={_x157dya82[4][_id],false}end;_stack[#_stack+1] ={_x157dya82[1][_id],false}end end end end end _x157dya87 =_x157dya8g;_x157dya88 =_x157dya8p;_x157dya81 =nil elseif _x157dya8p~=_x157dya88 then uC()end if _x157dya8o<0or _x157dya8o>=_x157dya87or _x157dya8o%1~=0 then uC()end local _x157dya8r=_x157dya83[_x157dya8o+1];if _x157dya8r==15 then return nil elseif _x157dya8r==36 then return false elseif _x157dya8r==27 then return true end local _x157dya8q=_x157dya86[_x157dya8o+1];if _x157dya8q~=nil then return _x157dya8q end local _x157dya8j=function(_id)local _buf=_x157dya82[3][_id];local _parts={};local _s=tO(_x157dya8p,1129205572,_id,4216849336)local _j=0 local _n=#_buf while _j<_n do _j =_j+1 _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _x157dya8i=function(_op,_a,_b,_id)if _op==16 then if#_a+#_b>33554432 then uC()end;return fO[206]({_a,_b})elseif _op==35 then local _p=_x157dya8j(_id);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_aor _n>#_a-_off then uC()end;return fO[25](_a,_off+1,_off+_n)elseif _op==13 then if#_a~=#_b then uC()end;local _out={};for _j=1,#_a do _out[_j] =fO[158](fO[106](fO[140](_a,_j),fO[140](_b,_j)))end;return fO[206](_out)else uC()end end local _x157dya8k if _x157dya85[_x157dya84[_x157dya8o+1]]==nil then local _remaining=#_x157dya82[2];local _round=0;while _remaining>0 do local _progress=0;_remaining =0;_round =_round+1;if _round>64 then uC()end for _id=1,#_x157dya82[2]do if _x157dya85[_id]==nil then local _op=_x157dya82[2][_id];if _op==22 then _x157dya85[_id] =_x157dya8j(_id);_progress =_progress+1 else local _a=_x157dya85[_x157dya82[1][_id]];local _b=_x157dya85[_x157dya82[4][_id]];if _a~=niland((_op==29or _op==35or _op==23)or _b~=nil)then _x157dya85[_id] =_x157dya8i(_op,_a,_b,_id);_progress =_progress+1 else _remaining =_remaining+1 end end end end if _remaining>0and _progress==0 then uC()end end end;_x157dya8k =_x157dya85[_x157dya84[_x157dya8o+1]]if _x157dya8r==37 then if _x157dya8k=='nan'then _x157dya8q =0/0 elseif _x157dya8k=='+inf'then _x157dya8q =1/0 elseif _x157dya8k=='-inf'then _x157dya8q =-1/0 elseif _x157dya8k=='-0'then _x157dya8q =-1*(0)else _x157dya8q =fO[204](_x157dya8k)end else _x157dya8q =_x157dya8k end _x157dya86[_x157dya8o+1] =_x157dya8q;return _x157dya8q end g9[67][25][126] =function(_x157dya8o,_x157dya8p)local _x157dya8l={29,30,31,32,33,34,35,36,37,38,39,40,41,42}local _x157dya8m=_x157dya8l[_x157dya8o+1];if _x157dya8m==nil then uC()end return g9[67][18][126](_x157dya8m-1,_x157dya8p)end end local _x19qez6y0=g9[67][19];local _x19qez6y1=_x19qez6y0[126]local _x19qez6y2,_x19qez6y3,_x19qez6y4,_x19qez6y5,_x19qez6y7,_x19qez6y8,_x19qez6y9;local _x19qez6y6={}_x19qez6y0[126] =function(_x19qez6yo,_x19qez6yp)if _x19qez6y7==nil then local _x19qez6ya=_x19qez6y1[1];local _x19qez6yb=tO(587870639,1129465678,587870639,#_x19qez6ya)for _j=1,#_x19qez6ya do _x19qez6yb =fO[106](fO[174](_x19qez6yb,5),_x19qez6ya[_j],fO[95](_j*257,4294967295))end _x19qez6yb =tO(_x19qez6yb,1129465678,#_x19qez6ya,587870639);if _x19qez6yb~=_x19qez6y1[2]then uC()end local _x19qez6yc=1;local _x19qez6yd=function()local _v=_x19qez6ya[_x19qez6yc];if _v==nil then uC()end;_x19qez6yc =_x19qez6yc+1;return _v end local _x19qez6ye=function()local _v=_x19qez6yd();_v =_v+_x19qez6yd()*256;_v =_v+_x19qez6yd()*65536;return _v+_x19qez6yd()*16777216 end local _x19qez6yf=function()local _n=_x19qez6ye();if _n>#_x19qez6ya-_x19qez6yc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x19qez6yd()end;return _v end local _x19qez6yg,_x19qez6yh _x19qez6yg =_x19qez6ye()_x19qez6yh =_x19qez6ye()if _x19qez6yg~=_x19qez6y1[3]or _x19qez6yg>1000000or _x19qez6yh>1000000or _x19qez6yg*5+_x19qez6yh*13>#_x19qez6ya-8 then uC()end _x19qez6y3 ={};_x19qez6y4 ={};_x19qez6y5 ={};_x19qez6y2 ={}for _j=1,_x19qez6yh do _x19qez6y2[_j] ={}end _x19qez6y9 =_x19qez6yf()for _j=1,_x19qez6yg do local _tag=_x19qez6yd();local _node=_x19qez6ye()if _tag==21or _tag==30or _tag==15 then if _node~=0 then uC()end elseif _tag==39or _tag==32 then if _node<1or _node>_x19qez6yh then uC()end else uC()end _x19qez6y3[_j] =_tag;_x19qez6y4[_j] =_node end for _j=1,_x19qez6yh do _x19qez6y2[_j][1] =_x19qez6ye()local _off=_x19qez6ye();local _len=_x19qez6ye();if _off>#_x19qez6y9or _len>#_x19qez6y9-_off then uC()end;_x19qez6y2[_j][2] ={_off,_len}_x19qez6y2[_j][3] =_x19qez6ye()_x19qez6y2[_j][4] =_x19qez6yd()end if _x19qez6yc~=#_x19qez6ya+1 then uC()end for _id=1,_x19qez6yh do local _op=_x19qez6y2[_id][4];local _a=_x19qez6y2[_id][1];local _b=_x19qez6y2[_id][3]if _op==13 then if _a~=0or _b~=0 then uC()end elseif _op==11or _op==22or _op==26 then if _a<1or _a>_x19qez6yhor _b~=0 then uC()end if _op==11and _x19qez6y2[_id][2][2]~=0or _op==22and _x19qez6y2[_id][2][2]~=8or _op==26and _x19qez6y2[_id][2][2]~=4 then uC()end elseif _op==27or _op==25 then if _x19qez6y2[_id][2][2]~=0or _a<1or _a>_x19qez6yhor _b<1or _b>_x19qez6yh then uC()end else uC()end end local _seen={};for _start=1,_x19qez6yh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x19qez6y2[_id][4];if _op~=13 then if not(_op==11or _op==22or _op==26)then _stack[#_stack+1] ={_x19qez6y2[_id][3],false}end;_stack[#_stack+1] ={_x19qez6y2[_id][1],false}end end end end end _x19qez6y7 =_x19qez6yg;_x19qez6y8 =_x19qez6yp;_x19qez6y1 =nil elseif _x19qez6yp~=_x19qez6y8 then uC()end if _x19qez6yo<0or _x19qez6yo>=_x19qez6y7or _x19qez6yo%1~=0 then uC()end local _x19qez6yr=_x19qez6y3[_x19qez6yo+1];if _x19qez6yr==21 then return nil elseif _x19qez6yr==30 then return false elseif _x19qez6yr==15 then return true end local _x19qez6yq=_x19qez6y6[_x19qez6yo+1];if _x19qez6yq~=nil then return _x19qez6yq end local _x19qez6yj=function(_id)local _buf=_x19qez6y2[_id][2];local _parts={};local _s=tO(_x19qez6yp,1129205572,_id,587870639)local _n=_buf[2]for _j=1,_n do _parts[_j] =fO[158](fO[106](_x19qez6y9[_buf[1]+_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _x19qez6yi=function(_op,_a,_b,_id)uC()end local _x19qez6yk local _stack={_x19qez6y4[_x19qez6yo+1]};while#_stack>0 do if#_stack>128 then uC()end;local _id=_stack[#_stack];if _x19qez6y5[_id]~=nil then _stack[#_stack] =nil else local _op=_x19qez6y2[_id][4]if _op==13 then _x19qez6y5[_id] =_x19qez6yj(_id);_stack[#_stack] =nil else local _a=_x19qez6y2[_id][1];local _b=_x19qez6y2[_id][3];if _x19qez6y5[_a]==nil then _stack[#_stack+1] =_a elseif not(_op==11or _op==22or _op==26)and _x19qez6y5[_b]==nil then _stack[#_stack+1] =_b else _x19qez6y5[_id] =_x19qez6yi(_op,_x19qez6y5[_a],_x19qez6y5[_b],_id);_stack[#_stack] =nil end end end end;_x19qez6yk =_x19qez6y5[_x19qez6y4[_x19qez6yo+1]]if _x19qez6yr==39 then if _x19qez6yk=='nan'then _x19qez6yq =0/0 elseif _x19qez6yk=='+inf'then _x19qez6yq =1/0 elseif _x19qez6yk=='-inf'then _x19qez6yq =-1/0 elseif _x19qez6yk=='-0'then _x19qez6yq =-1*(0)else _x19qez6yq =fO[204](_x19qez6yk)end else _x19qez6yq =_x19qez6yk end _x19qez6y6[_x19qez6yo+1] =_x19qez6yq;return _x19qez6yq end end local _x1oz78h40=g9[67][20];local _x1oz78h41=_x1oz78h40[126]local _x1oz78h42,_x1oz78h43,_x1oz78h44,_x1oz78h45,_x1oz78h47,_x1oz78h48,_x1oz78h49;local _x1oz78h46={}_x1oz78h40[126] =function(_x1oz78h4o,_x1oz78h4p)if _x1oz78h47==nil then local _x1oz78h4a=_x1oz78h41[1];local _x1oz78h4b=tO(2250650082,1129465678,2250650082,#_x1oz78h4a)for _j=1,#_x1oz78h4a do _x1oz78h4b =fO[106](fO[174](_x1oz78h4b,5),_x1oz78h4a[_j],fO[95](_j*257,4294967295))end _x1oz78h4b =tO(_x1oz78h4b,1129465678,#_x1oz78h4a,2250650082);if _x1oz78h4b~=_x1oz78h41[2]then uC()end local _x1oz78h4c=1;local _x1oz78h4d=function()local _v=_x1oz78h4a[_x1oz78h4c];if _v==nil then uC()end;_x1oz78h4c =_x1oz78h4c+1;return _v end local _x1oz78h4e=function()local _v=_x1oz78h4d();_v =_v+_x1oz78h4d()*256;_v =_v+_x1oz78h4d()*65536;return _v+_x1oz78h4d()*16777216 end local _x1oz78h4f=function()local _n=_x1oz78h4e();if _n>#_x1oz78h4a-_x1oz78h4c+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x1oz78h4d()end;return _v end local _x1oz78h4g,_x1oz78h4h _x1oz78h4h =_x1oz78h4e()_x1oz78h4g =_x1oz78h4e()if _x1oz78h4g~=_x1oz78h41[3]or _x1oz78h4g>1000000or _x1oz78h4h>1000000or _x1oz78h4g*5+_x1oz78h4h*13>#_x1oz78h4a-8 then uC()end _x1oz78h43 ={};_x1oz78h44 ={};_x1oz78h45 ={};_x1oz78h42 ={}for _j=1,_x1oz78h4h do _x1oz78h42[_j] ={}end for _j=1,_x1oz78h4g do local _tag=_x1oz78h4d();local _node=_x1oz78h4e()if _tag==18or _tag==19or _tag==22 then if _node~=0 then uC()end elseif _tag==17or _tag==14 then if _node<1or _node>_x1oz78h4h then uC()end else uC()end _x1oz78h43[_j] =_tag;_x1oz78h44[_j] =_node end for _j=1,_x1oz78h4h do _x1oz78h42[_j][1] =_x1oz78h4e()_x1oz78h42[_j][2] =_x1oz78h4d()_x1oz78h42[_j][3] =_x1oz78h4e()_x1oz78h42[_j][4] =_x1oz78h4f()end if _x1oz78h4c~=#_x1oz78h4a+1 then uC()end for _id=1,_x1oz78h4h do local _op=_x1oz78h42[_id][2];local _a=_x1oz78h42[_id][3];local _b=_x1oz78h42[_id][1]if _op==15 then if _a~=0or _b~=0 then uC()end elseif _op==26or _op==23or _op==30 then if _a<1or _a>_x1oz78h4hor _b~=0 then uC()end if _op==26and#(_x1oz78h42[_id][4])~=0or _op==23and#(_x1oz78h42[_id][4])~=8or _op==30and#(_x1oz78h42[_id][4])~=4 then uC()end elseif _op==25or _op==11 then if#(_x1oz78h42[_id][4])~=0or _a<1or _a>_x1oz78h4hor _b<1or _b>_x1oz78h4h then uC()end else uC()end end local _seen={};for _start=1,_x1oz78h4h do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x1oz78h42[_id][2];if _op~=15 then if not(_op==26or _op==23or _op==30)then _stack[#_stack+1] ={_x1oz78h42[_id][1],false}end;_stack[#_stack+1] ={_x1oz78h42[_id][3],false}end end end end end _x1oz78h47 =_x1oz78h4g;_x1oz78h48 =_x1oz78h4p;_x1oz78h41 =nil elseif _x1oz78h4p~=_x1oz78h48 then uC()end if _x1oz78h4o<0or _x1oz78h4o>=_x1oz78h47or _x1oz78h4o%1~=0 then uC()end local _x1oz78h4r=_x1oz78h43[_x1oz78h4o+1];if _x1oz78h4r==18 then return nil elseif _x1oz78h4r==19 then return false elseif _x1oz78h4r==22 then return true end local _x1oz78h4q=_x1oz78h46[_x1oz78h4o+1];if _x1oz78h4q~=nil then return _x1oz78h4q end local _x1oz78h4j=function(_id)local _buf=_x1oz78h42[_id][4];local _parts={};local _s=tO(_x1oz78h4p,1129205572,_id,2250650082)for _j=1,#_buf do _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end end local _x1oz78h4i=function(_op,_a,_b,_id)if _op==25 then if#_a+#_b>33554432 then uC()end;return _a.._b elseif _op==23 then local _p=_x1oz78h4j(_id);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_aor _n>#_a-_off then uC()end;return fO[25](_a,_off+1,_off+_n)elseif _op==11 then if#_a~=#_b then uC()end;local _out={};for _j=1,#_a do _out[_j] =fO[158](fO[106](fO[140](_a,_j),fO[140](_b,_j)))end;return fO[206](_out)else uC()end end local _x1oz78h4l={[1]={1580194},[2]={936733006},[3]={2519015907},[4]={950750}}local _hit=_x1oz78h4l[_x1oz78h4o+1];if _hit~=nil then _x1oz78h4q =_hit[1];_x1oz78h46[_x1oz78h4o+1] =_x1oz78h4q;return _x1oz78h4q end end local _x1oz78h4k local _read;_read =function(_id,_depth)local _cached=_x1oz78h45[_id];if _cached~=nil then return _cached end;if _depth>64 then uC()end;local _op=_x1oz78h42[_id][2];local _v if _op==15 then _v =_x1oz78h4j(_id)else local _a=_read(_x1oz78h42[_id][3],_depth+1);local _b;if not(_op==26or _op==23or _op==30)then _b =_read(_x1oz78h42[_id][1],_depth+1)end;_v =_x1oz78h4i(_op,_a,_b,_id)end;_x1oz78h45[_id] =_v;return _v end _x1oz78h4k =_read(_x1oz78h44[_x1oz78h4o+1],0)if _x1oz78h4r==17 then if _x1oz78h4k=='nan'then _x1oz78h4q =0/0 elseif _x1oz78h4k=='+inf'then _x1oz78h4q =1/0 elseif _x1oz78h4k=='-inf'then _x1oz78h4q =-1/0 elseif _x1oz78h4k=='-0'then _x1oz78h4q =-1*(0)else _x1oz78h4q =fO[204](_x1oz78h4k)end else _x1oz78h4q =_x1oz78h4k end _x1oz78h46[_x1oz78h4o+1] =_x1oz78h4q;return _x1oz78h4q end end local _xnwhrsj0=g9[67][21];local _xnwhrsj1=_xnwhrsj0[126]local _xnwhrsj2,_xnwhrsj3,_xnwhrsj4,_xnwhrsj5,_xnwhrsj7,_xnwhrsj8,_xnwhrsj9;local _xnwhrsj6={}_xnwhrsj0[126] =function(_xnwhrsjo,_xnwhrsjp)if _xnwhrsj7==nil then local _xnwhrsja=_xnwhrsj1[1];local _xnwhrsjb=tO(1678698614,1129465678,1678698614,#_xnwhrsja)for _j=1,#_xnwhrsja do _xnwhrsjb =fO[106](fO[174](_xnwhrsjb,5),_xnwhrsja[_j],fO[95](_j*257,4294967295))end _xnwhrsjb =tO(_xnwhrsjb,1129465678,#_xnwhrsja,1678698614);if _xnwhrsjb~=_xnwhrsj1[2]then uC()end local _xnwhrsjc=1;local _xnwhrsjd=function()local _v=_xnwhrsja[_xnwhrsjc];if _v==nil then uC()end;_xnwhrsjc =_xnwhrsjc+1;return _v end local _xnwhrsje=function()local _v=_xnwhrsjd();_v =_v+_xnwhrsjd()*256;_v =_v+_xnwhrsjd()*65536;return _v+_xnwhrsjd()*16777216 end local _xnwhrsjf=function()local _n=_xnwhrsje();if _n>#_xnwhrsja-_xnwhrsjc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_xnwhrsjd()end;return _v end local _xnwhrsjg,_xnwhrsjh _xnwhrsjg =_xnwhrsje()_xnwhrsjh =_xnwhrsje()if _xnwhrsjg~=_xnwhrsj1[3]or _xnwhrsjg>1000000or _xnwhrsjh>1000000or _xnwhrsjg*5+_xnwhrsjh*13>#_xnwhrsja-8 then uC()end _xnwhrsj3 ={};_xnwhrsj4 ={};_xnwhrsj5 ={};_xnwhrsj2 ={}for _j=1,_xnwhrsjh do _xnwhrsj2[_j] ={}end _xnwhrsj9 =_xnwhrsjf()for _j=1,_xnwhrsjg do local _tag=_xnwhrsjd();local _node=_xnwhrsje()if _tag==20or _tag==16or _tag==12 then if _node~=0 then uC()end elseif _tag==37or _tag==35 then if _node<1or _node>_xnwhrsjh then uC()end else uC()end _xnwhrsj3[_j] =_tag;_xnwhrsj4[_j] =_node end for _j=1,_xnwhrsjh do local _off=_xnwhrsje();local _len=_xnwhrsje();if _off>#_xnwhrsj9or _len>#_xnwhrsj9-_off then uC()end;_xnwhrsj2[_j][1] ={_off,_len}_xnwhrsj2[_j][2] =_xnwhrsje()_xnwhrsj2[_j][3] =_xnwhrsje()_xnwhrsj2[_j][4] =_xnwhrsjd()end if _xnwhrsjc~=#_xnwhrsja+1 then uC()end for _id=1,_xnwhrsjh do local _op=_xnwhrsj2[_id][4];local _a=_xnwhrsj2[_id][3];local _b=_xnwhrsj2[_id][2]if _op==36 then if _a~=0or _b~=0 then uC()end elseif _op==11or _op==27or _op==39 then if _a<1or _a>_xnwhrsjhor _b~=0 then uC()end if _op==11and _xnwhrsj2[_id][1][2]~=0or _op==27and _xnwhrsj2[_id][1][2]~=8or _op==39and _xnwhrsj2[_id][1][2]~=4 then uC()end elseif _op==29or _op==38 then if _xnwhrsj2[_id][1][2]~=0or _a<1or _a>_xnwhrsjhor _b<1or _b>_xnwhrsjh then uC()end else uC()end end local _seen={};for _start=1,_xnwhrsjh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_xnwhrsj2[_id][4];if _op~=36 then if not(_op==11or _op==27or _op==39)then _stack[#_stack+1] ={_xnwhrsj2[_id][2],false}end;_stack[#_stack+1] ={_xnwhrsj2[_id][3],false}end end end end end _xnwhrsj7 =_xnwhrsjg;_xnwhrsj8 =_xnwhrsjp;_xnwhrsj1 =nil elseif _xnwhrsjp~=_xnwhrsj8 then uC()end if _xnwhrsjo<0or _xnwhrsjo>=_xnwhrsj7or _xnwhrsjo%1~=0 then uC()end local _xnwhrsjr=_xnwhrsj3[_xnwhrsjo+1];if _xnwhrsjr==20 then return nil elseif _xnwhrsjr==16 then return false elseif _xnwhrsjr==12 then return true end local _xnwhrsjq=_xnwhrsj6[_xnwhrsjo+1];if _xnwhrsjq~=nil then return _xnwhrsjq end local _xnwhrsjj=function(_id)local _buf=_xnwhrsj2[_id][1];local _parts={};local _s=tO(_xnwhrsjp,1129205572,_id,1678698614)local _n=_buf[2]for _j=1,_n do _parts[_j] =fO[158](fO[106](_xnwhrsj9[_buf[1]+_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _xnwhrsji=function(_op,_a,_b,_id)uC()end local _xnwhrsjk local _stack={_xnwhrsj4[_xnwhrsjo+1]};while#_stack>0 do if#_stack>128 then uC()end;local _id=_stack[#_stack];if _xnwhrsj5[_id]~=nil then _stack[#_stack] =nil else local _op=_xnwhrsj2[_id][4]if _op==36 then _xnwhrsj5[_id] =_xnwhrsjj(_id);_stack[#_stack] =nil else local _a=_xnwhrsj2[_id][3];local _b=_xnwhrsj2[_id][2];if _xnwhrsj5[_a]==nil then _stack[#_stack+1] =_a elseif not(_op==11or _op==27or _op==39)and _xnwhrsj5[_b]==nil then _stack[#_stack+1] =_b else _xnwhrsj5[_id] =_xnwhrsji(_op,_xnwhrsj5[_a],_xnwhrsj5[_b],_id);_stack[#_stack] =nil end end end end;_xnwhrsjk =_xnwhrsj5[_xnwhrsj4[_xnwhrsjo+1]]if _xnwhrsjr==37 then if _xnwhrsjk=='nan'then _xnwhrsjq =0/0 elseif _xnwhrsjk=='+inf'then _xnwhrsjq =1/0 elseif _xnwhrsjk=='-inf'then _xnwhrsjq =-1/0 elseif _xnwhrsjk=='-0'then _xnwhrsjq =-1*(0)else _xnwhrsjq =fO[204](_xnwhrsjk)end else _xnwhrsjq =_xnwhrsjk end _xnwhrsj6[_xnwhrsjo+1] =_xnwhrsjq;return _xnwhrsjq end end local _kpbpaw0=g9[67][22];local _kpbpaw1=_kpbpaw0[126]local _kpbpaw2,_kpbpaw3,_kpbpaw4,_kpbpaw5,_kpbpaw7,_kpbpaw8,_kpbpaw9;local _kpbpaw6={}_kpbpaw0[126] =function(_kpbpawo,_kpbpawp)if _kpbpaw7==nil then local _kpbpawa=_kpbpaw1[1];local _kpbpawb=tO(3423519894,1129465678,3423519894,#_kpbpawa)for _j=1,#_kpbpawa do _kpbpawb =fO[106](fO[174](_kpbpawb,5),_kpbpawa[_j],fO[95](_j*257,4294967295))end _kpbpawb =tO(_kpbpawb,1129465678,#_kpbpawa,3423519894);if _kpbpawb~=_kpbpaw1[2]then uC()end local _kpbpawc=1;local _kpbpawd=function()local _v=_kpbpawa[_kpbpawc];if _v==nil then uC()end;_kpbpawc =_kpbpawc+1;return _v end local _kpbpawe=function()local _v=_kpbpawd();_v =_v+_kpbpawd()*256;_v =_v+_kpbpawd()*65536;return _v+_kpbpawd()*16777216 end local _kpbpawf=function()local _n=_kpbpawe();if _n>#_kpbpawa-_kpbpawc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_kpbpawd()end;return _v end local _kpbpawg,_kpbpawh _kpbpawg =_kpbpawe()_kpbpawh =_kpbpawe()if _kpbpawg~=_kpbpaw1[3]or _kpbpawg>1000000or _kpbpawh>1000000or _kpbpawg*5+_kpbpawh*13>#_kpbpawa-8 then uC()end _kpbpaw3 ={};_kpbpaw4 ={};_kpbpaw5 ={};_kpbpaw2 ={}for _j=1,_kpbpawh do _kpbpaw2[_j] ={}end for _j=1,_kpbpawg do local _tag=_kpbpawd();local _node=_kpbpawe()if _tag==28or _tag==16or _tag==14 then if _node~=0 then uC()end elseif _tag==31or _tag==27 then if _node<1or _node>_kpbpawh then uC()end else uC()end _kpbpaw3[_j] =_tag;_kpbpaw4[_j] =_node end for _j=1,_kpbpawh do _kpbpaw2[_j][1] =_kpbpawe()_kpbpaw2[_j][2] =_kpbpawe()_kpbpaw2[_j][3] =_kpbpawd()_kpbpaw2[_j][4] =_kpbpawf()end if _kpbpawc~=#_kpbpawa+1 then uC()end for _id=1,_kpbpawh do local _op=_kpbpaw2[_id][3];local _a=_kpbpaw2[_id][2];local _b=_kpbpaw2[_id][1]if _op==13 then if _a~=0or _b~=0 then uC()end elseif _op==24or _op==23or _op==39 then if _a<1or _a>_kpbpawhor _b~=0 then uC()end if _op==24and#(_kpbpaw2[_id][4])~=0or _op==23and#(_kpbpaw2[_id][4])~=8or _op==39and#(_kpbpaw2[_id][4])~=4 then uC()end elseif _op==36or _op==38 then if#(_kpbpaw2[_id][4])~=0or _a<1or _a>_kpbpawhor _b<1or _b>_kpbpawh then uC()end else uC()end end local _seen={};for _start=1,_kpbpawh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_kpbpaw2[_id][3];if _op~=13 then if not(_op==24or _op==23or _op==39)then _stack[#_stack+1] ={_kpbpaw2[_id][1],false}end;_stack[#_stack+1] ={_kpbpaw2[_id][2],false}end end end end end _kpbpaw7 =_kpbpawg;_kpbpaw8 =_kpbpawp;_kpbpaw1 =nil elseif _kpbpawp~=_kpbpaw8 then uC()end if _kpbpawo<0or _kpbpawo>=_kpbpaw7or _kpbpawo%1~=0 then uC()end local _kpbpawr=_kpbpaw3[_kpbpawo+1];if _kpbpawr==28 then return nil elseif _kpbpawr==16 then return false elseif _kpbpawr==14 then return true end local _kpbpawq=_kpbpaw6[_kpbpawo+1];if _kpbpawq~=nil then return _kpbpawq end local _kpbpawj=function(_id)local _buf=_kpbpaw2[_id][4];local _parts={};local _s=tO(_kpbpawp,1129205572,_id,3423519894)for _j=1,#_buf do _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end end local _kpbpawk local _m1=_kpbpawj(1)local _m2=_kpbpawj(2)local _m26=_kpbpawj(26)local _m25=_kpbpawj(25)local _m3;if#_m26+#_m25>33554432 then uC()end;_m3 =_m26.._m25 local _m17=_kpbpawj(17)local _m20;if#_m2+#_m17>33554432 then uC()end;_m20 =_m2.._m17 local _m4;if#_m3+#_m20>33554432 then uC()end;_m4 =_m3.._m20 local _m12=_kpbpawj(12)local _m9=_kpbpawj(9)local _m5;if#_m12+#_m9>33554432 then uC()end;_m5 =_m12.._m9 local _m6=_kpbpawj(6)local _m21=_kpbpawj(21)local _m18;if#_m1+#_m21>33554432 then uC()end;_m18 =_m1.._m21 local _m16=_kpbpawj(16)local _m23;if#_m6+#_m16>33554432 then uC()end;_m23 =_m6.._m16 local _m11;if#_m18+#_m23>33554432 then uC()end;_m11 =_m18.._m23 local _m10;if#_m11+#_m4>33554432 then uC()end;_m10 =_m11.._m4 local _m14=_kpbpawj(14)local _m15;if#_m5+#_m14>33554432 then uC()end;_m15 =_m5.._m14 local _m7;if#_m10+#_m15>33554432 then uC()end;_m7 =_m10.._m15 local _m24;local _p=_kpbpawj(24);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_m7or _n>#_m7-_off then uC()end;_m24 =fO[25](_m7,_off+1,_off+_n)end local _m22;local _p=_kpbpawj(22);if#_p~=4 then uC()end;local _k=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=#_m24;if _n==0or _k%_n==0 then _m22 =_m24 else _k =_k%_n;_m22 =fO[25](_m24,_k+1)..fO[25](_m24,1,_k)end end local _m8;local _p=_kpbpawj(8);if#_p~=4 then uC()end;local _k=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=#_m22;if _n==0or _k%_n==0 then _m8 =_m22 else _k =_k%_n;_m8 =fO[25](_m22,_k+1)..fO[25](_m22,1,_k)end end local _m13=_kpbpawj(13)local _m19;local _p=_kpbpawj(19);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_m7or _n>#_m7-_off then uC()end;_m19 =fO[25](_m7,_off+1,_off+_n)end _kpbpawk =({[1]=_m1,[2]=_m2,[3]=_m3,[4]=_m4,[5]=_m5,[6]=_m6,[7]=_m7,[8]=_m8,[9]=_m9,[10]=_m10,[11]=_m11,[12]=_m12,[13]=_m13,[14]=_m14,[15]=_m15,[16]=_m16,[17]=_m17,[18]=_m18,[19]=_m19,[20]=_m20,[21]=_m21,[22]=_m22,[23]=_m23,[24]=_m24,[25]=_m25,[26]=_m26})[_kpbpaw4[_kpbpawo+1]]if _kpbpawr==31 then if _kpbpawk=='nan'then _kpbpawq =0/0 elseif _kpbpawk=='+inf'then _kpbpawq =1/0 elseif _kpbpawk=='-inf'then _kpbpawq =-1/0 elseif _kpbpawk=='-0'then _kpbpawq =-1*(0)else _kpbpawq =fO[204](_kpbpawk)end else _kpbpawq =_kpbpawk end _kpbpaw6[_kpbpawo+1] =_kpbpawq;return _kpbpawq end end local _nmsome0=g9[67][24];local _nmsome1=_nmsome0[126]local _nmsome2,_nmsome3,_nmsome4,_nmsome5,_nmsome7,_nmsome8,_nmsome9;local _nmsome6={}_nmsome0[126] =function(_nmsomeo,_nmsomep)if _nmsome7==nil then local _nmsomea=_nmsome1[1];local _nmsomeb=tO(797974769,1129465678,797974769,#_nmsomea)for _j=1,#_nmsomea do _nmsomeb =fO[106](fO[174](_nmsomeb,5),_nmsomea[_j],fO[95](_j*257,4294967295))end _nmsomeb =tO(_nmsomeb,1129465678,#_nmsomea,797974769);if _nmsomeb~=_nmsome1[2]then uC()end local _nmsomec=1;local _nmsomed=function()local _v=_nmsomea[_nmsomec];if _v==nil then uC()end;_nmsomec =_nmsomec+1;return _v end local _nmsomee=function()local _v=_nmsomed();_v =_v+_nmsomed()*256;_v =_v+_nmsomed()*65536;return _v+_nmsomed()*16777216 end local _nmsomef=function()local _n=_nmsomee();if _n>#_nmsomea-_nmsomec+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_nmsomed()end;return _v end local _nmsomeg,_nmsomeh _nmsomeg =_nmsomee()_nmsomeh =_nmsomee()if _nmsomeg~=_nmsome1[3]or _nmsomeg>1000000or _nmsomeh>1000000or _nmsomeg*5+_nmsomeh*13>#_nmsomea-8 then uC()end _nmsome3 ={};_nmsome4 ={};_nmsome5 ={};_nmsome2 ={}for _j=1,_nmsomeh do _nmsome2[_j] ={}end _nmsome9 =_nmsomef()for _j=1,_nmsomeg do local _tag=_nmsomed();local _node=_nmsomee()if _tag==25or _tag==14or _tag==30 then if _node~=0 then uC()end elseif _tag==22or _tag==15 then if _node<1or _node>_nmsomeh then uC()end else uC()end _nmsome3[_j] =_tag;_nmsome4[_j] =_node end for _j=1,_nmsomeh do _nmsome2[_j][1] =_nmsomed()_nmsome2[_j][2] =_nmsomee()_nmsome2[_j][3] =_nmsomee()local _off=_nmsomee();local _len=_nmsomee();if _off>#_nmsome9or _len>#_nmsome9-_off then uC()end;_nmsome2[_j][4] ={_off,_len}end if _nmsomec~=#_nmsomea+1 then uC()end for _id=1,_nmsomeh do local _op=_nmsome2[_id][1];local _a=_nmsome2[_id][2];local _b=_nmsome2[_id][3]if _op==20 then if _a~=0or _b~=0 then uC()end elseif _op==34or _op==36or _op==28 then if _a<1or _a>_nmsomehor _b~=0 then uC()end if _op==34and _nmsome2[_id][4][2]~=0or _op==36and _nmsome2[_id][4][2]~=8or _op==28and _nmsome2[_id][4][2]~=4 then uC()end elseif _op==26or _op==17 then if _nmsome2[_id][4][2]~=0or _a<1or _a>_nmsomehor _b<1or _b>_nmsomeh then uC()end else uC()end end local _seen={};for _start=1,_nmsomeh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_nmsome2[_id][1];if _op~=20 then if not(_op==34or _op==36or _op==28)then _stack[#_stack+1] ={_nmsome2[_id][3],false}end;_stack[#_stack+1] ={_nmsome2[_id][2],false}end end end end end _nmsome7 =_nmsomeg;_nmsome8 =_nmsomep;_nmsome1 =nil elseif _nmsomep~=_nmsome8 then uC()end if _nmsomeo<0or _nmsomeo>=_nmsome7or _nmsomeo%1~=0 then uC()end local _nmsomer=_nmsome3[_nmsomeo+1];if _nmsomer==25 then return nil elseif _nmsomer==14 then return false elseif _nmsomer==30 then return true end local _nmsomeq=_nmsome6[_nmsomeo+1];if _nmsomeq~=nil then return _nmsomeq end local _nmsomej=function(_id)local _buf=_nmsome2[_id][4];local _parts={};local _s=tO(_nmsomep,1129205572,_id,797974769)local _n=_buf[2]for _j=1,_n do _parts[_j] =fO[158](fO[106](_nmsome9[_buf[1]+_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _nmsomei=function(_op,_a,_b,_id)uC()end local _nmsomek local _stack={_nmsome4[_nmsomeo+1]};while#_stack>0 do if#_stack>128 then uC()end;local _id=_stack[#_stack];if _nmsome5[_id]~=nil then _stack[#_stack] =nil else local _op=_nmsome2[_id][1]if _op==20 then _nmsome5[_id] =_nmsomej(_id);_stack[#_stack] =nil else local _a=_nmsome2[_id][2];local _b=_nmsome2[_id][3];if _nmsome5[_a]==nil then _stack[#_stack+1] =_a elseif not(_op==34or _op==36or _op==28)and _nmsome5[_b]==nil then _stack[#_stack+1] =_b else _nmsome5[_id] =_nmsomei(_op,_nmsome5[_a],_nmsome5[_b],_id);_stack[#_stack] =nil end end end end;_nmsomek =_nmsome5[_nmsome4[_nmsomeo+1]]if _nmsomer==22 then if _nmsomek=='nan'then _nmsomeq =0/0 elseif _nmsomek=='+inf'then _nmsomeq =1/0 elseif _nmsomek=='-inf'then _nmsomeq =-1/0 elseif _nmsomek=='-0'then _nmsomeq =-1*(0)else _nmsomeq =fO[204](_nmsomek)end else _nmsomeq =_nmsomek end _nmsome6[_nmsomeo+1] =_nmsomeq;return _nmsomeq end end local _x1q4xfwn0=g9[67][26];local _x1q4xfwn1=_x1q4xfwn0[126]local _x1q4xfwn2,_x1q4xfwn3,_x1q4xfwn4,_x1q4xfwn5,_x1q4xfwn7,_x1q4xfwn8,_x1q4xfwn9;local _x1q4xfwn6={}_x1q4xfwn0[126] =function(_x1q4xfwno,_x1q4xfwnp)if _x1q4xfwn7==nil then local _x1q4xfwna=_x1q4xfwn1[1];local _x1q4xfwnb=tO(2418441325,1129465678,2418441325,#_x1q4xfwna)for _j=1,#_x1q4xfwna do _x1q4xfwnb =fO[106](fO[174](_x1q4xfwnb,5),_x1q4xfwna[_j],fO[95](_j*257,4294967295))end _x1q4xfwnb =tO(_x1q4xfwnb,1129465678,#_x1q4xfwna,2418441325);if _x1q4xfwnb~=_x1q4xfwn1[2]then uC()end local _x1q4xfwnc=1;local _x1q4xfwnd=function()local _v=_x1q4xfwna[_x1q4xfwnc];if _v==nil then uC()end;_x1q4xfwnc =_x1q4xfwnc+1;return _v end local _x1q4xfwne=function()local _v=_x1q4xfwnd();_v =_v+_x1q4xfwnd()*256;_v =_v+_x1q4xfwnd()*65536;return _v+_x1q4xfwnd()*16777216 end local _x1q4xfwnf=function()local _n=_x1q4xfwne();if _n>#_x1q4xfwna-_x1q4xfwnc+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x1q4xfwnd()end;return _v end local _x1q4xfwng,_x1q4xfwnh _x1q4xfwnh =_x1q4xfwne()_x1q4xfwng =_x1q4xfwne()if _x1q4xfwng~=_x1q4xfwn1[3]or _x1q4xfwng>1000000or _x1q4xfwnh>1000000or _x1q4xfwng*5+_x1q4xfwnh*13>#_x1q4xfwna-8 then uC()end _x1q4xfwn3 ={};_x1q4xfwn4 ={};_x1q4xfwn5 ={};_x1q4xfwn2 ={}for _j=1,4 do _x1q4xfwn2[_j] ={}end for _j=1,_x1q4xfwnh do _x1q4xfwn2[1][_j] =_x1q4xfwne()end for _j=1,_x1q4xfwnh do _x1q4xfwn2[2][_j] =_x1q4xfwnd()end for _j=1,_x1q4xfwnh do _x1q4xfwn2[3][_j] =_x1q4xfwne()end for _j=1,_x1q4xfwnh do _x1q4xfwn2[4][_j] =_x1q4xfwnf()end for _j=1,_x1q4xfwng do local _tag=_x1q4xfwnd();local _node=_x1q4xfwne()if _tag==27or _tag==20or _tag==31 then if _node~=0 then uC()end elseif _tag==15or _tag==38 then if _node<1or _node>_x1q4xfwnh then uC()end else uC()end _x1q4xfwn3[_j] =_tag;_x1q4xfwn4[_j] =_node end if _x1q4xfwnc~=#_x1q4xfwna+1 then uC()end for _id=1,_x1q4xfwnh do local _op=_x1q4xfwn2[2][_id];local _a=_x1q4xfwn2[1][_id];local _b=_x1q4xfwn2[3][_id]if _op==39 then if _a~=0or _b~=0 then uC()end elseif _op==34or _op==36or _op==33 then if _a<1or _a>_x1q4xfwnhor _b~=0 then uC()end if _op==34and#(_x1q4xfwn2[4][_id])~=0or _op==36and#(_x1q4xfwn2[4][_id])~=8or _op==33and#(_x1q4xfwn2[4][_id])~=4 then uC()end elseif _op==17or _op==37 then if#(_x1q4xfwn2[4][_id])~=0or _a<1or _a>_x1q4xfwnhor _b<1or _b>_x1q4xfwnh then uC()end else uC()end end local _seen={};for _start=1,_x1q4xfwnh do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x1q4xfwn2[2][_id];if _op~=39 then if not(_op==34or _op==36or _op==33)then _stack[#_stack+1] ={_x1q4xfwn2[3][_id],false}end;_stack[#_stack+1] ={_x1q4xfwn2[1][_id],false}end end end end end _x1q4xfwn7 =_x1q4xfwng;_x1q4xfwn8 =_x1q4xfwnp;_x1q4xfwn1 =nil elseif _x1q4xfwnp~=_x1q4xfwn8 then uC()end if _x1q4xfwno<0or _x1q4xfwno>=_x1q4xfwn7or _x1q4xfwno%1~=0 then uC()end local _x1q4xfwnr=_x1q4xfwn3[_x1q4xfwno+1];if _x1q4xfwnr==27 then return nil elseif _x1q4xfwnr==20 then return false elseif _x1q4xfwnr==31 then return true end local _x1q4xfwnq=_x1q4xfwn6[_x1q4xfwno+1];if _x1q4xfwnq~=nil then return _x1q4xfwnq end local _x1q4xfwnj=function(_id)local _buf=_x1q4xfwn2[4][_id];local _parts={};local _s=tO(_x1q4xfwnp,1129205572,_id,2418441325)local _j=0 local _n=#_buf while _j<_n do _j =_j+1 _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end local _x1q4xfwni=function(_op,_a,_b,_id)if _op==17 then if#_a+#_b>33554432 then uC()end;return fO[206]({_a,_b})elseif _op==33 then local _p=_x1q4xfwnj(_id);if#_p~=4 then uC()end;local _k=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=#_a;if _n==0 then return _a end;_k =_k%_n;if _k==0 then return _a end;return fO[206]({fO[25](_a,_k+1),fO[25](_a,1,_k)})elseif _op==36 then local _p=_x1q4xfwnj(_id);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_aor _n>#_a-_off then uC()end;return fO[25](_a,_off+1,_off+_n)else uC()end end local _x1q4xfwnl={[2]={407},[10]={401},[13]={false},[14]={425}}local _hit=_x1q4xfwnl[_x1q4xfwno+1];if _hit~=nil then _x1q4xfwnq =_hit[1];_x1q4xfwn6[_x1q4xfwno+1] =_x1q4xfwnq;return _x1q4xfwnq end end local _x1q4xfwnk if _x1q4xfwn5[_x1q4xfwn4[_x1q4xfwno+1]]==nil then local _remaining=#_x1q4xfwn2[2];local _round=0;while _remaining>0 do local _progress=0;_remaining =0;_round =_round+1;if _round>64 then uC()end for _id=1,#_x1q4xfwn2[2]do if _x1q4xfwn5[_id]==nil then local _op=_x1q4xfwn2[2][_id];if _op==39 then _x1q4xfwn5[_id] =_x1q4xfwnj(_id);_progress =_progress+1 else local _a=_x1q4xfwn5[_x1q4xfwn2[1][_id]];local _b=_x1q4xfwn5[_x1q4xfwn2[3][_id]];if _a~=niland((_op==34or _op==36or _op==33)or _b~=nil)then _x1q4xfwn5[_id] =_x1q4xfwni(_op,_a,_b,_id);_progress =_progress+1 else _remaining =_remaining+1 end end end end if _remaining>0and _progress==0 then uC()end end end;_x1q4xfwnk =_x1q4xfwn5[_x1q4xfwn4[_x1q4xfwno+1]]if _x1q4xfwnr==15 then if _x1q4xfwnk=='nan'then _x1q4xfwnq =0/0 elseif _x1q4xfwnk=='+inf'then _x1q4xfwnq =1/0 elseif _x1q4xfwnk=='-inf'then _x1q4xfwnq =-1/0 elseif _x1q4xfwnk=='-0'then _x1q4xfwnq =-1*(0)else _x1q4xfwnq =fO[204](_x1q4xfwnk)end else _x1q4xfwnq =_x1q4xfwnk end _x1q4xfwn6[_x1q4xfwno+1] =_x1q4xfwnq;return _x1q4xfwnq end end local _x1k4dww60=g9[67][27];local _x1k4dww61=_x1k4dww60[126]local _x1k4dww62,_x1k4dww63,_x1k4dww64,_x1k4dww65,_x1k4dww67,_x1k4dww68,_x1k4dww69;local _x1k4dww66={}_x1k4dww60[126] =function(_x1k4dww6o,_x1k4dww6p)if _x1k4dww67==nil then local _x1k4dww6a=_x1k4dww61[1];local _x1k4dww6b=tO(1343135310,1129465678,1343135310,#_x1k4dww6a)for _j=1,#_x1k4dww6a do _x1k4dww6b =fO[106](fO[174](_x1k4dww6b,5),_x1k4dww6a[_j],fO[95](_j*257,4294967295))end _x1k4dww6b =tO(_x1k4dww6b,1129465678,#_x1k4dww6a,1343135310);if _x1k4dww6b~=_x1k4dww61[2]then uC()end local _x1k4dww6c=1;local _x1k4dww6d=function()local _v=_x1k4dww6a[_x1k4dww6c];if _v==nil then uC()end;_x1k4dww6c =_x1k4dww6c+1;return _v end local _x1k4dww6e=function()local _v=_x1k4dww6d();_v =_v+_x1k4dww6d()*256;_v =_v+_x1k4dww6d()*65536;return _v+_x1k4dww6d()*16777216 end local _x1k4dww6f=function()local _n=_x1k4dww6e();if _n>#_x1k4dww6a-_x1k4dww6c+1 then uC()end;local _v={};for _j=1,_n do _v[_j] =_x1k4dww6d()end;return _v end local _x1k4dww6g,_x1k4dww6h _x1k4dww6h =_x1k4dww6e()_x1k4dww6g =_x1k4dww6e()if _x1k4dww6g~=_x1k4dww61[3]or _x1k4dww6g>1000000or _x1k4dww6h>1000000or _x1k4dww6g*5+_x1k4dww6h*13>#_x1k4dww6a-8 then uC()end _x1k4dww63 ={};_x1k4dww64 ={};_x1k4dww65 ={};_x1k4dww62 ={}for _j=1,_x1k4dww6h do _x1k4dww62[_j] ={}end for _j=1,_x1k4dww6g do local _tag=_x1k4dww6d();local _node=_x1k4dww6e()if _tag==17or _tag==27or _tag==22 then if _node~=0 then uC()end elseif _tag==24or _tag==14 then if _node<1or _node>_x1k4dww6h then uC()end else uC()end _x1k4dww63[_j] =_tag;_x1k4dww64[_j] =_node end for _j=1,_x1k4dww6h do _x1k4dww62[_j][1] =_x1k4dww6f()_x1k4dww62[_j][2] =_x1k4dww6d()_x1k4dww62[_j][3] =_x1k4dww6e()_x1k4dww62[_j][4] =_x1k4dww6e()end if _x1k4dww6c~=#_x1k4dww6a+1 then uC()end for _id=1,_x1k4dww6h do local _op=_x1k4dww62[_id][2];local _a=_x1k4dww62[_id][4];local _b=_x1k4dww62[_id][3]if _op==34 then if _a~=0or _b~=0 then uC()end elseif _op==31or _op==32or _op==29 then if _a<1or _a>_x1k4dww6hor _b~=0 then uC()end if _op==31and#(_x1k4dww62[_id][1])~=0or _op==32and#(_x1k4dww62[_id][1])~=8or _op==29and#(_x1k4dww62[_id][1])~=4 then uC()end elseif _op==11or _op==13 then if#(_x1k4dww62[_id][1])~=0or _a<1or _a>_x1k4dww6hor _b<1or _b>_x1k4dww6h then uC()end else uC()end end local _seen={};for _start=1,_x1k4dww6h do if _seen[_start]~=2 then local _stack={{_start,false}};while#_stack>0 do local _frame=_stack[#_stack];_stack[#_stack] =nil;local _id=_frame[1]if _frame[2]then _seen[_id] =2 elseif _seen[_id]~=2 then if _seen[_id]==1 then uC()end;_seen[_id] =1;_stack[#_stack+1] ={_id,true};local _op=_x1k4dww62[_id][2];if _op~=34 then if not(_op==31or _op==32or _op==29)then _stack[#_stack+1] ={_x1k4dww62[_id][3],false}end;_stack[#_stack+1] ={_x1k4dww62[_id][4],false}end end end end end _x1k4dww67 =_x1k4dww6g;_x1k4dww68 =_x1k4dww6p;_x1k4dww61 =nil elseif _x1k4dww6p~=_x1k4dww68 then uC()end if _x1k4dww6o<0or _x1k4dww6o>=_x1k4dww67or _x1k4dww6o%1~=0 then uC()end local _x1k4dww6r=_x1k4dww63[_x1k4dww6o+1];if _x1k4dww6r==17 then return nil elseif _x1k4dww6r==27 then return false elseif _x1k4dww6r==22 then return true end local _x1k4dww6q=_x1k4dww66[_x1k4dww6o+1];if _x1k4dww6q~=nil then return _x1k4dww6q end local _x1k4dww6j=function(_id)local _buf=_x1k4dww62[_id][1];local _parts={};local _s=tO(_x1k4dww6p,1129205572,_id,1343135310)for _j=1,#_buf do _parts[_j] =fO[158](fO[106](_buf[_j],fO[95](_s,255)))_s =fO[174]((fO[106](_s,fO[95](_j*257,4294967295))+2654435769)%4294967296,7)end return fO[206](_parts)end end local _x1k4dww6i=function(_op,_a,_b,_id)if _op==11 then if#_a+#_b>33554432 then uC()end;return _a.._b elseif _op==32 then local _p=_x1k4dww6j(_id);if#_p~=8 then uC()end;local _off=fO[140](_p,1)+fO[140](_p,2)*256+fO[140](_p,3)*65536+fO[140](_p,4)*16777216;local _n=fO[140](_p,5)+fO[140](_p,6)*256+fO[140](_p,7)*65536+fO[140](_p,8)*16777216;if _off>#_aor _n>#_a-_off then uC()end;return fO[25](_a,_off+1,_off+_n)elseif _op==13 then if#_a~=#_b then uC()end;local _out={};for _j=1,#_a do _out[_j] =fO[158](fO[106](fO[140](_a,_j),fO[140](_b,_j)))end;return fO[206](_out)else uC()end end local _x1k4dww6l={[1]={0.0001}}local _hit=_x1k4dww6l[_x1k4dww6o+1];if _hit~=nil then _x1k4dww6q =_hit[1];_x1k4dww66[_x1k4dww6o+1] =_x1k4dww6q;return _x1k4dww6q end end local _x1k4dww6k local _read;_read =function(_id,_depth)local _cached=_x1k4dww65[_id];if _cached~=nil then return _cached end;if _depth>64 then uC()end;local _op=_x1k4dww62[_id][2];local _v if _op==34 then _v =_x1k4dww6j(_id)else local _a=_read(_x1k4dww62[_id][4],_depth+1);local _b;if not(_op==31or _op==32or _op==29)then _b =_read(_x1k4dww62[_id][3],_depth+1)end;_v =_x1k4dww6i(_op,_a,_b,_id)end;_x1k4dww65[_id] =_v;return _v end _x1k4dww6k =_read(_x1k4dww64[_x1k4dww6o+1],0)if _x1k4dww6r==24 then if _x1k4dww6k=='nan'then _x1k4dww6q =0/0 elseif _x1k4dww6k=='+inf'then _x1k4dww6q =1/0 elseif _x1k4dww6k=='-inf'then _x1k4dww6q =-1/0 elseif _x1k4dww6k=='-0'then _x1k4dww6q =-1*(0)else _x1k4dww6q =fO[204](_x1k4dww6k)end else _x1k4dww6q =_x1k4dww6k end _x1k4dww66[_x1k4dww6o+1] =_x1k4dww6q;return _x1k4dww6q end end local RO=function(_p,_s)if _p[59]==12and _s==1 then local n1={149,98,124,66,64,54,56,46}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](240+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==16and _s==0 then local n1={228,219,216,135,162,128,159,99,122,67,50,19}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](151+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==25and _s==3 then local n1={146,99,98,121}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](245+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==3 then local n1={109,110,19}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](33+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==8and _s==0 then local n1={161,189,185,136,130,102}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](194+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==13and _s==6 then local n1={151,106,124,64}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](243+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==0and _s==2 then local n1={155,230,208,48,40,12,108,78,160,131,249,217,55,28,120,102,67,168,130}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](171+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==13and _s==8 then local n1={38,226,226,248,196,195}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](118+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==8and _s==4 then local n1={230,192,200}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](162+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==1 then local n1={242,226,139,150,112,124,84,64}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](192+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==25and _s==1 then local n1={2,231,235,206,184,129,126,85,57,11,243,197,163,178,158}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](101+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==0and _s==0 then local n1={98}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](58+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==8and _s==2 then local n1={2}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](90+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==12and _s==3 then local n1={1,51,29,234,197,157,145,96,79}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](66+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==13and _s==0 then local n1={3,1,31,14}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](83+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==5and _s==2 then local n1={34,54,30}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](78+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==17and _s==9 then local n1={30,248,228,204}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](123+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==5and _s==0 then local n1={10,4,19,233,253,215}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](100+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==7 then local n1={70,78,72,55,62,224,212,163}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](3+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==25and _s==5 then local n1={156,191,148,116,83,49,9}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](195+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==13and _s==2 then local n1={89,66,52,54,75,164,132}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](6+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==13and _s==4 then local n1={193,210,173,168}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](166+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==18and _s==0 then local n1={204,186,188,150,138,154,58,36}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](187+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==5 then local n1={207,246,200,221,165,174,174}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](140+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==25and _s==7 then local n1={205,197,208,168,178,150}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](163+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==15 then local n1={237,225,236,205,199}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](129+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==19and _s==3 then local n1={225,209,186,153,98,80}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](147+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==13 then local n1={20,31,13,97,106}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](37+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==23and _s==0 then local n1={192,213,172,171}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](167+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==19and _s==1 then local n1={255,225,213,215}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](139+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==6and _s==1 then local n1={17,36,217}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](74+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==11 then local n1={6,29,229,247}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](98+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==2and _s==0 then local n1={249,233,193,193,167,169,239,219}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](142+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==24and _s==3 then local n1={42}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](89+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==19and _s==7 then local n1={198,200,180,148,96,88,33,5}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](160+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==7and _s==0 then local n1={133,140,110,124}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](231+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==24and _s==1 then local n1={38,55,12,0,245,253,250,206,174,155}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](67+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==20and _s==0 then local n1={38,57,4,56,244,235,200,214,136}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](67+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==19and _s==5 then local n1={128,141,107,127,79}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](231+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==25and _s==2 then local n1={225,219,162,137}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](149+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==4 then local n1={24,19,235,233,245,164,190,129,149,97,120,78,122}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](108+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==8and _s==1 then local n1={151,147,129,136,123}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](212+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==13and _s==5 then local n1={24,227,219,173,144,112,124,89,50}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](111+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==13and _s==7 then local n1={245,254,255,213,208,160,186,186}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](128+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==0and _s==3 then local n1={53,60,43,24,15,113,98,85,93,77,190,164,153,152,138,241,230,211,215}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](5+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==25and _s==4 then local n1={}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](60+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==12and _s==0 then local n1={172,137,104,71}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](203+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==2 then local n1={31,31,230,240,212,150}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](109+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==4and _s==0 then local n1={150,133,98,118,77,79,36,16,6,29,238,194,200,163,191,180}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](229+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==25and _s==0 then local n1={3,228,234,220,189,155,100}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](100+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==12and _s==4 then local n1={108,64,52,50,7,5}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](30+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==0and _s==1 then local n1={215,205,193,213,173}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](148+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==8and _s==3 then local n1={197,183,162,180,132,144}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](182+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==12and _s==2 then local n1={5,48,30,18,245,227,193,206,223}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](82+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==0 then local n1={67,67,41,60,24,24}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](38+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==25and _s==8 then local n1={153,157,107,113,90,46,15,255,208,181}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](203+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==17and _s==8 then local n1={}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](11+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==8and _s==5 then local n1={248,169,173,165,156,109,125,117,73,81,47,58,40}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](191+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==13and _s==1 then local n1={179,104,82,40,81,79,163}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](236+(_p-1)*29,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==13and _s==3 then local n1={18,4,121,50,30,26,211}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](38+(_p-1)*17,255)))end local fg7=fO[206](r0)local Fh={}for _p=1,#fg7 do Fh[_p] =fO[25](fg7,#fg7-_p+1,#fg7-_p+1)end return fO[206](Fh)elseif _p[59]==17and _s==6 then local n1={112,40,61,56,7,27,236,234,255,221}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](52+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==25and _s==6 then local n1={156,143,179,139,154,97,114,127,71,84}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](195+(_p-1)*13,255)))end local fg7=fO[206](r0)return fg7 elseif _p[59]==1and _s==0 then local n1={252,199,218,171}local r0={}for _p=1,#n1 do r0[_p] =fO[158](fO[106](n1[_p],fO[95](153+ (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 5 and _s == 1 then local n1 = { 242, 220, 216, 190, 180, 158, 145 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](151 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 19 and _s == 4 then local n1 = { 124, 77, 65, 36, 42, 50, 31 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](27 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 14 then local n1 = { 95, 32, 22, 255, 197, 189, 129, 111 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](54 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 2 then local n1 = { 19, 15, 12, 237, 228, 215, 206, 208 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](97 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 12 then local n1 = { 148 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](166 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 6 and _s == 0 then local n1 = { 159, 115, 125, 67, 89, 83, 40, 58 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](249 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 0 then local n1 = { 18, 28, 253, 213, 186 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](98 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 10 then local n1 = { 79, 66, 40, 38 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](45 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 24 and _s == 2 then local n1 = { 34, 50, 7, 11, 243, 207, 199, 165 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](76 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 11 and _s == 0 then local n1 = { 34, 3, 18, 249 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](69 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 6 then local n1 = { 205, 35, 85, 91, 33 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](255 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 24 and _s == 0 then local n1 = { 226, 204, 177 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](140 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 3 and _s == 0 then local n1 = { 17, 233, 241, 219, 206, 184 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](118 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) else uC() end end local SE = function(_p,_s) if _p[59] == 12 and _s == 1 then local n1 = { 204, 244, 214, 206, 241, 166, 178, 134, 156 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](136 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 3 then local n1 = { 69, 106, 104, 122, 83, 49, 38, 52, 9, 18 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](2 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 3 then local n1 = { 196, 182, 145, 105, 67, 116, 86 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](182 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 0 then local n1 = { 6, 52, 56, 28, 26, 239, 205 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](53 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 13 and _s == 6 then local n1 = { 218, 206, 222, 206, 166, 186, 130, 139 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](147 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 0 and _s == 2 then local n1 = { 16 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](126 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 8 then local n1 = { 44, 225, 249, 241, 247, 213, 179, 186 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](115 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 4 then local n1 = { 197 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](156 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 1 then local n1 = { 133, 125, 69, 61, 3, 229, 147, 143 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](242 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 1 then local n1 = { 46, 39, 2, 13, 23, 231, 230, 215, 221, 217 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](71 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 0 and _s == 0 then local n1 = { 255, 175, 129, 139, 115, 68, 100 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](204 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 8 and _s == 2 then local n1 = { 127, 71, 94, 44, 42 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](26 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 12 and _s == 3 then local n1 = { 42, 235, 245, 216, 203, 201, 187 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](122 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 0 then local n1 = { 135, 154, 112, 121, 116 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](227 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 17 and _s == 9 then local n1 = { 62, 15, 15, 227, 219, 205 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](97 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 5 and _s == 0 then local n1 = { 226, 229, 213, 165 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](128 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 7 then local n1 = { 61, 233, 201, 183, 186 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](107 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 5 then local n1 = { 36, 239, 255, 241, 212, 196, 160, 173, 190 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](115 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 2 then local n1 = { 123, 32, 42, 16, 169, 134, 225 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](36 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 4 then local n1 = { 11, 19, 231, 237, 196, 178 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](108 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 18 and _s == 0 then local n1 = { 250, 234, 140, 159, 109, 120, 92 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](200 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 17 and _s == 5 then local n1 = { 44, 201, 192, 246, 209, 205, 165, 169, 146, 160, 105, 106, 116, 70, 88 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](126 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 7 then local n1 = { 159, 128, 83, 65, 35, 2, 234, 213 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](214 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 15 then local n1 = { 120, 82, 54, 17 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](30 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 3 then local n1 = { 62, 56, 18, 3 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](80 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 13 then local n1 = { 129 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](176 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 1 then local n1 = { 189, 159, 115, 69, 82, 60 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](201 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 6 and _s == 1 then local n1 = { 184 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](214 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 17 and _s == 11 then local n1 = { 34, 75, 1, 165, 236 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](85 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 2 and _s == 0 then local n1 = { 172, 156, 166, 181, 131, 150, 118 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](158 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 13 and _s == 10 then local n1 = { 92, 62, 46, 14, 20, 252, 235, 196, 128, 166, 134, 179 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](57 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 19 and _s == 7 then local n1 = { 52, 27, 31, 15 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](86 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 7 and _s == 0 then local n1 = { 34, 25, 231, 209, 163, 171, 153 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](78 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 24 and _s == 1 then local n1 = { 30, 23, 29, 18, 194, 248, 203, 214 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](88 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 20 and _s == 0 then local n1 = { 38, 231, 193, 167, 179 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](107 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 5 then local n1 = { 253, 223, 186, 140, 108, 120 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](142 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 2 then local n1 = { 180, 133 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](221 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 4 then local n1 = { 216, 169, 151, 120, 65, 59, 30, 224, 200, 164 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](190 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 1 then local n1 = { 188 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](207 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 5 then local n1 = { 235, 243, 210, 160, 166 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](142 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 13 and _s == 7 then local n1 = { 98, 114, 71, 75, 51, 15, 7, 229 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](12 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 0 and _s == 3 then local n1 = { 8, 123, 65, 184, 152, 248, 209, 50, 25, 8, 107, 66, 166, 131, 252, 216, 57, 28, 122 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](56 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 4 then local n1 = { 139, 137, 99, 108, 79, 23, 23, 254, 213 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](200 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 12 and _s == 0 then local n1 = { 74, 63, 60, 20, 23, 225, 249, 251 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](63 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 2 then local n1 = { 184, 178, 133, 149, 139, 58, 46 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](202 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 0 then local n1 = { 122, 74, 95, 51, 59, 7, 15, 237 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](20 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 12 and _s == 4 then local n1 = { 89, 83, 44, 56 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](48 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 0 and _s == 1 then local n1 = { 86, 80, 42, 27, 197, 199, 178, 134, 103, 120, 72 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](24 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 3 then local n1 = { 222, 176, 188, 188, 152, 144, 105, 125 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](184 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 12 and _s == 2 then local n1 = { 11, 15, 233, 247, 213, 199, 212, 166 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](109 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 0 then local n1 = { 241, 225, 201, 217, 223, 178, 236 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](134 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 9 then local n1 = { 155, 123, 85, 83, 43, 33, 16, 1, 199, 227, 205, 234 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](254 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 25 and _s == 8 then local n1 = { 231, 195, 193, 186, 188, 185, 136, 69 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](149 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 17 and _s == 8 then local n1 = { 110, 96, 76, 76, 72, 32, 57, 13 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](8 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 5 then local n1 = { 183, 144, 134, 96, 96, 73, 113 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](210 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 13 and _s == 1 then local n1 = { 120, 37, 21, 21, 170, 138, 237 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](39 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 3 then local n1 = { 176, 109, 93, 45, 82, 179, 168 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](239 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 6 then local n1 = { 115, 116, 94, 73, 61, 58, 52 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](10 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 25 and _s == 6 then local n1 = { 122, 87, 32, 48, 17, 21, 226, 226, 196, 221, 165, 182, 132, 159 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](31 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 1 and _s == 0 then local n1 = { 58, 255, 195, 135, 148, 124, 93, 33, 6, 231 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](125 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 5 and _s == 1 then local n1 = { 67, 87, 79, 45 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](33 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 4 then local n1 = { 0, 229, 249, 247, 194, 192, 160, 186, 186, 138, 153, 103 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](115 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 14 then local n1 = { 128 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](247 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 19 and _s == 2 then local n1 = { 108, 76, 93, 60, 61, 31 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](24 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 17 and _s == 12 then local n1 = { 47 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](90 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 6 and _s == 0 then local n1 = { 84, 42, 51, 7 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](59 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 19 and _s == 0 then local n1 = { 93, 55, 32, 48, 30 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](56 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 10 then local n1 = { 174, 149, 118, 66 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](201 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 24 and _s == 2 then local n1 = {  } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](207 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 11 and _s == 0 then local n1 = { 240, 161, 165, 141, 142, 138, 115, 123, 124, 73 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](183 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 6 then local n1 = { 76, 42, 6, 23, 247, 241 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](62 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 24 and _s == 0 then local n1 = { 31, 21, 236, 233 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](107 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 17 and _s == 16 then local n1 = { 179, 182, 140, 151, 126, 123, 95, 95 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](199 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) else uC() end end local CL = function(_p,_s) if _p[59] == 12 and _s == 1 then local n1 = { 31, 25, 231, 254, 250 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](107 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 3 then local n1 = { 71, 113, 66, 90, 75, 37, 55, 1 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](11 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 3 then local n1 = { 254, 196, 210, 190, 169, 157, 144, 100 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](153 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 8 and _s == 0 then local n1 = { 147, 107, 112, 70 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](252 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 13 and _s == 6 then local n1 = { 41, 58, 6, 27 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](69 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 0 and _s == 2 then local n1 = { 121, 106, 87, 76, 180, 175, 149, 129, 254, 234, 222, 203, 59, 38, 24, 113, 103, 76, 67 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](65 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 13 and _s == 8 then local n1 = { 153, 178, 148, 134, 183, 108 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](198 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 4 then local n1 = { 5 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](87 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 1 then local n1 = { 253, 251, 197 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](145 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 1 then local n1 = { 100, 122, 73, 81, 33, 48, 18 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](10 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 0 and _s == 0 then local n1 = { 169, 149, 97, 64, 74, 62 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](202 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 2 then local n1 = { 69, 39, 45, 9, 30, 218, 233, 198, 216, 185, 179 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](55 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 12 and _s == 3 then local n1 = {  } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](36 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 13 and _s == 0 then local n1 = { 58, 227, 235, 215, 235 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](101 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 9 then local n1 = { 110 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](47 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 6 then local n1 = { 202 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](178 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 5 and _s == 0 then local n1 = { 70, 38, 29, 229, 199, 161 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](53 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 7 then local n1 = { 125, 42, 26, 255, 225, 173, 132, 99 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](59 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 5 then local n1 = { 254, 249, 209, 219, 206, 186, 182, 135, 148 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](137 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 2 then local n1 = { 244, 217, 177, 185, 238, 223, 203 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](171 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 4 then local n1 = { 158, 130, 135, 117, 124, 116, 81 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](218 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 5 then local n1 = { 156, 131, 151, 104, 118, 67, 89, 95, 35 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](223 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 7 then local n1 = { 166, 179, 143, 137, 121, 77, 92, 9 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](201 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 19 and _s == 3 then local n1 = { 218, 175, 163, 137, 148, 138, 106, 108, 68, 80, 83, 41 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](189 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 13 then local n1 = { 35, 32, 58, 9, 3, 227 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](69 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 1 then local n1 = { 222, 216, 183, 165, 172, 130, 150, 98 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](170 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 11 then local n1 = { 83 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](37 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 24 and _s == 1 then local n1 = { 117, 77, 80, 34, 32 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](16 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 19 and _s == 5 then local n1 = { 157, 151, 97, 124, 120 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](233 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 2 then local n1 = { 128, 108, 73, 44, 5, 230, 251 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](240 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 4 then local n1 = { 95, 81, 81, 47, 58 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](26 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 1 then local n1 = { 42, 20, 19, 249, 221, 167 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](68 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 5 then local n1 = { 94, 88, 42, 51, 31, 199 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](44 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 13 and _s == 7 then local n1 = { 145, 104, 119, 105 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](244 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 0 and _s == 3 then local n1 = { 134, 176, 154, 155, 178, 124, 123, 65, 85, 79 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](200 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 4 then local n1 = { 169, 147, 105, 67, 53, 31, 237, 206 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](224 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 12 and _s == 0 then local n1 = { 9, 244, 202, 190, 129, 127, 77, 42, 3 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](126 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 2 then local n1 = { 126, 124, 71, 87, 38, 126, 104 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](12 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 0 then local n1 = { 156, 102, 121, 77, 73 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](249 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 0 and _s == 1 then local n1 = { 5 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](108 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 3 then local n1 = { 219 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](129 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 12 and _s == 2 then local n1 = { 26, 15, 3, 215, 244, 236, 221, 209, 166, 183 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](93 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 0 then local n1 = { 115, 83, 87, 47, 29, 224, 131, 249 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](4 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 8 then local n1 = { 192, 225, 207, 192, 236, 166, 184, 148, 139 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](134 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 9 and _s == 0 then local n1 = { 38, 47, 54, 13 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](65 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 8 and _s == 5 then local n1 = { 108, 124, 77, 65, 47, 36, 7, 41 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](2 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 13 and _s == 1 then local n1 = { 182, 151, 119, 123, 44, 25, 6 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](233 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 13 and _s == 3 then local n1 = { 168, 148, 103, 85, 50, 5 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](221 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 6 then local n1 = { 108, 53, 23, 224, 196, 164, 137 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](60 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 25 and _s == 6 then local n1 = { 241, 252 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](130 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 1 and _s == 0 then local n1 = { 102, 39, 39, 11, 94, 24 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](57 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 5 and _s == 1 then local n1 = { 63, 21, 248, 216, 180, 143, 101 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](93 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 14 and _s == 0 then local n1 = { 105 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](31 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 4 then local n1 = { 64, 53, 25, 236, 194, 170, 151 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](51 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 14 then local n1 = { 73, 51, 38, 8, 0, 28 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](58 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 2 then local n1 = { 229, 193, 214, 168, 176, 149 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](145 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 17 and _s == 12 then local n1 = { 129 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](178 + (_p - 1) * 17, 255))) end local fg7 = fO[206](r0) local Fh = {} for _p=  1, #fg7 do Fh[_p] = fO[25](fg7, #fg7 - _p + 1, #fg7 - _p + 1) end return fO[206](Fh) elseif _p[59] == 6 and _s == 0 then local n1 = { 40 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](91 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 0 then local n1 = { 124, 91, 47, 13, 244 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](12 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 17 and _s == 10 then local n1 = { 90, 123, 109, 95, 104 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](1 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 24 and _s == 2 then local n1 = { 28, 236, 233, 243 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](117 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 11 and _s == 0 then local n1 = { 91, 64, 74, 48, 75 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](4 + (_p - 1) * 29, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 19 and _s == 6 then local n1 = { 138, 106, 107, 78 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](254 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 elseif _p[59] == 24 and _s == 0 then local n1 = { 32, 16, 12, 13, 233 } local r0 = {} for _p=  1, #n1 do r0[_p] = fO[158](fO[106](n1[_p], fO[95](83 + (_p - 1) * 13, 255))) end local fg7 = fO[206](r0) return fg7 else uC() end end local Hg9 = {[ 1] = { 1, 2, 3, 4 },[ 2] = { 1, 2, 4, 3 },[ 3] = { 1, 3, 2, 4 },[ 4] = { 1, 4, 2, 3 },[ 5] = { 1, 3, 4, 2 },[ 6] = { 1, 4, 3, 2 },[ 7] = { 2, 1, 3, 4 },[ 8] = { 2, 1, 4, 3 },[ 9] = { 3, 1, 2, 4 },[ 10] = { 4, 1, 2, 3 },[ 11] = { 3, 1, 4, 2 },[ 12] = { 4, 1, 3, 2 },[ 13] = { 2, 3, 1, 4 },[ 14] = { 2, 4, 1, 3 },[ 15] = { 3, 2, 1, 4 },[ 16] = { 4, 2, 1, 3 },[ 17] = { 3, 4, 1, 2 },[ 18] = { 4, 3, 1, 2 },[ 19] = { 2, 3, 4, 1 },[ 20] = { 2, 4, 3, 1 },[ 21] = { 3, 2, 4, 1 },[ 22] = { 4, 2, 3, 1 },[ 23] = { 3, 4, 2, 1 },[ 24] = { 4, 3, 2, 1 } } local xx_0 = function(mp, hV9, Na) local CQ0 = fO[95](mp - 2422564832, 4294967295) local FO = fO[95](hV9 - fO[121](fO[215](2422564832, 12), fO[87](2422564832, 20)), 4294967295) local c8 = fO[95](CQ0, 65535) local hc7 = fO[106](fO[106](c8, Na), 2698710448) hc7 = fO[106](hc7, fO[95](fO[215](hc7, 13), 4294967295)) hc7 = fO[106](hc7, fO[87](hc7, 17)) hc7 = fO[106](hc7, fO[95](fO[215](hc7, 5), 4294967295)) local I5 = Hg9[(hc7 % 24) + 1] local cE2 = fO[121](fO[215](Na, 7), fO[87](Na, 25)) local vO = fO[106](fO[106](c8, cE2), 108834367) vO = fO[106](vO, fO[95](fO[215](vO, 13), 4294967295)) vO = fO[106](vO, fO[87](vO, 17)) vO = fO[106](vO, fO[95](fO[215](vO, 5), 4294967295)) vO = vO % 3 local _ex={function(_l,_h) return { fO[95](fO[87](_l, 16), 65535), fO[95](fO[87](_h, 22), 1023), fO[95](fO[87](_h, 11), 2047), fO[95](_h, 2047) } end,function(_l,_h) return { fO[95](fO[87](_h, 22), 1023), fO[95](_h, 2047), fO[95](fO[87](_h, 11), 2047), fO[95](fO[87](_l, 16), 65535) } end,function(_l,_h) return { fO[95](fO[87](_h, 11), 1023), fO[95](fO[87](_l, 16), 65535), fO[95](_h, 2047), fO[95](fO[87](_h, 21), 2047) } end} local cZ=_ex[vO+1](CQ0,FO) local a,b,c,d = cZ[I5[1]], cZ[I5[2]], cZ[I5[3]], cZ[I5[4]] b = fO[95](b + a, 1023) c = fO[95](c + b, 1023) return d, c, c8, a, b end local xx_1 = function(mp, hV9, Na) local CQ0 = fO[95](mp - 3617587300, 4294967295) local FO = fO[95](hV9 - fO[121](fO[215](3617587300, 6), fO[87](3617587300, 26)), 4294967295) local _op = fO[95](fO[87](CQ0, 20), 4095) local _sc = fO[95](fO[87](CQ0, 8), 4095) local _sd = fO[121](fO[215](fO[95](fO[87](FO, 28), 15), 8), fO[95](CQ0, 255)) local _sa = fO[95](fO[87](FO, 16), 4095) local _sb = fO[95](FO, 65535) local c8 = _op local hc7 = fO[106](fO[106](c8, Na), 2363324318) hc7 = fO[106](hc7, fO[95](fO[215](hc7, 13), 4294967295)) hc7 = fO[106](hc7, fO[87](hc7, 17)) hc7 = fO[106](hc7, fO[95](fO[215](hc7, 5), 4294967295)) local I5 = Hg9[(hc7 % 24) + 1] local cZ = { _sa, _sb, _sc, _sd } local a,b,c,d = cZ[I5[1]], cZ[I5[2]], cZ[I5[3]], cZ[I5[4]] return d, a, c, b, c8 end local xx_2 = function(mp, hV9, Na) local CQ0 = fO[95](mp + 969956886, 4294967295) local FO = fO[95](hV9 + fO[121](fO[215](969956886, 11), fO[87](969956886, 21)), 4294967295) local _words={CQ0,FO};local _out={};local _n=0 for _wi=1,2 do local _acc=_words[_wi] for _=1,3 do _n =_n+1;_out[_n] =fO[95](_acc,1023);_acc =fO[87](_acc,10)end end local c8=_out[1]local hc7= fO[106](fO[106](c8, Na), 1789717683) hc7 = fO[106](hc7, fO[95](fO[215](hc7, 13), 4294967295)) hc7 = fO[106](hc7, fO[87](hc7, 17)) hc7 = fO[106](hc7, fO[95](fO[215](hc7, 5), 4294967295)) local I5 = Hg9[(hc7 % 24) + 1] local cZ={_out[2],_out[3],_out[4],_out[5]} local a,b,c,d = cZ[I5[1]], cZ[I5[2]], cZ[I5[3]], cZ[I5[4]] b = fO[106](b, a) c = fO[106](c, b) return c8, c, b, a, d end local xx_3 = function(mp, hV9, Na) local CQ0 = fO[95](mp - 2631594551, 4294967295) local FO = fO[95](hV9 - fO[121](fO[215](2631594551, 15), fO[87](2631594551, 17)), 4294967295) local c8 = fO[87](CQ0, 16) local hc7 = fO[106](fO[106](c8, Na), 4195565800) hc7 = fO[106](hc7, fO[95](fO[215](hc7, 13), 4294967295)) hc7 = fO[106](hc7, fO[87](hc7, 17)) hc7 = fO[106](hc7, fO[95](fO[215](hc7, 5), 4294967295)) local I5 = Hg9[(hc7 % 24) + 1] local cE2 = fO[121](fO[215](Na, 7), fO[87](Na, 25)) local vO = fO[106](fO[106](c8, cE2), 138304552) vO = fO[106](vO, fO[95](fO[215](vO, 13), 4294967295)) vO = fO[106](vO, fO[87](vO, 17)) vO = fO[106](vO, fO[95](fO[215](vO, 5), 4294967295)) vO = vO % 3 local cZ if vO == 1 then cZ = { fO[95](fO[87](FO, 22), 1023), fO[95](fO[87](FO, 11), 2047), fO[95](FO, 2047), fO[95](CQ0, 65535) } elseif vO == 2 then cZ = { fO[95](fO[87](FO, 11), 1023), fO[95](CQ0, 65535), fO[95](fO[87](FO, 21), 2047), fO[95](FO, 2047) } else cZ = { fO[95](CQ0, 65535), fO[95](fO[87](FO, 22), 1023), fO[95](fO[87](FO, 11), 2047), fO[95](FO, 2047) } end local a,b,c,d = cZ[I5[1]], cZ[I5[2]], cZ[I5[3]], cZ[I5[4]] b = fO[95](b + a, 1023) c = fO[95](c + b, 1023) return c8, d, c, b, a end local xx_4 = function(mp, hV9, Na) local CQ0 = fO[95](mp + 3761500090, 4294967295) local FO = fO[95](hV9 + fO[121](fO[215](3761500090, 1), fO[87](3761500090, 31)), 4294967295)    local _lo=CQ0%1024;local _mid=(CQ0//1024)%1024;local _hi=CQ0//1048576 local c8=_lo local hc7 = fO[106](fO[106](c8, Na), 2147875653) hc7 = fO[106](hc7, fO[95](fO[215](hc7, 13), 4294967295)) hc7 = fO[106](hc7, fO[87](hc7, 17)) hc7 = fO[106](hc7, fO[95](fO[215](hc7, 5), 4294967295)) local I5 = Hg9[(hc7 % 24) + 1] local cZ={_mid,_hi,FO%1024,(FO//1024)%1024} local a,b,c,d = cZ[I5[1]], cZ[I5[2]], cZ[I5[3]], cZ[I5[4]] b = fO[106](b, a) c = fO[106](c, b) return c, c8, a, d, b    end end local _ms0=function(_s)return fO[106](_s,1919612517),fO[106](fO[121](fO[215](_s,14),fO[87](_s,18)),1437566630)end local _ts0=function(_s,_l,_h,_o,a,b,c,d)   local _x=fO[95](fO[121](fO[215](_s,14),fO[87](_s,18))+_l+_o*17587+a*17745+b*48343+c*50745+d*33471,4294967295) _x =fO[106](fO[106](_x,_h),2840686982)return fO[121](fO[215](_x,14),fO[87](_x,18))    end end local _ms1=function(_s)return fO[106](_s,3461045215),fO[106](fO[121](fO[215](_s,4),fO[87](_s,28)),3477743689)end local _ts1=function(_s,_l,_h,_o,a,b,c,d)local _x=fO[106](_s,_l) _x =fO[106](_x,fO[121](fO[215](_h,27),fO[87](_h,5)))_x =fO[106](_x,_o*55689)_x =fO[106](_x,a*27075)_x =fO[106](_x,b*50229)_x =fO[106](_x,c*3805)_x =fO[106](_x,d*25195)_x =fO[95](_x*55689+1334142386,4294967295)return fO[106](_x,fO[87](_x,6)) end local _ms2=function(_s) return fO[106](_s,229728453),fO[106](fO[121](fO[215](_s,16),fO[87](_s,16)),1059741899) end local _ts2=function(_s,_l,_h,_o,a,b,c,d) local _x=fO[106](_s,_l) _x =fO[106](_x,fO[121](fO[215](_h,29),fO[87](_h,3)))local _q=fO[106](_o*11687,a*2599) _q =fO[106](_q,fO[106](b*23429,fO[106](c*54901,d*28507)))_x =fO[106](_x,_q)_x =fO[95](_x*11687+3123651450,4294967295)return fO[106](_x,fO[87](_x,12)) end local _ms3=function(_s) return fO[106](_s,751757507),fO[106](fO[121](fO[215](_s,8),fO[87](_s,24)),2699129865) end local _ts3=function(_s,_l,_h,_o,a,b,c,d)    local _x=fO[95](fO[121](fO[215](_s,13),fO[87](_s,19))+_l+_o*45377+a*8581+b*9579+c*13283+d*22187,4294967295) _x =fO[106](fO[106](_x,_h),1678308114)return fO[121](fO[215](_x,8),fO[87](_x,24))    end end local _ms4=function(_s)return fO[106](_s,3273929711),fO[106](fO[121](fO[215](_s,13),fO[87](_s,19)),2441217571)end local _ts4=function(_s,_l,_h,_o,a,b,c,d)local _x=fO[106](_s,_l) _x =fO[106](_x,fO[121](fO[215](_h,16),fO[87](_h,16)))local _q=fO[106](_o*43359,a*6823) _q =fO[106](_q,fO[106](b*5701,fO[106](c*39651,d*97)))_x =fO[106](_x,_q)_x =fO[95](_x*43359+3311971965,4294967295)return fO[106](_x,fO[87](_x,20)) end local _ms5=function(_s) return fO[106](_s,3196789887),fO[106](fO[121](fO[215](_s,20),fO[87](_s,12)),2792819664) end local _ts5=function(_s,_l,_h,_o,a,b,c,d) local _x=fO[95](fO[121](fO[215](_s,10),fO[87](_s,22))+_l,4294967295) _x =fO[95](_x+_o*14983,4294967295)_x =fO[95](_x+a*52821+b*8725,4294967295)_x =fO[95](_x+c*35353+d*26819,4294967295)local _y=fO[106](_x,_h) return fO[121](fO[215](fO[106](_y,1317670241),20),fO[87](fO[106](_y,1317670241),12)) end local _ms6=function(_s) return fO[106](_s,615247068),fO[106](fO[121](fO[215](_s,13),fO[87](_s,19)),872222841) end local _ts6=function(_s,_l,_h,_o,a,b,c,d) local _sum=fO[121](fO[215](_s,29),fO[87](_s,3)) _sum =_sum+_l+_o*13637 _sum =_sum+a*44633+b*53885 _sum =_sum+c*11407+d*24539 local _x=fO[95](_sum,4294967295)_x =fO[106](fO[106](_x,_h),1441872172)return fO[121](fO[215](_x,13),fO[87](_x,19))end local l7=nil local Uy7=nil local Pj0=setmetatable({},{__mode='k'})local Ct=setmetatable({},{__mode='k'}) local Su7=function(_d,_l) return tO(_d,_l,0,1279348293) end local q5;   local QO={} QO[133] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)       if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =b else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =b end end end return nil,Ls end QO[234] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local TO = dl[4][CL(dl[1],b)] local Eq = { n = 0 } local YV0 = l7(TO, Eq, dl[4]) if d == 0 then    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[1]end   end f2[a] =YV0 else for BW=0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _i=a+ BW;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[BW+ 1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[BW+ 1] end    end end end end return nil,Ls end QO[753] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,0,0,0       if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =SE(dl[1],b)else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =SE(dl[1],b)end   end end end local a,b,c,d=_cb,_cc,_ca,0 local _tab=(if Po2[b]~=nil then Po2[b][1]else  o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]);local _key=(if Po2[c]~=nil then Po2[c][1]else  o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)])       if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =_tab[_key]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =_tab[_key]end   end end end end return nil,Ls end q5 =function(JO)if JO<234 then if JO==133 then return QO[133]else uC()end else if JO<753 then if JO==234 then return QO[234]else uC() end else if JO==753 then return QO[753] else uC() end end end end    end local dO;local QO={} QO[186] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    local jG = dl[1][127][c + 1] local _sn = #jG local Gr if _sn == 0 then Gr = { n = 0 } elseif _sn == 1 and not jG[1][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]else  o5[((jG[1][1]+_bo)%_bn)+1][fO[166]((jG[1][1])/_bn)]), n = 1 } elseif _sn == 2 and not jG[1][2] and not jG[2][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]else  o5[((jG[1][1]+_bo)%_bn)+1][fO[166]((jG[1][1])/_bn)]), (if Po2[jG[2][1]]~=nil then Po2[jG[2][1]][1]else  o5[((jG[2][1]+_bo)%_bn)+1][fO[166]((jG[2][1])/_bn)]), n = 2 } elseif _sn == 3 and not jG[1][2] and not jG[2][2] and not jG[3][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]else  o5[((jG[1][1]+_bo)%_bn)+1][fO[166]((jG[1][1])/_bn)]), (if Po2[jG[2][1]]~=nil then Po2[jG[2][1]][1]else  o5[((jG[2][1]+_bo)%_bn)+1][fO[166]((jG[2][1])/_bn)]), (if Po2[jG[3][1]]~=nil then Po2[jG[3][1]][1]else  o5[((jG[3][1]+_bo)%_bn)+1][fO[166]((jG[3][1])/_bn)]), n = 3 } else Gr = {} local _an = 0 for gO=  1, _sn do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do _an = _an + 1 Gr[_an] = La[Um] end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[((jL[1]+_bo)%_bn)+1][fO[166]((jL[1])/_bn)]) end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[((jL[1]+_bo)%_bn)+1][fO[166]((jL[1])/_bn)]) end end Gr.n = _an end local YV0 = l7((if Po2[b]~=nil then Po2[b][1]else  o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]), Gr, dl[4]) if d ~= 0 then for BW=  0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _i=a+ BW;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[BW+ 1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[BW+ 1] end    end end else if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[1]end   end f2[a] =YV0 end  end return nil,Ls end QO[29] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =RO(dl[1],b)else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =RO(dl[1],b)end   end end return nil,Ls end QO[95] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) return { n = 0 }, Ls    end return nil,Ls end QO[46] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =dl[2][b+1][1][1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =dl[2][b+ 1][1][1] end    end end return nil,Ls end dO =function(JO)if(JO*10888709 + 5000022) % 16777213 == 257123 then return QO[186] elseif (5007941 + JO * 10890771) % 16777213 == 2073253 then return QO[29] elseif ((JO + 9) * 10892833 + 7643641) % 16777213 == 16425002 then return QO[95] elseif (JO * 10894895 + 5023779) % 16777213 == 2872559 then return QO[46] else uC() end end    end local lO;local QO={} QO[139] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)       if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]else o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)])[(if Po2[c]~=nil then Po2[c][1]else o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)])] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =(if Po2[b]~=nil then Po2[b][1]else o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)])[(if Po2[c]~=nil then Po2[c][1]else  o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)])] end    end end return nil,Ls end QO[179] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local n1 = dl[1][198][a + 1] local l5 = { n = 0 } for gO=  1, #n1 do local jL = n1[gO] if jL[2] and f2[jL[1]] ~= nil then local La = f2[jL[1]] for Um=  1, La.n do l5.n = l5.n + 1 l5[l5.n] = La[Um] end else l5.n = l5.n + 1 l5[l5.n] = (if Po2[jL[1]]==nil then o5[((jL[1]+_bo)%_bn)+1][fO[166]((jL[1])/_bn)]else  Po2[jL[1]][1]) end end return l5, Ls    end return nil,Ls end QO[195] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local _lhs=(if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else  Po2[b][1]);local _rhs=(if Po2[c]==nil then o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)]else  Po2[c][1])    local _out=_lhs == _rhs       if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =_out else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =_out end end end end end return nil,Ls end lO =function(JO)if(JO*10888693 + 4999989) % 16777213 == 8579146 then return QO[139] elseif (5007908 + JO * 10890755) % 16777213 == 8296345 then return QO[179] elseif ((JO + 9) * 10892817 + 7643752) % 16777213 == 15186304 then return QO[195] else uC() end end    end local GO={[133]=16,[186]=54,[95]=57,[46]=52,[139]=10,[179]=55,[195]=43}local di={}di[74] =function(a,b,c,d,o5,Po2,f2,dl,Ls)     local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =nil else o5[_s] =nil end;f2[_s] =nil end end return nil,Ls end di[15] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]==nil then o5[c]else  Po2[c][1]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]==nil then o5[b]else  Po2[b][1]),n1,(if Po2[c + 1]==nil then o5[c + 1]else  Po2[c + 1][1]))) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end di[195] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]==nil then o5[c]else  Po2[c][1]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]==nil then o5[b]else  Po2[b][1]),n1,(if Po2[c + 1]==nil then o5[c + 1]else  Po2[c + 1][1]),(if Po2[c + 2]==nil then o5[c + 2]else  Po2[c + 2][1]))) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end di[122] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =b else o5[_s] =b end;f2[_s] =nil end end return nil,Ls end di[105] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = dl[1][126](b,dl[6])    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =n1 else o5[_s] =n1 end;f2[_s] =nil end end return nil,Ls end di[229] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]==nil then o5[b]else  Po2[b][1]) local Gr = { (if Po2[c]==nil then o5[c]else  Po2[c][1]), (if Po2[c + 1]==nil then o5[c + 1]else  Po2[c + 1][1]), (if Po2[c + 2]==nil then o5[c + 2]else  Po2[c + 2][1]), n = 3 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end di[198] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]else o5[b])[(if Po2[c]~=nil then Po2[c][1]else  o5[c])] else o5[_s] =(if Po2[b]~=nil then Po2[b][1]else o5[b])[(if Po2[c]~=nil then Po2[c][1]else  o5[c])] end;f2[_s] =nil   end end return nil,Ls end di[6] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local jG = dl[1][127][c + 1] local n1 = (if Po2[jG[1][1]]==nil then o5[jG[1][1]]else  Po2[jG[1][1]][1]) local Gr = { n = 0 } for gO=  2, #jG do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do Gr.n = Gr.n + 1 Gr[Gr.n] = La[Um] end else Gr.n = Gr.n + 1 Gr[Gr.n] = (if Po2[jL[1]]==nil then o5[jL[1]]else  Po2[jL[1]][1]) end else Gr.n = Gr.n + 1 Gr[Gr.n] = (if Po2[jL[1]]==nil then o5[jL[1]]else  Po2[jL[1]][1]) end end local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]==nil then o5[b]else  Po2[b][1]),n1,fO[86](Gr,1,(fO[202](Gr)=='table' and (Gr.n or #Gr) or 0)))) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end di[3] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[b]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[c]), (if Po2[c + 1]~=nil then Po2[c + 1][1]else  o5[c + 1]), n = 2 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end di[77] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1]) % (if Po2[c]==nil then o5[c]else  Po2[c][1]) else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1]) % (if Po2[c]==nil then o5[c]else  Po2[c][1]) end;f2[_s] =nil   end end return nil,Ls end di[181] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1]) * (if Po2[c]==nil then o5[c]else  Po2[c][1]) else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1]) * (if Po2[c]==nil then o5[c]else  Po2[c][1]) end;f2[_s] =nil   end end return nil,Ls end di[170] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local jG = dl[1][127][c + 1] local _sn = #jG local Gr if _sn == 0 then Gr = { n = 0 } elseif _sn == 1 and not jG[1][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]else  o5[jG[1][1]]), n = 1 } elseif _sn == 2 and not jG[1][2] and not jG[2][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]else  o5[jG[1][1]]), (if Po2[jG[2][1]]~=nil then Po2[jG[2][1]][1]else  o5[jG[2][1]]), n = 2 } elseif _sn == 3 and not jG[1][2] and not jG[2][2] and not jG[3][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]else  o5[jG[1][1]]), (if Po2[jG[2][1]]~=nil then Po2[jG[2][1]][1]else  o5[jG[2][1]]), (if Po2[jG[3][1]]~=nil then Po2[jG[3][1]][1]else  o5[jG[3][1]]), n = 3 } else Gr = {} local _an = 0 for gO=  1, _sn do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do _an = _an + 1 Gr[_an] = La[Um] end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[jL[1]]) end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[jL[1]]) end end Gr.n = _an end local YV0 = l7((if Po2[b]~=nil then Po2[b][1]else  o5[b]), Gr, dl[4]) if d ~= 0 then for BW=  0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end else local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 end  end return nil,Ls end di[130] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = dl[1][126](b,dl[6]) local TO = dl[4][n1] local kb5 = dl[1][126](c,dl[6]) local Eq = { n = 1,[ 1] = kb5 } local YV0 = l7(TO, Eq, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end di[243] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local cO = (if Po2[a + 2]~=nil then Po2[a + 2][1]else  o5[a + 2]) local oQ3 = (if Po2[a]~=nil then Po2[a][1]else  o5[a]) + cO local S3 = (if Po2[a + 1]~=nil then Po2[a + 1][1]else  o5[a + 1]) if (cO >= 0 and oQ3 <= S3) or (cO < 0 and oQ3 >= S3) then Po2[a + 3] = nil    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =oQ3 else o5[_s] =oQ3 end;f2[_s] =nil end local _s=a + 3;local _c=Po2[_s];if _c~=nil then _c[1] =oQ3 else o5[_s] =oQ3 end;f2[_s] =nil end Ls =b+1 end    end return nil,Ls end di[51] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _lhs=(if Po2[b]~=nil then Po2[b][1]else  o5[b]);local _rhs=(if Po2[c]~=nil then Po2[c][1]else  o5[c])       local _stored=_lhs >= _rhs;   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end return nil,Ls end di[63] =function(a,b,c,d,o5,Po2,f2,dl,Ls)Ls = a + 1    end return nil,Ls end di[167] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local R8 = g9[67][b + 1] local Kt = {} for gO=  1, #R8[2] do local jL = R8[2][gO] if jL[1] == 0 then local P1 = Po2[jL[2]] if P1 == nil then P1 = { (if Po2[jL[2]]~=nil then Po2[jL[2]][1]else  o5[jL[2]]) } Po2[jL[2]] = P1 end Kt[gO] = P1 else Kt[gO] = dl[2][8627718][jL[2] + 1] end end local GL8=(R8[13]+2)%3 if GL8==1 then for _ci=1,#Kt do Kt[_ci] ={Kt[_ci]}end elseif GL8==2 then Kt ={[8627718]=Kt}end local qJ = { Kt } local nh = { R8, dl[5], dl[4] } local fR = function(...) local _venv = nh[3] or dl[4] local Z3 = Uy7(nh[1], qJ[1], fO[186](...), _venv, nh[2], nh) return fO[86](Z3, 1, (fO[202](Z3)=='table' and (Z3.n or #Z3) or 1)) end Pj0[fR] = nh Ct[fR] = qJ[1]    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =fR else o5[_s] =fR end;f2[_s] =nil end end return nil,Ls end di[37] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[4][SE(dl[1],b)]else o5[_s] =dl[4][SE(dl[1],b)]end;f2[_s] =nil   end end return nil,Ls end di[125] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _tab=(if Po2[a]==nil then o5[a]else  Po2[a][1]); _tab[(if Po2[b]==nil then o5[b]else  Po2[b][1])] = (if Po2[c]==nil then o5[c]else  Po2[c][1])    end end return nil,Ls end di[142] =function(a,b,c,d,o5,Po2,f2,dl,Ls)      local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =SE(dl[1],b)else o5[_s] =SE(dl[1],b)end;f2[_s] =nil   end end end return nil,Ls end di[249] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _lhs=(if Po2[b]==nil then o5[b]else  Po2[b][1]);local _rhs=(if Po2[c]==nil then o5[c]else  Po2[c][1]) local _out=_lhs < _rhs local _stored=_out    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end return nil,Ls end di[82] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]~=nil then Po2[b][1]else  o5[b]),n1)) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end di[226] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] ={}else o5[_s] ={}end;f2[_s] =nil   end end return nil,Ls end di[164] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1]) else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1]) end;f2[_s] =nil   end end return nil,Ls end di[60] =function(a,b,c,d,o5,Po2,f2,dl,Ls)if NO((if Po2[a]~=nil then Po2[a][1]else  o5[a])) then else Ls = b + 1 end    end return nil,Ls end di[221] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end return nil,Ls end di[133] =function(a,b,c,d,o5,Po2,f2,dl,Ls)return { n = 0 }, Ls    end return nil,Ls end di[91] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[a]==nil then o5[a]else Po2[a][1]) + (if Po2[b]==nil then o5[b]else  Po2[b][1]) else o5[_s] =(if Po2[a]==nil then o5[a]else Po2[a][1]) + (if Po2[b]==nil then o5[b]else  Po2[b][1]) end;f2[_s] =nil   end end return nil,Ls end di[153] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = NO((if Po2[a]==nil then o5[a]else  Po2[a][1])) if n1 then Ls = b + 1 end    end return nil,Ls end di[144] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _out=#((if Po2[b]~=nil then Po2[b][1]else  o5[b]))       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_out else o5[_s] =_out end;f2[_s] =nil end end end end return nil,Ls end di[622] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end local a,b,c,d=_cc,_cb,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =CL(dl[1],b)else o5[_s] =CL(dl[1],b)end;f2[_s] =nil   end end end local a,b,c,d=_cd,_ca,_cc,0    local _out=(if Po2[b]~=nil then Po2[b][1]else  o5[b])[(if Po2[c]~=nil then Po2[c][1]else  o5[c])]    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_out else o5[_s] =_out end;f2[_s] =nil end end end end return nil,Ls end di[390] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =RO(dl[1],b)else o5[_s] =RO(dl[1],b)end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,_ca,0    local _stored=(if Po2[b]~=nil then Po2[b][1]else  o5[b])[(if Po2[c]~=nil then Po2[c][1]else  o5[c])];   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end return nil,Ls end di[698] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[1][126](b,dl[6])else o5[_s] =dl[1][126](b,dl[6])end;f2[_s] =nil   end end end return nil,Ls end local Np6={}Np6[98] =function(a,b,c,d,o5,Po2,f2,dl,Ls)    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1])[(if Po2[c]==nil then o5[c]else  Po2[c][1])] else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1])[(if Po2[c]==nil then o5[c]else  Po2[c][1])] end;f2[_s] =nil   end end return nil,Ls end Np6[231] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = dl[4][dl[1][126](b,dl[6])]    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =n1[dl[1][126](c,dl[6])]else o5[_s] =n1[dl[1][126](c,dl[6])]end;f2[_s] =nil   end end return nil,Ls end Np6[84] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[b]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[c]), (if Po2[c + 1]~=nil then Po2[c + 1][1]else  o5[c + 1]), (if Po2[c + 2]~=nil then Po2[c + 2][1]else  o5[c + 2]), n = 3 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end Np6[59] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = NO((if Po2[a]==nil then o5[a]else  Po2[a][1])) if n1 then Ls = b + 1 end    end return nil,Ls end Np6[180] =function(a,b,c,d,o5,Po2,f2,dl,Ls)Ls = a + 1    end return nil,Ls end Np6[214] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]else o5[b]) + (if Po2[c]~=nil then Po2[c][1]else  o5[c]) else o5[_s] =(if Po2[b]~=nil then Po2[b][1]else o5[b]) + (if Po2[c]~=nil then Po2[c][1]else  o5[c]) end;f2[_s] =nil   end end return nil,Ls end Np6[160] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _tab=(if Po2[a]==nil then o5[a]else  Po2[a][1]); _tab[(if Po2[b]==nil then o5[b]else  Po2[b][1])] = (if Po2[c]==nil then o5[c]else  Po2[c][1])    end end return nil,Ls end Np6[33] =function(a,b,c,d,o5,Po2,f2,dl,Ls)if Po2[a]~=nil then Po2[a] =nil end   end return nil,Ls end Np6[194] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[1][126](b,dl[6])else o5[_s] =dl[1][126](b,dl[6])end;f2[_s] =nil   end end return nil,Ls end Np6[104] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _operand=(if Po2[b]~=nil then Po2[b][1]else  o5[b])    local _out=not NO(_operand)    local _stored=_out    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end return nil,Ls end Np6[166] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = NO((if Po2[a]==nil then o5[a]else  Po2[a][1])) if not n1 then Ls = b + 1 end    end return nil,Ls end Np6[183] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]~=nil then Po2[b][1]else  o5[b]),n1)) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end Np6[127] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _stored=(if Po2[b]==nil then o5[b]else  Po2[b][1]) == (if Po2[c]==nil then o5[c]else  Po2[c][1])    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end return nil,Ls end Np6[234] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]==nil then o5[b]else  Po2[b][1])    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =n1 else o5[_s] =n1 end;f2[_s] =nil end end return nil,Ls end Np6[118] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[4][CL(dl[1],b)]else o5[_s] =dl[4][CL(dl[1],b)]end;f2[_s] =nil   end end return nil,Ls end Np6[62] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = dl[1][127][c + 1] local jG = n1 local Gr = { n = 0 } for gO=  1, #jG do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do Gr.n = Gr.n + 1 Gr[Gr.n] = La[Um] end else Gr.n = Gr.n + 1 Gr[Gr.n] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[jL[1]]) end else Gr.n = Gr.n + 1 Gr[Gr.n] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[jL[1]]) end end local YV0 = l7((if Po2[b]~=nil then Po2[b][1]else  o5[b]), Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end Np6[8] =function(a,b,c,d,o5,Po2,f2,dl,Ls)      local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =CL(dl[1],b)else o5[_s] =CL(dl[1],b)end;f2[_s] =nil   end end end return nil,Ls end Np6[242] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[b]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[c]), n = 1 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end Np6[228] =function(a,b,c,d,o5,Po2,f2,dl,Ls)return { n = 0 }, Ls    end return nil,Ls end Np6[107] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _out=(if Po2[b]~=nil then Po2[b][1]else  o5[b]) / (if Po2[c]~=nil then Po2[c][1]else  o5[c])       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_out else o5[_s] =_out end;f2[_s] =nil end end end return nil,Ls end Np6[64] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = dl[1][198][a + 1] local l5 = { n = 0 } for gO=  1, #n1 do local jL = n1[gO] if jL[2] and f2[jL[1]] ~= nil then local La = f2[jL[1]] for Um=  1, La.n do l5.n = l5.n + 1 l5[l5.n] = La[Um] end else l5.n = l5.n + 1 l5[l5.n] = (if Po2[jL[1]]==nil then o5[jL[1]]else  Po2[jL[1]][1]) end end return l5, Ls    end return nil,Ls end Np6[67] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]==nil then o5[b]else  Po2[b][1]) local Gr = { (if Po2[c]==nil then o5[c]else  Po2[c][1]), (if Po2[c + 1]==nil then o5[c + 1]else  Po2[c + 1][1]), n = 2 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end Np6[206] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =nil else o5[_s] =nil end;f2[_s] =nil end end return nil,Ls end Np6[14] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]==nil then o5[c]else  Po2[c][1]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]==nil then o5[b]else  Po2[b][1]),n1,(if Po2[c + 1]==nil then o5[c + 1]else  Po2[c + 1][1]))) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end Np6[378] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end local a,b,c,d=_cc,0,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =SE(dl[1],b)else o5[_s] =SE(dl[1],b)end;f2[_s] =nil   end end local a,b,c,d=_cd,_ca,_cc,0 local _out=(if Po2[b]==nil then o5[b]else  Po2[b][1])[(if Po2[c]==nil then o5[c]else  Po2[c][1])]       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_out else o5[_s] =_out end;f2[_s] =nil end end end end return nil,Ls end Np6[429] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[1][126](b,dl[6])else o5[_s] =dl[1][126](b,dl[6])end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,_ca,0 local _out=(if Po2[b]~=nil then Po2[b][1]else  o5[b])[(if Po2[c]~=nil then Po2[c][1]else  o5[c])]    local _stored=_out;   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end return nil,Ls end Np6[875] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end local a,b,c,d=_cc,_cb,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =RO(dl[1],b)else o5[_s] =RO(dl[1],b)end;f2[_s] =nil   end end end local a,b,c,d=_cd,_ca,_cc,0 local _tab=(if Po2[b]~=nil then Po2[b][1]else  o5[b]);local _key=(if Po2[c]~=nil then Po2[c][1]else  o5[c])    local _out=_tab[_key]    local _stored=_out;   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end end return nil,Ls end Np6[917] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =CL(dl[1],b)else o5[_s] =CL(dl[1],b)end;f2[_s] =nil   end end end local a,b,c,d=_cc,_cd,_ca,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1]) == (if Po2[c]==nil then o5[c]else  Po2[c][1]) else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1]) == (if Po2[c]==nil then o5[c]else  Po2[c][1]) end;f2[_s] =nil   end end end end return nil,Ls end Np6[914] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =SE(dl[1],b)else o5[_s] =SE(dl[1],b)end;f2[_s] =nil   end end local a,b,c,d=_cc,0,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[1][126](b,dl[6])else o5[_s] =dl[1][126](b,dl[6])end;f2[_s] =nil   end end end return nil,Ls end Np6[256] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local n1 = dl[1][126](b,dl[6])    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =n1 else o5[_s] =n1 end;f2[_s] =nil end end end local a,b,c,d=_cc,_cd,_ca,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1]) > (if Po2[c]==nil then o5[c]else  Po2[c][1]) else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1]) > (if Po2[c]==nil then o5[c]else  Po2[c][1]) end;f2[_s] =nil   end end end end return nil,Ls end local ao5={}ao5[44] =function(a,b,c,d,o5,Po2,f2,dl,Ls) return { n = 0 }, Ls    end return nil,Ls end ao5[13] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1]) - (if Po2[c]==nil then o5[c]else  Po2[c][1]) else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1]) - (if Po2[c]==nil then o5[c]else  Po2[c][1]) end;f2[_s] =nil   end end return nil,Ls end ao5[188] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[4][RO(dl[1],b)]else o5[_s] =dl[4][RO(dl[1],b)]end;f2[_s] =nil   end end return nil,Ls end ao5[213] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _out=(if Po2[b]~=nil then Po2[b][1]else  o5[b]) ~= (if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _stored=_out    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end return nil,Ls end ao5[179] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]else o5[b]) + dl[1][126](c,dl[6]) else o5[_s] =(if Po2[b]~=nil then Po2[b][1]else o5[b]) + dl[1][126](c,dl[6]) end;f2[_s] =nil   end end return nil,Ls end ao5[165] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]==nil then o5[b]else  Po2[b][1]) local Gr = { (if Po2[c]==nil then o5[c]else  Po2[c][1]), (if Po2[c + 1]==nil then o5[c + 1]else  Po2[c + 1][1]), (if Po2[c + 2]==nil then o5[c + 2]else  Po2[c + 2][1]), n = 3 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end ao5[222] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local jG=dl[1][198][a+1] local _starts={};local _total=0 for gO=1,#jG do local _ref=jG[gO];_starts[gO] =_total;local _expanded;if _ref[2]then _expanded =f2[_ref[1]]end;if _expanded~=nil then _total =_total+_expanded.n else _total =_total+1 end end local l5={n=_total}for gO=1,#jG do local jL=jG[gO];local _start=_starts[gO];local _expanded;if jL[2]then _expanded =f2[jL[1]]end;if _expanded~=nil then for _ri=1,_expanded.n do l5[_start+_ri] =_expanded[_ri]end else l5[_start+1] =(if Po2[jL[1]]~=nil then Po2[jL[1]][1]else o5[jL[1]]) end end return l5,Ls    end return nil,Ls end ao5[126] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[b]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[c]), n = 1 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end ao5[95] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _tab=(if Po2[a]~=nil then Po2[a][1]else  o5[a]); _tab[(if Po2[b]~=nil then Po2[b][1]else  o5[b])] = (if Po2[c]~=nil then Po2[c][1]else  o5[c])    end end return nil,Ls end ao5[69] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local TO = dl[4][RO(dl[1],b)] local Eq = { n = 0 } local YV0 = l7(TO, Eq, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end ao5[143] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[b])    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =n1 else o5[_s] =n1 end;f2[_s] =nil end end return nil,Ls end ao5[78] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[4][dl[1][126](b,dl[6])][dl[1][126](c,dl[6])]else o5[_s] =dl[4][dl[1][126](b,dl[6])][dl[1][126](c,dl[6])]end;f2[_s] =nil   end end return nil,Ls end ao5[123] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]~=nil then Po2[b][1]else  o5[b]),n1,(if Po2[c + 1]~=nil then Po2[c + 1][1]else  o5[c + 1]))) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end ao5[191] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _operand=(if Po2[b]==nil then o5[b]else  Po2[b][1])    local _stored=-(_operand)    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end return nil,Ls end ao5[89] =function(a,b,c,d,o5,Po2,f2,dl,Ls)Ls = a + 1    end return nil,Ls end ao5[30] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local jG = dl[1][127][c + 1] local n1 = (if Po2[jG[1][1]]==nil then o5[jG[1][1]]else  Po2[jG[1][1]][1]) local Gr = { n = 0 } for gO=  2, #jG do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do Gr.n = Gr.n + 1 Gr[Gr.n] = La[Um] end else Gr.n = Gr.n + 1 Gr[Gr.n] = (if Po2[jL[1]]==nil then o5[jL[1]]else  Po2[jL[1]][1]) end else Gr.n = Gr.n + 1 Gr[Gr.n] = (if Po2[jL[1]]==nil then o5[jL[1]]else  Po2[jL[1]][1]) end end local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]==nil then o5[b]else  Po2[b][1]),n1,fO[86](Gr,1,(fO[202](Gr)=='table' and (Gr.n or #Gr) or 0)))) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end ao5[109] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local oQ3 = (if Po2[a]~=nil then Po2[a][1]else  o5[a]) local S3 = (if Po2[a + 1]~=nil then Po2[a + 1][1]else  o5[a + 1]) local cO = (if Po2[a + 2]~=nil then Po2[a + 2][1]else  o5[a + 2]) if (cO >= 0 and oQ3 > S3) or (cO < 0 and oQ3 < S3) then Ls = b + 1 else    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =oQ3 else o5[_s] =oQ3 end;f2[_s] =nil end local _s=a + 3;local _c=Po2[_s];if _c~=nil then _c[1] =oQ3 else o5[_s] =oQ3 end;f2[_s] =nil end end end return nil,Ls end ao5[140] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]==nil then o5[c]else  Po2[c][1]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]==nil then o5[b]else  Po2[b][1]),n1)) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end ao5[241] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =RO(dl[1],b)else o5[_s] =RO(dl[1],b)end;f2[_s] =nil   end end return nil,Ls end ao5[38] =function(a,b,c,d,o5,Po2,f2,dl,Ls)      local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[4][dl[1][126](b,dl[6])]else o5[_s] =dl[4][dl[1][126](b,dl[6])]end;f2[_s] =nil   end end end return nil,Ls end ao5[47] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = NO((if Po2[a]==nil then o5[a]else  Po2[a][1])) if not n1 then Ls = b + 1 end    end return nil,Ls end ao5[117] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _out=(if Po2[b]~=nil then Po2[b][1]else  o5[b]) > (if Po2[c]~=nil then Po2[c][1]else  o5[c])       local _stored=_out;   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end end return nil,Ls end ao5[61] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]else o5[b]) + c else o5[_s] =(if Po2[b]~=nil then Po2[b][1]else o5[b]) + c end;f2[_s] =nil   end end return nil,Ls end ao5[202] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1])[(if Po2[c]==nil then o5[c]else  Po2[c][1])] else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1])[(if Po2[c]==nil then o5[c]else  Po2[c][1])] end;f2[_s] =nil   end end return nil,Ls end ao5[182] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =nil else o5[_s] =nil end;f2[_s] =nil end end return nil,Ls end ao5[171] =function(a,b,c,d,o5,Po2,f2,dl,Ls)if not NO((if Po2[a]==nil then o5[a]else  Po2[a][1])) then else Ls = b + 1 end    end return nil,Ls end ao5[176] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] ={}else o5[_s] ={}end;f2[_s] =nil   end end return nil,Ls end ao5[555] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =CL(dl[1],b)else o5[_s] =CL(dl[1],b)end;f2[_s] =nil   end end end local a,b,c,d=_cc,_cd,_ca,0 local _tab=(if Po2[b]~=nil then Po2[b][1]else  o5[b]);local _key=(if Po2[c]~=nil then Po2[c][1]else  o5[c])    local _out=_tab[_key]    local _stored=_out;   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end end return nil,Ls end ao5[476] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =SE(dl[1],b)else o5[_s] =SE(dl[1],b)end;f2[_s] =nil   end end end local a,b,c,d=_cc,_cd,_ca,0    local _stored=(if Po2[b]==nil then o5[b]else  Po2[b][1])[(if Po2[c]==nil then o5[c]else  Po2[c][1])]    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end return nil,Ls end ao5[696] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[1][126](b,dl[6])else o5[_s] =dl[1][126](b,dl[6])end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,_ca,0 local _lhs=(if Po2[b]==nil then o5[b]else  Po2[b][1]);local _rhs=(if Po2[c]==nil then o5[c]else  Po2[c][1]) local _stored=_lhs == _rhs    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end return nil,Ls end ao5[32] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =CL(dl[1],b)else o5[_s] =CL(dl[1],b)end;f2[_s] =nil   end end end return nil,Ls end ao5[992] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =SE(dl[1],b)else o5[_s] =SE(dl[1],b)end;f2[_s] =nil   end end end end return nil,Ls end local BD9={[74]=17,[122]=16,[105]=30,[229]=29,[198]=10,[3]=28,[77]=18,[181]=3,[170]=54,[243]=7,[51]=48,[63]=13,[167]=49,[125]=11,[249]=45,[226]=9,[164]=5,[60]=15,[221]=52,[133]=57,[91]=4,[153]=14,[144]=19,[98]=10,[231]=32,[84]=29,[59]=14,[180]=13,[214]=1,[160]=11,[33]=51,[194]=30,[104]=42,[166]=15,[127]=43,[234]=5,[62]=54,[242]=27,[228]=57,[107]=38,[64]=55,[67]=28,[206]=17,[44]=57,[13]=2,[213]=44,[179]=33,[165]=29,[222]=55,[126]=27,[95]=11,[143]=5,[78]=32,[191]=41,[89]=13,[109]=8,[38]=31,[47]=15,[117]=47,[61]=35,[202]=10,[182]=17,[171]=14,[176]=9}local FU; local M0={} M0[239] =function(a,b,c,d,o5,Po2,f2,dl,Ls)      local _tab=(if Po2[a]~=nil then Po2[a][1]elseif  o5[a]~=nil then o5[a][1]else  nil); _tab[(if Po2[b]~=nil then Po2[b][1]elseif  o5[b]~=nil then o5[b][1]else  nil)] = (if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil)    end end return nil,Ls end M0[149] =function(a,b,c,d,o5,Po2,f2,dl,Ls)if NO((if Po2[a]~=nil then Po2[a][1]elseif  o5[a]~=nil then o5[a][1]else  nil)) then else Ls = b + 1 end    end return nil,Ls end M0[64] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; if Po2[_s] then Po2[_s][1] =dl[2][b+ 1][1] elseif o5[_s] then o5[_s][1] =dl[2][b+ 1][1] else o5[_s] ={dl[2][b+ 1][1]} end    end end return nil,Ls end M0[196] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local TO = dl[4][RO(dl[1],b)] local Eq = { n = 0 } local YV0 = l7(TO, Eq, dl[4]) if d == 0 then    if f2[a]~=nil then f2[a] =nil end;local _s=a; if Po2[_s] then Po2[_s][1] =YV0[1]elseif o5[_s] then o5[_s][1] =YV0[1]else o5[_s] ={YV0[1]}end    end f2[a] =YV0 else for BW=0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _s=a + BW; if Po2[_s] then Po2[_s][1] =YV0[BW+ 1] elseif o5[_s] then o5[_s][1] =YV0[BW+ 1] else o5[_s] ={YV0[BW+ 1]} end    end end end end return nil,Ls end M0[221] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =dl[4][RO(dl[1],b)]else local _b=o5[_s]; if _b~=nil then _b[1] =dl[4][RO(dl[1],b)]else o5[_s] ={dl[4][RO(dl[1],b)]}end end    end end return nil,Ls end M0[5] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]elseif  o5[b]~=nil then o5[b][1]else  nil)    if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =n1 else local _b=o5[_s];if _b~=nil then _b[1] =n1 else o5[_s] ={n1}end end   end end return nil,Ls end M0[131] =function(a,b,c,d,o5,Po2,f2,dl,Ls)      if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =RO(dl[1],b)else local _b=o5[_s]; if _b~=nil then _b[1] =RO(dl[1],b)else o5[_s] ={RO(dl[1],b)}end end    end end end return nil,Ls end M0[67] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]~=nil then Po2[b][1]elseif  o5[b]~=nil then o5[b][1]else  nil),n1,(if Po2[c + 1]~=nil then Po2[c + 1][1]elseif  o5[c + 1]~=nil then o5[c + 1][1]else  nil))) end) if not _ok then fO[218](YV0,0) end if d == 0 then    if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =YV0[1]else local _b=o5[_s]; if _b~=nil then _b[1] =YV0[1]else o5[_s] ={YV0[1]}end end    end f2[a] =YV0 else for BW=0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _s=a + BW; local _c=Po2[_s]; if _c~=nil then _c[1] =YV0[BW+ 1] else local _b=o5[_s]; if _b~=nil then _b[1] =YV0[BW+ 1] else o5[_s] ={YV0[BW+ 1]} end end    end end end end return nil,Ls end M0[30] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; if Po2[_s] then Po2[_s][1] =(if Po2[b]~=nil then Po2[b][1]elseif o5[b]~=nil then o5[b][1]else  nil) - (if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil) elseif o5[_s] then o5[_s][1] =(if Po2[b]~=nil then Po2[b][1]elseif o5[b]~=nil then o5[b][1]else  nil) - (if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil) else o5[_s] ={(if Po2[b]~=nil then Po2[b][1]elseif o5[b]~=nil then o5[b][1]else  nil) - (if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil)} end    end end return nil,Ls end M0[9] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local jG=dl[1][198][a+1] local _starts={};local _total=0 for gO=1,#jG do local _ref=jG[gO];_starts[gO] =_total;local _expanded;if _ref[2]then _expanded =f2[_ref[1]]end;if _expanded~=nil then _total =_total+_expanded.n else _total =_total+1 end end local l5={n=_total}for gO=1,#jG do local jL=jG[gO];local _start=_starts[gO];local _expanded;if jL[2]then _expanded =f2[jL[1]]end;if _expanded~=nil then for _ri=1,_expanded.n do l5[_start+_ri] =_expanded[_ri]end else l5[_start+1] =(if Po2[jL[1]]~=nil then Po2[jL[1]][1]elseif o5[jL[1]]~=nil then o5[jL[1]][1]else  nil) end end return l5,Ls    end return nil,Ls end M0[17] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local n1 = dl[1][126](b,dl[6])    if f2[a]~=nil then f2[a] =nil end;local _s=a; if Po2[_s] then Po2[_s][1] =n1 elseif o5[_s]then o5[_s][1] =n1 else o5[_s] ={n1}end   end end end return nil,Ls end FU =function(ZL)if(ZL*10887443 + 4997489) % 16777213 == 6628351 then return M0[239] elseif (5005408 + ZL * 10889505) % 16777213 == 151992 then return M0[149] elseif ((ZL + 9) * 10891567 + 7652502) % 16777213 == 14207882 then return M0[64] elseif (ZL * 10893629 + 5021246) % 16777213 == 9466479 then return M0[196] elseif (5029165 + ZL * 10895691) % 16777213 == 13835417 then return M0[221] elseif ((ZL + 12) * 10897753 + 8481752) % 16777213 == 9194210 then return M0[5] elseif (ZL * 10899815 + 5045003) % 16777213 == 6857663 then return M0[131] elseif (5052922 + ZL * 10901877) % 16777213 == 14058522 then return M0[67] elseif ((ZL + 15) * 10903939 + 9273886) % 16777213 == 13411964 then return M0[30] elseif (ZL * 10906001 + 5068760) % 16777213 == 2559491 then return M0[9] elseif (5076679 + ZL * 10908063) % 16777213 == 5964407 then return M0[17] else uC() end end    end local wy;local M0={} M0[173] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   Ls = a + 1    end return nil,Ls end M0[213] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =dl[1][126](b,dl[6])else local _b=o5[_s]; if _b~=nil then _b[1] =dl[1][126](b,dl[6])else o5[_s] ={dl[1][126](b,dl[6])}end end    end end return nil,Ls end M0[178] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; if Po2[_s] then Po2[_s][1] =SE(dl[1],b)elseif o5[_s] then o5[_s][1] =SE(dl[1],b)else o5[_s] ={SE(dl[1],b)}end    end end return nil,Ls end M0[102] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]elseif  o5[b]~=nil then o5[b][1]else  nil)    if f2[a]~=nil then f2[a] =nil end;local _s=a; if Po2[_s] then Po2[_s][1] =n1 elseif o5[_s]then o5[_s][1] =n1 else o5[_s] ={n1}end   end end return nil,Ls end M0[151] =function(a,b,c,d,o5,Po2,f2,dl,Ls)return { n = 0 }, Ls    end return nil,Ls end M0[56] =function(a,b,c,d,o5,Po2,f2,dl,Ls)if not NO((if Po2[a]~=nil then Po2[a][1]elseif  o5[a]~=nil then o5[a][1]else  nil)) then Ls = b + 1 end    end return nil,Ls end wy =function(ZL)if ZL<173 then if ZL<102 then if ZL==56 then return M0[56]else uC()end else if ZL<151 then if ZL==102 then return M0[102]else uC() end else if ZL==151 then return M0[151] else uC() end end end else if ZL<178 then if ZL==173 then return M0[173] else uC() end else if ZL<213 then if ZL==178 then return M0[178] else uC() end else if ZL==213 then return M0[213] else uC() end end end end end    end local vy4={}vy4[21] =function(a,b,c,d,o5,Po2,f2,dl,Ls) local n1 = dl[1][198][a + 1] local l5 = { n = 0 } for gO=  1, #n1 do local jL = n1[gO] if jL[2] and f2[jL[1]] ~= nil then local La = f2[jL[1]] for Um=  1, La.n do l5.n = l5.n + 1 l5[l5.n] = La[Um] end else l5.n = l5.n + 1 l5[l5.n] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]elseif  o5[jL[1]]~=nil then o5[jL[1]][1]else  nil) end end return l5, Ls    end return nil,Ls end vy4[13] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _out=(if Po2[b]~=nil then Po2[b][1]elseif  o5[b]~=nil then o5[b][1]else  nil) == (if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil)    local _stored=_out;   if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =_stored else local _b=o5[_s];if _b~=nil then _b[1] =_stored else o5[_s] ={_stored}end end   end end end return nil,Ls end vy4[65] =function(a,b,c,d,o5,Po2,f2,dl,Ls)Ls = a + 1    end return nil,Ls end vy4[190] =function(a,b,c,d,o5,Po2,f2,dl,Ls)if NO((if Po2[a]~=nil then Po2[a][1]elseif  o5[a]~=nil then o5[a][1]else  nil)) then else Ls = b + 1 end    end return nil,Ls end vy4[90] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _stored=(if Po2[b]~=nil then Po2[b][1]elseif  o5[b]~=nil then o5[b][1]else  nil) <= (if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil);   if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =_stored else local _b=o5[_s];if _b~=nil then _b[1] =_stored else o5[_s] ={_stored}end end   end end end return nil,Ls end vy4[108] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]elseif o5[b]~=nil then o5[b][1]else  nil) else local _b=o5[_s]; if _b~=nil then _b[1] =(if Po2[b]~=nil then Po2[b][1]elseif o5[b]~=nil then o5[b][1]else  nil) else o5[_s] ={(if Po2[b]~=nil then Po2[b][1]elseif o5[b]~=nil then o5[b][1]else  nil)} end end    end end return nil,Ls end vy4[234] =function(a,b,c,d,o5,Po2,f2,dl,Ls)return { n = 0 }, Ls    end return nil,Ls end vy4[183] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =CL(dl[1],b)else local _b=o5[_s]; if _b~=nil then _b[1] =CL(dl[1],b)else o5[_s] ={CL(dl[1],b)}end end    end end return nil,Ls end local D9={[239]=11,[149]=15,[64]=52,[5]=5,[30]=2,[9]=55,[17]=30,[173]=13,[213]=30,[102]=5,[151]=57,[56]=15,[21]=55,[13]=43,[65]=13,[190]=15,[90]=46,[108]=5,[234]=57}local UO; local L0={} L0[137] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)       local n1 = dl[1][126](b,dl[6])    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =n1 else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =n1 end end end end return nil,Ls end L0[144] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]else o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)])else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =(if Po2[b]~=nil then Po2[b][1]else o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]) end    end end return nil,Ls end L0[26] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]else o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)])[(if Po2[c]~=nil then Po2[c][1]else o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)])] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =(if Po2[b]~=nil then Po2[b][1]else o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)])[(if Po2[c]~=nil then Po2[c][1]else  o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)])] end    end end return nil,Ls end L0[233] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) return { n = 0 }, Ls    end return nil,Ls end UO =function(UG)if(UG*10887871 + 4998346) % 16777213 == 3464716 then return L0[137] elseif (5006265 + UG * 10889933) % 16777213 == 12875808 then return L0[144] elseif ((UG + 9) * 10891995 + 7649507) % 16777213 == 2993433 then return L0[26] elseif (UG * 10894057 + 5022103) % 16777213 == 9978221 then return L0[233] else uC() end end    end local oa5={}oa5[94] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)  local n1 = (if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else  Po2[b][1]) local Gr = { (if Po2[c]==nil then o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)]else  Po2[c][1]), n = 1 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[1]end   end f2[a] =YV0 else for BW=0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _i=a+ BW;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[BW+ 1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[BW+ 1] end    end end end end return nil,Ls end oa5[176] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else Po2[b][1]).. (if Po2[c]==nil then o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)]else  Po2[c][1]) else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =(if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else Po2[b][1]) .. (if Po2[c]==nil then o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)]else  Po2[c][1]) end    end end return nil,Ls end local AL={}AL[10] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)  local n1 = (if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else  Po2[b][1])    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =n1 else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =n1 end end end return nil,Ls end AL[29] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local n1 = dl[1][126](b,dl[6])    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =dl[4][n1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =dl[4][n1]end   end end return nil,Ls end local xO={[137]=30,[144]=5,[26]=10,[233]=57,[94]=27,[176]=12,[10]=5,[29]=31}local fe={}fe[108] =function(a,b,c,d,o5,Po2,f2,dl,Ls)  local oQ3 = (if Po2[a]==nil then o5[a]else  Po2[a][1]) local S3 = (if Po2[a + 1]==nil then o5[a + 1]else  Po2[a + 1][1]) local cO = (if Po2[a + 2]==nil then o5[a + 2]else  Po2[a + 2][1]) if (cO >= 0 and oQ3 > S3) or (cO < 0 and oQ3 < S3) then Ls = b + 1 else    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =oQ3 else o5[_s] =oQ3 end;f2[_s] =nil end local _s=a + 3;local _c=Po2[_s];if _c~=nil then _c[1] =oQ3 else o5[_s] =oQ3 end;f2[_s] =nil end end end return nil,Ls end fe[27] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local jG = dl[1][198][a + 1] local _sn = #jG if _sn == 1 and not jG[1][2] then return { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]else  o5[jG[1][1]]), n = 1 }, Ls elseif _sn == 0 then return { n = 0 }, Ls end local l5 = {} local _on = 0 for gO=  1, _sn do local jL = jG[gO] if jL[2] and f2[jL[1]] ~= nil then local La = f2[jL[1]] for Um=  1, La.n do _on = _on + 1 l5[_on] = La[Um] end else _on = _on + 1 l5[_on] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[jL[1]]) end end l5.n = _on return l5, Ls    end return nil,Ls end fe[92] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = dl[1][127][c + 1] local jG = n1 local Gr = { n = 0 } for gO=  1, #jG do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do Gr.n = Gr.n + 1 Gr[Gr.n] = La[Um] end else Gr.n = Gr.n + 1 Gr[Gr.n] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[jL[1]]) end else Gr.n = Gr.n + 1 Gr[Gr.n] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[jL[1]]) end end local YV0 = l7((if Po2[b]~=nil then Po2[b][1]else  o5[b]), Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end fe[40] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]==nil then o5[b]else  Po2[b][1]) local Gr = { n = 0 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end fe[130] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[4][dl[1][126](b,dl[6])][dl[1][126](c,dl[6])]else o5[_s] =dl[4][dl[1][126](b,dl[6])][dl[1][126](c,dl[6])]end;f2[_s] =nil   end end return nil,Ls end fe[136] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end return nil,Ls end fe[242] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]else o5[b])[(if Po2[c]~=nil then Po2[c][1]else  o5[c])] else o5[_s] =(if Po2[b]~=nil then Po2[b][1]else o5[b])[(if Po2[c]~=nil then Po2[c][1]else  o5[c])] end;f2[_s] =nil   end end return nil,Ls end fe[95] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = NO((if Po2[a]==nil then o5[a]else  Po2[a][1])) if not n1 then Ls = b + 1 end    end return nil,Ls end fe[54] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1]) % (if Po2[c]==nil then o5[c]else  Po2[c][1]) else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1]) % (if Po2[c]==nil then o5[c]else  Po2[c][1]) end;f2[_s] =nil   end end return nil,Ls end fe[225] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _tab=(if Po2[a]~=nil then Po2[a][1]else  o5[a]); _tab[(if Po2[b]~=nil then Po2[b][1]else  o5[b])] = (if Po2[c]~=nil then Po2[c][1]else  o5[c])    end end return nil,Ls end fe[80] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local n1 = dl[1][126](b,dl[6])    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =n1 else o5[_s] =n1 end;f2[_s] =nil end end end return nil,Ls end fe[24] =function(a,b,c,d,o5,Po2,f2,dl,Ls)Ls = a + 1    end return nil,Ls end fe[209] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]~=nil then Po2[b][1]else  o5[b]),n1,(if Po2[c + 1]~=nil then Po2[c + 1][1]else  o5[c + 1]))) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end fe[163] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =CL(dl[1],b)else o5[_s] =CL(dl[1],b)end;f2[_s] =nil   end end return nil,Ls end fe[111] =function(a,b,c,d,o5,Po2,f2,dl,Ls)if not NO((if Po2[a]~=nil then Po2[a][1]else  o5[a])) then else Ls = b + 1 end    end return nil,Ls end fe[212] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]==nil then o5[b]else  Po2[b][1]) local Gr = { (if Po2[c]==nil then o5[c]else  Po2[c][1]), (if Po2[c + 1]==nil then o5[c + 1]else  Po2[c + 1][1]), n = 2 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end fe[69] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]==nil then o5[b]else  Po2[b][1])    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =n1 else o5[_s] =n1 end;f2[_s] =nil end end return nil,Ls end fe[72] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] ={}else o5[_s] ={}end;f2[_s] =nil   end end return nil,Ls end fe[43] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[4][CL(dl[1],b)]else o5[_s] =dl[4][CL(dl[1],b)]end;f2[_s] =nil   end end return nil,Ls end fe[122] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _operand=(if Po2[b]==nil then o5[b]else  Po2[b][1])       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =#(_operand)else o5[_s] =#(_operand)end;f2[_s] =nil   end end end return nil,Ls end fe[234] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =nil else o5[_s] =nil end;f2[_s] =nil end end return nil,Ls end fe[89] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]else o5[b]) * (if Po2[c]~=nil then Po2[c][1]else  o5[c]) else o5[_s] =(if Po2[b]~=nil then Po2[b][1]else o5[b]) * (if Po2[c]~=nil then Po2[c][1]else  o5[c]) end;f2[_s] =nil   end end return nil,Ls end fe[374] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end local a,b,c,d=_cc,0,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =SE(dl[1],b)else o5[_s] =SE(dl[1],b)end;f2[_s] =nil   end end local a,b,c,d=_cd,_ca,_cc,0 local _tab=(if Po2[b]~=nil then Po2[b][1]else  o5[b]);local _key=(if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _out=_tab[_key]    local _stored=_out    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end return nil,Ls end fe[459] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[1][126](b,dl[6])else o5[_s] =dl[1][126](b,dl[6])end;f2[_s] =nil   end end end local a,b,c,d=_cc,_cd,_ca,0 local _tab=(if Po2[b]~=nil then Po2[b][1]else  o5[b]);local _key=(if Po2[c]~=nil then Po2[c][1]else  o5[c])    local _out=_tab[_key]       local _stored=_out;   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end end end return nil,Ls end local YK={}YK[193] =function(a,b,c,d,o5,Po2,f2,dl,Ls)    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =b else o5[_s] =b end;f2[_s] =nil end end return nil,Ls end YK[58] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = dl[1][198][a + 1] local l5 = { n = 0 } for gO=  1, #n1 do local jL = n1[gO] if jL[2] and f2[jL[1]] ~= nil then local La = f2[jL[1]] for Um=  1, La.n do l5.n = l5.n + 1 l5[l5.n] = La[Um] end else l5.n = l5.n + 1 l5[l5.n] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[jL[1]]) end end return l5, Ls    end return nil,Ls end YK[2] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[1][126](b,dl[6])else o5[_s] =dl[1][126](b,dl[6])end;f2[_s] =nil   end end return nil,Ls end YK[103] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =RO(dl[1],b)else o5[_s] =RO(dl[1],b)end;f2[_s] =nil   end end return nil,Ls end YK[106] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]else o5[b]) + (if Po2[c]~=nil then Po2[c][1]else  o5[c]) else o5[_s] =(if Po2[b]~=nil then Po2[b][1]else o5[b]) + (if Po2[c]~=nil then Po2[c][1]else  o5[c]) end;f2[_s] =nil   end end return nil,Ls end YK[100] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[4][dl[1][126](b,dl[6])][dl[1][126](c,dl[6])]else o5[_s] =dl[4][dl[1][126](b,dl[6])][dl[1][126](c,dl[6])]end;f2[_s] =nil   end end return nil,Ls end YK[137] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   Po2[a] =nil   end end return nil,Ls end YK[187] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local cO = (if Po2[a + 2]~=nil then Po2[a + 2][1]else  o5[a + 2]) local oQ3 = (if Po2[a]~=nil then Po2[a][1]else  o5[a]) + cO local S3 = (if Po2[a + 1]~=nil then Po2[a + 1][1]else  o5[a + 1]) if (cO >= 0 and oQ3 <= S3) or (cO < 0 and oQ3 >= S3) then Po2[a + 3] = nil    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =oQ3 else o5[_s] =oQ3 end;f2[_s] =nil end local _s=a + 3;local _c=Po2[_s];if _c~=nil then _c[1] =oQ3 else o5[_s] =oQ3 end;f2[_s] =nil end Ls =b+1 end    end return nil,Ls end YK[232] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _lhs=(if Po2[b]~=nil then Po2[b][1]else  o5[b]);local _rhs=(if Po2[c]~=nil then Po2[c][1]else  o5[c])    local _out=_lhs == _rhs    local _stored=_out    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end return nil,Ls end YK[184] =function(a,b,c,d,o5,Po2,f2,dl,Ls)return { n = 0 }, Ls    end return nil,Ls end YK[87] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[b]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[c]), n = 1 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end YK[126] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local TO = dl[4][RO(dl[1],b)] local Eq = { n = 0 } local YV0 = l7(TO, Eq, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end YK[154] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local R8 = g9[67][b + 1] local Kt = {} for gO=  1, #R8[2] do local jL = R8[2][gO] if jL[1] == 0 then local P1 = Po2[jL[2]] if P1 == nil then P1 = { (if Po2[jL[2]]~=nil then Po2[jL[2]][1]else  o5[jL[2]]) } Po2[jL[2]] = P1 end Kt[gO] = P1 else Kt[gO] = dl[2][8627718][jL[2] + 1] end end local GL8=(R8[13]+2)%3 if GL8==1 then for _ci=1,#Kt do Kt[_ci] ={Kt[_ci]}end elseif GL8==2 then Kt ={[8627718]=Kt}end local qJ = { Kt } local nh = { R8, dl[5], dl[4] } local fR = function(...) local _venv = nh[3] or dl[4] local Z3 = Uy7(nh[1], qJ[1], fO[186](...), _venv, nh[2], nh) return fO[86](Z3, 1, (fO[202](Z3)=='table' and (Z3.n or #Z3) or 1)) end Pj0[fR] = nh Ct[fR] = qJ[1]    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =fR else o5[_s] =fR end;f2[_s] =nil end end return nil,Ls end YK[79] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[b]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[c]), (if Po2[c + 1]~=nil then Po2[c + 1][1]else  o5[c + 1]), n = 2 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end YK[67] =function(a,b,c,d,o5,Po2,f2,dl,Ls)dl[2][8627718][b + 1][1] = (if Po2[a]==nil then o5[a]else  Po2[a][1])    end return nil,Ls end YK[73] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _tab=(if Po2[a]==nil then o5[a]else  Po2[a][1]); _tab[(if Po2[b]==nil then o5[b]else  Po2[b][1])] = (if Po2[c]==nil then o5[c]else  Po2[c][1])    end end return nil,Ls end YK[157] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[b]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[c]), (if Po2[c + 1]~=nil then Po2[c + 1][1]else  o5[c + 1]), (if Po2[c + 2]~=nil then Po2[c + 2][1]else  o5[c + 2]), n = 3 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end YK[31] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1]) else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1]) end;f2[_s] =nil   end end return nil,Ls end YK[202] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = NO((if Po2[a]==nil then o5[a]else  Po2[a][1])) if not n1 then Ls = b + 1 end    end return nil,Ls end YK[19] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]~=nil then Po2[b][1]else  o5[b]),n1,(if Po2[c + 1]~=nil then Po2[c + 1][1]else  o5[c + 1]))) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end YK[49] =function(a,b,c,d,o5,Po2,f2,dl,Ls)Ls = a + 1    end return nil,Ls end YK[5] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]~=nil then Po2[b][1]else  o5[b]),n1)) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end YK[41] =function(a,b,c,d,o5,Po2,f2,dl,Ls)if not NO((if Po2[a]~=nil then Po2[a][1]else  o5[a])) then else Ls = b + 1 end    end return nil,Ls end YK[14] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[4][RO(dl[1],b)]else o5[_s] =dl[4][RO(dl[1],b)]end;f2[_s] =nil   end end return nil,Ls end YK[22] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local jG = dl[1][127][c + 1] local _sn = #jG local Gr if _sn == 0 then Gr = { n = 0 } elseif _sn == 1 and not jG[1][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]else  o5[jG[1][1]]), n = 1 } elseif _sn == 2 and not jG[1][2] and not jG[2][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]else  o5[jG[1][1]]), (if Po2[jG[2][1]]~=nil then Po2[jG[2][1]][1]else  o5[jG[2][1]]), n = 2 } elseif _sn == 3 and not jG[1][2] and not jG[2][2] and not jG[3][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]else  o5[jG[1][1]]), (if Po2[jG[2][1]]~=nil then Po2[jG[2][1]][1]else  o5[jG[2][1]]), (if Po2[jG[3][1]]~=nil then Po2[jG[3][1]][1]else  o5[jG[3][1]]), n = 3 } else Gr = {} local _an = 0 for gO=  1, _sn do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do _an = _an + 1 Gr[_an] = La[Um] end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[jL[1]]) end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[jL[1]]) end end Gr.n = _an end local YV0 = l7((if Po2[b]~=nil then Po2[b][1]else  o5[b]), Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end YK[128] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] ={}else o5[_s] ={}end;f2[_s] =nil   end end return nil,Ls end YK[680] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =RO(dl[1],b)else o5[_s] =RO(dl[1],b)end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,_ca,0 local _tab=(if Po2[b]~=nil then Po2[b][1]else  o5[b]);local _key=(if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _out=_tab[_key]       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_out else o5[_s] =_out end;f2[_s] =nil end end end end return nil,Ls end YK[439] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =SE(dl[1],b)else o5[_s] =SE(dl[1],b)end;f2[_s] =nil   end end end local a,b,c,d=_cc,_cd,_ca,0 local _tab=(if Po2[b]==nil then o5[b]else  Po2[b][1]);local _key=(if Po2[c]==nil then o5[c]else  Po2[c][1])    local _out=_tab[_key]    local _stored=_out    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end end return nil,Ls end YK[748] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =CL(dl[1],b)else o5[_s] =CL(dl[1],b)end;f2[_s] =nil   end end end local a,b,c,d=_cc,_cd,_ca,0    local _out=(if Po2[b]~=nil then Po2[b][1]else  o5[b]) == (if Po2[c]~=nil then Po2[c][1]else  o5[c])       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_out else o5[_s] =_out end;f2[_s] =nil end end end end end return nil,Ls end YK[961] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,0,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =SE(dl[1],b)else o5[_s] =SE(dl[1],b)end;f2[_s] =nil   end end local a,b,c,d=_cb,_cc,_ca,0 local _out=(if Po2[b]~=nil then Po2[b][1]else  o5[b])[(if Po2[c]~=nil then Po2[c][1]else  o5[c])]    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_out else o5[_s] =_out end;f2[_s] =nil end end end return nil,Ls end YK[243] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =CL(dl[1],b)else o5[_s] =CL(dl[1],b)end;f2[_s] =nil   end end end end return nil,Ls end YK[477] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[1][126](b,dl[6])else o5[_s] =dl[1][126](b,dl[6])end;f2[_s] =nil   end end end end return nil,Ls end local N8={}N8[9] =function(a,b,c,d,o5,Po2,f2,dl,Ls) local n1 = dl[4][dl[1][126](b,dl[6])]    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =n1[dl[1][126](c,dl[6])]else o5[_s] =n1[dl[1][126](c,dl[6])]end;f2[_s] =nil   end end return nil,Ls end N8[224] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[b]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[c]), (if Po2[c + 1]~=nil then Po2[c + 1][1]else  o5[c + 1]), (if Po2[c + 2]~=nil then Po2[c + 2][1]else  o5[c + 2]), n = 3 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end N8[42] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[4][SE(dl[1],b)]else o5[_s] =dl[4][SE(dl[1],b)]end;f2[_s] =nil   end end return nil,Ls end N8[155] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]~=nil then Po2[b][1]else  o5[b]),n1)) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end N8[68] =function(a,b,c,d,o5,Po2,f2,dl,Ls)Ls = a + 1    end return nil,Ls end N8[26] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[b]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[c]), n = 1 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end N8[15] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] ={}else o5[_s] ={}end;f2[_s] =nil   end end return nil,Ls end N8[141] =function(a,b,c,d,o5,Po2,f2,dl,Ls)if not NO((if Po2[a]~=nil then Po2[a][1]else  o5[a])) then Ls = b + 1 end    end return nil,Ls end N8[88] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local jG=dl[1][198][a+1] local _starts={};local _total=0 for gO=1,#jG do local _ref=jG[gO];_starts[gO] =_total;local _expanded;if _ref[2]then _expanded =f2[_ref[1]]end;if _expanded~=nil then _total =_total+_expanded.n else _total =_total+1 end end local l5={n=_total}for gO=1,#jG do local jL=jG[gO];local _start=_starts[gO];local _expanded;if jL[2]then _expanded =f2[jL[1]]end;if _expanded~=nil then for _ri=1,_expanded.n do l5[_start+_ri] =_expanded[_ri]end else l5[_start+1] =(if Po2[jL[1]]==nil then o5[jL[1]]else Po2[jL[1]][1]) end end return l5,Ls    end return nil,Ls end N8[165] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _lhs=(if Po2[b]~=nil then Po2[b][1]else  o5[b]);local _rhs=(if Po2[c]~=nil then Po2[c][1]else  o5[c])    local _out=_lhs ~= _rhs    local _stored=_out    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end return nil,Ls end N8[241] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   Po2[a] =nil   end end return nil,Ls end N8[71] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]==nil then o5[b]else  Po2[b][1])    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =n1 else o5[_s] =n1 end;f2[_s] =nil end end return nil,Ls end N8[162] =function(a,b,c,d,o5,Po2,f2,dl,Ls)return { n = 0 }, Ls    end return nil,Ls end N8[223] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[c]==nil then o5[c]else  Po2[c][1]) local _ok,YV0=fO[143](function() return fO[186](fO[113]((if Po2[b]==nil then o5[b]else  Po2[b][1]),n1,(if Po2[c + 1]==nil then o5[c + 1]else  Po2[c + 1][1]))) end) if not _ok then fO[218](YV0,0) end if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end N8[214] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[b]else Po2[b][1])[(if Po2[c]==nil then o5[c]else  Po2[c][1])] else o5[_s] =(if Po2[b]==nil then o5[b]else Po2[b][1])[(if Po2[c]==nil then o5[c]else  Po2[c][1])] end;f2[_s] =nil   end end return nil,Ls end N8[65] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local jG = dl[1][127][c + 1] local _sn = #jG local Gr if _sn == 0 then Gr = { n = 0 } elseif _sn == 1 and not jG[1][2] then Gr = { (if Po2[jG[1][1]]==nil then o5[jG[1][1]]else  Po2[jG[1][1]][1]), n = 1 } elseif _sn == 2 and not jG[1][2] and not jG[2][2] then Gr = { (if Po2[jG[1][1]]==nil then o5[jG[1][1]]else  Po2[jG[1][1]][1]), (if Po2[jG[2][1]]==nil then o5[jG[2][1]]else  Po2[jG[2][1]][1]), n = 2 } elseif _sn == 3 and not jG[1][2] and not jG[2][2] and not jG[3][2] then Gr = { (if Po2[jG[1][1]]==nil then o5[jG[1][1]]else  Po2[jG[1][1]][1]), (if Po2[jG[2][1]]==nil then o5[jG[2][1]]else  Po2[jG[2][1]][1]), (if Po2[jG[3][1]]==nil then o5[jG[3][1]]else  Po2[jG[3][1]][1]), n = 3 } else Gr = {} local _an = 0 for gO=  1, _sn do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do _an = _an + 1 Gr[_an] = La[Um] end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]==nil then o5[jL[1]]else  Po2[jL[1]][1]) end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]==nil then o5[jL[1]]else  Po2[jL[1]][1]) end end Gr.n = _an end local YV0 = l7((if Po2[b]==nil then o5[b]else  Po2[b][1]), Gr, dl[4]) if d ~= 0 then for BW=  0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end else local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 end  end return nil,Ls end N8[127] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _tab=(if Po2[a]==nil then o5[a]else  Po2[a][1]); _tab[(if Po2[b]==nil then o5[b]else  Po2[b][1])] = (if Po2[c]==nil then o5[c]else  Po2[c][1])    end end return nil,Ls end N8[91] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = dl[1][126](b,dl[6])    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =n1 else o5[_s] =n1 end;f2[_s] =nil end end return nil,Ls end N8[244] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =SE(dl[1],b)else o5[_s] =SE(dl[1],b)end;f2[_s] =nil   end end return nil,Ls end N8[152] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = (if Po2[b]==nil then o5[b]else  Po2[b][1]) local Gr = { n = 0 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[1]else o5[_s] =YV0[1]end;f2[_s] =nil   end f2[a] =YV0 else for BW=0, d - 1 do    local _s=a + BW;local _c=Po2[_s];if _c~=nil then _c[1] =YV0[BW+ 1] else o5[_s] =YV0[BW+ 1] end;f2[_s] =nil   end end end end return nil,Ls end N8[132] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _operand=(if Po2[b]==nil then o5[b]else  Po2[b][1])    local _out=-(_operand)    local _stored=_out;   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end return nil,Ls end N8[558] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =CL(dl[1],b)else o5[_s] =CL(dl[1],b)end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,_ca,0 local _tab=(if Po2[b]==nil then o5[b]else  Po2[b][1]);local _key=(if Po2[c]==nil then o5[c]else  Po2[c][1])    local _stored=_tab[_key];   local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end end return nil,Ls end N8[390] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[1][126](b,dl[6])else o5[_s] =dl[1][126](b,dl[6])end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,_ca,0 local _lhs=(if Po2[b]~=nil then Po2[b][1]else  o5[b]);local _rhs=(if Po2[c]~=nil then Po2[c][1]else  o5[c]) local _out=_lhs == _rhs local _stored=_out    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =_stored else o5[_s] =_stored end;f2[_s] =nil end end end return nil,Ls end N8[689] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,_cb,0,0    local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =dl[2][8627718][b+ 1][1] else o5[_s] =dl[2][8627718][b+ 1][1] end;f2[_s] =nil   end end local a,b,c,d=_cc,_cd,0,0       local _s=a;local _c=Po2[_s];if _c~=nil then _c[1] =SE(dl[1],b)else o5[_s] =SE(dl[1],b)end;f2[_s] =nil   end end end end return nil,Ls end local DM5={[108]=8,[27]=55,[92]=54,[40]=26,[130]=32,[136]=52,[242]=10,[95]=15,[54]=18,[225]=11,[80]=30,[24]=13,[111]=14,[212]=28,[69]=5,[72]=9,[122]=19,[234]=17,[89]=3,[193]=16,[58]=55,[2]=30,[106]=1,[100]=32,[137]=51,[187]=7,[232]=43,[184]=57,[87]=27,[154]=49,[79]=28,[67]=53,[73]=11,[157]=29,[31]=5,[202]=15,[49]=13,[41]=14,[22]=54,[128]=9,[9]=32,[224]=29,[68]=13,[26]=27,[15]=9,[141]=15,[88]=55,[165]=44,[241]=51,[71]=5,[162]=57,[214]=10,[65]=54,[127]=11,[91]=30,[152]=26,[132]=41}local kO={}kO[65] =function(a,b,c,d,o5,Po2,f2,dl,Ls)     local _tab=(if Po2[a]~=nil then Po2[a][1]elseif  o5[a]~=nil then o5[a][1]else  nil); _tab[(if Po2[b]~=nil then Po2[b][1]elseif  o5[b]~=nil then o5[b][1]else  nil)] = (if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil)    end end return nil,Ls end kO[235] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local jG = dl[1][127][c + 1] local _sn = #jG local Gr if _sn == 0 then Gr = { n = 0 } elseif _sn == 1 and not jG[1][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]elseif  o5[jG[1][1]]~=nil then o5[jG[1][1]][1]else  nil), n = 1 } elseif _sn == 2 and not jG[1][2] and not jG[2][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]elseif  o5[jG[1][1]]~=nil then o5[jG[1][1]][1]else  nil), (if Po2[jG[2][1]]~=nil then Po2[jG[2][1]][1]elseif  o5[jG[2][1]]~=nil then o5[jG[2][1]][1]else  nil), n = 2 } elseif _sn == 3 and not jG[1][2] and not jG[2][2] and not jG[3][2] then Gr = { (if Po2[jG[1][1]]~=nil then Po2[jG[1][1]][1]elseif  o5[jG[1][1]]~=nil then o5[jG[1][1]][1]else  nil), (if Po2[jG[2][1]]~=nil then Po2[jG[2][1]][1]elseif  o5[jG[2][1]]~=nil then o5[jG[2][1]][1]else  nil), (if Po2[jG[3][1]]~=nil then Po2[jG[3][1]][1]elseif  o5[jG[3][1]]~=nil then o5[jG[3][1]][1]else  nil), n = 3 } else Gr = {} local _an = 0 for gO=  1, _sn do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do _an = _an + 1 Gr[_an] = La[Um] end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]elseif  o5[jL[1]]~=nil then o5[jL[1]][1]else  nil) end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]elseif  o5[jL[1]]~=nil then o5[jL[1]][1]else  nil) end end Gr.n = _an end local YV0 = l7((if Po2[b]~=nil then Po2[b][1]elseif  o5[b]~=nil then o5[b][1]else  nil), Gr, dl[4]) if d ~= 0 then for BW=  0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _s=a + BW; if Po2[_s] then Po2[_s][1] =YV0[BW+ 1] elseif o5[_s] then o5[_s][1] =YV0[BW+ 1] else o5[_s] ={YV0[BW+ 1]} end    end end else if f2[a]~=nil then f2[a] =nil end;local _s=a; if Po2[_s] then Po2[_s][1] =YV0[1]elseif o5[_s] then o5[_s][1] =YV0[1]else o5[_s] ={YV0[1]}end    end f2[a] =YV0 end  end return nil,Ls end kO[170] =function(a,b,c,d,o5,Po2,f2,dl,Ls)return { n = 0 }, Ls    end return nil,Ls end kO[46] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = dl[1][126](b,dl[6])    if f2[a]~=nil then f2[a] =nil end;local _s=a; if Po2[_s] then Po2[_s][1] =n1 elseif o5[_s]then o5[_s][1] =n1 else o5[_s] ={n1}end   end end return nil,Ls end kO[923] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _ca,_cb,_cc,_cd=a,b,c,d    local a,b,c,d=_ca,0,0,0    if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =SE(dl[1],b)else local _b=o5[_s]; if _b~=nil then _b[1] =SE(dl[1],b)else o5[_s] ={SE(dl[1],b)}end end    end end local a,b,c,d=_cb,_cc,_ca,0 local _stored=(if Po2[b]~=nil then Po2[b][1]elseif  o5[b]~=nil then o5[b][1]else  nil)[(if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil)]    if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =_stored else local _b=o5[_s];if _b~=nil then _b[1] =_stored else o5[_s] ={_stored}end end   end end end return nil,Ls end local PO;local zO={} zO[11] =function(a,b,c,d,o5,Po2,f2,dl,Ls)      if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =dl[2][b+ 1][1] else local _b=o5[_s]; if _b~=nil then _b[1] =dl[2][b+ 1][1] else o5[_s] ={dl[2][b+ 1][1]} end end    end end return nil,Ls end zO[109] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; if Po2[_s] then Po2[_s][1] =CL(dl[1],b)elseif o5[_s] then o5[_s][1] =CL(dl[1],b)else o5[_s] ={CL(dl[1],b)}end    end end return nil,Ls end zO[106] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _out=(if Po2[b]~=nil then Po2[b][1]elseif  o5[b]~=nil then o5[b][1]else  nil) == (if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil)    local _stored=_out;   if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =_stored else local _b=o5[_s];if _b~=nil then _b[1] =_stored else o5[_s] ={_stored}end end   end end end return nil,Ls end zO[186] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local n1 = dl[1][198][a + 1] local l5 = { n = 0 } for gO=  1, #n1 do local jL = n1[gO] if jL[2] and f2[jL[1]] ~= nil then local La = f2[jL[1]] for Um=  1, La.n do l5.n = l5.n + 1 l5[l5.n] = La[Um] end else l5.n = l5.n + 1 l5[l5.n] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]elseif  o5[jL[1]]~=nil then o5[jL[1]][1]else  nil) end end return l5, Ls    end return nil,Ls end zO[189] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =(if Po2[b]~=nil then Po2[b][1]elseif o5[b]~=nil then o5[b][1]else  nil)[(if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil)] else local _b=o5[_s]; if _b~=nil then _b[1] =(if Po2[b]~=nil then Po2[b][1]elseif o5[b]~=nil then o5[b][1]else  nil)[(if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil)] else o5[_s] ={(if Po2[b]~=nil then Po2[b][1]elseif o5[b]~=nil then o5[b][1]else  nil)[(if Po2[c]~=nil then Po2[c][1]elseif  o5[c]~=nil then o5[c][1]else  nil)]} end end    end end return nil,Ls end PO =function(mg)if mg<109 then if mg<106 then if mg==11 then return zO[11]else uC()end else if mg==106 then return zO[106]else uC() end end else if mg<186 then if mg==109 then return zO[109] else uC() end else if mg<189 then if mg==186 then return zO[186] else uC() end else if mg==189 then return zO[189] else uC() end end end end end    end local u1={}u1[104] =function(a,b,c,d,o5,Po2,f2,dl,Ls) return { n = 0 }, Ls    end return nil,Ls end u1[23] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =b else local _b=o5[_s];if _b~=nil then _b[1] =b else o5[_s] ={b}end end   end end return nil,Ls end u1[237] =function(a,b,c,d,o5,Po2,f2,dl,Ls)   if f2[a]~=nil then f2[a] =nil end;local _s=a; local _c=Po2[_s]; if _c~=nil then _c[1] =RO(dl[1],b)else local _b=o5[_s]; if _b~=nil then _b[1] =RO(dl[1],b)else o5[_s] ={RO(dl[1],b)}end end    end end return nil,Ls end local N7={[65]=11,[235]=54,[170]=57,[46]=30,[11]=52,[106]=43,[186]=55,[189]=10,[104]=57,[23]=16}local iO={}iO[174] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)   local n1 = dl[1][127][c + 1] local jG = n1 local Gr = { n = 0 } for gO=  1, #jG do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do Gr.n = Gr.n + 1 Gr[Gr.n] = La[Um] end else Gr.n = Gr.n + 1 Gr[Gr.n] = (if Po2[jL[1]]==nil then o5[((jL[1]+_bo)%_bn)+1][fO[166]((jL[1])/_bn)]else  Po2[jL[1]][1]) end else Gr.n = Gr.n + 1 Gr[Gr.n] = (if Po2[jL[1]]==nil then o5[((jL[1]+_bo)%_bn)+1][fO[166]((jL[1])/_bn)]else  Po2[jL[1]][1]) end end local YV0 = l7((if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else  Po2[b][1]), Gr, dl[4]) if d == 0 then    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[1]end   end f2[a] =YV0 else for BW=0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _i=a+ BW;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[BW+ 1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[BW+ 1] end    end end end end return nil,Ls end iO[197] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =b else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =b end end end return nil,Ls end iO[222] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local n1 = NO((if Po2[a]==nil then o5[((a+_bo)%_bn)+1][fO[166]((a)/_bn)]else  Po2[a][1])) if n1 then Ls = b + 1 end    end return nil,Ls end iO[77] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =dl[2][b+1][1][1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =dl[2][b+ 1][1][1] end    end end return nil,Ls end iO[119] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)]), n = 1 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[1]end   end f2[a] =YV0 else for BW=0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _i=a+ BW;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[BW+ 1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[BW+ 1] end    end end end end return nil,Ls end iO[171] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    local n1 = dl[1][126](b,dl[6])    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =n1 else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =n1 end end end end return nil,Ls end iO[34] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)])    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =n1 else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =n1 end end end return nil,Ls end iO[12] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local _operand=(if Po2[b]~=nil then Po2[b][1]else  o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)])    local _out=#(_operand)       local _stored=_out;   if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =_stored else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =_stored end end end end end end return nil,Ls end local vg1;local YS9={} YS9[127] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    local _lhs=(if Po2[b]~=nil then Po2[b][1]else  o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]);local _rhs=(if Po2[c]~=nil then Po2[c][1]else  o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)]) local _out=_lhs == _rhs    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =_out else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =_out end end end return nil,Ls end YS9[11] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)       if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =dl[1][126](b,dl[6])else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =dl[1][126](b,dl[6])end   end end end return nil,Ls end YS9[230] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local n1 = NO((if Po2[a]==nil then o5[((a+_bo)%_bn)+1][fO[166]((a)/_bn)]else  Po2[a][1])) if not n1 then Ls = b + 1 end    end return nil,Ls end YS9[90] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]) local Gr = { (if Po2[c]~=nil then Po2[c][1]else  o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)]), (if Po2[c + 1]~=nil then Po2[c + 1][1]else  o5[((c + 1+_bo)%_bn)+1][fO[166]((c + 1)/_bn)]), n = 2 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[1]end   end f2[a] =YV0 else for BW=0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _i=a+ BW;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[BW+ 1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[BW+ 1] end    end end end end return nil,Ls end YS9[175] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local jG = dl[1][127][c + 1] local _sn = #jG local Gr if _sn == 0 then Gr = { n = 0 } elseif _sn == 1 and not jG[1][2] then Gr = { (if Po2[jG[1][1]]==nil then o5[((jG[1][1]+_bo)%_bn)+1][fO[166]((jG[1][1])/_bn)]else  Po2[jG[1][1]][1]), n = 1 } elseif _sn == 2 and not jG[1][2] and not jG[2][2] then Gr = { (if Po2[jG[1][1]]==nil then o5[((jG[1][1]+_bo)%_bn)+1][fO[166]((jG[1][1])/_bn)]else  Po2[jG[1][1]][1]), (if Po2[jG[2][1]]==nil then o5[((jG[2][1]+_bo)%_bn)+1][fO[166]((jG[2][1])/_bn)]else  Po2[jG[2][1]][1]), n = 2 } elseif _sn == 3 and not jG[1][2] and not jG[2][2] and not jG[3][2] then Gr = { (if Po2[jG[1][1]]==nil then o5[((jG[1][1]+_bo)%_bn)+1][fO[166]((jG[1][1])/_bn)]else  Po2[jG[1][1]][1]), (if Po2[jG[2][1]]==nil then o5[((jG[2][1]+_bo)%_bn)+1][fO[166]((jG[2][1])/_bn)]else  Po2[jG[2][1]][1]), (if Po2[jG[3][1]]==nil then o5[((jG[3][1]+_bo)%_bn)+1][fO[166]((jG[3][1])/_bn)]else  Po2[jG[3][1]][1]), n = 3 } else Gr = {} local _an = 0 for gO=  1, _sn do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do _an = _an + 1 Gr[_an] = La[Um] end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]==nil then o5[((jL[1]+_bo)%_bn)+1][fO[166]((jL[1])/_bn)]else  Po2[jL[1]][1]) end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]==nil then o5[((jL[1]+_bo)%_bn)+1][fO[166]((jL[1])/_bn)]else  Po2[jL[1]][1]) end end Gr.n = _an end local YV0 = l7((if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else  Po2[b][1]), Gr, dl[4]) if d == 0 then    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[1]end   end f2[a] =YV0 else for BW=0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _i=a+ BW;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[BW+ 1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[BW+ 1] end    end end end end return nil,Ls end YS9[158] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) if d == 0 then    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =dl[3][1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =dl[3][1]end   end f2[a] =dl[3]else for BW= 0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _i=a+ BW;local _c=Po2[_i];if _c~=nil then _c[1] =dl[3][BW+ 1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =dl[3][BW+ 1] end    end end end end return nil,Ls end YS9[18] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local n1 = dl[1][198][a + 1] local l5 = { n = 0 } for gO=  1, #n1 do local jL = n1[gO] if jL[2] and f2[jL[1]] ~= nil then local La = f2[jL[1]] for Um=  1, La.n do l5.n = l5.n + 1 l5[l5.n] = La[Um] end else l5.n = l5.n + 1 l5[l5.n] = (if Po2[jL[1]]~=nil then Po2[jL[1]][1]else  o5[((jL[1]+_bo)%_bn)+1][fO[166]((jL[1])/_bn)]) end end return l5, Ls    end return nil,Ls end YS9[161] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local n1 = (if Po2[b]~=nil then Po2[b][1]else  o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)])    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =n1 else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =n1 end end end return nil,Ls end YS9[185] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local n1 = (if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else  Po2[b][1]) local Gr = { (if Po2[c]==nil then o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)]else  Po2[c][1]), n = 1 } local YV0 = l7(n1, Gr, dl[4]) if d == 0 then    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[1]end   end f2[a] =YV0 else for BW=0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _i=a+ BW;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[BW+ 1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[BW+ 1] end    end end end end return nil,Ls end vg1 =function(qa8)if qa8<158 then if qa8<90 then if qa8<18 then if qa8==11 then return YS9[11]else uC()end else if qa8==18 then return YS9[18]else uC() end end else if qa8<127 then if qa8==90 then return YS9[90] else uC() end else if qa8==127 then return YS9[127] else uC() end end end else if qa8<175 then if qa8<161 then if qa8==158 then return YS9[158] else uC() end else if qa8==161 then return YS9[161] else uC() end end else if qa8<185 then if qa8==175 then return YS9[175] else uC() end else if qa8<230 then if qa8==185 then return YS9[185] else uC() end else if qa8==230 then return YS9[230] else uC() end end end end end end    end local J3={}J3[183] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)     if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else Po2[b][1])else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =(if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else Po2[b][1]) end    end end return nil,Ls end J3[218] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =(if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else Po2[b][1])~= (if Po2[c]==nil then o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)]else  Po2[c][1]) else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =(if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else Po2[b][1]) ~= (if Po2[c]==nil then o5[((c+_bo)%_bn)+1][fO[166]((c)/_bn)]else  Po2[c][1]) end    end end return nil,Ls end J3[135] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) Ls = a + 1    end return nil,Ls end J3[148] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn)    if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =RO(dl[1],b)else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =RO(dl[1],b)end   end end return nil,Ls end J3[117] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) local jG = dl[1][127][c + 1] local _sn = #jG local Gr if _sn == 0 then Gr = { n = 0 } elseif _sn == 1 and not jG[1][2] then Gr = { (if Po2[jG[1][1]]==nil then o5[((jG[1][1]+_bo)%_bn)+1][fO[166]((jG[1][1])/_bn)]else  Po2[jG[1][1]][1]), n = 1 } elseif _sn == 2 and not jG[1][2] and not jG[2][2] then Gr = { (if Po2[jG[1][1]]==nil then o5[((jG[1][1]+_bo)%_bn)+1][fO[166]((jG[1][1])/_bn)]else  Po2[jG[1][1]][1]), (if Po2[jG[2][1]]==nil then o5[((jG[2][1]+_bo)%_bn)+1][fO[166]((jG[2][1])/_bn)]else  Po2[jG[2][1]][1]), n = 2 } elseif _sn == 3 and not jG[1][2] and not jG[2][2] and not jG[3][2] then Gr = { (if Po2[jG[1][1]]==nil then o5[((jG[1][1]+_bo)%_bn)+1][fO[166]((jG[1][1])/_bn)]else  Po2[jG[1][1]][1]), (if Po2[jG[2][1]]==nil then o5[((jG[2][1]+_bo)%_bn)+1][fO[166]((jG[2][1])/_bn)]else  Po2[jG[2][1]][1]), (if Po2[jG[3][1]]==nil then o5[((jG[3][1]+_bo)%_bn)+1][fO[166]((jG[3][1])/_bn)]else  Po2[jG[3][1]][1]), n = 3 } else Gr = {} local _an = 0 for gO=  1, _sn do local jL = jG[gO] if jL[2] then local La = f2[jL[1]] if La ~= nil then for Um=  1, La.n do _an = _an + 1 Gr[_an] = La[Um] end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]==nil then o5[((jL[1]+_bo)%_bn)+1][fO[166]((jL[1])/_bn)]else  Po2[jL[1]][1]) end else _an = _an + 1 Gr[_an] = (if Po2[jL[1]]==nil then o5[((jL[1]+_bo)%_bn)+1][fO[166]((jL[1])/_bn)]else  Po2[jL[1]][1]) end end Gr.n = _an end local YV0 = l7((if Po2[b]==nil then o5[((b+_bo)%_bn)+1][fO[166]((b)/_bn)]else  Po2[b][1]), Gr, dl[4]) if d ~= 0 then for BW=  0, d - 1 do    if f2[a + BW]~=nil then f2[a + BW] =nil end;local _i=a+ BW;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[BW+ 1] else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[BW+ 1] end    end end else if f2[a]~=nil then f2[a] =nil end;local _i=a;local _c=Po2[_i];if _c~=nil then _c[1] =YV0[1]else local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =YV0[1]end   end f2[a] =YV0 end  end return nil,Ls end J3[118] =function(a,b,c,d,o5,Po2,f2,dl,Ls)local _bn=2+((dl[1][59]+20786)%3);local _bo=((dl[1][59]*37997+20786)%_bn) return { n = 0 }, Ls    end return nil,Ls end local R5={[174]=54,[197]=16,[222]=14,[77]=52,[119]=27,[171]=30,[34]=5,[12]=19,[127]=43,[11]=30,[230]=15,[90]=28,[175]=54,[18]=55,[161]=5,[185]=27,[183]=5,[218]=44,[135]=13,[117]=54,[118]=57}local e5={}e5.__rcmaxm8_0 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2] local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689) local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm) local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss) _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 if _g==0 then _disp =di elseif _g==1 then _disp =Np6 elseif _g==2 then _disp =ao5 else uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC() end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2620409529] ={e5.__rcmaxm8_0,1,3377872752}e5.__r1rxygf1_1 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g<1 then _disp =di else if _g<2 then _disp =Np6 else _disp =ao5 end end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2949031110] ={e5.__r1rxygf1_1,1,2178992618}e5.__r17800rt_2 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 if _g==0 then _disp =di elseif _g==1 then _disp =Np6 elseif _g==2 then _disp =ao5 else uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1027844447] ={e5.__r17800rt_2,1,2287708299}e5.__rbwl4i8_3 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 if _g==0 then _disp =di elseif _g==1 then _disp =Np6 elseif _g==2 then _disp =ao5 else uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1278927262] ={e5.__rbwl4i8_3,1,2313981273}e5.__r1g5sgix_4 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g==0 then _disp =di elseif _g==1 then _disp =Np6 elseif _g==2 then _disp =ao5 else uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[4174829015] ={e5.__r1g5sgix_4,1,2175872827}e5.__r1qlpl4o_5_g ={[3043150820]=di,[3043150821]=Np6,[3043150822]=ao5}e5.__r1qlpl4o_5 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1qlpl4o_5_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[685141325] ={e5.__r1qlpl4o_5,1,3043150820}e5.__r70qe9o_6 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g<1 then _disp =di else if _g<2 then _disp =Np6 else _disp =ao5 end end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2676521112] ={e5.__r70qe9o_6,1,2727782459}e5.__r1pgh8dg_7 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 if _g<1 then _disp =di else if _g<2 then _disp =Np6 else _disp =ao5 end end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[545813639] ={e5.__r1pgh8dg_7,1,1950602937}e5.__rwzsa35_8 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g==0 then _disp =di elseif _g==1 then _disp =Np6 elseif _g==2 then _disp =ao5 else uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3894761075] ={e5.__rwzsa35_8,1,2103235912}e5.__r1pabvm6_9 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g==0 then _disp =di elseif _g==1 then _disp =Np6 elseif _g==2 then _disp =ao5 else uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2479129083] ={e5.__r1pabvm6_9,1,649050121}e5.__r19swwy9_a =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 if _g<1 then _disp =di else if _g<2 then _disp =Np6 else _disp =ao5 end end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[363847353] ={e5.__r19swwy9_a,1,740972884}e5.__rs8ra7c_b =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g<1 then _disp =di else if _g<2 then _disp =Np6 else _disp =ao5 end end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3931917903] ={e5.__rs8ra7c_b,1,1703027578}e5.__r1wpqb83_c =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g<1 then _disp =fe else if _g<2 then _disp =YK else _disp =N8 end end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[4096223144] ={e5.__r1wpqb83_c,4,2764268871}e5.__r1oqb2jz_d_g ={[946349414]=fe,[946349415]=YK,[946349412]=N8}e5.__r1oqb2jz_d =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r1oqb2jz_d_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[565809757] ={e5.__r1oqb2jz_d,4,946349414}e5.__r1wie87_e =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3196789887))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,20),fO[87](_ss,12)),2792819664))local _q0,_q1,_q2,_q3,_q4=xx_2(_lo,_hi,_ss)_ns =_ts5(_ss,_lo,_hi,_q0,_q3,_q2,_q1,_q4)local _g=fO[95](fO[106](_q0,55)*221+61309,4294967295)%3 if _g==0 then _disp =kO elseif _g==1 then _disp =PO elseif _g==2 then _disp =u1 else uC()end if _g==0or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q3;_w[5] =_q2;_w[6] =_q1;_w[7] =_q4;_w[9] =_ns;_w[10] =N7[_q0]or 0 _out,_npc =_disp(_q3,_q2,_q1,_q4,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3976358908] ={e5.__r1wie87_e,5,2334199384}e5.__rzfbzkd_f_g ={[3927352698]=kO,[3927352699]=PO,[3927352696]=u1}e5.__rzfbzkd_f =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms5(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_2(_lo,_hi,_ss)local _g=fO[95](fO[106](_q0,55)*221+61309,4294967295)%3 _disp =e5.__rzfbzkd_f_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[95](fO[121](fO[215](_ss,10),fO[87](_ss,22))+_lo+_q0*14983+_q3*52821+_q2*8725+_q1*35353+_q4*26819,4294967295);_x =fO[106](fO[106](_x,_hi),1317670241);return fO[121](fO[215](_x,20),fO[87](_x,12));end end)()if _g==0or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q3;_w[5] =_q2;_w[6] =_q1;_w[7] =_q4;_w[9] =_ns;_w[10] =N7[_q0]or 0 _out,_npc =_disp(_q3,_q2,_q1,_q4,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[886156771] ={e5.__rzfbzkd_f,5,3927352698}e5.__r1xrwkdf_g_g ={[3746383989]=iO,[3746383988]=vg1,[3746383991]=J3}e5.__r1xrwkdf_g =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,615247068);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),872222841)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[95](fO[106](_q0,5)*35+12660,4294967295)%3 _disp =e5.__r1xrwkdf_g_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts6(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =R5[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2742680868] ={e5.__r1xrwkdf_g,6,3746383989}e5.__rsqcp2p_h =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,615247068);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),872222841)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[95](fO[106](_q0,5)*35+12660,4294967295)%3 if _g<1 then _disp =iO else if _g<2 then _disp =vg1 else _disp =J3 end end _ns =_ts6(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =R5[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2566353830] ={e5.__rsqcp2p_h,6,3649912113}e5.__r4tj2jk_i =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,615247068))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),872222841))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts6(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[95](fO[106](_q0,5)*35+12660,4294967295)%3 if _g<1 then _disp =iO else if _g<2 then _disp =vg1 else _disp =J3 end end if _g==0or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =R5[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[429129236] ={e5.__r4tj2jk_i,6,1887938041}e5.__r1tiu1bs_j_g ={[440797370]=iO,[440797371]=vg1,[440797368]=J3}e5.__r1tiu1bs_j =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms6(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[95](fO[106](_q0,5)*35+12660,4294967295)%3 _disp =e5.__r1tiu1bs_j_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[95](fO[121](fO[215](_ss,29),fO[87](_ss,3))+_lo+_q0*13637+_q4*44633+_q3*53885+_q2*11407+_q1*24539,4294967295);_x =fO[106](fO[106](_x,_hi),1441872172);return fO[121](fO[215](_x,13),fO[87](_x,19))end)()if _g==0or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =R5[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[4076974630] ={e5.__r1tiu1bs_j,6,440797370}e5.__r1c10xy9_k_g ={[3249653817]=iO,[3249653816]=vg1,[3249653819]=J3}e5.__r1c10xy9_k =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,615247068);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),872222841)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[95](fO[106](_q0,5)*35+12660,4294967295)%3 _disp =e5.__r1c10xy9_k_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts6(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =R5[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3202203638] ={e5.__r1c10xy9_k,6,3249653817}e5.__redyxdl_l =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,615247068))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),872222841))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[95](fO[106](_q0,5)*35+12660,4294967295)%3 if _g==0 then _disp =iO elseif _g==1 then _disp =vg1 elseif _g==2 then _disp =J3 else uC()end _ns =(function()local _x=fO[95](fO[121](fO[215](_ss,29),fO[87](_ss,3))+_lo+_q0*13637+_q4*44633+_q3*53885+_q2*11407+_q1*24539,4294967295);_x =fO[106](fO[106](_x,_hi),1441872172);return fO[121](fO[215](_x,13),fO[87](_x,19))end)()if _g==0or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =R5[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[588208816] ={e5.__redyxdl_l,6,1382349103}e5.__rsti1lx_m =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,615247068);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),872222841)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[95](fO[106](_q0,5)*35+12660,4294967295)%3 if _g==0 then _disp =iO elseif _g==1 then _disp =vg1 elseif _g==2 then _disp =J3 else uC()end _ns =(function()local _x=fO[95](fO[121](fO[215](_ss,29),fO[87](_ss,3))+_lo+_q0*13637+_q4*44633+_q3*53885+_q2*11407+_q1*24539,4294967295);_x =fO[106](fO[106](_x,_hi),1441872172);return fO[121](fO[215](_x,13),fO[87](_x,19))end)()if _g==0or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =R5[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[31603487] ={e5.__rsti1lx_m,6,2613747501}e5.__r1nn33vf_n =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,615247068);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),872222841)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[95](fO[106](_q0,5)*35+12660,4294967295)%3 if _g==0 then _disp =iO elseif _g==1 then _disp =vg1 elseif _g==2 then _disp =J3 else uC()end _ns =_ts6(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =R5[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[282361897] ={e5.__r1nn33vf_n,6,2716603694}e5[210161810] ={e5.__r1g5sgix_4,1,3662621818}e5[2305380279] ={e5.__rbwl4i8_3,1,1522104991}e5.__r12v5bdl_q_g ={[3148398293]=di,[3148398292]=Np6,[3148398295]=ao5}e5.__r12v5bdl_q =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r12v5bdl_q_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2594587179] ={e5.__r12v5bdl_q,1,3148398293}e5.__rw4q9wd_r_g ={[852973472]=di,[852973473]=Np6,[852973474]=ao5}e5.__rw4q9wd_r =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__rw4q9wd_r_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3740377501] ={e5.__rw4q9wd_r,1,852973472}e5[207170447] ={e5.__r1pgh8dg_7,1,1164618701}e5[3224315998] ={e5.__rbwl4i8_3,1,3918072449}e5.__rk2oxrh_u_g ={[3405783293]=di,[3405783292]=Np6,[3405783295]=ao5}e5.__rk2oxrh_u =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__rk2oxrh_u_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1043260991] ={e5.__rk2oxrh_u,1,3405783293}e5[1536886154] ={e5.__r1g5sgix_4,1,3358859996}e5.__rba5e19_w =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g<1 then _disp =di else if _g<2 then _disp =Np6 else _disp =ao5 end end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[4250815807] ={e5.__rba5e19_w,1,3023935734}e5.__r11gelu6_x_g ={[236021220]=di,[236021221]=Np6,[236021222]=ao5}e5.__r11gelu6_x =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__r11gelu6_x_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1080840328] ={e5.__r11gelu6_x,1,236021220}e5[66585425] ={e5.__r1pgh8dg_7,1,3193887678}e5[887406134] ={e5.__rs8ra7c_b,1,3907827714}e5.__r1puuo6r_10_g ={[1272169133]=di,[1272169132]=Np6,[1272169135]=ao5}e5.__r1puuo6r_10 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1puuo6r_10_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2433107066] ={e5.__r1puuo6r_10,1,1272169133}e5[2761712405] ={e5.__rcmaxm8_0,1,1644238513}e5[1914432457] ={e5.__r19swwy9_a,1,136393048}e5[916902921] ={e5.__r70qe9o_6,1,574237631}e5[3823621026] ={e5.__r1rxygf1_1,1,1558204388}e5[3761696320] ={e5.__rwzsa35_8,1,933174241}e5[1963022368] ={e5.__r1pgh8dg_7,1,482476610}e5.__r1069h15_17 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 if _g<1 then _disp =di else if _g<2 then _disp =Np6 else _disp =ao5 end end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[42610653] ={e5.__r1069h15_17,1,3757073022}e5[2767467622] ={e5.__r1pgh8dg_7,1,3507359074}e5.__r1xbnp8d_19_g ={[33371193]=di,[33371192]=Np6,[33371195]=ao5}e5.__r1xbnp8d_19 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1xbnp8d_19_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2685051233] ={e5.__r1xbnp8d_19,1,33371193}e5.__r6b5dp2_1a_g ={[2724824269]=di,[2724824268]=Np6,[2724824271]=ao5}e5.__r6b5dp2_1a =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r6b5dp2_1a_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3997071840] ={e5.__r6b5dp2_1a,1,2724824269}e5.__r165pbei_1b_g ={[450332760]=di,[450332761]=Np6,[450332762]=ao5}e5.__r165pbei_1b =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r165pbei_1b_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[4055079160] ={e5.__r165pbei_1b,1,450332760}e5[2280198296] ={e5.__rs8ra7c_b,1,758314812}e5.__r1jvo8s8_1d =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g<1 then _disp =di else if _g<2 then _disp =Np6 else _disp =ao5 end end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1275375217] ={e5.__r1jvo8s8_1d,1,649136761}e5[2585994984] ={e5.__r1rxygf1_1,1,580771798}e5.__r1uzw5xv_1f_g ={[3323161007]=di,[3323161006]=Np6,[3323161005]=ao5}e5.__r1uzw5xv_1f =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1uzw5xv_1f_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2893396169] ={e5.__r1uzw5xv_1f,1,3323161007}e5[877567284] ={e5.__rwzsa35_8,1,169070550}e5.__r1z02daz_1h_g ={[1493027339]=di,[1493027338]=Np6,[1493027337]=ao5}e5.__r1z02daz_1h =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1z02daz_1h_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1722673190] ={e5.__r1z02daz_1h,1,1493027339}e5.__raciia1_1i_g ={[3108308732]=di,[3108308733]=Np6,[3108308734]=ao5}e5.__raciia1_1i =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__raciia1_1i_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1045708622] ={e5.__raciia1_1i,1,3108308732}e5.__r1j9o4t4_1j_g ={[4076502610]=di,[4076502611]=Np6,[4076502608]=ao5}e5.__r1j9o4t4_1j =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1j9o4t4_1j_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[156292482] ={e5.__r1j9o4t4_1j,1,4076502610}e5.__rkm985z_1k =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g==0 then _disp =di elseif _g==1 then _disp =Np6 elseif _g==2 then _disp =ao5 else uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3799992822] ={e5.__rkm985z_1k,1,180717511}e5.__rpz9rbm_1l =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g==0 then _disp =di elseif _g==1 then _disp =Np6 elseif _g==2 then _disp =ao5 else uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3209125810] ={e5.__rpz9rbm_1l,1,351975726}e5.__r1i8oc0_1m_g ={[2111885847]=di,[2111885846]=Np6,[2111885845]=ao5}e5.__r1i8oc0_1m =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__r1i8oc0_1m_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[102369427] ={e5.__r1i8oc0_1m,1,2111885847}e5[3376297717] ={e5.__r1pgh8dg_7,1,1639677671}e5[1058070621] ={e5.__r19swwy9_a,1,1223306920}e5[1392407737] ={e5.__r1rxygf1_1,1,1078300538}e5.__r1g1fa3f_1q_g ={[4274813239]=di,[4274813238]=Np6,[4274813237]=ao5}e5.__r1g1fa3f_1q =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1g1fa3f_1q_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3264051849] ={e5.__r1g1fa3f_1q,1,4274813239}e5.__rqur14a_1r_g ={[1233026731]=di,[1233026730]=Np6,[1233026729]=ao5}e5.__rqur14a_1r =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__rqur14a_1r_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1884048521] ={e5.__rqur14a_1r,1,1233026731}e5[4173106448] ={e5.__r1pabvm6_9,1,912937282}e5[643064304] ={e5.__rpz9rbm_1l,1,969357138}e5[4201616535] ={e5.__r19swwy9_a,1,2465990817}e5.__ry8ldtq_1v_g ={[1132011868]=di,[1132011869]=Np6,[1132011870]=ao5}e5.__ry8ldtq_1v =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__ry8ldtq_1v_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2739514251] ={e5.__ry8ldtq_1v,1,1132011868}e5.__rb527fi_1w_g ={[3179128714]=di,[3179128715]=Np6,[3179128712]=ao5}e5.__rb527fi_1w =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__rb527fi_1w_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3733083361] ={e5.__rb527fi_1w,1,3179128714}e5[868875919] ={e5.__rkm985z_1k,1,571017483}e5.__rwa904c_1y_g ={[2699560324]=di,[2699560325]=Np6,[2699560326]=ao5}e5.__rwa904c_1y =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__rwa904c_1y_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1451519990] ={e5.__rwa904c_1y,1,2699560324}e5[2542139738] ={e5.__r1rxygf1_1,1,3538740390}e5.__rqxo5is_20 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g==0 then _disp =fe elseif _g==1 then _disp =YK elseif _g==2 then _disp =N8 else uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[420057002] ={e5.__rqxo5is_20,4,3681357728}e5[354588415] ={e5.__rpz9rbm_1l,1,2628002427}e5[2164617229] ={e5.__rkm985z_1k,1,2478720955}e5[3687951286] ={e5.__r1pgh8dg_7,1,238525067}e5[1803355942] ={e5.__rkm985z_1k,1,1231581495}e5[1695277825] ={e5.__r1rxygf1_1,1,2529120343}e5.__r1xd5e15_26_g ={[1824441098]=di,[1824441099]=Np6,[1824441096]=ao5}e5.__r1xd5e15_26 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1xd5e15_26_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[587395960] ={e5.__r1xd5e15_26,1,1824441098}e5[3163414606] ={e5.__r17800rt_2,1,2253215847}e5[1522566782] ={e5.__r1g5sgix_4,1,1683787222}e5.__rkivqyt_29 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g==0 then _disp =di elseif _g==1 then _disp =Np6 elseif _g==2 then _disp =ao5 else uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1215698932] ={e5.__rkivqyt_29,1,2619824154}e5[3474434132] ={e5.__rbwl4i8_3,1,3421623072}e5[2505676864] ={e5.__r70qe9o_6,1,1144719141}e5[1370001639] ={e5.__r1pgh8dg_7,1,1220081352}e5[1677045235] ={e5.__r19swwy9_a,1,243404836}e5.__r1tkrf0i_2e =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 if _g<1 then _disp =di else if _g<2 then _disp =Np6 else _disp =ao5 end end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[729048139] ={e5.__r1tkrf0i_2e,1,2318886674}e5.__r1blpc39_2f_g ={[3192335807]=di,[3192335806]=Np6,[3192335805]=ao5}e5.__r1blpc39_2f =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__r1blpc39_2f_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[4120262494] ={e5.__r1blpc39_2f,1,3192335807}e5[714567175] ={e5.__rba5e19_w,1,4265565793}e5[2399520228] ={e5.__rba5e19_w,1,1336269183}e5[721329317] ={e5.__rkivqyt_29,1,1301445344}e5[2251149421] ={e5.__r70qe9o_6,1,2439330871}e5[132458674] ={e5.__r1069h15_17,1,2546056526}e5.__rt03uj9_2l_g ={[3891873635]=di,[3891873634]=Np6,[3891873633]=ao5}e5.__rt03uj9_2l =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__rt03uj9_2l_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1066183738] ={e5.__rt03uj9_2l,1,3891873635}e5.__rrqaiew_2m_g ={[987103329]=di,[987103328]=Np6,[987103331]=ao5}e5.__rrqaiew_2m =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__rrqaiew_2m_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2960922048] ={e5.__rrqaiew_2m,1,987103329}e5[1046193487] ={e5.__rbwl4i8_3,1,2778394965}e5[1368508835] ={e5.__r1pgh8dg_7,1,2770880637}e5[1783797900] ={e5.__rba5e19_w,1,716227076}e5.__rnrm40o_2q_g ={[2858821703]=di,[2858821702]=Np6,[2858821701]=ao5}e5.__rnrm40o_2q =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__rnrm40o_2q_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[4061616343] ={e5.__rnrm40o_2q,1,2858821703}e5.__r95y3oj_2r_g ={[2557879586]=di,[2557879587]=Np6,[2557879584]=ao5}e5.__r95y3oj_2r =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r95y3oj_2r_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1077784673] ={e5.__r95y3oj_2r,1,2557879586}e5[2321457844] ={e5.__r1pabvm6_9,1,2671246688}e5[1630648730] ={e5.__rbwl4i8_3,1,2603116643}e5[3207907381] ={e5.__rwzsa35_8,1,937937193}e5[3553600833] ={e5.__rpz9rbm_1l,1,4004479362}e5[3027316972] ={e5.__r1g5sgix_4,1,3415074457}e5.__r11g0a81_2x =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,1919612517);local _hm=fO[106](fO[121](fO[215](_ss,14),fO[87](_ss,18)),1437566630)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_2(_lo,_hi,_ss)local _g=fO[106](_q0,25)%3 if _g<1 then _disp =q5 else if _g<2 then _disp =dO else _disp =lO end end _ns =_ts0(_ss,_lo,_hi,_q0,_q3,_q2,_q1,_q4)_disp =_disp(_q0)if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q3;_w[5] =_q2;_w[6] =_q1;_w[7] =_q4;_w[9] =_ns;_w[10] =GO[_q0]or 0 _out,_npc =_disp(_q3,_q2,_q1,_q4,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1725098002] ={e5.__r11g0a81_2x,0,3699130692}e5.__rzl6e0r_2y_g ={[2064553187]=q5,[2064553186]=dO,[2064553185]=lO}e5.__rzl6e0r_2y =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,1919612517);local _hm=fO[106](fO[121](fO[215](_ss,14),fO[87](_ss,18)),1437566630)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_2(_lo,_hi,_ss)local _g=fO[106](_q0,25)%3 _disp =e5.__rzl6e0r_2y_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts0(_ss,_lo,_hi,_q0,_q3,_q2,_q1,_q4)_disp =_disp(_q0)if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q3;_w[5] =_q2;_w[6] =_q1;_w[7] =_q4;_w[9] =_ns;_w[10] =GO[_q0]or 0 _out,_npc =_disp(_q3,_q2,_q1,_q4,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2500976630] ={e5.__rzl6e0r_2y,0,2064553187}e5.__r1dusjs4_2z_g ={[3872550118]=di,[3872550119]=Np6,[3872550116]=ao5}e5.__r1dusjs4_2z =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1dusjs4_2z_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2877307552] ={e5.__r1dusjs4_2z,1,3872550118}e5.__r1vvwfrc_30_g ={[658327839]=di,[658327838]=Np6,[658327837]=ao5}e5.__r1vvwfrc_30 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__r1vvwfrc_30_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1807160161] ={e5.__r1vvwfrc_30,1,658327839}e5[152325483] ={e5.__rcmaxm8_0,1,2184273847}e5[914832771] ={e5.__rcmaxm8_0,1,272237371}e5.__r144w9l1_33_g ={[3844378359]=FU,[3844378358]=wy,[3844378357]=vy4}e5.__r144w9l1_33 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,229728453);local _hm=fO[106](fO[121](fO[215](_ss,16),fO[87](_ss,16)),1059741899)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)_ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 _disp =e5.__r144w9l1_33_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3023850972] ={e5.__r144w9l1_33,2,3844378359}e5.__r129x4ki_34_g ={[3639264872]=FU,[3639264873]=wy,[3639264874]=vy4}e5.__r129x4ki_34 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms2(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 _disp =e5.__r129x4ki_34_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo,fO[121](fO[215](_hi,29),fO[87](_hi,3)),_q1*11687);_x =fO[106](_x,_q2*2599,_q4*23429,_q0*54901,_q3*28507);_x =fO[95](_x*11687+3123651450,4294967295);return fO[106](_x,fO[87](_x,12));end end)()if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[899050077] ={e5.__r129x4ki_34,2,3639264872}e5.__r50s3kv_35_g ={[1699980457]=fe,[1699980456]=YK,[1699980459]=N8}e5.__r50s3kv_35 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 _disp =e5.__r50s3kv_35_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[587904702] ={e5.__r50s3kv_35,4,1699980457}e5.__r17gccsd_36 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g==0 then _disp =fe elseif _g==1 then _disp =YK elseif _g==2 then _disp =N8 else uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2199785785] ={e5.__r17gccsd_36,4,3811161761}e5.__rii241m_37 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 if _g==0 then _disp =fe elseif _g==1 then _disp =YK elseif _g==2 then _disp =N8 else uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[178332287] ={e5.__rii241m_37,4,1754664541}e5.__r10sjnxr_38_g ={[2040021415]=fe,[2040021414]=YK,[2040021413]=N8}e5.__r10sjnxr_38 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r10sjnxr_38_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1659689413] ={e5.__r10sjnxr_38,4,2040021415}e5[110968460] ={e5.__r1wpqb83_c,4,4128395418}e5.__rzggkls_3a_g ={[2068941813]=fe,[2068941812]=YK,[2068941815]=N8}e5.__rzggkls_3a =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__rzggkls_3a_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1198719299] ={e5.__rzggkls_3a,4,2068941813}e5.__r14wlobu_3b =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 if _g<1 then _disp =fe else if _g<2 then _disp =YK else _disp =N8 end end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1264545678] ={e5.__r14wlobu_3b,4,1590139540}e5.__rzvrb0t_3c =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g==0 then _disp =fe elseif _g==1 then _disp =YK elseif _g==2 then _disp =N8 else uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[4066649088] ={e5.__rzvrb0t_3c,4,669986798}e5.__r1hknqaa_3d =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g<1 then _disp =fe else if _g<2 then _disp =YK else _disp =N8 end end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[256622555] ={e5.__r1hknqaa_3d,4,2997274748}e5[1406973383] ={e5.__rqxo5is_20,4,1995107671}e5.__r1hcfmvk_3f_g ={[2289329524]=fe,[2289329525]=YK,[2289329526]=N8}e5.__r1hcfmvk_3f =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r1hcfmvk_3f_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2114718505] ={e5.__r1hcfmvk_3f,4,2289329524}e5[170900761] ={e5.__r17gccsd_36,4,3765952374}e5.__ro8al31_3h_g ={[2432675777]=fe,[2432675776]=YK,[2432675779]=N8}e5.__ro8al31_3h =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 _disp =e5.__ro8al31_3h_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3989604368] ={e5.__ro8al31_3h,4,2432675777}e5.__r1gulw6f_3i_g ={[3430575013]=fe,[3430575012]=YK,[3430575015]=N8}e5.__r1gulw6f_3i =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r1gulw6f_3i_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1727516293] ={e5.__r1gulw6f_3i,4,3430575013}e5.__rok5mkg_3j_g ={[4019947445]=fe,[4019947444]=YK,[4019947447]=N8}e5.__rok5mkg_3j =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 _disp =e5.__rok5mkg_3j_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2464723047] ={e5.__rok5mkg_3j,4,4019947445}e5[1344458355] ={e5.__rii241m_37,4,2621944715}e5[41578045] ={e5.__r14wlobu_3b,4,1933931576}e5.__r1b2jaae_3m_g ={[1227184066]=fe,[1227184067]=YK,[1227184064]=N8}e5.__r1b2jaae_3m =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r1b2jaae_3m_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[88466996] ={e5.__r1b2jaae_3m,4,1227184066}e5.__rs1xlxe_3n_g ={[320592398]=fe,[320592399]=YK,[320592396]=N8}e5.__rs1xlxe_3n =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__rs1xlxe_3n_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1741919081] ={e5.__rs1xlxe_3n,4,320592398}e5.__r1arnq4u_3o_g ={[1232845007]=fe,[1232845006]=YK,[1232845005]=N8}e5.__r1arnq4u_3o =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 _disp =e5.__r1arnq4u_3o_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2889971408] ={e5.__r1arnq4u_3o,4,1232845007}e5.__r7jyniu_3p_g ={[934286110]=fe,[934286111]=YK,[934286108]=N8}e5.__r7jyniu_3p =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r7jyniu_3p_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[379044984] ={e5.__r7jyniu_3p,4,934286110}e5.__rwqyidz_3q =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 if _g==0 then _disp =fe elseif _g==1 then _disp =YK elseif _g==2 then _disp =N8 else uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3897898171] ={e5.__rwqyidz_3q,4,3533272180}e5.__r8yfpqy_3r =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g<1 then _disp =fe else if _g<2 then _disp =YK else _disp =N8 end end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[400798676] ={e5.__r8yfpqy_3r,4,1998125421}e5.__r1tg41rj_3s =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 if _g<1 then _disp =fe else if _g<2 then _disp =YK else _disp =N8 end end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1621584159] ={e5.__r1tg41rj_3s,4,3390300367}e5[2753775651] ={e5.__r8yfpqy_3r,4,3633105311}e5.__rr632vt_3u_g ={[4002804721]=fe,[4002804720]=YK,[4002804723]=N8}e5.__rr632vt_3u =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 _disp =e5.__rr632vt_3u_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2953160059] ={e5.__rr632vt_3u,4,4002804721}e5[14300673] ={e5.__r1g5sgix_4,1,1113060774}e5.__r1g6eaxf_3w_g ={[233148503]=di,[233148502]=Np6,[233148501]=ao5}e5.__r1g6eaxf_3w =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1g6eaxf_3w_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2074456835] ={e5.__r1g6eaxf_3w,1,233148503}e5.__r1bqvcxf_3x_g ={[2116359650]=di,[2116359651]=Np6,[2116359648]=ao5}e5.__r1bqvcxf_3x =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1bqvcxf_3x_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1362960084] ={e5.__r1bqvcxf_3x,1,2116359650}e5[2618062617] ={e5.__r70qe9o_6,1,267965211}e5[1149811266] ={e5.__rkm985z_1k,1,897436872}e5[2579647324] ={e5.__rs8ra7c_b,1,3214781334}e5[2591636514] ={e5.__r1069h15_17,1,536715407}e5[1239817426] ={e5.__rcmaxm8_0,1,297525460}e5[954507667] ={e5.__r1pgh8dg_7,1,2604720146}e5[1008546291] ={e5.__rkm985z_1k,1,246998786}e5[2231670396] ={e5.__rcmaxm8_0,1,4101789590}e5[620920940] ={e5.__rpz9rbm_1l,1,1660269208}e5[374793458] ={e5.__r1g5sgix_4,1,2692620055}e5.__r1fz4ula_48_g ={[3042619075]=di,[3042619074]=Np6,[3042619073]=ao5}e5.__r1fz4ula_48 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__r1fz4ula_48_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1641056908] ={e5.__r1fz4ula_48,1,3042619075}e5[2015934133] ={e5.__rkm985z_1k,1,2533480244}e5.__rx3z0qd_4a_g ={[2239662800]=di,[2239662801]=Np6,[2239662802]=ao5}e5.__rx3z0qd_4a =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__rx3z0qd_4a_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1764541645] ={e5.__rx3z0qd_4a,1,2239662800}e5.__r15xt686_4b_g ={[279090998]=di,[279090999]=Np6,[279090996]=ao5}e5.__r15xt686_4b =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__r15xt686_4b_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1502666177] ={e5.__r15xt686_4b,1,279090998}e5.__r1oncn6k_4c_g ={[1048209718]=di,[1048209719]=Np6,[1048209716]=ao5}e5.__r1oncn6k_4c =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1oncn6k_4c_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2232826126] ={e5.__r1oncn6k_4c,1,1048209718}e5[2606547129] ={e5.__r1pabvm6_9,1,3044375896}e5[3243683870] ={e5.__rpz9rbm_1l,1,3771137655}e5[4021261584] ={e5.__r17800rt_2,1,2459316897}e5[2502971424] ={e5.__rpz9rbm_1l,1,438052076}e5[438874122] ={e5.__r19swwy9_a,1,3109296504}e5.__r1jcfgmc_4i_g ={[2491849145]=di,[2491849144]=Np6,[2491849147]=ao5}e5.__r1jcfgmc_4i =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__r1jcfgmc_4i_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[895304127] ={e5.__r1jcfgmc_4i,1,2491849145}e5[4140148945] ={e5.__r1tkrf0i_2e,1,3229004753}e5[2782183556] ={e5.__r1rxygf1_1,1,2614753949}e5[3903404124] ={e5.__r1wie87_e,5,299616332}e5.__rj5gx8h_4m =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms3(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_0(_lo,_hi,_ss)_ns =_ts3(_ss,_lo,_hi,_q2,_q3,_q4,_q1,_q0)local _g=fO[106](_q2,229)%3 if _g<1 then _disp =UO else if _g<2 then _disp =oa5 else _disp =AL end end if _g==1or _g==2 then _disp =_disp[_q2]else _disp =_disp(_q2)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q3;_w[5] =_q4;_w[6] =_q1;_w[7] =_q0;_w[9] =_ns;_w[10] =xO[_q2]or 0 _out,_npc =_disp(_q3,_q4,_q1,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1778061004] ={e5.__rj5gx8h_4m,3,2716472762}e5.__r1wfr1y5_4n_g ={[2517326443]=di,[2517326442]=Np6,[2517326441]=ao5}e5.__r1wfr1y5_4n =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1wfr1y5_4n_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2784826098] ={e5.__r1wfr1y5_4n,1,2517326443}e5.__r23uhwm_4o_g ={[3894247875]=fe,[3894247874]=YK,[3894247873]=N8}e5.__r23uhwm_4o =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r23uhwm_4o_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3557994535] ={e5.__r23uhwm_4o,4,3894247875}e5.__r1sc4n8_4p_g ={[1835601905]=fe,[1835601904]=YK,[1835601907]=N8}e5.__r1sc4n8_4p =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r1sc4n8_4p_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2350239176] ={e5.__r1sc4n8_4p,4,1835601905}e5.__r1a44oik_4q_g ={[1072282318]=fe,[1072282319]=YK,[1072282316]=N8}e5.__r1a44oik_4q =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 _disp =e5.__r1a44oik_4q_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1531476551] ={e5.__r1a44oik_4q,4,1072282318}e5.__r1a7a3pl_4r_g ={[2612102701]=fe,[2612102700]=YK,[2612102703]=N8}e5.__r1a7a3pl_4r =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r1a7a3pl_4r_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1199226901] ={e5.__r1a7a3pl_4r,4,2612102701}e5[816548685] ={e5.__r14wlobu_3b,4,570301357}e5.__rf1w58x_4t =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 if _g<1 then _disp =fe else if _g<2 then _disp =YK else _disp =N8 end end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1438463298] ={e5.__rf1w58x_4t,4,1103537525}e5[1992737665] ={e5.__rqxo5is_20,4,1584187941}e5.__r1mcf2w2_4v =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g<1 then _disp =fe else if _g<2 then _disp =YK else _disp =N8 end end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2434150720] ={e5.__r1mcf2w2_4v,4,1112002960}e5[3966744195] ={e5.__rqxo5is_20,4,952695750}e5.__r1j8huzg_4x_g ={[2204446880]=fe,[2204446881]=YK,[2204446882]=N8}e5.__r1j8huzg_4x =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r1j8huzg_4x_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1272667286] ={e5.__r1j8huzg_4x,4,2204446880}e5[3133815027] ={e5.__rf1w58x_4t,4,3508600878}e5[4210145100] ={e5.__rii241m_37,4,1763921990}e5.__rf95nqa_50_g ={[1903464133]=fe,[1903464132]=YK,[1903464135]=N8}e5.__rf95nqa_50 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__rf95nqa_50_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3385331687] ={e5.__rf95nqa_50,4,1903464133}e5.__r13nbvg3_51_g ={[2844108370]=fe,[2844108371]=YK,[2844108368]=N8}e5.__r13nbvg3_51 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r13nbvg3_51_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2709302994] ={e5.__r13nbvg3_51,4,2844108370}e5[3581650083] ={e5.__r1mcf2w2_4v,4,1975852828}e5[3520953203] ={e5.__r1tg41rj_3s,4,1813859626}e5.__r1ujyf4h_54 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms0(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_2(_lo,_hi,_ss)local _g=fO[106](_q0,25)%3 if _g<1 then _disp =q5 else if _g<2 then _disp =dO else _disp =lO end end _ns =_ts0(_ss,_lo,_hi,_q0,_q3,_q2,_q1,_q4)_disp =_disp(_q0)if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q3;_w[5] =_q2;_w[6] =_q1;_w[7] =_q4;_w[9] =_ns;_w[10] =GO[_q0]or 0 _out,_npc =_disp(_q3,_q2,_q1,_q4,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[314391008] ={e5.__r1ujyf4h_54,0,3653226404}e5.__r92ksdh_55 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms0(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_2(_lo,_hi,_ss)_ns =_ts0(_ss,_lo,_hi,_q0,_q3,_q2,_q1,_q4)local _g=fO[106](_q0,25)%3 if _g<1 then _disp =q5 else if _g<2 then _disp =dO else _disp =lO end end _disp =_disp(_q0)if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q3;_w[5] =_q2;_w[6] =_q1;_w[7] =_q4;_w[9] =_ns;_w[10] =GO[_q0]or 0 _out,_npc =_disp(_q3,_q2,_q1,_q4,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1104915865] ={e5.__r92ksdh_55,0,2586602137}e5.__r1myc2eg_56_g ={[1812093134]=fe,[1812093135]=YK,[1812093132]=N8}e5.__r1myc2eg_56 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r1myc2eg_56_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[569879762] ={e5.__r1myc2eg_56,4,1812093134}e5[524133785] ={e5.__r1tg41rj_3s,4,169681729}e5.__reobjfs_58 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g==0 then _disp =fe elseif _g==1 then _disp =YK elseif _g==2 then _disp =N8 else uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[11813943] ={e5.__reobjfs_58,4,3515507045}e5.__rscy45z_59_g ={[4190557630]=fe,[4190557631]=YK,[4190557628]=N8}e5.__rscy45z_59 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__rscy45z_59_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1919491430] ={e5.__rscy45z_59,4,4190557630}e5.__r19bd7xr_5a =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g<1 then _disp =fe else if _g<2 then _disp =YK else _disp =N8 end end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2175788541] ={e5.__r19bd7xr_5a,4,1465314001}e5[3887784623] ={e5.__r1tg41rj_3s,4,867266416}e5[2534988556] ={e5.__rf1w58x_4t,4,1982824076}e5.__r1awysju_5d_g ={[2257693529]=FU,[2257693528]=wy,[2257693531]=vy4}e5.__r1awysju_5d =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms2(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)_ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 _disp =e5.__r1awysju_5d_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2883247369] ={e5.__r1awysju_5d,2,2257693529}e5[3572456487] ={e5.__rsqcp2p_h,6,20054306}e5.__r1dr3aej_5f_g ={[2727358705]=di,[2727358704]=Np6,[2727358707]=ao5}e5.__r1dr3aej_5f =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1dr3aej_5f_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[243294859] ={e5.__r1dr3aej_5f,1,2727358705}e5.__r1nzqemx_5g_g ={[3957578107]=FU,[3957578106]=wy,[3957578105]=vy4}e5.__r1nzqemx_5g =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,229728453))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,16),fO[87](_ss,16)),1059741899))local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 _disp =e5.__r1nzqemx_5g_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo,fO[121](fO[215](_hi,29),fO[87](_hi,3)),_q1*11687);_x =fO[106](_x,_q2*2599,_q4*23429,_q0*54901,_q3*28507);_x =fO[95](_x*11687+3123651450,4294967295);return fO[106](_x,fO[87](_x,12));end end)()if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[669380654] ={e5.__r1nzqemx_5g,2,3957578107}e5.__rwmvg67_5h =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms2(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 if _g==0 then _disp =FU elseif _g==1 then _disp =wy elseif _g==2 then _disp =vy4 else uC()end _ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1533358760] ={e5.__rwmvg67_5h,2,1909934077}e5.__rnmg5k6_5i =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g<1 then _disp =fe else if _g<2 then _disp =YK else _disp =N8 end end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3787638465] ={e5.__rnmg5k6_5i,4,2599610088}e5[1746212505] ={e5.__r14wlobu_3b,4,3965211391}e5.__r19pxgna_5k_g ={[2879698630]=fe,[2879698631]=YK,[2879698628]=N8}e5.__r19pxgna_5k =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r19pxgna_5k_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3807113305] ={e5.__r19pxgna_5k,4,2879698630}e5[3564295279] ={e5.__r14wlobu_3b,4,3584251161}e5.__r1urwzat_5m_g ={[1763753025]=fe,[1763753024]=YK,[1763753027]=N8}e5.__r1urwzat_5m =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r1urwzat_5m_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2927293021] ={e5.__r1urwzat_5m,4,1763753025}e5[3257522806] ={e5.__r19bd7xr_5a,4,4013908177}e5.__rtye28r_5o_g ={[2480573945]=fe,[2480573944]=YK,[2480573947]=N8}e5.__rtye28r_5o =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms4(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__rtye28r_5o_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3232716832] ={e5.__rtye28r_5o,4,2480573945}e5[3609035268] ={e5.__rf1w58x_4t,4,4151710230}e5[2816396698] ={e5.__rnmg5k6_5i,4,3445295159}e5.__r1v3m43l_5r =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)_ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)local _g=fO[106](_q4,80)%3 if _g==0 then _disp =fe elseif _g==1 then _disp =YK elseif _g==2 then _disp =N8 else uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3469573015] ={e5.__r1v3m43l_5r,4,3745627953}e5.__r48qyio_5s_g ={[3718283935]=fe,[3718283934]=YK,[3718283933]=N8}e5.__r48qyio_5s =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3273929711);local _hm=fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 _disp =e5.__r48qyio_5s_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _p0=fO[106](_ss,_lo);local _p1=fO[106](fO[121](fO[215](_hi,16),fO[87](_hi,16)),_q4*43359);local _p2=fO[106](_q1*6823,_q3*5701);local _p3=fO[106](_q2*39651,_q0*97);local _x=fO[106](fO[106](_p0,_p1),fO[106](_p2,_p3));_x =fO[95](_x*43359+3311971965,4294967295);return fO[106](_x,fO[87](_x,20))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1054551867] ={e5.__r48qyio_5s,4,3718283935}e5[1995657284] ={e5.__r8yfpqy_3r,4,1251497675}e5[3154806867] ={e5.__reobjfs_58,4,1585377268}e5.__r16dkgw_5v =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3273929711))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,13),fO[87](_ss,19)),2441217571))local _q0,_q1,_q2,_q3,_q4=xx_1(_lo,_hi,_ss)local _g=fO[106](_q4,80)%3 if _g==0 then _disp =fe elseif _g==1 then _disp =YK elseif _g==2 then _disp =N8 else uC()end _ns =_ts4(_ss,_lo,_hi,_q4,_q1,_q3,_q2,_q0)if _g==0or _g==1or _g==2 then _disp =_disp[_q4]else _disp =_disp(_q4)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q1;_w[5] =_q3;_w[6] =_q2;_w[7] =_q0;_w[9] =_ns;_w[10] =DM5[_q4]or 0 _out,_npc =_disp(_q1,_q3,_q2,_q0,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[935442724] ={e5.__r16dkgw_5v,4,1634826527}e5[4256973674] ={e5.__r17gccsd_36,4,848473730}e5[361591622] ={e5.__r1hknqaa_3d,4,1297637829}e5.__r13dgqf3_5y_g ={[1069800255]=di,[1069800254]=Np6,[1069800253]=ao5}e5.__r13dgqf3_5y =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r13dgqf3_5y_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[4082737617] ={e5.__r13dgqf3_5y,1,1069800255}e5[1085309658] ={e5.__rkivqyt_29,1,3614415794}e5.__rfv0sk1_60_g ={[4061054401]=di,[4061054400]=Np6,[4061054403]=ao5}e5.__rfv0sk1_60 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__rfv0sk1_60_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1096976547] ={e5.__rfv0sk1_60,1,4061054401}e5.__rpcyfzk_61_g ={[3326938890]=di,[3326938891]=Np6,[3326938888]=ao5}e5.__rpcyfzk_61 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__rpcyfzk_61_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[755252818] ={e5.__rpcyfzk_61,1,3326938890}e5[2091137146] ={e5.__rbwl4i8_3,1,1354724579}e5[3309840530] ={e5.__rs8ra7c_b,1,2242890152}e5[1116106872] ={e5.__rpz9rbm_1l,1,20515392}e5[2639941950] ={e5.__rba5e19_w,1,1692154722}e5.__r1hym6a5_66_g ={[2436703512]=di,[2436703513]=Np6,[2436703514]=ao5}e5.__r1hym6a5_66 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1hym6a5_66_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3611558190] ={e5.__r1hym6a5_66,1,2436703512}e5[1813291083] ={e5.__r1jvo8s8_1d,1,122626962}e5[1978176769] ={e5.__r1g5sgix_4,1,902253172}e5.__r11qtju5_69_g ={[1122808876]=di,[1122808877]=Np6,[1122808878]=ao5}e5.__r11qtju5_69 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r11qtju5_69_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3297280031] ={e5.__r11qtju5_69,1,1122808876}e5[3243893660] ={e5.__r1pgh8dg_7,1,3874408230}e5[2873958680] ={e5.__r1tkrf0i_2e,1,2040438451}e5[2791186636] ={e5.__rwzsa35_8,1,1760118087}e5[3230633803] ={e5.__r1pgh8dg_7,1,2190581308}e5.__r1d2nm5s_6e_g ={[1814314031]=di,[1814314030]=Np6,[1814314029]=ao5}e5.__r1d2nm5s_6e =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1d2nm5s_6e_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3372536581] ={e5.__r1d2nm5s_6e,1,1814314031}e5[2511035142] ={e5.__rba5e19_w,1,4217765718}e5[664510597] ={e5.__rcmaxm8_0,1,2399500222}e5.__rmfca2o_6h_g ={[2087930854]=di,[2087930855]=Np6,[2087930852]=ao5}e5.__rmfca2o_6h =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__rmfca2o_6h_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[515168675] ={e5.__rmfca2o_6h,1,2087930854}e5.__r1h1wfyw_6i_g ={[1446244834]=di,[1446244835]=Np6,[1446244832]=ao5}e5.__r1h1wfyw_6i =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1h1wfyw_6i_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1654708426] ={e5.__r1h1wfyw_6i,1,1446244834}e5[2574480454] ={e5.__rcmaxm8_0,1,3136723693}e5.__r13yrrug_6k_g ={[1404843371]=di,[1404843370]=Np6,[1404843369]=ao5}e5.__r13yrrug_6k =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r13yrrug_6k_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[951286892] ={e5.__r13yrrug_6k,1,1404843371}e5.__rmrm30_6l_g ={[2631557716]=di,[2631557717]=Np6,[2631557718]=ao5}e5.__rmrm30_6l =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__rmrm30_6l_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2816276209] ={e5.__rmrm30_6l,1,2631557716}e5.__rrhx8wg_6m_g ={[1350430076]=di,[1350430077]=Np6,[1350430078]=ao5}e5.__rrhx8wg_6m =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__rrhx8wg_6m_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1164898169] ={e5.__rrhx8wg_6m,1,1350430076}e5[1464357461] ={e5.__rbwl4i8_3,1,3801813858}e5[554526127] ={e5.__r1rxygf1_1,1,39869470}e5.__rh119r_6p_g ={[2485702192]=di,[2485702193]=Np6,[2485702194]=ao5}e5.__rh119r_6p =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms1(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__rh119r_6p_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3163236511] ={e5.__rh119r_6p,1,2485702192}e5.__reiwbxg_6q_g ={[850102279]=di,[850102278]=Np6,[850102277]=ao5}e5.__reiwbxg_6q =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__reiwbxg_6q_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[649035704] ={e5.__reiwbxg_6q,1,850102279}e5.__r1h3wwwy_6r_g ={[627188625]=di,[627188624]=Np6,[627188627]=ao5}e5.__r1h3wwwy_6r =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1h3wwwy_6r_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2814166415] ={e5.__r1h3wwwy_6r,1,627188625}e5[818507069] ={e5.__r1pabvm6_9,1,688435331}e5[2067921495] ={e5.__r19swwy9_a,1,2639950294}e5[1797483726] ={e5.__r1pgh8dg_7,1,2442676943}e5[187721410] ={e5.__rcmaxm8_0,1,4168205858}e5[1833757416] ={e5.__rwzsa35_8,1,3396183160}e5.__r15wnjg3_6x_g ={[996221611]=di,[996221610]=Np6,[996221609]=ao5}e5.__r15wnjg3_6x =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,3461045215);local _hm=fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)_ns =_ts1(_ss,_lo,_hi,_q0,_q4,_q3,_q2,_q1)local _g=fO[106](_q0,15)%3 _disp =e5.__r15wnjg3_6x_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[1250663619] ={e5.__r15wnjg3_6x,1,996221611}e5[4238070608] ={e5.__r1pabvm6_9,1,4178247325}e5[4232416032] ={e5.__r17800rt_2,1,3452016987}e5.__r1k1g666_70_g ={[3434877551]=di,[3434877550]=Np6,[3434877549]=ao5}e5.__r1k1g666_70 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,3461045215))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,4),fO[87](_ss,28)),3477743689))local _q0,_q1,_q2,_q3,_q4=xx_3(_lo,_hi,_ss)local _g=fO[106](_q0,15)%3 _disp =e5.__r1k1g666_70_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =(function()local _x=fO[106](_ss,_lo);_x =fO[106](_x,fO[121](fO[215](_hi,27),fO[87](_hi,5)));_x =fO[106](_x,_q0*55689);_x =fO[106](_x,_q4*27075);_x =fO[106](_x,_q3*50229);_x =fO[106](_x,_q2*3805);_x =fO[106](_x,_q1*25195);_x =fO[95](_x*55689+1334142386,4294967295);return fO[106](_x,fO[87](_x,6))end)()if _g==0or _g==1or _g==2 then _disp =_disp[_q0]else _disp =_disp(_q0)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q4;_w[5] =_q3;_w[6] =_q2;_w[7] =_q1;_w[9] =_ns;_w[10] =BD9[_q0]or 0 _out,_npc =_disp(_q4,_q3,_q2,_q1,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3287843971] ={e5.__r1k1g666_70,1,3434877551}e5.__r19pj78n_71 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms2(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)_ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 if _g<1 then _disp =FU else if _g<2 then _disp =wy else _disp =vy4 end end if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2123474945] ={e5.__r19pj78n_71,2,2252782465}e5.__rhlbkzf_72_g ={[1371697658]=FU,[1371697659]=wy,[1371697656]=vy4}e5.__rhlbkzf_72 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,229728453))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,16),fO[87](_ss,16)),1059741899))local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)_ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 _disp =e5.__rhlbkzf_72_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3586638750] ={e5.__rhlbkzf_72,2,1371697658}e5.__r9d400j_73_g ={[2533003005]=FU,[2533003004]=wy,[2533003007]=vy4}e5.__r9d400j_73 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms2(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)_ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 _disp =e5.__r9d400j_73_g[fO[106](_g,_rk)];if _disp==nil then uC()end if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2500268879] ={e5.__r9d400j_73,2,2533003005}e5.__rqpmyea_74 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,229728453))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,16),fO[87](_ss,16)),1059741899))local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 if _g<1 then _disp =FU else if _g<2 then _disp =wy else _disp =vy4 end end _ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2645013174] ={e5.__rqpmyea_74,2,1005821512}e5.__rxfq77m_75_g ={[235933166]=FU,[235933167]=wy,[235933164]=vy4}e5.__rxfq77m_75 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,229728453);local _hm=fO[106](fO[121](fO[215](_ss,16),fO[87](_ss,16)),1059741899)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 _disp =e5.__rxfq77m_75_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2552641818] ={e5.__rxfq77m_75,2,235933166}e5.__ra8cw1n_76 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm=fO[106](_ss,229728453);local _hm=fO[106](fO[121](fO[215](_ss,16),fO[87](_ss,16)),1059741899)local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)_ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 if _g==0 then _disp =FU elseif _g==1 then _disp =wy elseif _g==2 then _disp =vy4 else uC()end if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3586493121] ={e5.__ra8cw1n_76,2,2120428230}e5.__r1acsmk1_77 =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lo=fO[106](_mw0,fO[106](_ss,229728453))local _hi=fO[106](_mw1,fO[106](fO[121](fO[215](_ss,16),fO[87](_ss,16)),1059741899))local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)_ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 if _g==0 then _disp =FU elseif _g==1 then _disp =wy elseif _g==2 then _disp =vy4 else uC()end if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2550504739] ={e5.__r1acsmk1_77,2,848708048}e5[1994425596] ={e5.__ra8cw1n_76,2,1410699761}e5[2382916070] ={e5.__r1acsmk1_77,2,1668225101}e5.__rvv7iur_7a_g ={[990502089]=FU,[990502088]=wy,[990502091]=vy4}e5.__rvv7iur_7a =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms2(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 _disp =e5.__rvv7iur_7a_g[fO[106](_g,_rk)];if _disp==nil then uC()end _ns =_ts2(_ss,_lo,_hi,_q1,_q2,_q4,_q0,_q3)if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[3592864224] ={e5.__rvv7iur_7a,2,990502089}e5.__r8woe7n_7b =function(_w,_ss,o5,Po2,f2,dl,Ls,_rk)local _disp=_w[3]local _out,_npc,_ns if _disp~=nil then _out,_npc =_disp(_w[4],_w[5],_w[6],_w[7],o5,Po2,f2,dl,Ls)_ns =_w[9]else local _mw0,_mw1=_w[1],_w[2]local _lm,_hm=_ms2(_ss);local _lo=fO[106](_mw0,_lm);local _hi=fO[106](_mw1,_hm)local _q0,_q1,_q2,_q3,_q4=xx_4(_lo,_hi,_ss)local _g=fO[95](fO[106](_q1,183)*199+36908,4294967295)%3 if _g==0 then _disp =FU elseif _g==1 then _disp =wy elseif _g==2 then _disp =vy4 else uC()end _ns =(function()local _x=fO[106](_ss,_lo,fO[121](fO[215](_hi,29),fO[87](_hi,3)),_q1*11687);_x =fO[106](_x,_q2*2599,_q4*23429,_q0*54901,_q3*28507);_x =fO[95](_x*11687+3123651450,4294967295);return fO[106](_x,fO[87](_x,12));end end)()if _g==2 then _disp =_disp[_q1]else _disp =_disp(_q1)end if _disp==nil then uC()end _w[3] =_disp;_w[4] =_q2;_w[5] =_q4;_w[6] =_q0;_w[7] =_q3;_w[9] =_ns;_w[10] =D9[_q1]or 0 _out,_npc =_disp(_q2,_q4,_q0,_q3,o5,Po2,f2,dl,Ls)end return _out,_npc,_ns end e5[2806307687] ={e5.__r8woe7n_7b,2,1715456730}local tV={}local EO=0 local r8={}local gO1=0 local h1=nil local C2=nil h1 =function(_ar,_a,_b,_c,K7,_npc,o5,Po2,f2,dl,ZO,E4,rO)local fR=(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])if K7[17]==fR then if K7[18]==1 then if K7[7]==1 then if _ar==2 then o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]),(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]),(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]))end end;if rO then f2[_a] =nil end elseif _ar==1 then o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]))end end;if rO then f2[_a] =nil end elseif _ar==3 then o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]),(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]),(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]),(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]),(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]))end end;if rO then f2[_a] =nil end elseif _ar==0 then o5[_a] =fR();if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR()end end;if rO then f2[_a] =nil end elseif _ar==4 then o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]),(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]),(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]),(if E4and Po2[_c+3]~=nil then Po2[_c+3][1]else o5[_c+3]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]),(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]),(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]),(if E4and Po2[_c+3]~=nil then Po2[_c+3][1]else o5[_c+3]))end end;if rO then f2[_a] =nil end else local _spec=K7[21];if fO[202](_spec)~='table'then _spec =dl[1][127][_c+1];K7[21] =_spec end;local _sn=fO[202](_spec)=='table'and#_specor 0 if _sn==2and not _spec[1][2] and not _spec[2][2] then o5[_a] =fR((if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]),(if E4 and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]),(if E4 and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]])) end end;if rO then f2[_a] =nil end elseif _sn==1and not _spec[1][2] then o5[_a] =fR((if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]])) end end;if rO then f2[_a] =nil end elseif _sn==0 then o5[_a] =fR();if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR()end end;if rO then f2[_a] =nil end else local Eq;if gO1>0 then Eq =r8[gO1];gO1 =gO1-1 else Eq ={}end;if _ar==2 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq.n =2 elseif _ar==1 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq.n =1 elseif _ar==3 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq.n =3 elseif _ar==0 then Eq.n =0 elseif _ar==4 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq[4] =(if E4and Po2[_c+3]~=nil then Po2[_c+3][1]else  o5[_c+3]);Eq.n =4 else local _spec=K7[21];if fO[202](_spec)~='table'then _spec =dl[1][127][_c+1];K7[21] =_spec end;local _sn=fO[202](_spec)=='table'and#_spec or 0 if _sn==2 and not _spec[1][2] and not _spec[2][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq.n =2 elseif _sn==1and not _spec[1][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq.n =1 elseif _sn==3and not _spec[1][2] and not _spec[2][2] and not _spec[3][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else  o5[_spec[3][1]]);Eq.n =3 elseif _sn==4and not _spec[1][2] and not _spec[2][2] and not _spec[3][2] and not _spec[4][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else  o5[_spec[3][1]]);Eq[4] =(if E4and Po2[_spec[4][1]]~=nil then Po2[_spec[4][1]][1]else  o5[_spec[4][1]]);Eq.n =4 elseif _sn==0 then Eq.n =0 else local _an=0;for _si=1,_sn do local _sr=_spec[_si];if _sr[2]then local _mv=f2[_sr[1]];if fO[202](_mv)=='table'then local _mn=_mv.n;if fO[202](_mn)~='number' then _mn =fO[202](_mv)=='table'and #_mv or 0 end;for _mi=1,_mn do _an =_an+1;Eq[_an] =_mv[_mi]end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]])end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]]) end end;Eq.n =_an end end;o5[_a] =fR(fO[86](Eq,1,Eq.n));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR(fO[86](Eq,1,Eq.n))end end;if rO then f2[_a] =nil end;gO1 =gO1+1;r8[gO1] =Eq end end else local Eq;if gO1>0 then Eq =r8[gO1];gO1 =gO1-1 else Eq ={}end;if _ar==2 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq.n =2 elseif _ar==1 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq.n =1 elseif _ar==3 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq.n =3 elseif _ar==0 then Eq.n =0 elseif _ar==4 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq[4] =(if E4and Po2[_c+3]~=nil then Po2[_c+3][1]else o5[_c+3]);Eq.n =4 else local _spec=K7[21];if fO[202](_spec)~='table'then _spec =dl[1][127][_c+1];K7[21] =_spec end;local _sn=fO[202](_spec)=='table'and#_specor 0 if _sn==2 and not _spec[1][2] and not _spec[2][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq.n =2 elseif _sn==1and not _spec[1][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq.n =1 elseif _sn==3and not _spec[1][2] and not _spec[2][2] and not _spec[3][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else  o5[_spec[3][1]]);Eq.n =3 elseif _sn==4and not _spec[1][2] and not _spec[2][2] and not _spec[3][2] and not _spec[4][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else  o5[_spec[3][1]]);Eq[4] =(if E4and Po2[_spec[4][1]]~=nil then Po2[_spec[4][1]][1]else  o5[_spec[4][1]]);Eq.n =4 elseif _sn==0 then Eq.n =0 else local _an=0;for _si=1,_sn do local _sr=_spec[_si];if _sr[2]then local _mv=f2[_sr[1]];if fO[202](_mv)=='table'then local _mn=_mv.n;if fO[202](_mn)~='number' then _mn =fO[202](_mv)=='table'and #_mv or 0 end;for _mi=1,_mn do _an =_an+1;Eq[_an] =_mv[_mi]end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]])end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]]) end end;Eq.n =_an end end;local YV0=fO[186](fR(fO[86](Eq,1,Eq.n)));gO1 =gO1+1;r8[gO1] =Eq;if K7[7]==1 then o5[_a] =YV0[1];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =YV0[1]end end;if rO then f2[_a] =nil end elseif K7[7]==0 then o5[_a] =YV0[1];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =YV0[1]end end;if rO then f2[_a] =nil end;f2[_a] =YV0 else for _i=0,K7[7]-1 do local _ws=_a+_i;o5[_ws] =YV0[_i+1];if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =YV0[_i+1]end end;if rO then f2[_ws] =nil end end end end end elseif K7[18]==2 then local Eq;if gO1>0 then Eq =r8[gO1];gO1 =gO1-1 else Eq ={}end;if _ar==2 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq.n =2 elseif _ar==1 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq.n =1 elseif _ar==3 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq.n =3 elseif _ar==0 then Eq.n =0 elseif _ar==4 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq[4] =(if E4and Po2[_c+3]~=nil then Po2[_c+3][1]else o5[_c+3]);Eq.n =4 else local _spec=K7[21];if fO[202](_spec)~='table'then _spec =dl[1][127][_c+1];K7[21] =_spec end;local _sn=fO[202](_spec)=='table'and#_specor 0 if _sn==2and not _spec[1][2]and not _spec[2][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq.n =2 elseif _sn==1and not _spec[1][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq.n =1 elseif _sn==3and not _spec[1][2] and not _spec[2][2] and not _spec[3][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else  o5[_spec[3][1]]);Eq.n =3 elseif _sn==4and not _spec[1][2] and not _spec[2][2] and not _spec[3][2] and not _spec[4][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else  o5[_spec[3][1]]);Eq[4] =(if E4and Po2[_spec[4][1]]~=nil then Po2[_spec[4][1]][1]else  o5[_spec[4][1]]);Eq.n =4 elseif _sn==0 then Eq.n =0 else local _an=0;for _si=1,_sn do local _sr=_spec[_si];if _sr[2]then local _mv=f2[_sr[1]];if fO[202](_mv)=='table'then local _mn=_mv.n;if fO[202](_mn)~='number' then _mn =fO[202](_mv)=='table'and #_mv or 0 end;for _mi=1,_mn do _an =_an+1;Eq[_an] =_mv[_mi]end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]])end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]]) end end;Eq.n =_an end end;local _vmc=K7[19]or Pj0[fR];local YV0;YV0 =Uy7(_vmc[1],Ct[fR],Eq,_vmc[3]or ZO,_vmc[2],_vmc);gO1 =gO1+1;r8[gO1] =Eq;if K7[7]==1 then o5[_a] =YV0[1];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =YV0[1]end end;if rO then f2[_a] =nil end elseif K7[7]==0 then o5[_a] =YV0[1];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =YV0[1]end end;if rO then f2[_a] =nil end;f2[_a] =YV0 else for _i=0,K7[7]-1 do local _ws=_a+_i;o5[_ws] =YV0[_i+1];if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =YV0[_i+1]end end;if rO then f2[_ws] =nil end end end end elseif fR==fO[230]and _ar==0 then if K7[7]==1 then o5[_a] =ZO;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =ZO end end;if rO then f2[_a] =nil end elseif K7[7]==0 then local YV0={n=1,[1]=ZO};o5[_a] =ZO;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =ZO end end;if rO then f2[_a] =nil end;f2[_a] =YV0 else o5[_a] =ZO;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =ZO end end;if rO then f2[_a] =nil end;for _i=1,K7[7]-1 do local _ws=_a+_i;o5[_ws] =nil;if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =nil end end;if rO then f2[_ws] =nil end end end end else return K7[3](_a,_b,_c,K7[7],o5,Po2,f2,dl,_npc),_npc,true end else local _vmc=Pj0[fR];K7[17] =fR;K7[19] =_vmc if fR==fO[230]and _ar==0 then K7[18] =3;if K7[7]==1 then o5[_a] =ZO;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =ZO end end;if rO then f2[_a] =nil end elseif K7[7]==0 then local YV0={n=1,[1]=ZO};o5[_a] =ZO;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =ZO end end;if rO then f2[_a] =nil end;f2[_a] =YV0 else o5[_a] =ZO;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =ZO end end;if rO then f2[_a] =nil end;for _i=1,K7[7]-1 do local _ws=_a+_i;o5[_ws] =nil;if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =nil end end;if rO then f2[_ws] =nil end end end end elseif _vmc~=nil then K7[18] =2;local Eq;if gO1>0 then Eq =r8[gO1];gO1 =gO1-1 else Eq ={}end;if _ar==2 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq.n =2 elseif _ar==1 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq.n =1 elseif _ar==3 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq.n =3 elseif _ar==0 then Eq.n =0 elseif _ar==4 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq[4] =(if E4and Po2[_c+3]~=nil then Po2[_c+3][1]else o5[_c+3]);Eq.n =4 else local _spec=K7[21];if fO[202](_spec)~='table'then _spec =dl[1][127][_c+1];K7[21] =_spec end;local _sn=fO[202](_spec)=='table'and#_specor 0 if _sn==2and not _spec[1][2]and not _spec[2][2]then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else o5[_spec[2][1]]);Eq.n =2 elseif _sn==1and not _spec[1][2]then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else o5[_spec[1][1]]);Eq.n =1 elseif _sn==3and not _spec[1][2]and not _spec[2][2]and not _spec[3][2]then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else o5[_spec[3][1]]);Eq.n =3 elseif _sn==4and not _spec[1][2]and not _spec[2][2]and not _spec[3][2]and not _spec[4][2]then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else o5[_spec[3][1]]);Eq[4] =(if E4and Po2[_spec[4][1]]~=nil then Po2[_spec[4][1]][1]else o5[_spec[4][1]]);Eq.n =4 elseif _sn==0 then Eq.n =0 else local _an=0;for _si=1,_sn do local _sr=_spec[_si];if _sr[2]then local _mv=f2[_sr[1]];if fO[202](_mv)=='table'then local _mn=_mv.n;if fO[202](_mn)~='number'then _mn =fO[202](_mv)=='table'and#_mv or 0 end;for _mi=1,_mn do _an =_an+1;Eq[_an] =_mv[_mi]end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]])end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]]) end end;Eq.n =_an end end;local _vmc=K7[19]or Pj0[fR];local YV0;YV0 =Uy7(_vmc[1],Ct[fR],Eq,_vmc[3]or ZO,_vmc[2],_vmc);gO1 =gO1+1;r8[gO1] =Eq;if K7[7]==1 then o5[_a] =YV0[1];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =YV0[1]end end;if rO then f2[_a] =nil end elseif K7[7]==0 then o5[_a] =YV0[1];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =YV0[1]end end;if rO then f2[_a] =nil end;f2[_a] =YV0 else for _i=0,K7[7]-1 do local _ws=_a+_i;o5[_ws] =YV0[_i+1];if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =YV0[_i+1]end end;if rO then f2[_ws] =nil end end end end elseif fR~=fO[230]and fR~=xwand fR~=jaand fR~=ZO.loadstringand fR~=ZO.load then K7[18] =1;if K7[7]==1 then if _ar==2 then o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]),(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]),(if E4 and Po2[_c+1]~=nil then Po2[_c+1][1]else  o5[_c+1])) end end;if rO then f2[_a] =nil end elseif _ar==1 then o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c])) end end;if rO then f2[_a] =nil end elseif _ar==3 then o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]),(if E4 and Po2[_c+1]~=nil then Po2[_c+1][1]else  o5[_c+1]),(if E4 and Po2[_c+2]~=nil then Po2[_c+2][1]else  o5[_c+2]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]),(if E4 and Po2[_c+1]~=nil then Po2[_c+1][1]else  o5[_c+1]),(if E4 and Po2[_c+2]~=nil then Po2[_c+2][1]else  o5[_c+2])) end end;if rO then f2[_a] =nil end elseif _ar==0 then o5[_a] =fR();if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR()end end;if rO then f2[_a] =nil end elseif _ar==4 then o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]),(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]),(if E4 and Po2[_c+2]~=nil then Po2[_c+2][1]else  o5[_c+2]),(if E4 and Po2[_c+3]~=nil then Po2[_c+3][1]else  o5[_c+3]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]),(if E4 and Po2[_c+1]~=nil then Po2[_c+1][1]else  o5[_c+1]),(if E4 and Po2[_c+2]~=nil then Po2[_c+2][1]else  o5[_c+2]),(if E4 and Po2[_c+3]~=nil then Po2[_c+3][1]else  o5[_c+3])) end end;if rO then f2[_a] =nil end else local _spec=K7[21];if fO[202](_spec)~='table'then _spec =dl[1][127][_c+1];K7[21] =_spec end;local _sn=fO[202](_spec)=='table'and#_spec or 0 if _sn==2 and not _spec[1][2] and not _spec[2][2] then o5[_a] =fR((if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]),(if E4 and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]),(if E4 and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]])) end end;if rO then f2[_a] =nil end elseif _sn==1and not _spec[1][2] then o5[_a] =fR((if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]])) end end;if rO then f2[_a] =nil end elseif _sn==0 then o5[_a] =fR();if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR()end end;if rO then f2[_a] =nil end else local Eq;if gO1>0 then Eq =r8[gO1];gO1 =gO1-1 else Eq ={}end;if _ar==2 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq.n =2 elseif _ar==1 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq.n =1 elseif _ar==3 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq.n =3 elseif _ar==0 then Eq.n =0 elseif _ar==4 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq[4] =(if E4and Po2[_c+3]~=nil then Po2[_c+3][1]else  o5[_c+3]);Eq.n =4 else local _spec=K7[21];if fO[202](_spec)~='table'then _spec =dl[1][127][_c+1];K7[21] =_spec end;local _sn=fO[202](_spec)=='table'and#_spec or 0 if _sn==2 and not _spec[1][2] and not _spec[2][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq.n =2 elseif _sn==1and not _spec[1][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq.n =1 elseif _sn==3and not _spec[1][2] and not _spec[2][2] and not _spec[3][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else  o5[_spec[3][1]]);Eq.n =3 elseif _sn==4and not _spec[1][2] and not _spec[2][2] and not _spec[3][2] and not _spec[4][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else  o5[_spec[3][1]]);Eq[4] =(if E4and Po2[_spec[4][1]]~=nil then Po2[_spec[4][1]][1]else  o5[_spec[4][1]]);Eq.n =4 elseif _sn==0 then Eq.n =0 else local _an=0;for _si=1,_sn do local _sr=_spec[_si];if _sr[2]then local _mv=f2[_sr[1]];if fO[202](_mv)=='table'then local _mn=_mv.n;if fO[202](_mn)~='number' then _mn =fO[202](_mv)=='table'and #_mv or 0 end;for _mi=1,_mn do _an =_an+1;Eq[_an] =_mv[_mi]end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]])end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]]) end end;Eq.n =_an end end;o5[_a] =fR(fO[86](Eq,1,Eq.n));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR(fO[86](Eq,1,Eq.n))end end;if rO then f2[_a] =nil end;gO1 =gO1+1;r8[gO1] =Eq end end else local Eq;if gO1>0 then Eq =r8[gO1];gO1 =gO1-1 else Eq ={}end;if _ar==2 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq.n =2 elseif _ar==1 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq.n =1 elseif _ar==3 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq.n =3 elseif _ar==0 then Eq.n =0 elseif _ar==4 then Eq[1] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);Eq[2] =(if E4and Po2[_c+1]~=nil then Po2[_c+1][1]else o5[_c+1]);Eq[3] =(if E4and Po2[_c+2]~=nil then Po2[_c+2][1]else o5[_c+2]);Eq[4] =(if E4and Po2[_c+3]~=nil then Po2[_c+3][1]else o5[_c+3]);Eq.n =4 else local _spec=K7[21];if fO[202](_spec)~='table'then _spec =dl[1][127][_c+1];K7[21] =_spec end;local _sn=fO[202](_spec)=='table'and#_specor 0 if _sn==2 and not _spec[1][2] and not _spec[2][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq.n =2 elseif _sn==1and not _spec[1][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq.n =1 elseif _sn==3and not _spec[1][2] and not _spec[2][2] and not _spec[3][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else  o5[_spec[3][1]]);Eq.n =3 elseif _sn==4and not _spec[1][2] and not _spec[2][2] and not _spec[3][2] and not _spec[4][2] then Eq[1] =(if E4and Po2[_spec[1][1]]~=nil then Po2[_spec[1][1]][1]else  o5[_spec[1][1]]);Eq[2] =(if E4and Po2[_spec[2][1]]~=nil then Po2[_spec[2][1]][1]else  o5[_spec[2][1]]);Eq[3] =(if E4and Po2[_spec[3][1]]~=nil then Po2[_spec[3][1]][1]else  o5[_spec[3][1]]);Eq[4] =(if E4and Po2[_spec[4][1]]~=nil then Po2[_spec[4][1]][1]else  o5[_spec[4][1]]);Eq.n =4 elseif _sn==0 then Eq.n =0 else local _an=0;for _si=1,_sn do local _sr=_spec[_si];if _sr[2]then local _mv=f2[_sr[1]];if fO[202](_mv)=='table'then local _mn=_mv.n;if fO[202](_mn)~='number' then _mn =fO[202](_mv)=='table'and #_mv or 0 end;for _mi=1,_mn do _an =_an+1;Eq[_an] =_mv[_mi]end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]])end else _an =_an+1;Eq[_an] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]]) end end;Eq.n =_an end end;local YV0=fO[186](fR(fO[86](Eq,1,Eq.n)));gO1 =gO1+1;r8[gO1] =Eq;if K7[7]==1 then o5[_a] =YV0[1];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =YV0[1]end end;if rO then f2[_a] =nil end elseif K7[7]==0 then o5[_a] =YV0[1];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =YV0[1]end end;if rO then f2[_a] =nil end;f2[_a] =YV0 else for _i=0,K7[7]-1 do local _ws=_a+_i;o5[_ws] =YV0[_i+1];if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =YV0[_i+1]end end;if rO then f2[_ws] =nil end end end end end else K7[18] =3;return K7[3](_a,_b,_c,K7[7],o5,Po2,f2,dl,_npc),_npc,true end end return nil,_npc end C2 =function(_a,K7,o5,Po2,f2,dl,E4,rO)local _rs=K7[21];if fO[202](_rs)~='table'then _rs =dl[1][198][_a+1];K7[21] =_rs end local _sn=fO[202](_rs)=='table'and#_rsor 0 if _sn==2and not _rs[1][2]and not _rs[2][2]then return{(if E4and Po2[_rs[1][1]]~=nil then Po2[_rs[1][1]][1]else o5[_rs[1][1]]),(if E4 and Po2[_rs[2][1]]~=nil then Po2[_rs[2][1]][1]else  o5[_rs[2][1]]),n=2} elseif _sn==1 and not _rs[1][2] then return {(if E4 and Po2[_rs[1][1]]~=nil then Po2[_rs[1][1]][1]else  o5[_rs[1][1]]),n=1} elseif _sn==0 then return {n=0} else local _h={};local _on=0;for _si=1,_sn do local _sr=_rs[_si];if _sr[2] then local _mv=f2[_sr[1]];if fO[202](_mv)=='table' then local _mn=_mv.n;if fO[202](_mn)~='number' then _mn =#_mv end;for _mi=1,_mn do _on =_on+1;_h[_on] =_mv[_mi]end else _on =_on+1;_h[_on] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]])end else _on =_on+1;_h[_on] =(if E4and Po2[_sr[1]]~=nil then Po2[_sr[1]][1]else o5[_sr[1]])end end;_h.n =_on;return _h end end Uy7 =function(SO,h9,Gr,ZO,qO,k5)local Ut=qO;if Ut==nil then Ut ={3409216033};if k5~=nil then k5[2] =Ut end end local J8,jP4,IQ local _atk=0 local _psCache=SO[-1]if _psCache~=niland not SO[163]then J8,jP4,IQ =_psCache[1],_psCache[2],_psCache[3]else local Cc0=3409216033 if SO[163] then local _cached=Ut[1];local _cachedProof=Ut[2] if _cached~=nil and _cached~=3409216033 and _cachedProof~=nil then Cc0 =_cached;_atk =_cachedProof else local _ingress=ZO[950750];local _ingressProof=ZO[1580194]if _ingress~=niland _ingress~=3409216033 and _ingressProof~=nil then Cc0 =_ingress;_atk =_ingressProof;Ut[1] =_ingress;Ut[2] =_ingressProof;ZO[950750] =nil;ZO[1580194] =nil else uC()end end end J8 =tO(Cc0,3448742156,SO[59],1347571540)local _cg=SO[58];if _cg~=niland _cg~=0 then jP4 =tO(tO(Cc0,3448742156,_cg-1,1347571540),1129270867,fO[95](124+(_cg-1)*153,255),_atk)else jP4 =tO(J8,1129270867,SO[226],_atk)end IQ =tO(J8,1296389185,0,0)if not SO[163]then SO[-1] ={J8,jP4,IQ}end end local QV=SO[13]or 2 local o5;local Po2;local f2;local _bn=0;local _bo=0 local dl if QV~=2and EO>0 then local _pf=tV[EO];EO =EO-1;o5 =_pf[1];Po2 =_pf[2];f2 =_pf[3];local _rn=SO[155];for _i=0,_rn-1 do o5[_i] =nil;Po2[_i] =nil;f2[_i] =nil end dl =_pf[4];if dl then dl[1] =SO;dl[2] =h9;dl[3] =Gr;dl[4] =ZO;dl[5] =Ut;dl[6] =jP4 else dl ={SO,h9,Gr,ZO,Ut,jP4}end elseif QV==2 then local _pid=SO[59];_bn =2+((_pid+20786)%3);_bo =((_pid*37997+20786)%_bn);o5 ={};for _bi=1,_bn do o5[_bi] ={}end;Po2 ={};f2 ={}dl ={SO,h9,Gr,ZO,Ut,jP4}else o5 ={};Po2 ={};f2 ={}dl ={SO,h9,Gr,ZO,Ut,jP4}end local S6=nil local yO=1 local uX3=0;local k3=0;local NP=0 local Na=0 local _rk=0 local n7 local XO;local iz;local T5;local _ready=false local E4=false;local rO=false local wf7;if not SO[163]then wf7 =SO[-3];if wf7==nil then wf7 ={};SO[-3] =wf7 end else wf7 ={}end for gO=0,SO[100]-1 do if QV==1 then local _s=SO[247]+gO;o5[_s] ={Gr[gO+1]}end elseif QV==2 then local _i=SO[247]+gO;local _k=((_i+_bo)%_bn)+1;local _s=fO[166](_i/_bn);o5[_k][_s] =Gr[gO+1] end else local _s = SO[247] + gO; o5[_s] = Gr[gO + 1]    end end end while true do local K7=wf7[yO]local Ls,yC if K7~=nil then Ls =yO+1 yC =nil if QV==0 then local _k=K7[10];local _a=K7[4];local _b=K7[5];local _c=K7[6]if _k==28 then local fR=(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])if K7[17]==fR and K7[18]==1 and K7[7]==1 then if not E4 and not rO then o5[_a] =fR(o5[_c],o5[_c+1])else o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]),(if E4 and Po2[_c+1]~=nil then Po2[_c+1][1]else  o5[_c+1]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]),(if E4 and Po2[_c+1]~=nil then Po2[_c+1][1]else  o5[_c+1])) end end;if rO then f2[_a] =nil end end else local _hf;yC,Ls,_hf =h1(2,_a,_b,_c,K7,Ls,o5,Po2,f2,dl,ZO,E4,rO);if _hf then E4 =true;rO =true elseif K7[7]==0 then rO =true end end elseif _k>=54 then if _k==56 then local fR=(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])if K7[17]==fRand K7[18]==1and K7[7]==1 then if not E4 and not rO then o5[_a] =fR(o5[_c],o5[_c+1],o5[_c+2],o5[_c+3])else o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]),(if E4 and Po2[_c+1]~=nil then Po2[_c+1][1]else  o5[_c+1]),(if E4 and Po2[_c+2]~=nil then Po2[_c+2][1]else  o5[_c+2]),(if E4 and Po2[_c+3]~=nil then Po2[_c+3][1]else  o5[_c+3]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]),(if E4 and Po2[_c+1]~=nil then Po2[_c+1][1]else  o5[_c+1]),(if E4 and Po2[_c+2]~=nil then Po2[_c+2][1]else  o5[_c+2]),(if E4 and Po2[_c+3]~=nil then Po2[_c+3][1]else  o5[_c+3])) end end;if rO then f2[_a] =nil end end else local _hf;yC,Ls,_hf =h1(4,_a,_b,_c,K7,Ls,o5,Po2,f2,dl,ZO,E4,rO);if _hf then E4 =true;rO =true elseif K7[7]==0 then rO =true end end elseif _k==55 then yC =C2(_a,K7,o5,Po2,f2,dl,E4,rO)elseif _k==54 then local _hf;yC,Ls,_hf =h1(-1,_a,_b,_c,K7,Ls,o5,Po2,f2,dl,ZO,E4,rO);if _hf then E4 =true;rO =true elseif K7[7]==0 then rO =true end elseif _k==57 then yC ={n=0}else yC,Ls =K7[3](_a,_b,_c,K7[7],o5,Po2,f2,dl,Ls);E4 =true;rO =true end elseif _k<20 then if _k==0 then yC,Ls =K7[3](_a,_b,_c,K7[7],o5,Po2,f2,dl,Ls);E4 =true;rO =true elseif _k==1 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])+(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])+(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c])end end;if rO then f2[_a] =nil end elseif _k==2 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])-(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])-(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c])end end;if rO then f2[_a] =nil end elseif _k==6 then local xf=(if E4and Po2[_a]~=nil then Po2[_a][1]else o5[_a]);local eO=(if E4and Po2[_a+1]~=nil then Po2[_a+1][1]else  o5[_a+1]);local y6=(if E4 and Po2[_a+2]~=nil then Po2[_a+2][1]else  o5[_a+2]);local _r1,_r2,_r3,_r4 local _cached=K7[11] if _cached==xf then if K7[12] then local Eq={n=2,[1]=eO,[2]=y6};local YV0=l7(xf,Eq,ZO);_r1,_r2,_r3,_r4 =YV0[1],YV0[2],YV0[3],YV0[4]else _r1,_r2,_r3,_r4 =xf(eO,y6)end else local _vmc=Pj0[xf];K7[11] =xf;K7[12] =_vmc~=nil;if _vmc~=nil then local Eq={n=2,[1]=eO,[2]=y6};local YV0=l7(xf,Eq,ZO);_r1,_r2,_r3,_r4 =YV0[1],YV0[2],YV0[3],YV0[4]else _r1,_r2,_r3,_r4 =xf(eO,y6)end end if _r1==nil then Ls =_c+1 else for _i=0,_b-1 do Po2[_a+3+_i] =nil;f2[_a+3+_i] =nil end;local _ws=_a+2;o5[_ws] =_r1;if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =_r1 end end;if rO then f2[_ws] =nil end end;o5[_a+3] =_r1;if _b>1 then o5[_a+4] =_r2 end;if _b>2 then o5[_a+5] =_r3 end;if _b>3 then o5[_a+6] =_r4 end local _tr=K7[15]if _tr then local _aa,_ab,_ac=_tr[2],_tr[3],_tr[4];local _k1=_tr[1]if _k1==1 then local _ws=_aa;o5[_ws] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else o5[_ab])+(if E4and Po2[_ac]~=nil then Po2[_ac][1]else o5[_ac]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else o5[_ab])+(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]) end end;if rO then f2[_ws] =nil end   end elseif _k1==4 then local _ws=_aa;o5[_ws] =(if E4and Po2[_aa]~=nil then Po2[_aa][1]else  o5[_aa])+(if E4 and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_aa]~=nil then Po2[_aa][1]else  o5[_aa])+(if E4 and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab]) end end;if rO then f2[_ws] =nil end   end elseif _k1==2 then local _ws=_aa;o5[_ws] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])-(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])-(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]) end end;if rO then f2[_ws] =nil end   end end _aa,_ab,_ac =_tr[6],_tr[7],_tr[8];local _k2=_tr[5]if _k2==2 then local _ws=_aa;o5[_ws] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])-(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])-(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]) end end;if rO then f2[_ws] =nil end   end elseif _k2==1 then local _ws=_aa;o5[_ws] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])+(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])+(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]) end end;if rO then f2[_ws] =nil end   end elseif _k2==4 then local _ws=_aa;o5[_ws] =(if E4and Po2[_aa]~=nil then Po2[_aa][1]else  o5[_aa])+(if E4 and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_aa]~=nil then Po2[_aa][1]else  o5[_aa])+(if E4 and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab]) end end;if rO then f2[_ws] =nil end   end end Ls =yO else local _bp=yO+1;local _n1=wf7[_bp];if _n1~=niland _n1[10]==13 then _bp =_n1[4]+1;_n1 =wf7[_bp]end;if _n1~=niland _n1[10]==13 then _bp =_n1[4]+1;_n1 =wf7[_bp]end local _n2=wf7[_bp+1];local _n3=wf7[_bp+2]if _n1~=niland _n2~=niland _n3~=niland _n3[10]==13 and _n3[4]+1==yO and (_n1[10]==1 or _n1[10]==2 or _n1[10]==4) and (_n2[10]==1 or _n2[10]==2 or _n2[10]==4) then K7[15] ={_n1[10],_n1[4],_n1[5],_n1[6],_n2[10],_n2[4],_n2[5],_n2[6]}local _aa,_ab,_ac=_n1[4],_n1[5],_n1[6];local _k1=_n1[10] if _k1==1 then    local _ws=_aa;o5[_ws] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])+(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])+(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]) end end;if rO then f2[_ws] =nil end   end elseif _k1==4 then local _ws=_aa;o5[_ws] =(if E4and Po2[_aa]~=nil then Po2[_aa][1]else  o5[_aa])+(if E4 and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_aa]~=nil then Po2[_aa][1]else  o5[_aa])+(if E4 and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab]) end end;if rO then f2[_ws] =nil end   end elseif _k1==2 then local _ws=_aa;o5[_ws] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])-(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])-(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]) end end;if rO then f2[_ws] =nil end   end end _aa,_ab,_ac =_n2[4],_n2[5],_n2[6];local _k2=_n2[10]if _k2==2 then local _ws=_aa;o5[_ws] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])-(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])-(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]) end end;if rO then f2[_ws] =nil end   end elseif _k2==1 then local _ws=_aa;o5[_ws] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])+(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab])+(if E4 and Po2[_ac]~=nil then Po2[_ac][1]else  o5[_ac]) end end;if rO then f2[_ws] =nil end   end elseif _k2==4 then local _ws=_aa;o5[_ws] =(if E4and Po2[_aa]~=nil then Po2[_aa][1]else  o5[_aa])+(if E4 and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab]);if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =(if E4and Po2[_aa]~=nil then Po2[_aa][1]else  o5[_aa])+(if E4 and Po2[_ab]~=nil then Po2[_ab][1]else  o5[_ab]) end end;if rO then f2[_ws] =nil end   end end Ls =yO end end end elseif _k==13 then Ls =_a+1 elseif _k==5 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])end end;if rO then f2[_a] =nil end elseif _k==15 then if not NO((if E4and Po2[_a]~=nil then Po2[_a][1]else o5[_a]))then Ls =_b+1 end elseif _k==16 then o5[_a] =_b;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =_b end end;if rO then f2[_a] =nil end elseif _k==7 then local cO=(if E4and Po2[_a+2]~=nil then Po2[_a+2][1]else o5[_a+2]);local oQ3=(if E4and Po2[_a]~=nil then Po2[_a][1]else o5[_a])+cO;local S3=(if E4 and Po2[_a+1]~=nil then Po2[_a+1][1]else  o5[_a+1]);if (cO>=0 and oQ3<=S3) or (cO<0 and oQ3>=S3) then Po2[_a+3] =nil;o5[_a] =oQ3;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =oQ3 end end;if rO then f2[_a] =nil end;local _ws=_a+3;o5[_ws] =oQ3;if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =oQ3 end end;if rO then f2[_ws] =nil end end;Ls =_b+1 end elseif _k==11 then local _tab=(if E4and Po2[_a]~=nil then Po2[_a][1]else o5[_a]);_tab[(if E4 and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])] =(if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c])    end elseif _k==3 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])*(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])*(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]) end end;if rO then f2[_a] =nil end elseif _k==9 then o5[_a] ={};if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] ={}end end;if rO then f2[_a] =nil end elseif _k==8 then local oQ3=(if E4and Po2[_a]~=nil then Po2[_a][1]else o5[_a]);local S3=(if E4and Po2[_a+1]~=nil then Po2[_a+1][1]else  o5[_a+1]);local cO=(if E4 and Po2[_a+2]~=nil then Po2[_a+2][1]else  o5[_a+2]);if (cO>=0 and oQ3>S3) or (cO<0 and oQ3<S3) then Ls =_b+1 else o5[_a] =oQ3;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =oQ3 end end;if rO then f2[_a] =nil end;local _ws=_a+3;o5[_ws] =oQ3;if E4 then local _wc=Po2[_ws];if _wc~=nil then _wc[1] =oQ3 end end;if rO then f2[_ws] =nil end end end elseif _k==10 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])[(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c])];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])[(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c])] end end;if rO then f2[_a] =nil end elseif _k==12 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])..(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])..(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]) end end;if rO then f2[_a] =nil end elseif _k==4 then o5[_a] =(if E4and Po2[_a]~=nil then Po2[_a][1]else o5[_a])+(if E4 and Po2[_b]~=nil then Po2[_b][1]else  o5[_b]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_a]~=nil then Po2[_a][1]else  o5[_a])+(if E4 and Po2[_b]~=nil then Po2[_b][1]else  o5[_b]) end end;if rO then f2[_a] =nil end elseif _k==14 then if NO((if E4and Po2[_a]~=nil then Po2[_a][1]else  o5[_a])) then Ls =_b+1 end elseif _k==17 then o5[_a] =nil;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =nil end end;if rO then f2[_a] =nil end elseif _k==18 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])%(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])%(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]) end end;if rO then f2[_a] =nil end elseif _k==19 then o5[_a] =#((if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =#((if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])) end end;if rO then f2[_a] =nil end else yC,Ls =K7[3](_a,_b,_c,K7[7],o5,Po2,f2,dl,Ls);E4 =true;rO =true end elseif _k<30 then if _k==22 then o5[_a] =fO[106]((if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]),(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fO[106]((if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]),(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c])) end end;if rO then f2[_a] =nil end elseif _k==20 then o5[_a] =fO[95]((if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]),(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fO[95]((if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b]),(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c])) end end;if rO then f2[_a] =nil end elseif _k==21 then o5[_a] =fO[121]((if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]),(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fO[121]((if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b]),(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c])) end end;if rO then f2[_a] =nil end elseif _k==23 then o5[_a] =fO[215]((if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]),(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fO[215]((if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b]),(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c])) end end;if rO then f2[_a] =nil end elseif _k==24 then o5[_a] =fO[87]((if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]),(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fO[87]((if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b]),(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c])) end end;if rO then f2[_a] =nil end elseif _k==27 then local fR=(if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b]) if K7[17]==fR and K7[18]==1 and K7[7]==1 then if not E4 and not rO then o5[_a] =fR(o5[_c])else o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c])) end end;if rO then f2[_a] =nil end end else local _hf;yC,Ls,_hf =h1(1,_a,_b,_c,K7,Ls,o5,Po2,f2,dl,ZO,E4,rO);if _hf then E4 =true;rO =true elseif K7[7]==0 then rO =true end end elseif _k==29 then local fR=(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])if K7[17]==fRand K7[18]==1and K7[7]==1 then if not E4 and not rO then o5[_a] =fR(o5[_c],o5[_c+1],o5[_c+2])else o5[_a] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]),(if E4 and Po2[_c+1]~=nil then Po2[_c+1][1]else  o5[_c+1]),(if E4 and Po2[_c+2]~=nil then Po2[_c+2][1]else  o5[_c+2]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR((if E4and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]),(if E4 and Po2[_c+1]~=nil then Po2[_c+1][1]else  o5[_c+1]),(if E4 and Po2[_c+2]~=nil then Po2[_c+2][1]else  o5[_c+2])) end end;if rO then f2[_a] =nil end end else local _hf;yC,Ls,_hf =h1(3,_a,_b,_c,K7,Ls,o5,Po2,f2,dl,ZO,E4,rO);if _hf then E4 =true;rO =true elseif K7[7]==0 then rO =true end end elseif _k==26 then local fR=(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])if K7[17]==fRand K7[18]==1and K7[7]==1 then if not E4 and not rO then o5[_a] =fR()else o5[_a] =fR();if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR()end end;if rO then f2[_a] =nil end end else local _hf;yC,Ls,_hf =h1(0,_a,_b,_c,K7,Ls,o5,Po2,f2,dl,ZO,E4,rO);if _hf then E4 =true;rO =true elseif K7[7]==0 then rO =true end end elseif _k==25 then o5[_a] =fO[181]((if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fO[181]((if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]))end end;if rO then f2[_a] =nil end else yC,Ls =K7[3](_a,_b,_c,K7[7],o5,Po2,f2,dl,Ls);E4 =true;rO =true end elseif _k<40 then if _k==30 then local _ck=K7[13];if _ck==nil then _ck =dl[1][126](_b,dl[6]);K7[13] =_ck end;o5[_a] =_ck;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =_ck end end;if rO then f2[_a] =nil end elseif _k==35 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])+_c;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])+_c end end;if rO then f2[_a] =nil end elseif _k==31 then local _ck=K7[13];if _ck==nil then _ck =dl[1][126](_b,dl[6]);K7[13] =_ck end;o5[_a] =ZO[_ck];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =ZO[_ck]end end;if rO then f2[_a] =nil end elseif _k==37 then local _ck=K7[13];if _ck==nil then _ck =dl[1][126](_c,dl[6]);K7[13] =_ck end;o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])[_ck];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])[_ck]end end;if rO then f2[_a] =nil end elseif _k==33 then local _ck=K7[13];if _ck==nil then _ck =dl[1][126](_c,dl[6]);K7[13] =_ck end;o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])+_ck;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])+_ck end end;if rO then f2[_a] =nil end elseif _k==34 then local _ck=K7[13];if _ck==nil then _ck =dl[1][126](_c,dl[6]);K7[13] =_ck end;o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])*_ck;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])*_ck end end;if rO then f2[_a] =nil end elseif _k==32 then local _k1=K7[13];local _k2=K7[14];if _k1==nil then _k1 =dl[1][126](_b,dl[6]);_k2 =dl[1][126](_c,dl[6]);K7[13] =_k1;K7[14] =_k2 end;o5[_a] =ZO[_k1][_k2];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =ZO[_k1][_k2]end end;if rO then f2[_a] =nil end elseif _k==36 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])*_c;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])*_c end end;if rO then f2[_a] =nil end elseif _k==38 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])/(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])/(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c])end end;if rO then f2[_a] =nil end elseif _k==39 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])//(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])//(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c])end end;if rO then f2[_a] =nil end else yC,Ls =K7[3](_a,_b,_c,K7[7],o5,Po2,f2,dl,Ls);E4 =true;rO =true end else if _k==48 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])>=(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])>=(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c])end end;if rO then f2[_a] =nil end elseif _k==49 then local R8=g9[67][_b+1]local Kt={}for gO=1,#R8[2]do local jL=R8[2][gO]if jL[1]==0 then local P1=Po2[jL[2]]if P1==nil then P1 ={(if E4and Po2[jL[2]]~=nil then Po2[jL[2]][1]else o5[jL[2]])};Po2[jL[2]] =P1;E4 =true end Kt[gO] =P1 else Kt[gO] =h9[8627718][jL[2]+1]end end local GL8=(R8[13]+2)%3 if GL8==1 then for _ci=1,#Kt do Kt[_ci] ={Kt[_ci]}end elseif GL8==2 then Kt ={[8627718]=Kt}end local qJ={Kt}local nh={R8,Ut,ZO}local fR=function(...)local _venv=nh[3]or ZO local Z3=Uy7(nh[1],qJ[1],fO[186](...),_venv,nh[2],nh) return fO[86](Z3,1,(fO[202](Z3)=='table' and (Z3.n or #Z3) or 1)) end Pj0[fR] =nh Ct[fR] =qJ[1]o5[_a] =fR;if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =fR end end;if rO then f2[_a] =nil end elseif _k==50 then local _t=(if E4and Po2[_a]~=nil then Po2[_a][1]else  o5[_a]);local _m=f2[_c];if fO[202](_m)=='table' then local _n=_m.n;if fO[202](_n)~='number' then _n =#_m end;for _i=1,_n do _t[_b+_i-1] =_m[_i]end else _t[_b] =(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]) end    end elseif _k==40 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])^(if E4and Po2[_c]~=nil then Po2[_c][1]else o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])^(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]) end end;if rO then f2[_a] =nil end elseif _k==41 then o5[_a] =-((if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b]));if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =-((if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])) end end;if rO then f2[_a] =nil end elseif _k==42 then o5[_a] =not(if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =not(if E4 and Po2[_b]~=nil then Po2[_b][1]else  o5[_b]) end end;if rO then f2[_a] =nil end elseif _k==43 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])==(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])==(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]) end end;if rO then f2[_a] =nil end elseif _k==44 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])~=(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])~=(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]) end end;if rO then f2[_a] =nil end elseif _k==45 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])<(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])<(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]) end end;if rO then f2[_a] =nil end elseif _k==46 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])<=(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])<=(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]) end end;if rO then f2[_a] =nil end elseif _k==47 then o5[_a] =(if E4and Po2[_b]~=nil then Po2[_b][1]else o5[_b])>(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]);if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =(if E4and Po2[_b]~=nil then Po2[_b][1]else  o5[_b])>(if E4 and Po2[_c]~=nil then Po2[_c][1]else  o5[_c]) end end;if rO then f2[_a] =nil end elseif _k==51 then Po2[_a] =nil elseif _k==52 then o5[_a] =h9[8627718][_b+1][1];if E4 then local _wc=Po2[_a];if _wc~=nil then _wc[1] =h9[8627718][_b+1][1]end end;if rO then f2[_a] =nil end elseif _k==53 then h9[8627718][_b+1][1] =(if E4and Po2[_a]~=nil then Po2[_a][1]else o5[_a])else yC,Ls =K7[3](_a,_b,_c,K7[7],o5,Po2,f2,dl,Ls);E4 =true;rO =true end end Na =K7[9]else yC,Ls =K7[3](K7[4],K7[5],K7[6],K7[7],o5,Po2,f2,dl,Ls)Na =K7[9]end else if not _ready then if SO[163]then XO =fO[106](fO[106](SO[142]or 0,Su7(IQ,2)),Su7(_atk,5))else XO =SO[142]or 0 end;iz =SO[232]or{};_ready =true end if yO>NPor yO<k3or uX3==0 then local yT=SO[114][yO]if yT==nil then uC() end if yT~=uX3 then uX3 =yT;local _cf=iz[uX3]if _cf then local _cfa=_cf[6] if _cfa then T5 =_cfa[1];Na =_cfa[2];_rk =_cfa[3]or 0;n7 =_cf[5];k3 =_cf[3];NP =_cf[4]else local _entry=SO[114][39728209][uX3]local RX=tO(J8,1112297283,uX3,0)local _atag;if SO[163]then Na =fO[106](fO[106](_entry,Su7(RX,0)),Su7(_atk,3));_atag =fO[106](fO[106](_cf[1],Su7(RX,1)),Su7(_atk,4))else Na =_entry;_atag =_cf[1]end local _arc=e5[_atag];if _arc==nil then uC()end;if uX3==1and XO~=_arc[2]then uC() end;T5 =_arc[1];_rk =_arc[3]or 0 n7 ={};k3 =_cf[3];NP =_cf[4]local _ct=_cf[2];local _clen=#_ct local _skey=fO[106](_cf[8],tO(RX,1465008464,_cf[7],_clen))local _raw={};local _st=_skey for _pi=1,_clen do _raw[_pi] =fO[106](_ct[_pi],fO[95](_st,255));_st =fO[174]((fO[106](_st,fO[95](_pi*257,4294967295),fO[95](uX3*131071,4294967295))+2654435769)%4294967296,7)end local _hh=1831565813;for _pi=1,_clen do _hh =fO[106](fO[174](_hh,5),_raw[_pi],fO[95](_pi*257,4294967295))end if tO(_skey,_hh,_clen,1413564193)~=_cf[9]then uC()end local _cnt=NP-k3+1;local _stride=#_raw/_cnt if _stride~=8and _stride~=10 and _stride~=12 then uC() end for _rp=k3,NP do local _ro=(_rp-k3)*_stride;local _wfirst=_raw[_ro+1]+_raw[_ro+2]*256+_raw[_ro+3]*65536+_raw[_ro+4]*16777216;local _wsecond=_raw[_ro+5]+_raw[_ro+6]*256+_raw[_ro+7]*65536+_raw[_ro+8]*16777216;if _stride~=8 then local _keyi=fO[106](364014757,fO[95](_rp*2246822519,4294967295));local _chk=fO[106](fO[174](_wsecond,7),_wfirst,_keyi);if _stride==10 then if _raw[_ro+9]+_raw[_ro+10]*256~=fO[95](_chk,65535) then uC() end else if _raw[_ro+9]+_raw[_ro+10]*256+_raw[_ro+11]*65536+_raw[_ro+12]*16777216~=_chk then uC() end end end;n7[_rp] ={_wsecond,_wfirst}end _cf[5] =n7;_cf[6] ={T5,Na,_rk}end else uC()end end end K7 =n7[yO]if K7==nil then uC() end Ls =yO+1 yC =nil yC,Ls,Na =T5(K7,Na,o5,Po2,f2,dl,Ls,_rk)if K7[10]==49 then local _rn=dl[1][155];for _ci=0,_rn-1 do if Po2[_ci]~=nil then E4 =true;break end end elseif K7[7]==0and(K7[10]==26or K7[10]==27 or K7[10]==28 or K7[10]==29 or K7[10]==54 or K7[10]==56) then rO =true end if K7[3]~=nil then wf7[yO] =K7 end end if yC then if QV~=2 then EO =EO+1;tV[EO] ={o5,Po2,f2,dl}end;return yC end yO =Ls end end l7 =function(fR,Gr,ZO)local _argc=(fO[202](Gr)=='table'and(Gr.nor#Gr) or 0) if fR==fO[230] and _argc==0 then local _pack={n=1,[1]=ZO} return _pack end local _vmc=Pj0[fR] if _vmc~=nil then local _caps=Ct[fR];return Uy7(_vmc[1],_caps,Gr,_vmc[3] or ZO,_vmc[2],_vmc) end if fR~=fO[230] and fR~=xw and fR~=ja and fR~=ZO.loadstring and fR~=ZO.load then return fO[186](fR(fO[86](Gr,1,(fO[202](Gr)=='table' and (Gr.n or #Gr) or 0)))) end if fR==xw or fR==ja or fR==ZO.loadstring or fR==ZO.load then local _res=fO[186](fO[143](xw,fO[86](Gr,1,(fO[202](Gr)=='table' and (Gr.n or #Gr) or 0)))) if _res[1] then if fO[202](_res[2])=='function' and fO[202](Gr[4])~='table' then fO[143](fO[193],_res[2],ZO) end local _rn=(fO[202](_res)=='table' and (_res.n or #_res) or 0);for _ri=1,_rn-1 do _res[_ri] =_res[_ri+1]end;_res[_rn] =nil;_res.n =_rn-1;return _res end fO[218](_res[2],0)end local _res=fO[186](fO[143](fR,fO[86](Gr,1,(fO[202](Gr)=='table'and (Gr.n or #Gr) or 0)))) if not _res[1] then local _rm=fO[202](_res[2])=='string' and _res[2] or '' if fO[202](Gr[1])=='string' and (_rm:find('RobloxScript',1,true) or _rm:find('not available',1,true)) then _res =fO[186](fO[143](xw,fO[86](Gr,1,(fO[202](Gr)=='table'and (Gr.n or #Gr) or 0)))) if _res[1] and fO[202](_res[2])=='function' and fO[202](Gr[4])~='table' then fO[143](fO[193],_res[2],ZO) end end if not _res[1] then fO[218](_res[2],0) end end if _res[1] then local _rn=(fO[202](_res)=='table' and (_res.n or #_res) or 0);for _ri=1,_rn-1 do _res[_ri] =_res[_ri+1]end;_res[_rn] =nil;_res.n =_rn-1;return _res end fO[218](_res[2],0)end local Il7Env=fO[230]()if fO[202](Il7Env)~='table' then Il7Env =_G end Il7Env.getfenv =fO[230]Il7Env.setfenv =fO[193]  local _pub=ja if fO[202](_pub)=='function' then Il7Env.loadstring =_pub if fO[202](Il7Env.load)~='function'then Il7Env.load =_pub end local _gg=Il7Env.getgenv if fO[202](_gg)=='function'then local _ok,_ge=fO[143](_gg) if _ok and fO[202](_ge)=='table' then _ge.loadstring =_pub;if fO[202](_ge.load)~='function'then _ge.load =_pub end end end end   end if fO[202](Il7Env.collectgarbage)=='function'then local _cg=Il7Env.collectgarbage;Il7Env.collectgarbage =function(_opt,...)if _opt==nilor _opt=='collect'then local _ok,_res=fO[143](_cg,_opt,...) if _ok then return _res end return nil end return _cg(_opt,...) end end local Il7=Uy7(g9[67][g9[208]+1],{},{n=0},Il7Env,nil,nil) return Il7 end },{}):As(bit32,string,table,math,type,error,pcall,getfenv or debug and debug.getfenv,setfenv or debug and debug.setfenv,tonumber)
-- chunk: =t3seed coverage=12/18 consts=6
-- subst=0
return 1
-- chunk: =t3setup coverage=12/18 consts=6
-- subst=0
return 1
-- chunk: =unobfuscated_2 coverage=36/60 consts=24
-- subst=0
local Players = game:GetService('Players')

local function greet(player)
  print('hello from KeyForge, ' .. player.Name)
end

local value = 20 + 22
print('answer:', value)

Players.PlayerAdded:Connect(greet)

