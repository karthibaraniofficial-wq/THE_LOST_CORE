# Phase 3 Automated Test Report — FUNOBOTZ: The Lost Core

**Game**: FUNOBOTZ: THE LOST CORE  
**Engine**: Godot 4.7.2  
**Test Suite**: `res://scripts/tests/test_phase3_vertical_slice.gd`  
**Execution Timestamp**: September 18, 2026  
**Result**: **15 / 15 TESTS PASSING (100% SUCCESS)**

---

## 1. Test Suite Overview

The Phase 3 test suite performs automated end-to-end unit and integration testing against live instantiated nodes in the Godot scene graph, verifying state transitions, companion selection, obstacle consequence mechanics, and victory conditions.

---

## 2. Test Execution Results

| Test # | Test Name | Assertion Target | Status | Execution Details |
| :---: | :--- | :--- | :---: | :--- |
| **01** | `test_initial_mission_state` | Mission starts at `MISSION_NOT_STARTED (0)` | **PASS** | `assert_eq(mission_manager.current_state, 0)` |
| **02** | `test_beacon_trigger_activates_mission` | Beacon entry sets `MISSION_ACTIVE (1)` | **PASS** | Area3D body entry triggers state update |
| **03** | `test_all_four_funobotz_spawned` | 4 companions present in scene graph | **PASS** | Quacky, Petalo, Tiko, Tolly confirmed valid |
| **04** | `test_hotkey_assignment` | `[1]=Petalo, [2]=Quacky, [3]=Tiko, [4]=Tolly` | **PASS** | Companion manager slots match specification |
| **05** | `test_companion_switching` | Slot selection updates active companion | **PASS** | `select_companion(1)` sets Petalo as active |
| **06** | `test_quacky_bramble_clearing` | Quacky ability removes bramble collision | **PASS** | Bramble shape disabled, state = `FOREST_OBJECTIVE` |
| **07** | `test_tiko_bridge_activation` | Tiko ability extends rainbow bridge mesh | **PASS** | Bridge collider active, state = `BRIDGE_OBJECTIVE` |
| **08** | `test_petalo_cave_illumination` | Petalo ability excites cave rune switch | **PASS** | Rune emissive = true, state = `CAVE_OBJECTIVE` |
| **09** | `test_tolly_vault_unlock` | Tolly ability unlocks ancient vault gate | **PASS** | Gate height animated, state = `VAULT_OBJECTIVE` |
| **10** | `test_core_altar_recovery` | Player altar entry collects Lost Core | **PASS** | Core mesh hidden, altar `is_collected` = true |
| **11** | `test_victory_state_transition` | Collecting core triggers `MISSION_COMPLETE (7)` | **PASS** | `assert_eq(mission_manager.current_state, 7)` |
| **12** | `test_hud_banner_display` | CompleteBanner visibility toggles on victory | **PASS** | HUD banner visible in viewport |
| **13** | `test_wrong_companion_feedback` | Non-matching bot gives educational hint | **PASS** | Hint string populated in UI feedback |
| **14** | `test_bridge_hint_proximity` | Wrong companion near bridge prompts hint | **PASS** | Quacky near bridge mech returns mechanical hint |
| **15** | `test_backward_compatible_aliases` | Aliases `CORE_RECOVERED` & `BEACON_REACHED` work | **PASS** | Existing Phase 2 integration scripts remain functional |

---

## 3. Test Command Reproduction

To re-run this automated test suite at any time:
```powershell
& "C:\Users\Admin\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" `
  --path "E:\funobotz\game" `
  --headless `
  -s "res://scripts/tests/test_phase3_vertical_slice.gd"
```
**Output**: `[PASS] 15/15 Phase 3 vertical slice tests succeeded with 0 errors.`
