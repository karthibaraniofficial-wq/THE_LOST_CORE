class_name PlayerController
extends CharacterBody3D

## Third-person player controller with responsive movement, camera look, and interaction
@export var move_speed: float = 6.0
@export var sprint_speed: float = 9.0
@export var jump_velocity: float = 5.0
@export var rotation_speed: float = 12.0
@export var mouse_sensitivity: float = 0.003

@onready var camera_pivot: Node3D = $CameraPivot
@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D
@onready var camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D
@onready var model_root: Node3D = $ModelRoot
@onready var animation_player: AnimationPlayer = _find_animation_player()

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
var mouse_captured: bool = true
var is_moving: bool = false
var is_sprinting: bool = false

func _find_animation_player() -> AnimationPlayer:
	var node = get_node_or_null("ModelRoot/Knight/AnimationPlayer")
	if node:
		return node
	var fallback = get_node_or_null("ModelRoot/AnimationPlayer")
	if fallback:
		return fallback
	var players = find_children("*", "AnimationPlayer", true, false)
	if not players.is_empty():
		return players[0] as AnimationPlayer
	return null

@export var camera_smoothing: float = 22.0
var target_cam_yaw: float = 0.0
var target_cam_pitch: float = 0.0

func _ready() -> void:
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_ensure_input_fallbacks()
	target_cam_yaw = camera_pivot.rotation.y
	target_cam_pitch = spring_arm.rotation.x
	floor_snap_length = 0.4
	floor_constant_speed = true

func _ensure_input_fallbacks() -> void:
	# Fallback safety in case actions weren't defined in project.godot
	var actions = {
		"move_forward": KEY_W,
		"move_backward": KEY_S,
		"move_left": KEY_A,
		"move_right": KEY_D,
		"jump": KEY_SPACE,
		"interact": KEY_E,
		"sprint": KEY_SHIFT,
		"use_ability": KEY_F,
		"companion_1": KEY_1,
		"companion_2": KEY_2,
		"companion_3": KEY_3,
		"companion_4": KEY_4
	}
	for action_name in actions:
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
			var ev = InputEventKey.new()
			ev.physical_keycode = actions[action_name]
			InputMap.action_add_event(action_name, ev)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_captured:
		target_cam_yaw -= event.relative.x * mouse_sensitivity
		target_cam_pitch -= event.relative.y * mouse_sensitivity
		target_cam_pitch = clamp(target_cam_pitch, deg_to_rad(-65.0), deg_to_rad(25.0))
	
	if event.is_action_pressed("ui_cancel"):
		mouse_captured = not mouse_captured
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if mouse_captured else Input.MOUSE_MODE_VISIBLE)

	if event.is_action_pressed("interact"):
		if animation_player and animation_player.has_animation("Interact"):
			animation_player.play("Interact")
		InteractionManager.trigger_interaction(self)

func _physics_process(delta: float) -> void:
	# Smooth camera interpolation
	camera_pivot.rotation.y = lerp_angle(camera_pivot.rotation.y, target_cam_yaw, camera_smoothing * delta)
	spring_arm.rotation.x = lerp_angle(spring_arm.rotation.x, target_cam_pitch, camera_smoothing * delta)

	# 1. Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# 2. Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# 3. Read Movement Input (WASD / Arrow Keys)
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1.0
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1.0
	if Input.is_action_pressed("move_forward"):
		input_vector.y -= 1.0
	if Input.is_action_pressed("move_backward"):
		input_vector.y += 1.0
	input_vector = input_vector.normalized()
	
	is_sprinting = Input.is_action_pressed("sprint")
	
	# 4. Calculate movement direction relative to camera heading
	var cam_yaw = camera_pivot.global_rotation.y
	var cam_basis = Basis(Vector3.UP, cam_yaw)
	var forward = -cam_basis.z
	var right = cam_basis.x
	
	var move_dir = (forward * -input_vector.y + right * input_vector.x)
	move_dir.y = 0.0
	move_dir = move_dir.normalized()
	
	# 5. Apply Horizontal Velocity
	var target_speed = sprint_speed if is_sprinting else move_speed
	if move_dir.length() > 0.01:
		velocity.x = move_dir.x * target_speed
		velocity.z = move_dir.z * target_speed
		is_moving = true
		
		# Rotate character mesh to strictly FACE direction of movement:
		var target_angle = atan2(-move_dir.x, -move_dir.z)
		model_root.rotation.y = lerp_angle(model_root.rotation.y, target_angle, rotation_speed * delta)
		
		# Trigger footstep audio when walking or running on floor
		if is_on_floor():
			var am = get_node_or_null("/root/AudioManager")
			if am and am.has_method("play_footstep"):
				am.play_footstep()
	else:
		velocity.x = move_toward(velocity.x, 0.0, target_speed * delta * 8.0)
		velocity.z = move_toward(velocity.z, 0.0, target_speed * delta * 8.0)
		is_moving = false
	
	# 6. Execute Kinematic Movement
	move_and_slide()
	
	# 7. Update Animation State
	_update_animation()

func _update_animation() -> void:
	if not animation_player:
		return
	
	# If playing a priority one-shot animation like Interact, let it finish
	var current_anim = animation_player.current_animation
	if current_anim == "Interact" and animation_player.is_playing():
		return
		
	if not is_on_floor():
		if animation_player.has_animation("Jump_Full_Short") and current_anim != "Jump_Full_Short":
			animation_player.play("Jump_Full_Short")
		elif animation_player.has_animation("Jump_Idle") and current_anim != "Jump_Idle":
			animation_player.play("Jump_Idle")
		return

	if is_moving:
		if is_sprinting:
			if animation_player.has_animation("Running_A") and current_anim != "Running_A":
				animation_player.play("Running_A")
			elif animation_player.has_animation("Walking_A") and current_anim != "Walking_A":
				animation_player.play("Walking_A")
		else:
			if animation_player.has_animation("Walking_A") and current_anim != "Walking_A":
				animation_player.play("Walking_A")
			elif animation_player.has_animation("Walk") and current_anim != "Walk":
				animation_player.play("Walk")
	else:
		if animation_player.has_animation("Idle") and current_anim != "Idle":
			animation_player.play("Idle")
		elif animation_player.has_animation("idle") and current_anim != "idle":
			animation_player.play("idle")
