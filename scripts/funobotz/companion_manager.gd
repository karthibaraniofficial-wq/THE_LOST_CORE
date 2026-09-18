class_name CompanionManagerClass
extends Node

## CompanionManager: Global supervisor for recruited Funobotz companions and ability activation
signal companion_recruited(companion: Node3D)
signal companion_dismissed(companion: Node3D)
signal companion_ability_used(companion: Node3D, feedback_text: String)

var active_companion: Node3D = null

func _ready() -> void:
	# Ensure "use_ability" input action is bound to Key F
	if not InputMap.has_action("use_ability"):
		InputMap.add_action("use_ability")
		var ev = InputEventKey.new()
		ev.physical_keycode = KEY_F
		InputMap.action_add_event("use_ability", ev)
	print("[CompanionManager] Initialized. Ready for Funobotz recruitment.")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_ability"):
		use_active_ability()
	elif event.is_action_pressed("companion_1") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_1):
		if switch_to_companion_by_id("petalo"):
			_play_switch_sound()
	elif event.is_action_pressed("companion_2") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_2):
		if switch_to_companion_by_id("quacky"):
			_play_switch_sound()
	elif event.is_action_pressed("companion_3") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_3):
		if switch_to_companion_by_id("tiko"):
			_play_switch_sound()
	elif event.is_action_pressed("companion_4") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_4):
		if switch_to_companion_by_id("tolly"):
			_play_switch_sound()

func _play_switch_sound() -> void:
	var am = get_node_or_null("/root/AudioManager")
	if am and am.has_method("play_sfx"):
		am.play_sfx("switch", 0.05)

func switch_to_companion_by_id(id: String) -> bool:
	var robots = get_tree().get_nodes_in_group("funobotz")
	for r in robots:
		if r is FunobotBase and r.robot_id == id:
			recruit(r)
			return true
	return false

func recruit(companion: Node3D) -> void:
	if active_companion == companion:
		print("[CompanionManager] Already following: ", companion.name)
		return
		
	if active_companion != null and is_instance_valid(active_companion):
		if active_companion.has_method("dismiss_companion"):
			active_companion.dismiss_companion()
		companion_dismissed.emit(active_companion)
		
	active_companion = companion
	if active_companion.has_method("set_recruited"):
		active_companion.set_recruited(true)
		
	print("[CompanionManager] Recruited: ", active_companion.name)
	companion_recruited.emit(active_companion)

func dismiss() -> void:
	if active_companion != null and is_instance_valid(active_companion):
		var prev = active_companion
		if active_companion.has_method("set_recruited"):
			active_companion.set_recruited(false)
		active_companion = null
		companion_dismissed.emit(prev)
		print("[CompanionManager] Dismissed companion.")

func use_active_ability() -> bool:
	if active_companion == null or not is_instance_valid(active_companion):
		print("[CompanionManager] No active companion recruited.")
		return false
		
	if active_companion.has_method("activate_ability"):
		var feedback = active_companion.activate_ability()
		companion_ability_used.emit(active_companion, str(feedback))
		return true
	return false

func has_companion() -> bool:
	return active_companion != null and is_instance_valid(active_companion)

func get_companion_name() -> String:
	if has_companion() and active_companion.has_method("get_companion_name"):
		return active_companion.get_companion_name()
	return ""
