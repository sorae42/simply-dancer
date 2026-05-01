-- option doesn't exist in Casual mode so don't bother
if SL and SL.Global and SL.Global.GameMode == "Casual" then return end

local player = ...
local pn = ToEnumShortString(player)
local dancer = SL and SL[pn] and SL[pn].ActiveModifiers and
                   SL[pn].ActiveModifiers.Dancer
if dancer == "None" or dancer == nil then return end

local ps = GAMESTATE:GetPlayerState(player)
local sp = ps and ps:GetSongPosition()
local beats_per_measure = 4

-- -----------------------------------------------------------------------
-- Safe accessors (never crash)

local function SafePrefCenter1Player()
    if PREFSMAN and type(PREFSMAN.GetPreference) == "function" then
        return PREFSMAN:GetPreference("Center1Player") == true
    end
    return false
end

local function SafeNotefieldWidth()
    if type(GetNotefieldWidth) == "function" then
        local w = GetNotefieldWidth()
        if type(w) == "number" then return w end
    end
    -- dance single default-ish
    return 256
end

local function SafeNotefieldX(p)
    -- If SL helper exists, use it.
    if type(GetNotefieldX) == "function" then
        local x = GetNotefieldX(p)
        if type(x) == "number" then return x end
    end

    -- Fallback: mimic SL-ish metrics for single/versus
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
    local nf_w = SafeNotefieldWidth()

    local centered_field = (humans == 1) and
                               (SafePrefCenter1Player() or IsDoubleLike())

    -- Tune knobs (safe constants)
    local y = SCREEN_CENTER_Y + 100

    local pane_push = math.floor((nf_w * 0.60) + 100)
    local centered_inset = 100

    if humans == 1 then
        local dir = (p == PLAYER_1) and 1 or -1
        local x = nf_x + dir * pane_push

        if centered_field then x = x - dir * centered_inset + 20 end

        return x, y
    else
        local toward_center = 170
        if p == PLAYER_1 then
            return nf_x + toward_center, y + 50
        else
            return nf_x - toward_center, y + 50
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

        local beats_per_cycle = math.max(1, n / 2)

        local delay = (beats_per_cycle / bps) / n
        if delay < 1 / 120 then delay = 1 / 120 end
        if delay > 1 / 6 then delay = 1 / 6 end

        if not self._anim_started then
            self._anim_started = true
            self:animate(true)
        end

        if delay ~= self._last_delay then
            self._last_delay = delay
            self:SetAllStateDelays(delay)
        end

        self:sleep(0.05):queuecommand("Tick")
    end
}

return actor
