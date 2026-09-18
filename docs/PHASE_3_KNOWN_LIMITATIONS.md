# Phase 3 Known Limitations & Future Roadmap — FUNOBOTZ: The Lost Core

**Game**: FUNOBOTZ: THE LOST CORE  
**Engine**: Godot 4.7.2 Forward+  
**Deliverable**: Phase 3 Vertical Slice Prototype  
**Date**: September 18, 2026  

---

## 1. Scope & Intent of the Vertical Slice

The Phase 3 build is an intentional **Vertical Slice** designed to prove end-to-end mechanics, pedagogical loop, stability, and game feel within a controlled 5–10 minute gameplay loop. It prioritizes rock-solid stability and zero game-breaking bugs over sprawling open-world content.

---

## 2. Known Limitations & Technical Context

### 2.1 Fixed Linear Companion Order in Vertical Slice
- **Current Behavior**: The vertical slice presents the four core obstacles in a sequential tutorial order (Forest Bramble -> Rainbow Bridge -> Mystery Cave -> Ancient Vault).
- **Rationale**: Ensures first-time school-age players master one robot concept before being overwhelmed with multi-robot combinations.
- **Production Roadmap**: Full game will feature branching open-world hubs where players can tackle sectors in arbitrary order.

### 2.2 Companion Following Physics Simplification
- **Current Behavior**: Active companions float smoothly behind the player using kinematic interpolation (`lerp` / `tween`) rather than complex NavMesh pathfinding.
- **Rationale**: Eliminates the risk of AI companions becoming stuck behind irregular low-poly rocks or falling through canyon cliffs during evaluators' playthroughs.
- **Production Roadmap**: Integration of Godot 4 NavigationServer3D with obstacle avoidance and dynamic jump links.

### 2.3 Audio Synthesizer Fallbacks
- **Current Behavior**: SFX and musical tracks use high-quality normalized stereo streams. Dynamic spatial 3D audio attenuation is tuned for standard stereo headphones and laptop speakers.
- **Production Roadmap**: Implementation of multi-channel interactive music layers that dynamically fade in instruments based on the currently selected Funobot.

---

## 3. Product Feasibility & Production Readiness

- **Modular Architecture**: Adding a 5th or 6th Funobot requires only creating a new `.tscn` derived from `base_funobot.gd` and registering its ability key.
- **Asset Pipeline**: The low-poly modular asset kit allows level designers to construct new adventure quest worlds rapidly without programmer intervention.
- **Multi-Platform Portability**: Godot 4's Forward+ and Mobile renderers enable rapid export to Windows, macOS, Linux, and WebGL/HTML5 for school Chromebook access.
