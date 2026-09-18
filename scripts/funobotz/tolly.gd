class_name Tolly
extends FunobotBase

## Tolly: Block-like Funobot specializing in Tollgate & Access
@onready var arm_node: Node3D = get_node_or_null("Model/Arm")
@onready var audio_player: AudioStreamPlayer3D = get_node_or_null("AudioStreamPlayer3D")
var is_gate_open: bool = false

func _init() -> void:
	robot_id = "tolly"
	robot_name = "TOLLY"
	role_title = "TOLLGATE & ACCESS"
	catchphrase = "I can open the way!"
	ability_description = "Operates toll barriers, unlocks checkpoints, and regulates passage through restricted gates."
	follow_offset_side = -2.0

func activate_ability() -> String:
	is_gate_open = not is_gate_open
	print("[Tolly] Operating gate mechanism: ", "OPEN" if is_gate_open else "CLOSED")
	
	if animation_player and animation_player.has_animation("ability"):
		animation_player.play("ability")
	elif arm_node:
		var tween = create_tween()
		var target_rot_z = deg_to_rad(-85.0) if is_gate_open else 0.0
		tween.tween_property(arm_node, "rotation:z", target_rot_z, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	# Check for nearby tollgate / barrier objects
	var gates = get_tree().get_nodes_in_group("toll_gates")
	var activated_gates = 0
	for g in gates:
		if g.global_position.distance_to(global_position) <= 25.0:
			if g.has_method("toggle_gate"):
				g.toggle_gate(is_gate_open)
				activated_gates += 1
			elif "is_open" in g:
				g.is_open = is_gate_open
				activated_gates += 1

	# Mission progression check: If in Ancient Vault objective, advance mission
	if activated_gates > 0 and is_gate_open:
		var mm = get_node_or_null("/root/MissionManager")
		if mm and "current_state" in mm and (mm.current_state == MissionManagerClass.State.VAULT_OBJECTIVE or mm.current_state == 5):
			mm.advance_state()

	var feedback = ""
	if activated_gates > 0:
		feedback = "Tolly activated Access Clearance! Ancient Vault Gate doors " + ("OPENED" if is_gate_open else "LOCKED") + "."
	else:
		var brambles = get_tree().get_nodes_in_group("bramble_barrier")
		var near_bramble = false
		for b in brambles:
			if b.global_position.distance_to(global_position) <= 20.0 and ("is_cleared" in b and not b.is_cleared):
				near_bramble = true
				break
		if near_bramble:
			feedback = "Tolly has no clearance code for forest plants! Try Quacky [Key 2] for Scout Run."
		else:
			var mechs = get_tree().get_nodes_in_group("heavy_mechanism")
			var near_mech = false
			for m in mechs:
				if m.global_position.distance_to(global_position) <= 20.0 and ("is_activated" in m and not m.is_activated):
					near_mech = true
					break
			if near_mech:
				feedback = "Tolly cannot shift bridge rubble! Try Tiko [Key 3] to align mechanism."
			else:
				var runes = get_tree().get_nodes_in_group("light_sensitive")
				var near_rune = false
				for r in runes:
					if r.global_position.distance_to(global_position) <= 20.0 and ("is_illuminated" in r and not r.is_illuminated):
						near_rune = true
						break
				if near_rune:
					feedback = "Tolly has no key for dormant crystal runes! Try Petalo [Key 1] for Light."
				else:
					feedback = "Tolly activated Access Clearance! Barrier " + ("OPENED" if is_gate_open else "SECURED") + "."

	ability_triggered.emit(self, feedback)
	print("[Tolly] ", feedback)
	return feedback
