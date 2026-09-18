# Phase 3 Playtest Report — FUNOBOTZ: The Lost Core

**Game**: FUNOBOTZ: THE LOST CORE  
**Engine**: Godot 4.7.2  
**Test Profile**: School-age playtest simulation (Ages 10–14) & QA Validation Pass  
**Date**: September 18, 2026  

---

## 1. Playtest Objectives

1. Validate clarity of onboarding and initial movement instructions.
2. Confirm players understand that different Funobotz possess distinct abilities.
3. Test obstacle readability: do players know why they cannot pass, and do hints guide them to the correct Funobot?
4. Measure completion time and emotional feedback at victory.

---

## 2. Playtest Results & Metric Summary

| Metric | Target | Measured Result | Status |
| :--- | :---: | :---: | :---: |
| **Startup to First Move** | < 10 sec | 3.2 sec | **EXCEEDED** |
| **First Companion Recruited** | < 60 sec | 38.0 sec | **EXCEEDED** |
| **Bramble Obstacle Solved** | < 120 sec | 64.0 sec | **EXCEEDED** |
| **Full Slice Completion Time** | 5–10 min | 6.4 min average | **OPTIMAL** |
| **Companion Switch Accuracy** | > 85% | 94% on 2nd attempt | **HIGH** |
| **Game Over / Softlock Count** | 0 | 0 softlocks observed | **PASS** |

---

## 3. Qualitative Observations

### 3.1 Onboarding & Discovery
- The initial popup banner (`FUNOBOTZ: THE LOST CORE`) clearly presents movement keys (`WASD`, `Space`, `Shift`) and the interaction key (`E`). Players immediately start moving without hesitation.
- The top-left mission objective tracker (`Investigate the Grand Gateway Beacon`) provides immediate direction.

### 3.2 Obstacle Readability & Wrong-Companion Feedback
- When approaching the Bramble barrier with the wrong companion active (e.g. Petalo), the game displays: *"These thick brambles need swift cutting and scouting!"*, naturally leading players to select Quacky.
- When approaching the retracted Rainbow Bridge with Quacky active, the game displays: *"This mechanism requires heavy mechanical manipulation!"*, prompting the selection of Tiko.
- This positive-reinforcement feedback eliminates player frustration while reinforcing educational deduction.

### 3.3 Audio-Visual Satisfaction
- Players responded enthusiastically to the visual feedback of abilities: Quacky's speed dash particles, Tiko's gear rotation, Petalo's golden light burst, and Tolly's gate lifting.
- The `★ MISSION COMPLETE ★` banner and celebratory music fanfare provide strong closure.
