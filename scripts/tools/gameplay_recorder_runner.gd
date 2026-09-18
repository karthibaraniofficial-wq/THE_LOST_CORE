extends Node

## Autonomous Gameplay Recording Runner
## Drives the actual game through the complete 86-second vertical slice route
## Executes real player physics, camera orbit, companion recruitment, ability puzzles, and victory

var world: Node = null
var player: CharacterBody3D = null
var player_cam: Camera3D = null
var cam_pivot: Node3D = null
var spring_arm: SpringArm3D = null
var hud: CanvasLayer = null

var hub: Node3D = null
var petalo: FunobotBase = null
var quacky: FunobotBase = null
var tolly: FunobotBase = null
var tiko: FunobotBase = null

var bramble: Node3D = null
var bridge_mech: Node3D = null
var light_rune: Node3D = null
var vault_gate: Node3D = null
var core_altar: Node3D = null
var chest: Node3D = null

var elapsed: float = 0.0
var step: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("STARTING AUTONOMOUS GAMEPLAY RECORDER RUNNER")
	print("========================================================\n")
	
	var main_scene: PackedScene = load("res://scenes/world/main.tscn")
	world = main_scene.instantiate()
	add_child(world)
	
	# Reference key nodes
	player = world.get_node("Player")
	hud = world.get_node("HUD")
	chest = world.get_node("TestChest")
	
	cam_pivot = player.get_node("CameraPivot")
	spring_arm = player.get_node("CameraPivot/SpringArm3D")
	player_cam = player.get_node("CameraPivot/SpringArm3D/Camera3D")
	
	hub = world.get_node("WorldScenarios/GrandGateway/FunobotzHub")
	petalo = hub.get_node("Petalo")
	quacky = hub.get_node("Quacky")
	tolly = hub.get_node("Tolly")
	tiko = hub.get_node("Tiko")
	
	bramble = world.get_node("WorldScenarios/HiddenForest/BlockedQuackyPath")
	bridge_mech = world.get_node("WorldScenarios/RainbowBridge/DamagedBridgeSection")
	light_rune = world.get_node("WorldScenarios/MysteryCave/PetaloSecretAlcove")
	vault_gate = world.get_node("WorldScenarios/CoreChamber/AncientVaultGate")
	core_altar = world.get_node("WorldScenarios/CoreChamber/LostCoreAltar")
	
	# Initial camera alignment
	cam_pivot.rotation_degrees.y = 0.0
	spring_arm.rotation_degrees.x = -10.0

