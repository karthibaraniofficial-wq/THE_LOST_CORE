class_name InteractionManagerClass
extends Node

## InteractionManager: Tracks in-range interactables and coordinates UI prompts and execution
signal active_interactable_changed(interactable: Node)
signal interaction_triggered(interactable: Node)

var active_interactable: Node = null
var nearby_interactables: Array[Node] = []

func register_nearby(interactable: Node) -> void:
	if not nearby_interactables.has(interactable):
		nearby_interactables.append(interactable)
		_update_active()

func unregister_nearby(interactable: Node) -> void:
	if nearby_interactables.has(interactable):
		nearby_interactables.erase(interactable)
		if active_interactable == interactable:
			active_interactable = null
		_update_active()

func _update_active() -> void:
	var previous = active_interactable
	if nearby_interactables.is_empty():
		active_interactable = null
	else:
		# Choose the most relevant or first available interactable
		active_interactable = nearby_interactables.back()
	
	if previous != active_interactable:
		active_interactable_changed.emit(active_interactable)

func trigger_interaction(interactor: Node3D) -> void:
	if active_interactable != null and is_instance_valid(active_interactable):
		if active_interactable.has_method("interact"):
			active_interactable.interact(interactor)
			interaction_triggered.emit(active_interactable)
