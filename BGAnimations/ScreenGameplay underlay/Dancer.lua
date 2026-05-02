-- option doesn't exist in Casual mode so don't bother
if SL and SL.Global and SL.Global.GameMode == "Casual" then return end

-- -----------------------------------------------------------------------
-- Dancer position configuration — all offsets are from the notefield center.
-- Set to 0 to place the dancer at the center of their own notefield.
-- These default numbers are adapted to the default installation of Simply Love theme.

local DancerPositionOffset = {
    -- 1P: horizontal offset from the notefield center. Positive pushes the dancer to the right.
    single_x_offset = 253,

    -- 1P: vertical offset from screen center. Positive moves the dancer downward.
    single_y_offset = 100,

    -- 1P Centered/Double: horizontal offset from the notefield center. Positive pushes the dancer to the right.
    centered_x_offset = 173,

    -- 1P Centered/Double: vertical offset from screen center. Positive moves the dancer downward.
    centered_y_offset = 100,

    -- 2P: P1 horizontal offset from their notefield center. Positive pushes the dancer to the right.
    vs_p1_x_offset = 170,

    -- 2P: P1 vertical offset from screen center. Positive moves the dancer downward.
    vs_p1_y_offset = 150,

    -- 2P: P2 horizontal offset from their notefield center. Positive pushes the dancer to the right.
    -- This number should be in the negative if you want to put the dancer to the left of the playfield.
    vs_p2_x_offset = -170,

    -- 2P: P2 vertical offset from screen center. Positive moves the dancer downward.
    vs_p2_y_offset = 150,
}

-- -----------------------------------------------------------------------

local player = ...
local pn = ToEnumShortString(player)
local dancer = SL and SL[pn] and SL[pn].ActiveModifiers and
                   SL[pn].ActiveModifiers.Dancer
if dancer == "None" or dancer == nil then return end

local ps = GAMESTATE:GetPlayerState(player)
local sp = ps and ps:GetSongPosition()

-- -----------------------------------------------------------------------
-- Safe accessors 

local function SafePrefCenter1Player()
    if PREFSMAN and type(PREFSMAN.GetPreference) == "function" then
        return PREFSMAN:GetPreference("Center1Player") == true
    end
    return false
end

local function SafeNotefieldX(p)
    if type(GetNotefieldX) == "function" then
        local x = GetNotefieldX(p)
        if type(x) == "number" then return x end
    end

    local humans = #GAMESTATE:GetHumanPlayers()
    if humans == 1 then
        return (p == PLAYER_1) and (SCREEN_CENTER_X - 143) or
                   (SCREEN_CENTER_X + 143)
    else
        return (p == PLAYER_1) and (SCREEN_CENTER_X - 70) or
                   (SCREEN_CENTER_X + 70)
    end
end

local function IsDoubleLike()
    local style = GAMESTATE:GetCurrentStyle()
    local st = style and style:GetStyleType() or nil
    return (st == "StyleType_OnePlayerTwoSides" or st ==
               "StyleType_TwoPlayersSharedSides")
end

-- -----------------------------------------------------------------------
-- Position logic

local function GetDancerXY(p)
    local humans = #GAMESTATE:GetHumanPlayers()
    local nf_x = SafeNotefieldX(p)
    local centered_field = (humans == 1) and
                               (SafePrefCenter1Player() or IsDoubleLike())

    if humans == 1 then
        if centered_field then
            return nf_x + DancerPositionOffset.centered_x_offset,
                   SCREEN_CENTER_Y + DancerPositionOffset.centered_y_offset
        else
            return nf_x + DancerPositionOffset.single_x_offset,
                   SCREEN_CENTER_Y + DancerPositionOffset.single_y_offset
        end
    else
        if p == PLAYER_1 then
            return nf_x + DancerPositionOffset.vs_p1_x_offset,
                   SCREEN_CENTER_Y + DancerPositionOffset.vs_p1_y_offset
        else
            return nf_x + DancerPositionOffset.vs_p2_x_offset,
                   SCREEN_CENTER_Y + DancerPositionOffset.vs_p2_y_offset
        end
    end
end

local dx, dy = GetDancerXY(player)

local actor = Def.Sprite {
    Texture = "/" .. THEME:GetCurrentThemeDirectory() .. "Dancers/" .. dancer,

    InitCommand = function(self) self:xy(dx, dy) end,

    OnCommand = function(self) self:queuecommand("Tick") end,

    TickCommand = function(self)
        self._num_states = self._num_states or (self:GetNumStates() or 1)
        local n = self._num_states
        if n <= 1 or not sp then
            self:sleep(0.25):queuecommand("Tick")
            return
        end

        local bps = sp:GetCurBPS()
        if not bps or bps <= 0 then
            self:sleep(0.25):queuecommand("Tick")
            return
        end

        local beats_per_cycle = 4
        local beat = sp:GetSongBeatVisible() or 0

        local q = math.max(1 / 16, beats_per_cycle / (n * 4))
        local qbeat = math.floor(beat / q + 1e-6) * q

        self:animate(false)

        local phase = (qbeat / beats_per_cycle) % 1
        local idx = math.floor(phase * n)
        if idx < 0 then idx = 0 end
        if idx >= n then idx = n - 1 end

        if idx ~= self._last_idx then
            self._last_idx = idx
            self:setstate(idx)
        end

        local next = (math.floor(beat / q + 1e-6) + 1) * q
        local dt = (next - beat) / bps
        if dt < 0.005 then dt = 0.005 end
        if dt > 0.05 then dt = 0.05 end

        self:sleep(dt):queuecommand("Tick")
    end
}

return actor
