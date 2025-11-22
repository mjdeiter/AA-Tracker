local mq = require('mq')
local ImGui = require('ImGui')

local SCRIPT_VERSION = "1.1"  -- Updated version

local start_aa_total = 0
local start_aa_exp = 0
local start_time = 0
local paused_time = 0
local last_pause_time = 0
local tracking = false
local paused = false
local open = true
local terminate = false

-- Simple log function (can be expanded if needed)
local function logMessage(msg)
    print("\ay" .. msg)  -- Using yellow color for logs; adjust as needed
end

-- Display credit message and version
print("\atOriginally created by Alektra <Lederhosen>")
print("\agAA Tracker v" .. SCRIPT_VERSION .. " Loaded")
logMessage("Script started")

local function resetTracking()
    start_aa_total = mq.TLO.Me.AAPointsTotal()
    start_aa_exp = mq.TLO.Me.AAExp() / 100
    start_time = os.time()
    paused_time = 0
    last_pause_time = 0
    paused = false
    print("Tracking reset. AA Total: " .. start_aa_total .. ", AA Exp: " .. start_aa_exp .. "%, Time: " .. os.date('%H:%M:%S', start_time))
end

local function drawGUI()
    open, _ = ImGui.Begin('AA Tracker', open)
    if not open then
        ImGui.End()
        return
    end

    -- Display current AA points at the top
    local curr_aa_total = mq.TLO.Me.AAPointsTotal()
    local curr_aa_exp = mq.TLO.Me.AAExp() / 100
    local curr_aa_spent = mq.TLO.Me.AAPointsSpent()
    local curr_aa_unspent = mq.TLO.Me.AAPoints()
    
    ImGui.Text(string.format('Current AA Points: %d (%.2f%% toward next)', curr_aa_total, curr_aa_exp))
    ImGui.Text(string.format('Unspent: %d | Spent: %d', curr_aa_unspent, curr_aa_spent))
    ImGui.Separator()

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
            print('Reset performed.')
        else
            print('Cannot reset while tracking. Stop first.')
        end
    end
    ImGui.SameLine()
    if ImGui.Button('End') then
        terminate = true
        print('Script ending.')
    end

    ImGui.Separator()

    if tracking then
        local current_time = os.time()
        local adjusted_time = current_time - paused_time
        if paused then
            adjusted_time = adjusted_time - (current_time - last_pause_time)
        end
        local time_seconds = adjusted_time - start_time
        local time_hours = time_seconds / 3600
        local aa_points_gained = curr_aa_total - start_aa_total
        local aa_exp_gained = aa_points_gained * 100 + (curr_aa_exp - start_aa_exp)
        local partial_progress = (aa_points_gained > 0 and curr_aa_exp or (curr_aa_exp - start_aa_exp))
        local aa_per_hour = (time_hours > 0 and (aa_exp_gained / 100 / time_hours) or 0)
        local exp_per_hour = (time_hours > 0 and (aa_exp_gained / time_hours) or 0)

        ImGui.Text(string.format('AA Gained: %d (plus %.2f%% toward next)', aa_points_gained, partial_progress))
        ImGui.Text(string.format('Total Equivalent: %.2f AA', aa_exp_gained / 100))
        ImGui.Text(string.format('Time Elapsed: %.2f hours', time_hours))
        ImGui.Text(string.format('Rate: %.2f AA/hour (%.2f%%/hour)', aa_per_hour, exp_per_hour))
        if paused then
            ImGui.Text('Tracking is paused.')
        end
    else
        ImGui.Text('Tracking stopped. Press Start to begin a new session.')
    end

    ImGui.End()
end

local function closeGUI()
    terminate = true
    print("GUI termination triggered via /closegui.")
end

if ImGui then
    local success, err = pcall(mq.imgui.init, 'AATracker', drawGUI)
    if not success then
        print("Failed to initialize ImGui: " .. err)
        return
    end
    mq.bind('/closegui', closeGUI)
end

while mq.TLO.MacroQuest.GameState() == "INGAME" and not terminate do
    mq.doevents()
    mq.delay(1000)  -- Update every second
end

if ImGui then
    mq.imgui.destroy('AATracker')
    print("GUI destroyed.")
end
