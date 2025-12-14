AA Tracker Script for EverQuest (Project Lazarus Server)
Author

Alektra <Lederhosen>

Version

1.5 (December 13, 2025)

Description

This Lua script uses MacroQuest and ImGui to provide a graphical interface for tracking Alternate Advancement (AA) points gained during gameplay sessions. It displays real-time stats including AA points gained, progress toward the next AA, total equivalent AA, time elapsed, and rate per hour. Features include start/stop tracking, pause/resume functionality, reset options, and an end button to terminate the script.

Usage

Save this script as aa_tracker.lua in your MacroQuest scripts directory.

Load the script in-game with: /lua run aa_tracker

The ImGui window "AA Tracker" will appear with buttons for Start/Stop, Pause/Resume, Reset, and End.

Start tracking to begin monitoring AA gains.

Pause to temporarily halt time accumulation (e.g., for breaks).

Stop to end the session and view final stats.

Reset to clear data (only available when not tracking).

End to close the GUI and terminate the script (use /closegui as a fallback if needed).

Changelog
v1.5 – December 13, 2025

Added an option to hide the Announce All Guild button via a checkbox in the UI.

Improved UI flexibility for players who prefer not to use guild-wide announcements.

Minor internal cleanup and version labeling update.

v1.0 – September 27, 2025

Initial release.

Real-time AA tracking with start/stop, pause/resume, reset, and session statistics.

ImGui-based interface with elapsed time and AA rate calculations.

Requirements

MacroQuest (MQNext) with ImGui plugin enabled.

Project Lazarus server.

Notes

This script assumes AA experience is reported via mq.TLO.Me.AAExp() and mq.TLO.Me.AAPointsTotal().

If ImGui issues occur, verify plugin loading with /plugin ImGui.

Disclaimer

Use at your own risk; ensure compliance with Project Lazarus rules regarding macros and scripts.
