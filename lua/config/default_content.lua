include("config.lua") --include to check the GEN_STARTER_* stuff

if(client) then
    if(GEN_STARTER_BOOKS) then
        --if our books directory does not exist, create it. 
        --(It is assumed that if the directory exists, the user has been to the server before.)
        if(!file.Exists("/goodreads/book/", "DATA") then 
            file.CreateDir("/goodreads/book/", "DATA")
            
            --Default book template; copy and paste this a couple times and change stuff:
            if(!file.Exists("/goodreads/book/default.txt", "DATA") then 
                text = [[Book Title\n 
                Your book's text goes here.]]
                file.Write("/goodreads/book/default.txt", text) 
            end
            
        end
    end
    if(GEN_STARTER_SIGNS) then
        --if our sign directory does not exist, create it. 
        --(It is assumed that if the directory exists, the user has been to the server before.)
        if(!file.Exists("/goodreads/sign/", "DATA") then 
            file.CreateDir("/goodreads/sign/", "DATA")
            
            --Default sign template; copy and paste this a couple times and change stuff:
            if(!file.Exists("/goodreads/sign/default.txt", "DATA") then 
                text = [[Sign Title\n 
                Your sign's text goes here.]]
                file.Write("/goodreads/sign/default.txt", text) 
            end
            
        end
    end
end
