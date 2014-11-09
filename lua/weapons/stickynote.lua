include("config/config.lua")

SWEP.PrintName = "Pad of Sticky Notes"			
SWEP.Author = "dougRiss"
SWEP.Instructions = "Left mouse place a sticky note."

SWEP.Spawnable = ALLOW_NOTES
SWEP.AdminOnly = (!ALLOW_NOTES && ADMIN_IGNORE)

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom	= false

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 5 )	
	getStickyNoteText()
end

function placeStickyNote( text )
	if ( CLIENT ) then return end
	
	local pos = self.Owner:EyePos() + ( self.Owner:GetAimVector() * 16 )
	local ang = self.Owner:EyeAngles()
	
	cam.Start3D2D((pos + ang:Up() * 0.1), ang, 0.15) -- I might have stolen this from DarkRP. Maybe.
		draw.RoundedBoxEx( 0, 0, 0, 160, 160, Color(100,100,100,100), false, false, false, false ) 
		draw.DrawText(text, "HudHintTextLarge", 0, -25, Color(255,255,255,255), 1)
	cam.End3D2D()
end

function getStickyNoteText()


	placeStickyNote( "boo" )
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + 5 )	
	getStickyNoteText()
end

