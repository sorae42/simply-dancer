local t = ...

local SongPosition = GAMESTATE:GetPlayerState(GAMESTATE:GetMasterPlayerNumber()):GetSongPosition()
local frames_per_beat = 4

for dancer in ivalues( GetDancers() ) do
	if dancer ~= "None" then
		t[#t+1] = LoadActor("/"..THEME:GetCurrentThemeDirectory().."Dancers/"..dancer)..{
			Name="Dancer_"..StripSpriteHints(dancer),
			InitCommand=function(self)
				self:visible(false)
				self:SetAllStateDelays(0)
				self._num_states = self:GetNumStates()
			end,
			OnCommand=function(self)
				self:SetUpdateFunction(function(s)
					if not s:GetVisible() then return end  -- optional: skip work when hidden
					local n = s._num_states or s:GetNumStates()
					if not n or n <= 1 then return end
					local beat = SongPosition:GetSongBeat() or 0
					local f = math.floor(beat * frames_per_beat) % n
					s:setstate(f)
				end)
			end
		}
	else
		t[#t+1] = Def.Actor{
			Name="Dancer_None",
			InitCommand=function(self) self:visible(false) end
		}
	end
end