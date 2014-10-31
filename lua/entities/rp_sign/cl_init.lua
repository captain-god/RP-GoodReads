include("shared.lua")

function ENT:Draw()
	self:DrawModel()       
end

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

local function writeToSign(panel, signText, name, owner) 
	local aSign = {}
	aSign.name = name
	aSign.text = signText
	aSign.owner = owner 
	
	net.Start("nwrpsign")
		net.WriteTable(aSign)
	net.SendToServer()
	
	panel:Remove()
	panel = nil
end

local function saveToFile(text)
	--[[do something]]--
end
	
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
--DFrame spawn every tick for as long as the mouse is pressed.
--]]

local function editSignFrame(name, signText, owner, activator)
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
				writeToSign(mainPanel, "", name, owner)
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

			local textBox = vgui.Create("DTextEntry", mainPanel)
			textBox:SetMultiline(true)
			textBox:SetValue(signText)
			textBox:SetPos(5, 30)
			textBox:SetSize(305, 365)
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
					editButton:SetText("Save")
					editButton:SetSize(btnW, btnH)
					editButton:SetPos(btnStartX, btnStartY)
					acceptButton:SetText("Cancel")
					textBox:SetEditable(true)
				else
					writeToSign(mainPanel, textBox:GetValue(), name, owner)
					displayNotification("Changes Saved")
					mainPanel = nil
				end --end if
			end --end function()
			
			local openButton = vgui.Create("DButton", mainPanel)
			openButton:SetPos(btnStartX, btnStartY + btnH + border)
			openButton:SetSize(btnW, 45)
			openButton:SetText("Open")
			openButton.DoClick = function ()
				mainPanel:Remove()
				mainPanel = nil
			end --end function()
			
			local saveButton = vgui.Create("DButton", mainPanel)
			saveButton:SetPos(btnStartX, btnStartY + ( btnH + border )* 2)
			saveButton:SetSize(btnW, 45)
			saveButton:SetText("Save")
			saveButton.DoClick = function ()
				saveToFile(mainPanel, textBox:GetValue(), name, owner)
				mainPanel:Remove()
				mainPanel = nil
			end --end function()
			
		else -- the sign is claimed and activator is not owner...
			mainPanel = vgui.Create("DFrame")
			mainPanel:SetSize(175, 300)
			mainPanel:SetTitle("Select Action")
			mainPanel:SetDraggable(false)
			mainPanel:ShowCloseButton(false)
			mainPanel:MakePopup()
			mainPanel:Center()
			mainPanel:ParentToHUD()		

			local textBox = vgui.Create("DTextEntry", mainPanel)
			textBox:SetMultiline(true)
			textBox:SetValue(signText)
			textBox:SetPos(4, 4)
			textBox:SetSize(167, 254)
			textBox:SetEditable(false)
			
			local closeButton = vgui.Create("DButton", mainPanel)
			closeButton:SetPos(4, 258)
			closeButton:SetSize(167, 38)
			closeButton:SetText("Close")
			closeButton.DoClick = function ()
				mainPanel:Remove()
				mainPanel = nil
			end --end function()
		end --end if pertaining to sign owner
	end -- end if (singleton)
end	--end function editSignFrame

net.Receive("nwrpsign", -- Not sure if this is the best way to do it, but this is the only way I know how to get the client and server to talk.
function (len)
	local theTable = net.ReadTable()
		local name = theTable.name
		local signText = theTable.text
		local owner = theTable.owner
		local activator = theTable.activator:SteamID()
		editSignFrame(name, signText, owner, activator)
end)

