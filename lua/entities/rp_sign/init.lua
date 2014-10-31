AddCSLuaFile("shared.lua")
AddCSLuaFile("init.lua")
include("shared.lua")

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

function ENT:Initialize()
	self:SetModel("models/props_lab/clipboard.mdl")
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