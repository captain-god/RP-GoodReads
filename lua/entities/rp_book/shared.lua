--[[-----------------------------------
AUTHOR: dougRiss
DATE: 11/7/2014
PURPOSE: Set up our entity details
--]]-----------------------------------
include("config/config.lua")

ENT.Base = "goodreads_base"
ENT.Type = "anim"
ENT.Spawnable = ALLOW_BOOKS

ENT.PrintName		= "Blue Book"
ENT.Author			= "DougRiss"
ENT.Contact			= "himself@dougriss.com"
ENT.Purpose			= "Save info in a Book for other players to read!"
ENT.Instructions	= "Hit E to edit the Book"

function ENT:SetupDataTables() --I used these to initialize the ents with Book name and value attributes at spawn, basically.
	self:NetworkVar( "String", 0, "BookName" )
	self:NetworkVar( "String", 1, "BookText" )
	self:NetworkVar( "String", 2, "BookID" )
	self:NetworkVar( "String", 3, "BookOwner")
end 
--[[hooks]]--