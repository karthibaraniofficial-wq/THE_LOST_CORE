class_name Interactable
extends Area3D

## Reusable 3D Interactable Component
signal interacted(interactor: Node3D)

@export var prompt_message: String = "Interact"
@export var object_name: String = "Object"
@export var is_enabled: bool = true
@export var one_shot: bool = false

var was_interacted: bool = false

func _ready() -> void:
	collision_layer = 4 # Interaction layer
	collision_mask = 2  # Detects player interaction detector
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func get_prompt() -> String:
	return prompt_message

func interact(interactor: Node3D) -> void:
	if not is_enabled:
		return
	if one_shot and was_interacted:
		return
	
	was_interacted = true
	interacted.emit(interactor)
	_on_interact(interactor)

## Virtual method for custom subclass behaviors
func _on_interact(_interactor: Node3D) -> void:
	pass

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_interaction_detector") and is_enabled:
		InteractionManager.register_nearby(self)

func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("player_interaction_detector"):
		InteractionManager.unregister_nearby(self)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and is_enabled:
		InteractionManager.register_nearby(self)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		InteractionManager.unregister_nearby(self)
