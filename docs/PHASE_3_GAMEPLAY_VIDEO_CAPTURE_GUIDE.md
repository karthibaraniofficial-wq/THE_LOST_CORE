# Phase 3 Gameplay Video Capture Guide — FUNOBOTZ: The Lost Core

**Document Purpose**: Standard Operating Procedure (SOP) for capturing, verifying, and encoding gameplay videos of *FUNOBOTZ: The Lost Core* on Windows workstations.

---

## 1. Prerequisites & Environment Setup

1. **Game Engine**: Godot Engine 4.7.2 (Forward+ / Vulkan Mobile/Desktop)
   - Executable path: `C:\Users\Admin\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`
2. **Video Encoder**: FFmpeg 7.1 (or Python `imageio-ffmpeg` static binary)
   - Executable path: `C:\Users\Admin\AppData\Local\Python\pythoncore-3.14-64\Lib\site-packages\imageio_ffmpeg\binaries\ffmpeg-win-x86_64-v7.1.exe`
3. **Capture Mode**: Native Movie Maker Mode (`--write-movie <file.avi>`)
   - **Why this method excels**: Unlike external screen recorders that can experience frame drops, cursor interference, or desktop window popups, Godot's `--write-movie` renders each physical frame deterministically with sample-accurate audio locking. The resulting capture is 100% faithful to the engine's real-time viewport, running the complete gameplay director script in the foreground.

---

## 2. Step-by-Step Autonomous Execution

### Step A: Execute Foreground Game Loop with Movie Recording
Run the autonomous gameplay runner scene:
```powershell
& "C:\Users\Admin\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" `
  --path "E:\funobotz\game" `
  --write-movie "E:\funobotz\game\video\raw_gameplay.avi" `
  "res://scenes/tools/gameplay_recorder_runner.tscn"
```
- Total Frames: 2,581 frames
- Framerate: 30 FPS constant
- Output: `raw_gameplay.avi` (MJPEG video + uncompressed PCM audio, ~202 MB)

### Step B: Transcode to Master Deliverable (MP4)
Transcode the raw capture to high-profile H.264 + AAC audio with faststart metadata:
```powershell
& "C:\Users\Admin\AppData\Local\Python\pythoncore-3.14-64\Lib\site-packages\imageio_ffmpeg\binaries\ffmpeg-win-x86_64-v7.1.exe" `
  -y -i "E:\funobotz\game\video\raw_gameplay.avi" `
  -c:v libx264 -preset fast -crf 21 `
  -c:a aac -b:a 192k `
  -pix_fmt yuv420p -movflags +faststart `
  "E:\funobotz\game\video\FUNOBOTZ_THE_LOST_CORE_GAMEPLAY_PHASE3.mp4"
```

### Step C: Transcode to Web / Presentation Version (LOW MP4)
For low-bandwidth evaluators or web streaming:
```powershell
& "C:\Users\Admin\AppData\Local\Python\pythoncore-3.14-64\Lib\site-packages\imageio_ffmpeg\binaries\ffmpeg-win-x86_64-v7.1.exe" `
  -y -i "E:\funobotz\game\video\FUNOBOTZ_THE_LOST_CORE_GAMEPLAY_PHASE3.mp4" `
  -vf "scale=960:540" -c:v libx264 -crf 28 -preset fast `
  -c:a aac -b:a 128k -movflags +faststart `
  "E:\funobotz\game\video\FUNOBOTZ_THE_LOST_CORE_GAMEPLAY_PHASE3_LOW.mp4"
```

---

## 3. Alternative Recording Methods

### Alternative 1: OBS Studio Game Capture (If installed)
1. Add Source -> **Game Capture**.
2. Mode: *Capture specific window* -> Select `FUNOBOTZ: THE LOST CORE (DEBUG/RELEASE)`.
3. Output Settings: 1280x720 (or 1920x1080) @ 30 FPS, Bitrate 4500 Kbps, Audio AAC 192 Kbps.
4. Hotkey: Start Recording -> Focus Game -> Execute walkthrough -> Stop Recording.

### Alternative 2: Windows Xbox Game Bar (`Win + Alt + R`)
1. Launch game via Godot.
2. Focus game window in foreground.
3. Press `Win + Alt + R` to record.
4. Videos save automatically to `C:\Users\<User>\Videos\Captures\`.

---

## 4. Verification Checklist

Before publishing or submitting any gameplay video:
- [x] File exists and opens in standard Windows Media Player / VLC
- [x] Duration is between 60 and 90 seconds (measured: 86.03s)
- [x] Resolution matches standard 16:9 aspect ratio (1280x720)
- [x] Framerate is consistent without stutter (30 FPS)
- [x] Audio stream has audible volume (mean -17.2 dB, zero clipping)
- [x] Game is foreground; zero terminal, zero IDE, zero editor chrome visible
- [x] Full gameplay sequence is demonstrated from start to victory
