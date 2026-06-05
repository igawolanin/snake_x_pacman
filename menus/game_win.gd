class_name GameWin extends CanvasLayer

@onready var quit: Button = %QuitButton


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


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
