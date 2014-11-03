ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.Spawnable = true

ENT.PrintName		= "Book"
ENT.Author			= "DougRiss"
ENT.Contact			= "himself@dougriss.com"
ENT.Purpose			= "Save info in a Book for other players to read!"
ENT.Instructions	= "Hit E to edit the book"

function ENT:SetupDataTables() --I used these to initialize the ents with book name and value attributes at spawn, basically.
	self:NetworkVar( "String", 0, "BookName" )
	self:NetworkVar( "String", 1, "BookText" )
	self:NetworkVar( "String", 2, "BookID" )
	self:NetworkVar( "String", 3, "BookOwner")
end 

--[[hooks]]--