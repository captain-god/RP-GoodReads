include("shared.lua")

function ENT:Draw()
	self:DrawModel()       
end

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
	
local mainPanel
local function editSignFrame(name, signText, owner, activator) -- hurr durr derma
	if !mainPanel then
		if owner == "" then -- if this sign has no owner...
			owner = activator
			mainPanel = vgui.Create("DFrame")
			mainPanel:SetSize(175, 45)
			mainPanel:SetDraggable(false)
			mainPanel:MakePopup()
			mainPanel:Center()
			mainPanel:ParentToHUD()		
			
			local claimSignButton = vgui.Create("DButton", mainPanel)
			claimSignButton:SetPos(4, 4)
			claimSignButton:SetSize(167, 38)
			claimSignButton:SetText("Claim Sign")
			claimSignButton.DoClick = function ()
				writeToSign(mainPanel, "", name, owner)
				mainPanel = nil
			end
		elseif owner == activator then -- if the sign /is/ claimed, and the activator is owner...
			mainPanel = vgui.Create("DFrame")
			mainPanel:SetSize(175, 300)
			mainPanel:SetDraggable(false)
			mainPanel:MakePopup()
			mainPanel:Center()
			mainPanel:ParentToHUD()		

			local tb = vgui.Create("DTextEntry", mainPanel)
			tb:SetMultiline(true)
			tb:SetValue(signText)
			tb:SetPos(4, 4)
			tb:SetSize(167, 254)
			tb:SetEditable(false)
			
			local acceptButton = vgui.Create("DButton", mainPanel)
			acceptButton:SetPos(4, 258)
			acceptButton:SetSize(82, 38)
			acceptButton:SetText("Accept")
			acceptButton.DoClick = function ()
				writeToSign(mainPanel, tb:GetValue(), name, owner)
				mainPanel = nil
			end
			
			local editButton = vgui.Create("DButton", mainPanel)
			editButton:SetPos(89, 258)
			editButton:SetSize(82, 38)
			editButton:SetText("Edit")
			editButton.DoClick = function ()
				if editButton:GetText() == "Edit" then
					editButton:SetText("Save")
					editButton:SetSize(167, 38)
					editButton:SetPos(4,258)
					tb:SetEditable(true)
				else
					writeToSign(mainPanel, tb:GetValue(), name, owner)
					mainPanel = nil
				end --end if
			end --end function()
		else -- the sign is claimed and activator is not owner...
			mainPanel = vgui.Create("DFrame")
			mainPanel:SetSize(175, 300)
			mainPanel:SetDraggable(false)
			mainPanel:MakePopup()
			mainPanel:Center()
			mainPanel:ParentToHUD()		

			local tb = vgui.Create("DTextEntry", mainPanel)
			tb:SetMultiline(true)
			tb:SetValue(signText)
			tb:SetPos(4, 4)
			tb:SetSize(167, 254)
			tb:SetEditable(false)
			
			local closeButton = vgui.Create("DButton", mainPanel)
			closeButton:SetPos(4, 258)
			closeButton:SetSize(167, 38)
			closeButton:SetText("Close")
			closeButton.DoClick = function ()
				mainPanel:Remove()
				mainPanel = nil
			end
		end
	end
end	

net.Receive("nwrpsign", -- Not sure if this is the best way to do it, but this is the only way I know how to get the client and server to talk.
function (len)
	local theTable = net.ReadTable()
		local name = theTable.name
		local signText = theTable.text
		local owner = theTable.owner
		local activator = theTable.activator:SteamID()
		editSignFrame(name, signText, owner, activator)
end)