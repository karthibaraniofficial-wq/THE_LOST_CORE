class_name Petalo
extends FunobotBase

## Petalo: Flower-like Funobot specializing in Light & Signalling
@onready var point_light: OmniLight3D = get_node_or_null("PointLight3D")
@onready var audio_player: AudioStreamPlayer3D = get_node_or_null("AudioStreamPlayer3D")

var is_light_boosted: bool = false

func _init() -> void:
	robot_id = "petalo"
	robot_name = "PETALO"
	role_title = "LIGHT & SIGNALLING"
	catchphrase = "I can light the way!"
	ability_description = "Emits a luminous golden aura that illuminates dark caves and activates photosensitive switches."
	follow_offset_side = -1.6

func activate_ability() -> String:
	is_light_boosted = not is_light_boosted
	
	if point_light:
		var tween = create_tween()
		var target_energy = 5.0 if is_light_boosted else 1.8
		var target_range = 18.0 if is_light_boosted else 8.0
		tween.tween_property(point_light, "light_energy", target_energy, 0.4)
		tween.parallel().tween_property(point_light, "omni_range", target_range, 0.4)
	
	if animation_player and animation_player.has_animation("ability"):
		animation_player.play("ability")
		
	# Check for nearby photosensitive objects or triggers
	var illuminated_count = 0
	var runes = get_tree().get_nodes_in_group("light_sensitive")
	for r in runes:
		if r.global_position.distance_to(global_position) <= 20.0:
			if r.has_method("activate_by_light"):
				r.activate_by_light()
				illuminated_count += 1
				
	# Mission progression check: If in Mystery Cave objective, advance mission
	var mm = get_node_or_null("/root/MissionManager")
	if mm and "current_state" in mm and mm.current_state == 4: # CAVE_OBJECTIVE
		mm.advance_state()
		
	var feedback = ""
	if illuminated_count > 0:
		feedback = "Petalo illuminated the dark cavern! Ancient crystal rune activated."
	else:
		var brambles = get_tree().get_nodes_in_group("bramble_barrier")
		var near_bramble = false
		for b in brambles:
			if b.global_position.distance_to(global_position) <= 20.0 and ("is_cleared" in b and not b.is_cleared):
				near_bramble = true
				break
		if near_bramble:
			feedback = "Petalo's light illuminates the thorns, but cannot dissolve them! Try Quacky [Key 2] for Scout Run."
		else:
			var mechs = get_tree().get_nodes_in_group("heavy_mechanism")
			var near_mech = false
			for m in mechs:
				if m.global_position.distance_to(global_position) <= 20.0 and ("is_activated" in m and not m.is_activated):
					near_mech = true
					break
			if near_mech:
				feedback = "Petalo's light cannot shift heavy stone! Try Tiko [Key 3] to align bridge mechanism."
			else:
				var gates = get_tree().get_nodes_in_group("toll_gates")
				var near_gate = false
				for g in gates:
					if g.global_position.distance_to(global_position) <= 20.0 and ("is_unlocked" in g and not g.is_unlocked):
						near_gate = true
						break
				if near_gate:
					feedback = "Petalo's light cannot unlock security barriers! Try Tolly [Key 4] for Security Clearance."
				else:
					feedback = "Petalo activated Light Beacon! Luminous aura expanded (Energy: " + ("5.0" if is_light_boosted else "1.8") + ")."

	ability_triggered.emit(self, feedback)
	print("[Petalo] ", feedback)
	return feedback
