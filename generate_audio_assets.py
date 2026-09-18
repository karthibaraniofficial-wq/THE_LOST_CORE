import os
import math
import struct
import wave
import random

AUDIO_DIR = r"E:\funobotz\game\assets\audio"
os.makedirs(AUDIO_DIR, exist_ok=True)
SAMPLE_RATE = 44100

def write_wav(filename, samples, sample_rate=SAMPLE_RATE):
    filepath = os.path.join(AUDIO_DIR, filename)
    with wave.open(filepath, 'w') as wav_file:
        wav_file.setnchannels(1) # Mono
        wav_file.setsampwidth(2) # 16-bit
        wav_file.setframerate(sample_rate)
        
        # Normalize and clip
        max_val = max(max(abs(s) for s in samples), 0.001)
        scale = 32000.0 / max_val
        
        frames = bytearray()
        for s in samples:
            val = int(s * scale)
            val = max(-32767, min(32767, val))
            frames.extend(struct.pack('<h', val))
        wav_file.writeframes(frames)
    print(f"Generated: {filepath} ({len(samples)} samples)")

# 1. Footstep: brief filtered thud with subtle gravel click
def gen_footstep():
    duration = 0.12
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        env = math.exp(-t * 35.0)
        # Low frequency thump + noise
        thump = math.sin(2 * math.pi * (80 - t * 200) * t)
        noise = (random.random() * 2.0 - 1.0) * math.exp(-t * 60.0) * 0.3
        samples.append((thump * 0.7 + noise) * env)
    return samples

# 2. Interact chime: bright two-tone chime (E5 -> G5)
def gen_interact():
    duration = 0.25
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        env1 = math.exp(-t * 14.0)
        tone1 = math.sin(2 * math.pi * 659.25 * t) + 0.3 * math.sin(2 * math.pi * 1318.5 * t)
        
        tone2 = 0.0
        if t > 0.06:
            t2 = t - 0.06
            env2 = math.exp(-t2 * 14.0)
            tone2 = (math.sin(2 * math.pi * 783.99 * t2) + 0.3 * math.sin(2 * math.pi * 1567.98 * t2)) * env2
        samples.append(tone1 * env1 * 0.6 + tone2 * 0.7)
    return samples

# 3. Chest open: latch click + rising magical arpeggio
def gen_chest_open():
    duration = 0.65
    n = int(SAMPLE_RATE * duration)
    samples = []
    notes = [523.25, 659.25, 783.99, 1046.5] # C5, E5, G5, C6
    for i in range(n):
        t = i / SAMPLE_RATE
        click = 0.0
        if t < 0.03:
            click = (random.random() * 2.0 - 1.0) * (1.0 - t / 0.03) * 0.8
        
        melody = 0.0
        for idx, freq in enumerate(notes):
            start_t = 0.04 + idx * 0.09
            if t > start_t:
                dt = t - start_t
                env = math.exp(-dt * 6.0)
                melody += math.sin(2 * math.pi * freq * dt) * env * 0.35
                melody += 0.2 * math.sin(4 * math.pi * freq * dt) * env * 0.35
        samples.append(click + melody)
    return samples

# 4. Recruit: Cheerful robotic chirp (A4 -> C#5 -> E5 -> A5)
def gen_recruit():
    duration = 0.45
    n = int(SAMPLE_RATE * duration)
    samples = []
    notes = [440.0, 554.37, 659.25, 880.0]
    for i in range(n):
        t = i / SAMPLE_RATE
        idx = min(int(t / 0.08), len(notes) - 1)
        freq = notes[idx]
        local_t = t - idx * 0.08
        env = math.exp(-local_t * 12.0) if idx < len(notes) - 1 else math.exp(-local_t * 6.0)
        # Pulse-like robotic square/sine blend
        wave_val = math.sin(2 * math.pi * freq * t) + 0.3 * math.sin(6 * math.pi * freq * t)
        samples.append(wave_val * env)
    return samples

