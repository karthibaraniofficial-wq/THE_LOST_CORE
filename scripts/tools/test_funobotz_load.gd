extends SceneTree

const FunobotBaseScript = preload("res://scripts/funobotz/funobot_base.gd")

func _init() -> void:
	print("--- TESTING FUNOBOTZ SCENE LOADING IN GODOT 4.7.2 ---")
	var scenes = [
		"res://scenes/funobotz/Petalo.tscn",
		"res://scenes/funobotz/Quacky.tscn",
		"res://scenes/funobotz/Tolly.tscn",
		"res://scenes/funobotz/Tiko.tscn",
		"res://scenes/world/environment/props/FunobotzHub.tscn"
	]
	
	var all_ok = true
	for sc_path in scenes:
		var packed = load(sc_path) as PackedScene
		if not packed:
			printerr("FAILED to load scene: ", sc_path)
			all_ok = false
			continue
		var inst = packed.instantiate()
		if not inst:
			printerr("FAILED to instantiate scene: ", sc_path)
			all_ok = false
			continue
		print("[PASS] Successfully instantiated: ", sc_path, " | Node Name: ", inst.name)
		if inst is FunobotBaseScript:
			print("       Robot: ", inst.robot_name, " | Role: ", inst.role_title, " | Catchphrase: ", inst.catchphrase)
			print("       Ability: ", inst.get_ability_description())
		inst.queue_free()
		
	if all_ok:
		print("--- ALL FUNOBOTZ SCENES PASSED VALIDATION ---")
	quit(0 if all_ok else 1)
