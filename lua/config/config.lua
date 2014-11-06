--[[   Server Configuration files:   ]]--

--Server Admins do not subscribe to server limits.
ADMIN_IGNORE = false 

--Maximum amount of signs a player can have at once.
MAX_SIGNS = 5 

--maximum number of characters allowed in a sign, 0 means no limit
MAX_SIGN_CHARACTERS = 255

--maximum number of characters allowed in a book, 0 means no limit
MAX_BOOK_CHARACTERS = 255 

--maximum number of chraracters allowed in a sticky-note; must be > 0 & < 255 (sticky notes are small)
MAX_STICKY_CHARACTERS = 60 

--minimum number of characters allowed; must be > 0
MIN_CHARACTERS = 0 

--players can use signs
ALLOW_SIGNS = true

--players can use books
ALLOW_BOOKS = true

--players can use sticky notes
ALLOW_NOTES = true

--generate prefabricated books for new users (config/default_content.lua contains said books)
GEN_STARTER_BOOKS = true

--generate prefabricated signs for new users (config/default_content.lua contains said signs)
GEN_STARTER_SIGNS = true

--gather usage statistics (for yourself, I wont see it ever); see config/usgstat.lua
GAT_USER_DATA = true

--gather errors and place them in a report (when, where and how something broke). Please email this to me.
GAT_ERROR_REPORT = true

--TODO: More
