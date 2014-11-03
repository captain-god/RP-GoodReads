ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.Spawnable = true

ENT.PrintName		= "Sign"
ENT.Author			= "DougRiss"
ENT.Contact			= "himself@dougriss.com"
ENT.Purpose			= "Save info in a Sign for other players to read!"
ENT.Instructions	= "Hit E to edit the sign"

function ENT:SetupDataTables() --I used these to initialize the ents with sign name and value attributes at spawn, basically.
	self:NetworkVar( "String", 0, "SignName" )
	self:NetworkVar( "String", 1, "SignText" )
	self:NetworkVar( "String", 2, "SignID" )
	self:NetworkVar( "String", 3, "SignOwner")
end 

--[[hooks]]--