class_name HUD
extends CanvasLayer

## HUD: Displays Mission title, Current Objective, Funobotz interaction card, and active companion

@onready var mission_title_label: Label = $SafeMargin/TopLeftPanel/VBox/MissionTitleLabel
@onready var objective_label: Label = $SafeMargin/TopLeftPanel/VBox/ObjectiveLabel
@onready var state_badge: Label = $SafeMargin/TopLeftPanel/VBox/StatusBadge

@onready var prompt_container: PanelContainer = $PromptContainer
@onready var robot_name_label: Label = $PromptContainer/VBox/RobotNameLabel
@onready var robot_role_label: Label = $PromptContainer/VBox/RobotRoleLabel
@onready var prompt_label: Label = $PromptContainer/VBox/PromptLabel

@onready var companion_panel: PanelContainer = $CompanionPanel
@onready var companion_name_label: Label = $CompanionPanel/VBox/CompanionNameLabel
@onready var companion_role_label: Label = $CompanionPanel/VBox/CompanionRoleLabel
@onready var companion_ability_label: Label = $CompanionPanel/VBox/CompanionAbilityLabel

@onready var toast_panel: PanelContainer = $ToastPanel
@onready var toast_label: Label = $ToastPanel/ToastLabel
@onready var complete_banner: PanelContainer = $CompleteBanner
@onready var title_splash: PanelContainer = get_node_or_null("TitleSplash")

var toast_tween: Tween = null
var splash_dismissed: bool = false

func _ready() -> void:
	# 1. Initialize mission display
	var mm = get_node_or_null("/root/MissionManager")
	if mm:
		_update_mission_display(
			mm.current_state,
			mm.mission_title,
			mm.get_current_objective()
		)
		mm.mission_state_changed.connect(_on_mission_state_changed)
	
	# 2. Connect interaction manager
	var im = get_node_or_null("/root/InteractionManager")
	if im:
		im.active_interactable_changed.connect(_on_active_interactable_changed)
		
	# 3. Connect companion manager
	var cm = get_node_or_null("/root/CompanionManager")
	if cm:
		cm.companion_recruited.connect(_on_companion_recruited)
		cm.companion_dismissed.connect(_on_companion_dismissed)
		cm.companion_ability_used.connect(_on_companion_ability_used)
		if cm.active_companion:
			_on_companion_recruited(cm.active_companion)
	
	# Initial prompt states
	prompt_container.visible = false
	companion_panel.visible = false
	toast_panel.visible = false
	complete_banner.visible = false
	
	if title_splash:
		title_splash.visible = true
		title_splash.modulate.a = 1.0

func _unhandled_input(event: InputEvent) -> void:
	if not splash_dismissed and title_splash and title_splash.visible:
		if event is InputEventKey and event.pressed:
			dismiss_title_splash()
		elif event is InputEventMouseButton and event.pressed:
			dismiss_title_splash()

func dismiss_title_splash() -> void:
	if splash_dismissed:
		return
	splash_dismissed = true
	if title_splash:
		var tween = create_tween()
		tween.tween_property(title_splash, "modulate:a", 0.0, 0.6)
		tween.tween_callback(func(): title_splash.visible = false)

func _on_mission_state_changed(_old: int, new_state: int, title: String, objective: String) -> void:
	_update_mission_display(new_state, title, objective)

func _update_mission_display(state: int, title: String, objective: String) -> void:
	mission_title_label.text = "MISSION: " + title.to_upper()
	objective_label.text = "OBJECTIVE: " + objective
	
	var mm = get_node_or_null("/root/MissionManager")
	if mm and mm.has_method("get_state_name"):
		state_badge.text = "[" + mm.get_state_name(state) + "]"
	
	if state == MissionManagerClass.State.MISSION_COMPLETE or state == 7:
		complete_banner.visible = true
		var tween = create_tween()
		complete_banner.modulate.a = 0.0
		tween.tween_property(complete_banner, "modulate:a", 1.0, 0.5)

func _on_active_interactable_changed(interactable: Node) -> void:
	if interactable and is_instance_valid(interactable):
		# Check if this interactable is a Funobot companion
		if "robot_name" in interactable and "role_title" in interactable:
			robot_name_label.text = str(interactable.robot_name).to_upper()
			robot_role_label.text = str(interactable.role_title).capitalize()
			robot_name_label.visible = true
			robot_role_label.visible = true
			
			if "is_recruited" in interactable and interactable.is_recruited:
				prompt_label.text = "Press [E] to talk  |  [F] Use Ability"
			else:
				prompt_label.text = "Press [E] to interact"
		else:
			robot_name_label.visible = false
			robot_role_label.visible = false
			var prompt_text = interactable.get_prompt() if interactable.has_method("get_prompt") else "Interact"
			prompt_label.text = "[E]  " + prompt_text
			
		prompt_container.visible = true
	else:
		prompt_container.visible = false

func _on_companion_recruited(companion: Node3D) -> void:
	if not companion or not is_instance_valid(companion):
		return
	companion_panel.visible = true
	var c_name = companion.get_companion_name() if companion.has_method("get_companion_name") else companion.name
	var c_role = companion.get_role_title() if companion.has_method("get_role_title") else "Companion"
	var c_ability = companion.get_ability_description() if companion.has_method("get_ability_description") else "Active Ability"
	
	companion_name_label.text = c_name.to_upper()
	companion_role_label.text = c_role.capitalize()
	companion_ability_label.text = "[F] " + c_ability + "\n[1] Petalo  [2] Quacky  [3] Tolly  [4] Tiko"
	
	show_toast(c_name.to_upper() + " active! Role: " + c_role.capitalize() + " ([F] Ability | [1-4] Switch)")

func _on_companion_dismissed(_companion: Node3D) -> void:
	companion_panel.visible = false

func _on_companion_ability_used(_companion: Node3D, feedback_text: String) -> void:
	show_toast(feedback_text)

func show_toast(text: String) -> void:
	toast_label.text = text
	toast_panel.visible = true
	toast_panel.modulate.a = 1.0
	
	if toast_tween and toast_tween.is_valid():
		toast_tween.kill()
		
	toast_tween = create_tween()
	toast_tween.tween_interval(3.2)
	toast_tween.tween_property(toast_panel, "modulate:a", 0.0, 0.5)
	toast_tween.tween_callback(func(): toast_panel.visible = false)
