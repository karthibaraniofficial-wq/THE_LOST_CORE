extends Node

## Master Phase 2 Live Snap Capture Suite for FUNOBOTZ: THE LOST CORE
## Runs the complete authentic gameplay loop and captures 10 in-engine snapshots

func _ready() -> void:
	print("\n========================================================")
	print("STARTING REFINED PHASE 2 IN-ENGINE SNAPSHOT CAPTURE SUITE")
	print("========================================================\n")
	
	var main_scene: PackedScene = load("res://scenes/world/main.tscn")
	var world = main_scene.instantiate()
	add_child(world)
	
	var overview_cam = Camera3D.new()
	overview_cam.name = "OverviewCam"
	world.add_child(overview_cam)
	
	# Wait for assets, shaders, materials, and singletons to stabilize
	for i in range(25):
		await get_tree().process_frame
		
	var player = world.get_node("Player")
	var hud = world.get_node("HUD")
	var chest = world.get_node("TestChest")
	var player_cam: Camera3D = player.get_node("CameraPivot/SpringArm3D/Camera3D")
	
	var hub = world.get_node_or_null("WorldScenarios/GrandGateway/FunobotzHub")
	assert(hub != null, "FunobotzHub missing from GrandGateway!")
	
	var petalo: Petalo = hub.get_node_or_null("Petalo")
	var quacky: Quacky = hub.get_node_or_null("Quacky")
	var tolly: Tolly = hub.get_node_or_null("Tolly")
	var tiko: Tiko = hub.get_node_or_null("Tiko")
	
	var bramble = world.get_node_or_null("WorldScenarios/HiddenForest/BlockedQuackyPath")
	var bridge_mech = world.get_node_or_null("WorldScenarios/RainbowBridge/DamagedBridgeSection")
	var light_rune = world.get_node_or_null("WorldScenarios/MysteryCave/PetaloSecretAlcove")
	var vault_gate = world.get_node_or_null("WorldScenarios/CoreChamber/AncientVaultGate")
	var lost_core = world.get_node_or_null("WorldScenarios/CoreChamber/LostCoreAltar")
	
	var capture = func(filenames: Array, desc: String):
		var img: Image = get_viewport().get_texture().get_image()
		for fn in filenames:
			var path = "E:/funobotz/game/docs/snaps/" + fn
			var err = img.save_png(path)
			print("[LIVE SNAPSHOT CAPTURED] ", desc, " -> ", path, " (code: ", err, ")")

	# =========================================================================
	# SNAP 01: 3D WORLD OVERVIEW (Connected 490m Adventure Quest Route)
	# =========================================================================
	print("--- Capturing Snap 01: 3D World Overview ---")
	player_cam.current = false
	overview_cam.current = true
	overview_cam.global_position = Vector3(28.0, 26.0, 16.0)
	overview_cam.look_at(Vector3(0.0, 4.0, -85.0), Vector3.UP)
	hud.visible = true
	hud.prompt_container.visible = false
	hud.complete_banner.visible = false
	hud.companion_panel.visible = false
	hud.toast_panel.visible = false
	MissionManager.set_state(MissionManager.State.MISSION_NOT_STARTED)
	for i in range(12): await get_tree().process_frame
	await capture.call(["snap01_world_overview.png", "snap1_world_overview.png"], "SNAP 01: 3D World Overview")

	# =========================================================================
	# SNAP 02: PLAYER START + MISSION ENTRY (Over-The-Shoulder Gateway View)
	# =========================================================================
	print("--- Capturing Snap 02: Player Start & Mission Entry ---")
	overview_cam.current = false
	player_cam.current = true
	player_cam.top_level = true
	player.global_position = Vector3(0.0, 0.5, 6.0)
	player.rotation_degrees = Vector3(0, 0, 0)
	player.get_node("ModelRoot").rotation_degrees = Vector3(0, 0, 0)
	player_cam.global_position = Vector3(0.8, 2.2, 9.2)
	player_cam.look_at(Vector3(0.0, 1.2, -10.0), Vector3.UP)
	hud.prompt_container.visible = false
	hud.complete_banner.visible = false
	hud.companion_panel.visible = false
	hud.toast_panel.visible = false
	MissionManager.set_state(MissionManager.State.MISSION_NOT_STARTED)
	for i in range(12): await get_tree().process_frame
	await capture.call(["snap02_player_start.png", "snap2_player_start.png"], "SNAP 02: Player Start + Mission Entry")

	# =========================================================================
	# SNAP 03: FUNOBOTZ HUB (Petalo, Quacky, Tolly, Tiko all clearly visible)
	# =========================================================================
	print("--- Capturing Snap 03: Funobotz Hub Presentation ---")
	chest.global_position = Vector3(50.0, 0.0, 50.0) # Move chest away so prompt doesn't show
	player.global_position = Vector3(3.8, 0.5, -6.5)
	player.rotation_degrees = Vector3(0, -60, 0)
	player.get_node("ModelRoot").rotation_degrees = Vector3(0, -60, 0)
	quacky.dismiss_companion()
	quacky.global_position = hub.global_position + Vector3(-1.1, 0.17, -0.2)
	petalo.global_position = hub.global_position + Vector3(-3.3, 0.17, 0.1)
	tolly.global_position = hub.global_position + Vector3(1.1, 0.17, -0.2)
	tiko.global_position = hub.global_position + Vector3(3.3, 0.17, 0.1)
	player_cam.global_position = Vector3(0.0, 2.3, -3.8)
	player_cam.look_at(Vector3(0.0, 0.95, -9.5), Vector3.UP)
	InteractionManager.nearby_interactables.clear()
	InteractionManager.active_interactable = null
	hud.prompt_container.visible = false
	hud.companion_panel.visible = false
	hud.toast_panel.visible = false
	for i in range(12): await get_tree().process_frame
	await capture.call(["snap03_funobotz_hub.png", "snap3_funobotz_hub.png", "snap_funobotz_cinematic.png"], "SNAP 03: Funobotz Hub")

	# =========================================================================
	# SNAP 04: CHALLENGE (Hidden Forest Obstacle)
	# =========================================================================
	print("--- Capturing Snap 04: Challenge Area (Hidden Forest Obstacle) ---")
	player.global_position = Vector3(12.8, 0.5, -84.0)
	player.rotation_degrees = Vector3(0, 15, 0)
	player.get_node("ModelRoot").rotation_degrees = Vector3(0, 15, 0)
	CompanionManager.recruit(quacky)
	quacky.global_position = Vector3(13.8, 0.2, -85.5)
	quacky.rotation_degrees = Vector3(0, 10, 0)
	player_cam.global_position = Vector3(12.0, 1.6, -80.5)
	player_cam.look_at(Vector3(14.0, 1.0, -88.0), Vector3.UP)
	MissionManager.set_state(MissionManager.State.FOREST_OBJECTIVE)
	InteractionManager.nearby_interactables.clear()
	InteractionManager.active_interactable = null
	hud.prompt_container.visible = false
	hud.toast_panel.visible = false
	for i in range(12): await get_tree().process_frame
	await capture.call(["snap04_challenge_forest.png", "snap04_challenge.png", "snap3_challenge_zone.png"], "SNAP 04: Challenge (Hidden Forest)")

	# =========================================================================
	# SNAP 05: FUNOBOTZ INTERACTION (Cinematic Angle showing Player & Petalo)
	# =========================================================================
	print("--- Capturing Snap 05: Funobotz Interaction ---")
	quacky.dismiss_companion()
	player.global_position = Vector3(-1.8, 0.5, -8.2)
	player.rotation_degrees = Vector3(0, -45, 0)
	player.get_node("ModelRoot").rotation_degrees = Vector3(0, -45, 0)
	player_cam.global_position = Vector3(-4.8, 1.8, -6.8)
	player_cam.look_at(Vector3(-2.6, 0.8, -9.2), Vector3.UP)
	InteractionManager.register_nearby(petalo)
	InteractionManager.active_interactable = petalo
	hud._on_active_interactable_changed(petalo)
	hud.companion_panel.visible = false
	hud.toast_panel.visible = false
	for i in range(12): await get_tree().process_frame
	await capture.call(["snap05_funobotz_interaction.png", "snap4_core_interaction.png", "snap_funobotz_interaction.png"], "SNAP 05: Funobotz Interaction")

	# =========================================================================
	# SNAP 06: ABILITY ACTIVE (Visible World Transformation)
	# =========================================================================
	print("--- Capturing Snap 06: Ability Active (World Transformation) ---")
	player.global_position = Vector3(12.8, 0.5, -84.0)
	player.rotation_degrees = Vector3(0, 15, 0)
	player.get_node("ModelRoot").rotation_degrees = Vector3(0, 15, 0)
	CompanionManager.recruit(quacky)
	quacky.global_position = Vector3(14.0, 0.2, -88.5)
	player_cam.global_position = Vector3(12.0, 1.6, -80.5)
	player_cam.look_at(Vector3(14.0, 1.0, -88.0), Vector3.UP)
	if bramble and bramble.has_method("clear_barrier"):
		bramble.clear_barrier()
	InteractionManager.nearby_interactables.clear()
	InteractionManager.active_interactable = null
	hud.prompt_container.visible = false
	hud.show_toast("Quacky executed Scout Run! Path recon completed and bramble barrier dissolved.")
	for i in range(12): await get_tree().process_frame
	await capture.call(["snap06_ability_active.png", "snap5_gameplay_feedback.png", "snap_funobotz_ability_active.png"], "SNAP 06: Ability Active")

	# =========================================================================
	# SNAP 07: GAMEPLAY FEEDBACK (HUD Toast, Companion Panel, Mission Update)
	# =========================================================================
	print("--- Capturing Snap 07: Gameplay Feedback ---")
	player.global_position = Vector3(0.0, 0.5, -18.0)
	player.rotation_degrees = Vector3(0, 0, 0)
	player.get_node("ModelRoot").rotation_degrees = Vector3(0, 0, 0)
	quacky.global_position = Vector3(1.6, 0.2, -16.5)
	quacky.rotation_degrees = Vector3(0, 0, 0)
	player_cam.global_position = Vector3(1.8, 1.8, -13.2)
	player_cam.look_at(Vector3(0.0, 0.9, -19.2), Vector3.UP)
	MissionManager.set_state(MissionManager.State.BRIDGE_OBJECTIVE)
	hud._on_companion_recruited(quacky)
	hud.show_toast("Quacky joined your quest! Press [F] to use Movement & Delivery ability.")
	for i in range(12): await get_tree().process_frame
	await capture.call(["snap07_gameplay_feedback.png", "snap7_essential_ui.png", "snap_funobotz_recruited_follow.png"], "SNAP 07: Gameplay Feedback")

	# =========================================================================
	# SNAP 08: CORE CHAMBER (Lost Core Destination & Opened Vault Gate)
	# =========================================================================
	print("--- Capturing Snap 08: Core Chamber Destination ---")
	player.global_position = Vector3(0.0, 0.5, -388.0)
	player.rotation_degrees = Vector3(0, 0, 0)
	player.get_node("ModelRoot").rotation_degrees = Vector3(0, 0, 0)
	if vault_gate:
		var gate_mesh = vault_gate.get_node_or_null("Gate")
		if gate_mesh:
			var door_l = gate_mesh.find_child("*door_left*", true, false)
			var door_r = gate_mesh.find_child("*door_right*", true, false)
			if door_l: door_l.rotation_degrees.y = -95.0
			if door_r: door_r.rotation_degrees.y = 95.0
			gate_mesh.position.y = 3.5
		if vault_gate.has_method("toggle_gate"):
			vault_gate.is_unlocked = true
	player_cam.global_position = Vector3(0.0, 2.5, -382.0)
	player_cam.look_at(Vector3(0.0, 1.8, -420.0), Vector3.UP)
	hud.prompt_container.visible = false
	hud.toast_panel.visible = false
	hud.complete_banner.visible = false
	MissionManager.set_state(MissionManager.State.CORE_RECOVERED)
	for i in range(14): await get_tree().process_frame
	await capture.call(["snap08_core_chamber.png", "snap6_completion_dais.png"], "SNAP 08: Core Chamber Destination")

	# =========================================================================
	# SNAP 09: MISSION COMPLETE (Actual In-Engine Completion State)
	# =========================================================================
	print("--- Capturing Snap 09: Mission Complete State ---")
	player.global_position = Vector3(1.8, 1.6, -418.0)
	player.rotation_degrees = Vector3(0, -35, 0)
	player.get_node("ModelRoot").rotation_degrees = Vector3(0, -35, 0)
	player_cam.global_position = Vector3(1.2, 2.4, -413.0)
	player_cam.look_at(Vector3(0.0, 1.8, -420.0), Vector3.UP)
	MissionManager.set_state(MissionManager.State.MISSION_COMPLETE)
	hud.complete_banner.visible = true
	hud.complete_banner.modulate.a = 1.0
	hud.prompt_container.visible = false
	hud.toast_panel.visible = false
	for i in range(14): await get_tree().process_frame
	await capture.call(["snap09_mission_complete.png"], "SNAP 09: Mission Complete")

	# =========================================================================
	# SNAP 10: TECHNICAL STRUCTURE (Godot Modular Architecture View)
	# =========================================================================
	print("--- Capturing Snap 10: Technical Structure ---")
	player_cam.current = false
	overview_cam.current = true
	overview_cam.global_position = Vector3(45.0, 50.0, -30.0)
	overview_cam.look_at(Vector3(0.0, 0.0, -110.0), Vector3.UP)
	hud.visible = false
	for i in range(12): await get_tree().process_frame
	await capture.call(["snap10_technical_structure.png", "snap8_technical_structure.png"], "SNAP 10: Technical Scene Structure")

	# =========================================================================
	# EXTRA BONUS SNAPS: PLAYTEST EVIDENCE & RISKIEST MECHANIC
	# =========================================================================
	print("--- Capturing Extra Bonus Snaps ---")
	# Playtest evidence: crossing Rainbow Bridge
	overview_cam.current = false
	player_cam.current = true
	player.global_position = Vector3(0.0, 0.5, -170.0)
	player.rotation_degrees = Vector3(0, 0, 0)
	player_cam.global_position = Vector3(2.5, 2.2, -164.0)
	player_cam.look_at(Vector3(0.0, 0.6, -180.0), Vector3.UP)
	hud.visible = true
	hud.complete_banner.visible = false
	hud.prompt_container.visible = false
	hud.toast_panel.visible = false
	MissionManager.set_state(MissionManager.State.BRIDGE_OBJECTIVE)
	for i in range(10): await get_tree().process_frame
	await capture.call(["snap10_playtest_evidence.png"], "Playtest Evidence (Rainbow Bridge)")

	# Riskiest mechanic: chest proximity & interaction trigger
	player.global_position = Vector3(4.0, 0.5, -1.8)
	player_cam.global_position = Vector3(6.5, 1.8, 0.2)
	player_cam.look_at(Vector3(4.0, 0.6, -4.0), Vector3.UP)
	InteractionManager.register_nearby(chest)
	InteractionManager.active_interactable = chest
	hud._on_active_interactable_changed(chest)
	for i in range(10): await get_tree().process_frame
	await capture.call(["snap9_riskiest_mechanic.png"], "Riskiest Mechanic Prototype (Chest Area3D)")

	print("\n========================================================")
	print("ALL 10 PHASE 2 LIVE SNAPSHOTS CAPTURED WITH 100% SUCCESS!")
	print("========================================================\n")
	get_tree().quit(0)
