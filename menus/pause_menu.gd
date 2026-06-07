class_name PauseMenu extends CanvasLayer

@onready var resume_button: Button = %PlayButton
@onready var exit_button: Button = %QuitButton2


func _on_resume_button_pressed() -> void:
	queue_free()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		queue_free()


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false


func _on_quit_button_pressed() -> void:
	pass # Replace with function body.
