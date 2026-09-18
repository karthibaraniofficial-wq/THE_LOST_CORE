class_name MissionManagerClass
extends Node

## MissionManager: Central authoritative state machine for mission tracking
signal mission_state_changed(old_state: int, new_state: int, title: String, objective: String)

enum State {
	MISSION_NOT_STARTED = 0,
	MISSION_ACTIVE = 1,
	FOREST_OBJECTIVE = 2,
	BRIDGE_OBJECTIVE = 3,
	CAVE_OBJECTIVE = 4,
	VAULT_OBJECTIVE = 5,
	CORE_OBJECTIVE = 6,
	MISSION_COMPLETE = 7
}

const CORE_RECOVERED: State = State.CORE_OBJECTIVE
const BEACON_REACHED: State = State.MISSION_ACTIVE

var current_state: State = State.MISSION_NOT_STARTED
var mission_title: String = "Recover the Lost Core"

const OBJECTIVES: Dictionary = {
	State.MISSION_NOT_STARTED: "Investigate the Grand Gateway Beacon.",
	State.MISSION_ACTIVE: "Explore the Grand Gateway and recruit a Funobot companion.",
	State.FOREST_OBJECTIVE: "Use Quacky [Key 2] to scout and dissolve the bramble barrier.",
	State.BRIDGE_OBJECTIVE: "Use Tiko [Key 3] to align the Rainbow Bridge mechanism and clear rubble.",
	State.CAVE_OBJECTIVE: "Illuminate the dark cavern with Petalo's [Key 1] light beacon.",
	State.VAULT_OBJECTIVE: "Use Tolly [Key 4] to override the ancient vault security gate.",
	State.CORE_OBJECTIVE: "Approach the ceremonial altar and recover the Lost Core.",
	State.MISSION_COMPLETE: "Mission Accomplished! The Discovery World is saved!"
}

func _ready() -> void:
	print("[MissionManager] Initialized. Current State: ", get_state_name(current_state))

func get_current_objective() -> String:
	return OBJECTIVES.get(current_state, "Explore the world.")

func get_state_name(state: int) -> String:
	match state:
		State.MISSION_NOT_STARTED: return "MISSION_NOT_STARTED"
		State.MISSION_ACTIVE: return "MISSION_ACTIVE"
		State.FOREST_OBJECTIVE: return "FOREST_OBJECTIVE"
		State.BRIDGE_OBJECTIVE: return "BRIDGE_OBJECTIVE"
		State.CAVE_OBJECTIVE: return "CAVE_OBJECTIVE"
		State.VAULT_OBJECTIVE: return "VAULT_OBJECTIVE"
		State.CORE_OBJECTIVE: return "CORE_OBJECTIVE"
		State.MISSION_COMPLETE: return "MISSION_COMPLETE"
		_: return "UNKNOWN"

func advance_state() -> void:
	if current_state < State.MISSION_COMPLETE:
		set_state(current_state + 1)

func set_state(new_state: int) -> void:
	if new_state == current_state:
		return
	var old = current_state
	current_state = new_state as State
	print("[MissionManager] State changed: ", get_state_name(old), " -> ", get_state_name(current_state))
	mission_state_changed.emit(old, current_state, mission_title, get_current_objective())
