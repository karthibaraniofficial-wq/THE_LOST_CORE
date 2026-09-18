# Phase 3 Technical Architecture Report — FUNOBOTZ: The Lost Core

**Game**: FUNOBOTZ: THE LOST CORE  
**Engine**: Godot 4.7.2 Forward+ (Vulkan 1.3 Desktop Renderer)  
**Architecture Pattern**: Modular Node Composition with Centralized Event/State Dispatch  

---

## 1. System Architecture

```text
                                 ┌────────────────────────┐
                                 │   game_manager.gd      │
                                 │ (Global Game State)    │
                                 └───────────┬────────────┘
                                             │
               ┌─────────────────────────────┼─────────────────────────────┐
               ▼                             ▼                             ▼
   ┌───────────────────────┐    ┌───────────────────────┐    ┌───────────────────────┐
   │  mission_manager.gd   │    │ companion_manager.gd  │    │      hud.gd           │
   │  - Discrete State Enum│    │  - Active Companion   │    │  - Mission Objective  │
   │  - Zone Tracking      │    │  - Ability Cooldowns  │    │  - Companion Cards    │
   │  - Signal Bus         │    │  - Hotkey Dispatch    │    │  - CompleteBanner     │
   └───────────┬───────────┘    └───────────┬───────────┘    └───────────────────────┘
               │                             │
               ▼                             ▼
   ┌───────────────────────┐    ┌───────────────────────┐
   │ In-World Obstacles    │    │ Funobot Nodes         │
   │  - forest_bramble.gd  │◄───┤  - petalo.gd          │
   │  - bridge_mechanic.gd │◄───┤  - quacky.gd          │
   │  - cave_rune.gd       │◄───┤  - tiko.gd            │
   │  - ancient_vault.gd   │◄───┤  - tolly.gd           │
   │  - lost_core_altar.gd │    └───────────────────────┘
   └───────────────────────┘
```

---

## 2. Key Script Files & Modules

### 2.1 `res://scripts/mission/mission_manager.gd`
- Centralized mission state manager tracking progression through an integer enum:
  - `MISSION_NOT_STARTED = 0`
  - `MISSION_ACTIVE = 1`
  - `FOREST_OBJECTIVE = 2`
  - `BRIDGE_OBJECTIVE = 3`
  - `CAVE_OBJECTIVE = 4`
  - `VAULT_OBJECTIVE = 5`
  - `CORE_OBJECTIVE = 6`
  - `MISSION_COMPLETE = 7`
- Emits `mission_state_changed(new_state)` signal connected to HUD, audio systems, and camera directors.

### 2.2 `res://scripts/funobotz/companion_manager.gd`
- Manages active companion slot, switching cooldowns, and input dispatch.
- Maps keys `1`, `2`, `3`, `4` to active companion instances.
- Handles `[F]` key press by forwarding the trigger to the active companion's `use_ability()` method.

### 2.3 Funobot Specialized Controllers
- `res://scripts/funobotz/quacky.gd`: Raycasts forward, checks for bramble targets within 8m, executes dash tween, triggers dissolve animation.
- `res://scripts/funobotz/tiko.gd`: Detects bridge gear mechanism, plays kinetic manipulation animation, calls `bridge.extend_bridge()`.
- `res://scripts/funobotz/petalo.gd`: Toggles `OmniLight3D` / `SpotLight3D` node, activates cave rune photosensitive switch within light radius.
- `res://scripts/funobotz/tolly.gd`: Scans vault access pad, verifies security state, raises gate collision and mesh.

### 2.4 `res://scripts/ui/hud.gd`
- Listens to `mission_state_changed` and `companion_switched` signals.
- Updates objective tracker text and companion card highlighting in real time.
- Displays celebratory `CompleteBanner` upon entering `State.MISSION_COMPLETE`.

---

## 3. Physics, Collisions & Layers

| Layer | Name | Description |
| :---: | :--- | :--- |
| **1** | `Environment / Terrain` | Static ground meshes, mountains, rocks, bridges |
| **2** | `Player` | CharacterBody3D (Knight) with capsule collider |
| **3** | `Companions` | Kinematic companion bodies with floating dampening |
| **4** | `Obstacles` | Brambles, locked gates, retracted bridge gaps |
| **5** | `Triggers / Beacons` | Area3D volumes for zone detection and interaction prompts |

---

## 4. Input Configuration (`project.godot`)

- `move_forward`: `W`, `Up`
- `move_backward`: `S`, `Down`
- `move_left`: `A`, `Left`
- `move_right`: `D`, `Right`
- `jump`: `Space`
- `sprint`: `Shift`
- `interact`: `E`
- `ability`: `F`
- `companion_1`: `1` (Petalo)
- `companion_2`: `2` (Quacky)
- `companion_3`: `3` (Tiko)
- `companion_4`: `4` (Tolly)
