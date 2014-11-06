--[[this shit takes forever to do by hand, and it's annoying
--so I took the liberty of just doing it here in some functions
--to be imported by the other modules.]]

function makePanel(x, y, closeButton, title)
    filePanel = vgui.Create("DFrame")
    filePanel:SetTitle(title)
    filePanel:SetSize(x, y)
    filePanel:SetDraggable(false)
    filePanel:ShowCloseButton(closeButton)
    filePanel:MakePopup()
    filePanel:Center()
    filePanel:ParentToHUD()
    
    return filePanel
end

function makeTextEntry(parent, x, y, posX, posY, value, editable, multiline)
    local textBox = vgui.Create("DTextEntry", parent)
    textBox:SetMultiline(multiline)
	textBox:SetValue(signText)
	textBox:SetSize(x, y)
	textBox:setPos(posX, posY)
	textBox:SetEditable(editable)
	
	return textBox
end

function makeButton(parent, x, y, posX, posY, text, doClickFunction)
    acceptButton = vgui.Create("DButton", parent)
	acceptButton:SetSize(x, y)
	acceptButton:SetPos(posX, posY)
	acceptButton:SetText(text)
	acceptButton.DoClick = (function ()
	    doClickFunction()
	end)
	
	return acceptButton
end

function makeLabel(parent, text, dock, font, x, y, posX, posY)
    local aLabel = vgui.Create( "DLabel", parent)
	aLabel:Dock( dock )
	aLabel:SetText( text )
	aLabel:SetFont( font )
	aLabel:SizeToContents()
	if (x && y) then aLabel:SetSize(x, y) end
	if (posX && posY) then aLabel:SetPos(posX, posY) end
	
	return aLabel
end

function makeNotification(x, y, posX, posY, text, life)
	successNotification = vgui.Create( "DNotify" )
	successNotification:SetPos(ScrW() * 0.5 - x * 0.5, ScrH() * 0.5)
	successNotification:SetSize( x, y )
	successNotification:SetLife(life)
	
	makeLabel( successNotification, 
	local aLabel = vgui.Create( "DLabel", successNotification)
	aLabel:Dock( FILL )
	aLabel:SetText( notification )
	aLabel:SetFont( "GModNotify" )
	aLabel:SetDark( true )
	aLabel:SizeToContents()
	
	successNotification:AddItem(aLabel)
end
