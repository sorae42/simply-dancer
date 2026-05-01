-- PASTE this file into BGAnimations/ScreenPlayerOptions overlay folder

local t = ...

for dancer in ivalues(GetDancers()) do
    if dancer ~= "None" then
        t[#t + 1] = LoadActor("/" .. THEME:GetCurrentThemeDirectory() .. "Dancers/" .. dancer) .. {
            Name = "Dancer_" .. StripSpriteHints(dancer),
            InitCommand = function(self)
                self:visible(false)
            end,

            OnCommand = function(self)
                -- drive states manually based on song beat
                if self.GetNumStates and (self:GetNumStates() or 1) > 1 then
                    self:animate(false)
                    self._last_idx = nil
                    self:queuecommand("Loop")
                end
            end,

            LoopCommand = function(self)
                local n = self:GetNumStates() or 1
                if n <= 1 then
                    self:stoptweening():sleep(0.1):queuecommand("Loop")
                    return
                end

                local beat = GAMESTATE:GetSongBeat() or 0

                local cycle_beats = 2
                local phase = ((beat / cycle_beats) % 1)
                local idx = math.floor(phase * n)

                if idx < 0 then idx = 0 end
                if idx >= n then idx = n - 1 end

                if idx ~= self._last_idx then
                    self._last_idx = idx
                    self:setstate(idx)
                end

                self:stoptweening():sleep(0.025):queuecommand("Loop")
            end
        }
    else
        t[#t + 1] = Def.Actor { Name = "Dancer_None", InitCommand = function(self) self:visible(false) end }
    end
end
