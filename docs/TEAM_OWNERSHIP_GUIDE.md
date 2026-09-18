# Team Ownership & Codebase Architecture Guide — FUNOBOTZ: The Lost Core

**Target Audience**: Development Team, Hackathon Evaluators, Technical Judges  
**Engine**: Godot 4.7.2 Forward+ (GDScript 2.0)  
**Project Path**: `E:\funobotz\game`  

---

## 1. Codebase Directory Organization

```text
E:\funobotz\game\
├── assets/                  # 3D models, textures, materials, and audio files
│   ├── audio/              # Background music and SFX WAV files
│   ├── characters/         # Player character models and textures
│   └── models/             # Funobot companion meshes, terrain props, altars
├── docs/                    # Technical documentation, audits, and test reports
│   └── snaps/              # 16 live gameplay screenshots + video verification frames
├── scenes/                  # Godot packed scene definitions (.tscn)
│   ├── main_world.tscn     # The primary playable 3D Discovery World
│   ├── player.tscn         # CharacterBody3D player with third-person camera
│   ├── funobotz/           # Individual companion robot scenes (Petalo, Quacky, Tiko, Tolly)
│   ├── obstacles/          # In-world interactive obstacles (Bramble, Bridge, Cave, Vault)
│   ├── ui/                 # HUD, TitleBanner, ObjectiveTracker, CompleteBanner
│   └── tools/              # Autonomous gameplay recording runner scenes
├── scripts/                 # GDScript 2.0 source code
│   ├── core/               # Global state managers (game_manager.gd)
│   ├── funobotz/           # Base companion classes and specialized robot logic
│   ├── mission/            # mission_manager.gd authoritative state enum
│   ├── obstacles/          # Physical obstacle reaction and consequence handlers
│   ├── player/             # 3D movement, jump, sprint, and camera controllers
│   ├── ui/                 # Dynamic HUD binding and signal listeners
│   └── tests/              # Automated unit/integration test suites
└── video/                   # Final rendered MP4 deliverables
    ├── FUNOBOTZ_THE_LOST_CORE_GAMEPLAY_PHASE3.mp4
    └── FUNOBOTZ_THE_LOST_CORE_GAMEPLAY_PHASE3_LOW.mp4
```

---

## 2. Key Design Decisions & Code Patterns

### 2.1 Decoupled Signal Bus Architecture
- UI components do not query the internal state of robots directly.
- The `mission_manager` and `companion_manager` broadcast strongly-typed signals (`mission_state_changed`, `companion_switched`, `ability_activated`).
- The `hud.gd` node connects to these signals on `_ready()`, keeping presentation completely decoupled from domain physics.

### 2.2 Cause-and-Effect Obstacle Interfaces
- All obstacles implement a common interface pattern:
  - `interact(companion_type: String)` or `resolve_challenge(companion: BaseFunobot)`
  - Provide immediate visual confirmation (mesh tween, particle burst)
  - Provide immediate physical confirmation (disabling collision shapes, opening doorways)
  - Provide immediate audio confirmation (dedicated WAV sound effects)
  - Advance the authoritative mission state

### 2.3 Deterministic Video Capture Pipeline
- Godot's `--write-movie` engine flag intercepts the engine's main loop, advancing time by fixed `1/30` second steps regardless of CPU/GPU rendering load.
- Guarantees 0 frame drops, artifact-free frame rendering, and sample-accurate audio synching directly into `raw_gameplay.avi`, which is subsequently encoded via FFmpeg to universal MP4 format.
