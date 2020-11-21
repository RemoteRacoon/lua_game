require("vector")
Player = {}
Player.__index = Player

function Player:create()
 local player = {}
 setmetatable(player, Player)
 player.position = nil
 return player
end