class_name FunobotBase
extends CharacterBody3D

## FunobotBase: Base class for all 4 Funobotz companion robots
signal funobot_interacted(robot: FunobotBase)
signal ability_triggered(robot: FunobotBase, feedback: String)

@export var robot_id: String = "funobot"
@export var robot_name: String = "FUNOBOT"
@export var role_title: String = "COMPANION"
@export var catchphrase: String = "Ready for adventure!"
@export var ability_description: String = "Special companion ability."
@export var follow_offset_side: float = 1.6
@export var min_follow_distance: float = 2.2
@export var follow_speed: float = 5.8

var is_recruited: bool = false
var follow_target: Node3D = null
var home_position: Vector3 = Vector3.ZERO
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

@onready var model_root: Node3D = get_node_or_null("Model")
@onready var animation_player: AnimationPlayer = get_node_or_null("AnimationPlayer")
@onready var interaction_area: Area3D = get_node_or_null("InteractionArea")

func _ready() -> void:
	add_to_group("funobotz")
	home_position = global_position
	# Decouple collision from player layer to avoid bumping/pushing the player
	collision_layer = 8
	collision_mask = 1
	floor_snap_length = 0.4
	floor_constant_speed = true
	_setup_interaction()
	_play_idle()

func _setup_interaction() -> void:
	if interaction_area:
		interaction_area.collision_layer = 4
		interaction_area.collision_mask = 2
		interaction_area.body_entered.connect(_on_interaction_body_entered)
		interaction_area.body_exited.connect(_on_interaction_body_exited)

func get_prompt() -> String:
	if is_recruited:
		return robot_name.capitalize() + " (Recruited - Press [F] for Ability)"
	return "Talk to " + robot_name.capitalize()

func interact(interactor: Node3D) -> void:
	print("[FunobotBase] Interacted with: ", robot_name)
	funobot_interacted.emit(self)
	_on_interacted(interactor)

func _on_interacted(interactor: Node3D) -> void:
	# Default behavior: Toggle recruitment through CompanionManager
	var comp_mgr = get_node_or_null("/root/CompanionManager")
	if not is_recruited:
		if comp_mgr:
			comp_mgr.recruit(self)
		else:
			set_recruited(true)
	else:
		# If already recruited, trigger ability or show status
		activate_ability()

func set_recruited(val: bool) -> void:
	is_recruited = val
	if is_recruited:
		# Locate the player
		var players = get_tree().get_nodes_in_group("player")
		if not players.is_empty():
			follow_target = players[0]
			if global_position.distance_to(follow_target.global_position) > 12.0:
				var target_yaw = follow_target.global_rotation.y
				if "model_root" in follow_target and follow_target.model_root:
					target_yaw = follow_target.model_root.global_rotation.y
				var player_basis = Basis(Vector3.UP, target_yaw)
				global_position = follow_target.global_position + (player_basis.z * 1.8) + (player_basis.x * follow_offset_side)
		print("[FunobotBase] ", robot_name, " is now following player.")
		
		# Advance introductory mission if not started
		var mm = get_node_or_null("/root/MissionManager")
		if mm and "current_state" in mm and mm.current_state == 0: # MISSION_NOT_STARTED
			mm.advance_state()
	else:
		follow_target = null
		print("[FunobotBase] ", robot_name, " dismissed.")

func dismiss_companion() -> void:
	set_recruited(false)

func _physics_process(delta: float) -> void:
	# 1. Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# 2. Handle Follow Behavior
	if is_recruited and follow_target and is_instance_valid(follow_target):
		_process_follow(delta)
	else:
		# Friction to zero when standing idle
		velocity.x = move_toward(velocity.x, 0.0, 10.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, 10.0 * delta)
		move_and_slide()

func _process_follow(delta: float) -> void:
	# Calculate target position slightly to the side/rear of the player's true facing direction
	var player_yaw = follow_target.global_rotation.y
	if "model_root" in follow_target and follow_target.model_root:
		player_yaw = follow_target.model_root.global_rotation.y
		
	var player_basis = Basis(Vector3.UP, player_yaw)
	var rear_offset = (player_basis.z * 1.8) + (player_basis.x * follow_offset_side)
	var target_pos = follow_target.global_position + rear_offset
	
	var to_target = target_pos - global_position
	to_target.y = 0.0
	var dist = to_target.length()
	
	# Anti-stuck safety: If fell too far behind (>35m), catch up safely
	if dist > 35.0:
		global_position = target_pos + Vector3(0, 0.2, 0)
		velocity = Vector3.ZERO
		return
		
	if dist > min_follow_distance:
		var move_dir = to_target.normalized()
		# Dynamic acceleration based on distance
		var current_speed = follow_speed * clamp(dist / 3.0, 0.8, 1.8)
		velocity.x = move_dir.x * current_speed
		velocity.z = move_dir.z * current_speed
		
		# Rotate to face movement direction
		var target_angle = atan2(-move_dir.x, -move_dir.z)
		if model_root:
			model_root.rotation.y = lerp_angle(model_root.rotation.y, target_angle, 10.0 * delta)
		else:
			rotation.y = lerp_angle(rotation.y, target_angle, 10.0 * delta)
		_play_move()
	else:
		velocity.x = move_toward(velocity.x, 0.0, 12.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, 12.0 * delta)
		
		# Face the same heading as the player when idle
		var target_angle = player_yaw
		if model_root:
			model_root.rotation.y = lerp_angle(model_root.rotation.y, target_angle, 6.0 * delta)
		else:
			rotation.y = lerp_angle(rotation.y, target_angle, 6.0 * delta)
		_play_idle()
		
	move_and_slide()

func _play_idle() -> void:
	if animation_player and animation_player.has_animation("idle"):
		if animation_player.current_animation != "idle" and animation_player.current_animation != "ability":
			animation_player.play("idle")

func _play_move() -> void:
	if animation_player and animation_player.has_animation("move"):
		if animation_player.current_animation != "move" and animation_player.current_animation != "ability":
			animation_player.play("move")

## Virtual ability interface
func activate_ability() -> String:
	print("[FunobotBase] Base activate_ability called for: ", robot_name)
	var feedback = "Activated " + robot_name + "'s ability!"
	ability_triggered.emit(self, feedback)
	return feedback

func can_activate() -> bool:
	return true

func get_ability_description() -> String:
	return ability_description

func get_companion_name() -> String:
	return robot_name

func get_role_title() -> String:
	return role_title

func _on_interaction_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var im = get_node_or_null("/root/InteractionManager")
		if im:
			im.register_nearby(self)

func _on_interaction_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		var im = get_node_or_null("/root/InteractionManager")
		if im:
			im.unregister_nearby(self)
