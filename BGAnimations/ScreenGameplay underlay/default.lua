-- Patch the default script load the dancer script
-- It needs to be put inside the player loop so it can load for 2 players

for player in ivalues(Players) do
	t[#t+1] = LoadActor("./Dancer.lua", player)
end
