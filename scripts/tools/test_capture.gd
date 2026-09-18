extends SceneTree

func _init() -> void:
	print("[CaptureTest] Starting viewport capture test...")
	var main_scene: PackedScene = load("res://scenes/world/main.tscn")
	var root_node = main_scene.instantiate()
	root.add_child(root_node)
	
	# Wait for 5 process frames to render
	for i in range(5):
		await process_frame
	
	var img: Image = root.get_viewport().get_texture().get_image()
	if img != null:
		var err = img.save_png("E:/funobotz/game/docs/snaps/test_snap.png")
		print("[CaptureTest] Image captured, size: ", img.get_size(), " save err: ", err)
	else:
		print("[CaptureTest] Error: get_image() returned null")
	quit()
