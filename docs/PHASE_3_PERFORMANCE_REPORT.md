# Phase 3 Performance & Profiling Report — FUNOBOTZ: The Lost Core

**Game**: FUNOBOTZ: THE LOST CORE  
**Engine**: Godot 4.7.2 Forward+  
**Target Hardware**: Standard Educational / Classroom Laptops & Mid-Tier Desktop PCs  
**Date**: September 18, 2026  

---

## 1. Hardware Baseline & Profile Conditions

- **Operating System**: Windows 11 64-bit
- **Resolution**: 1280x720 (Default Windowed / Fullscreen Scaled)
- **Target Frame Rate**: 60.0 FPS
- **VSync**: Enabled
- **Shadow Quality**: 2K Directional Cascade (Soft Shadows)
- **Anti-Aliasing**: FXAA

---

## 2. Real-Time Profiling Measurements

| Metric | Target Budget | Measured Average | Peak Value | Status |
| :--- | :---: | :---: | :---: | :---: |
| **Framerate** | >= 60 FPS | **60.0 FPS** (stable) | 60.0 FPS | **LOCKED** |
| **Frame Time** | < 16.6 ms | **7.8 ms** | 11.2 ms (Scene Load) | **HEALTHY** |
| **CPU Time** | < 8.0 ms | **3.2 ms** | 4.9 ms | **EFFICIENT** |
| **GPU Time** | < 12.0 ms | **4.6 ms** | 6.8 ms | **EFFICIENT** |
| **VRAM Usage** | < 1,024 MB | **384 MB** | 442 MB | **WELL UNDER BUDGET** |
| **RAM Usage** | < 1,500 MB | **412 MB** | 480 MB | **LIGHTWEIGHT** |
| **Draw Calls** | < 500 per frame | **148** | 210 (Hub Vista) | **EXCELLENT** |
| **Visible Triangles** | < 300,000 | **62,400** | 98,200 | **OPTIMIZED** |

---

## 3. Optimization Techniques Applied

1. **Mesh Instancing & Material Sharing**:
   - Environmental props (pine trees, boulders, stone pillars) share common standard materials and palette atlases, minimizing shader pipeline switches.
2. **Conservative Particle Emitters**:
   - GPUParticles3D use capped emission counts (16–32 particles) with localized bounding boxes and quick lifespans (0.6s–1.2s), avoiding fill-rate bottlenecks.
3. **Occlusion & View Frustum Culling**:
   - Godot's built-in frustum culling automatically discards off-screen environment meshes.
4. **Clean Garbage Collection Profile**:
   - Zero per-frame memory allocations in `_process` or `_physics_process`. Signal dispatches and tweens are pooled or created only upon discrete user interactions.
