--[[   Server Configuration files:   ]]--

--Server Admins do not subscribe to server limits.
ADMIN_IGNORE = false 

--Maximum amount of signs a player can have at once.
MAX_SIGNS = 5 
MAX_BOOKS = 5
MAX_NOTES = 5

--maximum and minimum number of characters allowed in a sign, 0 means no limit
MAX_SIGN_CHARACTERS = 255
MAX_BOOK_CHARACTERS = 255
MAX_NOTE_CHARACTERS = 60 --sticky notes are hard limited to <= 160 characters
MIN_SIGN_CHARACTERS = 0
MIN_BOOK_CHARACTERS = 0
MIN_NOTE_CHARACTERS = 0

--allow players to save signs and books they do not own
ALLOW_SAVE_ON_VIEW_SIGN = false
ALLOW_SAVE_ON_VIEW_BOOK = false

--allow what modules players can use
ALLOW_SIGNS = true
ALLOW_BOOKS = true
ALLOW_NOTES = true

--generate prefabricated content for new users (config/default_content.lua configures said content)
GEN_STARTER_BOOKS = true
GEN_STARTER_SIGNS = true

--gather usage statistics (for yourself, I wont see it ever); see config/usgstat.lua
GATHER_USER_DATA = true

--TODO: More
