class_name GameWin extends CanvasLayer


func _on_quit_button_pressed() -> void:
	get_tree().call_deferred(
			"change_scene_to_file",
			"res://menus/start.tscn"
		)
	
func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false
