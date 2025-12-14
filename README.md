[![Support](https://img.shields.io/badge/Support-Buy%20Me%20a%20Coffee-yellow)](https://buymeacoffee.com/shablagu)


# AA Tracker Script for EverQuest (Project Lazarus Server)

---

## Credits
**Created by:** Alektra  
**For:** Project Lazarus EverQuest EMU Server  
**Support:** https://buymeacoffee.com/shablagu

---

## Version
**1.5 (December 13, 2025)**

---

## Description
This Lua script uses MacroQuest and ImGui to provide a graphical interface for tracking Alternate Advancement (AA) points gained during gameplay sessions.

It displays real-time statistics including:

- AA points gained
- Progress toward the next AA
- Total equivalent AA
- Time elapsed
- AA gain rate per hour

The script includes controls for starting and stopping tracking sessions, pausing and resuming time accumulation, resetting data, and cleanly terminating the script.

---

## Usage
1. Save this script as `aa_tracker.lua` in your MacroQuest scripts directory.
2. Load the script in-game with:
   ```
   /lua run aa_tracker
   ```
3. The ImGui window **AA Tracker** will appear.
4. Use **Start** to begin tracking AA gains.
5. Use **Pause** to temporarily halt time accumulation (for breaks or downtime).
6. Use **Stop** to end the current tracking session.
7. Use **Reset** to clear tracking data (only available when not tracking).
8. Use **End** to close the GUI and terminate the script.
   - `/closegui` can be used as a fallback.

---

## Changelog

### v1.5 – December 13, 2025
- Added a UI checkbox to hide the **Announce All Guild** button.
- Allows users to disable guild-wide announcements without modifying the script.
- Minor internal cleanup and version labeling update.

### v1.0 – September 27, 2025
- Initial release.
- Real-time AA tracking with start/stop functionality.
- Pause and resume support.
- Reset and session statistics.
- ImGui-based user interface.

---

## Requirements
- MacroQuest (MQNext) with ImGui plugin enabled.
- Project Lazarus server.

---

## Notes
- This script assumes AA experience is reported via:
  - `mq.TLO.Me.AAExp()`
  - `mq.TLO.Me.AAPointsTotal()`
- If ImGui does not appear, verify the plugin is loaded:
  ```
  /plugin ImGui
  ```

---

## Disclaimer
Use at your own risk.

Ensure compliance with Project Lazarus rules regarding macros, automation, and scripting.
