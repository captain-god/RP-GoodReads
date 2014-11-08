--[[-----------------------------------
AUTHOR: dougRiss
DATE: 11/7/2014
PURPOSE: Generate content for players 
who are new to the server - this is also
where you configure what said content is
--]]-----------------------------------
include("config.lua")

if(client) then
    if(GEN_STARTER_BOOKS) then
        if(!file.Exists("/goodreads/book/", "DATA") then 
            file.CreateDir("/goodreads/book/", "DATA")
            
			--[[Use the following template to generate custom content]]--
			filename = "default"
            if(!file.Exists("/goodreads/book/"..filename..".txt", "DATA") then 
				book = {
					title = "Book Title"
					text = [[Book Contents]]
					}
                file.Write("goodreads/book/"..fileName..".txt", util.TableToKeyValues(book))
            end
            
        end
    end
	
    if(GEN_STARTER_SIGNS) then
        if(!file.Exists("/goodreads/sign/", "DATA") then 
            file.CreateDir("/goodreads/sign/", "DATA")
            
			--[[Use the following template to generate custom content]]--
			filename = "default"
            if(!file.Exists("/goodreads/sign/"..filename..".txt", "DATA") then 
				sign = {
					title = "Sign Title"
					text = [[Sign Contents]]
					}
                file.Write("goodreads/sign/"..fileName..".txt", util.TableToKeyValues(sign))
            end
            
        end
    end
end