# 5. Switch companion: quick clean futuristic blip
def gen_switch():
    duration = 0.12
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        freq = 880.0 + (t / duration) * 440.0
        env = math.sin(math.pi * (t / duration)) ** 0.5
        val = math.sin(2 * math.pi * freq * t) * env
        samples.append(val)
    return samples

# 6. Petalo ability: luminous bell sparkle shimmer
def gen_petalo():
    duration = 0.85
    n = int(SAMPLE_RATE * duration)
    samples = []
    bell_freqs = [880.0, 1108.7, 1318.5, 1760.0, 2093.0]
    for i in range(n):
        t = i / SAMPLE_RATE
        val = 0.0
        for idx, f in enumerate(bell_freqs):
            offset = idx * 0.06
            if t > offset:
                dt = t - offset
                decay = math.exp(-dt * 4.5)
                sparkle = math.sin(2 * math.pi * 12.0 * dt) * 0.15 + 1.0 # shimmer vibrato
                val += math.sin(2 * math.pi * f * sparkle * dt) * decay * 0.25
        samples.append(val)
    return samples

# 7. Quacky ability: speedy whoosh & flutter dash
def gen_quacky():
    duration = 0.6
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        env = math.sin(math.pi * (t / duration))
        # Pitch sweep from 300 to 700 and back to 200
        freq = 300.0 + 500.0 * math.sin(math.pi * (t / duration))
        flutter = math.sin(2 * math.pi * 28.0 * t) * 0.35 + 0.65
        noise = (random.random() * 2.0 - 1.0) * 0.4
        val = (math.sin(2 * math.pi * freq * t) * 0.6 + noise) * flutter * env
        samples.append(val)
    return samples

# 8. Tolly ability: security override digital ping & access unlock
def gen_tolly():
    duration = 0.55
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        # Two tone electronic confirm (700Hz -> 1050Hz) + mechanical click
        tone = 0.0
        if t < 0.12:
            tone = math.sin(2 * math.pi * 700.0 * t) * math.exp(-t * 10.0)
        elif t < 0.28:
            dt = t - 0.12
            tone = math.sin(2 * math.pi * 1050.0 * dt) * math.exp(-dt * 10.0)
        else:
            dt = t - 0.28
            # Mechanical latch
            click = (random.random() * 2.0 - 1.0) * math.exp(-dt * 20.0) * 0.5
            hum = math.sin(2 * math.pi * 180.0 * dt) * math.exp(-dt * 5.0) * 0.4
            tone = click + hum
        samples.append(tone)
    return samples

# 9. Tiko ability: hydraulic mechanical gear shift & heavy clang
def gen_tiko():
    duration = 0.7
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        # Hydraulic motor rise
        motor = 0.0
        if t < 0.35:
            m_freq = 120.0 + t * 400.0
            motor = (math.sin(2 * math.pi * m_freq * t) + 0.3 * math.sin(4 * math.pi * m_freq * t)) * (t / 0.35)
        # Heavy metallic impact clang at 0.35s
        clang = 0.0
        if t >= 0.35:
            dt = t - 0.35
            env = math.exp(-dt * 7.0)
            clang = (math.sin(2 * math.pi * 220.0 * dt) * 0.5 + 
                     math.sin(2 * math.pi * 440.0 * dt) * 0.3 + 
                     math.sin(2 * math.pi * 880.0 * dt) * 0.2 +
                     (random.random() * 2.0 - 1.0) * math.exp(-dt * 25.0) * 0.4) * env
        samples.append(motor * 0.4 + clang * 0.8)
    return samples

# 10. Obstacle solved: rich major chord fanfare
def gen_obstacle_solved():
    duration = 1.1
    n = int(SAMPLE_RATE * duration)
    samples = []
    chord = [523.25, 659.25, 783.99, 1046.5] # C Major
    for i in range(n):
        t = i / SAMPLE_RATE
        val = 0.0
        for f in chord:
            env = math.exp(-t * 2.8)
            val += (math.sin(2 * math.pi * f * t) + 0.2 * math.sin(4 * math.pi * f * t)) * env * 0.25
        samples.append(val)
    return samples

