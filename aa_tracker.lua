local mq = require('mq')
local ImGui = require('ImGui')

local SCRIPT_VERSION = "1.5"  -- Updated version

local start_aa_total = 0
local start_aa_exp = 0
local start_time = 0
local paused_time = 0
local last_pause_time = 0
local tracking = false
local paused = false
local open = true
local terminate = false
local show_current_aa = true

-- Hide guild announce button toggle (DEFAULT = ON)
local hide_guild_announce = true

-- Simple log function
local function logMessage(msg)
    print("\ay" .. msg)
end

print("\atAA Tracker v" .. SCRIPT_VERSION)
print("\atOriginally created by Alektra <Lederhosen>")
logMessage("Script started")

local function resetTracking()
    start_aa_total = mq.TLO.Me.AAPointsTotal()
    start_aa_exp = mq.TLO.Me.AAExp() / 100
    start_time = os.time()
    paused_time = 0
    last_pause_time = 0
    paused = false
    print("Tracking reset. AA Total: " .. start_aa_total .. ", AA Exp: " .. start_aa_exp .. "%")
end

local function announceAllGroup()
    mq.cmd('/noparse /e3bcga /gsay ${Me.Name} - Unspent AA: ${Me.AAPoints} | Spent: ${Me.AAPointsSpent}')
    print('Sent announce command to all group members via /e3bcga')
end

local function announceAllGuild()
    mq.cmd('/noparse /e3bcga /guildsay ${Me.Name} - Unspent AA: ${Me.AAPoints} | Spent: ${Me.AAPointsSpent}')
    print('Sent announce command to all guild members via /e3bcga')
end

local function drawGUI()
    open, _ = ImGui.Begin('AA Tracker v' .. SCRIPT_VERSION, open)
    if not open then
        ImGui.End()
        return
    end

    -- Show / Hide Current AA section
    if ImGui.Button(show_current_aa and 'Hide Current AA' or 'Show Current AA') then
        show_current_aa = not show_current_aa
    end

    ImGui.Separator()

    -- Hide Guild Announce checkbox (Lazarus-safe)
    local cb = ImGui.Checkbox('Hide Guild Announce Button', hide_guild_announce)
    if type(cb) == 'boolean' then
        hide_guild_announce = cb
    end

    ImGui.Separator()

    -- Announce buttons
    if ImGui.Button('Announce All Group') then
        announceAllGroup()
    end

    if not hide_guild_announce then
        ImGui.SameLine()
        if ImGui.Button('Announce All Guild') then
            announceAllGuild()
        end
    end

    ImGui.Separator()

    -- Current AA display
    if show_current_aa then
        local curr_aa_total = mq.TLO.Me.AAPointsTotal()
        local curr_aa_exp = mq.TLO.Me.AAExp() / 100
        local curr_aa_spent = mq.TLO.Me.AAPointsSpent()
        local curr_aa_unspent = mq.TLO.Me.AAPoints()

        ImGui.Text(string.format(
            'Current AA Points: %d (%.2f%% toward next)',
            curr_aa_total,
            curr_aa_exp
        ))
        ImGui.Text(string.format(
            'Unspent: %d | Spent: %d',
            curr_aa_unspent,
            curr_aa_spent
        ))
        ImGui.Separator()
    end

    -- Tracking controls
    if ImGui.Button(tracking and 'Stop' or 'Start') then
        if not tracking then
            resetTracking()
            tracking = true
            print('Tracking started.')
        else
            tracking = false
            print('Tracking stopped.')
        end
    end

    ImGui.SameLine()

    if tracking then
        if ImGui.Button(paused and 'Resume' or 'Pause') then
            if paused then
                paused_time = paused_time + (os.time() - last_pause_time)
                paused = false
                print('Tracking resumed.')
            else
                last_pause_time = os.time()
                paused = true
                print('Tracking paused.')
            end
        end
    end

    ImGui.SameLine()

    if ImGui.Button('Reset') then
        if not tracking then
            resetTracking()
        else
            print('Stop tracking before resetting.')
        end
    end

    ImGui.SameLine()

    if ImGui.Button('End') then
        terminate = true
        print('Script ending.')
    end

    ImGui.Separator()

    -- Tracking stats
    if tracking then
        local curr_aa_total = mq.TLO.Me.AAPointsTotal()
        local curr_aa_exp = mq.TLO.Me.AAExp() / 100
        local now = os.time()

        local adjusted_time = now - paused_time
        if paused then
            adjusted_time = adjusted_time - (now - last_pause_time)
        end

        local elapsed = adjusted_time - start_time
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)

        local gained = curr_aa_total - start_aa_total
        local gained_exp = gained * 100 + (curr_aa_exp - start_aa_exp)

        local rate = (elapsed > 0) and ((gained_exp / 100) / (elapsed / 3600)) or 0

        ImGui.Text(string.format('AA Gained: %d', gained))
        ImGui.Text(string.format('Time Elapsed: %02d:%02d', hours, minutes))
        ImGui.Text(string.format('Rate: %.2f AA/hour', rate))

        if paused then
            ImGui.Text('Tracking is paused.')
        end
    else
        ImGui.Text('Tracking stopped.')
    end

    ImGui.End()
end

local function closeGUI()
    terminate = true
    print("GUI termination triggered.")
end

local success, err = pcall(mq.imgui.init, 'AATracker', drawGUI)
if not success then
    print("Failed to initialize ImGui: " .. err)
    return
end

mq.bind('/closegui', closeGUI)

while mq.TLO.MacroQuest.GameState() == "INGAME" and not terminate do
    mq.doevents()
    mq.delay(1000)
end

mq.imgui.destroy('AATracker')
print("GUI destroyed.")
