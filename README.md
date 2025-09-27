# AA Tracker Script for EverQuest (Project Lazarus Server)

## Author
Alektra <Lederhosen>

## Version
1.0 (September 27, 2025)

## Description
This Lua script uses MacroQuest and ImGui to provide a graphical interface for tracking Alternate Advancement (AA) points gained during gameplay sessions. It displays real-time stats including AA points gained, progress toward the next AA, total equivalent AA, time elapsed, and rate per hour. Features include start/stop tracking, pause/resume functionality, reset options, and an end button to terminate the script.

## Usage
1. Save this script as `aa_tracker.lua` in your MacroQuest scripts directory.
2. Load the script in-game with: `/lua run aa_tracker`
3. The ImGui window "AA Tracker" will appear with buttons for Start/Stop, Pause/Resume, Reset, and End.
4. Start tracking to begin monitoring AA gains.
5. Pause to temporarily halt time accumulation (e.g., for breaks).
6. Stop to end the session and view final stats.
7. Reset to clear data (only available when not tracking).
8. End to close the GUI and terminate the script (use `/closegui` as a fallback if needed).

## Requirements
- MacroQuest with ImGui plugin enabled and functional.

## Notes
- This script assumes AA experience is reported via `mq.TLO.Me.AAExp()` and `mq.TLO.Me.AAPointsTotal()`. Adjust if your server differs.
- If ImGui issues occur, check plugin loading with `/plugin ImGui`.

## Disclaimer
Use at your own risk; ensure compliance with server rules regarding macros and scripts.
