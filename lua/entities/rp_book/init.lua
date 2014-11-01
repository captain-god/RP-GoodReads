AddCSLuaFile("shared.lua")
AddCSLuaFile("init.lua")
include("shared.lua")

util.AddNetworkString("nwrpbook") -- communicate between client and server about the books

--[[-----------------------------------
Here's the Signs' table and things
touch it.
--]]-----------------------------------
local books = {}
	
net.Receive("nwrpbook", -- Not sure if this is the best way to do it, but this is all I knew about talking with the server.
	function (len)
		local theTable = net.ReadTable()
		placeBookInTable(theTable.name, theTable, theTable.owner)
	end)

function placeBookInTable(id, theTable, owner)
	books[id] = theTable
end
--[[-----------------------------------
		Average Ent Shit
--]]-----------------------------------

function ENT:Initialize()
	self:SetModel("models/props_lab/binderblue.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS )
	self:SetBookName(self:GetCreationID()) --sets the book's name to it's creationID
	self:SetBookText("")
	self:SetBookOwner("")
	local newBook = {} 
	newBook.name = self:GetBookName()
	newBook.text = self:GetBookText()
	newBook.owner = self:GetBookOwner()
	books[self:GetBookName()] = newBook --store the newly created book in the table, right?
end

function ENT:OnRemove()
	books[self:GetBookName()] = nil -- remove it when deleted (gotta free up dem bits n bytes)
end

function ENT:Use( act, call )
	local me = self:GetBookName() -- on use, get the name of the entity being used
	local theTable = books[me]			-- store the table entry associated with whatever 'me' turns out to be
	theTable.activator = act
	if act.IsPlayer() then  	-- if the activating entity is the player...
		net.Start("nwrpbook") 	-- start the network string
			net.WriteTable(theTable) 	-- write the table with our entity's information
		net.Send(act) 			-- then send to the player who used it.
	end
end

function ENT:Think() 
end