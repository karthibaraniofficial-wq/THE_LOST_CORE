# Phase 3 Rubric Evidence Matrix — FUNOBOTZ: The Lost Core

**Project**: FUNOBOTZ: THE LOST CORE  
**Engine**: Godot 4.7.2 Forward+ Engine  
**Evaluation Scope**: 35 Marks across 8 Criteria  
**Methodology**: Grounded Technical Evidence (Zero Self-Assigned Numerical Scores)  
**Date**: September 18, 2026  

---

## 1. Criterion 1: Playability & Stability (7 Marks Total Allocation)

### Evaluator Evaluation Focus
- Does the game boot immediately without crashes or missing resource warnings?
- Is framerate stable (>= 60 FPS) with frame times under 16.6ms?
- Do controls respond with zero input latency?
- Are there any softlocks or breaking physics collisions?

### Documented Technical Evidence
1. **Zero-Error Engine Boot**:
   - Clean execution log without missing `.tscn`, `.gd`, or resource reference warnings.
   - Command: `Godot_v4.7.2-stable_win64_console.exe --path "E:\funobotz\game" "res://scenes/main_world.tscn"`.
2. **Stable 60.0 FPS Profile**:
   - Measured average frame time: `7.8 ms` (CPU: `3.2 ms`, GPU: `4.6 ms`).
   - Peak frame time during complex scene transitions: `11.2 ms` (remains well under 16.6 ms budget).
   - Documented in: [`PHASE_3_PERFORMANCE_REPORT.md`](file:///E:/funobotz/game/docs/PHASE_3_PERFORMANCE_REPORT.md).
3. **Collision & Softlock Prevention**:
   - Rigorous collision matrix: Layer 1 (Static Terrain), Layer 2 (Player CharacterBody3D), Layer 3 (Kinematic Companions), Layer 4 (Obstacles).
   - Automated 15-test suite confirms zero softlocks across full state lifecycle.
   - Documented in: [`PHASE_3_TEST_REPORT.md`](file:///E:/funobotz/game/docs/PHASE_3_TEST_REPORT.md).
4. **Visual Evidence**:
   - Startup snapshot: [`01_startup.png`](file:///E:/funobotz/game/docs/snaps/01_startup.png).
   - Gateway beacon: [`02_gateway_beacon.png`](file:///E:/funobotz/game/docs/snaps/02_gateway_beacon.png).

---

## 2. Criterion 2: Discovery World Integration (6 Marks Total Allocation)

### Evaluator Evaluation Focus
- Is the 3D environment cohesive in art direction, palette, and lighting?
- Do environment props feel natural to the world rather than scattered assets?
- Does lighting guide the player through the level organically?

### Documented Technical Evidence
1. **Art Style & Asset Palette Cohesion**:
   - Uniform low-poly stylized art direction utilizing warm primary colors, gentle stone textures, and pastel green foliage.
   - Asset audit verified 100% of meshes originate from internal library `E:\funobotz\asserts`.
   - Documented in: [`PHASE_3_ASSET_REPORT.md`](file:///E:/funobotz/game/docs/PHASE_3_ASSET_REPORT.md).
2. **Directional Lighting & Atmosphere**:
   - DirectionalLight3D configured with soft 2K cascade shadow mapping.
   - Atmospheric fog and sky shader tuned to daytime exploration ambiance.
3. **Visual Evidence**:
   - Discovery World vista: [`04_discovery_world_vista.png`](file:///E:/funobotz/game/docs/snaps/04_discovery_world_vista.png).
   - Funobotz Hub plaza: [`03_funobotz_hub.png`](file:///E:/funobotz/game/docs/snaps/03_funobotz_hub.png).

---

## 3. Criterion 3: Gameplay / Decision Quality (6 Marks Total Allocation)

### Evaluator Evaluation Focus
- Are player choices meaningful and rooted in understanding rather than random trial-and-error?
- Does deploying a companion produce immediate, tangible cause-and-effect in the 3D world?
- Does the game provide constructive feedback when an incorrect robot is chosen?

### Documented Technical Evidence
1. **Distinct STEAM Companion Roles**:
   - `[1] Petalo`: Light & Signalling (illuminates dark cavern, activates photosensitive rune switch).
   - `[2] Quacky`: Movement & Delivery (scouting dash, dissolves dense forest brambles).
   - `[3] Tiko`: Object Manipulation (rotates gears, extends mechanical rainbow bridge).
   - `[4] Tolly`: Tollgate & Access (authenticates security terminal, lowers vault gate).
2. **In-World Physical Consequences**:
   - Selecting the correct companion immediately triggers 3D animation, particle burst, sound effect, and removes physical collision shapes.
3. **Educational Wrong-Bot Feedback**:
   - Testing wrong robot against an obstacle does not fail silently; dynamic in-game banners explain *why* the tool is mismatched, fostering deductive reasoning.
4. **Visual & Code Evidence**:
   - Code: `res://scripts/funobotz/companion_manager.gd`, `res://scripts/mission/mission_manager.gd`.
   - Bramble solved: [`07_bramble_cleared.png`](file:///E:/funobotz/game/docs/snaps/07_bramble_cleared.png).
   - Rainbow bridge extended: [`09_bridge_active.png`](file:///E:/funobotz/game/docs/snaps/09_bridge_active.png).
   - Cave rune illuminated: [`11_cave_rune_active.png`](file:///E:/funobotz/game/docs/snaps/11_cave_rune_active.png).
   - Vault gate unlocked: [`13_vault_gate_open.png`](file:///E:/funobotz/game/docs/snaps/13_vault_gate_open.png).

---

## 4. Criterion 4: Fun & Replayability (5 Marks Total Allocation)

### Evaluator Evaluation Focus
- Is the gameplay loop engaging and satisfying for 10–14 year olds?
- Is there a clear sense of progression, discovery, and reward?
- Does audio-visual feedback create satisfying game feel?

### Documented Technical Evidence
1. **Dynamic Audio-Visual Feedback**:
   - Audio volume analysis confirmed -17.2 dB normalized mean volume with zero clipping across 8,259,584 samples.
   - Dedicated sound effects for robot dashing, gear turning, luminescent humming, gate sliding, and victory fanfare.
2. **Rewarding Climax & Complete Banner**:
   - Altar collection triggers celebratory particle burst, camera sweep, and `★ MISSION COMPLETE ★` banner.
3. **Visual Evidence**:
   - Core Chamber approach: [`14_core_chamber.png`](file:///E:/funobotz/game/docs/snaps/14_core_chamber.png).
   - Lost Core Altar: [`15_lost_core_altar.png`](file:///E:/funobotz/game/docs/snaps/15_lost_core_altar.png).
   - Victory state: [`16_victory.png`](file:///E:/funobotz/game/docs/snaps/16_victory.png) and [`video_verify_09_victory.png`](file:///E:/funobotz/game/docs/snaps/video_verify_09_victory.png).

---

## 5. Criterion 5: Category Excellence — Mission Challenge (4 Marks Total Allocation)

### Evaluator Evaluation Focus
- Does the game fulfill the specific "Mission Challenge" hackathon brief?
- Is there an explicit mission objective, active tracking, and definitive victory criteria?

### Documented Technical Evidence
1. **Authoritative Mission State Machine**:
   - `res://scripts/mission/mission_manager.gd` implements an 8-state sequence (`MISSION_NOT_STARTED` to `MISSION_COMPLETE`).
2. **Persistent HUD Objective Tracker**:
   - On-screen HUD updates dynamically from *"Investigate the Grand Gateway Beacon"* to individual sub-objectives, concluding with *"Mission Accomplished! The Discovery World is saved!"*.
3. **Visual Evidence**:
   - Top-left HUD tracker visible in all 16 live screenshots and video milestone frames.

---

## 6. Criterion 6: Innovation (3 Marks Total Allocation)

### Evaluator Evaluation Focus
- Does the game introduce novel mechanics or pedagogical approaches?
- How does it blend physical computing / robotics metaphors with 3D adventure gameplay?

### Documented Technical Evidence
1. **STEAM Robotics Metaphors**:
   - Funobot companions represent foundational concepts in robotics and automation: optical sensing, kinematic velocity, mechanical transmission, and access control.
2. **Deterministic Movie Writer Capture Pipeline**:
   - Innovation in QA and video verification: utilizing Godot's internal deterministic frame-stepping movie maker mode coupled with static FFmpeg transcoding to generate flawless 30 FPS video evidence without external screen recording lag.

---

## 7. Criterion 7: Product Feasibility (2 Marks Total Allocation)

### Evaluator Evaluation Focus
- Is the game architecture realistic for expansion into a full commercial or classroom product?
- Can new content, levels, and robots be added easily?

### Documented Technical Evidence
1. **Modular Base Classes**:
   - `base_funobot.gd` and modular obstacle controllers allow non-programmers to create new robots and obstacles by simply creating inherited scenes.
2. **Resource Efficiency**:
   - Total build size under 250 MB; VRAM footprint under 450 MB; runs smoothly on standard classroom laptops without discrete GPUs.
   - Documented in: [`PHASE_3_KNOWN_LIMITATIONS.md`](file:///E:/funobotz/game/docs/PHASE_3_KNOWN_LIMITATIONS.md).

---

## 8. Criterion 8: Team Ownership / Understanding (2 Marks Total Allocation)

### Evaluator Evaluation Focus
- Does the team demonstrate complete mastery over the codebase, architecture, and design decisions?
- Is documentation thorough, structured, and auditable?

### Documented Technical Evidence
1. **Comprehensive Documentation Suite**:
   - Complete technical documentation spanning 14 dedicated markdown reports in `E:\funobotz\game\docs/`.
2. **Automated Verification Reproducibility**:
   - All tests, captures, and builds can be run autonomously via standard command-line scripts without proprietary black-box tooling.
   - Documented in: [`TEAM_OWNERSHIP_GUIDE.md`](file:///E:/funobotz/game/docs/TEAM_OWNERSHIP_GUIDE.md) and [`EVALUATOR_QUICK_START.md`](file:///E:/funobotz/game/docs/EVALUATOR_QUICK_START.md).
