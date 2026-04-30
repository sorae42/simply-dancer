-- PATCH this Dancer method to your SL-PlayerOptions > Overrides

local Overrides = {
    -- ...

	-------------------------------------------------------------------------
	Dancer = {
		LayoutType = "ShowOneInRow",
		ExportOnChange = true,
		Choices = function() return map(StripSpriteHints, GetDancers()) end,
		Values = function() return GetDancers() end,
		SaveSelections = function(self, list, pn)
			local mods = SL[ToEnumShortString(pn)].ActiveModifiers
			for i, val in ipairs(self.Values) do
				if list[i] then mods.Dancer = val; break end
			end
			MESSAGEMAN:Broadcast("RefreshActorProxy", {Player=pn, Name="Dancer", Value=StripSpriteHints(mods.Dancer)})
		end
	},

    -- ...
}