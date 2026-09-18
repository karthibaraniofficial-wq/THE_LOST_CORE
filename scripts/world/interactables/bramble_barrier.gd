class_name BrambleBarrier
extends Node3D

## BrambleBarrier: Forest obstacle cleared by Quacky's scouting recon

@onready var collision: CollisionShape3D = get_node_or_null("PathBlockerCollision/CollisionShape3D")
var is_cleared: bool = false

func _ready() -> void:
	add_to_group("bramble_barrier")

func clear_barrier() -> void:
	if is_cleared:
		return
	is_cleared = true
	print("[BrambleBarrier] Quacky dissolved the thorn brambles! Forward path unlocked.")
	
	var am = get_node_or_null("/root/AudioManager")
	if am and am.has_method("play_sfx"):
		am.play_sfx("obstacle_solved", 0.05)
		
	if collision:
		collision.set_deferred("disabled", true)
		
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(0.01, 0.01, 0.01), 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): visible = false)
