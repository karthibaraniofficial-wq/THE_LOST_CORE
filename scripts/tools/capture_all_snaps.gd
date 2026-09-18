extends SceneTree

# High-resolution screenshot capture tool for FUNOBOTZ: THE LOST CORE Phase 2 Evidence
func _init() -> void:
	print("[CaptureRunner] Initializing Phase 2 Live Snap capture suite...")
	var main_scene: PackedScene = load("res://scenes/world/main.tscn")
	var world = main_scene.instantiate()
	root.add_child(world)
	
	# Wait for assets, materials, shaders and scene tree to stabilize
	for i in range(10):
		await process_frame
		
	var player = world.get_node("Player")
	var hud = world.get_node("HUD")
	var chest = world.get_node("TestChest")
	var cam: Camera3D = player.get_node("CameraPivot/SpringArm3D/Camera3D")
	
	# Helper capture function
	var capture = func(filename: String, step_name: String):
		var img: Image = root.get_viewport().get_texture().get_image()
		var path = "E:/funobotz/game/docs/snaps/" + filename
		var err = img.save_png(path)
		print("[CaptureRunner] Captured ", step_name, " -> ", path, " (err: ", err, ")")

	# =========================================================================
	# SNAP 1: 3D WORLD / LEVEL OVERVIEW
	# =========================================================================
	print("--- Capturing Snap 1: World Overview ---")
	cam.top_level = true
	cam.global_position = Vector3(18.0, 22.0, 15.0)
	cam.look_at(Vector3(0.0, 3.0, -50.0), Vector3.UP)
	for i in range(5): await process_frame
	await capture.call("snap1_world_overview.png", "LIVE SNAP 1: 3D World Overview")

	# =========================================================================
	# SNAP 2: PLAYER START + MISSION ENTRY
	# =========================================================================
	print("--- Capturing Snap 2: Player Start + Mission Entry ---")
	cam.top_level = false
	cam.position = Vector3.ZERO
	player.global_position = Vector3(0.0, 0.5, 5.0)
	player.rotation_degrees = Vector3(0, 180, 0)
	MissionManager.set_state(MissionManager.State.MISSION_NOT_STARTED)
	hud.get_node("PromptContainer").visible = false
	hud.get_node("CompleteBanner").visible = false
	for i in range(5): await process_frame
	await capture.call("snap2_player_start.png", "LIVE SNAP 2: Player Start & Mission Entry")

	# =========================================================================
	# SNAP 3: CHALLENGE / PROBLEM ZONE (Hidden Forest Blocked Path)
	# =========================================================================
	print("--- Capturing Snap 3: Challenge / Problem Zone ---")
	player.global_position = Vector3(0.0, 0.5, -92.0)
	player.rotation_degrees = Vector3(0, 180, 0)
	MissionManager.set_state(MissionManager.State.FOREST_OBJECTIVE)
	hud.get_node("PromptContainer").visible = false
	hud.get_node("CompleteBanner").visible = false
	for i in range(5): await process_frame
	await capture.call("snap3_challenge_zone.png", "LIVE SNAP 3: Challenge / Problem Zone")

	# =========================================================================
	# SNAP 4: CORE GAMEPLAY INTERACTION (Approaching Chest Shrine with [E] prompt)
	# =========================================================================
	print("--- Capturing Snap 4: Core Gameplay Interaction ---")
	player.global_position = Vector3(0.0, 0.5, -1.8)
	player.rotation_degrees = Vector3(0, 180, 0)
	MissionManager.set_state(MissionManager.State.MISSION_NOT_STARTED)
	# Trigger interaction manager nearby
	InteractionManager.register_nearby(chest)
	InteractionManager.active_interactable = chest
	hud._on_active_interactable_changed(chest)
	for i in range(5): await process_frame
	await capture.call("snap4_core_interaction.png", "LIVE SNAP 4: Core Gameplay Interaction")

	# =========================================================================
	# SNAP 5: GAMEPLAY FEEDBACK (Chest opened, glowing energy, mission active)
	# =========================================================================
	print("--- Capturing Snap 5: Gameplay Feedback ---")
	chest._on_interact(player)
	MissionManager.set_state(MissionManager.State.MISSION_ACTIVE)
	for i in range(10): await process_frame
	await capture.call("snap5_gameplay_feedback.png", "LIVE SNAP 5: Gameplay Feedback")

	# =========================================================================
	# SNAP 6: COMPLETION / PROGRESSION (Core Chamber & Dais with Lost Core)
	# =========================================================================
	print("--- Capturing Snap 6: Completion / Progression ---")
	player.global_position = Vector3(0.0, 1.6, -412.0)
	player.rotation_degrees = Vector3(0, 180, 0)
	MissionManager.set_state(MissionManager.State.MISSION_COMPLETE)
	hud.get_node("CompleteBanner").visible = true
	hud.get_node("CompleteBanner").modulate.a = 1.0
	for i in range(10): await process_frame
	await capture.call("snap6_completion_dais.png", "LIVE SNAP 6: Completion / Progression")

	# =========================================================================
	# SNAP 7: ESSENTIAL UI (HUD focus & child readability)
	# =========================================================================
	print("--- Capturing Snap 7: Essential UI ---")
	# Frame showing HUD with active prompt and clear mission text
	player.global_position = Vector3(0.0, 0.5, 3.0)
	player.rotation_degrees = Vector3(0, 180, 0)
	MissionManager.set_state(MissionManager.State.MISSION_ACTIVE)
	hud.get_node("CompleteBanner").visible = false
	hud.get_node("PromptContainer").visible = true
	hud.get_node("PromptContainer/HBox/PromptLabel").text = "[E]  INVESTIGATE ANCIENT RUNESTONE"
	for i in range(5): await process_frame
	await capture.call("snap7_essential_ui.png", "LIVE SNAP 7: Essential UI")

	# =========================================================================
	# SNAP 8: TECHNICAL SCENE / OBJECT STRUCTURE
	# =========================================================================
	print("--- Capturing Snap 8: Technical Structure ---")
	# Wide isometric technical view of the modular node layout
	cam.top_level = true
	cam.global_position = Vector3(30.0, 35.0, -20.0)
	cam.look_at(Vector3(0.0, 0.0, -80.0), Vector3.UP)
	hud.visible = false
	for i in range(5): await process_frame
	await capture.call("snap8_technical_structure.png", "LIVE SNAP 8: Technical Scene Structure")

	# =========================================================================
	# SNAP 9: RISKIEST MECHANIC PROTOTYPE (Chest mechanism, Area3D trigger)
	# =========================================================================
	print("--- Capturing Snap 9: Riskiest Mechanic Prototype ---")
	cam.global_position = Vector3(2.5, 2.0, -1.8)
	cam.look_at(Vector3(0.0, 0.5, -4.0), Vector3.UP)
	hud.visible = true
	hud.get_node("PromptContainer").visible = true
	hud.get_node("PromptContainer/HBox/PromptLabel").text = "[E]  TRIGGER STATE SEQUENCE"
	for i in range(5): await process_frame
	await capture.call("snap9_riskiest_mechanic.png", "LIVE SNAP 9: Riskiest Mechanic Prototype")

	# =========================================================================
	# SNAP 10: PLAYTEST EVIDENCE
	# =========================================================================
	print("--- Capturing Snap 10: Playtest Evidence ---")
	cam.top_level = false
	cam.position = Vector3.ZERO
	player.global_position = Vector3(0.0, 0.5, -180.0) # Rainbow bridge
	player.rotation_degrees = Vector3(0, 180, 0)
	MissionManager.set_state(MissionManager.State.BRIDGE_OBJECTIVE)
	hud.get_node("PromptContainer").visible = false
	for i in range(5): await process_frame
	await capture.call("snap10_playtest_evidence.png", "LIVE SNAP 10: Playtest Evidence")

	print("[CaptureRunner] ALL 10 LIVE SNAPS CAPTURED SUCCESSFULLY!")
	quit()
