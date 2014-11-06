if(client)
  if(!file.Exists("/goodreads/book/", "DATA") then file.CreateDir("/goodreads/book/", "DATA") end
  if(!file.Exists("/goodreads/book/such-is-life.txt", "DATA") then 
    suchIsLifeText = [[
    Such is life, I thought. I am alone, and everyone around me can see. I am alone in a crowded room. I am a sad sorry son of a bitch and I don't need your pity.
    ]]
    file.Write(suchIsLifeText) 
  end
end
