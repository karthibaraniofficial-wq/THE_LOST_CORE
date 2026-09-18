class_name BridgeMechanism
extends Node3D

## BridgeMechanism: Heavy bridge alignment mechanism manipulated by Tiko's arm

@onready var mech_light: OmniLight3D = get_node_or_null("MechanismLight")
@onready var rubble: Node3D = get_node_or_null("Rubble1")
@onready var blocker_collision: CollisionShape3D = get_node_or_null("BridgeBlocker/CollisionShape3D")
var is_activated: bool = false

func _ready() -> void:
	add_to_group("heavy_mechanism")

func activate_mechanism() -> void:
	if is_activated:
		return
	is_activated = true
	print("[BridgeMechanism] Tiko locked the structural bridge span into alignment!")
	
	var am = get_node_or_null("/root/AudioManager")
	if am and am.has_method("play_sfx"):
		am.play_sfx("obstacle_solved", 0.05)
		
	if blocker_collision:
		blocker_collision.set_deferred("disabled", true)
		
	if mech_light:
		var tween = create_tween()
		tween.tween_property(mech_light, "light_color", Color(0.2, 0.95, 0.4, 1.0), 0.5)
		tween.parallel().tween_property(mech_light, "light_energy", 3.5, 0.5)
		
	if rubble:
		var tween2 = create_tween()
		tween2.tween_property(rubble, "position:y", -3.0, 0.6)
		tween2.tween_callback(func(): rubble.visible = false)
