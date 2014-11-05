AddCSLuaFile("shared.lua")
AddCSLuaFile("init.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("nwrpbook") -- communicate between client and server about the books

--[[-----------------------------------
Here's the Books' table and things
touch it.
--]]-----------------------------------
local books = {}
	
net.Receive("nwrpbook", -- Not sure if this is the best way to do it, but this is all I knew about talking with the server.
	function (len)
		local theTable = net.ReadTable()
		placeBookInTable(theTable.id, theTable)
	end)

function placeBookInTable(id, theTable)
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
	self:SetBookID(self:GetCreationID()) --sets the book's name to it's creationID
	self:SetBookText("")
	self:SetBookOwner("")
	self:SetBookName("")
	local newBook = {} 
	newBook.name = self:GetBookName()
	newBook.text = self:GetBookText()
	newBook.owner = self:GetBookOwner()
	newBook.id = self:GetBookID()
	books[self:GetBookID()] = newBook --store the newly created book in the table, right?
end

function ENT:Use( act, call )
	local me = self:GetBookID() -- on use, get the name of the entity being used
	local theTable = books[me]			-- store the table entry associated with whatever 'me' turns out to be
	theTable.activator = act
	if act.IsPlayer() then  	-- if the activating entity is the player...
		net.Start("nwrpbook") 	-- start the network string
			net.WriteTable(theTable) 	-- write the table with our entity's information
		net.Send(act) 			-- then send to the player who used it.
	end
end

function ENT:Think()
	--I am book I am think hurdur--
end