# 11. Gate open: low stone rumble & sliding resonance
def gen_gate_open():
    duration = 1.4
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        env = math.sin(math.pi * (t / duration)) ** 0.5
        rumble = (math.sin(2 * math.pi * 45.0 * t) + 
                  math.sin(2 * math.pi * 65.0 * t) * 0.8 + 
                  (random.random() * 2.0 - 1.0) * 0.35) * env
        samples.append(rumble * 0.7)
    return samples

# 12. Lost Core recover: celestial cosmic surge & crystal chime
def gen_core_recover():
    duration = 1.6
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        # Rising cosmic resonance
        sweep_freq = 200.0 + (t / duration) ** 2 * 1200.0
        env = min(t / 0.4, 1.0) * math.exp(-max(0.0, t - 0.8) * 3.0)
        tone = (math.sin(2 * math.pi * sweep_freq * t) + 
                0.35 * math.sin(4 * math.pi * sweep_freq * t)) * env
        
        # Shimmer harmonics
        shimmer = math.sin(2 * math.pi * 14.0 * t) * 0.2 + 0.8
        samples.append(tone * shimmer)
    return samples

# 13. Victory: triumphant orchestral brass chord progression
def gen_victory():
    duration = 2.4
    n = int(SAMPLE_RATE * duration)
    samples = []
    # Progression: F Maj (0.0-0.45), G Maj (0.45-0.9), C Maj (0.9-2.4)
    for i in range(n):
        t = i / SAMPLE_RATE
        if t < 0.45:
            chord = [349.23, 440.0, 523.25] # F Maj
            local_t = t
            env = math.exp(-local_t * 1.8)
        elif t < 0.9:
            chord = [392.0, 493.88, 587.33] # G Maj
            local_t = t - 0.45
            env = math.exp(-local_t * 1.8)
        else:
            chord = [523.25, 659.25, 783.99, 1046.5] # C Maj Grand
            local_t = t - 0.9
            env = math.exp(-local_t * 1.2)
            
        val = 0.0
        for f in chord:
            # Brass harmonic structure (odd and even harmonics)
            harmonics = (math.sin(2 * math.pi * f * t) + 
                         0.5 * math.sin(4 * math.pi * f * t) + 
                         0.25 * math.sin(6 * math.pi * f * t))
            val += harmonics * env * 0.22
        samples.append(val)
    return samples

# 14. Ambient wind / nature breeze: soothing loopable low wind
def gen_ambient_wind():
    duration = 4.0
    n = int(SAMPLE_RATE * duration)
    samples = []
    # Filtered brown/pink noise emulation with subtle gust modulation
    noise_state = 0.0
    for i in range(n):
        t = i / SAMPLE_RATE
        white = random.random() * 2.0 - 1.0
        noise_state = (noise_state * 0.96) + (white * 0.04) # low pass filter
        gust = 0.5 + 0.5 * math.sin(2 * math.pi * 0.25 * t) * math.sin(2 * math.pi * 0.1 * t)
        # Seamless loop crossfade at boundaries
        fade = 1.0
        if t < 0.2:
            fade = t / 0.2
        elif t > duration - 0.2:
            fade = (duration - t) / 0.2
        samples.append(noise_state * gust * fade * 0.6)
    return samples

if __name__ == "__main__":
    write_wav("footstep.wav", gen_footstep())
    write_wav("interact.wav", gen_interact())
    write_wav("chest_open.wav", gen_chest_open())
    write_wav("recruit.wav", gen_recruit())
    write_wav("switch.wav", gen_switch())
    write_wav("ability_petalo.wav", gen_petalo())
    write_wav("ability_quacky.wav", gen_quacky())
    write_wav("ability_tolly.wav", gen_tolly())
    write_wav("ability_tiko.wav", gen_tiko())
    write_wav("obstacle_solved.wav", gen_obstacle_solved())
    write_wav("gate_open.wav", gen_gate_open())
    write_wav("core_recover.wav", gen_core_recover())
    write_wav("victory.wav", gen_victory())
    write_wav("ambient_wind.wav", gen_ambient_wind())
    print("\nALL 14 AUDIO ASSETS GENERATED SUCCESSFULLY!")
