class_name AudioManagerClass
extends Node

## AudioManager: Centralized event-driven audio system for FUNOBOTZ: THE LOST CORE
## Manages SFX pools, ambient loops, and connects dynamically to gameplay singletons.

var sfx_streams: Dictionary = {}
var sfx_pool: Array[AudioStreamPlayer] = []
var ambient_player: AudioStreamPlayer = null
const POOL_SIZE: int = 8

var last_footstep_time: float = 0.0
const FOOTSTEP_INTERVAL: float = 0.36

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_audio_streams()
	_create_audio_pool()
	_connect_gameplay_signals()
	start_ambient()
	print("[AudioManager] Initialized with ", sfx_streams.size(), " sound effects and ", POOL_SIZE, " player pool.")

func _load_audio_streams() -> void:
	var sound_files = {
		"footstep": "res://assets/audio/footstep.wav",
		"interact": "res://assets/audio/interact.wav",
		"chest_open": "res://assets/audio/chest_open.wav",
		"recruit": "res://assets/audio/recruit.wav",
		"switch": "res://assets/audio/switch.wav",
		"ability_petalo": "res://assets/audio/ability_petalo.wav",
		"ability_quacky": "res://assets/audio/ability_quacky.wav",
		"ability_tolly": "res://assets/audio/ability_tolly.wav",
		"ability_tiko": "res://assets/audio/ability_tiko.wav",
		"obstacle_solved": "res://assets/audio/obstacle_solved.wav",
		"gate_open": "res://assets/audio/gate_open.wav",
		"core_recover": "res://assets/audio/core_recover.wav",
		"victory": "res://assets/audio/victory.wav",
		"ambient_wind": "res://assets/audio/ambient_wind.wav"
	}
	
	for key in sound_files:
		var path = sound_files[key]
		if FileAccess.file_exists(path) or ResourceLoader.exists(path):
			var stream = load(path)
			if stream:
				sfx_streams[key] = stream
		else:
			print("[AudioManager] Audio file not found (will fallback silently): ", path)

func _create_audio_pool() -> void:
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer.new()
		player.bus = &"Master"
		add_child(player)
		sfx_pool.append(player)
		
	ambient_player = AudioStreamPlayer.new()
	ambient_player.bus = &"Master"
	ambient_player.volume_db = -12.0
	add_child(ambient_player)

func _connect_gameplay_signals() -> void:
	# 1. Connect to MissionManager
	var mm = get_node_or_null("/root/MissionManager")
	if mm and mm.has_signal("mission_state_changed"):
		mm.mission_state_changed.connect(_on_mission_state_changed)
		
	# 2. Connect to CompanionManager
	var cm = get_node_or_null("/root/CompanionManager")
	if cm:
		if cm.has_signal("companion_recruited"):
			cm.companion_recruited.connect(_on_companion_recruited)
		if cm.has_signal("companion_ability_used"):
			cm.companion_ability_used.connect(_on_companion_ability_used)
			
	# 3. Connect to InteractionManager
	var im = get_node_or_null("/root/InteractionManager")
	if im and im.has_signal("interaction_triggered"):
		im.interaction_triggered.connect(_on_interaction_triggered)

func _on_mission_state_changed(_old: int, new_state: int, _title: String, _obj: String) -> void:
	if new_state == 6: # MISSION_COMPLETE
		play_sfx("victory", 0.0)
	elif new_state in [2, 3, 4, 5]: # Progressed past an obstacle
		play_sfx("obstacle_solved", 0.05)

func _on_companion_recruited(_companion: Node3D) -> void:
	play_sfx("recruit", 0.04)

func _on_companion_ability_used(companion: Node3D, _feedback: String) -> void:
	if companion and "robot_id" in companion:
		var sound_name = "ability_" + str(companion.robot_id)
		play_sfx(sound_name, 0.05)
	else:
		play_sfx("interact", 0.05)

func _on_interaction_triggered(interactable: Node) -> void:
	if not interactable:
		return
	if interactable is TestChest or interactable.name == "TestChest":
		play_sfx("chest_open", 0.02)
	elif interactable.name.to_lower().contains("core"):
		play_sfx("core_recover", 0.0)
	else:
		play_sfx("interact", 0.06)

func play_sfx(sound_name: String, pitch_range: float = 0.0) -> void:
	if not sfx_streams.has(sound_name):
		return
		
	var stream = sfx_streams[sound_name]
	if not stream:
		return
		
	# Find an available stream player from the pool
	var player = _get_available_player()
	if player:
		player.stream = stream
		if pitch_range > 0.0:
			player.pitch_scale = randf_range(1.0 - pitch_range, 1.0 + pitch_range)
		else:
			player.pitch_scale = 1.0
		player.play()

func play_footstep() -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_footstep_time >= FOOTSTEP_INTERVAL:
		last_footstep_time = current_time
		play_sfx("footstep", 0.12)

func start_ambient() -> void:
	if sfx_streams.has("ambient_wind") and ambient_player:
		ambient_player.stream = sfx_streams["ambient_wind"]
		ambient_player.play()
		ambient_player.finished.connect(func():
			if ambient_player:
				ambient_player.play()
		)

func _get_available_player() -> AudioStreamPlayer:
	for p in sfx_pool:
		if not p.playing:
			return p
	# Fallback: take first player
	if not sfx_pool.is_empty():
		return sfx_pool[0]
	return null
