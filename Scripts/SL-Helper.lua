-- PATCH this file into SL-Helper.lua,
-- you can paste this at the end of the file

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
