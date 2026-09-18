class_name LightRune
extends Node3D

## LightRune: Photosensitive crystal rune triggered by Petalo's light beacon

@onready var crystal: Node3D = get_node_or_null("AlcoveCrystal")
var is_illuminated: bool = false

func _ready() -> void:
	add_to_group("light_sensitive")

func activate_by_light() -> void:
	if is_illuminated:
		return
	is_illuminated = true
	print("[LightRune] Petalo's golden light beacon activated the ancient crystal rune!")
	
	var am = get_node_or_null("/root/AudioManager")
	if am and am.has_method("play_sfx"):
		am.play_sfx("gate_open", 0.05)
		am.play_sfx("obstacle_solved", 0.05)
	
	# Add an omni light to the crystal if not present
	var rune_light = get_node_or_null("RuneLight")
	if not rune_light:
		rune_light = OmniLight3D.new()
		rune_light.name = "RuneLight"
		rune_light.light_color = Color(1.0, 0.88, 0.3, 1.0)
		rune_light.light_energy = 0.0
		rune_light.omni_range = 18.0
		add_child(rune_light)
		
	var tween = create_tween()
	tween.tween_property(rune_light, "light_energy", 5.0, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Unseal the cave exit barrier to Crystal Cavern
	var exit_barrier = get_tree().get_first_node_in_group("cave_exit_barrier")
	if exit_barrier:
		var col = exit_barrier.find_child("*CollisionShape3D*", true, false)
		if col:
			col.set_deferred("disabled", true)
		var tween2 = create_tween()
		tween2.tween_property(exit_barrier, "position:y", -4.0, 1.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween2.tween_callback(func(): exit_barrier.visible = false)
