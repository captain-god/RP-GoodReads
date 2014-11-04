include("shared.lua")

function ENT:Draw()
	self:DrawModel()       
end

--[[display a notification to the user]]--
local function displayNotification(notification) -- to display when a change is successful
	local theWidth = 150
	successNotification = vgui.Create( "DNotify" )
	successNotification:SetPos(ScrW() * 0.5 - theWidth * 0.5, ScrH() * 0.5)
	successNotification:SetSize( theWidth, 40 )
	successNotification:SetLife(1)
	
	local aLabel = vgui.Create( "DLabel", successNotification)
	aLabel:Dock( FILL )
	aLabel:SetText( notification )
	aLabel:SetFont( "GModNotify" )
	aLabel:SetDark( true )
	aLabel:SizeToContents()
	
	successNotification:AddItem(aLabel)
end

 -- TODO: implement this function when entity is hovered over
local function readOnHoverText()
	draw.DrawText( "Read...", "TargetID", ScrW() * 0.5, ScrH() * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end

--[[sends the data from the user to the server to be added to the sign table]]--
local function writeToSign(panel, signText, name, owner, id) 
	local aSign = {}
	aSign.id = id
	aSign.name = name
	aSign.text = signText
	aSign.owner = owner 
	
	net.Start("nwrpsign")
		net.WriteTable(aSign)
	net.SendToServer()
	
	panel:Remove()
	panel = nil
end

--[[write the sign to a file for later use]]--
local function saveToFile(text, name)
	if(!file.Exists("goodreads/sign/", "DATA")) then
		file.CreateDir("goodreads/sign/")
	end
	file.Write("goodreads/sign/"..name..".txt", text)
	print("Sign saved to 'data/goodreads/sign/"..name..".txt'")
end

--[[read from a file to retrieve sign data]]--
local function readFromFile(name)
	print("Sign loaded from 'data/goodreads/sign/"..name)
	return file.Read("goodreads/sign/"..name ,"DATA")
end

--[[this is the dialog that apppears when a user asks to open a file]]--
local function openFileDialog(owner, id)
	filePanel = vgui.Create("DFrame")
	filePanel:SetTitle("Select Action")
	filePanel:SetSize(175, 200)
	filePanel:SetDraggable(false)
	filePanel:ShowCloseButton(true)
	filePanel:MakePopup()
	filePanel:Center()
	filePanel:ParentToHUD()	

	local FileBrowser = vgui.Create( "DListView", filePanel )
	FileBrowser:AddColumn( "Signs" )
	FileBrowser:SetPos(5, 30)
	FileBrowser:SetSize(165, 125)
	FileBrowser:SetMultiSelect(false)
	local tbl = file.Find("goodreads/sign/*", "DATA", dateasc)
	local i = 1
	for k in pairs(tbl) do
		FileBrowser:AddLine(tbl[i])
		i = i + 1
	end
	
	local closeButton = vgui.Create("DButton", filePanel)
	closeButton:SetPos(5, 160)
	closeButton:SetSize(165, 35)
	closeButton:SetText("Load File")
	closeButton.DoClick = function ()
		if (FileBrowser:GetSelectedLine()) then
				name = tbl[FileBrowser:GetSelectedLine()]
				text = readFromFile(name)
				name = string.sub(name,1,(string.len(name) - 4))
				writeToSign(filePanel, text, name, owner, id) 
		else
		end-- end if-else
	end-- end inner anonymous function
end -- end function
	
local mainPanel

--[[
--Absurdly long function that produces the Derma frame that houses the meat of the addon.
--This relies on the above variable "mainPanel" to be uninitialized. When it's called, the
--first thing the function does is check to see if mainPanel exists (it shouldn't): if it
--exists already, do nothing. However, if it doesn't exist, then we're in business.
--
--The design pattern used here is a pseudo-singleton, meaning it emulates the idea of a
--singleton, but is done much differently. This may be removed later on, but presently, it
--is the only fix to the bug that occurs when a user uses the entity that causes the
--DFrame spawn every tick for as long as the use key is pressed.
--]]

local function editSignFrame(name, signText, owner, activator, id)
	if !mainPanel then
		if owner == "" then -- if this sign has no owner...
			owner = activator
			mainPanel = vgui.Create("DFrame")
			mainPanel:SetTitle("Select Action")
			mainPanel:SetSize(175, 100)
			mainPanel:SetDraggable(false)
			mainPanel:ShowCloseButton(false)
			mainPanel:MakePopup()
			mainPanel:Center()
			mainPanel:ParentToHUD()		
			
			local claimButton = vgui.Create("DButton", mainPanel)
			claimButton:SetPos(4, 30)
			claimButton:SetSize(167, 30)
			claimButton:SetText("Claim Sign")
			claimButton.DoClick = function ()
				writeToSign(mainPanel, "", name, owner, id)
				displayNotification("Claimed")
				mainPanel = nil
			end --end function()
			
			local closeButton = vgui.Create("DButton", mainPanel)
			closeButton:SetPos(4, 64)
			closeButton:SetSize(167, 30)
			closeButton:SetText("Close")
			closeButton.DoClick = function ()
				mainPanel:Remove()
				mainPanel = nil
			end --end function()
		elseif owner == activator then -- if the sign is claimed, and the activator is owner...
			local btnW = 80
			local btnH = 45
			local btnStartX = 315
			local btnStartY = 30
			local border = 5
			
			mainPanel = vgui.Create("DFrame")
			mainPanel:SetTitle("Sign Properties")
			mainPanel:SetDraggable(false)
			mainPanel:SetSize(400, 400)
			mainPanel:ShowCloseButton(false)
			mainPanel:MakePopup()
			mainPanel:Center()
			mainPanel:ParentToHUD()		

			local nameBox = vgui.Create("DTextEntry", mainPanel)
			nameBox:SetMultiline(true)
			nameBox:SetValue(name)
			nameBox:SetPos(5, 30)
			nameBox:SetSize(305, 20)
			nameBox:SetEditable(false)
			
			local textBox = vgui.Create("DTextEntry", mainPanel)
			textBox:SetMultiline(true)
			textBox:SetValue(signText)
			textBox:SetPos(5, 55)
			textBox:SetSize(305, 340)
			textBox:SetEditable(false)
			
			local acceptButton = vgui.Create("DButton", mainPanel)
			acceptButton:SetPos(btnStartX, 350)
			acceptButton:SetSize(btnW, 45)
			acceptButton:SetText("Close")
			acceptButton.DoClick = function ()
				mainPanel:Remove()
				mainPanel = nil
			end --end function()
			
			local editButton = vgui.Create("DButton", mainPanel)
			editButton:SetPos(btnStartX, btnStartY)
			editButton:SetSize(btnW, 45)
			editButton:SetText("Edit")
			editButton.DoClick = function ()
				if editButton:GetText() == "Edit" then
					editButton:SetText("Accept")
					editButton:SetSize(btnW, btnH)
					editButton:SetPos(btnStartX, btnStartY)
					acceptButton:SetText("Cancel")
					textBox:SetEditable(true)
					nameBox:SetEditable(true)
				else
					writeToSign(mainPanel, textBox:GetValue(), nameBox:GetValue(), owner, id)
					displayNotification("Changes Saved")
					mainPanel = nil
				end --end if
			end --end function()
			
			local openButton = vgui.Create("DButton", mainPanel)
			openButton:SetPos(btnStartX, btnStartY + btnH + border)
			openButton:SetSize(btnW, 45)
			openButton:SetText("Open")
			openButton.DoClick = function ()
				openFileDialog(owner, id)
				mainPanel:Remove()
				mainPanel = nil
			end --end function()
			
			local saveButton = vgui.Create("DButton", mainPanel)
			saveButton:SetPos(btnStartX, btnStartY + ( btnH + border )* 2)
			saveButton:SetSize(btnW, 45)
			saveButton:SetText("Save")
			saveButton.DoClick = function ()
				saveToFile(textBox:GetValue(), name)
				mainPanel:Remove()
				mainPanel = nil
			end --end function()
			
		else -- the sign is claimed and activator is not owner...
			mainPanel = vgui.Create("DFrame")
			mainPanel:SetSize(400, 400)
			mainPanel:SetTitle("Select Action")
			mainPanel:SetDraggable(false)
			mainPanel:ShowCloseButton(false)
			mainPanel:MakePopup()
			mainPanel:Center()
			mainPanel:ParentToHUD()		

			local nameBox = vgui.Create("DTextEntry", mainPanel)
			nameBox:SetMultiline(true)
			nameBox:SetValue(name)
			nameBox:SetPos(5, 30)
			nameBox:SetSize(305, 20)
			nameBox:SetEditable(false)
			
			local textBox = vgui.Create("DTextEntry", mainPanel)
			textBox:SetMultiline(true)
			textBox:SetValue(signText)
			textBox:SetPos(5, 55)
			textBox:SetSize(305, 340)
			textBox:SetEditable(false)
			
			local acceptButton = vgui.Create("DButton", mainPanel)
			acceptButton:SetPos(315, 350)
			acceptButton:SetSize(80, 45)
			acceptButton:SetText("Close")
			acceptButton.DoClick = function ()
				mainPanel:Remove()
				mainPanel = nil
			end --end function()
		end --end if pertaining to sign owner
	end -- end if (singleton)
end	--end function editSignFrame

net.Receive("nwrpsign", -- Not sure if this is the best way to do it, but this is the only way I know how to get the client and server to talk.
function (len)
	local theTable = net.ReadTable()
		local id = theTable.id
		local name = theTable.name
		local signText = theTable.text
		local owner = theTable.owner
		local activator = theTable.activator:SteamID()
		editSignFrame(name, signText, owner, activator, id)
end)

