--[[-----------------------------------
AUTHOR: dougRiss
DATE: 11/7/2014
PURPOSE: initializes our book SENT
--]]-----------------------------------
AddCSLuaFile("shared.lua")
AddCSLuaFile("init.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("config/config.lua")

--[[-----------------------------------
Here's the Books' table. Naturally, it
is empty on initialization, as nobody 
has yet to touch it.
--]]-----------------------------------
local books = {}

--[[-----------------------------------
Open up a network string that will allow
us to talk between the client and server
about our books.
--]]-----------------------------------
util.AddNetworkString(NW_STRING_BOOK)

--[[-----------------------------------
Receive the table from the clientside
script and do stuff to it.
--]]-----------------------------------
net.Receive(NW_STRING_BOOK, -- Not sure if this is the best way to do it, but this is all I knew about talking with the server.
    function (len)
        local theTable = net.ReadTable()
        placeBookInTable(theTable.id, theTable)
    end)

--[[-----------------------------------
Place our book that we gather from
net.Receive into our books table
--]]-----------------------------------
function placeBookInTable(id, theTable)
    books[id] = theTable
end

--[[-----------------------------------
Hook for when the object initializes;
Initializes the object when it's first
spawned.
--]]-----------------------------------
function ENT:Initialize()
    self:SetModel("models/props_lab/binderblue.mdl")
    self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid( SOLID_VPHYSICS )
    self:SetBookID(self:GetCreationID()) --sets the book's ID to it's creationID
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

--[[-----------------------------------
Hook for when an entity uses the item;
get the book from the table and send it
to the clientside scripts
--]]-----------------------------------
function ENT:Use( act, call)
    local me = self:GetBookID() -- on use, get the name of the entity being used
    local theTable = books[me]          -- store the table entry associated with whatever 'me' turns out to be
    theTable.activator = act
    if act.IsPlayer() then      -- if the activating entity is the player...
        net.Start(NW_STRING_BOOK)    -- start the network string
            net.WriteTable(theTable)    -- write the table with our entity's information
        net.Send(act)           -- then send to the player who used it.
    end
end

--[[-----------------------------------
Override ENT:Think to do nothing.
--]]-----------------------------------
function ENT:Think() end