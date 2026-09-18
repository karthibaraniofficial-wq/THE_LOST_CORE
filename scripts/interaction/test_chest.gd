class_name TestChest
extends Interactable

## Test Interactive Chest / Beacon for Phase 1 verification
@onready var chest_lid: Node3D = get_node_or_null("Lid")
@onready var glow_light: OmniLight3D = get_node_or_null("GlowLight")

var is_open: bool = false

func _ready() -> void:
	prompt_message = "Open Ancient Chest"
	object_name = "Ancient Chest"
	one_shot = true
	super._ready()

func _on_interact(_interactor: Node3D) -> void:
	if is_open:
		return
	is_open = true
	prompt_message = "Chest Opened"
	is_enabled = false
	InteractionManager.unregister_nearby(self)
	
	print("[TestChest] Player opened the Ancient Chest!")
	
	# Animate lid opening smoothly if present
	if chest_lid:
		var tween = create_tween()
		tween.tween_property(chest_lid, "rotation_degrees:x", -75.0, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Activate energy glow
	if glow_light:
		glow_light.visible = true
		var tween = create_tween()
		tween.tween_property(glow_light, "light_energy", 3.0, 0.4)
	
	# Advance mission state
	if MissionManager.current_state == MissionManager.State.MISSION_NOT_STARTED:
		MissionManager.set_state(MissionManager.State.MISSION_ACTIVE)
