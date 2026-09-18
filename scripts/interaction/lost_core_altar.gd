class_name LostCoreAltar
extends Interactable

## LostCoreAltar: Climactic interactive altar where the player recovers the Lost Core
## Triggers energy ring rotation, light bloom surge, victory audio, and MISSION_COMPLETE

@onready var core_orb: MeshInstance3D = get_node_or_null("CoreOrb")
@onready var ring1: MeshInstance3D = get_node_or_null("EnergyRing1")
@onready var ring2: MeshInstance3D = get_node_or_null("EnergyRing2")
@onready var core_light: OmniLight3D = get_node_or_null("CorePointLight")
@onready var core_spotlight: SpotLight3D = get_node_or_null("CoreSpotlight")

var is_recovered: bool = false
var is_collected: bool:
	get: return is_recovered

func _ready() -> void:
	prompt_message = "Recover the Lost Core"
	object_name = "Lost Energy Core"
	one_shot = true
	super._ready()

func _process(delta: float) -> void:
	# Idle subtle hover/rotation of core and rings
	if not is_recovered:
		if ring1:
			ring1.rotate_y(0.8 * delta)
		if ring2:
			ring2.rotate_x(1.1 * delta)
		if core_orb:
			core_orb.position.y = 1.8 + sin(Time.get_ticks_msec() / 600.0) * 0.08
	else:
		# Rapid celestial victory spin
		if ring1:
			ring1.rotate_y(4.5 * delta)
		if ring2:
			ring2.rotate_x(5.2 * delta)

func _on_interact(_interactor: Node3D) -> void:
	if is_recovered:
		return
	is_recovered = true
	prompt_message = "Lost Core Restored!"
	is_enabled = false
	InteractionManager.unregister_nearby(self)
	
	print("[LostCoreAltar] Player recovered the Lost Core! Initiating Victory Sequence...")
	
	# 1. Audio Fanfare
	var am = get_node_or_null("/root/AudioManager")
	if am and am.has_method("play_sfx"):
		am.play_sfx("core_recover", 0.0)
		# Victory fanfare triggers via MissionManager state transition, but ensure direct play as well
		am.play_sfx("victory", 0.0)
	
	# 2. Ascend Core Orb and Expand Rings
	var tween = create_tween().set_parallel(true)
	if core_orb:
		tween.tween_property(core_orb, "position:y", 3.2, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(core_orb, "scale", Vector3(1.35, 1.35, 1.35), 1.5)
	if ring1:
		tween.tween_property(ring1, "position:y", 3.2, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(ring1, "scale", Vector3(1.5, 1.5, 1.5), 1.5)
	if ring2:
		tween.tween_property(ring2, "position:y", 3.2, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(ring2, "scale", Vector3(1.5, 1.5, 1.5), 1.5)
	if core_light:
		tween.tween_property(core_light, "light_energy", 9.0, 1.2)
		tween.tween_property(core_light, "omni_range", 32.0, 1.5)
		tween.tween_property(core_light, "position:y", 3.2, 1.5)
	if core_spotlight:
		tween.tween_property(core_spotlight, "light_energy", 14.0, 1.0)
		
	# 3. Advance MissionManager state to MISSION_COMPLETE
	var mm = get_node_or_null("/root/MissionManager")
	if mm:
		mm.set_state(MissionManagerClass.State.MISSION_COMPLETE)
