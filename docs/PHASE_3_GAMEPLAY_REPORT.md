# Phase 3 Gameplay Report — FUNOBOTZ: The Lost Core

**Game**: FUNOBOTZ: THE LOST CORE  
**Engine**: Godot 4.7.2  
**Target Audience**: Age 10–14 (Middle school STEAM learners)  
**Session Length**: 5–10 Minutes Vertical Slice  

---

## 1. Core Gameplay Loop

The gameplay loop is built on three interconnected phases:
1. **Explore & Observe**: The player navigates the 3D Discovery World using third-person controls, encountering physical obstacles blocking access to the Lost Core.
2. **Reason & Select**: The player inspects obstacle characteristics (organic vines, mechanical bridge gap, dark cave, locked gate) and selects the appropriate Funobot companion `[1-4]`.
3. **Execute & Progress**: The player triggers the companion ability `[F]`, witnessing an immediate cause-and-effect reaction in the world environment that opens the path to the next sector.

```text
[ ENCOUNTER OBSTACLE ]
         │
         ▼
[ ANALYZE PROPERTIES ] ──► (Wrong Robot) ──► Helpful In-Game Feedback Prompt
         │
   (Correct Robot)
         │
         ▼
[ DEPLOY ABILITY ] ──► Visual FX + Audio Cue + Physical World Transformation
         │
         ▼
[ PROGRESS TO NEXT ZONE ]
```

---

## 2. Companion Mechanics Breakdown

| Funobot | Key | Domain | Special Ability | Obstacle Solved | Educational STEAM Concept |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Petalo** | `[1]` | Light & Signalling | Emits a luminous 15m golden aura | Mystery Cave & Photosensitive Runes | Optics, wavelength, solar luminescence |
| **Quacky** | `[2]` | Movement & Delivery | Fast reconnaissance dash & organic vine dissolver | Hidden Forest Brambles | Friction, kinetic energy, chemical breakdown |
| **Tiko** | `[3]` | Object Manipulation | Kinetic mechanical arm; rotates gears | Rainbow Bridge Retraction Mechanism | Mechanical advantage, gears, leverage |
| **Tolly** | `[4]` | Tollgate & Access | Digital security scanner; lowers tollgate | Ancient Vault Security Gate | Logic gates, access control, cyber-physical barriers |

---

## 3. Challenge Progression Sequence

1. **Zone 1: Grand Gateway & Beacon (0:00 - 1:00)**
   - Teaches basic 3D movement (`WASD`), jumping (`Space`), sprinting (`Shift`), and interaction (`E`).
   - Reaching the Grand Gateway Beacon activates the mission tracker and spawns the companion squad.
2. **Zone 2: Funobotz Plaza Hub (1:00 - 2:00)**
   - Introduces the four Funobot companions on their pedestals.
   - Teaches companion switching (`[1]` Petalo, `[2]` Quacky, `[3]` Tiko, `[4]` Tolly).
3. **Zone 3: Hidden Forest Bramble Barrier (2:00 - 3:30)**
   - Thorny vines block the mountain road. Selecting Petalo or Tiko provides feedback: *"These thick brambles need swift cutting and scouting!"*.
   - Selecting Quacky and pressing `[F]` dissolves the brambles into leaves, allowing passage.
4. **Zone 4: Rainbow Bridge Chasm (3:30 - 5:00)**
   - A deep chasm divides the path. Retracted mechanical bridge requires gear activation.
   - Selecting Tiko and pressing `[F]` engages the kinetic arm, extending bridge segments across the chasm.
5. **Zone 5: Mystery Cave & Darkness (5:00 - 6:30)**
   - Inside the cavern, pitch blackness prevents navigation.
   - Selecting Petalo and pressing `[F]` casts golden light, revealing hidden wall runes and illuminating the path.
6. **Zone 6: Ancient Vault Tollgate (6:30 - 8:00)**
   - Heavy reinforced vault gate blocks access to the inner sanctum.
   - Selecting Tolly and pressing `[F]` authenticates security codes, raising the gate.
7. **Zone 7: Core Chamber & Victory (8:00 - 9:00)**
   - Floating on the central altar is the Lost Core.
   - Approaching and pressing `[E]` triggers the victory sequence: triumphant fanfare, camera pan, and `★ MISSION COMPLETE ★` banner.
