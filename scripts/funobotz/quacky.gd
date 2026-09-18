class_name Quacky
extends FunobotBase

## Quacky: Duck-like Funobot specializing in Movement & Delivery
@onready var audio_player: AudioStreamPlayer3D = get_node_or_null("AudioStreamPlayer3D")
var is_scouting: bool = false

func _init() -> void:
	robot_id = "quacky"
	robot_name = "QUACKY"
	role_title = "MOVEMENT & DELIVERY"
	catchphrase = "I will scout ahead!"
	ability_description = "Dashes forward on reconnaissance, discovers hidden paths, and dissolves forest bramble barriers."
	follow_offset_side = 1.6

func activate_ability() -> String:
	if is_scouting:
		return "Quacky is already scouting ahead!"
		
	is_scouting = true
	print("[Quacky] Launching scouting maneuver...")
	
	if animation_player and animation_player.has_animation("ability"):
		animation_player.play("ability")
		
	# Quick forward dash sprint (reconnaissance)
	var forward_dir = -global_transform.basis.z
	var scout_target = global_position + (forward_dir * 6.0)
	var start_pos = global_position
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", scout_target, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.4)
	tween.tween_property(self, "global_position", start_pos, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.finished.connect(func(): is_scouting = false)
	
	# Check for nearby bramble obstacles to clear
	var barriers = get_tree().get_nodes_in_group("bramble_barrier")
	var cleared = false
	for b in barriers:
		if b.global_position.distance_to(global_position) <= 25.0:
			if b.has_method("clear_barrier"):
				b.clear_barrier()
				cleared = true
			elif "visible" in b:
				b.visible = false
				cleared = true
				
	# Mission progression check: If in Hidden Forest objective, advance mission
	var mm = get_node_or_null("/root/MissionManager")
	if mm and "current_state" in mm and mm.current_state == 2: # FOREST_OBJECTIVE
		mm.advance_state()
		
	var feedback = ""
	if cleared:
		feedback = "Quacky executed Scout Run! Path recon completed and bramble barrier dissolved."
	else:
		var mechs = get_tree().get_nodes_in_group("heavy_mechanism")
		var near_mech = false
		for m in mechs:
			if m.global_position.distance_to(global_position) <= 20.0 and ("is_activated" in m and not m.is_activated):
				near_mech = true
				break
		if near_mech:
			feedback = "Quacky's light frame cannot shift heavy bridge stone! Try Tiko [Key 3] to align mechanism."
		else:
			var runes = get_tree().get_nodes_in_group("light_sensitive")
			var near_rune = false
			for r in runes:
				if r.global_position.distance_to(global_position) <= 20.0 and ("is_illuminated" in r and not r.is_illuminated):
					near_rune = true
					break
			if near_rune:
				feedback = "Scouting cannot activate photosensitive crystals! Try Petalo [Key 1] to illuminate cavern."
			else:
				var gates = get_tree().get_nodes_in_group("toll_gates")
				var near_gate = false
				for g in gates:
					if g.global_position.distance_to(global_position) <= 20.0 and ("is_unlocked" in g and not g.is_unlocked):
						near_gate = true
						break
				if near_gate:
					feedback = "Scouting cannot bypass ancient vault locks! Try Tolly [Key 4] for Security Clearance."
				else:
					feedback = "Quacky executed Scout Run! Path recon completed."

	ability_triggered.emit(self, feedback)
	print("[Quacky] ", feedback)
	return feedback
