class_name VaultGate
extends Node3D

## VaultGate: Access control barrier operated by Tolly's clearance

@onready var gate_mesh: Node3D = get_node_or_null("Gate")
@onready var blocker_collision: CollisionShape3D = get_node_or_null("VaultBlocker/CollisionShape3D")
var is_unlocked: bool = false

func _ready() -> void:
	add_to_group("toll_gates")

func toggle_gate(open_state: bool) -> void:
	is_unlocked = open_state
	print("[VaultGate] Toll barrier set to: ", "OPEN" if is_unlocked else "LOCKED")
	
	var am = get_node_or_null("/root/AudioManager")
	if am and am.has_method("play_sfx"):
		am.play_sfx("gate_open", 0.05)
		if is_unlocked:
			am.play_sfx("obstacle_solved", 0.05)
			
	if blocker_collision:
		blocker_collision.set_deferred("disabled", is_unlocked)
	
	if gate_mesh:
		var door_l = gate_mesh.find_child("*door_left*", true, false)
		var door_r = gate_mesh.find_child("*door_right*", true, false)
		var tween = create_tween().set_parallel(true)
		if door_l:
			var target_rot_l = deg_to_rad(-95.0) if is_unlocked else 0.0
			tween.tween_property(door_l, "rotation:y", target_rot_l, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if door_r:
			var target_rot_r = deg_to_rad(95.0) if is_unlocked else 0.0
			tween.tween_property(door_r, "rotation:y", target_rot_r, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		# Also lift the gate assembly slightly if doors are missing
		if not door_l and not door_r:
			var target_y = 5.0 if is_unlocked else 0.0
			tween.tween_property(gate_mesh, "position:y", target_y, 1.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