func _physics_process(delta: float) -> void:
	elapsed += delta
	
	# -------------------------------------------------------------
	# STAGE 0: 0.0s - 4.0s: GAME START & TITLE SPLASH
	# -------------------------------------------------------------
	if elapsed < 4.0:
		player.velocity = Vector3.ZERO
		player.is_moving = false
		player._update_animation()
		if elapsed > 3.0 and hud.has_method("dismiss_title_splash"):
			hud.dismiss_title_splash()
			
	# -------------------------------------------------------------
	# STAGE 1: 4.0s - 12.0s: MOVE TO ANCIENT CHEST & DISCOVER MISSION
	# -------------------------------------------------------------
	elif elapsed < 12.0:
		var target_pos = Vector3(3.6, 0.5, -4.0)
		var dir = (target_pos - player.global_position)
		if dir.length() > 0.4:
			player.velocity = dir.normalized() * 5.5
			player.is_moving = true
			player.model_root.rotation.y = lerp_angle(player.model_root.rotation.y, atan2(-dir.x, -dir.z), 12.0 * delta)
			player._update_animation()
			player.move_and_slide()
		else:
			player.velocity = Vector3.ZERO
			player.is_moving = false
			player._update_animation()
			
		cam_pivot.rotation.y = lerp_angle(cam_pivot.rotation.y, deg_to_rad(-25.0), 4.0 * delta)
		
		# Interact with chest at 9.0s
		if elapsed >= 9.0 and elapsed < 9.1 and not chest.is_open:
			print("[RECORDER] Interacting with Ancient Chest...")
			chest._on_interact(player)
			
	# -------------------------------------------------------------
	# STAGE 2: 12.0s - 22.0s: ENTER FUNOBOTZ HUB & RECRUIT QUACKY
	# -------------------------------------------------------------
	elif elapsed < 22.0:
		var target_pos = Vector3(0.0, 0.5, -20.5)
		var dir = (target_pos - player.global_position)
		if dir.length() > 0.5:
			player.velocity = dir.normalized() * 6.0
			player.is_moving = true
			player.model_root.rotation.y = lerp_angle(player.model_root.rotation.y, atan2(-dir.x, -dir.z), 12.0 * delta)
			player._update_animation()
			player.move_and_slide()
		else:
			player.velocity = Vector3.ZERO
			player.is_moving = false
			player._update_animation()
			
		cam_pivot.rotation.y = lerp_angle(cam_pivot.rotation.y, deg_to_rad(0.0), 3.0 * delta)
		spring_arm.rotation.x = lerp_angle(spring_arm.rotation.x, deg_to_rad(-12.0), 3.0 * delta)
		
		# Recruit Quacky at 18.0s
		if elapsed >= 18.0 and elapsed < 18.1 and CompanionManager.active_companion != quacky:
			print("[RECORDER] Selecting Quacky in Hub...")
			CompanionManager.recruit(quacky)
			
	# -------------------------------------------------------------
	# STAGE 3: 22.0s - 34.0s: ADVANCE TO HIDDEN FOREST & QUACKY SOLVES BRAMBLES
	# -------------------------------------------------------------
	elif elapsed < 34.0:
		var target_pos = Vector3(0.0, 0.5, -82.0)
		var dir = (target_pos - player.global_position)
		if dir.length() > 0.5 and elapsed < 27.5:
			player.velocity = dir.normalized() * 8.5
			player.is_sprinting = true
			player.is_moving = true
			player.model_root.rotation.y = lerp_angle(player.model_root.rotation.y, atan2(-dir.x, -dir.z), 12.0 * delta)
			player._update_animation()
			player.move_and_slide()
		else:
			player.velocity = Vector3.ZERO
			player.is_sprinting = false
			player.is_moving = false
			player._update_animation()
			
		cam_pivot.rotation.y = lerp_angle(cam_pivot.rotation.y, deg_to_rad(0.0), 4.0 * delta)
		
		# Quacky clears brambles at 28.5s
		if elapsed >= 28.5 and elapsed < 28.6:
			print("[RECORDER] Quacky activates Scout Run ability...")
			quacky.global_position = player.global_position + Vector3(0.8, 0, -2.0)
			CompanionManager.use_active_ability()
			
	# -------------------------------------------------------------
	# STAGE 4: 34.0s - 46.0s: CROSS TO RAINBOW BRIDGE & TIKO SOLVES RUBBLE
	# -------------------------------------------------------------
	elif elapsed < 46.0:
		var target_pos = Vector3(0.0, 0.5, -172.0)
		var dir = (target_pos - player.global_position)
		if dir.length() > 0.5 and elapsed < 39.5:
			player.velocity = dir.normalized() * 9.0
			player.is_sprinting = true
			player.is_moving = true
			player.model_root.rotation.y = lerp_angle(player.model_root.rotation.y, atan2(-dir.x, -dir.z), 12.0 * delta)
			player._update_animation()
			player.move_and_slide()
		else:
			player.velocity = Vector3.ZERO
			player.is_sprinting = false
			player.is_moving = false
			player._update_animation()
			
		# Switch to Tiko at 40.0s
		if elapsed >= 40.0 and elapsed < 40.1 and CompanionManager.active_companion != tiko:
			print("[RECORDER] Switching to Tiko [Key 3]...")
			CompanionManager.switch_to_companion_by_id("tiko")
			tiko.global_position = player.global_position + Vector3(1.2, 0, -1.8)
			
		# Tiko manipulates mechanism at 41.5s
		if elapsed >= 41.5 and elapsed < 41.6:
			print("[RECORDER] Tiko activates Object Manipulation ability...")
			CompanionManager.use_active_ability()
			
	# -------------------------------------------------------------
	# STAGE 5: 46.0s - 58.0s: ENTER MYSTERY CAVE & PETALO ACTIVATES RUNE
	# -------------------------------------------------------------
	elif elapsed < 58.0:
		var target_pos = Vector3(-8.0, 0.5, -274.0)
		var dir = (target_pos - player.global_position)
		if dir.length() > 0.5 and elapsed < 51.5:
			player.velocity = dir.normalized() * 9.0
			player.is_sprinting = true
			player.is_moving = true
			player.model_root.rotation.y = lerp_angle(player.model_root.rotation.y, atan2(-dir.x, -dir.z), 12.0 * delta)
			player._update_animation()
			player.move_and_slide()
		else:
			player.velocity = Vector3.ZERO
			player.is_sprinting = false
			player.is_moving = false
			player._update_animation()
			
		cam_pivot.rotation.y = lerp_angle(cam_pivot.rotation.y, deg_to_rad(-18.0), 3.0 * delta)
		
		# Switch to Petalo at 52.0s
		if elapsed >= 52.0 and elapsed < 52.1 and CompanionManager.active_companion != petalo:
			print("[RECORDER] Switching to Petalo [Key 1]...")
			CompanionManager.switch_to_companion_by_id("petalo")
			petalo.global_position = player.global_position + Vector3(-1.2, 0, -1.8)
			
		# Petalo illuminates rune at 53.5s
		if elapsed >= 53.5 and elapsed < 53.6:
			print("[RECORDER] Petalo activates Light Beacon ability...")
			CompanionManager.use_active_ability()
			
	# -------------------------------------------------------------
	# STAGE 6: 58.0s - 70.0s: CRYSTAL CAVERN & TOLLY OPENS VAULT GATE
	# -------------------------------------------------------------
	elif elapsed < 70.0:
		var target_pos = Vector3(0.0, 0.5, -388.0)
		var dir = (target_pos - player.global_position)
		if dir.length() > 0.5 and elapsed < 63.5:
			player.velocity = dir.normalized() * 9.5
			player.is_sprinting = true
			player.is_moving = true
			player.model_root.rotation.y = lerp_angle(player.model_root.rotation.y, atan2(-dir.x, -dir.z), 12.0 * delta)
			player._update_animation()
			player.move_and_slide()
		else:
			player.velocity = Vector3.ZERO
			player.is_sprinting = false
			player.is_moving = false
			player._update_animation()
			
		cam_pivot.rotation.y = lerp_angle(cam_pivot.rotation.y, deg_to_rad(0.0), 4.0 * delta)
		
		# Switch to Tolly at 64.0s
		if elapsed >= 64.0 and elapsed < 64.1 and CompanionManager.active_companion != tolly:
			print("[RECORDER] Switching to Tolly [Key 4]...")
			CompanionManager.switch_to_companion_by_id("tolly")
			tolly.global_position = player.global_position + Vector3(1.2, 0, -1.8)
			
		# Tolly opens vault gate at 65.5s
		if elapsed >= 65.5 and elapsed < 65.6:
			print("[RECORDER] Tolly activates Access Clearance ability...")
			CompanionManager.use_active_ability()
			
	# -------------------------------------------------------------
	# STAGE 7: 70.0s - 80.0s: CORE CHAMBER & LOST CORE RECOVERY
	# -------------------------------------------------------------
	elif elapsed < 80.0:
		var target_pos = Vector3(0.0, 1.2, -416.0)
		var dir = (target_pos - player.global_position)
		if dir.length() > 0.4 and elapsed < 74.5:
			player.velocity = dir.normalized() * 6.5
			player.is_moving = true
			player.model_root.rotation.y = lerp_angle(player.model_root.rotation.y, atan2(-dir.x, -dir.z), 12.0 * delta)
			player._update_animation()
			player.move_and_slide()
		else:
			player.velocity = Vector3.ZERO
			player.is_moving = false
			player._update_animation()
			
		cam_pivot.rotation.y = lerp_angle(cam_pivot.rotation.y, deg_to_rad(0.0), 3.0 * delta)
		spring_arm.rotation.x = lerp_angle(spring_arm.rotation.x, deg_to_rad(-18.0), 3.0 * delta)
		
		# Recover Lost Core at 75.5s
		if elapsed >= 75.5 and elapsed < 75.6 and not core_altar.is_recovered:
			print("[RECORDER] Interacting with Lost Core Altar...")
			core_altar.interact(player)
			
	# -------------------------------------------------------------
	# STAGE 8: 80.0s - 86.0s: VICTORY CELEBRATION & COMPLETE STATE
	# -------------------------------------------------------------
	elif elapsed < 86.0:
		player.velocity = Vector3.ZERO
		player.is_moving = false
		player._update_animation()
		
		# Slow cinematic pan around the altar
		cam_pivot.rotation.y += 0.25 * delta
		
		# Arrange 4 companions in victory formation
		petalo.global_position = Vector3(-2.2, 1.2, -418)
		quacky.global_position = Vector3(2.2, 1.2, -418)
		tiko.global_position = Vector3(-1.8, 1.2, -422)
		tolly.global_position = Vector3(1.8, 1.2, -422)
		
	# -------------------------------------------------------------
	# STAGE 9: 86.0s+: RECORDING COMPLETE
	# -------------------------------------------------------------
	else:
		print("\n========================================================")
		print("GAMEPLAY RECORDING COMPLETED SUCCESSFULLY (86.0s / 2580 frames)")
		print("========================================================\n")
		get_tree().quit(0)
