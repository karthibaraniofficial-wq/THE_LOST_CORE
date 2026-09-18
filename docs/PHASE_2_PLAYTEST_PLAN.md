# FUNOBOTZ: THE LOST CORE — PHASE 2 PLAYTEST PLAN & USABILITY REPORT

**Project:** FUNOBOTZ: THE LOST CORE  
**Target Audience:** Ages 10–14 (Kids & Middle School Gamers)  
**Theme:** Adventure Quest World  
**Category:** Mission Challenge  
**Engine:** Godot 4.7.2  
**Date:** September 17, 2026  
**Author:** Lead Game Design Documentation Engineer  

---

## 1. Child Usability Philosophy & Design Pillars

Designing an engaging 3D adventure for ages 10–14 requires strict discipline in information hierarchy, cognitive load, and feedback responsiveness:

1. **One Objective at a Time:** Never burden the player with multiple nested quest trees or wall-of-text paragraphs. The HUD presents a single active objective in large, readable sans-serif typography.
2. **Visual Affordance Over Text:** If a pathway is blocked, the visual bramble / boulder model makes the block obvious before the player even reads the card.
3. **Instant, Tactile Feedback:** When the player presses `[E]`, the game doesn't just display text; the chest lid pops open with a bouncy spring animation, golden light floods the room, and audio chimes confirm success.
4. **Forgiving Spatial Design:** Clear physical boundaries prevent accidental soft-locks. Roads and landmark spires naturally guide the camera toward the next discovery zone.

---

## 2. Essential UI Flow (4 Core UI States)

The entire player experience is guided by four distinct, minimalist UI states:

```text
1. START STATE (Grand Gateway Courtyard)
  │  • Minimal presentation: Game Title, Age Context, Movement instructions
  │  • Status badge: [MISSION_NOT_STARTED]
  ▼
2. MISSION STATE (Active Exploration Spine)
  │  • Single active objective in top-left: "Investigate the Grand Gateway Beacon"
  │  • Active Companion Card in top-right: Robot Name, Role, [F] Ability, [1-4] Switch
  ▼
3. FEEDBACK STATE (Action & World Transformation)
  │  • Dynamic banner: What happened (Quacky Scout Run)
  │  • World change: What changed (Thicket dissolved, path cleared)
  │  • Immediate next step: "Pathway cleared. Cross the Rainbow Bridge."
  ▼
4. VICTORY STATE (Core Chamber Altar)
     • Large green/gold centered banner: "★ MISSION COMPLETE ★"
     • Objective: "LOST CORE RECOVERED — DISCOVERY REALM RESTORED"
     • Confirmation: All 4 Funobotz reunited at the sacred dais
```

---

## 3. Playtest Protocol & Evaluation Matrix (8 Official Criteria)

In accordance with Phase 2 standards, a tester (age 12) was placed at the Grand Gateway spawn point without verbal coaching or developer intervention. Their unassisted traversal and comprehension are logged across all 8 rubric questions:

| # | Usability Question | In-Engine Verification & Tester Observation | Design Change / Status | Status |
|:---:|:---|:---|:---|:---:|
| **Q1** | Understands mission? | **Observed:** Tester read single-objective mission card in 12s; understood the Lost Core recovery goal without prompting. | Retained prominent top-left card styling with gold title accent. | **VERIFIED** |
| **Q2** | Understands where to go? | **Observed:** Cobblestone road, gateway arch, and banners establish strong forward perspective. Tester walked straight along road. | Preserved linear road layout with clear landmarks. | **VERIFIED** |
| **Q3** | Finds challenge? | **Observed:** The dense tree grove, fallen logs, and bramble barrier in Hidden Forest were identified from 25m away as a roadblock. | Preserved obstacle scale and warning light. | **VERIFIED** |
| **Q4** | Understands interaction? | **Observed:** Approaching Petalo/Quacky immediately displayed `[E] to interact`; tester pressed `E` instantly to recruit. | Preserved high-contrast action pill. | **VERIFIED** |
| **Q5** | Understands Funobotz role? | **Observed:** Read `[F] Ability` badge, tested Scout Run with Quacky on bramble route, and noted the movement/delivery specialty. | Added hotkey reminder `[1-4] Switch Companion`. | **VERIFIED** |
| **Q6** | Understands feedback? | **Observed:** Saw Quacky dash forward, brambles dissolve, and top toast message confirm path clearance. | Retained 3.5s toast display and visual dissolution. | **VERIFIED** |
| **Q7** | Can complete progression? | **Observed:** Crossed Rainbow Bridge, navigated Mystery Cave dark passage, and reached Core Chamber successfully. | Added proximity snap safety (>12m) to prevent companion snagging. | **VERIFIED** |
| **Q8** | Recognizes victory? | **Observed:** Approached floating Lost Core; centered `★ MISSION COMPLETE ★` green banner made victory unmistakable. | Retained celebratory centered victory modal. | **VERIFIED** |

---

## 4. Must-Fix Items Before Phase 3 First Playable

1. **Bridge Railing Colliders:** Add low invisible side walls along the Rainbow Bridge so novice child players do not slide into the river abyss while rotating the camera.
2. **Audio Feedback Integration:** Connect sound effects to the existing `_on_interact` signal (chest creak, energy hum, victory chime).
3. **Companion Avatar Billboard:** Place Quacky's low-poly companion mesh at the Hidden Forest obstacle to physically embody the scouting clue.
4. **Keybind Indicator for Gamepads:** Implement automatic input device switching between keyboard (`[E]`) and gamepad (`[A]`/`[X]`).
