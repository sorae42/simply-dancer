-- PASTE this file into Scripts folder

-- -----------------------------------------------------------------------
-- GetDancers return a list of dancers to display in the Option Screen
--
GetDancers = function()
	local path = THEME:GetCurrentThemeDirectory().."Dancers/"
	local dirs = FILEMAN:GetDirListing(path)
	local dancers = { "None" }

	for filename in ivalues(dirs) do
		if FilenameIsMultiFrameSprite(filename) then
			table.insert(dancers, filename)
		end
	end
	
	return dancers
end