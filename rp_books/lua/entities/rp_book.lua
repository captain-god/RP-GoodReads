-- you may notice it says "sign" all over the place:
-- this is a port of the sign addon I made, only it
-- caters specifically to books.

AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.Spawnable = true

ENT.PrintName		= "Book"
ENT.Author			= "DougRiss"
ENT.Contact			= "N/A"
ENT.Purpose			= "Save info in a book!"
ENT.Instructions	= "Hit E to edit the book"

if (CLIENT) then
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
				claimSignButton:SetText("Claim book")
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
end

if (SERVER) then
	util.AddNetworkString("nwrpsign") -- communicate between client and server about the signs

--[[-----------------------------------
	Here's the Signs' table and things
	touch it.
--]]-----------------------------------
	local signs = {}
		
	net.Receive("nwrpsign", -- Not sure if this is the best way to do it, but this is all I knew about talking with the server.
		function (len)
			local theTable = net.ReadTable()
			placeSignInTable(theTable.name, theTable, theTable.owner)
		end)

	function placeSignInTable(id, theTable, owner)
		signs[id] = theTable
	end
--[[-----------------------------------
			Average Ent Shit
--]]-----------------------------------
	
	function ENT:SetupDataTables() --I used these to initialize the ents with sign name and value attributes at spawn, basically.
		self:NetworkVar( "String", 0, "SignName" )
		self:NetworkVar( "String", 1, "SignText" )
		self:NetworkVar( "String", 3, "SignOwner")
	end 
	
	function ENT:Initialize()
		self:SetModel("models/props_lab/binderblue.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid( SOLID_VPHYSICS )
		self:SetSignName(self:GetCreationID()) --sets the sign's name to it's creationID
		self:SetSignText("")
		self:SetSignOwner("")
		local newSign = {} 
		newSign.name = self:GetSignName()
		newSign.text = self:GetSignText()
		newSign.owner = self:GetSignOwner()
		signs[self:GetSignName()] = newSign --store the newly created sign in the table, right?
	end
	
	function ENT:OnRemove()
		signs[self:GetSignName()] = nil -- remove it when deleted (gotta free up dem bits n bytes)
	end
	
	function ENT:Use( act, call )
		local me = self:GetSignName() -- on use, get the name of the entity being used
		local theTable = signs[me]			-- store the table entry associated with whatever 'me' turns out to be
		theTable.activator = act
		if act.IsPlayer() then  	-- if the activating entity is the player...
			net.Start("nwrpsign") 	-- start the network string
				net.WriteTable(theTable) 	-- write the table with our entity's information
			net.Send(act) 			-- then send to the player who used it.
		end
	end
	
	function ENT:Think()
		--I am sign I am think hurdur--
	end
end
