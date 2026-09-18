class_name Tiko
extends FunobotBase

## Tiko: Segmented truss Funobot specializing in Object Manipulation
@onready var arm_node: Node3D = get_node_or_null("Model/TrussArm")
@onready var audio_player: AudioStreamPlayer3D = get_node_or_null("AudioStreamPlayer3D")
var is_extended: bool = false

func _init() -> void:
	robot_id = "tiko"
	robot_name = "TIKO"
	role_title = "OBJECT MANIPULATION"
	catchphrase = "I can move things!"
	ability_description = "Extends cantilevered mechanical arm to push obstacles, manipulate bridge spans, and toggle heavy machinery."
	follow_offset_side = 2.0

func activate_ability() -> String:
	is_extended = not is_extended
	print("[Tiko] Executing object manipulation: ", "EXTEND" if is_extended else "RETRACT")
	
	if animation_player and animation_player.has_animation("ability"):
		animation_player.play("ability")
	elif arm_node:
		var tween = create_tween()
		var target_scale_z = 1.6 if is_extended else 1.0
		var target_rot_x = deg_to_rad(-25.0) if is_extended else 0.0
		tween.tween_property(arm_node, "scale:z", target_scale_z, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(arm_node, "rotation:x", target_rot_x, 0.4)
		
	# Check for nearby mechanical objects, bridge mechanisms, or levers
	var mechanisms = get_tree().get_nodes_in_group("heavy_mechanism")
	var manipulated_count = 0
	for m in mechanisms:
		if m.global_position.distance_to(global_position) <= 25.0:
			if m.has_method("activate_mechanism"):
				m.activate_mechanism()
				manipulated_count += 1
				
	# Mission progression check: If in Rainbow Bridge objective, advance mission
	var mm = get_node_or_null("/root/MissionManager")
	if mm and "current_state" in mm and mm.current_state == 3: # BRIDGE_OBJECTIVE
		mm.advance_state()
		
	var feedback = ""
	if manipulated_count > 0:
		feedback = "Tiko engaged mechanical arm! Bridge levers shifted and structural alignment locked."
	else:
		var brambles = get_tree().get_nodes_in_group("bramble_barrier")
		var near_bramble = false
		for b in brambles:
			if b.global_position.distance_to(global_position) <= 20.0 and ("is_cleared" in b and not b.is_cleared):
				near_bramble = true
				break
		if near_bramble:
			feedback = "Tiko's heavy arm cannot clear flexible vines! Try Quacky [Key 2] for Scout Run."
		else:
			var runes = get_tree().get_nodes_in_group("light_sensitive")
			var near_rune = false
			for r in runes:
				if r.global_position.distance_to(global_position) <= 20.0 and ("is_illuminated" in r and not r.is_illuminated):
					near_rune = true
					break
			if near_rune:
				feedback = "Physical force cannot activate photosensitive crystals! Try Petalo [Key 1] for Light."
			else:
				var gates = get_tree().get_nodes_in_group("toll_gates")
				var near_gate = false
				for g in gates:
					if g.global_position.distance_to(global_position) <= 20.0 and ("is_unlocked" in g and not g.is_unlocked):
						near_gate = true
						break
				if near_gate:
					feedback = "Physical force cannot bypass security clearance! Try Tolly [Key 4] for Security Clearance."
				else:
					feedback = "Tiko engaged mechanical arm! Physical levers shifted and structural alignment locked."

	ability_triggered.emit(self, feedback)
	print("[Tiko] ", feedback)
	return feedback
